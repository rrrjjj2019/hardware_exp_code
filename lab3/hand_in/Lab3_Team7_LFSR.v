`timescale 1ns/1ps

module LFSR (clk, rst_n, out);
    input clk, rst_n;
    output out;
    
    reg [0:4] DFF;
    wire feedback;
    reg out;

    assign feedback = DFF[1] ^ DFF[4];

    always @(posedge clk) begin
        if(!rst_n)begin
            DFF <= 5'b10010;
        end
        else begin
            DFF <= {feedback, DFF[0:3]};
            out <= DFF[4];
        end
    end

endmodule
