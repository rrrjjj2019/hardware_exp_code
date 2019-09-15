`timescale 1ns/1ps

module Sliding_Window_Detector (clk, rst_n, in, dec1, dec2);
    input clk, rst_n;
    input in;
    output dec1, dec2;
	
	reg [2:0]state1, next_state1;
	reg [1:0]state2, next_state2;
	
	reg dec1;
	reg dec2;
	
	parameter S0=3'b000;
	parameter S1=3'b001;
	parameter S2=3'b010;
	parameter S3=3'b011;
	parameter S4=3'b100;
	parameter S5=3'b101;
	
	parameter SP0=2'b00;
	parameter SP1=2'b01;
	parameter SP2=2'b10;
	parameter SP3=2'b11;
	//============dec1===========================
	always@(posedge clk) begin
	    if(!rst_n) begin
			state1<=S0;
		end
		else begin
		    state1<=next_state1;
		end
	end
	
	always@(*) begin
	    case(state1) 
		    S0: begin
			    next_state1=(in==1'b0)? S0:S1;
				dec1=(in==1'b0)? 1'b0:1'b0;
			end
			S1: begin
			    next_state1=(in==1'b0)? S2:S3;
				dec1=(in==1'b0)? 1'b0:1'b0;
			end
			S2: begin
			    next_state1=(in==1'b0)? S0:S5;
				dec1=(in==1'b0)? 1'b0:1'b1;
			end
			S3: begin
			    next_state1=(in==1'b0)? S0:S4;
				dec1=(in==1'b0)? 1'b0:1'b0;
			end
			S4: begin
			    next_state1=S4;
				dec1=1'b0;
			end
			S5: begin
			    next_state1=(in==1'b0)? S2:S3;
                dec1=(in==1'b0)? 1'b0:1'b0;
			end
			
			default: begin
			    next_state1=S0;
				dec1=(in==1'b0)? 1'b0:1'b0;
			end
		endcase
	end
	//================dec2========================
	always@(posedge clk) begin
        if(!rst_n) begin
            state2<=SP0;
        end
        else begin
            state2<=next_state2;
        end
    end	
    
    always@(*) begin
        case(state2) 
            SP0: begin
                next_state2=(in==1'b0)? S1:S0;
                dec2=(in==1'b0)? 1'b0:1'b0;
            end
            SP1: begin
                next_state2=(in==1'b0)? S1:S2;
                dec2=(in==1'b0)? 1'b0: 1'b0;
            end
            SP2: begin
                next_state2=(in==1'b0)? S1:S3;
                dec2=(in==1'b0)? 1'b0:1'b0;
            end
            SP3: begin
                next_state2=(in==1'b0)? S1:S0;
                dec2=(in==1'b0)? 1'b1:1'b0;
            end
        endcase
    end
endmodule
