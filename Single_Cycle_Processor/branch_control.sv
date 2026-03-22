`timescale 1ns / 1ps
module branch_control(
    input  logic [2:0] funct3,
    input  logic       Jump,
    input  logic       Branch,
    input  logic       zero,
    input  logic       alu_last_bit,
    output logic       branch_assert
    );
    
    always_comb begin
        if (Jump)
            branch_assert = 1'b1;
        
        else if(Branch) begin
            branch_assert = 1'b0;
            case(funct3)
            3'b000: branch_assert = (zero==1);           // BEQ 
            3'b001: branch_assert = (zero!=1);           //BNE
            3'b100: branch_assert = (alu_last_bit == 1); //BLT
            3'b101: branch_assert = (alu_last_bit != 1); //BGE
            3'b110: branch_assert = (alu_last_bit == 1); //BLTU
            3'b111: branch_assert = (alu_last_bit != 1); //BGEU 
            default:branch_assert = 1'b0;
            endcase
        end
        else
            branch_assert = 1'b0;
    end
endmodule
