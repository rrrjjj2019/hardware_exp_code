`timescale 1ns/1ps

`define CYC 4

module sliding_window_dector_t;
    reg clk = 1'b1;
    reg in = 1'b0;
    reg rst_n = 1'b0;

    wire dec1, dec2;

    always #(`CYC/2) clk = ~clk;

    Sliding_Window_Detector s(clk, rst_n, in, dec1, dec2);

    /*initial begin
        @(negedge clk)begin
            rst_n = 1;
            in = 0;
        end
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b0;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b0;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b0;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b0;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b0;
        @(negedge clk) in=1'b1;
        @(negedge clk) in=1'b0;
        @(negedge clk) in=1'b1;
        @(negedge clk) $finish;
    end*/
    
    initial begin
            @(negedge clk) begin
                rst_n=1'b1;
                in=1'b0;
            end
            
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) $finish;
        end    
    
endmodule