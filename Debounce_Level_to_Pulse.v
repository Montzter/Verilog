module Debounce_Level_to_Pulse( 
Reset_N, 			//Resets system
CLK,					//Input clock, used to count the Debounce Length.
Signal_In,			//Bouncy Signal
Signal_Out,			//Clean Pulse output

);

input wire Reset_N, CLK, Signal_In;
output wire Signal_Out;

//Number of clock cycles to wait before deceting next input.
parameter Debounce_Length = 22'd2500000; //50 ms on a 50MHz clock.

//Turn level signal into pulse
wire Pulse_Signal;
HI_Level_to_Pulse l2p(
.Reset_N(Reset_N), 			//Resets system
.CLK(CLK),
.Signal_In(Signal_In),
.Pulse_Signal(Pulse_Signal),
);

defparam db1.Debounce_Length = Debounce_Length;
Debounce_Signal db1(
.Reset_N(Reset_N),
.CLK(CLK),
.Input_Signal(Pulse_Signal),
.Debounced_Signal(Signal_Out),
);	
endmodule
