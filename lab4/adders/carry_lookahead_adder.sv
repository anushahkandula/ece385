module carry_lookahead_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a CLA adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
	  //internal logics
	  logic [3:0]    Pg, Gg;
	  logic          C0, C1, C2, C3;
	  
	  
	  always_comb
	  begin
	  
	      //we assume C0 is 0
	      C0 = 1'b0;
			
			//use the expressions in lecture 
			C1 = Gg[0] | (C0 & Pg[0]);
			C2 = Gg[1] | (Gg[0] & Pg[1]) | (C0 & Pg[0] & Pg[1]);		
			C3 = Gg[2] | (Gg[1] & Pg[2]) | (Gg[0] & Pg[2] & Pg[1]) | (C0 & Pg[2] & Pg[1] & Pg[0]);		   
         CO = Gg[3] | (Gg[2] & Pg[3] ) | (Gg[1] & Pg[3] & Pg[2]) | (Gg[0] & Pg[3] & Pg[2] & Pg[1]) | (C0 & Pg[3] & Pg[2] & Pg[1] & Pg[0]);	  

		end	


      //use the bottom-level 4-bit lookahead adders
	   four_bit_cla fourbit_cla1(.A4(A[3:0]), .B4(B[3:0]), .Cin(C0), .S4(Sum[3:0]), .Pg(Pg[0]), .Gg(Gg[0]));
	   four_bit_cla fourbit_cla2(.A4(A[7:4]), .B4(B[7:4]), .Cin(C1), .S4(Sum[7:4]), .Pg(Pg[1]), .Gg(Gg[1]));
	   four_bit_cla fourbit_cla3(.A4(A[11:8]), .B4(B[11:8]), .Cin(C2), .S4(Sum[11:8]), .Pg(Pg[2]), .Gg(Gg[2])); 		
	   four_bit_cla fourbit_cla4(.A4(A[15:12]), .B4(B[15:12]), .Cin(C3), .S4(Sum[15:12]), .Pg(Pg[3]), .Gg(Gg[3]));
		
endmodule





//this bottem-level module is used to built the hierarchy
module four_bit_cla
(
    //A4, B4 and S4 are the inputs and outputs of the adder
	 //Pg and Gg are the group progation and generation bits
    input  logic [3:0]       A4,
	 input  logic [3:0]       B4,
	 input  logic             Cin,
	 output logic [3:0]       S4,
	 output logic             Pg,
	 output logic             Gg
);


//the internal logics
// the propagtion and generation bits
logic [3:0] p, g;
//the internal carries
logic c0, c1, c2, c3;


always_comb 
begin
    //create the p and g
	 p  = A4 ^ B4;
	 g  = A4 & B4;
	 
	 //create the carries using expressions in lecture
	 c0 = Cin;
	 c1 = (Cin & p[0]) | g[0];
	 c2 = (Cin & p[0] & p[1]) | (g[0] & p[1]) | g[1];
	 c3 = (Cin & p[0] & p[1] & p[2]) | (g[0] & p[1] & p[2]) | (g[1] & p[2]) | g[2];

    //create the outputs Pg and Gg	 
	 Pg = p[0] & p[1] & p[2] & p[3];
	 Gg = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]);	 

end

//use the full adder module to complete the 4-bit additions
//since the cout of full adder is not used, we don't connet anything to it
full_adder fourbit_adder1(.x(A4[0]), .y(B4[0]), .cin(c0), .s(S4[0]));
full_adder fourbit_adder2(.x(A4[1]), .y(B4[1]), .cin(c1), .s(S4[1]));
full_adder fourbit_adder3(.x(A4[2]), .y(B4[2]), .cin(c2), .s(S4[2]));
full_adder fourbit_adder4(.x(A4[3]), .y(B4[3]), .cin(c3), .s(S4[3]));

endmodule



