module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero,Uncondbranch);
input [63:0] CurrentPC, SignExtImm64;
input ALUZero,Branch, Uncondbranch;
output reg [63:0] NextPC;

always @(*)
begin
if ((Branch && ALUZero)|| Uncondbranch) NextPC = CurrentPC + SignExtImm64;

else NextPC = CurrentPC + 4; 

end



endmodule 