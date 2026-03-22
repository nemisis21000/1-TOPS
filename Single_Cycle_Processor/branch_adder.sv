`timescale 1ns / 1ps
module branch_adder(
    input  logic [31:0] adder_i, //change the name pls
    input  logic [31:0] imm,
    output logic [31:0] branch
    );
    
    assign branch = adder_i + imm;
    
endmodule
