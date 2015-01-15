with System.Machine_Code; use System.Machine_Code;
with Interfaces.C; use Interfaces.C;
with Ada.Text_IO; use Ada.Text_IO;

package body Port_IO_Linux is

   function Port_In(Port : in Word) return Byte is
      Tmp : Byte;
   begin
      Asm ("inb %%dx, %0",
           Byte'Asm_Output ("=a", Tmp),
           Word'Asm_Input  ("d",  Port));
      return Tmp;
   end Port_In;
   pragma Inline (Port_In);

   procedure Port_Out(Port : in Word; Data : in Byte) is
   begin
      Asm ("outb %0, %%dx",
           No_Output_Operands,
           (Byte'Asm_Input ("a", Data),
            Word'Asm_Input ("d", Port)), "", True);
   end Port_Out;
   pragma Inline (Port_Out);

   -- This one is for initialisation of the pakage
   -- You need to "sudo" to get IOPL 3
   function IOPL (Level: int) return int;
   pragma Import(C,IOPL,"iopl");

   Error : int;

  begin
   Error := IOPL(3);
   if Error /= 0 then
      Put_Line("Error calling iopl with error code " & int'Image (Error));
      raise Program_Error;
   end if;
end Port_IO_Linux;
