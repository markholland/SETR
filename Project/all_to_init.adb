with Robot_Interface; use Robot_Interface;
with Digital_IO_Sim;  use Digital_IO_Sim;
with Low_Level_Types; use Low_Level_Types;

with Ada.Unchecked_Conversion;

procedure All_To_Init is
   Status : Status_Type;
   Command : Command_Type;
begin
   Put_Line("Robot_Interface test starts...");

   --move all to init
   Move_Robot(Init_all);
   Put_Line("All axis moving...");
   -- loop checking if at init
   loop
      -- get state
      Status := Robot_State;
      Command := Last_Robot_Command;

      exit when Command = Stop_All;
      
      -- check init switches
      -- stop a motor if necessary
      for Ax in Axis_Type'Range loop
         if Status(Ax).Init_Switch = pressed then
            Command(Ax) := Stop; 
            Move_Robot(Command);       
         end if;
      end loop;

   delay 0.5; -- Sampling frequency
   end loop;
   -- end loop

   --end All_To_Init;
   Put_Line("End of Robot_Interface test.");
end All_To_Init;