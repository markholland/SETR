
with System;
with Interfaces;

with Port_IO; use Port_IO;

package Parallel_Port is

   Base_Address : constant IO_Address_Range :=2#001101111000#;

   type Data_Register is new Interfaces.Unsigned_8;
   Data_Register_Address : constant IO_Address_Range := Base_Address;

   type Status_Register is
      record
         Inv_S7 : Boolean;
         S6 : Boolean;
         S5 : Boolean;
         S4 : Boolean;
         S3 : Boolean;
      end record;
   Status_Register_Address : constant IO_Address_Range := Base_Address + 1;

   procedure Write_Data_Register (Data : in Data_Register);
   function Read_Status_Register return Status_Register;

private
   -- Establece la representación de los campos del registro de estado en
   --   los correspondientes bits del registro físico
   -- POR HACER
   -- Establece el tamaño en bits del registro de estado
   -- Establece la ordenación de los bits del registro de estado
   for Status_Register use
      record
         Inv_s7 at 0 range 7..7;
           S6 at 0 range 6..6;
           S5 at 0 range 5..5;
           S4 at 0 range 4..4;
           S3 at 0 range 3..3;
      end record;
   for Status_Register'Size use 8;
   for Status_Register'Bit_Order use System.Low_Order_First;

end Parallel_Port;
