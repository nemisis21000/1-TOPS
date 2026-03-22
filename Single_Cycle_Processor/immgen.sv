`timescale 1ns / 1ps
module immgen(           // from the 7 bits of opcode only first two bits [7:6] is really required
    input  logic [31:0] instr,  // from the 32 bits of the instr only [31:7] carry info required for
    output logic [31:0] imm_o
    );
    
    always_comb
    begin
        case(instr[6:0])
        
        //I - Type load
        7'b0000011: imm_o = {{20{instr[31]}},instr[31:20]};
        
        //I - Type like addi,subi
        7'b0010011: imm_o = {{20{instr[31]}},instr[31:20]};
        
        //I - Type JALR
        7'b1100111: imm_o = {{20{instr[31]}},instr[31:20]};
        
        //S - Type Store
        7'b0100011: imm_o = {{20{instr[31]}},instr[31:25],instr[11:7]};
        
        //SB - Type Branch
        7'b1100011: imm_o = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
        
        //J  - Type JAL
        7'b1101111: imm_o = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
        
        //U - Type LUI 
        7'b0110111: imm_o = {instr[31:12],12'b0};
        
        //U - Type AUIPC
        7'b0010111: imm_o = {instr[31:12],12'b0};
        
        default   : imm_o = 32'b00;
        endcase
    end
endmodule
