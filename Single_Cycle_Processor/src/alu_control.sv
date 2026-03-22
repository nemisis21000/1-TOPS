`timescale 1ns / 1ps

module alu_control (
    // Inputs
    input  logic       op5,        // 5th bit of opcode (distinguishes sub vs addi)
    input  logic       funct7,
    input  logic [2:0] funct3,
    input  logic [1:0] ALUOp,

    // Output
    output logic [3:0] control_o
);

    always_comb begin
        case (ALUOp)

            // S-type (e.g., store) → ADD
            2'b00: control_o = 4'b0000;

            // B-type (branch) → SUB (for comparison)
            2'b01: begin
                case (funct3)                
                    3'b000: control_o = 4'b1000;
                    3'b001: control_o = 4'b1000;
                    3'b100: control_o = 4'b0010;
                    3'b101: control_o = 4'b0010;
                    3'b110: control_o = 4'b0011;
                    3'b111: control_o = 4'b0011;
                    default: control_o = 4'b0000;
                endcase
            end
            // R-type / I-type
            2'b10: begin
                case (funct3)
                    3'b000: control_o = (funct7 & op5) ? 4'b1000 : 4'b0000; // sub / add / addi
                    3'b001: control_o = 4'b0001; // sll / slli
                    3'b010: control_o = 4'b0010; // slt / slti
                    3'b011: control_o = 4'b0011; // sltu / sltiu
                    3'b100: control_o = 4'b0100; // xor / xori
                    3'b101: control_o = (funct7) ? 4'b1001 : 4'b0101; // sra/srai or srl/srli
                    3'b110: control_o = 4'b0110; // or / ori
                    3'b111: control_o = 4'b0111; // and / andi
                    default: control_o = 4'b0000;

                endcase
            end

            default: control_o = 4'b0000;

        endcase
    end

endmodule