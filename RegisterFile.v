`timescale 1ps/1ps
module RegisterFile(BusA,BusB,BusW,RA,RB,RW,RegWr,Clk);
input [4:0] RA,RB,RW;
output[63:0] BusA,BusB;
input [63:0] BusW;
input Clk,RegWr;
reg [63:0] registers [31:0];
initial registers[31]= 64'b0;


assign #2 BusA = registers[RA];
assign #2 BusB = registers[RB];
always@(negedge Clk)
begin
if (RegWr && RW !=5'b11111) registers[RW] <=  #3BusW;
end

endmodule