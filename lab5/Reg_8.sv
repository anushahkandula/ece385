module reg_8 (input  logic Clk, Reset, Shift_In, Load, Shift_En,
              input  logic [7:0]  D,
              output logic Shift_Out,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
		     //change to 8-bit 0
			  Data_Out <= 8'h0;
		 else if (Load)
			  Data_Out <= D;
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
    end
	
    assign Shift_Out = Data_Out[0];

endmodule


module x_flip_flop
(
    input  logic Clk,
	 input  logic Reset,
	 input  logic Load,
	 input  logic D_In,
	 output logic D_Out
);

    //synchronous D flip-flop for extended bit X
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
		     //change to 0
			  D_Out <= 1'b0;
		 else if (Load)
		     //update the D
			  D_Out <= D_In;
		 else
		     //keep the same values
			  D_Out <= D_Out; 
    end
	 
endmodule
