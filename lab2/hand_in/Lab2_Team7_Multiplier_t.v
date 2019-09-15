`timescale 1ns/1ps

module Multiplier_t;
    reg [3:0]a;
    reg [3:0]b;
    wire [7:0]p;
    
    Multiplier m( .a(a), .b(b), .p(p));
    
    initial begin
            a=4'b0;
            b=4'b0;
            
            repeat (255) begin
                
                #1 {a, b}={a, b}+1'b1;
            end
            #1  $finish;
        end
    
endmodule