-------------------------------------------
-- SETR P5 Ejercicio 1: Selective accept --
-------------------------------------------

-- Utiliza este archivo inicialmente y modifícalo para resolver los 4 ejercicios.
-- Guarda las distintas versiones como gas_1.adb, gas_2.adb, gas_3.adb y gas_4.adb


with Consolas, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO;
use  Consolas, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO;

procedure Gas_2 is

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
      entry Rellenar (Gasolina, Gasoil, Biogasolina : in Integer);
      entry Servir_Gasolina (Pedido : in Integer);
      entry Servir_Gasoil (Pedido : in Integer);
      entry Servir_Biogasolina (Pedido : in Integer);
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
         Gasolinera.Rellenar (Gasolina => 150, Gasoil => 150, Biogasolina => 60);
         Next := Next + Period;
         delay until Next;
      end loop;
   end Reparto;

  task body Gasolinera is
     Cantidad_Super  : Integer := 0;  -- Deposito inicial de super
     Cantidad_Gasoil : Integer := 0;  -- Deposito inicial de gasoil
     Cantidad_Biogasolina : Integer := 0;  -- Deposito inicial de biogasolina
  begin
     -- ------------------------------------
     --         Tarea a completar
     -- ------------------------------------
     accept Start;
     loop
        -- Aceptacion selectiva
        select
          accept Rellenar (Gasolina, Gasoil, Biogasolina : in Integer) do
            Cantidad_Super := Cantidad_Super + Gasolina;
            Cantidad_Gasoil := Cantidad_Gasoil + Gasoil;
            Cantidad_Biogasolina := Cantidad_Biogasolina + Biogasolina;
            Consola.Put_Line("### RELLENADO:"&Integer'Image(Gasolina)& " GASOLINA, "&Integer'Image(Gasoil)&" GASOIL "&Integer'Image(Biogasolina)&" BIOGASOLINA");
          end Rellenar;
          or
          when Cantidad_Super /= 0 =>
          accept Servir_Gasolina(Pedido : in Integer) do
            if Pedido >= Cantidad_Super then
              Consola.Put_Line("-_- DEPOSITO GASOLINA VACIO. Servidos "&Integer'Image(Cantidad_Super)&" litros.");
              Cantidad_Super := 0;
            else
              Cantidad_Super := Cantidad_Super - Pedido;
              Consola.Put_Line("--> SERVICIO GASOLINA:" &Integer'Image(Pedido)& "; Quedan "&Integer'Image(Cantidad_Super)&" litros de GASOLINA.");
            end if;
          end Servir_Gasolina;
          or
          when Cantidad_Gasoil /= 0 =>
          accept Servir_Gasoil(Pedido : in Integer) do
            if Pedido >= Cantidad_Gasoil then
              Consola.Put_Line("=_= DEPOSITO GASOIL VACIO. Servidos "&Integer'Image(Cantidad_Gasoil)&" litros.");
              Cantidad_Gasoil := 0;
            else
              Cantidad_Gasoil := Cantidad_Gasoil - Pedido;
              Consola.Put_Line("==> SERVICIO GASOIL: "&Integer'Image(Pedido)&"; Quedan "&Integer'Image(Cantidad_Gasoil)&" litros de GASOIL.");
            end if;
          end Servir_Gasoil;
          or
          when Cantidad_Biogasolina /= 0 =>
          accept Servir_Biogasolina(Pedido : in Integer) do
            if Pedido = Cantidad_Biogasolina then
              Consola.Put_Line("·_· DEPOSITO BIOGASOLINA VACIO. Servidos 30 litros.");
              Cantidad_Biogasolina := 0;
            else
              Cantidad_Biogasolina := Cantidad_Biogasolina - Pedido;
              Consola.Put_Line("==> SERVICIO BIOGASOLINA: "&Integer'Image(Pedido)&"; Quedan "&Integer'Image(Cantidad_Biogasolina)&" litros de BIOGASOLINA.");
            end if;
          end Servir_Biogasolina;
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
        select
          Gasolinera.Servir_Biogasolina(30);
          Consola.Put_Line("----------------------Me han servido Biogasolina");
        else
          Gasolinera.Servir_Gasolina (30);
          Consola.Put_Line("----------------------Me han servido Gasolina");
        end select;
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
         --Consola.Put_Line("Me han servido Gasoil");
         Next := Next + Period;
         delay until Next;
      end loop;
   end Consumidor_Gasoil;

begin
   Gasolinera.Start;
   Reparto.Start;
   Consumidor_Gasolina.Start;
   Consumidor_Gasoil.Start;
end Gas_2;