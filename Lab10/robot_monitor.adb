pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Digital_IO_Sim;  use Digital_IO_Sim;
with Ada.Real_Time;   use Ada.Real_Time;

package body Robot_Monitor is

   protected body Robot_Mon is

      function Get_Pos return Position is
      begin
         return Pos;
      end Get_Pos;

      procedure Reset is
         Status : Status_Type;
         Command : Command_Type;
      begin
         Put_Line("Moving axes to initial position...");

         --move all to init
         Move_Robot(Init_all);
         -- loop checking if at init
         loop
            -- get state
            Status := Robot_State;
            Command := Last_Robot_Command;
            
            --Put_Line("Checking switches...");
            --Put_Line("Rotation: "&Init_Switch_Type'Image(Status(Rotation).Init_Switch));
            --Put_Line("Forward: "&Init_Switch_Type'Image(Status(Forward).Init_Switch));
            --Put_Line("Height: "&Init_Switch_Type'Image(Status(Height).Init_Switch));
            --Put_Line("Clamp: "&Init_Switch_Type'Image(Status(Clamp).Init_Switch));

            -- check init switches
            -- stop a motor if necessary
            if Status(Rotation).Init_Switch = pressed then
               -- Put_Line("Rotation at init...");
               Command(Rotation) := Stop;
               Move_Robot(Command);
            end if;
            if Status(Forward).Init_Switch = pressed then
               -- Put_Line("Forward at init...");
               Command(Forward) := Stop;
               Move_Robot(Command);
            end if;
            if Status(Height).Init_Switch = pressed then
               -- Put_Line("Height at init...");
               Command(Height) := Stop;
               Move_Robot(Command);
            end if;
            if Status(Clamp).Init_Switch = pressed then
               -- Put_Line("Clamp at init...");
               Command(Clamp) := Stop;
               Move_Robot(Command);
            end if;

            -- all motors at init   
            exit when Status(Rotation).Init_Switch = pressed 
                      and
                      Status(Forward).Init_Switch = pressed
                      and
                      Status(Height).Init_Switch = pressed
                      and
                      Status(Clamp).Init_Switch = pressed;

         end loop;
         -- end loop

         --end All_To_Init;
         Set_Pos((0, 0, 0, 0));
         Put_Line("Robot is now at initial position.");
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
      Status_Actual : Status_Type := Robot_State;
      Status_Anterior : Status_Type := Robot_State;
      Pos_Aux : Position :=(200,200,200,40);
      Sampler_Period : Time_Span := Microseconds(10); -- 1/((300*4)/60)
      Next : Time; 
   begin
      Next := Clock;  
      Robot_Mon.Set_Pos(Pos_Aux);

      loop
         Status_Anterior := Status_Actual;
         Status_Actual := Robot_State;
         Pos_Aux := Robot_Mon.Get_Pos;
         for Ax in Axis_Type'Range loop
           
            if Status_Actual(Ax).Pulse_Switch /= Status_Anterior(Ax).Pulse_Switch then         
               if Last_Robot_Command(Ax) = To_Init then
                  Pos_Aux(Ax) := Pos_Aux(Ax) - 1;             
               elsif Last_Robot_Command(Ax) = To_End then 
                  Pos_Aux(Ax) := Pos_Aux(Ax) + 1;          
               end if;
               Robot_Mon.Set_Pos(Pos_Aux); 
            end if;
         end loop;
         
         Next := Next + Sampler_Period;
         delay until Next;

      end loop;
   end Robot_Sampler;

   task body Positioner is 
      Target_Pos : Position;
      Actual_Pos : Position := Robot_Mon.Get_Pos;
      Period : Time_Span := Milliseconds(3); -- (1/((300*4)/60))/3
      Next : Time; 
      Command : Command_Type;
   begin
      loop
         Accept Move_Robot_To (P : in Position) do 
            Target_Pos := P;
            Next := Clock;
            while Actual_Pos /= Target_Pos loop
               
               for Ax in Axis_Type'Range loop
                  if Robot_Mon.Get_Pos(Ax) < Target_Pos(Ax) then
                     Command(Ax) := To_End;
                  end if;
                  if Robot_Mon.Get_Pos(Ax) > Target_Pos(Ax) then
                     Command(Ax) := To_Init;
                  end if;
                  if Robot_Mon.Get_Pos(Ax) = Target_Pos(Ax) then
                     Command(Ax) := Stop;
                  end if;         
               end loop; -- end for
               Move_Robot(Command);
               Next := Next + Period;
               delay until Next;
               Actual_Pos := Robot_Mon.Get_Pos;
              
            end loop;
            -- Stop all
            Command := Stop_All;
            Move_Robot(Command);
         end Move_Robot_To;
      end loop;
   end Positioner;

end Robot_Monitor;
