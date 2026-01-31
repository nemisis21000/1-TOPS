`timescale 1ns / 1ps
module updowncounter(
    input            clk,
    input            rst,
    input            direc, //0 for down and 1 for up
    output reg [3:0] counter
    );
    
    always @(posedge clk)
    begin
        if(rst)
            counter = 4'b0000;
        else if (direc)    
            counter = counter + 4'b0001;
        else if (!direc)
            counter = counter - 4'b0001;
        else counter = 4'b0000;
    end            
endmodule



`timescale 1ns / 1ps
module tb();

reg clk,rst,dir;
wire [3:0] counter;

updowncounter dut (clk,rst,dir,counter);

initial
begin
    clk = 1;
    rst = 1;
    dir = 0;
    #22
    rst = 0;
    #150
    dir = 1;
end
always #10 clk = ~clk;
endmodule
