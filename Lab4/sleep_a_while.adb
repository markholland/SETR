with Ada.Text_IO; use Ada.Text_IO;
procedure Sleep_A_While is
	My_Delay : Duration := 3.0;
begin
	Put_Line("Starting. Going to sleep for 3 seconds...");
	delay My_Delay;
	Put_Line("Enough sleeping!");
end sleep_A_While;