pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Digital_Io;  use Digital_Io;
with Ada.Real_Time;   use Ada.Real_Time;
with Ada.Text_IO;  use Ada.Text_IO; 	
package body Robot_Monitor is

   protected body Robot_Mon is

      function Get_Pos return Position is
      begin
         return Pos;
      end Get_Pos;

      procedure Reset is

         Command : Command_Type := Init_All;
         Status_Robot : Status_Type := Robot_State;

      begin
         Put_Line("Moving axis to initial position...");
         Move_Robot(Command);
         while(Last_Robot_Command /= Stop_All) loop
            Command := Last_Robot_Command;
            Status_Robot := Robot_State;
            for Ax in Axis_Type'Range loop
               if Status_Robot(Ax).Init_Switch = pressed then --and Command(Ax) /= Stop then
                  Command(Ax) := Stop;
               end if;
            end loop;
            Move_Robot(Command);
         end loop;
         --Move_Robot (Stop_All);
         Set_Pos((0,0,0,0));
         Put_Line("Robot is now at the initial position.");

      end Reset;

      procedure Set_Pos (P : in Position) is
      begin
         Pos := P;
      end Set_Pos;

      procedure Print_Pos (P : in Position) is
      begin
         Put ("Rotation, Forward, Height, Clamp = ");
         for Axis in Axis_Type'Range loop
            Put (Natural'Image(P(Axis)));
         end loop;
      end Print_Pos;

   end Robot_Mon;

   task Robot_Sampler is
      pragma Priority (System.Priority'Last - 1);
   end Robot_Sampler;

   task Positioner is
      pragma Priority (System.Priority'Last - 2);
      entry Move_Robot_To (P : in Position);
   end Positioner;

   procedure Move_Robot_To (P : in Position) is
   begin
      Positioner.Move_Robot_To (P);
   end Move_Robot_To;

   task body Robot_Sampler is
      Max_Speed : constant := 300;     -- Max Speed in RPM
      Period : constant Time_Span := Milliseconds(5);--(60000/((Max_Speed * 8)))/5); --10 ms
      Next : Time;
      Status_Robot : Status_Type := Robot_State;
      Status_Robot_Ant : Status_Type := Robot_State;
      --Command : Command_Type := Last_Robot_Command;
      Pos_Aux : Position;
   begin
      Next := Clock;
      --Robot_Mon.Set_Pos(Pos_Aux);
      loop
         --Put_Line(Natural'Image(Robot_Mon.Get_Pos(Clamp)));
         --Put_Line("Entra en loop infinito");
         Pos_Aux := Robot_Mon.Get_Pos;
         Status_Robot_Ant := Status_Robot;
         Status_Robot := Robot_State;
         for Ax in Axis_Type'Range loop
            --Put_Line("Entra en for");
            if Status_Robot(Ax).Pulse_Switch /= Status_Robot_Ant(Ax).Pulse_Switch then
               if Last_Robot_Command(Ax) = To_Init then
                 Pos_Aux(Ax) := Pos_Aux(Ax)-1;
               elsif Last_Robot_Command(Ax) = To_End then
                  Pos_Aux(Ax) := Pos_Aux(Ax)+1;
               end if;
            end if;
         end loop;
          Robot_Mon.Set_Pos(Pos_Aux);
         Next := Next + Period;
         delay until Next;
     end loop;
   end Robot_Sampler;


   task body Positioner is
      Max_Speed : constant := 300;     -- Max Speed in RPM
      Period : constant Time_Span := Milliseconds(8); --(1/((Max_Speed * 8)/60))/3)
      Next : Time;
      Command : Command_Type;
      Target_Pos : Position;
      --Pos_Aux : Position;
   begin

      loop
         --Put_Line("Entra en loop infinito");
         accept Move_Robot_To (P : in Position) do
            Next := Clock;
            --Put_Line("Entra en accept");
            Target_Pos := P;--Put_Line("Entra en loop infinito");
            end Move_Robot_To;
            --Pos_Aux := Robot_Mon.Get_Pos;
            while Robot_Mon.Get_Pos /= Target_Pos loop
               --Put_Line("Entra en while");
               --Pos_Aux := Robot_Mon.Get_Pos;
               for Ax in Axis_Type'Range loop
                  --Put_Line("Entra en for");
                  if Target_Pos(Ax) > Robot_Mon.Get_Pos(Ax) then
                     Command(ax) := To_End;
                  elsif Target_Pos(Ax) < Robot_Mon.Get_Pos(Ax) then
                     Command(Ax) := To_Init;
                  elsif Target_Pos(Ax) = Robot_Mon.Get_Pos(Ax) then
                     --Put_Line("Para el eje!!");
                     Command(Ax) := Stop;
                     --Put_Line("Eje parado");
                  end if;
               end loop;
               Move_Robot(Command);
               Next := Next + Period;
               delay until Next;
            end loop;
            Move_Robot(Stop_All);


      end loop;

   end Positioner;

end Robot_Monitor;
