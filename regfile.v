module regfile(data_in, writenum, write, readnum clk, data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;
	
	
	
	
	
endmodule


//let's add some useful modules


//MUX with 2 16-bit inputs and one-hot select
module mux2(a0, a1, s, b);
	input [15:0] a0, a1;
	input s;
	output [15:0] b;
	
	assign b = ({16{s}} & a0) | ({16{s}} & a1); //MUX logic, value s is concactinated 16 times to match bit size of inputs
	
endmodule



//MUX with 5 16-bit inputs and 8-bit one-hot select
module mux5(a0, a1, a2, a3, a4, s, b);
	input [15:0] a0, a1, a2, a3, a4;
	input [7:0] s;
	output [15:0] b;
	
	assign b = ({16{s[0]}} & a0) | 
				  ({16{s[1]}} & a1) |
				  ({16{s[2]}} & a2) |
				  ({16{s[3]}} & a3) |
				  ({16{s[4]}} & a4) ;	
endmodule


//decoder module for 3 to 8 bit decoder
module decoder38a(a, b);
	input [2:0] a;
	output [7:0] b;
	
	wire [7:0] b = 1 << a //why is wire used instead of assign. Ss6 #8
	
endmodule


//register with load enable
module vDFFE(clk, en, in, out);
	input clk, en;
	input [15:0] in;
	output [15:0] out;
	
	reg [15:0] out;
	wire [15:0] next_out;
	
	assign next_out = en ? in : out; //mux (load enable part of this register)
	
	always @(posedge clk)
		out = next_out;	
endmodule























