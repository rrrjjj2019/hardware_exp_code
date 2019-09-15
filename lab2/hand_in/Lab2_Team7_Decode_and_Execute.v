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

//ADD
module ADD(rs, rt, rd);
    input [3:0] rs, rt;
	output [3:0] rd;
	
	wire [3:0] c;
	//FullAdder(a, b, in, s, out);
	FullAdder FA0(rs[0], rt[0], 1'b0, rd[0], c[0]);
	FullAdder FA1(rs[1], rt[1], c[0], rd[1], c[1]);
	FullAdder FA2(rs[2], rt[2], c[1], rd[2], c[2]);
	FullAdder FA3(rs[3], rt[3], c[2], rd[3], c[3]);
	
endmodule

//SUB
module SUB(rs, rt, rd);
    input [3:0] rs, rt;
    output [3:0] rd;
    
    wire not_rt3, not_rt2, not_rt1, not_rt0;
    wire [3:0] c;
	
    not not0(not_rt3, rt[3]);
    not not1(not_rt2, rt[2]);
	not not2(not_rt1, rt[1]);
	not not3(not_rt0, rt[0]);
	
	FullAdder FA0(rs[0], not_rt0, 1'b1, rd[0], c[0]);
	FullAdder FA1(rs[1], not_rt1, c[0], rd[1], c[1]);
	FullAdder FA2(rs[2], not_rt2, c[1], rd[2], c[2]);
	FullAdder FA3(rs[3], not_rt3, c[2], rd[3], c[3]);
	
endmodule

//INC
module INC(rs, rd);
    input [3:0] rs;
	output [3:0] rd;
	
	wire [3:0] c;
	
    FullAdder FA0(rs[0], 1'b1, 1'b0, rd[0], c[0]);
	FullAdder FA1(rs[1], 1'b0, c[0], rd[1], c[1]);
	FullAdder FA2(rs[2], 1'b0, c[1], rd[2], c[2]);
	FullAdder FA3(rs[3], 1'b0, c[2], rd[3], c[3]);
	
endmodule

//BITWISE_NOR
module BITWISE_NOR(rs, rt, rd);
    input [3:0] rs, rt;
	output[3:0] rd;
	
	nor nor0(rd[3], rs[3], rt[3]);
	nor nor1(rd[2], rs[2], rt[2]);
	nor nor2(rd[1], rs[1], rt[1]);
	nor nor3(rd[0], rs[0], rt[0]);
	
endmodule

//BITWISE_NAND
module BITWISE_NAND(rs, rt, rd);
    input [3:0] rs, rt;
	output[3:0] rd;
	
	nand nor0(rd[3], rs[3], rt[3]);
	nand nor1(rd[2], rs[2], rt[2]);
	nand nor2(rd[1], rs[1], rt[1]);
	nand nor3(rd[0], rs[0], rt[0]);
	
endmodule

//RS_DIV_4
module RS_DIV_4(rs, rd);
    input [3:0] rs;
	output [3:0] rd;
	
	wire not_rs3, not_rs2;
	
	not not0(rd[3], 1'b1);
	not not1(rd[2], 1'b1);
	not not2(not_rs3, rs[3]);
	not not3(not_rs2, rs[2]);
	not not4(rd[1], not_rs3);
	not not5(rd[0], not_rs2);
	
endmodule

//RS_MUL_2
module RS_MUL_2(rs, rd);
    input [3:0] rs;
	output [3:0] rd;
	
	wire not_rs2, not_rs1, not_rs0;
	
	not not0(not_rs2, rs[2]);
	not not1(not_rs1, rs[1]);
	not not2(not_rs0, rs[0]);
	not not3(rd[0], 1'b1);
	not not4(rd[3], not_rs2);
	not not5(rd[2], not_rs1);
	not not6(rd[1], not_rs0);
	
endmodule

//MUL
module MUL (a, b, p);
    input [4-1:0] a, b;
    output [3:0] p;
	
	wire a0b0, a1b0, a2b0, a3b0;
	wire a0b1, a1b1, a2b1, a3b1;
	wire a0b2, a1b2, a2b2, a3b2;
	wire a0b3, a1b3, a2b3, a3b3;
	
	wire out_FA_a0b1, out_FA_a1b1, out_FA_a2b1, out_FA_a3b1;
	wire out_FA_a0b2, out_FA_a1b2, out_FA_a2b2, out_FA_a3b2;
	wire out_FA_a0b3, out_FA_a1b3, out_FA_a2b3, out_FA_a3b3;
	
	wire s_FA_a1b1, s_FA_a2b1, s_FA_a3b1;
	wire s_FA_a1b2, s_FA_a2b2, s_FA_a3b2;
	wire p4, p5, p6, p7;
	
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
	FullAdder FA9(a1b3, s_FA_a2b2, out_FA_a0b3, p4, out_FA_a1b3);
	FullAdder FA10(a2b3, s_FA_a3b2, out_FA_a1b3, p5, out_FA_a2b3);
	FullAdder FA11(a3b3, out_FA_a3b2, out_FA_a2b3, p6, p7);
	
endmodule

module Decode_and_Execute (op_code, rs, rt, rd);
    input [3-1:0] op_code;
    input [4-1:0] rs, rt;
    output [4-1:0] rd;
	
	wire not_op2, not_op1, not_op0;
	wire [3:0] add0, add1;
	wire [3:0] sub0, sub1;
	wire [3:0] inc0, inc1;
	wire [3:0] bitwise_nor0, bitwise_nor1;
	wire [3:0] bitwise_nand0, bitwise_nand1;
	wire [3:0] rs_div_4_0, rs_div_4_1;
	wire [3:0] rs_mul_2_0, rs_mul_2_1;
	wire [3:0] mul0, mul1;
	
	not not0(not_op2, op_code[2]);
	not not1(not_op1, op_code[1]);
	not not2(not_op0, op_code[0]);
	
	ADD _add(rs, rt, add0);
	SUB _sub(rs, rt, sub0);
	INC _inc(rs, inc0);
	BITWISE_NOR _bitwise_nor(rs, rt, bitwise_nor0);
	BITWISE_NAND _bitwise_nand(rs, rt, bitwise_nand0);
	RS_DIV_4  _rs_div_4(rs, rs_div_4_0);
	RS_MUL_2 _rs_mul_2(rs, rs_mul_2_0);
	MUL _MUL(rs, rt, mul0);
	
	and and0(add1[0], add0[0], not_op2, not_op1, not_op0);
	and and1(add1[1], add0[1], not_op2, not_op1, not_op0);
	and and2(add1[2], add0[2], not_op2, not_op1, not_op0);
	and and3(add1[3], add0[3], not_op2, not_op1, not_op0);
	
    and and4(sub1[0], sub0[0], not_op2, not_op1, op_code[0]);
    and and5(sub1[1], sub0[1], not_op2, not_op1, op_code[0]);
    and and6(sub1[2], sub0[2], not_op2, not_op1, op_code[0]);
    and and7(sub1[3], sub0[3], not_op2, not_op1, op_code[0]);
    
    and and8(inc1[0], inc0[0], not_op2, op_code[1], not_op0);
    and and9(inc1[1], inc0[1], not_op2, op_code[1], not_op0);
    and and10(inc1[2], inc0[2], not_op2, op_code[1], not_op0);
    and and11(inc1[3], inc0[3], not_op2, op_code[1], not_op0);
    
    and and12(bitwise_nor1[0], bitwise_nor0[0], not_op2, op_code[1], op_code[0]);
    and and13(bitwise_nor1[1], bitwise_nor0[1], not_op2, op_code[1], op_code[0]);
    and and14(bitwise_nor1[2], bitwise_nor0[2], not_op2, op_code[1], op_code[0]);
    and and15(bitwise_nor1[3], bitwise_nor0[3], not_op2, op_code[1], op_code[0]);
    
    and and16(bitwise_nand1[0], bitwise_nand0[0], op_code[2], not_op1, not_op0);
    and and17(bitwise_nand1[1], bitwise_nand0[1], op_code[2], not_op1, not_op0);
    and and18(bitwise_nand1[2], bitwise_nand0[2], op_code[2], not_op1, not_op0);
    and and19(bitwise_nand1[3], bitwise_nand0[3], op_code[2], not_op1, not_op0);
    
    and and20(rs_div_4_1[0], rs_div_4_0[0], op_code[2], not_op1, op_code[0]);
    and and21(rs_div_4_1[1], rs_div_4_0[1], op_code[2], not_op1, op_code[0]);
    and and22(rs_div_4_1[2], rs_div_4_0[2], op_code[2], not_op1, op_code[0]);
    and and23(rs_div_4_1[3], rs_div_4_0[3], op_code[2], not_op1, op_code[0]);
    
    and and24(rs_mul_2_1[0], rs_mul_2_0[0], op_code[2], op_code[1], not_op0);
    and and25(rs_mul_2_1[1], rs_mul_2_0[1], op_code[2], op_code[1], not_op0);
    and and26(rs_mul_2_1[2], rs_mul_2_0[2], op_code[2], op_code[1], not_op0);
    and and27(rs_mul_2_1[3], rs_mul_2_0[3], op_code[2], op_code[1], not_op0);
    
    and and28(mul1[0], mul0[0], op_code[2], op_code[1], op_code[0]);
    and and29(mul1[1], mul0[1], op_code[2], op_code[1], op_code[0]);
    and and30(mul1[2], mul0[2], op_code[2], op_code[1], op_code[0]);
    and and31(mul1[3], mul0[3], op_code[2], op_code[1], op_code[0]);
    
    or or0(rd[0], add1[0], sub1[0], inc1[0], bitwise_nor1[0], bitwise_nand1[0], rs_div_4_1[0], rs_mul_2_1[0], mul1[0]);	
	or or1(rd[1], add1[1], sub1[1], inc1[1], bitwise_nor1[1], bitwise_nand1[1], rs_div_4_1[1], rs_mul_2_1[1], mul1[1]);
	or or2(rd[2], add1[2], sub1[2], inc1[2], bitwise_nor1[2], bitwise_nand1[2], rs_div_4_1[2], rs_mul_2_1[2], mul1[2]);
	or or3(rd[3], add1[3], sub1[3], inc1[3], bitwise_nor1[3], bitwise_nand1[3], rs_div_4_1[3], rs_mul_2_1[3], mul1[3]);			
endmodule
