with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

package body Consolas is

   -------------
   -- Consola --
   -------------

   protected body Consola is

      ---------
      -- Put --
      ---------
      
      procedure Put (S1: String) is
      begin
         Ada.Text_Io.Put(S1);
      end Put;

      procedure Put (I: Integer) is
      begin
         Ada.Integer_Text_Io.Put(I,0);
      end Put;

      procedure Put (S1: String; I1: Integer;  S2: String; I2: Integer) is
      begin
         Ada.Text_Io.Put(S1);
         Ada.Integer_Text_Io.Put(I1,0);
         Ada.Text_Io.Put(S2);
         Ada.Integer_Text_Io.Put(I2,0);
      end Put;

      procedure Put (S1: String; I1: Integer;  S2: String; I2: Integer; S3: String) is
      begin
         Ada.Text_Io.Put(S1);
         Ada.Integer_Text_Io.Put(I1,0);
         Ada.Text_Io.Put(S2);
         Ada.Integer_Text_Io.Put(I2,0);
         Ada.Text_Io.Put(S3);
      end Put;

      procedure Put (S1: String; I1: Integer; S2: String) is
      begin
         Ada.Text_Io.Put(S1);
         Ada.Integer_Text_Io.Put(I1,0);
         Ada.Text_Io.Put(S2);
      end Put;

      --------------
      -- Put_Line --
      --------------

      procedure Put_Line (S1: String) is
      begin
         Ada.Text_Io.Put(S1);
         New_Line;
      end Put_Line;

      procedure Put_Line (I: Integer) is
      begin
         Ada.Integer_Text_Io.Put(I,0);
         New_Line;
      end Put_Line;

      procedure Put_Line
        (S1: String;
         I1: Integer;
         S2: String;
         I2: Integer) is
      begin
         Ada.Text_Io.Put(S1);
         Ada.Integer_Text_Io.Put(I1,0);
         Ada.Text_Io.Put(S2);
         Ada.Integer_Text_Io.Put(I2,0);
         New_Line;
      end Put_Line;

      procedure Put_Line (S1: String; I1: Integer;  S2: String; I2: Integer; S3: String) is
      begin
         Ada.Text_Io.Put(S1);
         Ada.Integer_Text_Io.Put(I1,0);
         Ada.Text_Io.Put(S2);
         Ada.Integer_Text_Io.Put(I2,0);
         Ada.Text_Io.Put(S3);
         New_Line;
      end Put_Line;
      
      procedure Put_Line (S1: String; I1: Integer; S2: String) is
      begin
         Ada.Text_Io.Put(S1);
         Ada.Integer_Text_Io.Put(I1,0);
         Ada.Text_Io.Put(S2);
         New_Line;
      end Put_Line;

   end Consola;

end Consolas;

