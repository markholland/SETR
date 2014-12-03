with Port_IO; use Port_IO;

package Display_IO is

   subtype Digit_Type is Byte range 0..15;
   subtype Switches_Type is Byte range 0 .. 15;

   -- Writes the representation of Digit in the 7 segment display
   procedure Write_Digit(Digit : in Digit_Type);

   -- Reads the value formed by the micro-switches
   function Read_Switches return Switches_Type;

end Display_IO;
