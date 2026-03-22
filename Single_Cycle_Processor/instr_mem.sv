`timescale 1ns / 1ps
module instr_mem(
    input  logic        clk,
    input  logic [31:0] ReadAdd,
    output logic [31:0] instr_o
    );
    
    logic [31:0] I_mem [127:0];
    
    assign instr_o = I_mem[{2'b00,ReadAdd[31:2]}];
    
initial 
begin
        $readmemh("../inst_file.hex", I_mem);
end
endmodule
