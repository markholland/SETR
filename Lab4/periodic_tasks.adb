with Ada.Calendar;  use Ada.Calendar;
with Ada.Text_IO; use Ada.Text_IO;

procedure Periodic_Tasks is
	I : Integer := 0;
	T_Cal      : Ada.Calendar.Time;
	Yr, Mh, Dy : Integer;
    Ss         : Duration;
	Hr, Mn, Sd : Integer;
	task Timer;	        -- Task specification
	task body Timer is  -- Task body
	begin
		loop
			T_Cal := Ada.Calendar.Clock;       -- Calendar time
      		Split (T_Cal, Yr, Mh, Dy, Ss);     -- Obtain year, month, day and secs
			Hr := Integer(Ss)/3600;            -- Calculate hour of day
      		Mn := (Integer(Ss) mod 3600) / 60; -- Calculate minute of hour
      		Sd := Integer(Ss) mod 60;          -- Calculate (integer) seconds of minute
			Put_Line(Integer'Image(Hr) & " :" &
               Integer'Image(Mn) & " :" &
               Integer'Image(Sd));
			delay 1.0;
		end loop;
	end Timer;
	
	task Incrementer;
	task body Incrementer is
	begin
		loop
			I := (I + 1) mod 16;
			Put_Line("I="&Integer'Image(I));
			delay 0.5;
		end loop;
	end Incrementer;

begin
	-- Tasks start to execute here
	Put_Line("Program Periodic_Tasks starts");

end Periodic_Tasks;