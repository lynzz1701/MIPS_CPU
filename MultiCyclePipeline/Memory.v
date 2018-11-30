`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:55 03/14/2018
// Design Name: 
// Module Name:    Memory 
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
module Memory(
    input clock_in,
    input [31:0] address,
    input [31:0] writeData,
    input memWrite,
    input memRead,
	 input reset,   //new in lab5
    output reg [31:0] readData
    );
	 
	 reg [0:31] memFile[0:127];
	 
	 initial        //new in lab5
	 begin
		$readmemh("./src/mem_data.txt",memFile);
	 end
	
	 always @ (memRead or address or reset)
	 begin
	   if(reset)
		  readData = 0;
	   if(memRead == 1'b1)
		  readData = memFile[address];
	 end
	 
	 always @ (negedge clock_in)
	 begin
	   if(reset)
		  $readmemh("./src/mem_data.txt",memFile);
	   if(memWrite==1'b1)
		  memFile[address] = writeData;
	 end


endmodule
