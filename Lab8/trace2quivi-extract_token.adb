--with Ada.Text_IO; -- For debug

separate(Trace2Quivi)
procedure Extract_Token(S:     in out String; 
                        Token: out String;
                        Size:  out Natural;
                        Event: out Events) is 
 -- Extracts token of size "Size" from "String"
 -- "String" returned with the token deleted
 
  Max_Str_Size: constant := 256;
  I : Integer;
  Tkn : String(1..Max_Str_Size) := (others => ' ');
  Tab : constant Character := Character'Val(9); -- Horizontal Tab character
  CR : constant Character := Character'Val(13); -- Carriage return
  LF : constant Character := Character'Val(10); -- Line feed
  
   Mode_Change_Str : constant String(1..Max_Str_Size) := 
           (1=>'M',2=>'O',3=>'D',4=>'E',5=>'_',6=>'C',7=>'H',8=>'A',9=>'N',10=>'G',11=>'E',others=>' ');
  Start_Task_Str : constant String(1..Max_Str_Size) := 
           (1=>'S',2=>'T',3=>'A',4=>'R',5=>'T',6=>'_',7=>'T',8=>'A',9=>'S',10=>'K',others=>' ');
  Stop_Task_Str : constant String(1..Max_Str_Size) := 
           (1=>'S',2=>'T',3=>'O',4=>'P',5=>'_',6=>'T',7=>'A',8=>'S',9=>'K',others=>' ');
  Missed_Deadline_Str : constant String(1..Max_Str_Size) :=
           (1=>'M',2=>'I',3=>'S',4=>'S',5=>'E',6=>'D',7=>'_',8=>'D',9=>'E',10=>'A',
           11=>'D',12=>'L',13=>'I',14=>'N',15=>'E',others=>' ');


begin
  Size := 0;  
  if S = "" then
    Event := No_Event;
    return;
  end if;
  
  -- Remove spaces and tabulators from the head of the string
  I := 1;
  while (S(I) = ' ' or S(I) = ',' or S(I) = Tab or S(I) = CR or S(I) = LF) and I < S'Length loop
    I := I + 1;
  end loop;
  -- At this point, there are I-1 blanks at the head of S
  if I > 1 then 
    for J in 1..S'Length-I-1 loop -- Move tail to head
      S(J) := S(J+I-1);
    end loop;
    for J in S'Length-I+2..S'Length loop -- Fill up with spaces
      S(J) := ' ';
    end loop;
  end if;
  
  I := 1;
  while S(I) /= ' ' and S(I) /= Tab and S(I) /= ',' and S(I) /= CR and S(I) /= LF and I <= S'Length loop
    Tkn(I) := S(I);
    I := I + 1;
  end loop;
   Token := Tkn;
   
   --Ada.Text_IO.Put_Line(Token); -- For debug
   
  -- Assign event
  if    Tkn = Start_Task_Str     then Event := Start_Task;
  elsif Tkn = Stop_Task_Str      then Event := Stop_Task;
  elsif Tkn = Mode_Change_Str    then Event := Mode_Change;
  elsif Tkn = Missed_Deadline_Str then Event := Missed_Deadline;
  else Event := No_Event;
  end if;

   -- For debug
   --Put_Line ("Event detected: -->" & Events'Image(Event) & "<--");
   
  Size := I - 1;
  for J in Size+1.. S'Length loop
    S(J-Size) := S(J);
  end loop;
  for J in S'Length-Size..S'Length loop
    S(J) := ' ';
  end loop;
  
end Extract_Token;
