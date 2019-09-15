`timescale 1ns/1ps

module Comparator_3bits_t;
    reg [2:0]a;
    reg [2:0]b;
    wire a_lt_b, a_gt_b, a_eq_b;
    
    Comparator_3bits c ( .a(a), .b(b), .a_lt_b(a_lt_b), .a_gt_b(a_gt_b), .a_eq_b(a_eq_b));
    
    initial begin
            a=3'b0;
            b=3'b0;
            
            repeat (63) begin
                
                #1 {a, b}={a, b}+1'b1;
            end
            #1  $finish;
        end
    
endmodule