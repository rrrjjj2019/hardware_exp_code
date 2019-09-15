`timescale 1ns/1ps
`define CYC 4

module gcd_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg start = 1'b0;
    reg [7:0]a, b;
    wire [7:0] gcd;
    wire done;

    Greatest_Common_Divisor gcd1(
        .clk(clk), 
        .rst_n(rst_n), 
        .start(start), 
        .a(a), 
        .b(b), 
        .done(done), 
        .gcd(gcd)
    );

    always #(`CYC / 2) clk = ~clk;

    initial begin
        @(negedge clk)begin
            rst_n = 1'b0;
            a = 0;
            b = 0;
        end

        @(negedge clk)begin
            rst_n = 1'b1;
        end

        @(negedge clk)begin
            start = 1'b1;
            a = 8'd144;
            b = 8'd12;
        end

        @(negedge clk)begin
            start = 1'b0;
        end
        
        /*if(done==1'b1)begin
            #(2*`CYC)$finish;
        end*/
        
    end
    
    always@(*)begin
        if(done==1'b1)begin
            #(2*`CYC)$finish;
        end
    end

endmodule