package Buffers is
  type Circular_Buffer is private;
  N: constant Integer;
  Index : constant Integer;
  Buffer_Full, Buffer_Empty : exception;
  procedure Add (B : in out Circular_Buffer; I : in Integer);
  procedure Remove (B : in out Circular_Buffer; I : out Integer);
  procedure Initialise(B: in out Circular_Buffer);
  procedure List(B: in out Circular_Buffer);
  function  Full(B : in Circular_Buffer) return Boolean;
  function  Empty(B : in Circular_Buffer) return Boolean;

private
  type Circular_Buffer is
    record
         Queue : Buffer;
         Add_Index,
         Rem_Index : Index := 0;
         Counter : Integer := 0 ;
      end record;
  N : constant Integer := 5;
  Index : constant Integer := 1 mod N;
end Buffers;
