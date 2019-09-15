/*module debounce(pb, clk, pb_debounce);
    input pb, clk;
    output pb_debounce;

    reg [3:0] DFF;

    always @(posedge clk)begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end

    assign pb_debounce = (DFF == 4'b1111)?1'b1:1'b0;

endmodule

module onepluse(pb, clk, pb_onepluse);
    input pb, clk;
    output pb_onepluse;

    reg pb_delay;
    reg pb_onepluse;

    always @(posedge clk)begin
        pb_delay <= pb;
        pb_onepluse <= pb & (!pb_delay);
    end

endmodule*/

module divn(clk, rst_n, o_clk);
    input clk, rst_n;
    output o_clk;

    reg [4:0] counter_p, counter_n;
    reg clk_p, clk_n;

    parameter N = 8;

    assign o_clk = (N == 1) ? clk_p:
                    (N[0] == 1)? clk_p|clk_n:clk_p;

    always @(posedge clk)begin
        if(!rst_n)begin
            counter_p <= 0;
        end
        else begin
            if(counter_p == (N - 1))begin
                counter_p <= 0;
            end
            else begin
                counter_p <= counter_p + 1;
            end
        end
        
    end

    always @(posedge clk)begin
        if(!rst_n)begin
            clk_p <= 0;
        end
        else begin
            if(counter_p < (N >> 1))begin
                clk_p <= 1;
            end
            else begin
                clk_p <= 0;
            end
        end
    end

    always @(posedge clk)begin
        if(!rst_n)begin
            counter_n <= (N>>1);
        end
        else begin
            if(counter_n == 0)begin
                counter_n <= (N >> 1);
            end
            else begin
                counter_n <= counter_n - 1;
            end
        end
    end

    always @(posedge clk)begin
        if(!rst_n)begin
            clk_n <= 0;
        end
        else begin
            if(counter_n > (N >> 1))begin
                clk_n <= 1;
            end
            else begin
                clk_n <= 0;
            end
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