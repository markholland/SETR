with Parallel_Port; use Parallel_Port;
package body Display_IO is

   To_Segments : array (Digit_Type'Range) of Data_Register :=
     (0  => 2#0011_1111#, -- Digit 0
      1  => 2#0000_0110#, -- Digit 1
      2  => 2#0101_1011#, -- Digit 2
      3  => 2#0100_1111#, -- Digit 3
      4  => 2#0110_0110#, -- Digit 4
      5  => 2#0110_1101#, -- Digit 5
      6  => 2#0111_1101#, -- Digit 6
      7  => 2#0000_0111#, -- Digit 7
      8  => 2#0111_1111#, -- Digit 8
      9  => 2#0110_1111#, -- Digit 9
      10  => 2#0111_0111#,-- Digit A
      11  => 2#0111_1100#,-- Digit B
      12  => 2#0011_1001#,-- Digit C
      13  => 2#0101_1110#,-- Digit D
      14  => 2#0111_1001#,-- Digit E
      15  => 2#0111_0001#);-- Digit F

      -- Completar para los valores 9 a 15                -- POR HACER
      procedure Write_Digit(Digit : in Digit_Type) is
      begin

         Write_Data_Register(To_Segments(Digit));

      end Write_Digit;

      function Read_Switches return Switches_Type is
      Status : Status_Register;
      Switches : Switches_Type := 0;
      begin

      Status := Read_Status_Register;

         if Status.S4 then Switches := Switches + 1; end if;
         if Status.S5 then Switches := Switches + 2; end if;
         if not Status.Inv_S7 then Switches := Switches + 4; end if;
         if Status.S6 then Switches := Switches + 8; end if;

      return Switches;

      end Read_Switches;

   end Display_IO;
