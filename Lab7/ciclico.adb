with Ada.Text_IO, Ada.Real_Time, Use_CPU, Logging_Support;
use  Ada.Text_IO, Ada.Real_Time, Use_CPU, Logging_Support;


-- Procedure ciclico
-- Implementa un ejecutivo cíclico para el siguiente conjunto de tareas:
-- Tarea     Periodo  Plazo   Cómputo Fase
--   T1       0.040   0.040    0.010   0.0 
--   T2       0.050   0.050    0.018   0.0
--   T3       0.200   0.200    0.010   0.0
--   T4       0.200   0.200    0.020   0.0 


procedure Ciclico is 
   -- Completar
   type Ciclo_Menor is mod ...; 
   Ts        : constant Time_Span := Milliseconds(...);  

   Ciclo     : Ciclo_Menor := 0;  
   Siguiente : Time; 
   CRLF      : constant String := Character'Val(13) & Character'Val(10);


   ---------------------------------------------
   --                 TAREA T1                --
   ---------------------------------------------
   procedure T1 is 
   begin
      Log (Start_Task,"T1");
      Work (10);
      Log (Stop_Task,"T1");
   end T1;

   ---------------------------------------------
   --                 TAREA T2                --
   ---------------------------------------------
   procedure T2 is 
   begin
      Log (Start_Task,"T2");
      Work (18);
      Log (Stop_Task,"T2");
   end T2;

   ---------------------------------------------
   --                 TAREA T3                --
   ---------------------------------------------
   procedure T3 is 
   begin
      Log (Start_Task,"T3");
      Work (10);
      Log (Stop_Task,"T3");
   end T3;

   ---------------------------------------------
   --                 TAREA T4                --
   ---------------------------------------------
   procedure T4 is 
   begin
      Log (Start_Task,"T4");
      Work (20);
      Log (Stop_Task,"T4");
   end T4;

begin
   Put_Line ("Comienza la ejecución del plan cíclico");
   Set_Log (On,"trace.log");
   -- Generar cabecera del fichero de traza --
   Log (No_Event,"1   NORMAL" & CRLF); -- Nr of modes
   Log (No_Event,"4" & CRLF);          -- Nr of tasks
   Log (No_Event,"T1  0.040 0.040 0.0 4" & CRLF); -- Task_name Period Deadline Phasing Priority
   Log (No_Event,"T2  0.050 0.050 0.0 3" & CRLF); 
   Log (No_Event,"T3  0.200 0.200 0.0 2" & CRLF); 
   Log (No_Event,"T4  0.200 0.200 0.0 1" & CRLF); 
   Log (No_Event,":BODY" & CRLF);
   Log (Mode_Change,"NORMAL");
   -------------------------------
   
   Siguiente := Clock;
    for I in 1..100 loop
      delay until Siguiente;
      Siguiente := Siguiente + Ts;
      case Ciclo is
         -- Completar
         when 0  => ...



      end case;
      Ciclo := Ciclo + 1;
      Put(".");
   end loop;
   Set_Log (Off);
   New_Line;
   Put_Line ("Fin de ejecución");
end Ciclico;
