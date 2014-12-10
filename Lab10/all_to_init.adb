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
      
      --Put_Line("Checking switches...");
      --Put_Line("Rotation: "&Init_Switch_Type'Image(Status(Rotation).Init_Switch));
      --Put_Line("Forward: "&Init_Switch_Type'Image(Status(Forward).Init_Switch));
      --Put_Line("Height: "&Init_Switch_Type'Image(Status(Height).Init_Switch));
      --Put_Line("Clamp: "&Init_Switch_Type'Image(Status(Clamp).Init_Switch));

      -- check init switches
      -- stop a motor if necessary
      if Status(Rotation).Init_Switch = pressed then
         Put_Line("Rotation at init...");
         Command(Rotation) := Stop;
         Move_Robot(Command);
      end if;
      if Status(Forward).Init_Switch = pressed then
         Put_Line("Forward at init...");
         Command(Forward) := Stop;
         Move_Robot(Command);
      end if;
      if Status(Height).Init_Switch = pressed then
         Put_Line("Height at init...");
         Command(Height) := Stop;
         Move_Robot(Command);
      end if;
      if Status(Clamp).Init_Switch = pressed then
         Put_Line("Clamp at init...");
         Command(Clamp) := Stop;
         Move_Robot(Command);
      end if;

      -- all motors at init   
      exit when Status(Rotation).Init_Switch = pressed 
                and
                Status(Forward).Init_Switch = pressed
                and
                Status(Height).Init_Switch = pressed
                and
                Status(Clamp).Init_Switch = pressed;

   delay 0.5; -- Sampling frequency
   end loop;
   -- end loop

   --end All_To_Init;
   Put_Line("End of Robot_Interface test.");
end All_To_Init;