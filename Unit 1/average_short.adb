with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;
procedure Average_Short is
-- Display the average of two numbers entered by the user
   A : Integer;
   B : Integer;
   M : Float;
begin
   Put_Line ("Enter two integers.");
   Get (A);
   Get (B);
   M := Float (A + B) / 2.0;
   New_Line;
   Put ("The average of your integers is ");
   Put (M, 1, 2, 0);
   New_Line;
end Average_Short;
