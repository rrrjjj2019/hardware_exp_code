`timescale 1ns/1ps

module Binary_to_Grey_t;
    reg [3:0] din = 4'b0000;
    wire [3:0] dout;

    Binary_to_Grey btg(
        .din(din),
        .dout(dout)
    );

    initial begin
      repeat (2**4) begin
        #1 din = din + 1'b1;
      end
      #1 $finish;
    end
    
endmodule