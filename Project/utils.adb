pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Digital_IO_Sim;  use Digital_IO_Sim;
with Ada.Real_Time;   use Ada.Real_Time;
with Robot_Monitor;   use Robot_Monitor;
with Queue; 

package body Utils is

   package Int_Queue is new Queue(Position);
   use Int_Queue;
   Saved_Positions : Queue_Type;

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
      Avail : Boolean;
      Period : constant Time_Span := Milliseconds(5); -- (1/((300*8)/60))/3
      Next : Time; 
      Command : Command_Type := Stop_All;
      begin
         Next := Clock;
         Command(A) := M;
         Move_Robot(Command);

         if M = To_Init then -- We stop before reaching zero
            while Robot_Mon.Get_Pos(A) > Init_Axis loop
               --Stop when same key pressed
               Get_Immediate(Item => Input, Available => Avail);
               exit when Input = C;
               Next := Next + Period;
               delay until Next;      
            end loop;
         elsif M = To_End then -- we might be starting in zero
            while Robot_Mon.Get_Pos(A) < Simul_Limits(A) loop
               --Stop when same key pressed
               Get_Immediate(Item => Input, Available => Avail);
               exit when Input = C;
               Next := Next + Period;
               delay until Next;      
            end loop;
         end if;
      
         Command := Stop_All;
         Move_Robot(Command);
end Move_Within_Limits;


procedure Move_With_Keys (C : in Character) is
 
   begin
      --Put_Line(Character'Image(C));
      case C is
         when 'q' => -- rotate to init
            Move_Within_Limits(Rotation, To_Init, C);
         when 'a' => -- rotate to end
            Move_Within_Limits(Rotation, To_End, C);
         when 'w' => -- Forward to init
            Move_Within_Limits(Forward, To_Init, C);
         when 's' => -- Forward to end
            Move_Within_Limits(Forward, To_End, C);
         when 'e' => -- Height to init
            Move_Within_Limits(Height, To_Init, C);
         when 'd' => -- Height to end
            Move_Within_Limits(Height, To_End, C);
         when 'r' => -- Clamp to init
            Move_Within_Limits(Clamp, To_Init, C);
         when 'f' => -- Clamp to end
            Move_Within_Limits(Clamp, To_End, C);
         when 'm' => -- Position to memory
            Put_Line("Saving position to memory");
            Push(Saved_Positions, Robot_Mon.Get_Pos);
            Put_Line("Saved!");
         when 'p' => -- Repeat from memory
            Repeat_From_Memory;
         when others =>
            return;
      end case;

end Move_With_Keys;

procedure Repeat_From_Memory is
   Next_Position : Position;
   Count : Natural := 1;
   begin
   --Robot_Mon.Reset;
   while not Is_Empty(Saved_Positions) loop
      Pop(Saved_Positions, Next_Position);
      Put_Line("Going to saved position:"&Natural'Image(Count));      
      Move_Robot_To(Next_Position);
      Put_Line("I'm at position:"&Natural'Image(Count) &" and will wait 3 seconds");
      Count := Count + 1;
      delay 3.0;
      --Put_Line(Position'Image(Val));
   end loop;
   Put_Line("I've done all the movements I know!");

end Repeat_From_Memory;

end Utils;