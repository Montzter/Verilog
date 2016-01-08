module CommandShiftRegister(
ByteIn,
Clear,
LoadByte,
RegValues,
);

parameter Number_of_Bytes = 4;
parameter Number_of_Bits = Number_of_Bytes*8;


input wire [7:0] ByteIn;
input wire Clear;
input wire LoadByte;
output reg [Number_of_Bits-1:0] RegValues;

always @(posedge LoadByte or posedge Clear)
	if(Clear)
		RegValues[Number_of_Bits-1:0] <= 0;
	else
		RegValues[Number_of_Bits-1:0] <= {RegValues[Number_of_Bits-9:0],ByteIn[7:0]};

endmodule
