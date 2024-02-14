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
module SignExtenderTest_v;
initial
   begin
     $dumpfile("SignExtender.vcd"); // the string inside the double quotation is the name of the .vcd file to be generated, you name it.
     $dumpvars(0,SignExtenderTest_v); // the 2nd parameter is your test module name, which is in the very first line!
  end
	task passTest;
		input [63:0] actualOut, expectedOut;
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

	reg [25:0] Imm26;
	reg [1:0] Ctrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusImm;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	SignExtender uut (
		.BusImm(BusImm), 
        .Imm26(Imm26),
		.Ctrl(Ctrl)
	);

	initial begin
		// Initialize Inputs

        Imm26=0;
		Ctrl = 0;
		passed = 0;
		{Imm26, Ctrl} = {26'hED1, 2'b00}; #40; passTest({BusImm}, 64'h3, "I_type", passed);
		{Imm26,Ctrl} = {26'h103303,2'b01}; #40; passTest({BusImm}, {{56{1'b1}},8'h3}, "D_type", passed);
		{Imm26, Ctrl} = {26'h3FFCD5,2'b10}; #40; passTest({BusImm}, {{36{1'b0}},26'h3FFCD5,2'b0}, "B_type", passed);
		{Imm26, Ctrl} = {26'h3FFCD53,2'b11}; #40; passTest({BusImm}, {{43{1'b1}},19'h7FE6A,2'b0}, "CB_type", passed);        
		allPassed(passed, 4);
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
