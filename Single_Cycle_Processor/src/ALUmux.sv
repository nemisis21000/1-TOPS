`timescale 1ns / 1ps

module ALUmux
(
    input  logic [31:0] Rs2,
    input  logic [31:0] imm,
    input  logic        ALUsrc,
    output logic [31:0] B  //B input of the alu
    );
    
    assign B = (ALUsrc)? imm:Rs2;
endmodule