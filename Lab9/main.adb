with Display_IO;
use Display_IO;

procedure Main is
   Switches: Switches_Type;
begin
   for I in 1 .. 30 loop -- Approx. loop duration = 1 minute
         -- Leer el valor de los microinterruptores - POR HACER
           -- Escribir el valor lei­do en el visualizador - POR HACER
      Switches := Display_IO.Read_Switches;
      Display_IO.Write_Digit(Digit_Type(Switches));
   delay 2.0;
   end loop;
   for I in reverse 0..9 loop -- Ten seconds for countdown
     -- Escribir en el visualizador el valor de I -€“ POR HACER
     Display_IO.Write_Digit(Digit_Type(I));
      delay 1.0;
   end loop;
end Main;
