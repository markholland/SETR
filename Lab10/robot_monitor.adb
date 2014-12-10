pragma Task_Dispatching_Policy (FIFO_Within_Priorities);
pragma Locking_Policy (Ceiling_Locking);

with Digital_IO_Sim;  use Digital_IO_Sim;
with Ada.Real_Time;   use Ada.Real_Time;

package body Robot_Monitor is

   protected body Robot_Mon is

      function Get_Pos return Position is
      begin
         return Pos;
      end Get_Pos;

      procedure Reset is ... -- COMPLETAR
      end Reset;

      procedure Set_Pos (P : in Position) is
      begin
         Pos := P;
      end Set_Pos;

      procedure Print_Pos (P : in Position) is
      begin
         Put ("Rotation, Forward, Height, Clamp = ");
         for Axis in Axis_Type'Range loop
            Put (Natural'Image(P(Axis)));
         end loop;
      end Print_Pos;

   end Robot_Mon;

   task Robot_Sampler is
      pragma Priority (System.Priority'Last - 1);
   end Robot_Sampler;

   task Positioner is
      pragma Priority (System.Priority'Last - 2);
      entry Move_Robot_To (P : in Position);
   end Positioner;

   procedure Move_Robot_To (P : in Position) is
   begin
      Positioner.Move_Robot_To (P);
   end Move_Robot_To;

   task body Robot_Sampler is ... -- COMPLETAR

   task body Positioner is ... -- COMPLETAR

end Robot_Monitor;
