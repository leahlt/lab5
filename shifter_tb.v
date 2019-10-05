module shifter_tb ();

  reg [15:0] in;
  reg [1:0] shift;
  wire [15:0] sout;
  reg err;
  
  
  shifter DUT (in,shift,sout);
  
  task shift_checker; 
  input [15:0] expected;
    begin 
      if( sout !== expected ) begin
        $display("Error output is %b, expected %b", sout, expected);
	     err = 1'b1;
	   end
    end
  endtask
  
  initial begin
  // Test no shift
  err = 1'b0;
  shift = 2'b00;
  in = 16'b1111000011001111;
  
  #5
  shift_checker(16'b1111000011001111);
  
  // Test left shift
  shift = 2'b01;
  
  #5
  shift_checker(16'b1110000110011110);
  
  // Test right shift with MSB = 0
  shift = 2'b10;
  
  #5
  shift_checker(16'b0111100001100111);
  
  // Test right shift with MSB = B[15]
  shift = 2'b11;
  
  #5
  shift_checker(16'b1111100001100111);
  
  in = 0;
  
  #5
  shift_checker(16'b0000_0000_0000_0000);
  
  in = 16'b1000_0000_0000_0000;
  
  #5
  shift_checker(16'b1100_0000_0000_0000);
  
  in = 16'b0100_0000_0000_0000;
  
  #5
  shift_checker(16'b0010_0000_0000_0000);
  
  #5;
  end
endmodule