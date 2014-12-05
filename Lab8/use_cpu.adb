with Ada.Text_IO, Ada.Float_Text_IO, Ada.Real_Time, Ada.Numerics.Elementary_Functions;
use  Ada.Text_IO, Ada.Float_Text_IO, Ada.Real_Time, Ada.Numerics.Elementary_Functions;

package body Use_CPU is

   T1, T2, T3 : Time;
   Time_Measured : Time_Span;
   Tolerance : Time_Span := Microseconds (10);
   X : Float := 0.0;
   Min : Integer := 0;
   Max : Integer := 300_000_000;
   NTimes : Integer := (Max - Min) / 2;  -- Number of iterations to calibrate for 10 ms use of CPU
   Sample_Size : constant Integer := 10; -- Number of times to perform test prior to averaging
   Std_Dev : Float := 0.0;               -- Standard deviation of times measured
   Measurements : array (1..Sample_Size) of Integer;  -- Measurements taken

   procedure Iterate (Iterations : in Integer) with Inline is
      X : Float := 0.0;
   begin
      for I in 1 .. Iterations loop
         X := X + 16.25;
         X := X - 16.25;
         X := X + 16.25;
         X := X - 16.25;
         X := X + 16.25;
         X := X - 16.25;
      end loop;
   end Iterate;


   procedure Work (Amount_MS: in Natural) is
      Iterations : Integer := (NTimes * Amount_MS) / 10;
   begin
      Iterate (Iterations);
   end Work;

begin
   Put ("Calibrating number of iterations for 10 ms...");
   for I in 1..Sample_Size loop
      loop
         --Put("Trying" & Integer'Image(NTimes) & " times:");
         T1 := Clock;
         Iterate (NTimes);
         T2 := Clock;
         T3 := Clock;
         Time_Measured := (T2 - T1 - (T3 - T2));
         --Put("  Took" & Duration'Image(To_Duration(Time_Measured)) & " seconds.");
         if abs (Time_Measured - Milliseconds (10)) <= Tolerance then
            exit;
         elsif (Time_Measured > Milliseconds (10)) then -- NTimes too large -> reduce
            Max := NTimes;
         else -- NTimes too short -> increase
            Min := NTimes;
         end if;
         --Put_Line (" Searching now range" & Integer'Image(Min) & " .. " & Integer'Image(Max));
         NTimes := Min + ((Max - Min) / 2);
      end loop;
      Measurements (I) := NTimes;
      Min := NTimes / 2;
      Max := NTimes * 2;
      Put(".");
   end loop;
   NTimes := 0;
   for I in 1..Sample_Size loop -- Calculate average
      NTimes := NTimes + Measurements(I);
      --Put(Integer'Image(Measurements(I)));
      --Put (if I < Sample_Size then ", " else ".");
   end loop;
   NTimes := NTimes / Sample_Size;

   for I in 1..Sample_Size loop -- Calculate standard deviation
      Std_Dev := Std_Dev + Float((Measurements (I) - NTimes)**2);
   end loop;
   Std_Dev := Std_Dev / Float(Sample_Size);
   Std_Dev := Sqrt (Std_Dev);

   New_Line;
   Put_Line ("Calibration results:");
   Put_Line ("  Nr. of iterations for 10 ms =" & Integer'Image(NTimes));
   Put ("           Standard deviation = ");
   Put(Item => Std_Dev, Aft => 1, Exp => 0);
   New_Line;

end Use_CPU;
