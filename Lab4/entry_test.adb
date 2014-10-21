
with Ada.Text_IO; use Ada.Text_IO;

procedure Entry_Test is
	
	task T is
		entry E1;
		entry E2;
	end T;
	task body T is
		
	begin 
		accept E1;			-- Wait until someone calls T.E1
		Put_Line("Entry E1 called!");
		loop
			delay 2.0;
			accept E2;		-- Wait until someone calls T.E2
			Put_Line("Entry E2 called!");
		end loop;
	end T;

begin
	-- Tasks start to execute here
	Put_Line("Program Entry_Test starts");
	delay 3.0;
	T.E1;
	delay 3.0;
	for I in 1..10 loop
		T.E2;
	end loop;
	delay 5.0;
	T.E2;
	Put_Line("Program Entry_Test Finished");

end Entry_Test;