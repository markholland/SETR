with Motor_Sim, System, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;    
use Motor_Sim, System, Ada.Real_Time, Ada.Text_IO, Ada.Integer_Text_IO, Ada.Float_Text_IO;

procedure Speed_Motor with
   Priority => System.Default_Priority is

   period_sampler : constant Float := Float((1.0/((Float(motor_sim.Max_Speed)*8.0)/60.0))/5.0); -- in ms
   period_speedometer : constant Float := Float(Float(motor_sim.Max_Speed)/(((Float(motor_sim.Max_Speed)*8.0)/60.0)*5.0)); -- in ms

   protected Edges with Priority => System.Priority'Last - 1 is
      procedure Add;
      procedure Count_And_Reset(Count: out Natural);
   private
      Nr_Of_Edges : Natural := 0;
   end Edges;

   protected body Edges is
      procedure Add is
      begin
         Nr_Of_Edges := Nr_Of_Edges + 1;
      end Add;
      procedure Count_And_Reset(Count: out Natural) is
      begin
         Count := Nr_Of_Edges;
         Nr_Of_Edges := 0;
      end Count_And_Reset;
   end Edges;

   task Sampler with Priority => System.Priority'Last - 1 is
      entry Start;
      entry Stop;
   end Sampler;

   task body Sampler is 
      Pulse_Value : Boolean := False;
      Pulse_Value_Aux : Boolean := False;
      Running : Boolean := False;
      Period : Time_Span := Microseconds(Integer(period_sampler*1000000.0));
      Next : Time;
   begin
      loop
      select
         accept Start;
            Next := Clock;
            Next := Next + Period;
            Running := True;
      or
         accept Stop;
            exit;
      or
         when Running =>
            delay until Next;
            Pulse_Value_Aux := Motor_Sim.Motor_Pulse;
            --Put_Line("1:"&Boolean'Image(Pulse_Value_Aux));
            --Put_Line("2:"&Boolean'Image(Pulse_Value));
            if (Pulse_Value /= Pulse_Value_Aux) then
               Pulse_Value := Pulse_Value_Aux;
               Edges.Add;
            end if;
            Next := Next + Period;
      end select;
      end loop;
   end Sampler;

   task Speedometer with Priority => System.Priority'Last - 2 is
      entry Start;
      entry Finish;
   end Speedometer;

   task body Speedometer is
      type Velocity is delta 0.1 digits 5;
      Speed : Velocity;
      Count : Natural := 0;
      Running : Boolean := False;
      Period : Time_Span := Microseconds(Integer(period_speedometer*1000000.0));
      Next : Time;
   begin
      loop
         select
            accept Start;
               Next := Clock;
               Next := Next + Period;
               Running := True;
         or 
            accept Finish;
               Running := False;
               exit;
         or
            when Running =>
               delay until Next;
               Edges.Count_And_Reset(Count);
               Speed := Velocity'Value(Integer'Image(Count * 5));
               Put_Line("Velocity: "&Velocity'Image(Speed));
               Next := Next + Period;
         end select;
      end loop;    
   end Speedometer;

begin
   Put_Line ("Starting motor simulation");
   Put_Line ("Max speed =" & Integer'Image (Max_Speed) & " RPM");
   Start_Simulation;

   Put_Line ("Speedometer");
   Put_Line ("-----------");
   Put_Line ("Motor stopped for 6 seconds");
   Sampler.Start;
   Speedometer.Start;
   delay 6.0;

   Put_Line ("Starting motor for 12 seconds at half speed");
   Set_Speed (Half);
   Motor_On;
   delay 12.0;

   Put_Line ("Starting motor for 12 seconds at full speed");
   Set_Speed (Full);
   delay 12.0;

   Put_Line ("Stopping motor. Waiting 6 more seconds");
   Motor_Off;
   delay 6.0;

   Put_Line ("Ending speedometer");
   Speedometer.Finish;
   Sampler.Stop;
   Put_Line ("Ending motor simulation");
   End_Simulation;
   Put_Line ("End of main task");
exception
   when others =>
      Put_Line ("Exception caught in main");
end Speed_Motor;