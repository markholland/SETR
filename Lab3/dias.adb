with Ada.Text_IO,Ada.Integer_Text_IO,Ada.Float_Text_IO;
use Ada.Text_IO,Ada.Integer_Text_IO,Ada.Float_Text_IO;

procedure dias is
type Day_Type is (Lunes,Martes,Miercoles,Jueves,Viernes,Sabado,Domingo);

package Dias is new Ada.Text_IO.Enumeration_IO(Day_Type);

dia : Day_Type;
begin
Put("¿Que dia es hoy? ");
Dias.Get(dia);

Put("Por lo que ayer fue ");
if dia = Day_Type'First then
	Dias.Put(Item => Day_Type'Last, Set => Lower_Case);
else
	Dias.Put(Item => Day_Type'Pred(dia), Set => Lower_Case);
end if;

Put(" y mañana sera ");
if dia = Day_Type'Last then
	Dias.Put(Item => Day_Type'First, Set => Lower_Case);
else
	Dias.Put(Item => Day_Type'Succ(dia), Set => Lower_Case);
end if;
end dias;
