module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic           Clk;            // 50MHz clock is only used to get timing estimate data
logic           Reset;          // input used to reset the circuit
logic           ClearA_LoadB;   // input used to clear A,X and load B
logic           Run;            // input used to run 
logic[7:0]      SW;            // From slider switches
    
// all outputs are registered
logic[6:0]      AhexU;         
logic[6:0]      AhexL;
logic[6:0]      BhexU;
logic[6:0]      BhexL;
logic[7:0]      Aval;
logic[7:0]      Bval;
logic           X;  


						
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
lab5_multiplier_toplevel lab(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 0;		// Toggle Rest
ClearA_LoadB = 1;
Run = 1;

#2 Reset = 1;

#2 SW= 8'hc5;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 SW= 8'h07;

#2 Run = 0;	// Toggle Run
#40 Run = 1;

#2 SW= 8'hff;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 SW= 8'h01;

#2 Run = 0;
#40 Run = 1;

#2 SW= 8'hff;
#2 Run = 0;
#40 Run = 1;

end
endmodule
