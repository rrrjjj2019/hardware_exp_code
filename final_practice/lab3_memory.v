`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
    input clk;
    input ren, wen;
    input [6-1:0] addr;
    input [8-1:0] din;
    output [8-1:0] dout;

    reg [8-1:0] memory [0:63];
    reg [6-1:0] addrp;
    reg [8-1:0] dinp;
    reg renp, wenp;
    reg [8-1:0] dout;

    always@(posedge clk)begin
        addrp <= addr;
        dinp <= din;
        renp <= ren;
        wenp <= wen;
    end

    always@(*)begin//all+p
        if(!renp)begin
            dout = memory[addrp];
        end
        else if((!wenp)&&renp)begin
            memory[addrp] = dinp;
            dout = 0; //don't forget
        end
        else begin
            dout = 0;
        end
    end

endmodule