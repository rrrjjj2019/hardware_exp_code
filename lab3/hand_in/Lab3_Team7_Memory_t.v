`timescale 1ns/1ps


module Memory_t;
    
	parameter cyc = 4;
	parameter memWidth = 8;
	parameter memNumWidth = 6;
	
	parameter dataWidth = 8;
	parameter dataNumWidth = 5;
	
	//about mem 2D array
	reg clk;
    reg ren;
    reg wen;
	reg [memNumWidth - 1 : 0] addr;
	reg [memWidth - 1 : 0] din;
	wire [memWidth - 1 : 0] dout;
	
	
	//about data 2D array
	reg [dataWidth - 1 : 0] dataROM [0 : 31];
	reg [dataNumWidth - 1 : 0] addrInDataROM;
	parameter maxSizeInDataROM = 5'd31;
	
    Memory m(
        .clk(clk),
        .ren(ren),
		.wen(wen),
		.addr(addr),
		.din(din),
        .dout(dout)
    );
	
	
	//to test readfile
	/*
	initial begin
	    $readmemb ("data.txt", dataROM);
        $display("Contents of Mem after reading data file:");
		for (k=0; k<=15; k=k+1) $display("addr:%d, din:%d", dataROM[2*k],dataROM[2*k+1]);
    end
	*/
	

    always #(cyc / 2) clk = ~ clk;


    initial begin
        //read dataROM from data
		$readmemb ("data.txt", dataROM);

		clk = 1'b0;
		ren = 1'b1;
		wen = 1'b1;
		
		addrInDataROM = 5'b00000;
		
		//to test readfile
		/*
		for(addrInDataROM=0;addrInDataROM<=5'd15;addrInDataROM=addrInDataROM+1'd1) begin
		    $display("******************************");
		    $display("addrInDataROM: %d", addrInDataROM);
		    $display("dataROM[ %d ]: %b", addrInDataROM,dataROM[2*addrInDataROM]);
		    addr = dataROM[2 * addrInDataROM];
            $display("addr: %b", dataROM[2*addrInDataROM]);
		end
		$display("******************************");
		$display("******************************");
		$display("******************************");
		$display("******************************");
		$display("******************************");
		*/
		@(negedge clk) wen = 1'b0;
		#(4 * cyc) wen = 1'b1;
		#(3 * cyc) ren =  1'b0;
		#(4 * cyc) ren = 1'b1;
		
    end

	always@(negedge clk) begin
	    if((addrInDataROM * 2 + 1 )<= maxSizeInDataROM) begin
	        
			$display("addrInDataROM: %d", addrInDataROM);
			$display("dataROM[%d]: %b", 2 * addrInDataROM, dataROM[2 * addrInDataROM]);
			$display("addr: %d", addr);
			$display("dataROM[%d]: %b", 2 * addrInDataROM + 1'b1, dataROM[2 * addrInDataROM+1'b1]);
			$display("din: %d", din);
			$display("******************************");
			
			
			addr = dataROM[2 * addrInDataROM];
			din = dataROM[2 * addrInDataROM + 1];
		    addrInDataROM = (addrInDataROM + 1'b1);
	    end
		else begin
		    $finish;
		end
    end

endmodule
    