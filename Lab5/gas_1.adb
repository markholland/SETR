-------------------------------------------
-- SETR P5 Ejercicio 1: Selective accept --
-------------------------------------------

-- Utiliza este archivo inicialmente y modifícalo para resolver los 4 ejercicios.
-- Guarda las distintas versiones como gas_1.adb, gas_2.adb, gas_3.adb y gas_4.adb


with Consolas, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO;
use  Consolas, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO;

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
        select
          accept Rellenar (Gasolina, Gasoil : in Integer) do
            Cantidad_Super := Cantidad_Super + Gasolina;
            Cantidad_Gasoil := Cantidad_Gasoil + Gasoil;
            Put_Line("### RELLENADO:"&Integer'Image(Gasolina)& " litros de GASOLINA y "&Integer'Image(Gasoil)&" litros de GASOIL");
          end Rellenar;
          or
          accept Servir_Gasolina(Pedido : in Integer) do
            if Pedido > Cantidad_Super then
              Put_Line("-_- DEPOSITO GASOLINA VACIO. Servidos "&Integer'Image(Cantidad_Super)&" litros.");
              Cantidad_Super := 0;
            else
              Cantidad_Super := Cantidad_Super - Pedido;
              Put_Line("--> SERVICIO GASOLINA:" &Integer'Image(Pedido)& "; Quedan "&Integer'Image(Cantidad_Super)&" litros de GASOLINA.");
            end if;
          end Servir_Gasolina;
          or
          accept Servir_Gasoil(Pedido : in Integer) do
            if Pedido > Cantidad_Gasoil then
              Put_Line("=_= DEPOSITO GASOIL VACIO. Servidos "&Integer'Image(Cantidad_Gasoil)&" litros.");
              Cantidad_Gasoil := 0;
            else
              Cantidad_Gasoil := Cantidad_Gasoil - Pedido;
              Put_Line("==> SERVICIO GASOIL: "&Integer'Image(Pedido)&"; Quedan "&Integer'Image(Cantidad_Gasoil)&" litros de GASOIL.");
            end if;
          end Servir_Gasoil;
        end select;
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