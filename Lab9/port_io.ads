
with Interfaces; use Interfaces;

package Port_IO is

   type IO_Address_Range is new Unsigned_16;
   type Byte is new Unsigned_8;
   type Word is new Unsigned_16;
   -- Unsigned_N tienen ya restringido su tama–o a N bits en Interfaces

   procedure Out_Byte (Address : in IO_Address_Range;
                       Data : in Byte);
   function In_Byte (Address : in IO_Address_Range) return Byte;

   procedure Out_Word (Address : in IO_Address_Range;
                       Data : in Word);
   function In_Word (Address : in IO_Address_Range) return Word;

end Port_IO;
