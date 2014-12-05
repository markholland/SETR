with System, Ada.Unchecked_Conversion;
with Port_IO; use Port_IO;

package body Parallel_Port is

   -- Crea la funcion de conversion de Data_Register a Byte
   function Data_Register_To_Byte is new Ada.Unchecked_Conversion(-- POR HACER
                                                                  Source => Data_Register,
                                                                  Target => Byte);
   -- Crea la funcion de conversion de Byte a Status_Register
   --REVISAR NUMERO BITS CONVERSION!!!!!!!!!!!!!!!
   function Byte_To_Status_Register is new Ada.Unchecked_Conversion(  -- POR HACER
                                                                      Source =>Byte ,
                                                                      Target =>Status_Register);
   procedure Write_Data_Register (Data : in Data_Register) is
      Destino : Byte;
    begin
            -- Convierte el Data_Register a Byte y
            --  escribelo en la direccion de E/S correspondiente
            --  utilizando el subprograma Out_Byte
            -- POR HACER
      Destino := Data_Register_To_Byte(Data);
      Port_IO.Out_Byte(Address => Base_Address ,
                       Data    => Destino);

    end Write_Data_Register;

    function Read_Status_Register return Status_Register is
      Data : Byte;
      Dato : Status_Register;
    begin
    -- Lee el registro de estado del puerto paralelo desde
    --  la direccion de E/S correspondiente
    --  utilizando la funcion In_Byte
    -- POR HACER
      Data := Port_IO.In_Byte(Address =>Status_Register_Address);
      Dato := Byte_To_Status_Register(Data);

     -- Convierte el Byte leido a un dato de tipo Status_Register
     --   y devuelvelo como valor de retorno de la función
    return Dato;      -- POR HACER
   end Read_Status_Register;
end Parallel_Port;
