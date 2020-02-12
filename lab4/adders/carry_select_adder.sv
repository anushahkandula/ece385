module carry_select_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a carry select.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  //internal logics
	  logic c1, c2, c3;
	  //use 3 four_bit select adders and 1 four_bit ripple adder
	  four_bit_ra  fcra1(.X(A[3:0]),    .Y(B[3:0]),    .CIN(1'b0), .S(Sum[3:0]),    .COUT(c1));
	  four_bit_csa fcsa1(.A4(A[7:4]),   .B4(B[7:4]),   .Cin(c1),   .S4(Sum[7:4]),  .COUT(c2));	  
	  four_bit_csa fcsa2(.A4(A[11:8]),  .B4(B[11:8]),  .Cin(c2),   .S4(Sum[11:8]),  .COUT(c3));
	  four_bit_csa fcsa3(.A4(A[15:12]), .B4(B[15:12]), .Cin(c3),   .S4(Sum[15:12]), .COUT(CO));
     
endmodule



module four_bit_csa
(
    //A4, B4 and S4 are the inputs and outputs of the adder
	 //Pg and Gg are the group progation and generation bits
    input  logic [3:0]       A4,
	 input  logic [3:0]       B4,
	 input  logic             Cin,
	 output logic [3:0]       S4,
	 output logic             COUT
);

    //internal logics
    logic  [3:0]  sum0, sum1;
	 logic         C0, C1;
	 
	 //use the four bit ripple adders module
	 four_bit_ra fa0(.X(A4),   .Y(B4),   .CIN(1'b0),  .S(sum0),   .COUT(C0));  
	 four_bit_ra fa1(.X(A4),   .Y(B4),   .CIN(1'b1),  .S(sum1),   .COUT(C1));  
	 
	 //select the result according to the input carry
	 always_comb
	 begin
	     //choose according to Cin
		  if (Cin == 1'b1)
		      begin
				    S4   = sum1;
					 COUT = C1;				
				end
		   else
		      begin
				    S4   = sum0;
					 COUT = C0;				
				end			
	 
	 end

endmodule	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
