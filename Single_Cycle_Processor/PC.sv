`timescale 1ns / 1ps
module PC(
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] PC_i,
    output logic [31:0] PC_o
    );
    
    always_ff @(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
            PC_o = 32'b0;
        else 
            PC_o = PC_i;
    end    
endmodule
