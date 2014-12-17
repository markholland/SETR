pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Digital_IO_Sim;  use Digital_IO_Sim;
with Ada.Real_Time;   use Ada.Real_Time;
with Robot_Monitor;   use Robot_Monitor;

package body Utils is


procedure Move_By_One (A : in Axis_Type; M : in Motion_Type) is
      pos1 : Position := Robot_Mon.Get_Pos;
      pos2 : Position;
      command : Command_Type := Stop_All;
      begin
         command(A) := M;
         Move_Robot(command);
         loop
            pos2 := Robot_Mon.Get_Pos;
            if M = To_End then
            	exit when pos2(A) >= pos1(A) + 1;
            elsif M = To_Init then
            	exit when pos2(A) <= pos1(A) - 1;
            else
            	exit;
            end if;
         end loop;
         Move_Robot(Stop_All);
         
end Move_By_One;

procedure Move_Within_Limits(A : in Axis_Type;
                             M : in Motion_Type; 
                             C : in Character) is

      Input : Character;
      Period : constant Time_Span := Milliseconds(17); -- (1/((300*4)/60))/3
      Next : Time; 
      Command : Command_Type := Stop_All;
      begin
   
         Next := Clock;
         Command(A) := M;
         Move_Robot(Command)
         if A := Clamp then -- Clamp axis has different limit

            while Robot_Mon.Get_Pos(A) <= End_Clamp loop
               --Stop when same key pressed
               Get(Item => Input);
               exit when Input = C;

               Next := Next + Period;
               delay until Next;      
            end loop;
            Command := Stop_All;
            Move_Robot(Command);

         else -- Rest of axis share same limit

            while Robot_Mon.Get_Pos(A) <= End_Axis loop
               --Stop when same key pressed
               Get(Item => Input);
               exit when Input = C;

               Next := Next + Period;
               delay until Next;      
            end loop
            Command := Stop_All;
            Move_Robot(Command);     

         end if;             
              
end Move_Within_Limits;


procedure Move_With_Keys (C : in Character) is

   begin
      case C is
         when Q => -- rotate to init
            Move_Within_Limits(Rotation, To_Init, C);
         when A => -- rotate to end
            Move_Within_Limits(Rotation, To_End, C);
         when W => -- Forward to init
            Move_Within_Limits(Forward, To_Init, C);
         when S => -- Forward to end
            Move_Within_Limits(Forward, To_End, C);
         when E => -- Height to init
            Move_Within_Limits(Height, To_Init, C);
         when D => -- Height to end
            Move_Within_Limits(Height, To_End, C);
         when R => -- Clamp to init
            Move_Within_Limits(Clamp, To_Init, C);
         when F => -- Clamp to end
            Move_Within_Limits(Clamp, To_End, C);
      end case;

end Move_With_Keys;

end Utils;