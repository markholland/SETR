
with Ada.Text_IO, Ada.Integer_Text_IO, Buffers;
use  Ada.Text_IO, Ada.Integer_Text_IO, Buffers;

procedure Menu is

Buffer_Full, Buffer_Empty : exception;
My_Buffer: Circular_Buffer;
Command, Elem: Integer;
begin
  Put_Line("BUFFER MANAGER");
  loop
    Put_Line("1. Add element to buffer");
    Put_Line("2. Remove element from buffer");
    Put_Line("3. Initialise buffer");
    Put_Line("4. Buffer contents");
    Put_Line("0. Quit");
    Get(Command);
    case Command is
      when 1 =>
	         Put("Element to add:");
           Get(Elem);
           Add(My_Buffer,Elem);
	    when 2 =>
	         Remove(My_Buffer,Elem);
           Put("Element removed:");
           Put(Elem);
           New_Line;
	    when 3 =>
        Initialise(My_Buffer);
      when 4 => 
	Put("Buffer elements:");
	List(My_Buffer);
	New_Line;
      when 0 =>
        exit;
      when  others => null;
    end case;
  end loop;
end Menu;