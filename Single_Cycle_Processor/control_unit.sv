`timescale 1ns / 1ps
module control_unit (
    // Inputs
    input  logic [6:0]  instr,   // opcode

    // Outputs
    output logic        Jump,
    output logic        Branch,
    output logic [1:0]  MemtoReg,
    output logic        MemWrite,
    output logic        ALUSrc,
    output logic        RegWrite,
    output logic [1:0]  ALUOp
);
    always_comb
    begin
        case(instr)
        //R type
        7'b0110011: {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b0_00_100_0_10;
        //I type - load
        7'b0000011: {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b1_01_100_0_00;
        //I type - arth imm
        7'b0010011: {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b1_00_100_0_10;
        //S type - store
        7'b0100011: {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b1_00_010_0_00;
        //B type - branch
        7'b1100011: {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b0_00_001_0_01;
        //J type - JAL
        7'b1101111: {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b0_10_101_1_00;
        //default
        default:    {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp} = 9'b0; 
        endcase
    end
endmodule
