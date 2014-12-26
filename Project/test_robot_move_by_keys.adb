with Robot_Monitor;   use Robot_Monitor;
with Robot_Interface; use Robot_Interface;
with Digital_IO_Sim;  use Digital_IO_Sim;
with Utils;           use Utils;          

with Ada.Integer_Text_IO;

procedure Test_Robot_Move_By_Keys is
   
   Input : Character := 'Z';
   Available : Boolean := False;

   Position_aux : Position;

begin

  Put_Line("Test_Robot_Monitor starts...");
   Robot_Mon.Reset;
   delay 3.0;

   --Move_By_One(Forward, To_End);
   --delay 3.0;

   --Move_By_One(Forward, To_Init);
   
  
  while Input /= 'z' loop -- Until decide to exit
    --Put_Line("Move Robot");
    Available := False;
    while Available = False loop
      Get_Immediate(Item => Input, Available => Available);
      if(Available) then 
        --Put_Line(Character'Image(Input));
        Move_With_Keys(Input);
      end if;
    end loop;
    Put_Line("");
  end loop;

  Position_Aux := Robot_Mon.Get_Pos;

  Put_Line ("End of program.");
end Test_Robot_Move_By_Keys;
