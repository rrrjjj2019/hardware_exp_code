`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec/*, state*/);
    input clk, rst_n;
    input in;
    output dec;
    //output [1:0]state;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg dec;
    reg [1:0] state, next_state;
    reg [1:0] counter, next_counter;

    always @(posedge clk) begin
        if(!rst_n)begin
            state <= S0;
            counter <= 0;
        end
        else begin
            state <= next_state;
            counter <= next_counter;
        end
    end

    always@(*)begin
        case (state)
            S0:begin
                next_state = S1;
                if(in == 1)begin
                    dec = 0;
                    next_counter = counter + 1;
                end
                else begin
                    dec = 0;
                    next_counter = counter;
                end
            end
            S1:begin
                next_state = S2;
                if(in == 0)begin
                    dec = 0;
                    next_counter = counter + 1;
                end
                else begin
                    dec = 0;
                    next_counter = counter;
                end
            end
            S2:begin
                next_state = S3;
                if(in == 0)begin
                    dec = 0;
                    next_counter = counter + 1;
                end
                else begin
                    dec = 0;
                    next_counter = counter;
                end
            end
            S3:begin
                next_state = S0;
                if(in == 1)begin
                    if(counter == 2'd3)begin
                        dec = 1;
                    end
                    else begin
                        dec = 0;
                    end
                    next_counter = 0;
                end
                else begin
                    dec = 0;
                    next_counter = 0;
                end
            end
        endcase
    end

endmodule
