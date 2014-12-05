
with System.Machine_Code; use System.Machine_Code;

package body Port_IO is

   procedure Out_Byte (Address : in IO_Address_Range;
                       Data : in Byte) is
   begin
      System.Machine_Code.Asm
        (Template => "outb %%al, %%dx",
         Outputs => No_Output_Operands,
         Inputs => (Byte'Asm_Input( "a", Data),
                    IO_Address_Range'Asm_Input("d", Address)),
         Clobber => "",
         Volatile => true);
   end Out_Byte;

   function In_Byte (Address : in IO_Address_Range) return Byte is
      Result : Byte;
   begin
      System.Machine_Code.Asm
        (Template => "inb %%dx, %%al",
         Outputs => Byte'Asm_Output( "=a", Result),
         Inputs => IO_Address_Range'Asm_Input("d", Address),
         Clobber => "",
         Volatile => true);

      return Result;
   end In_Byte;

   procedure Out_Word (Address : in IO_Address_Range;
                       Data : in Word) is
   begin
      System.Machine_Code.Asm
        (Template => "outw %%ax, %%dx",
         Outputs => No_Output_Operands,
         Inputs => (Word'Asm_Input( "a", Data),
                    IO_Address_Range'Asm_Input("d", Address)),
         Clobber => "",
         Volatile => true);
   end Out_Word;

   function In_Word (Address : in IO_Address_Range) return Word is
      Result : Word;
   begin
      System.Machine_Code.Asm
        (Template => "inw %%dx, %%ax",
         Outputs => Word'Asm_Output( "=a", Result),
         Inputs => IO_Address_Range'Asm_Input("d", Address),
         Clobber => "",
         Volatile => true);
      return Result;
   end In_Word;

end Port_IO;
