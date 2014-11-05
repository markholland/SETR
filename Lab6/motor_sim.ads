pragma Task_Dispatching_Policy (Fifo_Within_Priorities);
pragma Queuing_Policy (Priority_Queuing);
pragma Locking_Policy (Ceiling_Locking);

package Motor_Sim is

   Max_Speed : constant := 1000;     -- Max Speed in RPM

   type Speed_Mode is (Full, Half);  -- Full -> Max_Speed; Half -> Full/2

   procedure Motor_On;                      -- To start motor
   procedure Motor_Off;                     -- To stop motor
   procedure Set_Speed (S : in Speed_Mode); -- To set nominal speed
   function Motor_Pulse return Boolean;     -- To read pulse signal

   procedure Start_Simulation;  -- To start the simulatoin
   procedure End_Simulation;    -- To terminate the simulation

end Motor_Sim;
