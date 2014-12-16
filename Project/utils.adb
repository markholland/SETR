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



end Utils;