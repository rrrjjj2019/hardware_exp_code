`timescale 1ns/1ps

module Decoder (din, dout);
    input [4-1:0] din;
    output [16-1:0] dout;
    
    wire not_a, not_b, not_c, not_d;
    
    not not_1(not_a, din[3]);
    not not_2(not_b, din[2]);
    not not_3(not_c, din[1]);
    not not_4(not_d, din[0]);

    and and_1(dout[0], din[3], din[2], din[1], din[0]);
    and and_2(dout[1], din[3], din[2], din[1], not_d);
    and and_3(dout[2], din[3], din[2], not_c, din[0]);
    and and_4(dout[3], din[3], din[2], not_c, not_d);
    and and_5(dout[4], din[3], not_b, din[1], din[0]);
    and and_6(dout[5], din[3], not_b, din[1], not_d);
    and and_7(dout[6], din[3], not_b, not_c, din[0]);
    and and_8(dout[7], din[3], not_b, not_c, not_d);
    and and_9(dout[8], not_a, not_b, not_c, not_d);
    and and_10(dout[9], not_a, not_b, not_c, din[0]);
    and and_11(dout[10], not_a, not_b, din[1], not_d);
    and and_12(dout[11], not_a, not_b, din[1], din[0]);
    and and_13(dout[12], not_a, din[2], not_c, not_d);
    and and_14(dout[13], not_a, din[2], not_c, din[0]);
    and and_15(dout[14], not_a, din[2], din[1], not_d);
    and and_16(dout[15], not_a, din[2], din[1], din[0]);

endmodule
