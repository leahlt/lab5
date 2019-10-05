module datapath (clk, 
                 //register operand fetch stage
                 readnum, vsel, loada, loadb, 
                 // computation stage
					  shift, asel, bsel, ALUop, loadc, loads, 
					  // set when writing back to register file
					  writenum, write, datapath_in, 
					  // outputs
					  Z_out, datapath_out);
					  
  input [15:0] datapath_in;
  output [15:0] datapath_out;
  input write, vsel, loada, loadb, asel, bsel, loadc, loads, clk;
  input [2:0] readnum, writenum;
  input [1:0] shift, ALUop;
  output Z_out;

  wire [15:0] data_in, data_out, Aload, Bload, sout, Ain, Bin, out;
  wire Z;
  
  mux2 mod9(datapath_out, datapath_in, vsel, data_in);
  
  regfile U0(data_in, writenum, write, readnum, clk, data_out);
  
  vDFFE mod3(clk, loada, data_out, Aload);
  vDFFE mod4(clk, loadb, data_out, Bload);
  
  mux2 mod6(Aload, 16'b0000_0000_0000_0000, asel, Ain);
  mux2 mod7(sout, {11'b0, datapath_in[4:0]}, bsel, Bin);
  
  shifter U1(Bload, shift, sout);
  
  ALU U2(Ain,Bin,ALUop,out,Z);
  
  vDFFE mod5(clk, loadc, out, datapath_out);
  vDFFE mod10(clk, loads, Z, Z_out);
  
endmodule




