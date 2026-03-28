`timescale 1ns / 1ps

module data_mem (
    input  logic        clk,
    input  logic        MemWrite,
    input  logic [ 2:0] funct3,
    input  logic [31:0] word_add,
    input  logic [31:0] data_in,
    output logic [31:0] data_o
);


logic [31:0] mem [63:0];

always_ff @(posedge clk)
begin
     if(MemWrite)  //if wrt_en is high then data_in goes in 
        case(funct3)
        3'b000:  begin
                 case(word_add[1:0])                                    //sb
                 2'b00:mem[word_add[31:2]][7:0]   <= data_in[7:0];
                 2'b01:mem[word_add[31:2]][15:8]  <= data_in[7:0];
                 2'b10:mem[word_add[31:2]][23:16] <= data_in[7:0];
                 2'b11:mem[word_add[31:2]][31:24] <= data_in[7:0];   
                 default: mem[word_add[31:2]] <= mem[word_add[31:2]];   //no change    
                 endcase
                 end
        3'b001:  begin
                 case(word_add[1:0])                                    //sh
                 2'b00:mem[word_add[31:2]][15:0]  <= data_in[15:0];     
                 2'b10:mem[word_add[31:2]][31:16] <= data_in[15:0];     
                 default: mem[word_add[31:2]] <= mem[word_add[31:2]];   //no change
                 endcase
                 end
        3'b010:  mem[word_add[31:2]] <= data_in;                        //sw
        default: mem[word_add[31:2]] <= mem[word_add[31:2]];            //no change    
        endcase
end
    
always_comb
begin
     case(funct3)
     3'b000:     begin  //lb
                 case(word_add[1:0])
                 2'b00: data_o = {{24{mem[word_add[31:2]][7]}},mem[word_add[31:2]][7:0]};
                 2'b01: data_o = {{24{mem[word_add[31:2]][15]}},mem[word_add[31:2]][15:8]};
                 2'b10: data_o = {{24{mem[word_add[31:2]][23]}},mem[word_add[31:2]][23:16]};
                 2'b11: data_o = {{24{mem[word_add[31:2]][31]}},mem[word_add[31:2]][31:24]};
                 default: data_o = {32{1'b0}}; // Invalid offset
                 endcase
                 end
     3'b001:     begin  //lh
                 case(word_add[1:0])
                 2'b00: data_o = {{16{mem[word_add[31:2]][15]}},mem[word_add[31:2]][15:0]};
                 2'b01: data_o = {{16{mem[word_add[31:2]][23]}},mem[word_add[31:2]][23:8]};                     
                 2'b10: data_o = {{16{mem[word_add[31:2]][31]}},mem[word_add[31:2]][31:16]};
                 default: data_o = {32{1'b0}}; // Invalid offset
                 endcase
                 end
     3'b010:     data_o = mem[word_add[31:2]];//lw 
     
     3'b100:     begin  //lbu
                 case(word_add[1:0])
                 2'b00: data_o = {{24{1'b0}},mem[word_add[31:2]][7:0]};
                 2'b01: data_o = {{24{1'b0}},mem[word_add[31:2]][15:8]};
                 2'b10: data_o = {{24{1'b0}},mem[word_add[31:2]][23:16]};
                 2'b11: data_o = {{24{1'b0}},mem[word_add[31:2]][31:24]};
                 default: data_o = {32{1'b0}}; // Invalid offset
                 endcase
                 end
     3'b101:     begin  //lhu
                 case(word_add[1:0])
                 2'b00: data_o = {{16{1'b0}},mem[word_add[31:2]][15:0]};
                 2'b10: data_o = {{16{1'b0}},mem[word_add[31:2]][31:16]};
                 default: data_o = {32{1'b0}}; // Invalid offset
                 endcase
                 end 
     default: data_o = {32{1'b0}}; // Invalid offset
     endcase
end


initial
begin
    $readmemh("../data_mem.hex",mem);
end

endmodule
