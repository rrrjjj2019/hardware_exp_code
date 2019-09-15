`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output out;
output [2-1:0] state;

parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;

reg [2-1:0]next_state;
reg [2-1:0]state;
reg out;

always@(posedge clk) begin
    if(!rst_n)begin
        state <= S0;
    end
    else begin
        state <= next_state;
    end
end

always@(*)begin
    case (state)
        S0:begin
            if(in == 1)begin
                next_state = S1;
                out = 1;
            end
            else begin
                next_state = S0;
                out = 0;
            end
        end
        S1:begin
            if(in == 1)begin
                next_state = S2;
                out = 0;
            end
            else begin
                next_state = S1;
                out = 1;
            end
        end
        S2:begin
            if(in == 1)begin
                next_state = S1;
                out = 0;
            end
            else begin
                next_state = S0;
                out = 0;
            end
        end
    endcase
end


endmodule
