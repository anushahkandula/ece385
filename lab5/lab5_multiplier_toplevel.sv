 //ECE 385 Lab5 (multiplier) code.  This is the top level entity which
 //connects an adder circuit to LEDs and buttons on the device.  
 
 
module lab5_multiplier_toplevel
(
    input   logic           Clk,            // 50MHz clock is only used to get timing estimate data
    input   logic           Reset,          // input used to reset the circuit
    input   logic           ClearA_LoadB,   // input used to clear A,X and load B
    input   logic           Run,            // input used to run 
    input   logic[7:0]      SW,             // From slider switches
    
    // all outputs are registered
    output  logic[6:0]      AhexU,          // Hex drivers display.
    output  logic[6:0]      AhexL,
    output  logic[6:0]      BhexU,
    output  logic[6:0]      BhexL,
	 output  logic[7:0]      Aval,
    output  logic[7:0]      Bval,
	 output  logic           X  
);

    //local logic variables go here
	 logic Reset_SH, ClearA_LoadB_SH, Run_SH;
	 logic [2:0] F_S;
	 logic [1:0] R_S;
	 logic Clr_XA, Clr_Ld, Add, Sub, Shift, Output_A;
	 logic [7:0] A, B, Din_S;
	 logic [8:0] X_A;
	 
	 
	 //assign outputs with A and B
	 assign Aval = A;
	 assign Bval = B;
	 
	 //Instantiation of modules here
	 
	 //shift registers for A
	 reg_8    reg_unit_A (
                        .Clk(Clk),
                        .Reset(Reset_SH |Clr_Ld | Clr_XA), //clear A for input signals ot before each mutiplication
                        .Shift_In(X),
								.Load(Add | Sub),  //only load A in the add states
								.Shift_En(Shift),
								.D(X_A[7:0]),
								.Shift_Out(Output_A),
								.Data_Out(A)
                        );
								
	 //shift registers for B
	 reg_8    reg_unit_B (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Shift_In(Output_A),
								.Load(Clr_Ld),
								.Shift_En(Shift),
								.D(Din_S),  //use the synchronized S
								.Shift_Out(),
								.Data_Out(B)
                        );					
								
	 //flip-flop for extended bit X
	 x_flip_flop    flip_flop_x (
                        .Clk(Clk),
                        .Reset(Reset_SH |Clr_Ld | Clr_XA),
								.Load(Add | Sub),
								.D_In(X_A[8]),  //use the highest bit of X_A
								.D_Out(X)
                        );					
															
								
    //9 bit 2's complement adder and subtractor 
    adder_subtractor_9bit add_sub_9bit (
	                                    .A(A),    
								               .B(Din_S),
								               .sign(Sub),  //sign depends on subtraction or addition
								               .Sum(X_A)
                                       );
								
	 //control unit for the multiplier							
	 control          control_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Run(Run_SH),
                        .ClearA_LoadB(ClearA_LoadB_SH),
                        .M(B[0]),  //M is the least significant bit of B
                        .Shift,
                        .Add,
                        .Sub,
							   .Clr_Ld,
							   .Clr_XA
								);
  								
	 //hex drivers used to display A and B on the screen							
	 HexDriver        HexAL (
                        .In0(A[3:0]),
                        .Out0(AhexL) );
								
	 HexDriver        HexBL (
                        .In0(B[3:0]),
                        .Out0(BhexL) );
								
	 HexDriver        HexAU (
                        .In0(A[7:4]),
                        .Out0(AhexU) );
								
	 HexDriver        HexBU (
                       .In0(B[7:4]),
                        .Out0(BhexU) );
								
	 //Input synchronizers required for asynchronous inputs (in lab5, the inputs are from the switches)
	 sync button_sync[2:0] (Clk, {~Reset, ~ClearA_LoadB, ~Run}, {Reset_SH, ClearA_LoadB_SH, Run_SH});
	 sync Din_sync[7:0] (Clk, SW, Din_S);
	 
endmodule
