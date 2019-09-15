`timescale 1ns/1ps

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
XOR XOR_2(cin, xor1, xor2);

wire sum = xor2;
and and_1(and1, a, b);
and and_2(and2, a, cin);
and and_3(and3, b, cin);
or or_1(or1, and1, and2);
or or_2(cout, or1, and3);
//wire cout = (a&b) | (a&cin) | (b&cin);
endmodule

module RippleCarryAdder (a, b, cin, cout, sum);
    input [4-1:0] a, b;
    input cin;
    output [4-1:0] sum;
    output cout;

    wire c1, c2, c3;

    FullAdder f0(a[0], b[0], cin, c1, sum[0]);
    FullAdder f1(a[1], b[1], c1, c2, sum[1]);
    FullAdder f2(a[2], b[2], c2, c3, sum[2]);
    FullAdder f3(a[3], b[3], c3, cout, sum[3]);

endmodule
