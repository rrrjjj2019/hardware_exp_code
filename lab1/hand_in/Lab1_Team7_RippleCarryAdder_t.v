`timescale 1ns/1ps

module RippleCarryAdder_t;
    reg [3:0] a = 4'b0101;
    reg [3:0] b = 4'b0110;
    reg cin = 1'b0;
    wire [3:0] sum;
    wire cout;

    RippleCarryAdder r0(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );



endmodule