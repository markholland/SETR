-------------------------------------------------
--                Digital_IO_Sim               --
--                                             --
-- Interface to simulated Fischertechnik robot --
--                                             --
--                                             --
-- Jorge Real                                  --
--                                             -- 
-------------------------------------------------

with Low_Level_Types; use Low_Level_Types;
with Ada.Text_IO, Ada.Integer_Text_IO;

package Digital_IO_Sim is
   
   -- Simulated robot interface
   procedure Write_Low_Byte(Value: in Byte);
   function Read_Low_Byte return Byte;

   -- Simulator console output
   -- Use these instead of Ada.Text_IO when you use the simulator!
   procedure Put (Item: in String);
   procedure Put (Item: in Character);
   procedure Put (Item:  in Integer; 
                  Width: in Ada.Text_IO.Field := Ada.Integer_Text_IO.Default_Width;
                  Base:  in Ada.Text_IO.Number_Base := Ada.Integer_Text_IO.Default_Base);
   procedure New_Line (Spacing : in Ada.Text_IO.Positive_Count := 1);   
   procedure Put_Line(Item: in String);
   procedure Get(Item : out Natural); -- Read Naturals up to 3 digits
   procedure Get_Immediate(Item : out Character;
                           Available : out Boolean);
   
end Digital_IO_Sim;
