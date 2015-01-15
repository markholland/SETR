with Ada.Calendar; use Ada.Calendar;
with Ada.Real_Time; use Ada.Real_Time;
with Robot_Interface; use Robot_Interface;

procedure To_Home2 is

   Move_Robot((Clamp => Stop, others => To_Init));
   loop

      if Robot_state((Rotation(Init_Switch.Pressed)));

   end loop;

end To_Home2;
