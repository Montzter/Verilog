module SRAM_with_VGA_module(
//General Inputs/Outputs
CLOCK_50,
SRAM_USE,
SRAM_WRITE,
SRAM_ADDRESS,
SRAM_DATA_IN,
SRAM_DATA_OUT,
VGA_ENABLE,
VGA_IMG_SELECT,
//SRAM
SRAM_ADDR,
SRAM_DQ,
SRAM_CE_N,
SRAM_OE_N,
SRAM_WE_N,
SRAM_UB_N,
SRAM_LB_N,
//VGA
VGA_R,
VGA_G,
VGA_B,
VGA_CLK,
VGA_BLANK_N,
VGA_HS,
VGA_VS,
VGA_SYNC_N
);
//General Inputs/Outputs
input wire CLOCK_50, SRAM_USE, SRAM_WRITE, VGA_ENABLE;
input wire [1:0] VGA_IMG_SELECT;
input wire[19:0] SRAM_ADDRESS;
input wire [15:0] SRAM_DATA_IN;
output wire [15:0] SRAM_DATA_OUT;
//SRAM
output wire [19:0] SRAM_ADDR;
inout wire [15:0] SRAM_DQ;
output wire SRAM_CE_N,SRAM_OE_N,SRAM_WE_N,SRAM_UB_N,SRAM_LB_N;
//VGA
output wire [7:0] VGA_R, VGA_G, VGA_B;
output reg VGA_CLK, VGA_HS, VGA_VS;
output wire VGA_BLANK_N, VGA_SYNC_N;

//**************************
//            VGA
//**************************

//Setup 25 MHz pixel clock
always @(posedge CLOCK_50)
	VGA_CLK <= ~VGA_CLK;
	
//Setup VGA_BLANK_N and VGA_SYNC_N
assign VGA_BLANK_N = (VGA_ENABLE && ~SRAM_USE)? (((CLOCK_COUNTER[10:0] >= 11'd285) && (CLOCK_COUNTER[10:0] <= 11'd1555))): 1'b0;
assign VGA_SYNC_N = 1'b0;

//Set first pixel address of VGA image
reg [19:0] StartPixel;
always @(VGA_IMG_SELECT[1:0])
	case(VGA_IMG_SELECT[1:0])
	2'b00: StartPixel[19:0] <= 20'd0;
	2'b01: StartPixel[19:0] <= 20'd307199;
	2'b11: StartPixel[19:0] <= 20'd614399;
	default:StartPixel[19:0] <= 20'd0;
	endcase

//Set VGA_HS
reg [10:0] CLOCK_COUNTER;
always @(posedge CLOCK_50) begin
	CLOCK_COUNTER <= (CLOCK_COUNTER[10:0] == 11'd1583)? 11'b0: CLOCK_COUNTER[10:0] + 1'b1;
	VGA_HS <= (CLOCK_COUNTER[10:0] > 11'd189);
end

//Set VGA_VS
reg [9:0] LineCounter;
always @(negedge VGA_HS) begin
	LineCounter <= (LineCounter == 10'd525)? 10'b0: LineCounter[9:0] + 1'b1;
	VGA_VS <= (LineCounter[9:0] > 10'd1);
end

//Set SRAM address of pixel
reg[19:0] PIXELADDRESS;
always @(negedge VGA_CLK) begin
	if(~VGA_VS)
		PIXELADDRESS[19:0] <= StartPixel[19:0];//514
	else if((CLOCK_COUNTER[10:0] > 11'd284) && (CLOCK_COUNTER[10:0] < 11'd1554) && (LineCounter[9:0] > 10'd34) && (LineCounter[9:0] < 10'd515))
		PIXELADDRESS[19:0] <= PIXELADDRESS[19:0] + 1'b1;
end

//Set RGB values
assign VGA_R[7:0] = 8'b0;
assign VGA_G[7:0] = SRAM_DATA_OUT[13:6];
assign VGA_B[7:0] = 8'b0;

//**************************
//            SRAM
//**************************

//Select SRAM address
assign SRAM_ADDR[19:0] = (VGA_ENABLE && ~SRAM_USE)? PIXELADDRESS[19:0]: SRAM_ADDRESS[19:0];


//Set data busses
assign SRAM_DATA_OUT[15:0] = SRAM_DQ[15:0];
assign SRAM_DQ[15:0] = SRAM_WRITE? SRAM_DATA_IN[15:0]: 16'bzzzzzzzzzzzzzzzz;


//Set control bits
assign SRAM_CE_N = 1'b0;
assign SRAM_OE_N = 1'b0;
assign SRAM_WE_N = ~(SRAM_WRITE && SRAM_USE) ;
assign SRAM_UB_N = 1'b0;
assign SRAM_LB_N = 1'b0;

endmodule
