`timescale 1ns/1ps

`define CYC 4

module Mealy_t;
reg clk = 1'b1;
reg rst_n = 1'b1;
reg in = 1'b0;
wire dec;

Mealy_Sequence_Detector m (
  .clk (clk),
  .rst_n (rst_n),
  .in (in),
  .dec (dec)
);

always #(`CYC / 2) clk = ~clk;

initial begin
  @ (negedge clk) rst_n = 1'b0;
  @ (posedge clk)
  @ (negedge clk) 
    rst_n = 1'b1;
    in = 1'b1;
  
  @ (negedge clk) in = 1'b1;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b1;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b1;
  @ (negedge clk) in = 1'b1;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b1;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) in = 1'b0;
  @ (negedge clk) $finish;
end

endmodule
