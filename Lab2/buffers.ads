package Buffers is
   type Circular_Buffer is private;
  procedure Add (B : in out Circular_Buffer; I : in Integer);
  procedure Remove (B : in out Circular_Buffer;I : out Integer);
  procedure Initialise(B: in out Circular_Buffer);
  procedure List(B: in out Circular_Buffer);
  function  Full(B : in Circular_Buffer) return Boolean;
  function  Empty(B : in Circular_Buffer) return Boolean;
private
  N : constant Integer := 5;
 type Index is mod N;
 type Buffer is array (Index) of Integer;
 type Circular_Buffer is
    record
         Queue : Buffer;
         Add_Index,
         Rem_Index : Index := 0;
         Counter : Integer := 0 ;
      end record;
end Buffers;
