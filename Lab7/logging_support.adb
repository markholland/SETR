--pragma Locking_Policy (Ceiling_Locking);

with Ada.Text_IO;
with Ada.Real_Time;           use Ada.Real_Time;
with Ada.Characters.Latin_1;  use Ada.Characters.Latin_1;
with System;
   
   package body Logging_Support is
   ------------------------------------------------------------------------
   --| Body of Package for Logging tasks activity
   --| WITH-ed by the body of a package to provide an easy way to
   --| trace events related to task activation and completion
   --| Implemented as a modification to the Debugging_Support package
   --| from Michael B. Feldman, The George Washington University 
   --| Author: Jorge Real
   --| Last Modified: November 2014
   --|                Added PO for serialised output 
   -------------------------------------------------------------------------
   
   Two_Tabs: constant String := HT & HT;
      
   Init: Time; -- := Clock;
   
   protected Serialise with Priority => System.Priority'Last is
      procedure Set_Log(Which_Way: in Switch; File_Name: String := "");
      procedure Log(Event: in Event_Type; Message: in String := "");
   private
      Logging_Is_On: Boolean := False;
      -- no debugging unless client calls Set_Log(Which_Way => On);
      Log_File: Ada.Text_IO.File_Type;
      Writing_To_File: Boolean := False;
      -- use standard output unless client gives a file name
   end Serialise;
   
   protected body Serialise is
      procedure Set_Log(Which_Way: in Switch; File_Name: String := "") is
      begin -- Set_Log
         if Which_Way = Off then
            Logging_Is_On := False;
            Ada.Text_IO.Close(Log_File);
         else
            Logging_Is_On := True;
            Init := Clock;
         -- Open log file, if any
            if File_Name /= "" then
               Writing_To_File := True;
               Ada.Text_IO.Create(File => Log_File, 
                                  Mode => Ada.Text_IO.Out_File,
                                  Name => File_Name);
            end if;
         end if;
      end Set_Log;

      procedure Log(Event: in Event_Type; Message: in String := "") is
         Time_Stamp : Time_Span;
      begin -- Log
         Time_Stamp := Clock - Init;
         if not Logging_Is_On then
            return;
         end if;
         if Writing_To_File then
           if Event /= No_Event then
             Ada.Text_IO.Put(File => Log_File, Item => Event_Type'Image(Event)& Two_Tabs & Message & Two_Tabs );
             Ada.Text_IO.Put(File => Log_File, Item => Duration'Image(To_Duration(Time_Stamp)));
             Ada.Text_IO.New_Line(File => Log_File);
           else
             Ada.Text_IO.Put(File => Log_File, Item => Message);
           end if; 
         else -- standard output
            Ada.Text_IO.Put(Item => Message & Event_Type'Image(Event));
            Ada.Text_IO.New_Line;
         end if;
      end Log;
   end Serialise;
   
  

      procedure Set_Log(Which_Way: in Switch; File_Name: String := "") is
      begin -- Set_Log
      Serialise.Set_Log (Which_Way, File_Name);
--        if Which_Way = Off then
--              Logging_Is_On := False;
--           else
--              Logging_Is_On := True;
--           -- Open debugging file, if any
--              if File_Name /= "" then
--                 Writing_To_File := True;
--                 Ada.Text_IO.Create(File => Log_File, 
--                                    Mode => Ada.Text_IO.Out_File,
--                                    Name => File_Name);
--              end if;
--           end if;
      end Set_Log;

      procedure Log(Event: in Event_Type; Message: in String := "") is
   begin -- Log
      Serialise.Log (Event, Message);
--           if not Logging_Is_On then
--              return;
--           end if;
--           if Writing_To_File then
--             if Event /= No_Event then
--               Ada.Text_IO.Put(File => Log_File, Item => Event_Type'Image(Event)& Two_Tabs & Message & Two_Tabs );
--               Ada.Text_IO.Put(File => Log_File, Item => Duration'Image(To_Duration(Clock-Init)));
--               Ada.Text_IO.New_Line(File => Log_File);
--             else
--               Ada.Text_IO.Put(File => Log_File, Item => Message);
--             end if; 
--           else -- standard output
--              Ada.Text_IO.Put(Item => Message & Event_Type'Image(Event));
--              Ada.Text_IO.New_Line;
--           end if;
      end Log;
   
   end Logging_Support;
                                                           
