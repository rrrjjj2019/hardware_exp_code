`timescale 1ns/1ps

module Mux_8bits_t;
    reg[7:0] a;
    reg [7:0]b;
    reg sel = 1'b0;
    wire [7:0] f;
    Mux_8bits m1 (  .a (a),  .b (b),  .sel (sel),  .f (f)  );
    
    initial begin
        a=8'b0;
        b=8'b0;
        
        repeat (2000000) begin
            
            #1 {sel, a, b}={sel, a, b}+7'b1111111;
        end
        #1  $finish;
    end
endmodule
