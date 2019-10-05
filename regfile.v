module regfile(data_in, writenum, write, readnum, clk, data_out);
//top level module for the register file. Inputs and outs are listed below
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;
	
	//some useful "temporary" values
	wire [7:0] hot_writenum, hot_readnum;
	wire [15:0] a0, a1, a2, a3, a4, a5, a6, a7;
	wire en0, en1, en2, en3, en4, en5, en6, en7;
	
	//each of the following assigned statements will set en (select for mux) aka load enabler for register
	assign en0 = write & hot_writenum[0];
	assign en1 = write & hot_writenum[1];
	assign en2 = write & hot_writenum[2];
	assign en3 = write & hot_writenum[3];
	assign en4 = write & hot_writenum[4];
	assign en5 = write & hot_writenum[5];
	assign en6 = write & hot_writenum[6];
	assign en7 = write & hot_writenum[7];
	
	//use decoder to convert write and read inputs into one hot codes
	decoder38a writex(writenum, hot_writenum);
   decoder38a readx(readnum, hot_readnum);

	//use load enabled register to write to any register
	vDFFE r0(clk, en0, data_in, a0);
	vDFFE r1(clk, en1, data_in, a1);
	vDFFE r2(clk, en2, data_in, a2);
	vDFFE r3(clk, en3, data_in, a3);
	vDFFE r4(clk, en4, data_in, a4);
	vDFFE r5(clk, en5, data_in, a5);
	vDFFE r6(clk, en6, data_in, a6);
	vDFFE r7(clk, en7, data_in, a7);
	
	//finally use large mux to access a the register determined by readnum
   mux8 outx(a0, a1, a2, a3, a4, a5, a6, a7, hot_readnum, data_out);

endmodule


//some useful modules


//MUX with 2 16-bit inputs and one-hot select
module mux2(a0, a1, s, b);
	input [15:0] a0, a1;
	input s;
	output [15:0] b;
	
	assign b = s ? a1 : a0; //MUX logic, value s is concactinated 16 times to match bit size of inputs
	
endmodule



//MUX with 5 16-bit inputs and 8-bit one-hot select
module mux8(a0, a1, a2, a3, a4, a5, a6, a7, s, b);
	input [15:0] a0, a1, a2, a3, a4, a5, a6, a7;
	input [7:0] s;
	output [15:0] b;
	
	assign b = ({16{s[0]}} & a0) | 
				  ({16{s[1]}} & a1) |
				  ({16{s[2]}} & a2) |
				  ({16{s[3]}} & a3) |
				  ({16{s[4]}} & a4) |
				  ({16{s[5]}} & a5) |
				  ({16{s[6]}} & a6) |
				  ({16{s[7]}} & a7) ; //mux logic, value s is concactinated 16 times to match the bit-size of the inputs, only one input will be assigned to output (and --> or effect)	
endmodule


//decoder module for 3 to 8 bit decoder
module decoder38a(a, b);
	input [2:0] a;
	output [7:0] b;
	
	wire [7:0] b = 1 << a; //shifter logic that runs decoder. b wired (similar to assign)
	
endmodule


//register with load enable
module vDFFE(clk, en, in, out);
	input clk, en;
	input [15:0] in;
	output [15:0] out;
	
	reg [15:0] out;
	wire [15:0] next_out;
	
	assign next_out = en ? in : out; //mux (load enable part of this register)
	
	always @(posedge clk) //always block that runs when the clk is at a rising edge. Always block controls the output of the load enabled register
		out = next_out;	
endmodule


