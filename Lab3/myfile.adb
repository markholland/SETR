with Ada.Text_IO;
use  Ada.Text_IO;

procedure myfile is

procedure Eliminar_espacios (Item : in out String; Blanks_Removed : out Natural) is
	   begin
      Blanks_Removed := 0;
      for I in 1..Item'Length loop
         Put(Item(I));
	      while (Item(I) = ' ') loop
	      	for J in I .. Item'Length-1 loop
	        	Item(J) := Item(J+1);
	      	end loop;
	    	Blanks_Removed := Blanks_Removed + 1;
	      end loop;
      end loop;
      New_Line;
end Eliminar_espacios;

input : String(1..100);
Count : Natural; -- Numero de caracteres introducidos
Blanks_Removed : Natural;
begin
Put("Escriba un texto con espacios: ");
Get_Line(Item => input, Last => Count);
Put_Line(Integer'Image(Count));
   Put_Line(input(1..Count));
   Put(Natural'Image(Count));
     New_Line;
   Eliminar_espacios(input(1..Count), Blanks_Removed);
   Put(Natural'Image(Blanks_Removed));
       New_Line;
Put_Line(input(1..(Count-Blanks_Removed)));
Put(Integer'Image(Blanks_Removed));
end myfile;
