with Ada.Text_IO; use Ada.Text_IO;
procedure Worker_Test_2 is
   Next_Number : Integer := 0;            -- Contador para calcular Worker_Ids
   function Next_Index return Positive is -- Función usada solo para inicializar Workers
   begin
      Next_Number := Next_Number + 1;
      return Positive(Next_Number);
   end Next_Index;

   task type Worker (Worker_Id: Positive := Next_Index) is
      entry Start; -- Entry para dar inicio a las tareas (ver task body)
   end Worker;     -- Especificacion del tipo (tarea con una entry)

      -- pueden tomar parte en arrays y records
   type Work_Force is array (Positive range <>) of Worker;
   type Company (Nr_Of_Workers: Positive) is
      record
         Id : Integer := 0;
         Staff: Work_Force(1..Nr_Of_Workers);
      end record;
   Small_Co_Employees : constant Positive := 3;
   Small_Co: Company(Nr_Of_Workers => Small_Co_Employees); -- Una empresa de 3 empleados

   task body Worker is   -- Cuerpo del tipo
   begin
      accept Start;   -- Detiene la ejecución del Worker hasta que se llame a Start
      Put_Line("Task" & Positive'Image(Worker_Id) & " started");
      for I in 1..10 loop
         Put_Line("Task" & Positive'Image(Worker_Id) & ":" & Integer'Image(I) & Positive'Image(Small_Co.Id));
         delay Duration'Small;
      end loop;
   end Worker;

begin
   Put_Line("Main program starts...");
   Small_Co.Id := 999999;
   for I in 1..Small_Co_Employees loop
      Small_Co.Staff(I).Start; -- Llamada a la entry Start de los Worker
   end loop;
   Put_Line("Main program ends.");
end Worker_Test_2;
