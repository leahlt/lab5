module cpu(clk, reset, s, load, in, out, N, V, Z, w);
	input clk, reset, s, load;
	input [15:0] in;
	output [15:0] out;
	output N, V, Z, w;
	
	wire [15:0] instr, sximm8, sximm5;
	wire [2:0] readnum, writenum, opcode;
	wire [1:0] ALUop, shift, op;

	vDFFE (#16) instruction(clk, load, in, instr); //instruction register
	
	//if reset == 1 then FSM should go to reset state
			//after this FSM should not do anything until s == 1 & poseedge clk
	//out is dataout from datapath
	//N, V, Z, are from Z from status register
	//w gets one if FSM is reset == 1 & s ~== 1;
		//when the FSM is done, it should return here^

	instruct_decoder ID (instr, // from instrucion vDDF
				nsel, // still undefined
				ALUop, sximm5, sximm8, shift,
				readnum, writenum, op, opcode
				)

	datapath DP ( .clk         (~KEY[0]), // recall from Lab 4 that KEY0 is 1 when NOT pushed

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  
                .datapath_in (datapath_in),
                // added for lab 6
                // These are still undefined
                .mdata ({15{1'b0}}),
                .PC ({8{1'b0}}),

                sximm8, sximm5,


                // outputs
                .Z_out       (LEDR[9]),
                .datapath_out(datapath_out)
             );	
	
endmodule


module lap6_top();

endmodule //currently, because of some confusion with the lab hand out this is NOT the top level, cpu is the top level for the project

module instruct_decoder(Rd, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, op, opcode);
	output [15:0] sximm8, sximm5;
	output [2:0] readnum, writenum, opcode;
	output [1:0] ALUop, shift, op;	

	assign ALUop = Rd[12:11];

	assign sximm5 = {11{1'b0},Rd[4:0]};
	assign sximm8 = {8{1'b0},Rd[7:0]};

	assign shift = Rd[4:3];

	wire [2:0] writeReadNum;
	mux3 (#3) muxR(Rd[10:8], Rd[7:5], Rm[2:0], nsel, writeReadNum);
	assign readnum = writeReadNum;
	assign writenum = writeReadNum;

	assign op = Rd[12:11];
	assign opcode = Rd[15:13];

endmodule

module mux3(a2, a1, a0, s, b);
	parameter n=3;
	input [n-1:0] a2, a1, a0;
	input [2:0] s;
	output b;

	assign b = ({n{s[0]}} & a0) | 
				  ({n{s[1]}} & a1) |
				  ({n{s[2]}} & a2) |;

endmodule