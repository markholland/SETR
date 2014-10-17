with Ada.Text_IO;
use  Ada.Text_IO;

procedure Palindrome is 

	function Is_Palindrome (Item : in String) return Boolean is
	begin
		if Item'Length <= 1 then
			return True;
		elsif Item(Item'First) /= Item(Item'Last) then
			return False;
		else
			return Is_Palindrome(Item(Item'First+1 .. Item'Last-1));
		end if;
	end Is_Palindrome;

	procedure Remove_Blanks (Item : in out String; Blanks_Removed : out Natural) is
	   begin
	   Blanks_Removed := 0;
	   for I in 1..Item'Length loop
	      while (Item(I) = ' ') loop
	      	for J in I .. Item'Length-1 loop
	        	Item(J) := Item(J+1);
	      	end loop;
	    	Blanks_Removed := Blanks_Removed + 1;
	      end loop;
	    end loop;
	end Remove_Blanks;

	-- vars
	Max_Length : constant Positive := 100;
	subtype Line_Type is String (1 .. Max_Length);
	Line : Line_Type;
	Count: Natural;
	Blanks : Natural;

begin
	Put_Line ("Introduce una cadena y te diré si es palíndromo");
	Get_Line (Item => Line, Last => Count);
	Put_Line(Line(1..Count));
	Put_Line ("Número de caracteres:" & Natural'Image(Count));
	Remove_Blanks(Line(1..Count), Blanks);
	Put_Line ("Número de espacios:" & Natural'Image(Blanks));
	Put (Line(1 .. Count - Blanks) & " ");

	if Is_Palindrome (Line (1 .. Count - Blanks)) then
		Put_Line ("es un palíndromo");
	else
		Put_Line ("no es un palíndromo");
	end if;
end Palindrome;
