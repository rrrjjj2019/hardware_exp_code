`timescale 1ns/1ps

module XOR(a, b, out);
    input a, b;
	output out;

    wire not_a, not_b;
    wire a_not_b, b_not_a;
    
    not not0(not_a, a);
    not not1(not_b, b);
    and and0(a_not_b, a, not_b);
    and and1(b_not_a, b, not_a);
    or or0(out, a_not_b,b_not_a);
	
endmodule


module FullAdder(a, b, in, s, out);
    input a, b, in;
	output s, out;
	
	wire xor_ab, and_xor_ab_in, and_ab;
	
	XOR xor0(a, b, xor_ab);
	XOR xor1(in, xor_ab, s);
	and and2(and_xor_ab_in, xor_ab, in);
	and and3(and_ab, a, b);
	or or1(out, and_xor_ab_in, and_ab);
	
	
endmodule


module Multiplier (a, b, p);
    input [4-1:0] a, b;
    output [8-1:0] p;
	
	wire a0b0, a1b0, a2b0, a3b0;
	wire a0b1, a1b1, a2b1, a3b1;
	wire a0b2, a1b2, a2b2, a3b2;
	wire a0b3, a1b3, a2b3, a3b3;
	
	wire out_FA_a0b1, out_FA_a1b1, out_FA_a2b1, out_FA_a3b1;
	wire out_FA_a0b2, out_FA_a1b2, out_FA_a2b2, out_FA_a3b2;
	wire out_FA_a0b3, out_FA_a1b3, out_FA_a2b3, out_FA_a3b3;
	
	wire s_FA_a1b1, s_FA_a2b1, s_FA_a3b1;
	wire s_FA_a1b2, s_FA_a2b2, s_FA_a3b2;
	
	and and4(p[0], a[0], b[0]);
	and and5(a1b0, a[1], b[0]);
	and and6(a2b0, a[2], b[0]);
	and and7(a3b0, a[3], b[0]);
	
	and and8(a0b1, a[0], b[1]);
	and and9(a1b1, a[1], b[1]);
	and and10(a2b1, a[2], b[1]);
	and and11(a3b1, a[3], b[1]);
	
	and and12(a0b2, a[0], b[2]);
	and and13(a1b2, a[1], b[2]);
	and and14(a2b2, a[2], b[2]);
	and and15(a3b2, a[3], b[2]);
	
	and and16(a0b3, a[0], b[3]);
	and and17(a1b3, a[1], b[3]);
	and and18(a2b3, a[2], b[3]);
	and and19(a3b3, a[3], b[3]);
	
	
	FullAdder FA0(a0b1, a1b0, 1'b0, p[1], out_FA_a0b1);
	FullAdder FA1(a1b1, a2b0, out_FA_a0b1, s_FA_a1b1, out_FA_a1b1);
	FullAdder FA2(a2b1, a3b0, out_FA_a1b1, s_FA_a2b1, out_FA_a2b1);
	FullAdder FA3(a3b1, 1'b0, out_FA_a2b1, s_FA_a3b1, out_FA_a3b1);
	
	FullAdder FA4(a0b2, s_FA_a1b1, 1'b0, p[2], out_FA_a0b2);
	FullAdder FA5(a1b2, s_FA_a2b1, out_FA_a0b2, s_FA_a1b2, out_FA_a1b2);
    FullAdder FA6(a2b2, s_FA_a3b1, out_FA_a1b2, s_FA_a2b2, out_FA_a2b2);
	FullAdder FA7(a3b2, out_FA_a3b1, out_FA_a2b2, s_FA_a3b2, out_FA_a3b2);
	
	FullAdder FA8(a0b3, s_FA_a1b2, 1'b0, p[3], out_FA_a0b3);
	FullAdder FA9(a1b3, s_FA_a2b2, out_FA_a0b3, p[4], out_FA_a1b3);
	FullAdder FA10(a2b3, s_FA_a3b2, out_FA_a1b3, p[5], out_FA_a2b3);
	FullAdder FA11(a3b3, out_FA_a3b2, out_FA_a2b3, p[6], p[7]);
	
	
	endmodule
