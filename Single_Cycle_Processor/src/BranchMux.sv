`timescale 1ns / 1ps

module BRANCHmux        //name can be changed
(
    input  logic [31:0] Rs1,
    input  logic [31:0] PC,
    input  logic [ 1:0] src,     //name can be changed
    output logic [31:0] adder_i  //input of the Branch adder name should be changed
    );
    
    assign adder_i = (src == 2'b00)? PC   :
                     (src == 2'b01)? 32'b0: Rs1;
                        
endmodule