pragma Priority_Specific_Dispatching (EDF_Across_Priorities,10,10);
--Rest of priorities covered by FIFO_Within_Priorities (ARM D.2.2(3.5/2))

pragma Locking_Policy (Ceiling_Locking);
pragma Queuing_Policy (Priority_Queuing);
--
with Ada.Text_IO, Ada.Real_Time, Ada.Dispatching.EDF, Ada.Exceptions, Use_CPU, Logging_Support, System;
use  Ada.Text_IO, Ada.Real_Time, Ada.Dispatching.EDF, Ada.Exceptions, Use_CPU, Logging_Support;

procedure Tasks_Test with
   Priority => 9 is

   Init_Time : Time := Clock + Milliseconds (20);

   CRLF : constant String :=
     Character'Val (13) & Character'Val (10); -- Auxiliary for trace file header

   task type CPU_Consumer (Period_MS   : Natural;
                           CPU_Time_MS : Natural;
                           Prio        : System.Priority;
                           Id          : Integer)
   with Priority => Prio is
      entry Start;
   end CPU_Consumer;

   task type EDF_CPU_Consumer (Period_MS   : Natural;
                               CPU_Time_MS : Natural;
                               Prio        : System.Priority;
                               Deadline_MS : Natural;
                               Id          : Integer)
   with Priority => Prio, Relative_Deadline => Milliseconds(Deadline_MS) is
      entry Start;
   end EDF_CPU_Consumer;

   -------------------------------------------------------------------------------------------------------
   --                                        System-dependent objects                                   --
   --                            Note: Header of trace file must be coherent with this                  --
   -------------------------------------------------------------------------------------------------------
   Tasks_Nr : constant := 6;
   Task_Name : array (1 .. Tasks_Nr) of String (1 .. 2) :=
     ("T1", "T2", "T3", "T4", "T5", "T6");

   -- RM tasks

   T1 : CPU_Consumer (Period_MS => 200,  CPU_Time_MS => 10, Id => 1, Prio => System.Priority'Last    );
   T2 : CPU_Consumer (Period_MS => 500,  CPU_Time_MS => 20, Id => 2, Prio => System.Priority'Last - 1);
   T3 : CPU_Consumer (Period_MS => 800,  CPU_Time_MS => 30, Id => 3, Prio => System.Priority'Last - 2);
   T4 : CPU_Consumer (Period_MS => 1000, CPU_Time_MS => 40, Id => 4, Prio => System.Priority'Last - 3);

   -- EDF tasks

   T5 : EDF_CPU_Consumer (Period_MS => 150, CPU_Time_MS => 10, Id => 5, Prio => 10, Deadline_MS => 100);
   T6 : EDF_CPU_Consumer (Period_MS => 250, CPU_Time_MS => 30, Id => 6, Prio => 10, Deadline_MS => 120);
   -------------------------------------------------------------------------------------------------------
   -------------------------------------------------------------------------------------------------------


   task body CPU_Consumer is
      Next : Time;
   begin
      accept Start; -- Wait until started from main program
      Next := Init_Time;
      loop
         Log (Event => Start_Task, Message => Task_Name (Id));
         Work (CPU_Time_MS);
         Next := Next + Milliseconds (Period_MS);
         Log (Event => Stop_Task, Message => Task_Name (Id));
         delay until Next;
      end loop;
   exception
      when E: others =>
         Put_Line (Exception_Name(E) & "--" & Exception_Message(E));
   end CPU_Consumer;

   task body EDF_CPU_Consumer is
      Next : Time;
   begin
      accept Start; -- Wait until started from main program
      Next := Init_Time;
      loop
         Log (Event => Start_Task, Message => Task_Name (Id));
         Work(CPU_Time_MS);
         Next := Next + Milliseconds (Period_MS);
         Log (Event => Stop_Task, Message => Task_Name (Id));
         Delay_Until_And_Set_Deadline (Next, Milliseconds(Deadline_MS));
      end loop;
   exception
      when E: others =>
         Put_Line (Exception_Name(E) & "--" & Exception_Message(E));
   end EDF_CPU_Consumer;



begin
   -- Generate trace file header --
   Set_Log (On, "trace.log");
   Log (No_Event, "1   NORMAL" & CRLF); -- Nr of modes
   Log (No_Event, Integer'Image(Tasks_Nr) & CRLF);          -- Nr of tasks
   --      Task_name Period  Deadline Phasing Priority (times in seconds)
   Log (No_Event, "T1  0.200 0.200 0.0 6" & CRLF);
   Log (No_Event, "T2  0.500 0.500 0.0 5" & CRLF);
   Log (No_Event, "T3  0.800 0.800 0.0 4" & CRLF);
   Log (No_Event, "T4  1.000 1.000 0.0 3" & CRLF);
   Log (No_Event, "T5  0.150 0.100 0.0 2" & CRLF);
   Log (No_Event, "T6  0.250 0.120 0.0 1" & CRLF);
   Log (No_Event, ":BODY" & CRLF);
   Init_Time := Clock;
   Log (Mode_Change, "NORMAL");
   -------------------------------

   -- Activate all tasks in decreasing priority order
   T1.Start;
   T2.Start;
   T3.Start;
   T4.Start;
   T5.Start;
   T6.Start;


   Put ("Test running for 10 seconds. Please wait... ");
   delay 10.0;
   Put ("Ending test... ");
   Set_Log (Off);

   -- Abort all tasks for normal termination
   abort T1;
   abort T2;
   abort T3;
   abort T4;
   abort T5;
   abort T6;
   Put_Line ("Tasks aborted. Test finished.");
end Tasks_Test;
