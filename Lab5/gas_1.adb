-------------------------------------------
-- SETR P5 Ejercicio 1: Selective accept --
-------------------------------------------

-- Utiliza este archivo inicialmente y modifícalo para resolver los 4 ejercicios.
-- Guarda las distintas versiones como gas_1.adb, gas_2.adb, gas_3.adb y gas_4.adb


with Consolas, Ada.Real_Time;
use  Consolas, Ada.Real_Time;

procedure Gas_1 is

   -- Especificación de tareas y tipos tarea

   task Reparto is -- Rellena los depósitos de la gasolinera
      entry Start;
   end Reparto;

   task Consumidor_Gasolina is -- Consume Gasolina
      entry Start;
   end Consumidor_Gasolina;

   task Consumidor_Gasoil is -- Consume Gasoil
      entry Start;
   end Consumidor_Gasoil;

   task Gasolinera is  -- Atiende las peticiones de servicio y rellenado
      entry Start;
      entry Rellenar (Gasolina, Gasoil : in Integer);
      entry Servir_Gasolina (Pedido : in Integer);
      entry Servir_Gasoil (Pedido : in Integer);
   end Gasolinera;

   -- Cuerpo de las tareas

   task body Reparto is
      Next : Time;
      Period : Time_Span := Seconds (12);
   begin
      accept Start do
         Next := Clock;
      end Start;
      loop
         Gasolinera.Rellenar (Gasolina => 150, Gasoil => 150);
         Next := Next + Period;
         delay until Next;
      end loop;
   end Reparto;

  task body Gasolinera is
     Cantidad_Super  : Integer := 0;  -- Deposito inicial de super
     Cantidad_Gasoil : Integer := 0;  -- Deposito inicial de gasoil
  begin
     -- ------------------------------------
     --         Tarea a completar
     -- ------------------------------------
     accept Start;
     loop
        -- Aceptacion selectiva
     end loop;
  end Gasolinera;

 
   task body Consumidor_Gasolina is
      Next   : Time;
      Period : Time_Span := Milliseconds (1500);
   begin
      accept Start do
         Next := Clock;
      end Start;
      loop
         Gasolinera.Servir_Gasolina (25);
         Next := Next + Period;
         delay until Next;
      end loop;
   end Consumidor_Gasolina;

   task body Consumidor_Gasoil is
      Next   : Time;
      Period : Time_Span := Seconds (3);
   begin
      accept Start do
         Next := Clock;
      end Start;
      loop
         Gasolinera.Servir_Gasoil (40);
         Next := Next + Period;
         delay until Next;
      end loop;
   end Consumidor_Gasoil;

begin
   Gasolinera.Start;
   Reparto.Start;
   Consumidor_Gasolina.Start;
   Consumidor_Gasoil.Start;
end Gas_1;