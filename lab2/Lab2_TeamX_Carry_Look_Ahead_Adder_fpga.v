`timescale 1ns/1ps

//here is modules from lab1#######################################
module XOR (a, b, out);
	input a, b;
	output out;
	wire out1, out2, out3;
	nand nand1(out1, a, b);
	nand nand2(out2, a, out1);
	nand nand3(out3, b, out1);
	nand nand4(out, out2, out3);

endmodule

module FullAdder (a, b, cin, cout, sum);
    input a, b;
    input cin;
    output sum;
    output cout;

    wire xor1, xor2;
    wire and1, and2, and3;
    wire or1;


    XOR XOR_1(a, b, xor1);
    XOR XOR_2(cin, xor1, sum);

    and and_1(and1, a, b);
    and and_2(and2, a, cin);
    and and_3(and3, b, cin);
    or or_1(or1, and1, and2);
    or or_2(cout, or1, and3);
endmodule
//here is modules from lab1#######################################

module Carry_Look_Ahead_Adder (SW, AN, seg, DP);
    input [8:0] SW;
    output [3:0] AN;
    output [0:6] seg;
    output DP;

    wire cout;
    wire [4-1:0] sum;
    wire [3:0] P, G, C;
    wire and1, and2, and3, and4, and5, and6, and7, and8, and9, and10, and11, and12, and13, and14, and15, and16, and17, and18, and19, and20, and21, and22, and23, and24, and25, and26, and27, and28, and29, and30, and31, and32, and33, and34, and35, and36, and37, and38, and39, and40;
    wire not1, not2;
    wire or1;
    wire cout0, cout1, cout2, cout3;
    wire nota, notb, notc, notd;
    wire not_cout;

    and and_a(G[0], SW[5], SW[1]);
    and and_b(G[1], SW[6], SW[2]);
    and and_c(G[2], SW[7], SW[3]);
    and and_d(G[3], SW[8], SW[4]);

    xor xor_a(P[0], SW[5], SW[1]);
    xor xor_b(P[1], SW[6], SW[2]);
    xor xor_c(P[2], SW[7], SW[3]);
    xor xor_d(P[3], SW[8], SW[4]);

    //c[0]
    not not_1(not1, SW[0]);
    not not_2(C[0], not1);

    //c[1]
    and and_2(and2, P[0], C[0]);
    or or_1(C[1], G[0], and2);

    //c[2]
    and and_3(and3, P[1], G[0]);
    and and_4(and4, P[1], P[0], C[0]);
    or or_2(C[2], G[1], and3, and4);

    //c[3]
    and and_5(and5, P[2], G[1]);
    and and_6(and6, P[2], P[1], G[0]);
    and and_7(and7, P[2], P[1], P[0], C[0]);
    or or_3(C[3], G[2], and5, and6, and7);

    //cout
    and and_8(and8, P[3], G[2]);
    and and_9(and9, P[3], P[2], G[1]);
    and and_10(and10, P[3], P[2], P[1], G[0]);
    and and_11(and11, P[3], P[2], P[1], P[0], C[0]);
    or or_4(cout, G[3], and8, and9, and10, and11);

    //sum
    FullAdder f0(SW[5], SW[1], C[0], cout0, sum[0]);
    FullAdder f1(SW[6], SW[2], C[1], cout1, sum[1]);
    FullAdder f2(SW[7], SW[3], C[2], cout2, sum[2]);
    FullAdder f3(SW[8], SW[4], C[3], cout3, sum[3]);

    //AN
    not not_3(not2, SW[8]);
    or or_5(AN[3], SW[8], not2);
    or or_6(AN[2], SW[8], not2);
    or or_7(AN[1], SW[8], not2);
    or or_8(or1, SW[8], not2);
    not not_4(AN[0], or1);

    //seg
    not not_5(nota, sum[3]);
    not not_6(notb, sum[2]);
    not not_7(notc, sum[1]);
    not not_8(notd, sum[0]);

    //seg[0]
    and and_12(and12, nota, notb, notc, sum[0]);
    and and_13(and13, nota, sum[2], notc, notd);
    and and_14(and14, sum[3], sum[2], notc, sum[0]);
    and and_15(and15, sum[3], notb, sum[1], sum[0]);
    or or_9(seg[0], and12, and13, and14, and15);

    //seg[1]
    and and_16(and16, sum[3], sum[2], notc, notd);
    and and_17(and17, nota, sum[2], notc, sum[0]);
    and and_18(and18, sum[3], sum[1], sum[0]);
    and and_19(and19, sum[3], sum[2], sum[1]);
    and and_20(and20, sum[2], sum[1], notd);
    or or_10(seg[1], and16, and17, and18, and19, and20);

    //seg[2]
    and and_21(and21, sum[3], sum[2], notc, notd);
    and and_22(and22, nota, notb, sum[1], notd);
    and and_23(and23, sum[3], sum[2], sum[1]);
    or or_11(seg[2], and21, and22, and23);

    //seg[3]
    and and_24(and24, nota, sum[2], notc, notd);
    and and_25(and25, nota, notb, notc, sum[0]);
    and and_26(and26, sum[2], sum[1], sum[0]);
    and and_27(and27, sum[3], notb, sum[1], notd);
    or or_12(seg[3], and24, and25, and26, and27);

    //seg[4]
    and and_28(and28, nota, sum[2], notc);
    and and_29(and29, notb, notc, sum[0]);
    and and_30(and30, nota, sum[0]);
    or or_13(seg[4], and28, and29, and30);

    //seg[5]
    and and_31(and31, sum[3], sum[2], notc, sum[0]);
    and and_32(and32, nota, notb, sum[0]);
    and and_33(and33, nota, sum[1], sum[0]);
    and and_34(and34, nota, notb, sum[1]);
    or or_14(seg[5], and31, and32, and33, and34);

    //seg[6]
    and and_35(and35, sum[3], sum[2], notc, notd);
    and and_36(and36, nota, sum[2], sum[1], sum[0]);
    and and_37(and37, nota, notb, notc);
    or or_15(seg[6], and35, and36, and37);

    //DP
    not not_9(DP, cout);
    
endmodule
