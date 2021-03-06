//this module is the ALU of the LC3
module  ALU (
    input logic  [15:0] A, B,
    input logic  [1:0]  ALUK,
    output logic [15:0] Output
);
    always_comb
    begin
	     //perform the operation according to the ALUK signal
	     case(ALUK)
	     2'b00: Output = A + B;
	     2'b01: Output = A & B;
	     2'b10: Output = ~A;
	     2'b11: Output = A;
	     endcase
    end

endmodule 