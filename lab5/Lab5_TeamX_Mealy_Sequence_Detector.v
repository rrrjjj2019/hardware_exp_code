`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec/*, state*/);
    input clk, rst_n;
    input in;
    output dec;
   // output [1:0] state;

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;

    reg dec;
    reg [1:0] state, next_state;
    reg [1:0] counter_1100, next_counter_1100;
    reg [1:0] counter_0011, next_counter_0011;

    always @(posedge clk) begin
        if(!rst_n)begin
            state <= S0;
            counter_1100 <= 0;
            counter_0011 <= 0;
        end
        else begin
            state <= next_state;
            counter_1100 <= next_counter_1100;
            counter_0011 <= next_counter_0011;
        end
    end

    always@(*)begin
        case (state)
            S0:begin
                next_state = S1;
                if(in == 1)begin
                    dec = 0;
                    next_counter_1100 = counter_1100 + 1;
                    next_counter_0011 = counter_0011;
                end
                else begin
                    dec = 0;
                    next_counter_1100 = counter_1100;
                    next_counter_0011 = counter_0011 + 1;
                end
            end
            S1:begin
                next_state = S2;
                if(in == 0)begin
                    dec = 0;
                    next_counter_0011 = counter_0011 + 1;
                    next_counter_1100 = counter_1100;
                end
                else begin
                    dec = 0;
                    next_counter_1100 = counter_1100 + 1;
                    next_counter_0011 = counter_0011;
                end
            end
            S2:begin
                next_state = S3;
                if(in == 0)begin
                    dec = 0;
                    next_counter_1100 = counter_1100 + 1;
                    next_counter_0011 = counter_0011;
                end
                else begin
                    dec = 0;
                    next_counter_0011 = counter_0011 + 1;
                    next_counter_1100 = counter_1100;
                end
            end
            S3:begin
                next_state = S0;
                next_counter_0011 = 0;
                next_counter_1100 = 0;
                if(in == 1)begin
                    if(counter_0011 == 2'd3)begin
                        dec = 1;
                    end
                    else begin
                        dec = 0;
                    end
                end
                else begin
                    if(counter_1100 == 2'd3)begin
                        dec = 1;
                    end
                    else begin
                        dec = 0;
                    end
                end

                /*if(counter_1100 == 2'd3)begin
                    if(in == 0)begin
                        next_dec = 1;
                        $display("counter_1100_output");
                    end
                    else begin
                        next_dec = 0;
                    end
                end

                if(counter_0011 == 2'd3)begin
                    if(in == 1)begin
                        next_dec = 1;
                        $display("counter_0011_output");
                    end
                    else begin
                        next_dec = 0;
                    end
                end*/
            end
        endcase
    end

endmodule
