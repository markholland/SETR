with Ada.Unchecked_Deallocation;
 
package body Queue is 
 
   ----------
   -- Push --
   ----------
 
   procedure Push (List : in out Queue_Type; Item : in Element_Type) is
      Temp : Queue_Ptr := new Queue_Element'(Item, null);
   begin
      if List.Tail = null then
         List.Tail := Temp;
      end if;
      if List.Head /= null then
        List.Head.Next := Temp;
      end if;
      List.Head := Temp;
   end Push;
 
   ---------
   -- Pop --
   ---------
 
   procedure Pop (List : in out Queue_Type; Item : out Element_Type) is
      procedure Free is new Ada.Unchecked_Deallocation(Queue_Element, Queue_Ptr);
      Temp : Queue_Ptr := List.Tail;
   begin
      if List.Head = null then
         raise Empty_Error;
      end if;
      Item := List.Tail.Value;
      List.Tail := List.Tail.Next;
      if List.Tail = null then
         List.Head := null;
      end if;
      Free(Temp);
   end Pop;
 
   --------------
   -- Is_Empty --
   --------------
 
   function Is_Empty (List : Queue_Type) return Boolean is
   begin
      return List.Head = null;
   end Is_Empty;

   --------------
   --  Empty   --
   --------------

   Procedure Empty_Queue(List : in out Queue_Type) is
      Item : Element_Type;
   begin
      while not Is_Empty(List) loop
         Pop(List, Item);
      end loop;
   end Empty_Queue;
 
end Queue;