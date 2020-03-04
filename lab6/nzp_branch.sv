//this module is the nzp block
module nzp_block
(
	input Clk, Reset, Load,
	input logic [15:0] Input, 
	output logic n, z, p
);

   
   always_ff @ (posedge Clk)
   	begin
		   //reset the n,z,p
   		if(Reset)
   			begin 
   				n <= 0;
   				z <= 0;
   				p <= 0;
   			end
			//load the n,z,p	
   		else if (Load)
   			begin
				   //check if input is 0
   				if(Input == 16'b0)
   					begin
   						n <= 0; 
   						z <= 1;
   						p <= 0;
   					end
					//check if input is negative	
   				else if(Input[15])
   					begin
   						n <= 1;
   						z <= 0;
   						p <= 0;
   					end
					//then the input must be positive	
   				else
   					begin
   						n <= 0;
   						z <= 0;
   						p <= 1;
   					end
   			end

   	end
	
endmodule 

//this module is a register to store the BEN
module ben_register 
(
    input  logic Clk, Reset, N, Z, P, Load,
    input  logic [2:0] CC_In,
    output logic BEN_Out
);
					 
		 always_ff @ (posedge Clk)
			begin	
			   //reset the BEN
            if(Reset)
			       BEN_Out <= 1'b0;
				//compute the BEN by comparing CC with NZP	 
		      else if (Load)			
					 BEN_Out <= (CC_In[2] & N) || (CC_In[1] & Z) || (CC_In[0] & P);
			end
				
endmodule


