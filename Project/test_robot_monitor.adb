with Robot_Monitor;   use Robot_Monitor;
with Robot_Interface; use Robot_Interface;
with Digital_IO_Sim;  use Digital_IO_Sim;

with Ada.Integer_Text_IO;

procedure Test_Robot_Monitor is
   Target_Pos : array (1 .. 4) of Position :=
     (1 => (100, 100, 100, 10),
      2 => (5, 50, 200, 20),
      3 => (300, 300, 300, 30),
      4 => (111,222,333,0));
   Temp : Natural;
begin

  Put_Line("Test_Robot_Monitor starts...");
   Robot_Mon.Reset;
   delay 3.0;

   for I in Target_Pos'Range loop
      Put_Line ("Searching position:");
      Robot_Mon.Print_Pos (Target_Pos (I));
      New_Line;
      Move_Robot_To (Target_Pos (I));
      while Target_Pos (I) /= Robot_Mon.Get_Pos loop
         delay 0.5;
      end loop;
      Put_Line ("Position reached:");
      Robot_Mon.Print_Pos (Robot_Mon.Get_Pos);
      New_Line;
      if I < 4 then
         delay 3.0; -- Pause between targets
      end if;
   end loop;

   Put_Line ("Input a destination position to take the robot to:");
   Put_Line("Rotation: ");  Get(Temp); Put(Temp); New_Line;
   Target_Pos(1)(Rotation) := Temp;
   Put_Line("Forward: ");  Get(Temp); Put(Temp); New_Line;
   Target_Pos(1)(Forward) := Temp;
   Put_Line("Height: ");  Get(Temp); Put(Temp); New_Line;
   Target_Pos(1)(Height) := Temp;
   Put_Line("Clamp: ");  Get(Temp); Put(Temp); New_Line;
   Target_Pos(1)(Clamp) := Temp;

   Move_Robot_To(Target_Pos(1));
   while Target_Pos (1) /= Robot_Mon.Get_Pos loop
      delay 0.5;
   end loop;
   Put_Line ("End of program.");
end Test_Robot_Monitor;
