`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:29:07 05/21/2018 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top(
    input clk,
    input reset
	 
    );
	
	reg [31:0] memFile [0:255];
	reg [31:0] InstMemFile [0:127];
	initial
	begin
		$readmemb("./src/mem_inst.txt",InstMemFile);
		$readmemh("./src/mem_data.txt",memFile);
		PC=0;
	end
	
	
	wire[31:0] INST;
	wire REG_DST,
			JUMP,
			BRANCH,
			MEM_READ,
			MEM_TO_REG,
			MEM_WRITE;
	wire[1:0] ALU_OP;
	wire ALU_SRC,
			REG_WRITE;
			
	wire[3:0] ALU_CTR;
	
	wire [31:0] READ_DATA_1,
				READ_DATA_2,
				READ_DATA_2_MUX,
				ALU_RES;
   
   wire ZERO;
	wire[31:0] READ_DATA,
				WRITE_DATA
				;
				
				
				
				
	wire[4:0] READ_REG_1,
			READ_REG_2,
			WRITE_REG;
	
	wire[31:0] SIGN_EXT;
	wire[31:0] SHIFT_LEFT,MUX_PC;
	reg[31:0] PC;
	wire[31:0] PC_PLUS;
	wire[31:0] PC_PLUS_MUX;
	wire[31:0] jump;
	
	assign INST = InstMemFile[PC>>2];
	assign WRITE_REG = REG_DST ? INST[15:11] : INST[20:16];
	assign READ_DATA_2_MUX = ALU_SRC ? SIGN_EXT : READ_DATA_2;
	assign PC_PLUS_MUX = (BRANCH && ZERO) ? (PC+4+SIGN_EXT*4) : (PC+4);
	assign MUX_PC = (JUMP) ? ((INST[25:0]<<2 )|((PC+4)&(32'b11110000000000000000000000000000))):(PC_PLUS_MUX);
	assign WRITE_DATA = (MEM_TO_REG) ? (READ_DATA):(ALU_RES);
	assign jump = (INST[25:0]<<2 )|((PC+4)&(32'b11110000000000000000000000000000));
	
	always@ (posedge clk)
	begin
		if (reset)
			PC<=0;
		else 
			PC<=MUX_PC;

	end 
	
	Ctr mainCtr(
			.opCode(INST[31:26]),
			.regDst(REG_DST),
			.jump(JUMP),
			.branch(BRANCH),
			.memRead(MEM_READ),
			.memToReg(MEM_TO_REG),
			.aluOp(ALU_OP),
			.memWrite(MEM_WRITE),
			.aluSrc(ALU_SRC),
			.regWrite(REG_WRITE));
			
	AluCtr aluCtr(
			.aluOp(ALU_OP),
			.funct(INST[5:0]),
			.aluCtr(ALU_CTR));
			
	Alu alu(
			.input1(READ_DATA_1),
			.input2(READ_DATA_2_MUX),
			.aluCtr(ALU_CTR),
			.zero(ZERO),
			.aluRes(ALU_RES));
			
	Memory dataMemory(
			.clock_in(clk),
			.writeData(READ_DATA_2),
			.memWrite(MEM_WRITE),
			.memRead(MEM_READ),
			.address(ALU_RES),
			.reset(reset),
			.readData(READ_DATA));
	
	Register register(
			.clock_in(clk),
			.writeData(WRITE_DATA),
			.writeReg(WRITE_REG),
			.readReg1(INST[25:21]),
			.readReg2(INST[20:16]),
			.readData1(READ_DATA_1),
			.readData2(READ_DATA_2),
			.regWrite(REG_WRITE),
			.reset(reset));
	
	signext signext(
			.inst(INST[15:0]),
			.data(SIGN_EXT));
	
	
	
	
	



endmodule
