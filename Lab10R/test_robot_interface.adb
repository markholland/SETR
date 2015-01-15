with Robot_Interface; use Robot_Interface;
with Digital_IO;  use Digital_IO;
with Low_Level_Types; use Low_Level_Types;

with Ada.Unchecked_Conversion;

procedure Test_Robot_Interface is
   Command : Command_Type := Stop_All;
   function Command_To_Byte is new Ada.Unchecked_Conversion (Source => Command_Type, Target => Byte);
begin
   Put_Line("Robot_Interface test starts...");
   Put_Line("Initial value of Command =" & Byte'Image(Command_To_Byte(Command)));

   for Ax in Axis_Type'Range loop
      for Mo in Motion_Type'Range loop
         Command (Ax) := Mo;
         Put_Line("Command for " & Axis_Type'Image(Ax) & " " & Motion_Type'Image (Mo) & ": " &
                    Byte'Image(Command_To_Byte(Command)));
         Command := Stop_All;
      end loop;
   end loop;
   delay 2.0;
   Put_Line ("Moving all axes but the clamp towards the initial position for three seconds...");
   Move_Robot((Clamp => Stop, others => To_Init));
   delay 3.0;
   Move_Robot (Stop_All);
   Put_Line("End of Robot_Interface test.");
end Test_Robot_Interface;
