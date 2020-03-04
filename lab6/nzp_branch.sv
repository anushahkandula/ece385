module nzp_block
(
	input Clk, Reset, Load,
	input logic [15:0] Input, 
	output logic n, z, p
);

   
   always_ff @ (posedge Clk)
   	begin
   		if(Reset)
   			begin 
   				n <= 0;
   				z <= 0;
   				p <= 0;
   			end
   		else if (Load)
   			begin
   				if(Input == 16'b0)
   					begin
   						n <= 0; 
   						z <= 1;
   						p <= 0;
   					end
   				else if(Input[15])
   					begin
   						n <= 1;
   						z <= 0;
   						p <= 0;
   					end
   				else
   					begin
   						n <= 0;
   						z <= 0;
   						p <= 1;
   					end
   			end
//   		else
//   			begin
//   				n <= n;
//   				z <= z;
//   				p <= p;
//   			end
   	end
	
endmodule 


module ben_register 
(
    input  logic Clk, Reset, N, Z, P, Load,
    input  logic [2:0] CC_In,
    output logic BEN_Out
);
					 
		 always_ff @ (posedge Clk)
			begin	
            if(Reset)
			       BEN_Out <= 1'b0;
		      else if (Load)			
					 BEN_Out <= (CC_In[2] & N) || (CC_In[1] & Z) || (CC_In[0] & P);
			end
				
endmodule


