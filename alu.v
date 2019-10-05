module ALU(Ain,Bin,ALUop,out,Z); // ALU Module
  input [15:0] Ain, Bin;
  input [1:0] ALUop;
  output [15:0] out;
  output Z; //if the main 16-bit result of ALU is 0, Z = 1 else Z = 0
  
  reg [15:0] result;
  assign out = result;
  assign Z = ( result == 16'b0000_0000_0000_0000 );
  
  always @(*) begin
    case(ALUop)
	   2'b00: result = Ain + Bin; //A + B
		2'b01: result = Ain - Bin; //A - B
		2'b10: result = Ain & Bin; //A ANDED B
		2'b11: result = ~Bin; //not B
	   default: result = 16'bxxxx_xxxx_xxxx_xxxx;
	 endcase
  end
  
endmodule