module ALU_tb ();
// testbench for ALU module
  reg [15:0] Ain, Bin;
  reg [1:0] ALUop;
  wire [15:0] out;
  wire Z;
  reg err;
  
  
  ALU DUT (Ain,Bin,ALUop,out,Z);
  
  task ALU_checker; // Test that check the value of Z and the output of ALU
  input [15:0] expected;
    begin 
      if( out !== expected ) begin
        $display("Error output is %b, expected %b", out, expected);
	     err = 1'b1;
	   end 
		if ( Z !== ( expected === 16'b0000_0000_0000_0000 ) ) begin
	     $display("Error Z is %b, expected %b", Z, ( expected === 16'b0000_0000_0000_0000 ));
		  err = 1'b1;
		end
    end
  endtask
  
  initial begin
  // test addition
  
  // 0 + 0 = 0
  ALUop = 2'b00;
  err = 1'b0;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker( 0 );
  
  // 5 + 4 = 9
  Ain = 5;
  Bin = 4;
  
  #5
  ALU_checker ( 9 );
  
  
  // checking if it correctly overflow, expecting a 0
  Ain = 16'b1111_1111_1111_1111;
  Bin = 1;
  
  #5
  ALU_checker ( 0 );
  
  // 18236 + 21305 = 18236 + 21305
  Ain = 18236;
  Bin = 21305;
  
  #5
  ALU_checker (18236 + 21305);
  
  // test subtraction
  
  // 0 - 0 = 0
  ALUop = 2'b01;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker ( 0 );
  
  // 5 - 4 = 1
  Ain = 5;
  Bin = 4;
  
  #5
  ALU_checker ( 1 );
  
  // random binary... expecting a 0
  Ain = 16'b0010_0101_0100_0101;
  Bin = 16'b0010_0101_0100_0101;
  
  #5
  ALU_checker ( 16'b0000_0000_0000_0000 );
  
  // 49103 - 12451 = 49103 - 12451
  Ain = 49103;
  Bin = 12451;
  
  #5
  ALU_checker ( 49103 - 12451 );
  
  // test AND
  
  // 0 & 0 = 0
  ALUop = 2'b10;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker ( 0 );
  
  // Same number anded is equal to that number
  Ain = 16'b0010_0101_0100_0101;
  Bin = 16'b0010_0101_0100_0101;
  
  #5
  ALU_checker ( 16'b0010_0101_0100_0101 );
  
  // ( Ain & ~Ain ) = 0
  Ain = 16'b0010_0101_0100_0101;
  Bin = 16'b1101_1010_1011_1010;
  
  #5
  ALU_checker ( 16'b0000_0000_0000_0000 );
  
  // Random number anded together
  Ain = 14152;
  Bin = 12451;
  
  #5
  ALU_checker ( 14152 & 12451 );
 
  // test negate
  
  // negation of 0 is 1
  ALUop = 2'b11;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker ( 16'b1111_1111_1111_1111 );
  
  // negation of 111111111 is 0000000
  Ain = 21415;
  Bin = 16'b1111_1111_1111_1111;
  
  #5
  ALU_checker ( 16'b0000_0000_0000_0000 );
  
  // using the negation function of verilog
  Ain = 5142;
  Bin = 14151;
  
  #5
  ALU_checker ( ~14151 );
 
  // ~1010110000110101 = 0101001111001010
  Ain = 21512;
  Bin = 16'b1010_1100_0011_0101;
  
  #5
  ALU_checker ( 16'b0101_0011_1100_1010 );
 
  #5;
  
  if(~err) $display("PASSED"); //prints final "verdict" on testbench
  else $display("FAILED");
		
  end
endmodule