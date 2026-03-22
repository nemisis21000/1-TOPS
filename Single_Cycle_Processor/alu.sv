`timescale 1ns / 1ps

module alu(
    //declaring inputs
    input  logic [31:0] A, 
    input  logic [31:0] B,
    input  logic [ 3:0] control_i,

    output logic [31:0] result,
    output logic        zero,
    output logic        alu_last_bit
);
    
always_comb
begin
    case (control_i)
        4'b0000:  result <= A + B;                                     // ADD
        4'b0001:  result <= (A << B[4:0]);                             // sll  
        4'b0010:  result <= {{31{1'b0}}, ($signed(A) < $signed(B))};   // slt    
        4'b0011:  result <= {{31{1'b0}}, (A < B)};                     // sltu  
        4'b0100:  result <= A ^ B;                                     // XOR
        4'b0101:  result <= (A >> B[4:0]);                             // srl
        4'b0110:  result <= A | B;                                     // OR
        4'b0111:  result <= A & B;                                     // AND       
        4'b1000:  result <=  A - B;                                    // SUB
        4'b1001:  result <= $signed(A) >>> B[4:0];                     // sra
        default:  result <= 0;
    endcase
end

assign zero = (result == 0) ? 1'b1 : 1'b0;
assign alu_last_bit = result[0];

endmodule
