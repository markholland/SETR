with Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Float_Text_IO;
procedure Average is
-- Display the average of two numbers entered by the user
   A : Integer;
   B : Integer;
   M : Float;
begin
   Ada.Text_IO.Put_Line (Item => "Enter two integers.");
   Ada.Integer_Text_IO.Get (Item => A);
   Ada.Integer_Text_IO.Get (Item => B);
   M := Float (A + B) / 2.0;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put (Item => "The average of your integers is ");
   Ada.Float_Text_IO.Put (Item => M,
                          Fore => 1,
                          Aft  => 2,
                          Exp  => 0);
   Ada.Text_IO.New_Line;
end Average;
