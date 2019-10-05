module mux_tb (); //regression test for the mux2 module
   reg [15:0] sim_a0;
   reg [15:0] sim_a1;
	reg sim_s;
	reg sim_b;
 
   wire sim_b;

    mux2 dut (
      .a0(sim_a0),
      .a1(sim_a1),
      .s(sim_s),
      .b(sim_b)
    );

	 task my_mux_checker;
		input sim_b;
		
		begin
			if(sim_b ) begin
			
			end
		end
	endtask
		
	 
    initial begin
	 
	 
	 end
endmodule
	 