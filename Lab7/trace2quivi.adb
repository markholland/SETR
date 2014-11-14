with Ada.Text_IO, Ada.Float_Text_IO, Ada.Command_Line, Ada.Exceptions; 
use  Ada.Text_IO, Ada.Float_Text_IO, Ada.Command_Line, Ada.Exceptions;

procedure Trace2Quivi is

-- Translates the trace generated from Quisap to a 
-- quivi-compatible trace for displaying
-- Assumes fixed priorities for tasks to interpret 
-- the simple Quisap trace, based on start/stop events only
-- instead of the execution intervals used in quivi
-- Jorge Real, October 2001
--------------------------------------------------------------
--Input file format:
--------------------------------------------------------------
--<nr_of_modes>, {<mode_name>} * nr_of_modes
--<nr_of_tasks>
--{task_name {period deadline phasing priority} * nr_of_modes --(priorities are static)
--
--:body
--{event parameters}
--
--Possible events:
--MODE_CHANGE destination_mode_name time
--START_TASK task_name time
--STOP_TASK task_name time
--
-- "time" values are float nr. of seconds; "names" are strings
--------------------------------------------------------------

  type Events is (No_Event,Start_Task,Stop_Task,Mode_Change,Missed_Deadline); -- Events that can appear in the log file
  Last_Event : Events := No_Event;

  procedure Extract_Token(S:     in out String; 
                          Token: out String;
                          Size:  out Natural;
                          Event: out Events) is separate; -- Extracts token of size "size" from "String"
                                              -- "String" returned with the extracted token supressed
                                              -- "Event" assigned if the token corresponds to a predefined event

  Max_Str_Size: constant := 256;  -- Max length of an input line (see also Extract_Token)
  Max_Modes_Nr: constant := 4;
  Max_Tasks_Nr: constant := 16;
  
  type Task_Log is record
    Last_Start:      Float;
    Release_Nr:      Natural := 0;
    Last_Release_Log_At : Float;
  end record;
  The_Task: array (1..Max_Tasks_Nr) of Task_Log;  -- Registers state of the task during the translation
  
  Preempted_List: array (1..Max_Tasks_Nr) of Integer range 0..Max_Tasks_Nr := (others => 0);
  Preempted_Tasks_Nr: Integer range 0..Max_Tasks_Nr := 0;

  Task_Name: array(1..Max_Tasks_Nr) of String(1..Max_Str_Size) := (others => (others => ' '));
  Mode_Name: array(1..Max_Modes_Nr) of String(1..Max_Str_Size) := (others => (others => ' '));
  
  type Task_Profile_Record is record
    Period,
    Deadline,
    Phasing:  Float;
    Prio:     Integer;
  end record;
  type Task_Profile_Array is array (1..Max_Tasks_Nr,1..Max_Modes_Nr) of Task_Profile_Record;
  
  Task_Profile: Task_Profile_Array; -- Tasks' static profiles
  
  Modes_Nr: Integer range 1..Max_Modes_Nr; -- Actual nr of modes
  Tasks_Nr: Integer range 1..Max_Tasks_Nr; -- Actual nr of tasks


  Body_Token : constant String(1..Max_Str_Size) := 
           (1=>':',2=>'B',3=>'O',4=>'D',5=>'Y',others=>' '); -- Token indicating start of input file's body 
  Input_File,
  Output_File: File_Type;
  CRLF: constant String := Character'Val(13) & Character'Val(10); -- Carriage Return and Line Feed
  Processed_Lines : Natural := 0; -- Number of lines processed from the input file
  Str: String(1..Max_Str_Size) := (others => ' ');   -- Auxiliary to read strings from input file
  Last: Positive; -- Aux to convert strings into floats with Float_Text_IO.Get
  Token: String(1..Max_Str_Size); -- Aux to get tokens from Str
  Token_Size : Natural := 0;
  Line_Size : Natural := 0;
  Scale : constant Float := 1_000.0; -- To convert floats into integers in the output file (1000 means treat units as ms)
  
  
  Current_Mode: Integer range 1..Max_Modes_Nr := 1; -- Operating mode in course
  Old_Mode : Integer range 1..Max_Modes_Nr; -- Previous upon a MCR (the new mode is stored in Current_Mode)
  Task_In_CPU: Integer range 0..Max_Tasks_Nr := 0;  -- Task currently executing; 0 for idle CPU
  Last_Mode_Change_At : Float := 0.0; -- Time when the last mode change was requested (to calculate activations)
  Mode_Changes : Integer := 0; -- Number of mode changes occurred
  Start_Time : Float; -- Aux to calculate start time of a task execution block
  Stop_Time : Float;  -- Aux to calculate stop time of a task execution block 
  Release_Time : Float; -- Aux to calculate release time of a task
  Real_Releases : Integer; -- Aux to calculate the number of releases that should have been logged upon a MCR

            
begin
  Put_Line("Trace to quivi. Translating " & Argument(1) & " into " & Argument(2) & ".");
  Open(Input_File,In_File,Argument(1));      -- Open input file
  Create (Output_File,Out_File,Argument(2)); -- Create and open output file

  Get_Line(Input_File,Str,Line_Size);
  Processed_Lines := Processed_Lines + 1;
  Extract_Token(Str,Token,Token_Size,Last_Event); -- Number of modes
  Modes_Nr := Integer'Value(Token);
  
  for I in 1..Modes_Nr loop                         -- Write mode names to output
    Extract_Token(Str,Token,Token_Size,Last_Event); -- Mode name
    Mode_Name(I):= Token;
  end loop;

  Get_Line(Input_File,Str,Line_Size);  -- Get a new line from input file
  Processed_Lines := Processed_Lines + 1;
  Extract_Token(Str,Token,Token_Size,Last_Event); -- Nr of tasks
  Tasks_Nr:= Integer'Value(Token);

  -- Generate first line of the quivi file
  -- Version Tick_width Tick_Height Length Init_Tick Tasks_Nr
  Put(Output_File,"2.1 2 11 60000 0" & Integer'Image(Tasks_Nr) & " {");

  for T in 1..Tasks_Nr loop
    Get_Line(Input_File,Str,Line_Size);   -- Get a new line (one per task)
    Processed_Lines := Processed_Lines + 1;
    Extract_Token(Str,Token,Token_Size,Last_Event);  -- Name of the task
    Put(Output_File,Token(1..Token_Size));
    Put(Output_File," ");
    Task_Name(T) := Token;
    for M in 1..Modes_Nr loop  -- Extract task profiles for internal use
      Extract_Token(Str,Token,Token_Size,Last_Event); -- Period
      Task_Profile(T,M).Period:= Float'Value(Token);
      Extract_Token(Str,Token,Token_Size,Last_Event); -- Deadline
      Task_Profile(T,M).Deadline:= Float'Value(Token);
      Extract_Token(Str,Token,Token_Size,Last_Event); -- Initial Phase
      Task_Profile(T,M).Phasing:= Float'Value(Token);
      Extract_Token(Str,Token,Token_Size,Last_Event); -- Priority
      Task_Profile(T,M).Prio:= Integer'Value(Token);
    end loop;
  end loop;
  Put(Output_File,"} 1 Arcoiris" & CRLF);

  Get_Line(Input_File,Str,Line_Size);   -- Search :BODY
  Processed_Lines := Processed_Lines + 1;
  Extract_Token(Str,Token,Token_Size,Last_Event);  

  while Token /= Body_Token loop  -- Skip lines until body
    Extract_Token(Str,Token,Token_Size,Last_Event);
    if Token_Size = 0 then
      Get_Line(Input_File,Str,Line_Size);
      Processed_Lines := Processed_Lines + 1;
      Extract_Token(Str,Token,Token_Size,Last_Event);
    end if;
   end loop;
  
  Get_Line(Input_File,Str,Line_Size);
  Processed_Lines := Processed_Lines + 1;
  while not End_Of_File(Input_File) loop  
    Put(".");  -- Tracking progress on screen
    Extract_Token(Str,Token,Token_Size,Last_Event);  -- Obtain event

    case Last_Event is

      when Mode_Change => 
        Extract_Token(Str,Token,Token_Size,Last_Event); -- Destination mode
        Old_Mode := Current_Mode; 
        Mode_Changes := Mode_Changes + 1;
        for I in 1..Modes_Nr loop -- Obtain the mode's number 
          if Token = Mode_Name(I) then
            Current_Mode := I;  -- Assign Current_Mode
            exit;
          end if;
        end loop;
        Extract_Token(Str,Token,Token_Size,Last_Event); -- Mode change request time
        Get(Token,Start_Time,Last);  -- Start_Time is borrowed here as auxilar
        if Mode_Changes > 1 then -- Check for missed releases (skip the change to the initial mode)
          for T in 1..Tasks_Nr loop 
            if Task_Profile(T,Old_Mode).Period > 0.0 then
              Real_Releases := Integer(  -- Calculate the number of real releases
                Float'Ceiling((Start_Time - Last_Mode_Change_At - Task_Profile(T,Old_Mode).Phasing) / 
                              Task_Profile(T,Old_Mode).Period));
            else
              Real_Releases := 0;
            end if;
            for N in 1..Real_Releases - The_Task(T).Release_Nr loop -- Annotate all missed ACTIV events
              The_Task(T).Release_Nr := The_Task(T).Release_Nr + 1;
              Release_Time := Last_Mode_Change_At + 
                              Float((The_Task(T).Release_Nr - 1))*Task_Profile(T,Old_Mode).Period +
                              Task_Profile(T,Old_Mode).Phasing;
              The_Task(T).Last_Release_Log_At := Release_Time; -- Annotate last release logged

              Put(Output_File,Long_Integer'Image(Long_Integer(Release_Time*Scale)));
              Put(Output_File," {{LLEGA" & Integer'Image(T-1) & "}}" & CRLF);
              Put(Output_File,Long_Integer'Image(Long_Integer(Scale*(Release_Time + Task_Profile(T,Current_Mode).Deadline))));
              Put(Output_FIle," {{PLAZO" & Integer'Image(T-1) & "}}" & CRLF);
            end loop;
            The_Task(T).Release_Nr := 0; -- Set releases nr to 0 for all tasks in the new mode
          end loop;
        end if;
        Get(Token,Last_Mode_Change_At,Last); -- Assign Last_Mode_Change_At
        Put(Output_File,Long_Integer'Image(Long_Integer(Scale*Last_Mode_Change_At)));
        Put(Output_File," {{CMODO ");
        for L in 1..Max_Str_Size-1 loop
          Put(Output_File,Mode_Name(Current_Mode)(L)); -- Spell mode name to output file
          if Mode_Name(Current_Mode)(L+1) = ' ' then
            exit;
          end if;
        end loop;
        Put(Output_File," red }}" & CRLF);

        
      when Start_Task =>
         Extract_Token(Str,Token,Token_Size,Last_Event); -- Task name         
         for T in 1..Tasks_Nr loop
            if Token = Task_Name(T) then -- Find the task that has started
            Extract_Token(Str,Token,Token_Size,Last_Event); 
            Get(Token,Start_Time,Last); -- Obtain the start time of the task
            if Task_In_CPU /= 0 then -- A task has been preempted; generate its corresponding EXEC line
               Put(Output_File,Long_Integer'Image(Long_Integer(Scale*The_Task(Task_In_CPU).Last_Start)));
               Put(Output_File," {{C-EJE " & Integer'Image(Task_In_CPU-1) & "}}" & CRLF);
               Put(Output_File,Long_Integer'Image(Long_Integer(Scale*Start_Time)));
               Put(Output_File," {{T-EJE " & Integer'Image(Task_In_CPU-1) & "}}" & CRLF);
               Preempted_Tasks_Nr := Preempted_Tasks_Nr + 1;
               Preempted_List(Preempted_Tasks_Nr) := Task_In_CPU;
            end if;
            Task_In_CPU := T;
            The_Task(T).Last_Start := Start_Time;  -- Assign to task log
            The_Task(T).Release_Nr := The_Task(T).Release_Nr + 1;
            Release_Time := Last_Mode_Change_At + 
                            Float((The_Task(T).Release_Nr -1))*Task_Profile(T,Current_Mode).Period +
                            Task_Profile(T,Current_Mode).Phasing;
            The_Task(T).Last_Release_Log_At := Release_Time; -- Annotate last release logged
            Put(Output_File,Long_Integer'Image(Long_Integer(Release_Time*Scale)));
            Put(Output_FIle," {{LLEGA" & Integer'Image(T-1) & "}}" & CRLF);
            Put(Output_File,Long_Integer'Image(Long_Integer(Scale*(Release_Time + Task_Profile(T,Current_Mode).Deadline))));
            Put(Output_FIle," {{PLAZO" & Integer'Image(T-1) & "}}" & CRLF);
            exit;  -- There can only be one task in the CPU
          end if;
        end loop;

      when Stop_Task =>
         Extract_Token(Str,Token,Token_Size,Last_Event); -- Task name
         for T in 1..Tasks_Nr loop
            if Token = Task_Name(T) then
               Extract_Token(Str,Token,Token_Size,Last_Event); 
               Get(Token,Stop_Time,Last); -- Obtain the stop time of the task
               Put(Output_File,Long_Integer'Image(Long_Integer(Scale*The_Task(Task_In_CPU).Last_Start)));
               Put(Output_File," {{C-EJE " & Integer'Image(T-1) & "}}" & CRLF);
               Put(Output_File,Long_Integer'Image(Long_Integer(Scale*Stop_Time)));
               Put(Output_File," {{T-EJE " & Integer'Image(T-1) & "}}" & CRLF);
               Put(Output_File,Long_Integer'Image(Long_Integer(Scale*Stop_Time)));
               Put(Output_File," {{ACABA " & Integer'Image(T-1) & "}}" & CRLF);          
               if Preempted_Tasks_Nr > 0 then -- Reactivate last task preempted
                  Task_In_CPU := Preempted_List(Preempted_Tasks_Nr);
                  Preempted_Tasks_Nr := Preempted_Tasks_Nr  - 1;
                  The_Task(Task_In_CPU).Last_Start := Stop_Time;
               else
                  Task_In_CPU := 0;
               end if;    
               exit;
            end if;
        end loop;
        
      when Missed_Deadline =>
         Extract_Token(Str,Token,Token_Size,Last_Event); -- Task name
         for T in 1..Tasks_Nr loop
            if Token = Task_Name(T) then
              Extract_Token(Str,Token,Token_Size,Last_Event); -- Time of missed deadline
              Get(Token,Stop_Time,Last); -- Convert to an integer value (borrow Stop_Time variable)
              Put(Output_File,Long_Integer'Image(Long_Integer(Scale*Stop_Time)));
              Put(Output_File," {{EV-AB " & Integer'Image(T-1) & " Miss red }}" & CRLF);
              exit;
            end if;
         end loop;

      when others =>
        Put_Line(CRLF & "Unrecognised event at line" & Integer'Image(Processed_Lines));
        exit;
    end case;
    Get_Line(Input_File,Str,Line_Size); -- Get a new line from input file
    Processed_Lines := Processed_Lines + 1;
  end loop;
  
  -- Translation ended. Now close files and terminate
  Close(Input_File);
  Close(Output_File);
  Put_Line(CRLF & "Translation completed.");

exception
  when E: others =>
    Put_Line(CRLF & "### ERROR detected in input file " & Argument(1) & "###");
    Put_Line("Last line processed:" & Integer'Image(Processed_Lines));
    Put_Line("Last string processed: " & """" & Str & """");
    Put_Line(Exception_Name (E) & ". " & Exception_Information(E));
end Trace2Quivi;
