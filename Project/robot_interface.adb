with Low_Level_Types, Digital_IO;
use  Low_Level_Types, Digital_IO;
with System, Ada.Unchecked_Conversion;

package body Robot_Interface is

   function Command_To_Byte is new Ada.Unchecked_Conversion (Source => Command_Type, Target => Byte);
   function Byte_To_Command is new Ada.Unchecked_Conversion (Source => Byte, Target => Command_Type);
   function Byte_To_Status  is new Ada.Unchecked_Conversion (Source => Byte, Target => Status_Type);

   protected Robot is
      pragma Priority(System.Priority'Last-1);
      procedure Move_Robot (Command: in Byte);
      function Robot_State return Byte;
      function Current_Command return Byte;
   private
      Last_Command_Applied: Byte := 0;
   end Robot;

   protected body Robot is
      procedure Move_Robot (Command : in Byte) is
      begin
         Last_Command_Applied := Command;
         Write_Low_Byte(Command);
      end Move_Robot;

      function Robot_State return Byte is
      begin
         return Read_Low_Byte;
      end Robot_State;

      function Current_Command return Byte is
      begin
         return Last_Command_Applied;
      end Current_Command;

   end Robot;

   ----------------
   -- Move_Robot --
   ----------------
   procedure Move_Robot (Command: in Command_Type) is
   begin
      Robot.Move_Robot(Command_To_Byte(Command));
   end Move_Robot;

   -----------------
   -- Robot_State --
   -----------------
   function Robot_State return Status_Type is
   begin
      return Byte_To_Status(Robot.Robot_State);
   end Robot_State;

   -------------------
   -- Robot_Command --
   -------------------
   function Last_Robot_Command return Command_Type is
   begin
      return Byte_To_Command(Robot.Current_Command);
   end Last_Robot_Command;

   

end Robot_Interface;
