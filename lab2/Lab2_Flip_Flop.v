`timescale 1ns/1ps

module Flip_Flop (clk, d, q);
input clk;
input d;
output q;

wire n_clk;
not not_0(n_clk, clk);
wire q1;

Latch Master (
  .clk (n_clk),
  .d (d),
  .q (q1)
);

Latch Slave (
  .clk (clk),
  .d (q1),
  .q (q)
);
endmodule

module Latch (clk, d, q);
  input clk;
  input d;
  output q;

  wire not0, and1, q, and3, and4;
  
  not not_0(not0, d);
  nand and_1(and1, clk, d);
  nand and_3(and3, clk, not0);
  nand and_2(q, and1, and4);
  nand and_4(and4, and3, q);

endmodule
