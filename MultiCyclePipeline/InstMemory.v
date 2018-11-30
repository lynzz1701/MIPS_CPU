`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:59 05/22/2018 
// Design Name: 
// Module Name:    InstMemory 
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
module InstMemory(
    input [31:0] address,
    input CLK,
    input RESET,
    output reg [31:0] readData);
	 
	 reg [31:0] memBuffer[0:127];
	 initial
	 begin
		$readmemb("./src/inst_mem.txt",memBuffer);
	 end
	 
	 
	 always@(address)
	 begin
		readData = memBuffer[address>>2];
	end 
	
endmodule
