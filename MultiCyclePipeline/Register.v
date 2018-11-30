`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:41:49 03/14/2018 
// Design Name: 
// Module Name:    Register 
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
module Register(
    input clock_in,
    input [4:0] readReg1,
    input [4:0] readReg2,
    input [4:0] writeReg,
    input [31:0] writeData,
    input regWrite,
	 input reset,  //new in lab5
    output reg [31:0] readData1,
    output reg [31:0] readData2
    );
	 
	 reg [0:31] regFile[0:31];
	 
	 initial   //new in lab5
	 begin
		$readmemh("./src/reg.txt",regFile);
	 end

	 
	 always @ (readReg1 or readReg2 or reset)
	 begin
	     if(reset)
		  begin
			readData1 = 0;
			readData2 = 0;
		  end
		  else
		  begin
			readData1 = regFile[readReg1];
			readData2 = regFile[readReg2];
		  end
	 end	 
	 
	 always @ (negedge clock_in)
	 begin
	   if(reset)
		  $readmemh("./src/reg.txt",regFile);	 
	   else if(regWrite==1'b1)
		  regFile[writeReg] = writeData;
	 end
	 
endmodule
