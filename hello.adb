with Ada.Text_IO;
 use Ada.Text_IO;

type My_Int1 is range 0..100;

 procedure Hello is
 begin
 for I in My_Int1'range loop
 Put_Line ("Hello WORLD!");
 end loop;
 end
 Hello;
