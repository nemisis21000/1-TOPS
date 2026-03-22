`timescale 1ns / 1ps
module and_logic(
    input  logic branch,
    input  logic zero,
    output logic and_out
    );
    
    assign and_out = zero & branch;
endmodule
