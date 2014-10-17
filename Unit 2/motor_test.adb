with Motor_Sim;     use Motor_Sim;
with Ada.Text_IO;   use Ada.Text_IO;

procedure Motor_Test is
   Running : Boolean;
begin
   Put_Line ("Starting motor simulation");
   Start_Simulation;
   Put_Line("Simple motor test. Will take 10 seconds...");
   Motor_Off;
   Running := False;
   for I in 0..199 loop
      if I mod 25 = 0 then
         if not Running then
            Motor_On;
            Running := True;
         else
            Motor_Off;
            Running := False;
         end if;
         New_Line;
      end if;
      Put(if Motor_Pulse then "1 " else "0 ");
--        if Motor_Pulse then
--           Put("1 ");
--        else
--           Put("0 ");
--        end if;
      delay 0.05;
   end loop;
   Motor_Off;
   New_Line;

   Put_Line ("Ending motor simulation");
   End_Simulation;
   Put_Line("End of simple test program");

end Motor_Test;
