with Robot_Interface; use Robot_Interface;
with Digital_Io;  use Digital_Io;
with Low_Level_Types; use Low_Level_Types;
with Ada.Unchecked_Conversion;
with Ada.Text_IO;

procedure To_Home is
   Command : Command_Type := Init_All;
   Status_Robot : Status_Type := Robot_State;
function Command_To_Byte is new Ada.Unchecked_Conversion (Source => Command_Type, Target => Byte);

begin
    Put_Line("Robot_Interface test starts...");
    --Put_Line("Initial value of Command =" & Byte'Image(Command_To_Byte(Command)));
   Move_Robot(Command);
   while(Last_Robot_Command /= Stop_All) loop
      --Ada.Text_IO.Put("Entra en While");
      Command := Last_Robot_Command;
      Status_Robot := Robot_State;
      for Ax in Axis_Type'Range loop
         --Ada.Text_IO.Put("Entra en for");
         if Status_Robot(Ax).Init_Switch = pressed and Command(Ax) /= Stop then
            Command(Ax) := Stop; Move_Robot(Command);
            Put_Line("Command for " & Axis_Type'Image(Ax) & ": " & Byte'Image(Command_To_Byte(Command)));
         end if;

      end loop;
      delay 0.4;
    end loop;
   Move_Robot (Stop_All);
   Put_Line("End of Robot_Interface test.");
end To_Home;
