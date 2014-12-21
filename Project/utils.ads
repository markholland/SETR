with Robot_Interface; use Robot_Interface;
with System;



package Utils is


	--type valid_Movement_keys is (Q, A, W, S, E, D, R, F);

	procedure Move_By_One(A : in Axis_Type; 
						  M : in Motion_Type);

	procedure Move_Within_Limits(A : in Axis_Type;
						  M : in Motion_Type;
						  C : in Character);

	procedure Move_With_Keys(C : in Character);


	-- Constants for keeping simulator from forcing an axis
	End_Axis : Constant Natural := 200;
	End_Clamp : Constant Natural := 40;
	Init_Axis : Constant Natural := 0;



end Utils;