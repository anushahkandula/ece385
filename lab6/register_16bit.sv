//16 bit register
module register_16
(
    input  logic Clk,
	 input  logic Load,
	 input  logic Reset,
	 input  logic [15:0] Data_In,
	 output logic [15:0] Data_Out	 
);
	 
	 
    always_ff @ (posedge Clk)
    begin
	    
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
		     //change to 16-bit 0
			  Data_Out <= 16'b0;
		 else if (Load)
			  Data_Out <= Data_In;
	 end
	 
endmodule

//the register file 
module register_file
(
    input logic Clk,
	 input logic Load,
	 input logic Reset,
	 input logic [2:0] SR1_In, SR2_In, DR_In,
	 input logic [15:0] In,
	 output logic [15:0] SR1_Out, SR2_Out
);

    //internal register array
    logic [15:0] data [7:0];
    	 
    always_ff @(posedge Clk)
    begin
	     //clear the all 8 registers
	     if (Reset)
		  begin
		      data[0] <= 16'b0;
		      data[1] <= 16'b0;
		      data[2] <= 16'b0;
		      data[3] <= 16'b0;
		      data[4] <= 16'b0;
		      data[5] <= 16'b0;
		      data[6] <= 16'b0;
		      data[7] <= 16'b0;				
		  end
        //load the detination register with the bus input
        else if (Load)
        begin
            data[DR_In] <= In;
        end
    end

    //update both the SR1 and SR2	 
    always_comb
    begin
        SR1_Out = data[SR1_In];
        SR2_Out = data[SR2_In];
    end
    
endmodule
    