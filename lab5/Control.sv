//the state machine for the 8 bit multiplier

module control (input  logic Clk, Reset, Run, ClearA_LoadB, M, //input M is used as the lsb of B
                output logic Shift, Add, Sub, Clr_Ld, Clr_XA); //output Clr_XA is used to clear X and A 

    // Declare signals curr_state, next_state of type enum
    // with enum values of A, B, ..., F as the state values
	 // We 5 bits to provide 18 states
    enum logic [4:0] {Start, Clear, S1_Add, S1_Shift, S2_Add, S2_Shift, S3_Add, S3_Shift, S4_Add, S4_Shift
	 , S5_Add, S5_Shift, S6_Add, S6_Shift, S7_Add, S7_Shift, S8_Add, S8_Shift, End}  curr_state, next_state; 

	//updates flip flop synchronously with the clock
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
		      //reset to the Start state
            curr_state <= Start;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required for default cases
        unique case (curr_state) 
            //move to the new mutiplication cycle when Run is high
            Start  :    if (Run)
                          next_state = Clear;
				//it will clear the X and A in this state
				Clear:        next_state = S1_Add;
			   //each bit will go through two cycles: add and shift
            S1_Add :      next_state = S1_Shift;
            S1_Shift :    next_state = S2_Add;
            S2_Add :      next_state = S2_Shift;
            S2_Shift :    next_state = S3_Add;
            S3_Add :      next_state = S3_Shift;
            S3_Shift :    next_state = S4_Add;
            S4_Add :      next_state = S4_Shift;
            S4_Shift :    next_state = S5_Add;
            S5_Add :      next_state = S5_Shift;
            S5_Shift :    next_state = S6_Add;
            S6_Add :      next_state = S6_Shift;
            S6_Shift :    next_state = S7_Add;
            S7_Add :      next_state = S7_Shift;
            S7_Shift :    next_state = S8_Add;
            S8_Add :      next_state = S8_Shift;
            S8_Shift :    next_state = End;	
	         //move back to start state when run is low			
            End :       if (~Run) 
                          next_state = Start;
							  
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   Start, End:
			   //in start and end states, the machine doesn't execute any operations	
	         begin
                Clr_Ld = ClearA_LoadB;
					 Shift  = 1'b0;
					 Add    = 1'b0;
					 Sub    = 1'b0;
					 Clr_XA = 1'b0;
		      end
            
	   	   Clear:
			   //X,A will always be clear before the multiplication
	         begin
                Clr_Ld = 1'b0;
					 Shift  = 1'b0;
					 //clear the X,A
					 Clr_XA = 1'b1;
					 Add    = 1'b0;
					 Sub    = 1'b0;
		      end

	   	   S1_Add, S2_Add, S3_Add, S4_Add, S5_Add, S6_Add, S7_Add:
	         begin
                Clr_Ld = 1'b0;
					 Shift  = 1'b0;
					 Clr_XA = 1'b0;
					 Add    = 1'b0;
					 Sub    = 1'b0;
					 if (M)
					   begin 
					     Add    = 1'b1;
					     Sub    = 1'b0;					     
					   end
		      end

	   	   S8_Add:
			   //the last bit will only perform subtraction
	         begin
                Clr_Ld = 1'b0;
					 Shift  = 1'b0;
					 Clr_XA = 1'b0;
					 Add    = 1'b0;
					 Sub    = 1'b0;
					 if (M)
					   begin 
					     Add    = 1'b0;
						  //if last bit is high, subtraction is performed
					     Sub    = 1'b1;					     
					   end
		      end
				
	   	   default:  //default cases are for shifting cases
	         begin
                Clr_Ld = 1'b0;
					 //shift in those cases
					 Shift  = 1'b1;
					 Add    = 1'b0;
					 Sub    = 1'b0;
					 Clr_XA = 1'b0;
		      end
        endcase
    end

endmodule
