module regfile_tb();
//top-level test case (also intended for autograder) that runs the regfile module
	reg [15:0] data_in;
	reg [2:0] writenum, readnum;
	reg write, clk;
	reg err;
	
	wire [15:0] data_out;
	
	regfile DUT(
		.data_in(data_in),
		.writenum(writenum),
		.readnum(readnum),
		.clk(clk),
		.write(write),
		.data_out(data_out)
	);
	
	
	task my_regfile_checker; //checks that the proper register is being read/written to, checks that data_out=data_in
		input [2:0] expected_reg;
		input [15:0] expected_readout;
		
		begin
			if(writenum & readnum !== expected_reg) begin
				$display("ERROR ** writenum and readnum don't match. Write is %b, read is %b, expected %b", writenum, readnum, expected_reg) ; //check that the right reg is being accessed by write/read
				err = 1'b1;
			end
			
			if(data_out !== expected_readout) begin
				$display("ERROR ** output is %b, expected %b", data_out, expected_readout) ; //check that the number in is the number out (data)
				err = 1'b1;
			end
		end
	endtask
	
	task my_regfilemem_checker; //checks that a register outputs expected value... used mostly to check that past registers (different read/write) still hold the correct value
input [15:0] expected_out;
	
	begin
		if (data_out !== expected_out) begin
			$display("ERROR ** output is %b, expected %b", data_out, expected_out) ; //check that the number in is the number out (data)
				err = 1'b1;
		end
	end
		
	endtask
	
	
	
	
	initial begin
		err = 1'b0; //initialize err
		//Register 0, data_in 3
		clk = 1'b0; //clk off
		data_in = 16'b0000_0000_0000_0011 ; //3
		writenum = 3'b000 ; //write register 0
		write = 1'b1 ;// "on"
		readnum = 3'b000; //read register 0
		#10
		
		$display("Moving to register 0, check for binary 3");
		clk = 1'b1; 
		#10;
		my_regfile_checker(3'b000, 16'b0000_0000_0000_0011); //expecting that read/write register is 000 and that binary data output is 0000_0000_0000_0011
		#10
		
		
		
		//Register 1, data_in 320
		clk = 1'b0; //clk off
		data_in = 16'b0000_0001_0100_0000 ; //320
		writenum = 3'b001 ; //write register 1
		write = 1'b1 ;// "on"
		readnum = 3'b001; //read register 1
		#10		
		
		$display("Moving to register 1, check for binary 320");
		clk = 1'b1; 
		#10;
		my_regfile_checker(3'b001, 16'b0000_0001_0100_0000); //expecting that read/write register is 001 and that binary data output is 0000_0001_0100_0000
		#10
		readnum = 3'b000; //read register 0
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0011); //checks the value in the last register assigned, not current write register. Reading register 0, expecting out is 0000_0000_0000_0011
		
		
		
		//Register 2, data_in 34464
		clk = 1'b0; //clk off
		data_in = 16'b1000_0110_1010_0000 ; //34464
		writenum = 3'b010 ; //write register 2
		write = 1'b1 ;// "on"
		readnum = 3'b010; //read register 2
		#10
		
		$display("Moving to register 2, check for binary 34464");
		clk = 1'b1; 
		#10;
		my_regfile_checker(3'b010, 16'b1000_0110_1010_0000); //expecting that read/write register is 010 and that binary data output is 1000_0110_1010_0000
		#10
		readnum = 3'b001; //read register 1
		#10
		my_regfilemem_checker(16'b0000_0001_0100_0000); //checks the value in the last register assigned, not current write register. Reading register 1, expecting out is 0000_0001_0100_0000
		
		
		
		//Register 3, data_in 42
		clk = 1'b0;
		data_in = 16'b0000_0000_0010_1010 ; //42
		writenum = 3'b011; //write register 3
		write = 1'b1 ;// "on"
		readnum = 3'b011; //read register 3
		#10
		
		$display("Moving to register 3, check for binary 42");
		clk = 1'b1; 
		#10;
		my_regfile_checker(3'b011, 16'b0000_0000_0010_1010); //expecting that read/write register is 011 and that binary data output is 0000_0000_0010_1010
		#10
		readnum = 3'b010; //read register 2
		#10
		my_regfilemem_checker(16'b1000_0110_1010_0000); //checks the value in the last register assigned, not current write register. Reading register 2, expecting out is 1000_0110_1010_0000
	
		
		
		//Register 4, data_in 5
		clk = 1'b0; //clk off
		data_in = 16'b0000_0000_0000_0101 ; //5
		writenum = 3'b100 ; //write register 4
		write = 1'b1 ;// "on"
		readnum = 3'b100; //read register 4
		#10		
		
		$display("Moving register 4, check for binary 5");
		clk = 1'b1;
		#10;
		my_regfile_checker(3'b100, 16'b0000_0000_0000_0101); //expecting that read/write register is 100 and that binary data output is 0000_0000_0000_0101
		#10
		readnum = 3'b011; //read register 3
		#10
		my_regfilemem_checker(16'b0000_0000_0010_1010); //checks the value in the last register assigned, not current write register. Reading register 3, expecting out is 0000_0000_0010_1010
		
		
		
		//Register 5, data_in 4
		clk = 1'b0; //clk off
		data_in = 16'b0000_0000_0000_0100 ; //4
		writenum = 3'b101 ; //write register 5
		write = 1'b1 ;// "on"
		readnum = 3'b101; //read register 5
		#10		
		
		$display("Moving register 5, check for binary 4");
		clk = 1'b1;
		#10;
		my_regfile_checker(3'b101, 16'b0000_0000_0000_0100); //expecting that read/write register is 101 and that binary data output is 0000_0000_0000_0100
		#10
		readnum = 3'b100; //read register 4
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0101); //checks the value in the last register assigned, not current write register. Reading register 4, expecting out is 0000_0000_0000_0101
		
		
		
		//Register 6, data_in 5
		clk = 1'b0; //clk off
		data_in = 16'b0000_0000_0000_0101 ; //5
		writenum = 3'b110 ; //write register 6
		write = 1'b1 ;// "on"
		readnum = 3'b110; //read register 6
		#10
		
		$display("Moving register 6, check for binary 5");
		clk = 1'b1;  
		#10;
		my_regfile_checker(3'b110, 16'b0000_0000_0000_0101); //expecting that read/write register is 110 and that binary data output is 0000_0000_0000_0101
		#10
		readnum = 3'b101; //read register 5
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0100); //checks the value in the last register assigned, not current write register. Reading register 5, expecting out is 0000_0000_0000_0100
		#10
		
		
		//Register for 7, data_in 0
		clk = 1'b0; //clk off
		data_in = 16'b0000_0000_0000_0000 ; //0
		writenum = 3'b111 ; //write register 7
		write = 1'b1 ;// "on"
		readnum = 3'b111; //read register 7
		#10
		
		$display("Moving register 7, check for binary 0");
		clk = 1'b1;  
		#10;
		my_regfile_checker(3'b111, 16'b0000_0000_0000_0000); //expecting that read/write register is 111 and that binary data output is 0000_0000_0000_0000
		#10
		readnum = 3'b110; //read register 6
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0101); //checks the value in the last register assigned, not current write register. Reading register 6, expecting out is 0000_0000_0000_0101
		
		#10
		readnum = 3'b111; //read register 7
		#10
		my_regfilemem_checker(16'b0000_0000_0000_0000); //checks the value in the last register assigned, not current write register. Reading register 7, expecting out is 0000_0000_0000_0000
		
		
		
		
		
		//Quick check rewriting over a register
		//Register for 6, data_in 1
		clk = 1'b0; //clk off
		data_in = 16'b0000_0000_0000_0001 ; //0
		writenum = 3'b110 ; //write register 7
		write = 1'b1 ;// "on"
		readnum = 3'b110; //read register 7
		#10
		
		$display("Moving register 7, check for binary 1");
		clk = 1'b1; 
		#10;
		my_regfile_checker(3'b110, 16'b0000_0000_0000_0001); //expecting that read/write register is 110 and that binary data output is 0000_0000_0000_0001
		#10;
		
		
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err
		else $display("FAILED");
		
		$stop;
	end	
endmodule





module mux2_tb (); //regression-style test for the mux2 module
   reg [15:0] a0;
   reg [15:0] a1;
	reg s;
	reg err;
 
   wire [15:0] b;

    mux2 dut (
      .a0(a0),
      .a1(a1),
      .s(s),
      .b(b)
    );

	 task my_mux_checker; //checks that the output of the mux is expected
		input [15:0] expected_out;
		
		begin
			if(b !== expected_out) begin
				$display("Error  ** output is %b, expected %b", b, expected_out);
				err = 1'b1;
			end
		end
	endtask
		
	 
    initial begin
		a0 = 16'b0000_0000_0011_0000;
		a1 = 16'b0000_0000_0000_0010;
		err = 0;
		s = 1'b1;
		#10
		
		$display("-----MUX2 CHECK-----");
		
		//check a1 goes through when s=1. Expected output is 0000_0000_0000_0010
		$display("Checking MUX2 for s=1") ;
		my_mux_checker(16'b0000_0000_0000_0010);
		#10
		
		//check a0 goes through when s=1. Expected output is 0000_0000_0000_0000
		s = 1'b0;
		#10
		$display("Checking MUX2 for s=0") ;
		my_mux_checker(16'b0000_0000_0011_0000);
		#10
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err from task my_FSM_checker
		else $display("FAILED");
		
		$stop;
	 end
endmodule
	 
	 
module mux8_tb (); //regression-style test for the mux5 module
   reg [15:0] a0;
   reg [15:0] a1;
	reg [15:0] a2;
	reg [15:0] a3;
	reg [15:0] a4;
	reg [15:0] a5;
	reg [15:0] a6;
	reg [15:0] a7;
	reg [7:0] s;
	reg err;
 
   wire [15:0] b;

    mux8 dut (
      .a0(a0),
      .a1(a1),
		.a2(a2),
		.a3(a3),
		.a4(a4),
		.a5(a5),
		.a6(a6),
		.a7(a7),
      .s(s),
      .b(b)
    );

	 task my_mux_checker;
		input [15:0] expected_out;
		
		begin
			if(b !== expected_out) begin
				$display("Error  ** output is %b, expected %b", b, expected_out);
				err = 1'b1;
			end
		end
	endtask
		
	 
    initial begin
		a0 = 16'b0000_0000_0000_0001;
		a1 = 16'b0000_0000_0000_0010;
		a2 = 16'b0000_0000_0000_0100;
		a3 = 16'b0000_0000_0000_1000;
		a4 = 16'b0000_0000_0001_0000;
		a5 = 16'b0000_0000_0010_0000;
		a6 = 16'b0000_0000_0100_0000;
		a7 = 16'b0000_0000_1000_0000;
		err = 0;
		
		$display("-----MUX5 CHECK-----");
		
		//check a0 goes through when s=0. Expected output is 0000_0000_0000_0001
		s = 8'b0000_0001;
		#10
		my_mux_checker(16'b0000_0000_0000_0001);
		$display("Checking MUX5 for s=0") ;
		#10
		
		//check a1 goes through when s=1. Expected output is 0000_0000_0000_0010
		s = 8'b0000_0010;
		#10
		my_mux_checker(16'b0000_0000_0000_0010);
		$display("Checking MUX5 for s=1") ;
		#10
		
		//check a2 goes through when s=2. Expected output is 0000_0000_0000_0100
		s = 8'b0000_0100;
		#10
		my_mux_checker(16'b0000_0000_0000_0100);
		$display("Checking MUX5 for s=2") ;
		#10
		
		
		//check a3 goes through when s=3. Expected output is 0000_0000_0000_1000
		s = 8'b0000_1000;
		#10
		my_mux_checker(16'b0000_0000_0000_1000);
		$display("Checking MUX5 for s=3") ;
		#10
		
		//check a4 goes through when s=4. Expected output is 0000_0000_0001_0000
		s = 8'b0001_0000;
		#10
		my_mux_checker(16'b0000_0000_0001_0000);
		$display("Checking MUX5 for s=4") ;
		#10
		
		//check a5 goes through when s=1. Expected output is 0000_0000_0010_0000
		s = 8'b0010_0000;
		#10
		my_mux_checker(16'b0000_0000_0010_0000);
		$display("Checking MUX5 for s=5") ;
		#10
		
		//check a5 goes through when s=1. Expected output is 0000_0000_0100_0000
		s = 8'b0100_0000;
		#10
		my_mux_checker(16'b0000_0000_0100_0000);
		$display("Checking MUX5 for s=6") ;
		#10
		
		//check a0 goes through when s=1. Expected output is 0000_0000_1000_0000
		s = 8'b1000_0000;
		#10
		my_mux_checker(16'b0000_0000_1000_0000);
		$display("Checking MUX5 for s=7") ;
		#10
		
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench depends on err from task my_FSM_checker
		else $display("FAILED");
		
		$stop;
	 end
endmodule
	 
	 
	 
module decoder38_tb (); //regression test for the decoder module
   reg [2:0] a;
   wire [7:0] b;
	reg err;
 
 
    decoder38a dut (
      .a(a),
      .b(b)
    );

	 task my_decoder_checker;
		input [7:0] expected_out;
		
		begin
			if(b !== expected_out) begin
				$display("Error  ** output is %b, expected %b", b, expected_out);
				err = 1'b1;
			end
		end
	endtask
		
	 
    initial begin
		a = 3'b001;
		err = 0;
		#10
		
		$display("-----DECODER CHECK-----");
		
		//check for 1. Expected outcome is 0000_0010
		my_decoder_checker(8'b0000_0010);
		#10
		
		//check for 4 Expected outcome is 0001_0000
		a = 3'b100;
		#10
		my_decoder_checker(8'b0001_0000);
		#10
		
		//check for 2 Expected outcome is 0000_0100
		a = 3'b010;
		#10
		my_decoder_checker(8'b0000_0100);
		#10;
		
		if(~err) $display("PASSED"); //prints final "verdict" on testbench
		else $display("FAILED");
		
		$stop;
	 end
endmodule
	 