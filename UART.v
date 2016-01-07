module UART(
Clock,
Reset_N,
RX_Line,
TX_Line,
RX_Byte,
RX_Ready,
TX_Byte,
TX_Ready,
TX_Busy,
BaudSel,
);

parameter BaudRate = 115200;


input wire Clock;
input wire Reset_N;
input wire RX_Line;
output wire TX_Line;
output wire [7:0] RX_Byte;
output wire RX_Ready;
input wire [7:0] TX_Byte;
input wire TX_Ready;
output wire TX_Busy;
input wire [3:0] BaudSel;

wire BC;

generate
	case(BaudRate)
	300://300 Baud
		begin
		parameter BaudFreq = 3;
		parameter BaudLimit = 31247;	
		end
	600://600 Baud 
		begin
		parameter BaudFreq = 3;
		parameter BaudLimit = 15622;	
		end
	1200://1200 Baud 
		begin
		parameter BaudFreq = 6;
		parameter BaudLimit = 15613;	
		end
	2400://2400 Baud 
		begin
		parameter BaudFreq = 12;
		parameter BaudLimit = 15613;	
		end
	4800://4800 Baud 
		begin
		parameter BaudFreq = 24;
		parameter BaudLimit = 15601;	
		end
	9600://9600 Baud 
		begin
		parameter BaudFreq = 48;
		parameter BaudLimit = 15577;	
		end
	14400://14400 Baud 
		begin
		parameter BaudFreq = 72;
		parameter BaudLimit = 15553;	
		end
	19200://19200 Baud 
		begin
		parameter BaudFreq = 96;
		parameter BaudLimit = 15529;	
		end
	38400://38400 Baud 
		begin
		parameter BaudFreq = 192;
		parameter BaudLimit = 15433;	
		end
	57600://57600 Baud 
		begin
		parameter BaudFreq = 288;
		parameter BaudLimit = 15337;	
		end
	115200://115200 Baud 
		begin
		parameter BaudFreq = 576;
		parameter BaudLimit = 15049;	
		end
	default://115200 Baud 
		begin
		parameter BaudFreq = 576;
		parameter BaudLimit = 15049;	
		end
	endcase
	
	uart_top UART1
	(
		// global signals 
		.clock(Clock), 
		.reset(~Reset_N),
		// uart serial signals 
		.ser_in(RX_Line), 
		.ser_out(TX_Line),
		// transmit and receive internal interface signals 
		.rx_data(RX_Byte[7:0]), 
		.new_rx_data(RX_Ready), 
		.tx_data(TX_Byte[7:0]), 
		.new_tx_data(TX_Ready), 
		.tx_busy(TX_Busy), 
		// baud rate configuration register - see baud_gen.v for details 
		.baud_freq(BaudFreq), 
		.baud_limit(BaudLimit), 
		.baud_clk(BC) 
	);	
	
endgenerate





endmodule


//---------------------------------------------------------------------------------------
// uart top level module  
//
//---------------------------------------------------------------------------------------

module uart_top 
(
	// global signals 
	clock, reset,
	// uart serial signals 
	ser_in, ser_out,
	// transmit and receive internal interface signals 
	rx_data, new_rx_data, 
	tx_data, new_tx_data, tx_busy, 
	// baud rate configuration register - see baud_gen.v for details 
	baud_freq, baud_limit, 
	baud_clk 
);
//---------------------------------------------------------------------------------------
// modules inputs and outputs 
input 			clock;			// global clock input 
input 			reset;			// global reset input 
input			ser_in;			// serial data input 
output			ser_out;		// serial data output 
input	[7:0]	tx_data;		// data byte to transmit 
input			new_tx_data;	// asserted to indicate that there is a new data byte for transmission 
output 			tx_busy;		// signs that transmitter is busy 
output	[7:0]	rx_data;		// data byte received 
output 			new_rx_data;	// signs that a new byte was received 
input	[11:0]	baud_freq;	// baud rate setting registers - see header description 
input	[15:0]	baud_limit;
output			baud_clk;

// internal wires 
wire ce_16;		// clock enable at bit rate 

assign baud_clk = ce_16;
//---------------------------------------------------------------------------------------
// module implementation 
// baud rate generator module 
baud_gen baud_gen_1
(
	.clock(clock), .reset(reset), 
	.ce_16(ce_16), .baud_freq(baud_freq), .baud_limit(baud_limit)
);

// uart receiver 
uart_rx uart_rx_1 
(
	.clock(clock), .reset(reset), 
	.ce_16(ce_16), .ser_in(ser_in), 
	.rx_data(rx_data), .new_rx_data(new_rx_data) 
);

// uart transmitter 
uart_tx  uart_tx_1
(
	.clock(clock), .reset(reset), 
	.ce_16(ce_16), .tx_data(tx_data), .new_tx_data(new_tx_data), 
	.ser_out(ser_out), .tx_busy(tx_busy) 
);

endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------


//---------------------------------------------------------------------------------------
// baud rate generator for uart 
//
// this module has been changed to receive the baud rate dividing counter from registers.
// the two registers should be calculated as follows:
// first register:
// 		baud_freq = 16*baud_rate / gcd(global_clock_freq, 16*baud_rate)
// second register:
// 		baud_limit = (global_clock_freq / gcd(global_clock_freq, 16*baud_rate)) - baud_freq 
//
//---------------------------------------------------------------------------------------

module baud_gen 
(
	clock, reset, 
	ce_16, baud_freq, baud_limit 
);
//---------------------------------------------------------------------------------------
// modules inputs and outputs 
input 			clock;		// global clock input 
input 			reset;		// global reset input 
output			ce_16;		// baud rate multiplyed by 16 
input	[11:0]	baud_freq;	// baud rate setting registers - see header description 
input	[15:0]	baud_limit;

// internal registers 
reg ce_16;
reg [15:0]	counter;
//---------------------------------------------------------------------------------------
// module implementation 
// baud divider counter  
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		counter <= 16'b0;
	else if (counter >= baud_limit) 
		counter <= counter - baud_limit;
	else 
		counter <= counter + baud_freq;
end

// clock divider output 
always @ (posedge clock or posedge reset)
begin
	if (reset)
		ce_16 <= 1'b0;
	else if (counter >= baud_limit) 
		ce_16 <= 1'b1;
	else 
		ce_16 <= 1'b0;
end 

endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
// uart receive module  
//
//---------------------------------------------------------------------------------------

module uart_rx 
(
	clock, reset,
	ce_16, ser_in, 
	rx_data, new_rx_data 
);
//---------------------------------------------------------------------------------------
// modules inputs and outputs 
input 			clock;			// global clock input 
input 			reset;			// global reset input 
input			ce_16;			// baud rate multiplyed by 16 - generated by baud module 
input			ser_in;			// serial data input 
output	[7:0]	rx_data;		// data byte received 
output 			new_rx_data;	// signs that a new byte was received 

// internal wires 
wire ce_1;		// clock enable at bit rate 
wire ce_1_mid;	// clock enable at the middle of each bit - used to sample data 

// internal registers 
reg	[7:0] rx_data;
reg	new_rx_data;
reg [1:0] in_sync;
reg rx_busy; 
reg [3:0]	count16;
reg [3:0]	bit_count;  //************************************************************************************
reg [7:0]	data_buf;
//---------------------------------------------------------------------------------------
// module implementation 
// input async input is sampled twice 
always @ (posedge clock or posedge reset)
begin 
	if (reset) 
		in_sync <= 2'b11;
	else 
		in_sync <= {in_sync[0], ser_in};
end 

// a counter to count 16 pulses of ce_16 to generate the ce_1 and ce_1_mid pulses.
// this counter is used to detect the start bit while the receiver is not receiving and 
// signs the sampling cycle during reception. 
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		count16 <= 4'b0;
	else if (ce_16) 
	begin 
		if (rx_busy | (in_sync[1] == 1'b0))
			count16 <= count16 + 4'b1;
		else 
			count16 <= 4'b0;
	end 
end 

// ce_1 pulse indicating expected end of current bit 
assign ce_1 = (count16 == 4'b1111) & ce_16;
// ce_1_mid pulse indication the sampling clock cycle of the current data bit 
assign ce_1_mid = (count16 == 4'b0111) & ce_16;

// receiving busy flag 
always @ (posedge clock or posedge reset)
begin 
	if (reset)
		rx_busy <= 1'b0;
	else if (~rx_busy & ce_1_mid)
		rx_busy <= 1'b1;
	else if (rx_busy & (bit_count == 4'h8) & ce_1_mid)  //****************************************************
		rx_busy <= 1'b0;
end 

// bit counter 
always @ (posedge clock or posedge reset)//******************************************************************
begin 
	if (reset)
		bit_count <= 4'h0;
	else if (~rx_busy) 
		bit_count <= 4'h0;
	else if (rx_busy & ce_1_mid)
		bit_count <= bit_count + 4'h1;
end 

// data buffer shift register 
always @ (posedge clock or posedge reset)
begin 
	if (reset)
		data_buf <= 8'h0;
	else if (rx_busy & ce_1_mid)
		data_buf <= {in_sync[1], data_buf[7:1]};
end 

// data output and flag 
always @ (posedge clock or posedge reset)
begin 
	if (reset) 
	begin 
		rx_data <= 8'h0;
		new_rx_data <= 1'b0;
	end 
	else if (rx_busy & (bit_count == 4'h8) & ce_1)//**********************************************************
	begin 
		rx_data <= data_buf;
		new_rx_data <= 1'b1;
	end 
	else 
		new_rx_data <= 1'b0;
end 

endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------
// uart transmit module  
//
//---------------------------------------------------------------------------------------

module uart_tx  
(
	clock, reset,
	ce_16, tx_data, new_tx_data, 
	ser_out, tx_busy
);
//---------------------------------------------------------------------------------------
// modules inputs and outputs 
input 			clock;			// global clock input 
input 			reset;			// global reset input 
input			ce_16;			// baud rate multiplyed by 16 - generated by baud module 
input	[7:0]	tx_data;		// data byte to transmit 
input			new_tx_data;	// asserted to indicate that there is a new data byte for transmission 
output			ser_out;		// serial data output 
output 			tx_busy;		// signs that transmitter is busy 

// internal wires 
wire ce_1;		// clock enable at bit rate 

// internal registers 
reg ser_out;
reg tx_busy;
reg [3:0]	count16;
reg [3:0]	bit_count;
reg [8:0]	data_buf;
//---------------------------------------------------------------------------------------
// module implementation 
// a counter to count 16 pulses of ce_16 to generate the ce_1 pulse 
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		count16 <= 4'b0;
	else if (tx_busy & ce_16)
		count16 <= count16 + 4'b1;
	else if (~tx_busy)
		count16 <= 4'b0;
end 

// ce_1 pulse indicating output data bit should be updated 
assign ce_1 = (count16 == 4'b1111) & ce_16;

// tx_busy flag 
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		tx_busy <= 1'b0;
	else if (~tx_busy & new_tx_data)
		tx_busy <= 1'b1;
	else if (tx_busy & (bit_count == 4'h9) & ce_1)
		tx_busy <= 1'b0;
end 

// output bit counter 
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		bit_count <= 4'h0;
	else if (tx_busy & ce_1)
		bit_count <= bit_count + 4'h1;
	else if (~tx_busy) 
		bit_count <= 4'h0;
end 

// data shift register 
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		data_buf <= 9'b0;
	else if (~tx_busy)
		data_buf <= {tx_data, 1'b0};
	else if (tx_busy & ce_1)
		data_buf <= {1'b1, data_buf[8:1]};
end 

// output data bit 
always @ (posedge clock or posedge reset)
begin
	if (reset) 
		ser_out <= 1'b1;
	else if (tx_busy)
		ser_out <= data_buf[0];
	else 
		ser_out <= 1'b1;
end 

endmodule
//---------------------------------------------------------------------------------------
//						Th.. Th.. Th.. Thats all folks !!!
//---------------------------------------------------------------------------------------
