`timescale 1ns / 1ps
module PCadder(
    input  logic [31:0] PC,
    output logic [31:0] PCplus4
    );
    
    assign PCplus4 = PC +32'd4;
    
endmodule
