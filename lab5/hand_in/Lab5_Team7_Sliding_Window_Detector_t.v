`timescale 1ns / 1ps

`define CYC 4

module Sliding_Window_Detector_t;
    reg clk=1'b1;
    reg in=1'b0;
    reg rst_n=1'b0;
    
    wire dec1;
    wire dec2;
    
    always #(`CYC / 2) clk = ~clk;
    
    Sliding_Window_Detector s0(clk, rst_n, in, dec1, dec2);
    /*
    // to test dec1
    initial begin
        @(negedge clk) begin
            rst_n=1'b1;
            in=1'b0;
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
    end
    */
    // to test dec2
    /*initial begin
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
    */
    // a general test
    initial begin
            @(negedge clk) begin
                rst_n=1'b1;
                in=1'b0;
            end
            
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
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
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b1;
            @(negedge clk) in=1'b0;
            @(negedge clk) in=1'b1;
            
            @(negedge clk) $finish;
        end    
    

endmodule
