`timescale 1ns / 1ps
module control_unit (
    // Inputs
    input  logic [6:0] opcode,   // opcode
    input  logic [2:0] funct3,   
    input  logic       funct7,
    
    // Outputs
    output logic        Jump,
    output logic        Branch,
    output logic [1:0]  MemtoReg,
    output logic        MemWrite,
    output logic        ALUSrc,
    output logic        RegWrite,
    output logic [1:0]  Src,
    output logic [3:0]  alu_control

);
    
    logic [1:0] ALUOp;
    
    always_comb
    begin
        case(opcode)
        //R type
        7'b0110011:// {ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0_00_100_0_10_00;
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b00;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b10;
            Src        = 2'b00;
        end
        //I type - load
        7'b0000011: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b1_01_100_0_00_00;
        begin
            ALUSrc     = 1'b1;
            MemtoReg   = 2'b01;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b00;
            Src        = 2'b00;
        end
        //I type - arth imm
        7'b0010011: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b1_00_100_0_10_00;
        begin
            ALUSrc     = 1'b1;
            MemtoReg   = 2'b00;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b10;
            Src        = 2'b00;
        end
        
        //S type - store
        7'b0100011: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b1_00_010_0_00_00;
        begin
            ALUSrc     = 1'b1;
            MemtoReg   = 2'b00;
            RegWrite   = 1'b0;
            MemWrite   = 1'b1;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b00;
            Src        = 2'b00;
        end
        
        //B type - branch
        7'b1100011: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0_00_001_0_01_00;
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b00;
            RegWrite   = 1'b0;
            MemWrite   = 1'b0;
            Branch     = 1'b1;
            Jump       = 1'b0;
            ALUOp      = 2'b01;
            Src        = 2'b00;
        end
        
        //J type - JAL
        7'b1101111: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0_10_100_1_00_00;
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b10;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b1;
            ALUOp      = 2'b00;
            Src        = 2'b00;
        end
        
        //U type - AUIPC
        7'b0010111: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0_11_100_0_00_00;
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b11;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b00;
            Src        = 2'b00;
        end
        
        //U type - LUI
        7'b0110111: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0_11_100_0_00_01;
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b11;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b00;
            Src        = 2'b01;
        end
        
        //I type - JALR
        7'b1100111: //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0_10_100_1_00_10;
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b10;
            RegWrite   = 1'b1;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b1;
            ALUOp      = 2'b00;
            Src        = 2'b10;
        end
        //default
        default:    //{ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jump,ALUOp,Src} = 11'b0; 
        begin
            ALUSrc     = 1'b0;
            MemtoReg   = 2'b00;
            RegWrite   = 1'b0;
            MemWrite   = 1'b0;
            Branch     = 1'b0;
            Jump       = 1'b0;
            ALUOp      = 2'b00;
            Src        = 2'b00;
        end
        endcase
    end
    
    always_comb 
    begin
        case (ALUOp)
            // Store and Load >> ADD
            2'b00: alu_control = 4'b0000;

            // B-type (branch) 
            2'b01: begin
                case (funct3)                
                    3'b000: alu_control = 4'b1000;    //sub for beq
                    3'b001: alu_control = 4'b1000;    //sub for bne
                    3'b100: alu_control = 4'b0010;    //slt for blt
                    3'b101: alu_control = 4'b0010;    //slt for bge
                    3'b110: alu_control = 4'b0011;    //sltu for bltu
                    3'b111: alu_control = 4'b0011;    //sltu for bgeu
                    default:alu_control = 4'b0000;
                endcase
            end
            // R-type / I-type
            2'b10: begin
                case (funct3)
                    3'b000: alu_control = (funct7 & opcode[5]) ? 4'b1000 : 4'b0000; // sub / add / addi
                    3'b001: alu_control = 4'b0001; // sll / slli
                    3'b010: alu_control = 4'b0010; // slt / slti
                    3'b011: alu_control = 4'b0011; // sltu / sltiu
                    3'b100: alu_control = 4'b0100; // xor / xori
                    3'b101: alu_control = (funct7) ? 4'b1001 : 4'b0101; // sra/srai or srl/srli
                    3'b110: alu_control = 4'b0110; // or / ori
                    3'b111: alu_control = 4'b0111; // and / andi
                    default:alu_control = 4'b0000;
                endcase
            end

            default: alu_control = 4'b0000;

        endcase
    end
    
    
endmodule
