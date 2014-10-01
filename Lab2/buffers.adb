with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;
package body buffers is

	Buffer_Full, Buffer_Empty : exception;

   function Full (B : in Circular_Buffer) return Boolean is
   begin
      if B.Counter = N -1 then
         return True;
      else return False;
      end if;
   end Full;

   function Empty (B : in Circular_Buffer) return Boolean is
   begin
      if B.Counter = 0 then
         return True;
      else return False;
      end if;
   end Empty;

  procedure Initialise (B: in out Circular_Buffer) is
   begin
      B.Add_Index := 0;
      B.Rem_Index := 0;
      B.Counter := 0;
   end Initialise;

   procedure Add (B: in out Circular_Buffer; I : in Integer) is
    begin
      if not Full(B) then
         B.Queue(B.Add_Index) := I;
         B.Add_Index := B.Add_Index + 1;
         B.Counter := B.Counter + 1;
      else 
      	 raise Buffer_Full;
      end if;
      exception
    when Buffer_Full =>
      Put_Line ("Buffer Full! Unable to add element!");
   end Add;

   procedure Remove (B: in out Circular_Buffer; I : out Integer ) is
    begin
      if not Empty(B) then
         I:= B.Queue(B.Rem_Index);
         B.Rem_Index := B.Rem_Index + 1;
         B.Counter := B.Counter - 1;
      else 
      	 raise Buffer_Empty;
      end if;
      exception
      when Buffer_Empty =>
      Put_Line ("Buffer Full! Unable to add element!");
   end Remove;

   procedure List (B : in out Circular_Buffer) is
      My_Index : Index := B.Rem_Index;
   begin
      if Empty(B) then
         Put_Line("Buffer Empty");
      else
         for I in 1 .. B.Counter loop
            Put(B.Queue(My_Index));
            My_Index:=My_Index+1;
         end loop;
      end if;
   end List;
end buffers;
