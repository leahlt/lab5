module cpu_tb ();

	reg [15:0] in;
	reg clk, reset, s, load, err;
	wire [15:0] out;
	wire N, V, Z, w;
	
	cpu DUT(clk, reset, s, load, in, out, N, V, Z, w);
	
  task outputcheck;
  input [15:0] outx;
    begin
	   if( out !== outx ) begin
	     err = 1'b1;
		  $display("Data error data out is %b, expected %b", out, outx);
		end
    end
  endtask
 
  task statuscheck;
  input Zx, Nx, Vx;
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
		end
  endtask
  
  task reg1check;
  input [15:0] regfile;
    begin
	   if( cpu_tb.DUT.DP.REGFILE.R1 !== regfile ) begin
	     err = 1'b1;
		  $display("Regfile error R1 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R1, regfile);
		end  
		end
  endtask
    
  task reg7check;
  input [15:0] regfile;
    begin
	   if( cpu_tb.DUT.DP.REGFILE.R7 !== regfile ) begin
	     err = 1'b1;
		  $display("Regfile error R7 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R7, regfile);
		end  
		end
  endtask
  
  initial forever begin
	   clk = 0; 
		#1
		clk = 1;
		#1;
    end
  
  initial begin
  
  reset = 1;
  err = 0;
  
   #10;
  
  reset = 0;
  //------Instruction 1----------//
  
  $display("-----Now testing instruction 1");
  $display("TEST 1");
  // Test 1
  in = 16'b11010_000_0110_1001; // Load a random positive number in register 0
  load = 1;
  
   #10
  
  s = 1;
  
  @(posedge clk)
  s <= 0;
  
   
   #10;
  
  reg0check( {{8{1'b0}}, 8'b0110_1001} );
  
  
  //Test 2
  $display("TEST 2");
  in = 16'b11010_000_1100_1010; // Load a random negative number in register 0
  load = 1;
    
   #10;
  
  s = 1;
  @(posedge clk)
  s <= 0;
  

   #10
  
  load = 0;
  in = 16'b11010_010_0000_1000; // Load 8 in register 2 for test 3
  
   #10
  
  reg0check( {{8{1'b1}}, 8'b1100_1010} );
  
  //Test 3
  $display("TEST 3");
  load = 1;
  s = 1;
  @(posedge clk)
  s <= 0;
  
   
   #10;
  //No need to change in because we have changed it before
  
  if (  cpu_tb.DUT.DP.REGFILE.R2 !== 16'b0000_0000_0000_1000 ) begin
    err = 1;
	 $display("Regfile error R2 is %b, expected %b", cpu_tb.DUT.DP.REGFILE.R2, 16'b0000_0000_0000_1000 );
  end
  
  //------Instruction 2----------//
  $display("-----Now testing instruction 2");
  $display("TEST 1");
  //Test 1
  in = 16'b11000_000_000_00_010; // Load reg 2 = 8 in reg 0
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  
  reg0check( {{8{1'b0}}, 8'b0000_1000} );
  
  //Test 2
  $display("TEST 2");
  in = 16'b11000_011_001_10_000; // Load reg 0 shift left = 8 / 2 = 4 in reg 1
  
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  reg1check( {{8{1'b0}}, 8'b0000_0100} );
  
  //Test 3
  $display("TEST 3");
  in = 16'b11000_011_111_01_001; // Load reg 1 shift right = 4 * 2 = 8 in reg 7
  
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
  
   #10;
  reg7check( {{8{1'b0}}, 8'b0000_1000} );
  
  //------Instruction 3----------//

  $display("-----Now testing instruction 3");
  $display("TEST 1");

  //Test 1
  in = 16'b10100_010_001_00_001; // reg 2 + reg 1 = 8 + 4 = 12 in reg 1
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  
  reg1check( {{12{1'b0}}, 16'b1100} );
  
  //Test 2
  $display("TEST 2");
  in = 16'b10100_010_111_01_001; // reg 2 + reg 1 * 2 = 8 + 24 = 32 in reg 7
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  reg7check( {{8{1'b0}}, 8'b0010_0000} );
  
  //Test 3
  $display("TEST 3");
  in = 16'b10100_010_111_00_000; // reg 2 + reg 0 * 2 = 8 + 8 = 16 in reg 7   
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
   #10;
  reg7check( {{8{1'b0}}, 8'b0001_0000} );

  //------Instruction 4----------// reg 7 = 16
  $display("-----Now testing instruction 4");
  $display("TEST 1");
  //Test 1
  in = 16'b10101_010_000_01_111; // reg 2 - reg 7 * 2 = 8 - 32 = -number
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  
  statuscheck( 0, 1, 0 );
  
  //Test 2
  $display("TEST 2");
  in = 16'b10101_010_000_10_111; // reg 2 - reg 7 / 2 = 8 - 8 = 0 
  
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  statuscheck( 1, 0, 0 );
  
  //Test 3

  $display("TEST 3");
  in = 16'b11010_100_1111_1111; // Load 1_111_1111 to reg 4 (-1)

  								 // This will turn to binary 1111_1111_1111_1111
   #10; s = 1; @(posedge clk) s <= 0;
   @(posedge w)
  in = 16'b11000_000_100_10_100; // reg 4 shift left and setting MSB = 0 to reg 4
  								 // This will turn to binary 0111_1111_1111_1111 (MAX_INTEGER)
   #10; s = 1; @(posedge clk) s <= 0;
   @(posedge w)
  in = 16'b11010_110_1111_0111; // Load -8 to reg 5 
   #10; s = 1; @(posedge clk) s <= 0;
   @(posedge w)

  in = 16'b10101_110_000_00_100; // reg 5 - reg 4 = -8 - MAX_INTEGER = 7

  								 // 1111_1111_1111_0111 this is -8
  								 // 1000_0000_0000_0001 this is flipping the MAX_INTEGER
  								 // 0111_1111_1111_1000 resulting number is positve, MAX_INTEGER - 8
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
  
   #10;

  statuscheck( 0, 1, 1 );
  
  //------Instruction 5----------//
  $display("-----Now testing instruction 5");
  
  //Test 1
  $display("TEST 1");
  in = 16'b10110_111_100_00_010; // reg 4 & reg 2 = 0111_1111_1111_1111 && 0000_0000_0000_0100
  								 // result is 8 to reg 7
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  
  reg7check( {{8{1'b0}}, 8'b0000_1000} );
  
  //Test 2
  $display("TEST 2");
  in = 16'b10110_111_010_10_010; // reg 2 & reg 2 shift left = 0 to reg 7
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  reg7check( {{8{1'b0}}, 8'b0000_0000} );
  
  //Test 3
  $display("TEST 3");
  in = 16'b10110_110_100_00_100; // Load reg 4 & reg 4 = reg 4 to reg 7
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
  
   #10;
  reg7check( { 1'b0, {15{1'b1}} } );
  

  //------Instruction 6----------//
  $display("-----Now testing instruction 6");
  
  //Test 1
  $display("TEST 1");
  in = 16'b10110_000_111_00_010; // Load ~reg 2 = 1111_1111_1111_0111 to reg 7
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  
  reg0check( {{8{1'b1}}, 8'b1111_0111} );
  
  //Test 2
  $display("TEST 2");
  in = 16'b10110_000_000_01_100; // ~(reg 4 shift left) = 1111_1111_1111_1110 to reg 0
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
   
   #10;
  reg0check( {{15{1'b1}}, 1'b0} );
  
  //Test 3
  $display("TEST 3");
  in = 16'b10110_000_001_11_000; // ~(reg 0 shift left MSB = 1) = all 0 to reg 1 
  
  
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
  
   #10;
  reg1check( {16{1'b0}} );


  //Test NOT and Status overflow
  $display("Special tests");
  in = 16'b10111_000_110_00_100; // ~reg 4 to reg 5
  								 // This is the MIN_INTEGER = 1000_0000_0000_0000
   #10; s = 1; @(posedge clk) s <= 0;
   @(posedge w)

  in = 16'b10101_000_110_00_100; // reg 5 - reg 4 = MIN_INTEGER - MAX_INTEGER 

  								 // 1000_0000_0000_0000 this is MIN_INTEGER
  								 // 0111_1111_1111_1111 this is MAX_INTEGER
  								 // 1000_0000_0000_0001 this is MAX_INTEGER flipped

  								 // 0000_0000_0000_0001 resulting in POSITIVE 1
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
  statuscheck( 0, 0, 1);


  //Test 2
  in = 16'b10111_000_110_00_100; // ~reg 4 to reg 5
  								 // This is the MIN_INTEGER = 1000_0000_0000_0000
   #10; s = 1; @(posedge clk) s <= 0;
   @(posedge w)

  in = 16'b10101_000_110_00_100; // reg 5 - reg 4 = MAX_INTEGER - MIN_INTEGER 

  								 // 0111_1111_1111_1111 this is MAX_INTEGER
  								 // 1000_0000_0000_0000 this is NEGATIVE MIN_INTEGER
  								 // 1111_1111_1111_1111 resulting in NEGATIVE 1
   #10;
  s = 1;
  @(posedge clk)
  s <= 0;
  
  statuscheck( 0, 1, 1);

  $stop;
  end
 
endmodule