with Robot_Monitor;   use Robot_Monitor;
with Robot_Interface; use Robot_Interface;
with Digital_IO_Sim;  use Digital_IO_Sim;
with Utils; use Utils;

with Ada.Integer_Text_IO;
with Ada.Text_IO;

procedure Test_Robot_Move_By_One is
   Target_Pos : array (1 .. 4) of Position :=
     (1 => (100, 100, 100, 10),
      2 => (5, 50, 200, 20),
      3 => (300, 300, 300, 30),
      4 => (111,222,333,0));
   Temp : Natural;

   C : Character;
begin

  Put_Line("Test_Robot_Monitor starts...");
   Robot_Mon.Reset;
   delay 3.0;

   --Move_By_One(Forward, To_End);
   --delay 3.0;

   --Move_By_One(Forward, To_Init);
   --delay 3.0;

   --Move_By_One(Forward, Stop);
   Put_Line("Input command");
   Get(Item=>C);
   Move_With_Keys(C);

   Put_Line ("End of program.");
end Test_Robot_Move_By_One;
