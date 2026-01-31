`timescale 1ns / 1ps
module barrel_shifter #(parameter width = 32)(
    input      [width - 1 :0] data_in,
    input [$clog2(width)-1:0]  control, //By how many places data_in has to shifted
    input             direc, // if 0 > shift left, if 1 shift right
    input             arith, // if 0 logical shift else arithmetic shift
    output reg [width-1:0] data_out
    );
    
    always @(*)
    begin
        case ({arith,direc})
        2'b00,2'b10: data_out = data_in << control;//logical left shift
        2'b01: data_out = data_in >> control;//logical right shift
        2'b11: data_out = $signed(data_in) >>> control;//arithmetic right shift
        default : data_out = {width{1'b0}};
        endcase
    end
endmodule


`timescale 1ns / 1ps

module tb_barrel_shifter;


    reg  [31:0] data_in;
    reg  [4:0] control;
    reg               direc;
    reg               arith;
    wire [31:0]  data_out;

    barrel_shifter #(
        .WIDTH(31)
    ) dut (
        .data_in(data_in),
        .control(control),
        .direc(direc),
        .arith(arith),
        .data_out(data_out)
    );

    initial begin
        data_in = {{(24){1'b0}}, 8'hF0};
        control = 4;
        direc   = 0;
        arith   = 0;
        #10;

        data_in = {{(24){1'b0}}, 8'hF0};
        control = 4;
        direc   = 1;
        arith   = 0;
        #10;

        data_in = {1'b1, {(31){1'b0}}};
        control = 4;
        direc   = 1;
        arith   = 1;
        #10;

        data_in = {1'b0, 1'b1, {(30){1'b0}}};
        control = 4;
        direc   = 1;
        arith   = 1;
        #10;

        data_in = {32{1'b1}};
        control = 0;
        direc   = 0;
        arith   = 0;
        #10;

        data_in = {32{1'b1}};
        control = 31;
        direc   = 1;
        arith   = 1;
        #10;

        $finish;
    end

endmodule
