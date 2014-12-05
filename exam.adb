protected type Var_Server is
	entry Write (Value : in Integer);
	entry Read (Value : out Integer);
private
	The_Var : Integer;
	Written : Boolean := False;
	Times_Read : Integer := 0;

end Var_Server;

protected body Var_Server is
	entry Read (V: out integer) when (Updated and Times_Read < 2) is
	begin
		V := The_Var;
		Times_Read := Times_Read + 1;
		if Times_Read = 2 then
			Updated := False;
	end Read;
	entry Write(V: in Integer) when not Updated is
	begin
		The_Var := V;
		Updated := True;
	end Write;
end Var_Server;