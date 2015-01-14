pragma Ada_95;
with System;
package ada_main is
   pragma Warnings (Off);

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2014 (20140331)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_aprendizaje" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#0ac6982d#;
   pragma Export (C, u00001, "aprendizajeB");
   u00002 : constant Version_32 := 16#fbff4c67#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#81ea5798#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#7bf4f215#;
   pragma Export (C, u00005, "ada__calendar__delaysB");
   u00006 : constant Version_32 := 16#474dd4b1#;
   pragma Export (C, u00006, "ada__calendar__delaysS");
   u00007 : constant Version_32 := 16#65712768#;
   pragma Export (C, u00007, "ada__calendarB");
   u00008 : constant Version_32 := 16#e791e294#;
   pragma Export (C, u00008, "ada__calendarS");
   u00009 : constant Version_32 := 16#108bcef8#;
   pragma Export (C, u00009, "ada__exceptionsB");
   u00010 : constant Version_32 := 16#b7e3d12a#;
   pragma Export (C, u00010, "ada__exceptionsS");
   u00011 : constant Version_32 := 16#032105bb#;
   pragma Export (C, u00011, "ada__exceptions__last_chance_handlerB");
   u00012 : constant Version_32 := 16#2b293877#;
   pragma Export (C, u00012, "ada__exceptions__last_chance_handlerS");
   u00013 : constant Version_32 := 16#820bee89#;
   pragma Export (C, u00013, "systemS");
   u00014 : constant Version_32 := 16#daf76b33#;
   pragma Export (C, u00014, "system__soft_linksB");
   u00015 : constant Version_32 := 16#c8d48bbb#;
   pragma Export (C, u00015, "system__soft_linksS");
   u00016 : constant Version_32 := 16#c8ed38da#;
   pragma Export (C, u00016, "system__parametersB");
   u00017 : constant Version_32 := 16#84d1763b#;
   pragma Export (C, u00017, "system__parametersS");
   u00018 : constant Version_32 := 16#c96bf39e#;
   pragma Export (C, u00018, "system__secondary_stackB");
   u00019 : constant Version_32 := 16#296a21e0#;
   pragma Export (C, u00019, "system__secondary_stackS");
   u00020 : constant Version_32 := 16#39a03df9#;
   pragma Export (C, u00020, "system__storage_elementsB");
   u00021 : constant Version_32 := 16#afc8a48d#;
   pragma Export (C, u00021, "system__storage_elementsS");
   u00022 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00022, "system__stack_checkingB");
   u00023 : constant Version_32 := 16#0cb48561#;
   pragma Export (C, u00023, "system__stack_checkingS");
   u00024 : constant Version_32 := 16#393398c1#;
   pragma Export (C, u00024, "system__exception_tableB");
   u00025 : constant Version_32 := 16#2c12889c#;
   pragma Export (C, u00025, "system__exception_tableS");
   u00026 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00026, "system__exceptionsB");
   u00027 : constant Version_32 := 16#ea68837f#;
   pragma Export (C, u00027, "system__exceptionsS");
   u00028 : constant Version_32 := 16#b895431d#;
   pragma Export (C, u00028, "system__exceptions_debugB");
   u00029 : constant Version_32 := 16#31e9f737#;
   pragma Export (C, u00029, "system__exceptions_debugS");
   u00030 : constant Version_32 := 16#570325c8#;
   pragma Export (C, u00030, "system__img_intB");
   u00031 : constant Version_32 := 16#80d00e4b#;
   pragma Export (C, u00031, "system__img_intS");
   u00032 : constant Version_32 := 16#ff5c7695#;
   pragma Export (C, u00032, "system__tracebackB");
   u00033 : constant Version_32 := 16#aa0f71d4#;
   pragma Export (C, u00033, "system__tracebackS");
   u00034 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00034, "system__wch_conB");
   u00035 : constant Version_32 := 16#9976cc5b#;
   pragma Export (C, u00035, "system__wch_conS");
   u00036 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00036, "system__wch_stwB");
   u00037 : constant Version_32 := 16#b467e05a#;
   pragma Export (C, u00037, "system__wch_stwS");
   u00038 : constant Version_32 := 16#9b29844d#;
   pragma Export (C, u00038, "system__wch_cnvB");
   u00039 : constant Version_32 := 16#96c176a8#;
   pragma Export (C, u00039, "system__wch_cnvS");
   u00040 : constant Version_32 := 16#69adb1b9#;
   pragma Export (C, u00040, "interfacesS");
   u00041 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00041, "system__wch_jisB");
   u00042 : constant Version_32 := 16#16b16f89#;
   pragma Export (C, u00042, "system__wch_jisS");
   u00043 : constant Version_32 := 16#8cb17bcd#;
   pragma Export (C, u00043, "system__traceback_entriesB");
   u00044 : constant Version_32 := 16#371a8e1b#;
   pragma Export (C, u00044, "system__traceback_entriesS");
   u00045 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00045, "interfaces__cB");
   u00046 : constant Version_32 := 16#3b563890#;
   pragma Export (C, u00046, "interfaces__cS");
   u00047 : constant Version_32 := 16#22d03640#;
   pragma Export (C, u00047, "system__os_primitivesB");
   u00048 : constant Version_32 := 16#32da62a0#;
   pragma Export (C, u00048, "system__os_primitivesS");
   u00049 : constant Version_32 := 16#ee80728a#;
   pragma Export (C, u00049, "system__tracesB");
   u00050 : constant Version_32 := 16#70168623#;
   pragma Export (C, u00050, "system__tracesS");
   u00051 : constant Version_32 := 16#034d7998#;
   pragma Export (C, u00051, "ada__tagsB");
   u00052 : constant Version_32 := 16#ce72c228#;
   pragma Export (C, u00052, "ada__tagsS");
   u00053 : constant Version_32 := 16#c3335bfd#;
   pragma Export (C, u00053, "system__htableB");
   u00054 : constant Version_32 := 16#06c95d63#;
   pragma Export (C, u00054, "system__htableS");
   u00055 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00055, "system__string_hashB");
   u00056 : constant Version_32 := 16#a497361d#;
   pragma Export (C, u00056, "system__string_hashS");
   u00057 : constant Version_32 := 16#d30d7c26#;
   pragma Export (C, u00057, "system__unsigned_typesS");
   u00058 : constant Version_32 := 16#4266b2a8#;
   pragma Export (C, u00058, "system__val_unsB");
   u00059 : constant Version_32 := 16#c3a5911d#;
   pragma Export (C, u00059, "system__val_unsS");
   u00060 : constant Version_32 := 16#27b600b2#;
   pragma Export (C, u00060, "system__val_utilB");
   u00061 : constant Version_32 := 16#2eab5877#;
   pragma Export (C, u00061, "system__val_utilS");
   u00062 : constant Version_32 := 16#d1060688#;
   pragma Export (C, u00062, "system__case_utilB");
   u00063 : constant Version_32 := 16#a602875e#;
   pragma Export (C, u00063, "system__case_utilS");
   u00064 : constant Version_32 := 16#d3ebeffa#;
   pragma Export (C, u00064, "ada__text_ioB");
   u00065 : constant Version_32 := 16#675daa57#;
   pragma Export (C, u00065, "ada__text_ioS");
   u00066 : constant Version_32 := 16#1b5643e2#;
   pragma Export (C, u00066, "ada__streamsB");
   u00067 : constant Version_32 := 16#2564c958#;
   pragma Export (C, u00067, "ada__streamsS");
   u00068 : constant Version_32 := 16#db5c917c#;
   pragma Export (C, u00068, "ada__io_exceptionsS");
   u00069 : constant Version_32 := 16#9f23726e#;
   pragma Export (C, u00069, "interfaces__c_streamsB");
   u00070 : constant Version_32 := 16#bb1012c3#;
   pragma Export (C, u00070, "interfaces__c_streamsS");
   u00071 : constant Version_32 := 16#a8d053ac#;
   pragma Export (C, u00071, "system__crtlS");
   u00072 : constant Version_32 := 16#967994fc#;
   pragma Export (C, u00072, "system__file_ioB");
   u00073 : constant Version_32 := 16#3efb028f#;
   pragma Export (C, u00073, "system__file_ioS");
   u00074 : constant Version_32 := 16#b7ab275c#;
   pragma Export (C, u00074, "ada__finalizationB");
   u00075 : constant Version_32 := 16#19f764ca#;
   pragma Export (C, u00075, "ada__finalizationS");
   u00076 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00076, "system__finalization_rootB");
   u00077 : constant Version_32 := 16#cdf99d19#;
   pragma Export (C, u00077, "system__finalization_rootS");
   u00078 : constant Version_32 := 16#d0432c8d#;
   pragma Export (C, u00078, "system__img_enum_newB");
   u00079 : constant Version_32 := 16#e347e849#;
   pragma Export (C, u00079, "system__img_enum_newS");
   u00080 : constant Version_32 := 16#7f98a7e4#;
   pragma Export (C, u00080, "system__os_libB");
   u00081 : constant Version_32 := 16#94c13856#;
   pragma Export (C, u00081, "system__os_libS");
   u00082 : constant Version_32 := 16#1a817b8e#;
   pragma Export (C, u00082, "system__stringsB");
   u00083 : constant Version_32 := 16#fcb4ffef#;
   pragma Export (C, u00083, "system__stringsS");
   u00084 : constant Version_32 := 16#4dac4f57#;
   pragma Export (C, u00084, "system__file_control_blockS");
   u00085 : constant Version_32 := 16#a4371844#;
   pragma Export (C, u00085, "system__finalization_mastersB");
   u00086 : constant Version_32 := 16#f61dc7c9#;
   pragma Export (C, u00086, "system__finalization_mastersS");
   u00087 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00087, "system__address_imageB");
   u00088 : constant Version_32 := 16#23e773b3#;
   pragma Export (C, u00088, "system__address_imageS");
   u00089 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00089, "system__img_boolB");
   u00090 : constant Version_32 := 16#77d29f62#;
   pragma Export (C, u00090, "system__img_boolS");
   u00091 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00091, "system__ioB");
   u00092 : constant Version_32 := 16#1c4919c6#;
   pragma Export (C, u00092, "system__ioS");
   u00093 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00093, "system__storage_poolsB");
   u00094 : constant Version_32 := 16#7750690d#;
   pragma Export (C, u00094, "system__storage_poolsS");
   u00095 : constant Version_32 := 16#e34550ca#;
   pragma Export (C, u00095, "system__pool_globalB");
   u00096 : constant Version_32 := 16#c88d2d16#;
   pragma Export (C, u00096, "system__pool_globalS");
   u00097 : constant Version_32 := 16#d6f619bb#;
   pragma Export (C, u00097, "system__memoryB");
   u00098 : constant Version_32 := 16#db7688bd#;
   pragma Export (C, u00098, "system__memoryS");
   u00099 : constant Version_32 := 16#7b002481#;
   pragma Export (C, u00099, "system__storage_pools__subpoolsB");
   u00100 : constant Version_32 := 16#e3b008dc#;
   pragma Export (C, u00100, "system__storage_pools__subpoolsS");
   u00101 : constant Version_32 := 16#63f11652#;
   pragma Export (C, u00101, "system__storage_pools__subpools__finalizationB");
   u00102 : constant Version_32 := 16#fe2f4b3a#;
   pragma Export (C, u00102, "system__storage_pools__subpools__finalizationS");
   u00103 : constant Version_32 := 16#bd2abc63#;
   pragma Export (C, u00103, "digital_ioB");
   u00104 : constant Version_32 := 16#4b9698b8#;
   pragma Export (C, u00104, "digital_ioS");
   u00105 : constant Version_32 := 16#cbe83689#;
   pragma Export (C, u00105, "port_io_linuxB");
   u00106 : constant Version_32 := 16#7ea591d0#;
   pragma Export (C, u00106, "port_io_linuxS");
   u00107 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00107, "system__concat_2B");
   u00108 : constant Version_32 := 16#80ab3959#;
   pragma Export (C, u00108, "system__concat_2S");
   u00109 : constant Version_32 := 16#8db09547#;
   pragma Export (C, u00109, "system__machine_codeS");
   u00110 : constant Version_32 := 16#607f16d8#;
   pragma Export (C, u00110, "low_level_typesS");
   u00111 : constant Version_32 := 16#19198c00#;
   pragma Export (C, u00111, "robot_interfaceB");
   u00112 : constant Version_32 := 16#a37f0c5d#;
   pragma Export (C, u00112, "robot_interfaceS");
   u00113 : constant Version_32 := 16#f3f2f93c#;
   pragma Export (C, u00113, "digital_io_simB");
   u00114 : constant Version_32 := 16#52879741#;
   pragma Export (C, u00114, "digital_io_simS");
   u00115 : constant Version_32 := 16#95dd9521#;
   pragma Export (C, u00115, "ada__real_timeB");
   u00116 : constant Version_32 := 16#42a49de8#;
   pragma Export (C, u00116, "ada__real_timeS");
   u00117 : constant Version_32 := 16#1607bce4#;
   pragma Export (C, u00117, "system__arith_64B");
   u00118 : constant Version_32 := 16#abebfac2#;
   pragma Export (C, u00118, "system__arith_64S");
   u00119 : constant Version_32 := 16#ca392521#;
   pragma Export (C, u00119, "system__taskingB");
   u00120 : constant Version_32 := 16#f5c19b9a#;
   pragma Export (C, u00120, "system__taskingS");
   u00121 : constant Version_32 := 16#33b3ce66#;
   pragma Export (C, u00121, "system__task_primitivesS");
   u00122 : constant Version_32 := 16#941b8271#;
   pragma Export (C, u00122, "system__os_interfaceB");
   u00123 : constant Version_32 := 16#537105aa#;
   pragma Export (C, u00123, "system__os_interfaceS");
   u00124 : constant Version_32 := 16#3cf531dc#;
   pragma Export (C, u00124, "system__linuxS");
   u00125 : constant Version_32 := 16#b02a62be#;
   pragma Export (C, u00125, "system__os_constantsS");
   u00126 : constant Version_32 := 16#0d37206f#;
   pragma Export (C, u00126, "system__task_primitives__operationsB");
   u00127 : constant Version_32 := 16#cf8dfb31#;
   pragma Export (C, u00127, "system__task_primitives__operationsS");
   u00128 : constant Version_32 := 16#ea8d9160#;
   pragma Export (C, u00128, "system__bit_opsB");
   u00129 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00129, "system__bit_opsS");
   u00130 : constant Version_32 := 16#903909a4#;
   pragma Export (C, u00130, "system__interrupt_managementB");
   u00131 : constant Version_32 := 16#35ded653#;
   pragma Export (C, u00131, "system__interrupt_managementS");
   u00132 : constant Version_32 := 16#f65595cf#;
   pragma Export (C, u00132, "system__multiprocessorsB");
   u00133 : constant Version_32 := 16#baa771fa#;
   pragma Export (C, u00133, "system__multiprocessorsS");
   u00134 : constant Version_32 := 16#3c04b2bf#;
   pragma Export (C, u00134, "system__stack_checking__operationsB");
   u00135 : constant Version_32 := 16#64c2cb2b#;
   pragma Export (C, u00135, "system__stack_checking__operationsS");
   u00136 : constant Version_32 := 16#375a3ef7#;
   pragma Export (C, u00136, "system__task_infoB");
   u00137 : constant Version_32 := 16#0d7a5b9c#;
   pragma Export (C, u00137, "system__task_infoS");
   u00138 : constant Version_32 := 16#9eee2fc2#;
   pragma Export (C, u00138, "system__tasking__debugB");
   u00139 : constant Version_32 := 16#bb93797c#;
   pragma Export (C, u00139, "system__tasking__debugS");
   u00140 : constant Version_32 := 16#4bc4ed76#;
   pragma Export (C, u00140, "system__stack_usageB");
   u00141 : constant Version_32 := 16#09222097#;
   pragma Export (C, u00141, "system__stack_usageS");
   u00142 : constant Version_32 := 16#d6a5fa34#;
   pragma Export (C, u00142, "ada__real_time__delaysB");
   u00143 : constant Version_32 := 16#6becaccd#;
   pragma Export (C, u00143, "ada__real_time__delaysS");
   u00144 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00144, "system__concat_3B");
   u00145 : constant Version_32 := 16#897bb22c#;
   pragma Export (C, u00145, "system__concat_3S");
   u00146 : constant Version_32 := 16#932a4690#;
   pragma Export (C, u00146, "system__concat_4B");
   u00147 : constant Version_32 := 16#fc6fc5a9#;
   pragma Export (C, u00147, "system__concat_4S");
   u00148 : constant Version_32 := 16#608e2cd1#;
   pragma Export (C, u00148, "system__concat_5B");
   u00149 : constant Version_32 := 16#0555ada7#;
   pragma Export (C, u00149, "system__concat_5S");
   u00150 : constant Version_32 := 16#a00eee25#;
   pragma Export (C, u00150, "system__tasking__protected_objectsB");
   u00151 : constant Version_32 := 16#36656f16#;
   pragma Export (C, u00151, "system__tasking__protected_objectsS");
   u00152 : constant Version_32 := 16#c587dd0c#;
   pragma Export (C, u00152, "system__soft_links__taskingB");
   u00153 : constant Version_32 := 16#e47ef8be#;
   pragma Export (C, u00153, "system__soft_links__taskingS");
   u00154 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00154, "ada__exceptions__is_null_occurrenceB");
   u00155 : constant Version_32 := 16#8b1b3b36#;
   pragma Export (C, u00155, "ada__exceptions__is_null_occurrenceS");
   u00156 : constant Version_32 := 16#d6b24de5#;
   pragma Export (C, u00156, "system__tasking__rendezvousB");
   u00157 : constant Version_32 := 16#35a93978#;
   pragma Export (C, u00157, "system__tasking__rendezvousS");
   u00158 : constant Version_32 := 16#100eaf58#;
   pragma Export (C, u00158, "system__restrictionsB");
   u00159 : constant Version_32 := 16#ce87e357#;
   pragma Export (C, u00159, "system__restrictionsS");
   u00160 : constant Version_32 := 16#231a83de#;
   pragma Export (C, u00160, "system__tasking__entry_callsB");
   u00161 : constant Version_32 := 16#bcd33659#;
   pragma Export (C, u00161, "system__tasking__entry_callsS");
   u00162 : constant Version_32 := 16#08b993e8#;
   pragma Export (C, u00162, "system__tasking__initializationB");
   u00163 : constant Version_32 := 16#abc6a10c#;
   pragma Export (C, u00163, "system__tasking__initializationS");
   u00164 : constant Version_32 := 16#e011f681#;
   pragma Export (C, u00164, "system__tasking__protected_objects__entriesB");
   u00165 : constant Version_32 := 16#7671a6ef#;
   pragma Export (C, u00165, "system__tasking__protected_objects__entriesS");
   u00166 : constant Version_32 := 16#d7d2b300#;
   pragma Export (C, u00166, "system__tasking__protected_objects__operationsB");
   u00167 : constant Version_32 := 16#fae24494#;
   pragma Export (C, u00167, "system__tasking__protected_objects__operationsS");
   u00168 : constant Version_32 := 16#4a7c3c75#;
   pragma Export (C, u00168, "system__tasking__queuingB");
   u00169 : constant Version_32 := 16#64c7d8f4#;
   pragma Export (C, u00169, "system__tasking__queuingS");
   u00170 : constant Version_32 := 16#2052398a#;
   pragma Export (C, u00170, "system__tasking__utilitiesB");
   u00171 : constant Version_32 := 16#60ed07eb#;
   pragma Export (C, u00171, "system__tasking__utilitiesS");
   u00172 : constant Version_32 := 16#bd6fc52e#;
   pragma Export (C, u00172, "system__traces__taskingB");
   u00173 : constant Version_32 := 16#6a6148e0#;
   pragma Export (C, u00173, "system__traces__taskingS");
   u00174 : constant Version_32 := 16#b9c85017#;
   pragma Export (C, u00174, "system__tasking__stagesB");
   u00175 : constant Version_32 := 16#58d36a7f#;
   pragma Export (C, u00175, "system__tasking__stagesS");
   u00176 : constant Version_32 := 16#f8f38c17#;
   pragma Export (C, u00176, "system__val_intB");
   u00177 : constant Version_32 := 16#caaec4b6#;
   pragma Export (C, u00177, "system__val_intS");
   u00178 : constant Version_32 := 16#f64b89a4#;
   pragma Export (C, u00178, "ada__integer_text_ioB");
   u00179 : constant Version_32 := 16#f1daf268#;
   pragma Export (C, u00179, "ada__integer_text_ioS");
   u00180 : constant Version_32 := 16#f6fdca1c#;
   pragma Export (C, u00180, "ada__text_io__integer_auxB");
   u00181 : constant Version_32 := 16#b9793d30#;
   pragma Export (C, u00181, "ada__text_io__integer_auxS");
   u00182 : constant Version_32 := 16#e0da2b08#;
   pragma Export (C, u00182, "ada__text_io__generic_auxB");
   u00183 : constant Version_32 := 16#a6c327d3#;
   pragma Export (C, u00183, "ada__text_io__generic_auxS");
   u00184 : constant Version_32 := 16#d48b4eeb#;
   pragma Export (C, u00184, "system__img_biuB");
   u00185 : constant Version_32 := 16#152ff46b#;
   pragma Export (C, u00185, "system__img_biuS");
   u00186 : constant Version_32 := 16#2b864520#;
   pragma Export (C, u00186, "system__img_llbB");
   u00187 : constant Version_32 := 16#54e8e495#;
   pragma Export (C, u00187, "system__img_llbS");
   u00188 : constant Version_32 := 16#9777733a#;
   pragma Export (C, u00188, "system__img_lliB");
   u00189 : constant Version_32 := 16#9344bb58#;
   pragma Export (C, u00189, "system__img_lliS");
   u00190 : constant Version_32 := 16#c2d63ebb#;
   pragma Export (C, u00190, "system__img_llwB");
   u00191 : constant Version_32 := 16#fd84c703#;
   pragma Export (C, u00191, "system__img_llwS");
   u00192 : constant Version_32 := 16#8ed53197#;
   pragma Export (C, u00192, "system__img_wiuB");
   u00193 : constant Version_32 := 16#7b6e73f9#;
   pragma Export (C, u00193, "system__img_wiuS");
   u00194 : constant Version_32 := 16#e892b88e#;
   pragma Export (C, u00194, "system__val_lliB");
   u00195 : constant Version_32 := 16#182f0829#;
   pragma Export (C, u00195, "system__val_lliS");
   u00196 : constant Version_32 := 16#1e25d3f1#;
   pragma Export (C, u00196, "system__val_lluB");
   u00197 : constant Version_32 := 16#a9ff2b54#;
   pragma Export (C, u00197, "system__val_lluS");
   u00198 : constant Version_32 := 16#79f6e606#;
   pragma Export (C, u00198, "robot_monitorB");
   u00199 : constant Version_32 := 16#63928ed2#;
   pragma Export (C, u00199, "robot_monitorS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  interfaces%s
   --  system%s
   --  system.arith_64%s
   --  system.case_util%s
   --  system.case_util%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.io%s
   --  system.io%b
   --  system.linux%s
   --  system.machine_code%s
   --  system.multiprocessors%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_checking.operations%s
   --  system.stack_usage%s
   --  system.stack_usage%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.os_lib%s
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  system.arith_64%b
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  system.soft_links%s
   --  system.stack_checking.operations%b
   --  system.traces%s
   --  system.traces%b
   --  system.unsigned_types%s
   --  system.img_biu%s
   --  system.img_biu%b
   --  system.img_llb%s
   --  system.img_llb%b
   --  system.img_llw%s
   --  system.img_llw%b
   --  system.img_wiu%s
   --  system.img_wiu%b
   --  system.val_int%s
   --  system.val_lli%s
   --  system.val_llu%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_llu%b
   --  system.val_lli%b
   --  system.val_int%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  system.address_image%s
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.io_exceptions%s
   --  ada.tags%s
   --  ada.streams%s
   --  ada.streams%b
   --  interfaces.c%s
   --  system.multiprocessors%b
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.task_primitives%s
   --  system.interrupt_management%b
   --  system.tasking%s
   --  system.task_primitives.operations%s
   --  system.tasking%b
   --  system.tasking.debug%s
   --  system.task_primitives.operations%b
   --  system.traces.tasking%s
   --  system.traces.tasking%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.delays%s
   --  ada.calendar.delays%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  system.file_control_block%s
   --  system.file_io%s
   --  system.secondary_stack%s
   --  system.file_io%b
   --  system.tasking.debug%b
   --  system.storage_pools.subpools%b
   --  system.finalization_masters%b
   --  interfaces.c%b
   --  ada.tags%b
   --  system.soft_links%b
   --  system.os_lib%b
   --  system.secondary_stack%b
   --  system.address_image%b
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.tasking.entry_calls%s
   --  system.tasking.initialization%s
   --  system.tasking.utilities%s
   --  system.traceback%s
   --  ada.exceptions%b
   --  system.traceback%b
   --  system.tasking.initialization%b
   --  ada.real_time%s
   --  ada.real_time%b
   --  ada.real_time.delays%s
   --  ada.real_time.delays%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.integer_aux%s
   --  ada.text_io.integer_aux%b
   --  ada.integer_text_io%s
   --  ada.integer_text_io%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.protected_objects.entries%s
   --  system.tasking.protected_objects.entries%b
   --  system.tasking.queuing%s
   --  system.tasking.queuing%b
   --  system.tasking.utilities%b
   --  system.tasking.rendezvous%s
   --  system.tasking.protected_objects.operations%s
   --  system.tasking.protected_objects.operations%b
   --  system.tasking.rendezvous%b
   --  system.tasking.entry_calls%b
   --  system.tasking.stages%s
   --  system.tasking.stages%b
   --  low_level_types%s
   --  digital_io%s
   --  digital_io_sim%s
   --  digital_io_sim%b
   --  port_io_linux%s
   --  port_io_linux%b
   --  digital_io%b
   --  robot_interface%s
   --  robot_interface%b
   --  robot_monitor%s
   --  robot_monitor%b
   --  aprendizaje%b
   --  END ELABORATION ORDER


end ada_main;
