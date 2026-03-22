`timescale 1ns / 1ps
module branch_adder(
    input  logic [31:0] PC,
    input  logic [31:0] imm,
    output logic [31:0] branch
    );
    
    assign branch = PC + imm;
    
endmodule
