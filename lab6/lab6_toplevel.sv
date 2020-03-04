//-------------------------------------------------------------------------
//      lab6_toplevel.sv                                                 --
//                                                                       --
//      Created 10-19-2017 by Po-Han Huang                               --
//                        Spring 2018 Distribution                       --
//                                                                       --
//      For use with ECE 385 Experment 6                                 --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------
module lab6_toplevel( input logic [15:0] S,
                      input logic Clk, Reset, Run, Continue,
                      output logic [11:0] LED,
                      output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
                      output logic CE, UB, LB, OE, WE,
                      output logic [19:0] ADDR,
                      inout wire [15:0] Data);
//synchronized logics
logic Reset_S, Run_S, Continue_S;
logic [15:0] Din_S;
//logic OE_S, WE_S, CE_S, UB_S, LB_S ;

slc3 my_slc(.*, .S(Din_S), .Reset(Reset_S), .Run(Run_S), .Continue(Continue_S), .CE(CE), .UB(UB), .LB(LB), .OE(OE), .WE(WE));
// Even though test memory is instantiated here, it will be synthesized into 
// a blank module, and will not interfere with the actual SRAM.
// Test memory is to play the role of physical SRAM in simulation.
test_memory my_test_memory(.Reset(~Reset_S), .I_O(Data), .CE(CE), .UB(UB), .LB(LB), .OE(OE), .WE(WE), .A(ADDR), .*);

//Input synchronizers required for asynchronous inputs (in lab6, the inputs are from the switches)
sync button_sync[2:0] (Clk, {Reset, Run, Continue}, {Reset_S, Run_S, Continue_S});
sync Din_sync[15:0] (Clk, S, Din_S);
//sync_r1 Mem_sync1[1:0] (Clk, {OE, WE}, {OE_S, WE_S}); 
//sync_r0 Mem_sync2[2:0] (Clk, {CE, UB, LB}, {CE_S, UB_S, LB_S}); 

endmodule