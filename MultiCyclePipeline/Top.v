`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:41 05/22/2018 
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
	reg [31:0] PC;		
	
	//IF
	reg [31:0] IF_ID_PC_PLUS;
	reg [31:0] IF_ID_INST;
	wire [31:0] IF_PC_PLUS;
	wire [31:0] IF_INST;
	wire [31:0] MUX_PC;
	
	
	
	//ID
	reg [31:0] ID_EX_READ_DATA_1,
				ID_EX_READ_DATA_2,
				ID_EX_PC_PLUS,
				ID_EX_SIGN_EXT;
	reg[4:0] ID_EX_INST20,
				ID_EX_INST15;
	reg[1:0] ID_EX_ALU_OP;
	reg ID_EX_REG_DST,
		ID_EX_ALU_SRC,
		ID_EX_BRANCH,
		ID_EX_MEM_READ,
		ID_EX_MEM_WRITE,
		ID_EX_MEM_TO_REG,
		ID_EX_REG_WRITE;
		
		
	wire ID_REG_WRITE,
		ID_REG_DST,
		ID_ALU_SRC,
		ID_BRANCH,
		ID_MEM_READ,
		ID_MEM_WRITE,
		ID_MEM_TO_REG;
	wire REG_WRITE;
	wire [1:0] ID_ALU_OP;
	wire [4:0] WRITE_REG;
	wire [31:0] WRITE_DATA;
	wire [31:0] ID_READ_DATA_1,
				ID_READ_DATA_2,
				ID_SIGN_EXT;
	
	//EX
	reg EX_MEM_BRANCH,
		EX_MEM_MEM_READ,
		EX_MEM_MEM_WRITE,
		EX_MEM_REG_WRITE,
		EX_MEM_MEM_TO_REG;
	reg [31:0] EX_MEM_READ_DATA_2;
	reg [31:0] EX_MEM_PC_RES;
	reg [31:0] EX_MEM_ALU_RES;
	reg [31:0] EX_MEM_WRITE_REG;
	reg EX_MEM_ZERO;
		
		
	wire EX_ZERO;
	wire [31:0] EX_ALU_RES;
	wire [31:0] EX_PC_RES;
	wire [31:0] READ_DATA_2_MUX;
	wire [3:0] ALU_CTR;
	wire [4:0] EX_WRITE_REG;
	
	
	
	//MEM
	wire PCSrc;
	wire [31:0] MEM_READ_DATA;
	
	
	reg  MEM_WB_REG_WRITE,
		MEM_WB_MEM_TO_REG;
	reg [31:0]	MEM_WB_ALU_RES,
			MEM_WB_READ_DATA;
		
	reg [4:0] MEM_WB_WRITE_REG;
	
	//WB
	wire [31:0] WB_WRITE_DATA;
	
	InstMemory instMemory(
			.address(PC),
			.CLK(clk),
			.RESET(reset),
			.readData(IF_INST));
	
	Register register(
			.clock_in(clk),
			.writeData(WB_WRITE_DATA),
			.writeReg(MEM_WB_WRITE_REG),
			.readReg1(IF_ID_INST[25:21]),
			.readReg2(IF_ID_INST[20:16]),
			.readData1(ID_READ_DATA_1),
			.readData2(ID_READ_DATA_2),
			.regWrite(MEM_WB_REG_WRITE),
			.reset(reset));
	
	signext signext(
			.inst(IF_ID_INST[15:0]),
			.data(ID_SIGN_EXT));
	
	
	Ctr ctr(
			.opCode(IF_ID_INST[31:26]),
			.regDst(ID_REG_DST),
			.branch(ID_BRANCH),
			.memRead(ID_MEM_READ),
			.memToReg(ID_MEM_TO_REG),
			.aluOp(ID_ALU_OP),
			.memWrite(ID_MEM_WRITE),
			.aluSrc(ID_ALU_SRC),
			.regWrite(ID_REG_WRITE));
	
	Alu alu(
			.input1(ID_EX_READ_DATA_1),
			.input2(READ_DATA_2_MUX),
			.aluCtr(ALU_CTR),
			.zero(EX_ZERO),
			.aluRes(EX_ALU_RES));
			
	AluCtr aluCtr(
			.aluOp(ID_EX_ALU_OP),
			.funct(ID_EX_SIGN_EXT[5:0]),
			.aluCtr(ALU_CTR));
			
	
	Memory dataMemory(
			.reset(reset),
			.clock_in(clk),
			.writeData(EX_MEM_READ_DATA_2),
			.memWrite(EX_MEM_MEM_WRITE),
			.memRead(EX_MEM_MEM_READ),
			.address(EX_MEM_ALU_RES),
			.readData(MEM_READ_DATA));
			
	
	initial
	begin
		$readmemb("./src/inst_mem.txt",InstMemFile);
		$readmemh("./src/mem_data.txt",memFile);
		PC <=0;
		IF_ID_PC_PLUS <=0;
		IF_ID_INST <=0;
		
		ID_EX_READ_DATA_1 <=0;
		ID_EX_READ_DATA_2 <=0;
		ID_EX_PC_PLUS <=0;
		ID_EX_SIGN_EXT <=0;
		ID_EX_INST20 <=0;
		ID_EX_INST15 <=0;
		//ID_EX_REG_DST,
		ID_EX_ALU_SRC <=0;
		ID_EX_BRANCH <=0;
		ID_EX_MEM_READ <=0;
		ID_EX_MEM_WRITE <=0;
		ID_EX_MEM_TO_REG <=0;
		ID_EX_REG_WRITE <=0;
		ID_EX_ALU_OP <=0;
		
		EX_MEM_BRANCH <=0;
		EX_MEM_MEM_READ <=0;
		EX_MEM_MEM_WRITE <=0;
		EX_MEM_REG_WRITE <=0;
		EX_MEM_MEM_TO_REG <=0;
		EX_MEM_READ_DATA_2 <=0;
		EX_MEM_PC_RES <=0;
		EX_MEM_ALU_RES <=0;
		EX_MEM_WRITE_REG <=0;
		EX_MEM_ZERO <=0;
		
		MEM_WB_REG_WRITE <=0;
		MEM_WB_MEM_TO_REG <=0;
		MEM_WB_ALU_RES <=0;
		MEM_WB_READ_DATA <=0;
		MEM_WB_WRITE_REG <=0;
		
	end
	
	assign IF_PC_PLUS = PC +4;
	assign MUX_PC = PCSrc ? EX_MEM_PC_RES : IF_PC_PLUS;
	
	assign EX_PC_RES = ID_EX_PC_PLUS + ID_EX_SIGN_EXT<<2;
	assign READ_DATA_2_MUX = ID_EX_ALU_SRC ? ID_EX_SIGN_EXT : ID_EX_READ_DATA_2;
	assign EX_WRITE_REG = ID_EX_REG_DST ? ID_EX_INST15 : ID_EX_INST20;
	
	
	assign PCSrc =  EX_MEM_BRANCH && EX_MEM_ZERO;
	assign WB_WRITE_DATA = MEM_WB_MEM_TO_REG ? MEM_WB_READ_DATA : MEM_WB_ALU_RES;
	

	
	always @(posedge clk)
	begin

		if (reset == 1) PC <= 0;
		else	PC <= MUX_PC;
		
		//IF_ID
		IF_ID_INST <= IF_INST;
		IF_ID_PC_PLUS <= IF_PC_PLUS;
		
	
		//ID_EX	
		ID_EX_PC_PLUS <= IF_ID_PC_PLUS;
		ID_EX_INST20 <= IF_ID_INST[20:16];
		ID_EX_INST15 <= IF_ID_INST[15:11];
		ID_EX_READ_DATA_1 <= ID_READ_DATA_1;
		ID_EX_READ_DATA_2 <= ID_READ_DATA_2;
		ID_EX_SIGN_EXT <= ID_SIGN_EXT;
		ID_EX_REG_DST <= ID_REG_DST;
		ID_EX_ALU_SRC <= ID_ALU_SRC;
		ID_EX_BRANCH <= ID_BRANCH;
		ID_EX_MEM_READ <= ID_MEM_READ;
		ID_EX_MEM_WRITE <= ID_MEM_WRITE;
		ID_EX_MEM_TO_REG <= ID_MEM_TO_REG;
		ID_EX_REG_WRITE <= ID_REG_WRITE;
		ID_EX_ALU_OP <=  ID_ALU_OP;
		
		//EX_MEM
		
		EX_MEM_BRANCH <= ID_EX_BRANCH;
		EX_MEM_MEM_READ <= ID_EX_MEM_READ;
		EX_MEM_MEM_WRITE <= ID_EX_MEM_WRITE;
		EX_MEM_REG_WRITE <= ID_EX_REG_WRITE;
		EX_MEM_MEM_TO_REG <= ID_EX_MEM_TO_REG;
		EX_MEM_READ_DATA_2 <= ID_EX_READ_DATA_2;
		EX_MEM_PC_RES <= EX_PC_RES; 
		EX_MEM_ALU_RES <= EX_ALU_RES;
		EX_MEM_WRITE_REG <= EX_WRITE_REG;
		EX_MEM_ZERO <= EX_ZERO;
	

		//MEM_WB
		MEM_WB_REG_WRITE <= EX_MEM_REG_WRITE;
		MEM_WB_MEM_TO_REG <= EX_MEM_MEM_TO_REG;
		MEM_WB_ALU_RES <= EX_MEM_ALU_RES;
		MEM_WB_READ_DATA <= MEM_READ_DATA;
		MEM_WB_WRITE_REG <= EX_MEM_WRITE_REG;
end	
	
endmodule
