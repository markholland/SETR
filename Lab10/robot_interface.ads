package Robot_Interface is

   type Axis_Type is (Rotation, Forward, Height, Clamp);

   -- Command-related types
   type Motion_Type is (Stop, To_End, To_Init);
   type Command_Type is array (Axis_Type'Range) of Motion_Type;
   Stop_All : constant Command_Type;
   Init_All : constant Command_Type;

   -- Status-related types
   type Init_Switch_Type is (Pressed, Not_Pressed);
   type Switches_Type is
      record
         Init_Switch  : Init_Switch_Type;
         Pulse_Switch : Boolean;
      end record;
   type Status_Type is array (Axis_Type'Range) of Switches_Type;


   -- Procedure for issuing robot commands
   procedure Move_Robot (Command : in Command_Type);

   -- Function for querying robot state
   function Robot_State return Status_Type;

   -- Function for querying last command applied to robot
   function Last_Robot_Command return Command_Type;

private
   -- Clauses for Command_Type
   -- Completar con las cláusulas necesarias para    -- los tipos que intervienen en la definición de Command_Type
   -- Clauses for Status_Type   -- Completar con las cláusulas necesarias para   -- los tipos que intervienen en la definición de Switches_Type
end Robot_Interface;
