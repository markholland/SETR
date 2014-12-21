with Robot_Monitor;   use Robot_Monitor;
with Robot_Interface; use Robot_Interface;
with Digital_IO_Sim;  use Digital_IO_Sim;
with Utils;           use Utils;

with Ada.Integer_Text_IO;

procedure Test_Robot_Move_By_Keys is
   Target_Pos : array (1 .. 4) of Position :=
     (1 => (100, 100, 100, 10),
      2 => (5, 50, 200, 20),
      3 => (300, 300, 300, 30),
      4 => (111,222,333,0));
   Temp : Natural;

   Input : Character := 'Z';
   Available : Boolean := False;
begin

  Put_Line("Test_Robot_Monitor starts...");
   Robot_Mon.Reset;
   delay 3.0;

   --Move_By_One(Forward, To_End);
   --delay 3.0;

   --Move_By_One(Forward, To_Init);
   
  
  while Input /= 'l' loop
    Put_Line("Move Robot");
    Available := False;
    while Available = False loop
      Get_Immediate(Item => Input, Available => Available);
      if(Available) then 
        Put_Line(Character'Image(Input));
        Move_With_Keys(Input);
      end if;
    end loop;
    
  end loop;

   Put_Line ("End of program.");
end Test_Robot_Move_By_Keys;
