---------------------------------------
--           Digital_IO              --
--                                   --
-- Interface to Fischertechnik robot --
--                                   --
-- Jorge Real                        --
---------------------------------------

with Low_Level_Types; use Low_Level_Types;

package Digital_IO is

   procedure Write_Low_Byte(Value: in Byte);
   function Read_Low_Byte return Byte;

end Digital_IO;
