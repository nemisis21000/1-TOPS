`timescale 1ns / 1ps
module reg_file(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        RegWrite,
    input  logic [ 4:0] Rs1,
    input  logic [ 4:0] Rs2,
    input  logic [ 4:0] Rd,
    input  logic [31:0] WriteData,
    output logic [31:0] ReadData1,
    output logic [31:0] ReadData2
    );
    
    logic [31:0] register [0:31];
    
    always_ff @(posedge clk)
    begin
        if(!rst_n)
            for(int i = 0; i< 32; i++)
                register[i] <= 32'b0;            
        
        else if (RegWrite == 1'b1 && Rd != 5'b0) 
            register[Rd] <= WriteData;
    end
    
    always_comb
    begin
        ReadData1 = register[Rs1];
        ReadData2 = register[Rs2];        
    end
    
endmodule
