`timescale 1ns/1ps

`define CYC 4

module Greatest_Common_Divisor_t;
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    reg start=1'b0;
    reg [8-1:0] a, b;
    wire done;
    wire [8-1:0] gcd;

    Greatest_Common_Divisor g (
      .clk (clk),
      .rst_n (rst_n),
      .start (start),
	  .a (a),
	  .b (b),
      .done (done),
      .gcd (gcd)
    );

always #(`CYC / 2) clk = ~clk;

initial begin
    
  @ (negedge clk) begin
      rst_n = 1'b0;
	  a = 8'd0;
	  b = 8'd0;
  end
  
 
  @ (negedge clk) rst_n = 1'b1;
  
  @ (negedge clk) begin
      start = 1'b1;
      a = 8'd144;
      b = 8'd12;
  end 
 
  @ (negedge clk) start = 1'b0;

end


always@(*) begin
      if(done==1'b1) begin
	      #(2*`CYC) $finish;
	  end
	  
end

endmodule
