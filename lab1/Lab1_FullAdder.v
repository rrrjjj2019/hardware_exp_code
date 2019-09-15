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
