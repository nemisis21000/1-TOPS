`timescale 1ns / 1ps

module REGmux
(
    input  logic [31:0] result,    // from ALU
    input  logic [31:0] data_o,    // from data_mem
    input  logic [31:0] PCplus4,   // for Jump instructions
    input  logic [31:0] branch_adder_o,   // for lui and auipc
    input  logic [ 1:0] MemtoReg,  // from control unit
    output logic [31:0] WriteData  // data written back to register file
    );
        
    always_comb begin
        case(MemtoReg)
        2'b00:  WriteData = result;
        2'b01:  WriteData = data_o;
        2'b10:  WriteData = PCplus4;
        2'b11:  WriteData = branch_adder_o;
        default:WriteData = 32'b00;
        endcase
    end
endmodule