`timescale 1ns/1ps

module LFSR (clk, rst_n, out);
    input clk, rst_n;
    output out;

    reg [0:4]DFF;
    wire feedback;
    assign feedback = DFF[1] ^ DFF[4];

    always@(posedge clk)begin
        if(!rst_n)begin
            DFF <= 5'b10010;
        end
        else begin
            DFF[0:4] <= {feedback, DFF[0:3]};
        end
    end
    assign out = DFF[4];

endmodule