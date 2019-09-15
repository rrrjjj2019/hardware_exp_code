`timescale 1ns/1ps

module Carry_Look_Ahead_Adder_t;
    reg [3:0] a = 4'b1111;
    reg [3:0] b = 4'b0001;
    reg cin = 1'b1;
    wire cout;
    wire [3:0] sum;

    Carry_Look_Ahead_Adder ctaa(
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );


endmodule