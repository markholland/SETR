with Digital_IO_Sim,Robot_Interface,Robot_Monitor;
use Digital_IO_Sim,Robot_Interface,Robot_Monitor;

procedure Aprendizaje is

Ch : Character;
   Available : Boolean; -- For use with Get_Immediate
   Command : Command_Type := Stop_All; -- Ensure that initially all axis will be still
   Pos : Position;
   Simul_Max_Pos : Position := (400, 400, 400, 40); -- Simulator axis limits

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
               Command(Rotation) := (if Command(Rotation) = Stop then To_Init else Stop);
            when 'A' | 'a' =>
               Command(Rotation) := (if Command(Rotation) = Stop then To_End else Stop);
            -- Forward keys
            when 'W' | 'w' =>
               Command(Forward) := (if Command(Forward) = Stop then To_Init else Stop);
            when 'S' | 's' =>
               Command(Forward) := (if Command(Forward) = Stop then To_End else Stop);
            --  Height keys
            when 'E' | 'e' =>
               Command(Height) := (if Command(Height) = Stop then To_Init else Stop);
            when 'D' | 'd' =>
               Command(Height) := (if Command(Height) = Stop then To_End else Stop);
            -- Clamp keys
            when 'R' | 'r' =>
               Command(Clamp) := (if Command(Clamp) = Stop then To_Init else Stop);
            when 'F' | 'f' =>
               Command(Clamp) := (if Command(Clamp) = Stop then To_End else Stop);
            when 'M' | 'm' => --memorizar
               Put_Line("Saving position");
               iter := iter + 1;
               Posicion(iter) := Robot_Mon.Get_Pos;        
            when 'P' | 'p' => --repeticion
               Put_Line("Entering repetition mode.");
               Robot_Mon.Reset;
               for i in 1..iter loop
                  Move_Robot_To(Posicion(i));
               delay 2.0;
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
           (Pos(Ax) = Simul_Max_Pos(Ax) and Command(Ax) = To_End) then
            Command(Ax) := Stop;  -- Overwrite forcing commands with Stop
         end if;
      end loop;
      Move_Robot (Command);
      delay 0.02; -- Sampling rate for key presses
   end loop;
   New_Line;
   Put_Line ("End of program");

end Aprendizaje;
