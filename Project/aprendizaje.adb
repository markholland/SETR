with Digital_IO,Robot_Interface,Robot_Monitor,Ada.Text_IO;
use Digital_IO,Robot_Interface,Robot_Monitor,Ada.Text_IO;

procedure Aprendizaje is

Ch : Character;
   Available : Boolean; -- For use with Get_Immediate
   Command : Command_Type := Stop_All; -- Ensure that initially all axis will be still
   Pos : Position;
   --Simul_Max_Pos : Position := (400, 400, 400, 40); -- Simulator axis limits
   Max_Pos : Position := (239, 149, 234, 40);
   iter : Integer := 0; -- The first element won't hold a position
   type Posiciones is array (0..400) of Position;

   Posicion : Posiciones;

begin
   Robot_Mon.Reset;
   Put_Line ("Move the robot axis with (q,a,w,s,e,d,r,f), 'm' to remember the current position, 'p' to repeat known movements, 'l' to reenter learning mode and forget known positions, 'u' to end the program.");
    loop
      Pos := Robot_Mon.Get_Pos;
      Get_Immediate (Ch, Available);
      if Available then
         case Ch is
            -- Rotation keys
            when 'Q' | 'q' =>
              if Command(Rotation) = Stop then 
		            Command(Rotation) := To_Init;
	            else
		            Command(Rotation) := Stop;
	            end if;  
            when 'A' | 'a' =>
              if Command(Rotation) = Stop then
		            Command(Rotation) := To_End;
	            else 
                Command(Rotation) := Stop;
	            end if;  
            -- Forward keys
            when 'W' | 'w' =>
              if Command(Forward) = Stop then
		            Command(Forward) := To_Init;
		          else 
                Command(Forward) := Stop;
		          end if; 
            when 'S' | 's' =>
              if Command(Forward) = Stop then
		            Command(Forward) := To_End;
		          else 
                Command(Forward) := Stop;
		          end if; 
            --  Height keys
            when 'E' | 'e' =>
              if Command(Height) = Stop then
		            Command(Height) := To_Init;
		          else 
                Command(Height) := Stop;
		          end if;  
            when 'D' | 'd' =>
              if Command(Height) = Stop then
		            Command(Height) := To_End;
		          else 
                Command(Height) := Stop;
		          end if;
            -- Clamp keys
            when 'R' | 'r' =>
              if Command(Clamp) = Stop then
		            Command(Clamp) := To_Init;
		          else 
                Command(Clamp) := Stop;
		          end if;
            when 'F' | 'f' =>
              if Command(Clamp) = Stop then
		            Command(Clamp) := To_End;
		          else 
                Command(Clamp) := Stop;
		          end if;
            when 'M' | 'm' => --memorizar
               Put_Line("Saving position");
               iter := iter + 1;
               Posicion(iter) := Robot_Mon.Get_Pos;
               Robot_Mon.Print_Pos (Posicion(iter));
               Put_Line("");
            when 'P' | 'p' => --repeticion
               Put_Line("Entering repetition mode.");
               Robot_Mon.Reset;
               delay 2.0;
               for i in 1..iter loop
                  Robot_Mon.Print_Pos(Posicion(i));
                  Put_Line("");
                  Move_Robot_To(Posicion(i));
                  delay 2.0;     -- 2 second pause inbetween movements
               end loop;
               Put_Line("Completed all known movements.");
            when 'L' | 'l' =>
               iter := 0;
               Put_Line("Entering learning mode, previous positions have been forgotten.");
               -- Termination key
            when 'U' | 'u' =>
               exit;
            -- Any other key
            when others =>
               null;
         end case;
      end if;
      -- Check limits before applying Commands
      for Ax in Axis_Type'Range loop
         if (Pos(Ax) = 0 and Command(Ax) = To_Init) or else
           (Pos(Ax) = Max_Pos(Ax) and Command(Ax) = To_End) then
            Command(Ax) := Stop;  -- Overwrite forcing commands with Stop
         end if;
      end loop;
      Move_Robot (Command);
      delay 0.02; -- Sampling rate for key presses
   end loop;
   New_Line;
   Put_Line ("End of program");

end Aprendizaje;
