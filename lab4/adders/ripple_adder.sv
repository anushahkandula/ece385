module ripple_adder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Sum,
    output  logic           CO
);

    /* TODO
     *
     * Insert code here to implement a ripple adder.
     * Your code should be completly combinational (don't use always_ff or always_latch).
     * Feel free to create sub-modules or other files. */
     //internal carries
	  logic c1, c2, c3;
	  
	  four_bit_ra fa0(.X(A[3:0]),   .Y(B[3:0]),   .CIN(0),  .S(Sum[3:0]),   .COUT(c1));  
	  four_bit_ra fa1(.X(A[7:4]),   .Y(B[7:4]),   .CIN(c1), .S(Sum[7:4]),   .COUT(c2)); 
	  four_bit_ra fa2(.X(A[11:8]),  .Y(B[11:8]),  .CIN(c2), .S(Sum[11:8]),  .COUT(c3)); 
	  four_bit_ra fa3(.X(A[15:12]), .Y(B[15:12]), .CIN(c3), .S(Sum[15:12]), .COUT(CO)); 
	  
endmodule

	  
	  
	  
	  
module full_adder
(
    input  logic    x, y, cin,
	 output logic    s, cout
	 
);

always_comb
begin
    //logic expressions the one bit adder
    s = x ^ y ^ cin;
    cout = (x&y) | (y&cin) | (cin&x);
end
     
endmodule





module four_bit_ra
(
    input  logic [3:0]   X, Y,
	 input  logic         CIN,
	 output logic [3:0]   S,
	 output logic         COUT 
);
 
    //internal signals for carries 
    logic c_temp1, c_temp2, c_temp3;
	 //use the full adder module to calculate each bit
	 full_adder full_adder1(.x(X[0]), .y(Y[0]), .cin(CIN),     .s(S[0]), .cout(c_temp1));
	 full_adder full_adder2(.x(X[1]), .y(Y[1]), .cin(c_temp1), .s(S[1]), .cout(c_temp2));	 
	 full_adder full_adder3(.x(X[2]), .y(Y[2]), .cin(c_temp2), .s(S[2]), .cout(c_temp3));
	 full_adder full_adder4(.x(X[3]), .y(Y[3]), .cin(c_temp3), .s(S[3]), .cout(COUT));

endmodule
