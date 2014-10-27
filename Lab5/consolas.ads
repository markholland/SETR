package Consolas is

   protected Consola is
      procedure Put(S1: String);
      procedure Put_Line(S1: String);

      procedure Put(I: Integer);
      procedure Put_Line(I: Integer);

      procedure Put(S1: String; I1: Integer;
                    S2: String; I2: Integer);
      procedure Put_Line(S1: String; I1: Integer;
                         S2: String; I2: Integer);

      procedure Put(S1: String; I1: Integer;
                    S2: String; I2: Integer; S3: String);
      procedure Put_Line(S1: String; I1: Integer;
                         S2: String; I2: Integer; S3: String);


      procedure Put(S1: String; I1: Integer; S2: String);
      procedure Put_Line( S1: String; I1: Integer; S2: String);
   end Consola;
   
end Consolas;
