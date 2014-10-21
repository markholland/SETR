with Ada.Calendar;  use Ada.Calendar;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO;   use Ada.Text_IO;

procedure RT_Test is
   T_Cal      : Ada.Calendar.Time;
   Next       : Ada.Real_Time.Time;
   Period     : Time_Span := Seconds(1);
   Yr, Mh, Dy : Integer;
   Ss         : Duration;
   Hr, Mn, Sd : Integer;

begin
   Put_Line("Resolution (Real_Time.Time_Unit) =" & Float'Image(Time_Unit));
   Put_Line("Granularity (Real_Time.Tick) =" & Duration'Image(To_Duration(Tick)));
   Put_Line("Absolute delay and RT Clock test");
   Next := Ada.Real_Time.Clock + Period; -- Start time of next iteration
   for I in 1 .. 30 loop                 -- Half minute loop (almost exact)
      T_Cal := Ada.Calendar.Clock;
      Split (T_Cal, Yr, Mh, Dy, Ss);
      Hr := Integer(Ss)/3600;
      Mn := (Integer(Ss) mod 3600) / 60;
      Sd := Integer(Ss) mod 60;
      Ss := Ss - 3600.0*Hr - 60.0*Mn;
      Put_Line(Integer'Image(Dy) & " /" &
               Integer'Image(Mh) & " /" &
               Integer'Image(Yr) & "  " &
               Integer'Image(Hr) & " :" &
               Integer'Image(Mn) & " :" &
               Integer'Image(Sd) & "  (" &
               Duration'Image(Ss) & ")");
      delay until Next;
      Next := Next + Period;
   end loop;

declare
   Init : Ada.Real_Time.Time;
   Ts : Time_Span;
begin
   New_Line(2);
   Put_Line("Relative vs. absolute delay (wait 5 sec for each test)");
   Put("With relative delay:");
   T_Cal := Ada.Calendar.Clock;
   for I in 1..5_000 loop
      delay 0.001;
   end loop;
   Ss := Ada.Calendar.Clock - T_Cal;
   Put_Line("Time elapsed:" & Duration'Image(Ss) & " sec");
   Put("With absolute delay:");
   Init := Ada.Real_Time.Clock;
   Next := Init;
   for I in 1..5_000 loop
      Next := Next + Milliseconds(1);
      delay until Next;
   end loop;
   Ts := Ada.Real_Time.Clock - Init;
   Put_Line("Time elapsed:" & Duration'Image(To_Duration(Ts)) & " sec");
end;
   
   
end RT_Test;


