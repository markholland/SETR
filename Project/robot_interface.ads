with System;

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
   -- Completar con las cláusulas necesarias para 
   -- los tipos que intervienen en la definición de Command_Type
   -- Compiler error if declared in private section
   
   for Motion_Type use(Stop => 0, To_End => 1,
                        To_Init => 2);
   --for Motion_Type'Size use 2; --2 bits needed

   for Command_Type'Component_Size use 2;
   for Command_Type'Size use 8; -- 4 elements * size

   Stop_All : constant Command_Type := (others => Stop);
   Init_All : constant Command_Type := (others => To_Init);
   
   -- Clauses for Status_Type
   -- Completar con las cláusulas necesarias para
   -- los tipos que intervienen en la definición de Switches_Type
   for Init_Switch_Type use(Pressed => 0, Not_Pressed => 1);
   --for Init_Switch_Type'Size use 1;  --1 bit needed
 
   for Switches_Type use
      record
         Init_Switch at 0 range 0..0;
         Pulse_Switch at 0 range 1..1;
      end record;
   --for Switches_Type'Size use 1+Init_Switch_Type'Size; -- boolean'Size + 
   for Switches_Type'Bit_Order use System.Low_Order_First;

   for Status_Type'Component_Size use 2;--Switches_Type'Size;
   for Status_Type'Size use 8;--4 elements * 2 component size;
end Robot_Interface;
