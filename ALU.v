`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SUB 4'b0110
`define PassB 4'b0111

module ALU(BusW,Zero,BusA,BusB,ALUCtrl);
output reg [63:0]BusW;
output Zero;
input [63:0] BusA,BusB;
input [3:0]ALUCtrl;
always @ (ALUCtrl, BusA,BusB)
case(ALUCtrl)
`AND: BusW = BusA & BusB;
`OR:  BusW = BusA | BusB;
`ADD: BusW = BusA + BusB;
`SUB: BusW = BusA - BusB;
`PassB: 
begin
    BusW = BusB;
end
endcase
assign  Zero = (BusB==0);
endmodule