with Ada.Calendar;  use Ada.Calendar;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO; use Ada.Text_IO;

procedure Periodic_Tasks_2_rt_time is
	I : Integer := 0;
	T_Cal      : Ada.Calendar.Time;
	Yr, Mh, Dy : Integer;
    Ss         : Duration;
	Hr, Mn, Sd : Integer;
	task Timer is	    -- Task specification
		entry Start;
		entry Stop;
	end Timer;       
	task body Timer is  -- Task body
		Next : Ada.Real_Time.Time;
		Period : Ada.Real_Time.Time_Span := Seconds(1);
	begin
		accept Start;
		Next := Ada.Real_Time.Clock;
		loop
			select		
				accept Stop;
				exit;
			else
				T_Cal := Ada.Calendar.Clock;       -- Calendar time
	  			Split (T_Cal, Yr, Mh, Dy, Ss);     -- Obtain year, month, day and secs
				Hr := Integer(Ss)/3600;            -- Calculate hour of day
	      		Mn := (Integer(Ss) mod 3600) / 60; -- Calculate minute of hour
	      		Sd := Integer(Ss) mod 60;          -- Calculate (integer) seconds of minute
	      		Ss := Ss - 3600.0*Hr - 60.0*Mn;    -- Calculate (fixed point) seconds of minute
				Put_Line(Integer'Image(Hr) & " :" &
	            Integer'Image(Mn) & " :" &
	            Integer'Image(Sd) & "  (" &
	            Duration'Image(Ss) & ")"); -- Print date, time and f.p. seconds
				Put_Line("I="&Integer'Image(I));
				Next := Next + Period;
				delay until Next;	
			end select;
		end loop;
	end Timer;
	
	task Incrementer is
		entry Start;
		entry Stop;
	end Incrementer;
	task body Incrementer is
		Next : Ada.Real_Time.Time;
		Period : Ada.Real_Time.Time_Span := Milliseconds(500);
	begin
		accept Start;
		Next := Ada.Real_Time.Clock;
		loop
			select
				accept Stop;
				exit;	
			else
				I := (I + 1) mod 16;
				Next := Next + Period;
				delay until Next;
			end select;
		end loop;
	end Incrementer;

Next : Ada.Real_Time.Time;
Period : Ada.Real_Time.Time_Span := Seconds(10);
begin
	-- Tasks start to execute here
	Put_Line("Program starts... will stop in some 10 seconds");
	Timer.Start;		-- Start the Timer task
	Incrementer.Start;  -- Start the Incrementer task
	delay 10.0;
	Timer.Stop;			-- Force Timer to terminate
	Incrementer.Stop;	-- Force Incrementer to terminate
	Put_Line("End of program.");
end Periodic_Tasks_2_rt_time;