//
//
//
//

`define NM1 32'd466 //bB_freq
`define NM2 32'd523 //C_freq
`define NM3 32'd587 //D_freq
`define NM4 32'd622 //bE_freq
`define NM5 32'd698 //F_freq
`define NM6 32'd784 //G_freq
`define NM7 32'd880 //A_freq
`define NM0 32'd20000 //slience (over freq.)

module Music (
	input [7:0] ibeatNum,	
	output reg [31:0] tone
);

always @(*) begin
	case (ibeatNum)		// 1 beat
		8'd0 : tone = 32'd262;	//3
		8'd1 : tone = 32'd294;
		8'd2 : tone = 32'd330;
		8'd3 : tone = 32'd349;
		8'd4 : tone = 32'd392;	//1
		8'd5 : tone = 32'd440;
		8'd6 : tone = 32'd494;
		8'd7 : tone = 32'd262 << 1;
		8'd8 : tone = 32'd294 << 1;
		8'd9 : tone = 32'd330 << 1;
		8'd10 : tone = 32'd349 << 1;
		8'd11 : tone = 32'd392 << 1;
		8'd12 : tone = 32'd440 << 1;
		8'd13 : tone = 32'd494 << 1;
		8'd14 : tone = 32'd262 << 2;
		//8'd15 : tone = 32'd294 << 2;
	endcase
end

endmodule