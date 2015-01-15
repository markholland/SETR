with Digital_Io, Robot_Interface, Robot_Monitor, Ada.Text_IO;
use  Digital_Io, Robot_Interface, Robot_Monitor, Ada.Text_IO;

procedure Learn_Rep is
   Ch : Character;
   Available : Boolean;
   Command : Command_Type := Stop_All;
   Pos : Position;
   Max_Pos : Position := (239, 149, 234, 40);
   type Pos_Array is array (0..400) of Position;
   Position_Mem : Pos_Array;
   Iter_Array : Integer := 0;
begin
   Robot_Mon.Reset;
   Put_Line ("Press robot control keys to make it move(q,a,w,s,e,d,r,f), or press 'u' to terminate");
    loop
      Pos := Robot_Mon.Get_Pos;
      Get_Immediate (Ch, Available);
      if Available then
         case Ch is
            -- Memorized mode
            when 'M' | 'm' =>
	       Put_Line("Posicion guardada");	
               Iter_Array := Iter_Array + 1; 
               Position_Mem(Iter_Array) := Robot_Mon.Get_Pos;
               Robot_Mon.Print_Pos (Position_Mem(Iter_Array));
               Put_Line("");
            --Repetition mode
            when 'P' | 'p' =>
               Robot_Mon.Reset;
                for i in 1..Iter_Array loop
		  Robot_Mon.Print_Pos (Position_Mem(i));
		  Put_Line("");
                  Move_Robot_To(Position_Mem(i));
		  delay 2.0;
                end loop;
            -- Learn mode
            when 'L' | 'l' =>
               Iter_Array := 0;
            -- Rotation keys
            when 'Q' | 'q' =>
               --Command(Rotation) := (if Command(Rotation) = Stop then To_Init else Stop);
		if Command(Rotation) = Stop then
		  Command(Rotation) := To_Init;
		else Command(Rotation) := Stop;
		end if;    
            when 'A' | 'a' =>
               --Command(Rotation) := (if Command(Rotation) = Stop then To_End else Stop);
               if Command(Rotation) = Stop then
		  Command(Rotation) := To_End;
		else Command(Rotation) := Stop;
		end if;    
            -- Forward keys
            when 'W' | 'w' =>
               --Command(Forward) := (if Command(Forward) = Stop then To_Init else Stop);
               if Command(Forward) = Stop then
		  Command(Forward) := To_Init;
		else Command(Forward) := Stop;
		end if;    
            when 'S' | 's' =>
               --Command(Forward) := (if Command(Forward) = Stop then To_End else Stop);
                if Command(Forward) = Stop then
		  Command(Forward) := To_End;
		else Command(Forward) := Stop;
		end if;    
            --  Height keys
            when 'E' | 'e' =>
               --Command(Height) := (if Command(Height) = Stop then To_Init else Stop);
                if Command(Height) = Stop then
		  Command(Height) := To_Init;
		else Command(Height) := Stop;
		end if;    
            when 'D' | 'd' =>
               --Command(Height) := (if Command(Height) = Stop then To_End else Stop);
                if Command(Height) = Stop then
		  Command(Height) := To_End;
		else Command(Height) := Stop;
		end if;
            -- Clamp keys
            when 'R' | 'r' =>
               --Command(Clamp) := (if Command(Clamp) = Stop then To_Init else Stop);
                if Command(Clamp) = Stop then
		  Command(Clamp) := To_Init;
		else Command(Clamp) := Stop;
		end if;
            when 'F' | 'f' =>
               --Command(Clamp) := (if Command(Clamp) = Stop then To_End else Stop);
               if Command(Clamp) = Stop then
		  Command(Clamp) := To_End;
		else Command(Clamp) := Stop;
		end if;
            -- Termination key
            when 'U' | 'u' =>
               exit;
            -- Any other key
            when others =>
               null;
         end case;
      end if;
      -- Check limits before applying Command
      for Ax in Axis_Type'Range loop
         if (Pos(Ax) = 0 and Command(Ax) = To_Init) or else
           (Pos(Ax) = Max_Pos(Ax) and Command(Ax) = To_End) then
            Command(Ax) := Stop;  -- Overwrite forcing commands with Stop
         end if;
      end loop;
      Move_Robot (Command);
      delay 0.02; -- Don't need a precise keyboard samplig timing in this example
   end loop;
   New_Line;
   Put_Line ("End of program");

end Learn_Rep;
