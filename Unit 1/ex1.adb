with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;
 use Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;


procedure Ex1 is


function Sqrt (X : in Float; Tolerance : in Float) return Integer is
	Approx : Float := X / 2.0; 
	Error : Float := abs(X - Approx**2);
	Count : Integer := 0;
	begin
	Put("Aproximacion de partida:");
	Put(Item => Approx, Fore => 1, Aft => 18, Exp => 0);
	Put(" Error = ");
	Put(Item => Error, Fore => 1, Aft => 18, Exp => 0);
	New_Line;
	while abs (X - Approx ** 2) > Tolerance loop		
		Approx := 0.5 * (Approx + X / Approx); 
		Count := Count + 1;
		Error := abs(X - Approx**2);
		Put("Aproximacion al resultado:");
		Put(Item => Approx, Fore => 1, Aft => 18, Exp => 0);
		Put(" Error = ");
		Put(Item => Error, Fore => 1, Aft => 18, Exp => 0);
		New_Line;
	end loop; 
	Put("La raiz cuadrada de ");
    Put(Item => X, Fore => 1, Aft => 2, Exp => 0);
    Put(" es aproximadamente ");
    Put(Item => Approx, Fore => 1, Aft => 10, Exp => 0);
    New_Line;     
	return Count;
end Sqrt;

X, Tolerance : Float;
Count : Integer;
begin
	
		Put_Line("Calculate Sqrt(X) with Tolerance y");
		Put("Introduce a real number X: ");
		Get(X);
		Put("Introduce Tolerance y: ");
		Get(Tolerance);
		Count := Sqrt(X, Tolerance);
		Put("Obtained in ");
		Put(Count);
		Put(" iterations.");
		New_Line;
	
end Ex1;