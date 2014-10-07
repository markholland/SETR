with Ada.Text_IO;
use  Ada.Text_IO;

procedure Remove_Blanks is

procedure Eliminar_espacios (Item : in out String; Blanks_Removed : out Natural) is
	   begin
	   for I in 1..Item'Length loop
	      while (Item(I) = ' ') loop
	      	for J in I .. Item'Length-1 loop
	        	Item(J) := Item(J+1);
	      	end loop;
	    	Blanks_Removed := Blanks_Removed + 1;
	      end loop;
	    end loop;
end Eliminar_espacios;

input : String(1..100);
Count : Natural; -- Numero de caracteres introducidos
Blanks_Removed : Natural := 0;
begin
Put("Escriba un texto con espacios: ");
Get_Line(Item => input, Last => Count);
Put_Line(Integer'Image(Count));
Put_Line(input(1..Count));
Eliminar_espacios(input, Blanks_Removed);
Put_Line(input(1..(Count-Blanks_Removed)));
Put(Integer'Image(Blanks_Removed));
end Remove_Blanks;
