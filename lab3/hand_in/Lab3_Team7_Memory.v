`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
    input clk;
    input ren, wen;
    input [6-1:0] addr;
    input [8-1:0] din;
    output [8-1:0] dout;

	reg [8-1:0] Mem [0:64-1];
	reg [6-1:0] addrp;
	reg [8-1:0] dinp;
	reg [8-1:0]dout;
	reg renp, wenp;
	
	//sequentials
	always@(posedge clk)begin
	    addrp<=addr;
		dinp<=din;
		renp<=ren;
		wenp<=wen;
	end
	
	//combinational
	always@(*)begin
	    //read
		if(!renp)begin
		    dout=Mem[addrp];
		end
		//write
		else if((!wenp)&&renp)begin
		    Mem[addrp]=dinp;
			dout=8'b0;
		end
		//do nothing
		else begin
		    dout=8'b0;
		end
	end
	
endmodule
