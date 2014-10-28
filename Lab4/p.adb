with Ada.Text_IO; use Ada.Text_IO;
procedure P is
	task T1; task T2;	   -- Specification of T1 and T2

	task body T1 is        -- Body of T1
		I : Integer := 0;  -- Declarative part of the task
	begin
		loop
			I := I + 1;
			Put_Line("Task1 I="&Integer'Image(I));
			delay 1.0;
		end loop;
	end T1;
	task body T2 is		   -- Body of T2
		I : Integer := 0;  -- Declaration part of the task
	begin
		loop
			I := I + 2;
			Put_Line("Task2 I="&Integer'Image(I));
			delay 1.0;
		end loop;
	end T2;

begin
	-- Tasks T1 and T2 start to execute here
	Put_Line("Program P starts");
end P;