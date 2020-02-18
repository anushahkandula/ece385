module adder_subtractor_9bit
(
    input   logic[7:0]     A,    //A will be extended to 9 bit
    input   logic[7:0]     B,    //B will be extended to 9 bit
	 input   logic          sign, //1 means add; 0 means subtract
    output  logic[8:0]     Sum
);

     //this 2's complement adder use ripple adders internally
	  //internal logics
	  //internal carriers
	  logic c1, c2;
	  //new B after poetential invertion
	  logic [7:0] B_2;
	  //invert the B if sign is minus
	  assign B_2 = B ^ {8{sign}};
	  
	  //use four bit adders to add the new B with A
	  //carry in works as the potential one for 2's complement
	  four_bit_ra fa0(.X(A[3:0]), .Y(B_2[3:0]), .CIN(sign), .S(Sum[3:0]), .COUT(c1));  
	  four_bit_ra fa1(.X(A[7:4]), .Y(B_2[7:4]), .CIN(c1),   .S(Sum[7:4]), .COUT(c2)); 
	  //use a full bit adder for the extended bit
	  full_adder full_adder1(.x(A[7]), .y(B_2[7]), .cin(c2), .s(Sum[8]), .cout());
	  
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





