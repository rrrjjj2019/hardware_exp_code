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

module Carry_Look_Ahead_Adder (a, b, cin, cout, sum);
    input [4-1:0] a, b;
    input cin;
    output cout;
    output [4-1:0] sum;

    wire [3:0] P, G, C;
    wire and1, and2, and3, and4, and5, and6, and7, and8, and9, and10, and11;
    wire not1;
    wire cout0, cout1, cout2, cout3;

    and and_a(G[0], a[0], b[0]);
    and and_b(G[1], a[1], b[1]);
    and and_c(G[2], a[2], b[2]);
    and and_d(G[3], a[3], b[3]);

    xor xor_a(P[0], a[0], b[0]);
    xor xor_b(P[1], a[1], b[1]);
    xor xor_c(P[2], a[2], b[2]);
    xor xor_d(P[3], a[3], b[3]);

    //c[0]
    not not_1(not1, cin);
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
    FullAdder f0(a[0], b[0], C[0], cout0, sum[0]);
    FullAdder f1(a[1], b[1], C[1], cout1, sum[1]);
    FullAdder f2(a[2], b[2], C[2], cout2, sum[2]);
    FullAdder f3(a[3], b[3], C[3], cout3, sum[3]);

endmodule
