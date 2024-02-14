`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:13:28 03/03/2009
// Design Name:   RegisterFile
// Module Name:   E:/350/Lab7/RegisterFile/RegisterFileTest.v
// Project Name:  RegisterFile
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: RegisterFile
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module NextPClogic_v;

   initial
   begin
     $dumpfile("NextPClogic.vcd"); // the string inside the double quotation is the name of the .vcd file to be generated, you name it.
     $dumpvars(0,NextPClogic_v); // the 2nd parameter is your test module name, which is in the very first line!
  end

   task passTest;
      input [63:0] actualOut, expectedOut;
      input [`STRLEN*8:0] testType;
      inout [7:0] 	  passed;
      
      if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
      else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
   endtask
   
   task allPassed;
      input [7:0] passed;
      input [7:0] numTests;
      
      if(passed == numTests) $display ("All tests passed");
      else $display("Some tests failed");
   endtask

   // Inputs CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch
reg [63:0] CurrentPC, SignExtImm64;
reg Branch,ALUZero, Uncondbranch;
reg [7:0] passed;
   // Outputs
wire [63:0] NextPC;

   // Instantiate the Unit Under Test (UUT)
NextPClogic uut (
.NextPC(NextPC),
.CurrentPC(CurrentPC),
.SignExtImm64(SignExtImm64),
.Branch(Branch),
.ALUZero(ALUZero),
.Uncondbranch(Uncondbranch)
);

   initial begin
      // Initialize Inputs

CurrentPC = 0;
SignExtImm64 = 0;
Branch = 0;
ALUZero =0;
Uncondbranch=0;
passed=0;


$monitor("CurrentPC = 0x%0h, SignExtImm64 = 0x%0h, Branch = %0b, ALUZero = %0b, Uncondbranch= %0b",CurrentPC,SignExtImm64,Branch,ALUZero,Uncondbranch);
      // Add stimulus here
   //should be PC+4

      #10
      {CurrentPC,SignExtImm64,Branch,ALUZero,Uncondbranch} = {64'b0,64'h0,1'b0,1'b0,1'b0};
#10
	  passTest(NextPC, 64'h4, "PC + 4 check", passed);

 //should be PC+Imm
      #10{CurrentPC,SignExtImm64,Branch,ALUZero,Uncondbranch} = {64'h0,64'h32,1'b0,1'b0,1'b1};
	#10passTest(NextPC, 64'h32, "Uncond branch check", passed);
      #10
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h4, 64'h32, 1'b1, 1'b1, 1'b0}; //should be PC+Imm
      #10
	  passTest(NextPC, 64'h36, "Cond branch check", passed);
//should be PC+4 
      #10
      {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h4, 64'h36, 1'b1, 1'b0, 1'b0}; //should be PC+Imm
      #10
	  passTest(NextPC, 64'h8, "Cond branch fail check", passed);
      #10
 //should be PC+Imm
      #10
        {CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch} = {64'h4, 64'h36, 1'b1, 1'b0, 1'b1};
	  #10passTest(NextPC, 64'h3A, "Uncond branch pass", passed);
   end
   
endmodule

