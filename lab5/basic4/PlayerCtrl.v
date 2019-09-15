//
//
//
//

module PlayerCtrl (
	input clk,
	input reset,
	input dir,
	output reg [7:0] ibeat
);
parameter BEATLEAGTH = 14; //original 63

always @(posedge clk/*, posedge reset*/) begin
	if (reset) begin
		ibeat <= 8'd0;
	end
	else if (dir == 8'd0) begin //ascend
		if(ibeat < BEATLEAGTH)begin
			ibeat <= ibeat + 1;
		end
		else begin
			ibeat <= 8'd14; //original 0
		end
	end
	else begin  //decend
		if(ibeat > 0)begin
			ibeat <= ibeat - 1;
		end
		else begin
			ibeat <= 0;
		end
	end
end

endmodule