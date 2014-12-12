with Robot_Interface; use Robot_Interface;
with System;

package Robot_Monitor is

   type Position is array (Axis_Type'Range) of Natural;

   protected Robot_Mon is
      pragma Priority(System.Priority'Last-1);
      function Get_Pos return Position;
      procedure Reset;
      procedure Set_Pos (P : in Position);
      procedure Print_Pos (P : in Position);
   private
      Pos: Position := (others => Natural'Last / 2);
   end Robot_Mon;

   -- For moving the robot to a particular position
   procedure Move_Robot_To (P: in Position);
   procedure Start_Sampler;

end Robot_Monitor;
