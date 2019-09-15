`timescale 1ns/1ps

module Decode_and_Execute_t;
    reg [2:0] op_code;
    reg [3:0] rs, rt;
    wire [3:0] rd;
    
    Decode_and_Execute DE( .op_code(op_code), .rs(rs), .rt(rt), .rd(rd));
    
    initial begin
            rs=4'b0;
            rt=4'b0;
			op_code=3'b0;
            
            repeat (683) begin
                
                #1 {op_code, rs, rt}={op_code, rs, rt}+2'b11;
            end
            #1  $finish;
        end
    
endmodule