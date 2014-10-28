with Ada.Calendar;  use Ada.Calendar;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO; use Ada.Text_IO;

procedure Periodic_Tasks_rt_time is
	I : Integer := 0;
	T_Cal      : Ada.Calendar.Time;
	Yr, Mh, Dy : Integer;
    Ss         : Duration;
	Hr, Mn, Sd : Integer;
	task Timer;	        -- Task specification
	task body Timer is  -- Task body
		Next : Ada.Real_Time.Time := Ada.Real_Time.Clock;
		Period : Ada.Real_Time.Time_Span := Seconds(1);
	begin
		Next := Ada.Real_Time.Clock;
		loop
			T_Cal := Ada.Calendar.Clock;       -- Calendar time
      		Split (T_Cal, Yr, Mh, Dy, Ss);     -- Obtain year, month, day and secs
			Hr := Integer(Ss)/3600;            -- Calculate hour of day
      		Mn := (Integer(Ss) mod 3600) / 60; -- Calculate minute of hour
      		Sd := Integer(Ss) mod 60;          -- Calculate (integer) seconds of minute
      		Ss := Ss - 3600.0*Hr - 60.0*Mn;    -- Calculate (fixed point) seconds of minute
			Put_Line(Integer'Image(Hr) & " :" &
               Integer'Image(Mn) & " :" &
               Integer'Image(Sd) & "  (" &
               Duration'Image(Ss) & ")"); -- Print date, time and f.p. seconds);
			Put_Line("I="&Integer'Image(I));
			Next := Next + Period;
			delay until Next;
		end loop;
	end Timer;
	
	task Incrementer;
	task body Incrementer is
		Next : Ada.Real_Time.Time;
		Period : Ada.Real_Time.Time_Span := MilliSeconds(500);
	begin
		Next := Ada.Real_Time.Clock;
		loop
			I := (I + 1) mod 16;
			Next := Next + Period;
			delay until Next;
		end loop;
	end Incrementer;

begin
	-- Tasks start to execute here
	Put_Line("Program Periodic_Tasks starts");

end Periodic_Tasks_rt_time;