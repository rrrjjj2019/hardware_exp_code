`timescale 1ns/1ps

module Mux_1bit (a, b, sel, f);
input a, b;
input sel;
output f;
wire out1, out2, n_sel;

not not_1(n_sel, sel);

and and_1(out1, sel, a);
and and_2(out2, n_sel, b);
or or_1(f, out1, out2);

endmodule
