module ALU_tb ();

  reg [15:0] Ain, Bin;
  reg [1:0] ALUop;
  wire [15:0] out;
  wire Z;
  reg err;
  
  
  ALU DUT (Ain,Bin,ALUop,out,Z);
  
  task ALU_checker; 
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
  ALUop = 2'b00;
  err = 1'b0;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker( 0 );
  
  Ain = 5;
  Bin = 4;
  
  #5
  ALU_checker ( 9 );
  
  Ain = 16'b1111_1111_1111_1111;
  Bin = 1;
  
  #5
  ALU_checker ( 0 );
  
  Ain = 18236;
  Bin = 21305;
  
  #5
  ALU_checker (18236 + 21305);
  
  // test subtraction
  ALUop = 2'b01;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker ( 0 );
  
  Ain = 5;
  Bin = 4;
  
  #5
  ALU_checker ( 1 );
  
  Ain = 16'b0010_0101_0100_0101;
  Bin = 16'b0010_0101_0100_0101;
  
  #5
  ALU_checker ( 16'b0000_0000_0000_0000 );
  
  Ain = 49103;
  Bin = 12451;
  
  #5
  ALU_checker ( 49103 - 12451 );
  
  // test AND
  ALUop = 2'b10;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker ( 0 );
  
  Ain = 16'b0010_0101_0100_0101;
  Bin = 16'b0010_0101_0100_0101;
  
  #5
  ALU_checker ( 16'b0010_0101_0100_0101 );
  
  Ain = 16'b0010_0101_0100_0101;
  Bin = 16'b1101_1010_1011_1010;
  
  #5
  ALU_checker ( 16'b0000_0000_0000_0000 );
  
  Ain = 14152;
  Bin = 12451;
  
  #5
  ALU_checker ( 14152 & 12451 );
 
  // test negate
  ALUop = 2'b11;
  Ain = 0;
  Bin = 0;
  
  #5
  ALU_checker ( 16'b1111_1111_1111_1111 );
  
  Ain = 21415;
  Bin = 16'b1111_1111_1111_1111;
  
  #5
  ALU_checker ( 16'b0000_0000_0000_0000 );
  
  Ain = 5142;
  Bin = 14151;
  
  #5
  ALU_checker ( ~14151 );
 
  Ain = 21512;
  Bin = 16'b1010_1100_0011_0101;
  
  #5
  ALU_checker ( 16'b0101_0011_1100_1010 );
 
  #5;
  
  end
endmodule