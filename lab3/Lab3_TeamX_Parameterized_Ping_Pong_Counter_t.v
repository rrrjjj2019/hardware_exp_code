`timescale 1ns/1ps

`define CYC 4

module Parameterized_Ping_Pong_Counter_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg flip = 1'b0;
    reg enable = 1'b0;
    reg [3:0] max = 4'd9;
    reg [3:0] min = 4'd0;

    wire direction;
    wire [3:0] out;

    Parameterized_Ping_Pong_Counter p(
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .flip(flip),
        .max(max),
        .min(min),
        .direction(direction),
        .out(out)
    );

    always #(`CYC/2)clk = ~clk;

    initial begin
        @(negedge clk)
        rst_n = 1'b0;
        @(negedge clk)
        rst_n = 1'b1;
        enable = 1'b1;

        #(`CYC * 10)
        enable = 1'b0;

        #(`CYC * 5)
        enable  = 1'b1;

        #(`CYC * 15)
        flip = 1'b1;
        #(`CYC)
        flip = 1'b0;

        #(`CYC * 20)
        $finish;
    end

endmodule