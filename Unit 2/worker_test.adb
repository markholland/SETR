with Ada.Text_IO; use Ada.Text_IO;
procedure Worker_Test is
   task type Worker;     -- Especificacion del tipo (tarea simple)
      -- Se pueden declarar objetos tarea allá donde sea visible la declaración del tipo
   John, Elisabeth, Jane : Worker; -- crea 3 tareas de tipo Worker

      -- Pueden tomar parte en arrays y records
   type Work_Force is array (Positive range <>) of Worker;
   type Company (Nr_Of_Workers: Positive) is record
      Id : Integer := 0; Staff: Work_Force(1..Nr_Of_Workers);
   end record;
   Small_Co: Company(Nr_Of_Workers => 3); -- Una empresa de 3 empleados

   task body Worker is   -- Cuerpo del tipo
   begin
      for I in 1..10 loop
         Put_Line(Integer'Image(I) & Integer'Image(Small_Co.Id));
      end loop;
   end Worker;

begin
   Small_Co.Id := 999999;
   Put_Line("Main program");
end Worker_Test;
