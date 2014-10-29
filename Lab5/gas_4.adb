-------------------------------------------
-- SETR P5 Ejercicio 1: Selective accept --
-------------------------------------------

-- Utiliza este archivo inicialmente y modifícalo para resolver los 4 ejercicios.
-- Guarda las distintas versiones como gas_1.adb, gas_2.adb, gas_3.adb y gas_4.adb


with Consolas, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO;
use  Consolas, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO;

procedure Gas_4 is

   -- Especificación de tareas y tipos tarea

  task Reparto is -- Rellena los depósitos de la gasolinera
    entry Start;
  end Reparto;

  task Consumidor_Gasoil is -- Consume Gasoil
    entry Start;
  end Consumidor_Gasoil;

  task Gasolinera is  -- Atiende las peticiones de servicio y rellenado
    entry Start;
    entry Rellenar (Gasoil : in Integer);
    entry Servir_Gasoil (Pedido : in Integer);
  end Gasolinera;

  protected Alarma is 
    procedure Generar; 
    entry Esperar;
  private
    Alarm : Boolean := False;
  end Alarma;

  task Genera_Alarmas is 
    entry Start;
  end Genera_Alarmas;

  task Proteccion_Civil is
    entry Start;
  end Proteccion_Civil;

   -- Cuerpo de las tareas

   task body Reparto is
      Next : Time;
      Period : Time_Span := Seconds (12);
   begin
      accept Start do
         Next := Clock;
      end Start;
      loop
         Gasolinera.Rellenar (Gasoil => 150);
         Next := Next + Period;
         delay until Next;
      end loop;
   end Reparto;

  task body Gasolinera is
     Cantidad_Gasoil : Integer := 0;  -- Deposito inicial de gasoil
  begin
     accept Start;
     loop
        -- Aceptacion selectiva
        select
          accept Rellenar (Gasoil : in Integer) do
            Cantidad_Gasoil := Cantidad_Gasoil + Gasoil;
            Put_Line("### RELLENADO:"&Integer'Image(Gasoil)&" GASOIL");
          end Rellenar;
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
          
        end select;
     end loop;
  end Gasolinera;

 
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

  protected body Alarma is
    procedure Generar is 
    begin
      Alarm := True; 
    end Generar;

    entry Esperar when Alarm is 
    begin
      Alarm := False; 
    end Esperar;
  end Alarma;

  task body Genera_Alarmas is 
    Next : Time;
    Period : Time_Span := Seconds (16);
  begin
    accept Start do
      Next := Clock; 
    end Start;
    loop
      Next := Next + Period; 
      delay until Next; 
      Alarma.Generar;
    end loop;
  end Genera_Alarmas;

  task body Proteccion_Civil is
    Next : Time;
    Period : Time_Span := Seconds (2);
  begin
    accept Start do
      Next := Clock;
    end Start;
    loop
      select
        Alarma.Esperar;
        Consola.Put_Line("--------Alarma atendida");
      then abort
        loop
          Consola.Put_Line("/// P.C. solicita repostar");
          Gasolinera.Servir_Gasoil(35);
          Consola.Put_Line("/// Proteccion Civil ha repostado GASOIL");
          Next := Next + Period; 
          delay until Next;  
        end loop; 
      end select; 
    end loop;
  end Proteccion_Civil;

begin
   Gasolinera.Start;
   Reparto.Start;
   Consumidor_Gasoil.Start;
   Proteccion_Civil.Start;
   Genera_Alarmas.Start;
end Gas_4;