with Robot_Interface; use Robot_Interface;
with System;

package Utils is

	procedure Move_By_One(A : in Axis_Type; 
						  M : in Motion_Type);

	procedure Move_Within_Limits(A : in Axis_Type;
						  M : in Motion_Type;
						  C : in Character);

	procedure Move_With_Keys(C : in Character);

	procedure Repeat_From_Memory; -- Pop from queue calling positioner

	-- Constants for keeping simulator from forcing an axis
	End_Axis : Constant Natural;
	End_Clamp : Constant Natural;
	Init_Axis : Constant Natural;

	type Limits_Type is array (Axis_Type'Range) of Natural;
	Simul_Limits : constant Limits_Type;

private

	End_Axis : Constant Natural := 400;
	End_Clamp : Constant Natural := 40;
	Init_Axis : Constant Natural := 0;

	Simul_Limits : constant Limits_Type:= (Rotation=>End_Axis,
					 					   Forward=>End_Axis,
					 					   Height=>End_Axis,
					 				       Clamp=>End_Clamp);



end Utils;