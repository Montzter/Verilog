module Debounce_Signal(
Reset_N,
CLK,
Input_Signal,
Debounced_Signal,


//Debug Signals
LookForPulse,
CurrentCount,
);
input wire Reset_N, CLK, Input_Signal;
output reg Debounced_Signal;

//Debug
output reg LookForPulse;
output reg [21:0]CurrentCount;
parameter Debounce_Length = 22'd2500000;

//Debounce Pulse signal
//When pulse is detected, wait 'Debounce_Length' until looking for next pulse
//*******reg LookForPulse;
//*******reg [21:0]CurrentCount;

//Manage LookForPulse
always @(negedge Reset_N or posedge CLK)
	if(~Reset_N) begin
		LookForPulse <= 1'b1;
		CurrentCount[21:0] <= Debounce_Length;
		end
	else 
		if(~LookForPulse)//Currently waiting for the debounce timer to run out.
			if(CurrentCount[21:0] == 22'b0) begin //Debounce timer is zero.
				CurrentCount[21:0] <= Debounce_Length; //Reset counter.
				LookForPulse <= 1'b1;	//Return to monitoring for pulses
				end
			else	//Debounce timer is not zero.
				CurrentCount[21:0] <= CurrentCount[21:0] - 22'b1;
		else//
			LookForPulse <= ~Input_Signal;
	
//Manage Debounced_Signal
always @(negedge Reset_N or posedge CLK)
	if(~Reset_N)
		Debounced_Signal <= 1'b0;
	else
		Debounced_Signal <= (LookForPulse)? Input_Signal: 1'b0;

endmodule
