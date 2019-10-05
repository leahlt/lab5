module mux2_tb (); //regression test for the mux2 module
   reg [15:0] sim_a0;
   reg [15:0] sim_a1;
	reg sim_s;
	reg err;
 
   wire [15:0] sim_b;

    mux2 dut (
      .a0(sim_a0),
      .a1(sim_a1),
      .s(sim_s),
      .b(sim_b)
    );

	 task my_mux_checker;
		input [15:0] expected_out;
		
		begin
			if(sim_b !== expected_out) begin
				$display("Error  ** output is %b, expected %b", sim_b, expected_out);
				err = 1'b1;
			end
		end
	endtask
		
	 
    initial begin
		sim_a0 = 16'b0000_0000_0000_0000;
		sim_a1 = 16'b0000_0000_0000_0010;
		err = 0;
		sim_s = 1'b1;
		#10
		
		$display("-----MUX2 CHECK-----");
		
		//check a1 goes through
		$display("Checking MUX2 for s=1") ;
		my_mux_checker(16'b0000_0000_0000_0010);
		#10
		
		//check a0 goes through
		sim_s = 1'b0;
		#10
		$display("Checking MUX2 for s=0") ;
		my_mux_checker(16'b0000_0000_0000_0000);
		#10
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err from task my_FSM_checker
		else $display("FAILED");
		
		$stop;
	 end
endmodule
	 
	 
module mux5_tb (); //regression test for the mux2 module
   reg [15:0] sim_a0;
   reg [15:0] sim_a1;
	reg [15:0] sim_a2;
	reg [15:0] sim_a3;
	reg [15:0] sim_a4;
	reg [15:0] sim_a5;
	reg [15:0] sim_a6;
	reg [15:0] sim_a7;
	reg [7:0] sim_s;
	reg err;
 
   wire [15:0] sim_b;

    mux5 dut (
      .a0(sim_a0),
      .a1(sim_a1),
		.a2(sim_a2),
		.a3(sim_a3),
		.a4(sim_a4),
		.a5(sim_a5),
		.a6(sim_a6),
		.a7(sim_a7),
      .s(sim_s),
      .b(sim_b)
    );

	 task my_mux_checker;
		input [15:0] expected_out;
		
		begin
			if(sim_b !== expected_out) begin
				$display("Error  ** output is %b, expected %b", sim_b, expected_out);
				err = 1'b1;
			end
		end
	endtask
		
	 
    initial begin
		sim_a0 = 16'b0000_0000_0000_0001;
		sim_a1 = 16'b0000_0000_0000_0010;
		sim_a2 = 16'b0000_0000_0000_0100;
		sim_a3 = 16'b0000_0000_0000_1000;
		sim_a4 = 16'b0000_0000_0001_0000;
		sim_a5 = 16'b0000_0000_0010_0000;
		sim_a6 = 16'b0000_0000_0100_0000;
		sim_a7 = 16'b0000_0000_1000_0000;
		err = 0;
		#10
		
		$display("-----MUX5 CHECK-----");
		
		//check a0 goes through
		sim_s = 8'b0000_0001;
		#10
		my_mux_checker(16'b0000_0000_0000_0001);
		$display("Checking MUX5 for s=0") ;
		#10
		
		//check a1 goes through
		sim_s = 8'b0000_0010;
		#10
		my_mux_checker(16'b0000_0000_0000_0010);
		$display("Checking MUX5 for s=1") ;
		#10
		
		//check a2 goes through
		sim_s = 8'b0000_0100;
		#10
		my_mux_checker(16'b0000_0000_0000_0100);
		$display("Checking MUX5 for s=2") ;
		#10
		
		
		//check a3 goes through
		sim_s = 8'b0000_1000;
		#10
		my_mux_checker(16'b0000_0000_0000_1000);
		$display("Checking MUX5 for s=3") ;
		#10
		
		//check a4 goes through
		sim_s = 8'b0001_0000;
		#10
		my_mux_checker(16'b0000_0000_0001_0000);
		$display("Checking MUX5 for s=4") ;
		#10
		
		//check a5 goes through
		sim_s = 8'b0010_0000;
		#10
		my_mux_checker(16'b0000_0000_0010_0000);
		$display("Checking MUX5 for s=5") ;
		#10
		
		//check a6 goes through
		sim_s = 8'b0100_0000;
		#10
		my_mux_checker(16'b0000_0000_0100_0000);
		$display("Checking MUX5 for s=6") ;
		#10
		
		//check a4 goes through
		sim_s = 8'b1000_0000;
		#10
		my_mux_checker(16'b0000_0000_1000_0000);
		$display("Checking MUX5 for s=7") ;
		#10
		
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err from task my_FSM_checker
		else $display("FAILED");
		
		$stop;
	 end
endmodule
	 
	 
	 
module decoder38_tb (); //regression test for the mux2 module
   reg [2:0] sim_a;
   wire [7:0] sim_b;
	reg err;
 
 
    decoder38a dut (
      .a(sim_a),
      .b(sim_b)
    );

	 task my_decoder_checker;
		input [7:0] expected_out;
		
		begin
			if(sim_b !== expected_out) begin
				$display("Error  ** output is %b, expected %b", sim_b, expected_out);
				err = 1'b1;
			end
		end
	endtask
		
	 
    initial begin
		sim_a = 3'b001;
		err = 0;
		#10
		
		$display("-----DECODER CHECK-----");
		
		//check for 1 
		my_decoder_checker(8'b0000_0010);
		#10
		
		//check for 4
		sim_a = 3'b100;
		#10
		my_decoder_checker(8'b0001_0000);
		#10
		
		//check for 2
		sim_a = 3'b010;
		#10
		my_decoder_checker(8'b0000_0100);
		#10;
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err from task my_FSM_checker
		else $display("FAILED");
		
		$stop;
	 end
endmodule
	 