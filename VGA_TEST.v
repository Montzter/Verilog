module VGA_TEST(
//General
CLOCK_50,
SW,
GPIO,
//VGA
VGA_R,
VGA_G,
VGA_B,
VGA_CLK,
VGA_BLANK_N,
VGA_HS,
VGA_VS,
VGA_SYNC_N,
);
//General inputs
input wire CLOCK_50;
input wire [17:0] SW;
output wire [35:0] GPIO;
//VGA connections
output wire [7:0] VGA_R, VGA_G, VGA_B;
output reg VGA_CLK;
output wire VGA_BLANK_N, VGA_SYNC_N;
output reg VGA_HS, VGA_VS;

assign GPIO[35] = VGA_BLANK_N;//VGA_VS;
assign GPIO[34] = VGA_HS;

//General 25 MHz Pixel Clock
always @(posedge CLOCK_50)
	VGA_CLK <= ~VGA_CLK;
	
//Set screen to red
assign VGA_R[7:0] = 8'b00000000;
assign VGA_G[7:0] = 8'b10000000;
assign VGA_B[7:0] = 8'b00000000;

//Set BLANK and SYNC signals
//Blank_N signal is low durring sync, front and back porch. 
assign VGA_BLANK_N = ((CLOCK_COUNTER[10:0] >= 11'd285) && (CLOCK_COUNTER[10:0] <= 11'd1555));
assign VGA_SYNC_N = 1'b0;

//Generate VGA_VS
// 190 c.c. Sync. 
//  95 c.c. Back porch
//1270 c.c. Display Interval
//  30 c.c. Front Porch
reg [9:0] LineCounter;
always @(negedge VGA_HS) begin
	LineCounter <= (LineCounter == 10'd524)? 10'b0: LineCounter[9:0] + 1'b1;
	VGA_VS <= (LineCounter[9:0] > 10'd1);
end

//Generate VGA_HS
//2   Lines Sync. 
//33  Lines Back porch
//480 Lines Display Interval
//10  Lines Front Porch
reg [10:0] CLOCK_COUNTER;
always @(posedge CLOCK_50) begin
	CLOCK_COUNTER <= (CLOCK_COUNTER == 11'd1584)? 11'b0: CLOCK_COUNTER[10:0] + 1'b1;
	VGA_HS <= (CLOCK_COUNTER[10:0] > 11'd189);
end

endmodule
