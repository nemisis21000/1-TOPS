`timescale 1ns / 1ps

module top (
    input  logic clk,
    input  logic rst_n
);

    // =========================
    // Internal Signals
    // =========================

    // Data signals
    logic [31:0] instruction_top;
    logic [31:0] Rd1_top, Rd2_top;
    logic [31:0] imm_o_top;
    logic [31:0] alu_mux_top;
    logic [31:0] BranchAdd_top, PCplus4_top;
    logic [31:0] PC_i_top, PC_o_top;
    logic [31:0] result_top;
    logic [31:0] data_o_top;
    logic [31:0] write_data_top;
    logic [31:0] adder_i_top;

    // Control signals
    logic        RegWrite_top;
    logic        ALUSrc_top;
    logic        Branch_top;
    logic        Jump_top;
    logic        zero_top;
    logic        alu_last_bit_top;
    logic        PC_sel;
    logic        MemWrite_top;

    logic [3:0]  alu_control_top;
    logic [1:0]  ALUOp_top;
    logic [1:0]  MemtoReg_top;
    logic [1:0]  Src_top;
    // =========================
    // Program Counter
    // =========================

    PC PC (
        .clk    (clk),
        .rst_n  (rst_n),
        .PC_i   (PC_i_top),
        .PC_o   (PC_o_top)
    );

    PCadder PC_ADDER (
        .PC       (PC_o_top),
        .PCplus4  (PCplus4_top)
    );

    // =========================
    // Instruction Memory
    // =========================

    instr_mem INSTR_MEMORY (
        .clk       (clk),
        .ReadAdd   (PC_o_top),
        .instr_o   (instruction_top)
    );

    // =========================
    // Register File
    // =========================

    reg_file REG_FILE (
        .clk         (clk),
        .rst_n       (rst_n),
        .RegWrite    (RegWrite_top),
        .Rs1         (instruction_top[19:15]),
        .Rs2         (instruction_top[24:20]),
        .Rd          (instruction_top[11:7]),
        .WriteData   (write_data_top),
        .ReadData1   (Rd1_top),
        .ReadData2   (Rd2_top)
    );

    // =========================
    // Immediate Generator
    // =========================

    immgen IMM_GEN (
        .instr   (instruction_top),
        .imm_o   (imm_o_top)
    );

    // =========================
    // Control Unit
    // =========================

    control_unit CONTROL_UNIT (
        .instr     (instruction_top[6:0]),
        .Jump      (Jump_top),
        .Branch    (Branch_top),
        .MemtoReg  (MemtoReg_top),
        .MemWrite  (MemWrite_top),
        .ALUSrc    (ALUSrc_top),
        .RegWrite  (RegWrite_top),
        .ALUOp     (ALUOp_top),
        .Src       (Src_top)
    );

    // =========================
    // ALU Control
    // =========================

    alu_control ALU_CONTROL (
        .op5         (instruction_top[5]),
        .funct7      (instruction_top[30]),
        .funct3      (instruction_top[14:12]),
        .ALUOp       (ALUOp_top),
        .control_o   (alu_control_top)
    );

    // =========================
    // ALU
    // =========================

    alu ALU (
        .A            (Rd1_top),
        .B            (alu_mux_top),
        .control_i    (alu_control_top),
        .result       (result_top),
        .zero         (zero_top),
        .alu_last_bit (alu_last_bit_top)
    );

    // =========================
    // ALU Input MUX
    // =========================

    ALUmux ALU_MUX (
        .Rs2  (Rd2_top),
        .imm  (imm_o_top),
        .ALUsrc (ALUSrc_top),
        .B   (alu_mux_top)
    );
    // =========================
    // Branch Adder Mux
    // =========================

    BRANCHmux BRANCH_ADDER_MUX (
        .PC      (PC_o_top),
        .Rs1     (Rd1_top),
        .src     (Src_top),
        .adder_i (adder_i_top)
    );

    // =========================
    // Branch Adder
    // =========================

    branch_adder BRANCH_ADDER (
        .adder_i (adder_i_top),
        .imm    (imm_o_top),
        .branch (BranchAdd_top)
    );

    // =========================
    // Branch Decision Logic
    // =========================

    branch_control BRANCH_CONTROL (
        .funct3         (instruction_top[14:12]),
        .Jump           (Jump_top),
        .Branch         (Branch_top),
        .zero           (zero_top),
        .alu_last_bit   (alu_last_bit_top),
        .branch_assert  (PC_sel)
    );

    // =========================
    // PC Selection MUX
    // =========================

    PCmux PC_MUX (
        .PCplus4  (PCplus4_top),
        .Branch   (BranchAdd_top),
        .sel      (PC_sel),
        .PCin     (PC_i_top)
    );

    // =========================
    // Data Memory
    // =========================

    data_mem DATA_MEMORY (
        .clk       (clk),
        .MemWrite  (MemWrite_top),
        .funct3    (instruction_top[14:12]),
        .word_add  (result_top),
        .data_in   (Rd2_top),
        .data_o    (data_o_top)
    );

    // =========================
    // Writeback MUX
    // =========================

    REGmux REG_MUX (
        .result         (result_top),
        .PCplus4        (PCplus4_top),
        .data_o         (data_o_top),
        .branch_adder_o (BranchAdd_top),
        .MemtoReg       (MemtoReg_top),
        .WriteData      (write_data_top)
    );

endmodule