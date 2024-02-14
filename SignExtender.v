module SignExtender(BusImm, Imm26,Ctrl);
output reg [63:0] BusImm;
input [25:0] Imm26;
input [2:0] Ctrl;
always @ (Ctrl,Imm26)
begin
case(Ctrl)
    3'b000: BusImm = {52'b0,Imm26[21:10]};
    3'b001: BusImm = {{55{Imm26[20]}},Imm26[20:12]};
    3'b010: BusImm = {{36{Imm26[25]}},Imm26[25:0],2'b0};
    3'b011: BusImm = {{43{Imm26[23]}},Imm26[23:5],2'b0};
    3'b100: BusImm = {48'b0,{Imm26[20:5]}};
    3'b101    :   BusImm = {32'b0, Imm26[20:5], 16'b0}; //MOVZ LSL = 16
    3'b110    :   BusImm = {16'b0, Imm26[20:5], 32'b0}; //MOVZ LSL = 32
    3'b111    :   BusImm = {Imm26[20:5], 48'b0}; //MOVZ LSL = 48
endcase
end

    endmodule