with Motor_Sim, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO, System;    
use Motor_Sim, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO, System;

procedure Speed_Motor with
   Priority => System.Default_Priority is


   protected Edges is
      procedure Add;
      procedure Count_And_Reset(Count: out Natural);
   private
      Nr_Of_Edges : Natural := 0;
   end Edges;

   protected body Edges is
      procedure Add is
      begin
         Nr_Of_Edges := Nr_Of_Edges + 1;
      end Add;
      procedure Count_And_Reset(Count: out Natural) is
      begin
         Count := Nr_Of_Edges;
         Nr_Of_Edges := 0;
      end Count_And_Reset;
   end Edges;

   task Sampler is
      entry Start;
      entry Stop;
   end Sampler;

   task body Sampler is 
      Pulse_Value : Boolean := False;
      Pulse_Value_Aux : Boolean := False;
      Period : Time_Span := Microseconds(3000);
      Next : Time;
   begin
      loop
      select
         accept Start;
            Next := Clock;
            Next := Next + Period;
      or
         accept Stop;
            exit;
      end select;
      Pulse_Value_Aux := Motor_Sim.Motor_Pulse;
      if (Pulse_Value /= Pulse_Value_Aux) then
         Pulse_Value := Pulse_Value_Aux;
         Edges.Add;
      end if;
      Next := Next + Period;
      delay until Next;
      end loop;
   end Sampler;

   task Speedometer is
      entry Start;
      entry Finish;
   end Speedometer;

   task body Speedometer is
      type Velocity is delta 0.1 digits 4;
      Speed : Velocity;
      Count : Natural := 0;
      Period : Time_Span := Microseconds(1500000);
      Next : Time;
   begin
      loop
      select
         accept Start;
            Next := Clock;
            Next := Next + Period;
      or 
         accept Finish;
            exit;
      end select;
      Edges.Count_And_Reset(Count);
      Speed := Velocity'Value(Integer'Image(Count * 5));
      Put_Line("Velocity: "&Velocity'Image(Speed));
      Next := Next + Period;
      delay until Next;
      end loop;

   end Speedometer;

begin
   Put_Line ("Starting motor simulation");
   Put_Line ("Max speed =" & Integer'Image (Max_Speed) & " RPM");
   Start_Simulation;

   Put_Line ("Speedometer");
   Put_Line ("-----------");
   Put_Line ("Motor stopped for 6 seconds");
   Sampler.Start;
   Speedometer.Start;
   delay 6.0;

   Put_Line ("Starting motor for 12 seconds at half speed");
   Set_Speed (Half);
   Motor_On;
   delay 12.0;

   Put_Line ("Starting motor for 12 seconds at full speed");
   Set_Speed (Full);
   delay 12.0;

   Put_Line ("Stopping motor. Waiting 6 more seconds");
   Motor_Off;
   delay 6.0;

   Put_Line ("Ending speedometer");
   Speedometer.Finish;
   Sampler.Stop;
   Put_Line ("Ending motor simulation");
   End_Simulation;
   Put_Line ("End of main task");
exception
   when others =>
      Put_Line ("Exception caught in main");
end Speed_Motor;