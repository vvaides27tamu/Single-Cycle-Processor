`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module ALUTest_v;
initial
   begin
     $dumpfile("ALU.vcd"); // the string inside the double quotation is the name of the .vcd file to be generated, you name it.
     $dumpvars(0,ALUTest_v); // the 2nd parameter is your test module name, which is in the very first line!
  end
	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed. Passed %x. Total tests: %x", passed, numTests);
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;


		{BusA, BusB, ALUCtrl} = {64'h20, 64'h4500, 4'h2}; #40; passTest({Zero, BusW}, 65'h04520, "ADD 0x20,0x4500", passed);
		{BusA, BusB, ALUCtrl} = {64'h23BCF6, 64'h5B86, 4'h2}; #40; passTest({Zero, BusW}, 65'h24187C, "ADD 0x1234,0xABCD0000", passed);
		{BusA, BusB, ALUCtrl} = {64'h5EC74E3, 64'h487CD8838D, 4'h2}; #40; passTest({Zero, BusW}, 65'h4882C4F870, "ADD 0x1234,0xABCD0000", passed);

		{BusA, BusB, ALUCtrl} = {64'h53F15, 64'h17177, 4'h0}; #40; passTest({Zero, BusW}, 65'h13115, "AND 0x53F15,0x17177", passed);
		{BusA, BusB, ALUCtrl} = {64'hDA0, 64'h23BB, 4'h0}; #40; passTest({Zero, BusW}, 65'h1A0, "AND 0xDA0,0xABCD0000", passed);
		{BusA, BusB, ALUCtrl} = {64'h18667, 64'h3BE61, 4'h0}; #40; passTest({Zero, BusW}, 65'h18661, "AND 0x18667,0x3BE61", passed);

		{BusA, BusB, ALUCtrl} = {64'h98967F, 64'hA98AC7, 4'h1}; #40; passTest({Zero, BusW}, 65'hB99EFF, "OR 0x98967F,0xA98AC7", passed);
		{BusA, BusB, ALUCtrl} = {64'h73BBF6, 64'h1, 4'h1}; #40; passTest({Zero, BusW}, 65'h73BBF7, "OR 0x73BBF6,0x1", passed);
		{BusA, BusB, ALUCtrl} = {64'h319384, 64'h01304213, 4'h1}; #40; passTest({Zero, BusW}, 65'h131D397, "OR 0x319384,0x01304213", passed);

		{BusA, BusB, ALUCtrl} = {64'h19E0711F, 64'h2246274, 4'h6}; #40; passTest({Zero, BusW}, 65'h17BC0EAB, "SUB 0x19E0711F,0x2246274", passed);
		{BusA, BusB, ALUCtrl} = {64'hFEDCBA, 64'hABCDEF, 4'h6}; #40; passTest({Zero, BusW}, 65'h530ECB, "SUB 0xFEDCBA,0xABCDEF", passed);
		{BusA, BusB, ALUCtrl} = {64'h328FEDAF, 64'hAB879CD, 4'h6}; #40; passTest({Zero, BusW}, 65'h27D773E2, "SUB 0x328FEDAF,0xAB879CD", passed);

		{BusA, BusB, ALUCtrl} = {64'h0, 64'hFFF, 4'h7}; #40; passTest({Zero, BusW}, 65'hFFF, "PassB 0x0,0xFFF", passed);
		{BusA, BusB, ALUCtrl} = {64'h999, 64'h0, 4'h7}; #40; passTest({Zero, BusW}, 65'h10000000000000000, "PassB 0x999,0x0", passed);
		{BusA, BusB, ALUCtrl} = {64'h0, 64'h0, 4'h7}; #40; passTest({Zero, BusW}, 65'h10000000000000000, "PassB 0x0,0x0", passed);

		allPassed(passed, 15);
	end    
endmodule

/*ADD1, 2, 20, 4500, 0, 4520
ADD2, 2,23BCF6 , 5B86, 0, 24187C
ADD3, 2, 5EC74E3, 487CD8838D, 0, 4882C4F870

AND1,0, 53F15,17177,0,13115
AND2,0, DA0,23BB,0,1A0
AND3,0, 18667,3BE61,0,18661

OR1,1,98967F,A98AC7,0,B99EFF
OR2,1,73BBF6,1,0,73BBF7
OR3,1,319384,01304213,0,131D397

SUB,6,19E0711F,2246274,0,17BC0EAB
SUB,6,FEDCBA,ABCDEF,0,530ECB
SUB,6,328FEDAF,AB879CD,0,27D773E2

PassB,7,0,FFF,0,FFF
PassB,7,999,0,1, 0
PassB,7,0,0,1,0*/