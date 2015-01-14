pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b~aprendizaje.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b~aprendizaje.adb");

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E081 : Short_Integer; pragma Import (Ada, E081, "system__os_lib_E");
   E015 : Short_Integer; pragma Import (Ada, E015, "system__soft_links_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exception_table_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "ada__io_exceptions_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "ada__tags_E");
   E067 : Short_Integer; pragma Import (Ada, E067, "ada__streams_E");
   E046 : Short_Integer; pragma Import (Ada, E046, "interfaces__c_E");
   E027 : Short_Integer; pragma Import (Ada, E027, "system__exceptions_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "system__finalization_root_E");
   E075 : Short_Integer; pragma Import (Ada, E075, "ada__finalization_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "system__os_interface_E");
   E131 : Short_Integer; pragma Import (Ada, E131, "system__interrupt_management_E");
   E094 : Short_Integer; pragma Import (Ada, E094, "system__storage_pools_E");
   E086 : Short_Integer; pragma Import (Ada, E086, "system__finalization_masters_E");
   E100 : Short_Integer; pragma Import (Ada, E100, "system__storage_pools__subpools_E");
   E137 : Short_Integer; pragma Import (Ada, E137, "system__task_info_E");
   E121 : Short_Integer; pragma Import (Ada, E121, "system__task_primitives_E");
   E127 : Short_Integer; pragma Import (Ada, E127, "system__task_primitives__operations_E");
   E008 : Short_Integer; pragma Import (Ada, E008, "ada__calendar_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "ada__calendar__delays_E");
   E096 : Short_Integer; pragma Import (Ada, E096, "system__pool_global_E");
   E084 : Short_Integer; pragma Import (Ada, E084, "system__file_control_block_E");
   E073 : Short_Integer; pragma Import (Ada, E073, "system__file_io_E");
   E019 : Short_Integer; pragma Import (Ada, E019, "system__secondary_stack_E");
   E163 : Short_Integer; pragma Import (Ada, E163, "system__tasking__initialization_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "ada__real_time_E");
   E065 : Short_Integer; pragma Import (Ada, E065, "ada__text_io_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "system__tasking__protected_objects_E");
   E165 : Short_Integer; pragma Import (Ada, E165, "system__tasking__protected_objects__entries_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "system__tasking__queuing_E");
   E175 : Short_Integer; pragma Import (Ada, E175, "system__tasking__stages_E");
   E104 : Short_Integer; pragma Import (Ada, E104, "digital_io_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "digital_io_sim_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "port_io_linux_E");
   E112 : Short_Integer; pragma Import (Ada, E112, "robot_interface_E");
   E199 : Short_Integer; pragma Import (Ada, E199, "robot_monitor_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E199 := E199 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "robot_monitor__finalize_spec");
      begin
         F1;
      end;
      E165 := E165 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F2;
      end;
      E065 := E065 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "ada__text_io__finalize_spec");
      begin
         F3;
      end;
      E086 := E086 - 1;
      E100 := E100 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__file_io__finalize_body");
      begin
         E073 := E073 - 1;
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__file_control_block__finalize_spec");
      begin
         E084 := E084 - 1;
         F5;
      end;
      E096 := E096 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__pool_global__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__storage_pools__subpools__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__finalization_masters__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");
   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := 0;
      WC_Encoding := 'b';
      Locking_Policy := 'C';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := 'F';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           True, False, False, False, False, False, False, False, 
           False, False, False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (False, False, False, True, True, False, False, False, 
           False, False, True, True, True, True, False, False, 
           True, False, False, True, True, False, True, True, 
           False, True, True, True, True, False, True, True, 
           False, True, False, False, True, False, False, False, 
           True, True, False, True, False, True, False, False, 
           False, True, False, False, False, False, False, False, 
           True, False, True, True, True, False, False, True, 
           False, False, True, False, True, True, False, True, 
           True, True, False, True, False, False, False, False, 
           False, True, True, False, True, False),
         Count => (0, 0, 0, 0, 0, 1, 5, 0, 4, 0),
         Unknown => (False, False, False, False, False, False, False, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      Finalize_Library_Objects := finalize_library'access;

      if E015 = 0 then
         System.Soft_Links'Elab_Spec;
      end if;
      if E025 = 0 then
         System.Exception_Table'Elab_Body;
      end if;
      E025 := E025 + 1;
      if E068 = 0 then
         Ada.Io_Exceptions'Elab_Spec;
      end if;
      E068 := E068 + 1;
      if E052 = 0 then
         Ada.Tags'Elab_Spec;
      end if;
      if E067 = 0 then
         Ada.Streams'Elab_Spec;
      end if;
      E067 := E067 + 1;
      if E046 = 0 then
         Interfaces.C'Elab_Spec;
      end if;
      if E027 = 0 then
         System.Exceptions'Elab_Spec;
      end if;
      E027 := E027 + 1;
      if E077 = 0 then
         System.Finalization_Root'Elab_Spec;
      end if;
      E077 := E077 + 1;
      if E075 = 0 then
         Ada.Finalization'Elab_Spec;
      end if;
      E075 := E075 + 1;
      if E123 = 0 then
         System.Os_Interface'Elab_Spec;
      end if;
      E123 := E123 + 1;
      if E094 = 0 then
         System.Storage_Pools'Elab_Spec;
      end if;
      E094 := E094 + 1;
      if E086 = 0 then
         System.Finalization_Masters'Elab_Spec;
      end if;
      if E100 = 0 then
         System.Storage_Pools.Subpools'Elab_Spec;
      end if;
      if E137 = 0 then
         System.Task_Info'Elab_Spec;
      end if;
      E137 := E137 + 1;
      if E121 = 0 then
         System.Task_Primitives'Elab_Spec;
      end if;
      E121 := E121 + 1;
      if E131 = 0 then
         System.Interrupt_Management'Elab_Body;
      end if;
      E131 := E131 + 1;
      if E127 = 0 then
         System.Task_Primitives.Operations'Elab_Body;
      end if;
      E127 := E127 + 1;
      if E008 = 0 then
         Ada.Calendar'Elab_Spec;
      end if;
      if E008 = 0 then
         Ada.Calendar'Elab_Body;
      end if;
      E008 := E008 + 1;
      if E006 = 0 then
         Ada.Calendar.Delays'Elab_Body;
      end if;
      E006 := E006 + 1;
      if E096 = 0 then
         System.Pool_Global'Elab_Spec;
      end if;
      E096 := E096 + 1;
      if E084 = 0 then
         System.File_Control_Block'Elab_Spec;
      end if;
      E084 := E084 + 1;
      if E073 = 0 then
         System.File_Io'Elab_Body;
      end if;
      E073 := E073 + 1;
      E100 := E100 + 1;
      if E086 = 0 then
         System.Finalization_Masters'Elab_Body;
      end if;
      E086 := E086 + 1;
      E046 := E046 + 1;
      if E052 = 0 then
         Ada.Tags'Elab_Body;
      end if;
      E052 := E052 + 1;
      if E015 = 0 then
         System.Soft_Links'Elab_Body;
      end if;
      E015 := E015 + 1;
      if E081 = 0 then
         System.Os_Lib'Elab_Body;
      end if;
      E081 := E081 + 1;
      if E019 = 0 then
         System.Secondary_Stack'Elab_Body;
      end if;
      E019 := E019 + 1;
      if E163 = 0 then
         System.Tasking.Initialization'Elab_Body;
      end if;
      E163 := E163 + 1;
      if E116 = 0 then
         Ada.Real_Time'Elab_Spec;
      end if;
      if E116 = 0 then
         Ada.Real_Time'Elab_Body;
      end if;
      E116 := E116 + 1;
      if E065 = 0 then
         Ada.Text_Io'Elab_Spec;
      end if;
      if E065 = 0 then
         Ada.Text_Io'Elab_Body;
      end if;
      E065 := E065 + 1;
      if E151 = 0 then
         System.Tasking.Protected_Objects'Elab_Body;
      end if;
      E151 := E151 + 1;
      if E165 = 0 then
         System.Tasking.Protected_Objects.Entries'Elab_Spec;
      end if;
      E165 := E165 + 1;
      if E169 = 0 then
         System.Tasking.Queuing'Elab_Body;
      end if;
      E169 := E169 + 1;
      if E175 = 0 then
         System.Tasking.Stages'Elab_Body;
      end if;
      E175 := E175 + 1;
      if E114 = 0 then
         Digital_Io_Sim'Elab_Body;
      end if;
      E114 := E114 + 1;
      if E106 = 0 then
         Port_Io_Linux'Elab_Body;
      end if;
      E106 := E106 + 1;
      E104 := E104 + 1;
      if E112 = 0 then
         Robot_Interface'Elab_Body;
      end if;
      E112 := E112 + 1;
      if E199 = 0 then
         Robot_Monitor'Elab_Spec;
      end if;
      if E199 = 0 then
         Robot_Monitor'Elab_Body;
      end if;
      E199 := E199 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_aprendizaje");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   ./low_level_types.o
   --   ./digital_io_sim.o
   --   ./port_io_linux.o
   --   ./digital_io.o
   --   ./robot_interface.o
   --   ./robot_monitor.o
   --   ./aprendizaje.o
   --   -L./
   --   -L/home/markholland/gnat/lib/gcc/i686-pc-linux-gnu/4.7.4/rts-marteuc_x86/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
   --   -lmarte
   --   -lgnat
--  END Object file/option list   

end ada_main;
