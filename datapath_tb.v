module datapath_tb ();

  reg [15:0] datapath_in;
  reg write, vsel, loada, loadb, asel, bsel, loadc, loads, clk;
  reg [2:0] readnum, writenum;
  reg [1:0] shift, ALUop;
  wire Z_out;
  wire [15:0] datapath_out;
  reg err;
  
  datapath DUT(clk, 
                 //register operand fetch stage
                 readnum, vsel, loada, loadb, 
                 // computation stage
					  shift, asel, bsel, ALUop, loadc, loads, 
					  // set when writing back to register file
					  writenum, write, datapath_in, 
					  // outputs
					  Z_out, datapath_out);
					  
  task outputcheck;
  input [15:0] out;
  input zout;
    begin
	   if( out !== datapath_out ) begin
	     err = 1'b1;
		  $display("Data error data out is %b, expected %b", datapath_out, out);
		end
	   if( Z_out !== zout ) begin
	     err = 1'b1;
		  $display("Status error Z status is %b, expected %b", Z_out, zout);
		end
    end
  endtask
  
 /* task regcheck;
  input [3:0] regno;
  input [15:0] expected
  begin
    if( expected !== //that thing that opens the value of something ) begin
	   err = 1'b1;
		$display("Reg error data is %b, expected %b", ^, expected);
	 end
  end
  endtask
	*/
					  
  initial begin
	 forever begin
	   clk = 0; 
		#1
		clk = 1;
		#1;
    end
  end
  
  initial begin
    //Set everything to zero
	 
	 //-------test case 1----------

    // Put 0 in R0
	 err = 1'b0;
	 vsel = 1'b1;
	 datapath_in = 16'b0;
	 writenum = 3'b000;
	 write = 1'b1;
	 readnum = 3'b000;
	 loada = 1'b1;
	 loadb = 1'b1;
	 shift = 2'b00;
	 asel = 1'b0;
	 bsel = 1'b0;
	 ALUop = 2'b00;
	 loads = 1'b1;
	 loadc = 1'b1;
	 
	 
	 // Set load into 0
	 loada = 0;
	 loadb = 0;
	 loadc = 0;
	 
	 // Put 7 in R0
	 writenum = 0;
	 datapath_in = 7;
	 
	 #10
	 
	 // Put 2 in R1
	 writenum = 1;
	 datapath_in = 2;
	 
	 #10
	 
	 // Move R1 to A
	 write = 0;
	 readnum = 1;
	 loada = 1;
	 
	 #10
	 
	 // Move R0 to B & change the shift to left 
	 readnum = 0;
	 loada = 0;
	 loadb = 1;
	 
	 #10
	 
	 shift = 2'b01;
	 
	 // Add Ain and Bin
	 ALUop = 2'b00;
	 loada = 0;
	 loadb = 0;
	 
	 // Save the result to loadc
	 loadc = 1;
	 
	 #10
	 
	 // Save datapath_out to R2
	 
	 write = 1;
	 writenum = 2;
	 readnum = 2;
	 vsel = 1'd0;
	 
	 #10
	 
	 // Make out = R2
	 write = 0;
	 loada = 0;
	 loadb = 1;
	 
	 #10
	 
	 loadc = 1;
	 asel = 1;
	 shift = 2'b00;
	 
	 #10
	 
	 // datapath_out = R2
	 
	 outputcheck( 16, 0 );
	 
	 #10
	 
	 
	 //----------END test case 1----------
	 
	 
	 
	 
	 
	 
	 //-----------Test case 2----------
	 $display("Checking 2nd test case. Primarily testing asel");
	 vsel = 1'b1;
	 datapath_in = 16'b0000_0000_0110_0001;
	 writenum = 5;
	 write = 1'b1;
	 readnum = 5;
	 loada = 0;
	 loadb = 0;
	 shift = 2'b00;
	 asel = 1'b1;
	 bsel = 1'b1;
	 ALUop = 2'b00;
	 loads = 1'b1;
	 loadc = 1'b1;
	 

	 #10
	 outputcheck( 16'b0000_0000_0000_0001, 0 );
	 
	 
	 // Move datapath_out to R3
	 write = 1;
	 vsel = 0;
	 writenum = 3;
	 readnum = 3;
	 
	 #10
	 // Move R3 to A
	 write = 0;
	 loada = 1;
	 loadb = 1;
 
	 #10
	 
	 
	 //here the asel and bsel values will continue forward as Ain and Bin, not data-in values
	 // Add Ain and Bin
	 ALUop = 2'b00;
	 loada = 0;
	 loadb = 0;
	 bsel = 0; //reopen bsel
	 asel = 1; //close asel
	 
	 // Save the result to loadc
	 loadc = 1;
	 
	 #10
	 outputcheck( 16'b0000_0000_0000_0001, 0 );
	 
		
    //----------END test case 2----------
	 
	 
	 
	 
	 
	 
	 //-----------Test case 3----------
	 $display("Checking 3nd test case. Primarily testing ALU and shift");
	 
	 //Pass the value of 0110010001100001 and negate that value on ALU 
	 //Then the value will be loaded in mod5 and displayed on datapath_out
	 vsel = 1'b1;
	 datapath_in = 16'b0110_0100_0110_0001;
	 writenum = 6;
	 write = 1'b1;
	 readnum = 6;
	 loada = 1;
	 loadb = 1;
	 shift = 2'b00;
	 asel = 1'b1;
	 bsel = 1'b0;
	 ALUop = 2'b11;
	 loads = 1'b1;
	 loadc = 1'b1;
	 
	 #10
	 
	 outputcheck( ~16'b0110_0100_0110_0001 , 0 );
	 
	 // Set load into 0 so that Z_out is saved
	 loads = 0;
	 
	 // Change the output to 0 by assigning A = 32 and B = 32. Then we subtract those number in ALU
	 // This means that Z_out should stay 0 even though Z = 1;
	 write = 1;
	 datapath_in = 32;
	 readnum = 4;
	 writenum = 4;
	 asel = 0;
	 loada = 1;
	 loadb = 1;
	 loadc = 1;
	 ALUop = 2'b01;
 
	 #10
    
	 outputcheck( 0, 0 );
	 
	 // Change loads to 1 so the Z_out is updated to current value of Z
	 loads = 1;
	 
	 #10
	 
	 outputcheck( 0, 1 );
	 

	 // Shift B to the right so the value of sout is half the value of B
	 // This means that out = 32 - 32/2 = 32 - 16 = 16
	 // This also means Z is 0 -> Z_out
	 shift = 2'b10;
	 
	 #10
	 
	 outputcheck( 16, 0 );
	 
	 // Change to the other type of shift. The value of sout wouldn't change because B[15] = 0
	 shift = 2'b11;
	 
	 #10
	 
	 outputcheck( 16, 0 );
	 
	 #10
	 
	 
    //----------END test case 3----------
	 
	 
	 
	 
	 
	 
	 //-----------Test case 4----------
	 $display("Checking 3nd test case. Primarily testing regfile");
	 
    // Write 11312 in r0
	 vsel = 1'b1;
	 asel = 1;
	 bsel = 0;
	 ALUop = 2'b00;
	 loada = 1;
	 loadb = 1;
	 loadc = 1;
	 loads = 1;
	 shift = 2'b00;
	 
	 datapath_in = 11312;
	 writenum = 0;
	 write = 1;
	 
	 #10
	 
	 // Write 21415 in r1
	 datapath_in = 21415;
	 writenum = 1;
	 readnum = 0;
	 
	 // Check r0 which is 11312
	 #10
	 outputcheck( 11312, 0 );
	 
	 // Write 14141 in r2
	 datapath_in = 14141;
	 writenum = 2;
	 readnum = 1;
	 
	 // Check r1 which is 21415
	 #10
	 outputcheck( 21415, 0 );
	 
	 // Write 5151 in r3
	 datapath_in = 5151;
	 writenum = 3;
	 readnum = 2;
	 
	 // Check r2 which is 14141
	 #10
	 outputcheck( 14141, 0 );
	 
	 // Write 2491 in r4
	 datapath_in = 2491;
	 writenum = 4;
	 readnum = 3;
	 
	 // Check r3 which is 5151
	 #10
	 outputcheck( 5151, 0 );
	 
	 // Write 2463 in r5
	 datapath_in = 2463;
	 writenum = 5;
	 readnum = 4;
	 
	 // Check r4 which is 2491
	 #10
	 outputcheck( 2491, 0 );
	 
	 // Write 9893 in r6
	 datapath_in = 9893;
	 writenum = 6;
	 readnum = 5;
	 
	 // Check r5 which is 2463
	 #10
	 outputcheck( 2463, 0 );
	 
	 // Write 14112 in r7
	 datapath_in = 14112;
	 writenum = 7;
	 readnum = 6;
	 
	 // Check r6 which is 9893
	 #10
	 outputcheck( 9893, 0);
	 
	 readnum = 7;
	
	 // Check r7 which is 14112
	 #10
	 outputcheck (14112, 0);
	 
	 
	 
	 #10
	 
	  if(~err) $display("PASSED"); //prints final "verdict" on testbench
  else $display("FAILED");
  
	 $stop;
	 
	 end
endmodule
	 
	 