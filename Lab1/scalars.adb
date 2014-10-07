with Ada.Text_IO; use Ada.Text_IO;
procedure Scalars is
   type Speed is digits 3 range 0.0 .. 300.0;
   type Euro is delta 0.01 digits 8; --range 0.0 .. 100_000.0;
   type Peso is delta 0.1 digits 9; --range 0.0 .. 10_000_000.0;
F: Float := 0.0;
S: Speed := 0.0;
begin
Put_Line("Float:");
Put_Line(Float'Image(Float'First));
Put_Line(Float'Image(Float'Last));
Put_Line(Float'Image(Float'Last - Float'Pred(Float'Last)));
Put_Line(Float'Image(Float'Succ(F)));
Put_Line("Speed:");
Put_Line(Speed'Image(Speed'First));
Put_Line(Speed'Image(Speed'Last));
Put_Line(Speed'Image(Speed'Last - Speed'Pred(Speed'Last)));
Put_Line(Speed'Image(Speed'Succ(S)));
Put_Line("Euro:");
Put_Line(Euro'Image(Euro'First));
Put_Line(Euro'Image(Euro'Last));
Put_Line("Peso:");
Put_Line(Peso'Image(Peso'First));
Put_Line(Peso'Image(Peso'Last));
end Scalars;
