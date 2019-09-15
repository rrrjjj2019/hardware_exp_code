module debounced(pb_debounced, pb, clk);
    output pb_debounced;
    input pb, clk;

    reg [3:0]DFF;
    
    always @(posedge clk)begin
        DFF[3:1] <= DFF[2:0];
        DFF[0] <= pb;
    end

    assign pb_debounced = ((DFF == 4'b1111)?1'b1:1'b0);

endmodule

module onepulse(pb_onepulse, pb_debounced, clk);
    output pb_onepulse;
    input pb_debounced, clk;

    reg pb_delay;

    always@(posedge clk)begin
        pb_onepulse <= (pb_debounced) & (!pb_delay);
        pb_delay <= pb_debounced;
    end
endmodule