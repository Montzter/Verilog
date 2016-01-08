module AlphaNumeric_7Seg_activeLow(
Input,
SevenSeg,
);
input wire [7:0] Input;
output reg [6:0] SevenSeg;

always @(Input[7:0])
	case(Input[7:0])
		//0
		8'd48: SevenSeg[6:0] <= 7'b1000000;//0000001;
		//1
		8'd49: SevenSeg[6:0] <=	7'b1111001;//1001111;
		//2
		8'd50: SevenSeg[6:0] <=	7'b0100100;//0010010;
		//3
		8'd51: SevenSeg[6:0] <=	7'b0110000;//0000110;
		//4
		8'd52: SevenSeg[6:0] <=	7'b0011001;//1001100;
		//5
		8'd53: SevenSeg[6:0] <=	7'b0010010;//0100100;
		//6
		8'd54: SevenSeg[6:0] <=	7'b0000010;//0100000;
		//7
		8'd55: SevenSeg[6:0] <=	7'b1111000;//0001111;
		//8
		8'd56: SevenSeg[6:0] <=	7'b0000000;//0000000;
		//9
		8'd57: SevenSeg[6:0] <=	7'b0010000;//0000100;
		//A,a
		8'd65: SevenSeg[6:0] <= 7'b0001000;
		8'd97: SevenSeg[6:0] <=	7'b0001000;
		//B,b
		8'd66: SevenSeg[6:0] <= 7'b0000011;//1100000;
		8'd98: SevenSeg[6:0] <=	7'b0000011;//1100000;
		//C,c
		8'd67: SevenSeg[6:0] <= 7'b1000110;//0110001;
		8'd99: SevenSeg[6:0] <=	7'b1000110;//0110001;
		//D,d
		8'd68: SevenSeg[6:0] <= 7'b0100001;//1000010;
		8'd100:SevenSeg[6:0] <=	7'b0100001;//1000010;
		//E,e
		8'd69: SevenSeg[6:0] <= 7'b0000110;//0110000;
		8'd101:SevenSeg[6:0] <=	7'b0000110;//0110000;
		//F,f
		8'd70: SevenSeg[6:0] <= 7'b0001110;//0111000;
		8'd102:SevenSeg[6:0] <=	7'b0001110;//0111000;
		//G,g
		8'd71: SevenSeg[6:0] <= 7'b1000010;//0100001;
		8'd103:SevenSeg[6:0] <=	7'b1000010;//0100001;
		//H,h
		8'd72: SevenSeg[6:0] <= 7'b0001011;//1101000;
		8'd104:SevenSeg[6:0] <=	7'b0001011;//1101000;
		//I,i
		8'd73: SevenSeg[6:0] <= 7'b1001111;//1111001;
		8'd105:SevenSeg[6:0] <=	7'b1001111;//1111001;
		//J,j
		8'd74: SevenSeg[6:0] <= 7'b1100001;//1000011;
		8'd106:SevenSeg[6:0] <=	7'b1100001;//1000011;
		//K,k
		8'd75: SevenSeg[6:0] <= 7'b0001010;//0101000;
		8'd107:SevenSeg[6:0] <=	7'b0001010;//0101000;
		//L,l
		8'd76: SevenSeg[6:0] <= 7'b1000111;//1110001;
		8'd108:SevenSeg[6:0] <=	7'b1000111;//1110001;
		//M,m
		8'd77: SevenSeg[6:0] <= 7'b1101010;//0101011;
		8'd109:SevenSeg[6:0] <=	7'b1101010;//0101011;
		//N,n
		8'd78: SevenSeg[6:0] <= 7'b1001000;//0001001;
		8'd110:SevenSeg[6:0] <=	7'b1001000;//0001001;
		//O,o
		8'd79: SevenSeg[6:0] <= 7'b1000000;//0000001;
		8'd111:SevenSeg[6:0] <=	7'b1000000;//0000001;
		//P,p
		8'd80: SevenSeg[6:0] <= 7'b0001100;//0011000;
		8'd112:SevenSeg[6:0] <=	7'b0001100;//0011000;
		//Q,q
		8'd81: SevenSeg[6:0] <= 7'b0011000;//0001100;
		8'd113:SevenSeg[6:0] <=	7'b0011000;//0001100;
		//R,r
		8'd82: SevenSeg[6:0] <= 7'b1001100;//0011001;
		8'd114:SevenSeg[6:0] <=	7'b1001100;//0011001;
		//S,s
		8'd83: SevenSeg[6:0] <= 7'b0010010;//0100100;
		8'd115:SevenSeg[6:0] <=	7'b0010010;//0100100;
		//T,t
		8'd84: SevenSeg[6:0] <= 7'b0000111;//1110000;
		8'd116:SevenSeg[6:0] <=	7'b0000111;//1110000;
		//U,u
		8'd85: SevenSeg[6:0] <= 7'b1000001;//1000001;
		8'd117:SevenSeg[6:0] <=	7'b1000001;//1000001;
		//V,v
		8'd86: SevenSeg[6:0] <= 7'b1010001;//1000101;
		8'd118:SevenSeg[6:0] <=	7'b1010001;//1000101;
		//W,w
		8'd87: SevenSeg[6:0] <= 7'b1010101;//1010101;
		8'd119:SevenSeg[6:0] <=	7'b1010101;//1010101;
		//X,x
		8'd88: SevenSeg[6:0] <= 7'b0001001;//1001000;
		8'd120:SevenSeg[6:0] <=	7'b0001001;//1001000;
		//Y,y
		8'd89: SevenSeg[6:0] <= 7'b0010001;//1000100;
		8'd121:SevenSeg[6:0] <=	7'b0010001;//1000100;
		//Z,z
		8'd90: SevenSeg[6:0] <= 7'b0110100;//0010110;
		8'd122:SevenSeg[6:0] <= 7'b0110100;//0010110;
		//Everything Else
		default: SevenSeg[6:0] <= 7'b1111111;
	endcase

endmodule
