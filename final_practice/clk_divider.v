`timescale 1ns/1ps

module divn(clk, rst_n, o_clk);
    input clk, rst_n;
    output o_clk;

    parameter N = 6;
    reg [30:0]counter;
    reg o_clk;

    always@(posedge clk)begin
        if(!rst_n)begin
            counter <= 0;
        end
        else if (counter == (N-1)) begin
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end

    always@(posedge clk)begin
        if(!rst_n)begin
            o_clk <= 0;
        end
        else if(counter < (N>>1))begin //not<=
            o_clk <= 1;
        end
        else begin
            o_clk <= 0;
        end
    end

endmodule

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
    input clk, rst_n;
    input [2-1:0] sel;
    output clk1_2;
    output clk1_4;
    output clk1_8;
    output clk1_3;
    output dclk;

    wire n_sel_1, n_sel_0;
    wire and1, and2, and3, and4, and5, and6, and7, and8, and9, and10;

    divn #(2)d2(clk, rst_n, clk1_2);
    divn #(4)d4(clk, rst_n, clk1_4);
    divn #(8)d8(clk, rst_n, clk1_8);
    divn #(3)d3(clk, rst_n, clk1_3);

    not not1(n_sel_0, sel[0]);
    not not2(n_sel_1, sel[1]);

    and and_1(and1, clk1_2, n_sel_1, n_sel_0);
    and and_2(and2, clk1_4, n_sel_1, sel[0]);
    and and_3(and3, clk1_8, sel[1], n_sel_0);
    and and_4(and4, clk1_3, sel[1], sel[0]);

    or or_1(dclk, and1, and2, and3, and4);

endmodule
