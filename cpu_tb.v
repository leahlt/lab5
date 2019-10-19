module cpu_tb ();

	reg [15:0] in;
	reg clk, reset, s, load;
	wire [15:0] out;
	wire N, V, Z, w;
	
	cpu DUT(clk, reset, s, load, in, out, N, V, Z, w);
	
  task outputcheck;
  input [15:0] out;
  input zout;
    begin
	   if( out !== datapath_out ) begin
	     err = 1'b1;
		  $display("Data error data out is %b, expected %b", datapath_out, out);
		end
    end
  endtask
 
  task statuscheck;
  input Nx, Vx, Zx;
	 begin
	   if( Nx !== N ) begin
	     err = 1'b1;
		  $display("Status error N out is %b, expected %b", N, Nx);
		end
	   if( Vx !== V ) begin
	     err = 1'b1;
		  $display("Status error V out is %b, expected %b", V, Vx);
		end
	   if( Zx !== Z ) begin
	     err = 1'b1;
		  $display("Status error Z out is %b, expected %b", Z, Zx);
		end
	 end
  endtask
  
  task reg0check;
  input [15:0] regfile0;
    begin
	   if( cpu_tb.DUT.DP.REGFILE.R0 !== regfile0 ) begin
	     err = 1'b1;
		  $display("Regfile error R0 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R0, regfile0);
		end  
  endtask
  
  task reg1check;
  input [15:0] regfile;
    begin
	   if( cpu_tb.DUT.DP.REGFILE.R1 !== regfile ) begin
	     err = 1'b1;
		  $display("Regfile error R1 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R1, regfile);
		end  
  endtask
    
  task reg7check;
  input [15:0] regfile;
    begin
	   if( cpu_tb.DUT.DP.REGFILE.R7 !== regfile ) begin
	     err = 1'b1;
		  $display("Regfile error R7 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R7, regfile);
		end  
  endtask
  
  initial begin
	 forever begin
	   clk = 0; 
		#1
		clk = 1;
		#1;
    end
  end
  
  initial begin
  
  reset = 0;
  
  //------Instruction 1----------//
  
  // Test 1
  in = 16'b11010_000_0110_1001; // Load a random positive number in register 0
  load = 1;
  
  #5
  
  load = 0;
  s = 1;
  
  #5
  
  reg0check( {8{1'b0}, 8'b0110_1001} );
  
  //Test 2
  
  in = 16'b11010_000_1100_1010; // Load a random negative number in register 0
  load = 1;
  
  #5
  
  load = 0;
  in = 16'b11010_010_0000_1000; // Load 8 in register 2 for test 3
  
  #5
  
  reg0check( {8{1'b1}, 8'b1100_1010} );
  
  //Test 3
  
  load = 1;
  
  #5
  
  //No need to change in because we have changed it before
  
  if (  cpu_tb.DUT.DP.REGFILE.R2 !== 16'b0000_0000_0000_1000 ) begin
    err = 1;
	 $display("Regfile error R2 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R2, 16'b0000_0000_0000_1000 );
  end
  
  //------Instruction 2----------//
  
  //Test 1
  in = 16'b11000_000_000_00_010; // Load reg 2 = 8 in reg 0

  #5
  
  reg0check( {8{1'b0}, 8'b0000_1000 );
  
  //Test 2
  in = 16'b11000_011_001_10_000; // Load reg 0 shift left = 8 / 2 = 4 in reg 1
  
  #5
  
  reg1check( {8{1'b)}, 8'b0000_0100 );
  
  //Test 3
  in = 16'b11000_011_111_01_001; // Load reg 1 shift right = 4 * 2 = 8 in reg 7
  
  #5
  
  reg7check( {8{1'b0}, 8'b0000_1000 );
  
  $stop;
  end
  
endmodule