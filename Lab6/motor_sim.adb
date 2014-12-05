with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Exceptions; use Ada.Exceptions;
with Ada.Real_Time;  use Ada.Real_Time;
with System;

package body Motor_Sim is

   task Simulator is
      --with Priority => System.Priority'Last-1 is
      entry Start_Simulation;
      entry End_Simulation;
      entry Motor_On;
      entry Motor_Off;
      entry Set_Speed (S : in Speed_Mode);
      entry Pulse (P: out Boolean);
   end Simulator;

   task body Simulator is
      Pulse_Value : Boolean := False;
      Running : Boolean := False;
      -- One turn of the motor produces 8 pulse edges, so the
      -- simulation period = 1000 / ((Max_Speed * 8) / 60) ms
      Period_Full_Speed : constant Time_Span := Microseconds (60_000_000 / ((Max_Speed * 8)));
      Period_Half_Speed : constant Time_Span := 2 * Period_Full_Speed;
      Simulator_Period : Time_Span := Period_Full_Speed;
      Next : Time;
   begin
      accept Start_Simulation;
      loop
         select
            accept Set_Speed (S: in Speed_Mode) do
               case S is
                  when Full => Simulator_Period := Period_Full_Speed;
                  when Half => Simulator_Period := Period_Half_Speed;
               end case;
            end Set_Speed;
         or
            accept Motor_On  do
               if not Running then
                  Next := Clock + Simulator_Period;
                  Running := True;
               end if;
            end Motor_On;
         or
            accept Motor_Off  do
               Running := False;
            end Motor_Off;
         or
            when Running =>
               delay until Next;
               Pulse_Value := not Pulse_Value;
               Next := Next + Simulator_Period;
         or
            accept Pulse (P : out Boolean) do
               P := Pulse_Value;
            end Pulse;
         or
            accept End_Simulation;
            exit;
         end select;
      end loop;
   exception
      when Exc: others =>
         Put("Simulator died due to ");
         Put_Line(Exception_Name(Exc) & Exception_Message(Exc));
   end Simulator;


   --------------
   -- Motor_On --
   --------------

   procedure Motor_On is
   begin
      Simulator.Motor_On;
   end Motor_On;

   ---------------
   -- Motor_Off --
   ---------------

   procedure Motor_Off is
   begin
      Simulator.Motor_Off;
   end Motor_Off;

   ---------------
   -- Set_Speed --
   ---------------

   procedure Set_Speed (S: in Speed_Mode) is
   begin
      Simulator.Set_Speed (S);
   end Set_Speed;


   -----------------
   -- Motor_Pulse --
   -----------------

   function Motor_Pulse return Boolean is
      Value : Boolean;
   begin
      Simulator.Pulse(Value);
      return Value;
   end Motor_Pulse;

   ----------------------
   -- Start_Simulation --
   ----------------------

   procedure Start_Simulation is
   begin
      Simulator.Start_Simulation;
   end Start_Simulation;

   --------------------
   -- End_Simulation --
   --------------------

   procedure End_Simulation is
   begin
      Simulator.End_Simulation;
   end End_Simulation;

end Motor_Sim;
