module shifter(in,shift,sout); //shifter module
  input [15:0] in;
  input [1:0] shift;
  output [15:0] sout;
  
  reg [15:0] result;
  assign sout = result; //give out the value held in result from the always block
  
  always @(*) begin //always block that implements the shifter (used to divide or mulitply by 2)
    case (shift) //shifter works via concactination
	   2'b00: result = in; //no shift
		2'b01: result = {in[14:0], 1'b0}; //shift left
		2'b10: result = {1'b0, in[15:1]}; //shift right with most significant digit = 0
		2'b11: result = {in[15], in[15:1]}; //shift right with most significant digit = in[15]
		default: result = 16'bxxxx_xxxx_xxxx_xxxx; //for debugging purposes
    endcase
  end
  
endmodule