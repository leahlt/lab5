module regfile_tb();
	reg [15:0] sim_data_in;
	reg [2:0] sim_writenum, sim_readnum;
	reg sim_write, sim_clk;
	reg err;
	
	wire [15:0] sim_data_out;
	
	regfile dut(
		.data_in(sim_data_in),
		.writenum(sim_writenum),
		.readnum(sim_readnum),
		.clk(sim_clk),
		.write(sim_write),
		.data_out(sim_data_out)
	);
	
	
	task my_regfile_checker;
		input [2:0] expected_reg;
		input [15:0] expected_readout;
		
		begin
			if(sim_writenum & sim_readnum !== expected_reg) begin
				$display("ERROR ** writenum and readnum don't match. Write is %b, read is %b, expected %b", sim_writenum, sim_readnum, expected_reg) ; //check that the right reg is being accessed by write/read
				err = 1'b1;
			end
			
			if(sim_data_out !== expected_readout) begin
				$display("ERROR ** output is %b, expected %b", sim_data_out, expected_readout) ; //check that the number in is the number out (data)
				err = 1'b1;
			end
		end
	endtask
	
	task my_regfilemem_checker;
	input [15:0] expected_out;
	
	begin
		if (sim_data_out !== expected_out) begin
			$display("ERROR ** output is %b, expected %b", sim_data_out, expected_out) ; //check that the number in is the number out (data)
				err = 1'b1;
		end
	end
		
	endtask
	
	
	
	
	initial begin
		//Register 0, data_in 3
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b0000_0000_0000_0011 ; //3
		sim_writenum = 3'b000 ; //write register 0
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b000; //read register 0
		#10
		
		$display("Moving to register 0, check for binary 3");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b000, 16'b0000_0000_0000_0011);
		#10
		
		
		
		//Register 1, data_in 320
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b0000_0001_0100_0000 ; //320
		sim_writenum = 3'b001 ; //write register 1
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b001; //read register 1
		#10		
		
		$display("Moving to register 1, check for binary 320");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b001, 16'b0000_0001_0100_0000);
		#10
		sim_readnum = 3'b000; //read register 0
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0011); //checks the value in the last register assigned, not current write register
		
		
		
		//Register 2, data_in 34464
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b1000_0110_1010_0000 ; //34464
		sim_writenum = 3'b010 ; //write register 2
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b010; //read register 2
		#10
		
		$display("Moving to register 2, check for binary 34464");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b010, 16'b1000_0110_1010_0000);
		#10
		sim_readnum = 3'b001; //read register 1
		#10
		my_regfilemem_checker(16'b0000_0001_0100_0000); //checks the value in the last register assigned, not current write register
		
		
		
		//Register 3, data_in 42
		err = 1'b0;
		sim_clk = 1'b0;
		sim_data_in = 16'b0000_0000_0010_1010 ; //42
		sim_writenum = 3'b011; //write register 3
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b011; //read register 3
		#10
		
		$display("Moving to register 3, check for binary 42");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b011, 16'b0000_0000_0010_1010);
		#10
		sim_readnum = 3'b010; //read register 2
		#10
		my_regfilemem_checker(16'b1000_0110_1010_0000); //checks the value in the last register assigned, not current write register
	
		
		
		//Register 4, data_in 5
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b0000_0000_0000_0101 ; //5
		sim_writenum = 3'b100 ; //write register 4
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b100; //read register 4
		#10		
		
		$display("Moving register 4, check for binary 5");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b100, 16'b0000_0000_0000_0101);
		#10
		sim_readnum = 3'b011; //read register 3
		#10
		my_regfilemem_checker(16'b0000_0000_0010_1010); //checks the value in the last register assigned, not current write register
		
		
		
		//Register 5, data_in 4
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b0000_0000_0000_0100 ; //4
		sim_writenum = 3'b101 ; //write register 5
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b101; //read register 5
		#10		
		
		$display("Moving register 5, check for binary 4");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b101, 16'b0000_0000_0000_0100);
		#10
		sim_readnum = 3'b100; //read register 4
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0101); //checks the value in the last register assigned, not current write register
		
		
		
		//Register 6, data_in 5
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b0000_0000_0000_0101 ; //5
		sim_writenum = 3'b110 ; //write register 6
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b110; //read register 6
		#10
		
		$display("Moving register 6, check for binary 5");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b110, 16'b0000_0000_0000_0101);
		#10
		sim_readnum = 3'b101; //read register 5
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0100); //checks the value in the last register assigned, not current write register
		
		
		
		//Register for 7, data_in 0
		sim_clk = 1'b0; //clk off
		sim_data_in = 16'b0000_0000_0000_0000 ; //0
		sim_writenum = 3'b111 ; //write register 7
		sim_write = 1'b1 ;// "on"
		sim_readnum = 3'b111; //read register 7
		#10
		
		$display("Moving register 7, check for binary 0");
		sim_clk = 1'b1; //now something can happen;
		#10;
		my_regfile_checker(3'b111, 16'b0000_0000_0000_0000);
		#10
		sim_readnum = 3'b110; //read register 6
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0101); //checks the value in the last register assigned, not current write register
		
		#10
		sim_readnum = 3'b111; //read register 7
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0000); //checks the value in the last register assigned, not current write register
		
		
		
		
		
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err from task my_FSM_checker
		else $display("FAILED");
		
		$stop;
		
	end
	//still haven't really check what happens when we try to read a register we haven't just written to, I think it will hold the value
	
	
endmodule





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
	 