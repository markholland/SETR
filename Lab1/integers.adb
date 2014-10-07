with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
procedure Integers is
   C : Character; -- Para esperar pulsación de tecla al finalizar
   subtype Indice_Vector is Integer range 1..100;
begin
Put("El Integer más pequeño es: ");
Put(Indice_Vector'First);
New_Line;
Put("El Integer más grande es: ");
Put(Indice_Vector'Last);
New_Line;
Get(C); -- Esperar tecla
end Integers;
