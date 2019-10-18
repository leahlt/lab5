module cpu(clk, reset, s, load, in, out, N, V, Z, w);
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w;
	
	vDFFE (#16) instruction(clk, load, in, out); //instruction register
	
	//if reset == 1 then FSM should go to reset state
			//after this FSM should not do anything until s == 1 & poseedge clk
	//out is dataout from datapath
	//N, V, Z, are from Z from status register
	//w gets one if FSM is reset == 1 & s ~== 1;
		//when the FSM is done, it should return here^
	
	
	
endmodule


module lap6_top();

endmodule //currently, because of some confusion with the lab hand out this is NOT the top level, cpu is the top level for the project

module instruct_decoder(Rd);
	
	
endmodule
