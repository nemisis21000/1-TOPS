`timescale 1ns / 1ps

module PCmux
(
    input  logic [31:0] PCplus4,
    input  logic [31:0] Branch,
    input  logic        sel, // and of branch control signal and zero signal of alu
    output logic [31:0] PCin 
    );
    
    assign PCin = (sel)? Branch:PCplus4;
endmodule
