module shifter_tb ();
//testbench for the shifter module
  reg [15:0] sim_in;
  reg [1:0] sim_shift;
  wire [15:0] sim_out;
  reg err;
  
  
  shifter DUT (
	.in(sim_in),
	.shift(sim_shift),
	.sout(sim_out)
	);
  
  task shift_checker; //task that checks if expected out = actual shifter output
  input [15:0] expected;
    begin 
      if( sim_out !== expected ) begin
        $display("Error output is %b, expected %b", sim_out, expected);
	     err = 1'b1;
	   end
    end
  endtask
  
  initial begin
  // Test no shift. Expected output is 1111000011001111
  err = 1'b0;
  sim_shift = 2'b00;
  sim_in = 16'b1111000011001111;

  
  #5
  shift_checker(16'b1111000011001111);
  
  // Test left shift. Expected output is 1110000110011110
  sim_shift = 2'b01;

  
  #5
  shift_checker(16'b1110000110011110);
  

  // Test right shift with MSB = 0.  Expected output is 0111100001100111
  sim_shift = 2'b10;
  
  #5
  shift_checker(16'b0111100001100111);
  

  // Test right shift with MSB = B[15].  Expected output is 1111100001100111
  sim_shift = 2'b11;

  
  #5
  shift_checker(16'b1111100001100111);
  

  // Test shift with in =0  Expected output is 0000_0000_0000_0000
  sim_in = 0;
  
  #5
  shift_checker(16'b0000_0000_0000_0000);
  

  // Test shift with in = 1000_0000_0000_0000  Expected output is 1100_0000_0000_0000
  sim_in = 16'b1000_0000_0000_0000;

  
  #5
  shift_checker(16'b1100_0000_0000_0000);
  

   // Test shift with in = 0100_0000_0000_0000  Expected output is 0010_0000_0000_0000
  sim_in = 16'b0100_0000_0000_0000;

  
  #5
  shift_checker(16'b0010_0000_0000_0000);
  
  #5;

  
	if(~err) $display("PASSED"); //prints final "verdict" on testbench
	else $display("FAILED");
		
	$stop;
  end
endmodule
