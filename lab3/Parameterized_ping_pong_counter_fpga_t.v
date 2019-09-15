`timescale 1ns/1ps

`define CYC 10

module Ping_Pong_Counter_fpga_t();
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg flip = 1'b0;
    reg enable = 1'b1;
    reg [3:0] max = 4'd9;
    reg [3:0] min = 4'd0;

    wire [0:6] out;
    wire [3:0] AN;
    wire divided_clk;
    wire onepluse_reset;
    wire debounced_reset;

    fpga f(
        .clk(clk),
        .max(max),
        .min(min),
        .enable(enable),
        .flip(flip),
        .reset(rst_n),
        .out(out),
        .AN(AN),
        .divided_clk(divided_clk),
        .onepluse_reset(onepluse_reset),
        .debounced_reset(debounced_reset)
    );

    always #(`CYC/2) clk = ~clk;

    initial begin
        @(negedge clk)
        rst_n = 1'b0;
        @(negedge clk)
        rst_n = 1'b1;
        enable = 1'b1;


        #(`CYC * 524300)
        enable  = 1'b1;

        #(`CYC * 1524300)
        flip = 1'b1;
        #(`CYC * 1524300)
        flip = 1'b0;

    end

endmodule