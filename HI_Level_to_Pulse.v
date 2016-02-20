module HI_Level_to_Pulse(
Reset_N, 			//Resets system
CLK,
Signal_In,
Pulse_Signal,
);
input wire Reset_N, CLK, Signal_In;
output wire Pulse_Signal;

//Turn level signal into pulse
reg [1:0] Level_To_Pulse_FF;

always @(negedge Reset_N or posedge CLK)
	if(~Reset_N)
		Level_To_Pulse_FF[1:0] <= 2'b00;
	else
		Level_To_Pulse_FF[1:0] <= {Level_To_Pulse_FF[0],Signal_In};

assign Pulse_Signal = (Level_To_Pulse_FF[1] ^ Level_To_Pulse_FF[0]) & Signal_In;

endmodule
