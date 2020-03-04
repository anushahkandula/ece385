module datapath
(
    input  logic Clk, Reset,
	 input  logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	 input  logic GatePC, GateMDR, GateALU, GateMARMUX,
	 input  logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
	 input  logic [1:0] ADDR2MUX, ALUK, PCMUX,
	 input  logic MIO_EN,
	 input logic [15:0] MDR_In,
	 output logic [11:0] LED,
    output logic [15:0] PC,
	 output logic [15:0] MAR, MDR, IR_Out,
	 output logic BEN
);

    //internal logics
	 logic [15:0] Bus, PCMUX_Out, MDRMUX_Out, SR2MUX_Out, DRMUX_Out, ADDR1MUX_Out, ADDR2MUX_Out;
	 logic [15:0] ALU_Out, ADDER_Out;
	 logic [15:0] SR1_Out, SR2_Out;
	 logic [2:0]  DR_In, SR1_In, SR2_In;
	 logic [3:0]  gatemux_sel;
	 logic mdrmux_sel, drmux_sel, sr1mux_sel, sr2mux_sel, addr1mux_sel;
	 logic [1:0]  pcmux_sel, addr2mux_sel;
	 logic [15:0] IR_5, IR_6, IR_9, IR_11;
	 logic N, Z, P;
	 
	 //combine all gates into one
	 assign gatemux_sel   = {GatePC, GateMDR, GateALU, GateMARMUX};
	 assign mdrmux_sel    = MIO_EN;
	 assign pcmux_sel     = PCMUX;
	 assign drmux_sel     = DRMUX;
	 assign sr1mux_sel    = SR1MUX;
	 assign sr2mux_sel    = SR2MUX;
	 assign addr1mux_sel = ADDR1MUX;
	 assign addr2mux_sel = ADDR2MUX;	 

	 
    //sign extensions of IR
	 assign IR_5  =  { {11{IR_Out[4]}}  , IR_Out[4:0] };	 
	 assign IR_6  =  { {10{IR_Out[5]}}  , IR_Out[5:0] };
	 assign IR_9  =  { { 7{IR_Out[8]}}  , IR_Out[8:0] };
	 assign IR_11 =  { { 5{IR_Out[10]}} , IR_Out[10:0] };
	 //assign the SR2_In
	 assign SR2_In = IR_Out[2:0];
	 
	 //the adder_out is the sum of addr1 and addr2
	 assign ADDER_Out = ADDR1MUX_Out + ADDR2MUX_Out;
	 
	 //initialization of all the registers
    //the PC register
	 //notice that Reset is active low
    register_16 PC_Reg(.Clk(Clk), .Load(LD_PC), .Reset(~Reset), .Data_In(PCMUX_Out), .Data_Out(PC));
	
    //the IR register
    register_16 IR_Reg(.Clk(Clk), .Load(LD_IR), .Reset(~Reset), .Data_In(Bus), .Data_Out(IR_Out));   

    //the MAR register
    register_16 MAR_Reg(.Clk(Clk), .Load(LD_MAR), .Reset(~Reset), .Data_In(Bus), .Data_Out(MAR));	 

	 //the MDR register
    register_16 MDR_Reg(.Clk(Clk), .Load(LD_MDR), .Reset(~Reset), .Data_In(MDRMUX_Out), .Data_Out(MDR));
	 
	 //Register file
	 register_file reg_file(.Clk(Clk), .Load(LD_REG), .Reset(~Reset), .SR1_In(SR1_In), .SR2_In(SR2_In), .DR_In(DR_In), .In(Bus), .SR1_Out(SR1_Out), .SR2_Out(SR2_Out));

	 
    //the ALU of the processor
	 ALU alu(.A(SR1_Out), .B(SR2MUX_Out), .ALUK(ALUK), .Output(ALU_Out)); 
 
    //nzp computing block
	 nzp_block nzp1(.Clk(Clk), .Reset(~Reset), .Load(LD_CC), .Input(Bus), .n(N), .z(Z), .p(P));
 
    //BEN register
	 ben_register ben_reg(.Clk(Clk), .Reset(~Reset), .N(N), .Z(Z), .P(P), .Load(LD_BEN), .CC_In(IR_Out[11:9]), .BEN_Out(BEN));

    //the LED	 
	 always_ff @ (posedge Clk)
	 begin
	   if (~Reset)
		   LED <= 12'h0;
		else if (LD_LED)
			LED <= IR_Out[11:0];
		else
			LED <= LED;
	 end
	

//***************************************MUX*****************************************************************
	always_comb 
	begin
	
	   //gate MUX
	   case (gatemux_sel)
		    4'b1000: 
				  Bus = PC;
		    4'b0100: 
				  Bus = MDR;
		    4'b0010: 
				  Bus = ALU_Out;
		    4'b0001: 
				  Bus = ADDER_Out;
		    default:
				  Bus = 16'b0;
		endcase
	
	   //MDR MUX
		case (mdrmux_sel)
		    1'b0: 
				  MDRMUX_Out = Bus;
		    1'b1: 
				  MDRMUX_Out = MDR_In;
		endcase
		
		//PC MUX
	   case (pcmux_sel)
		    2'b00: 
				  PCMUX_Out = PC + 16'b1;
		    2'b01: 
				  PCMUX_Out = Bus;
		    2'b10: 
				  PCMUX_Out = ADDER_Out;
		    default:
				  PCMUX_Out = 16'b0;
		endcase	
	
      //DR MUX
	   case (drmux_sel)
	       1'b0: DR_In = IR_Out[11:9]; 
			 1'b1: DR_In = 3'b111; 
		endcase 
		
		//SR1 MUX
	   case (sr1mux_sel)
	       1'b0: SR1_In = IR_Out[8:6]; 
			 1'b1: SR1_In = IR_Out[11:9]; 
		endcase 	
		
		//SR2 MUX
	   case (sr2mux_sel)
	       1'b0: SR2MUX_Out = SR2_Out; 
			 1'b1: SR2MUX_Out = IR_5; 
		endcase 		
		
		//ADDR1 MUX
	   case (addr1mux_sel)
	       1'b0: ADDR1MUX_Out = PC; 
			 1'b1: ADDR1MUX_Out = SR1_Out; 
		endcase 				

		//ADDR2 MUX
	   case (addr2mux_sel)
	       2'b00: ADDR2MUX_Out = 16'b0; 
			 2'b01: ADDR2MUX_Out = IR_6; 
	       2'b10: ADDR2MUX_Out = IR_9; 
			 2'b11: ADDR2MUX_Out = IR_11;
		endcase 
		
	end


endmodule	







