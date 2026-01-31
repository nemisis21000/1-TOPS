`timescale 1ns / 1ps
module posedge_input(
    input  clk,
    input  signal,
    output pulse
);

reg prev;

always @(posedge clk) begin
    prev <= signal;
end

assign pulse = signal & ~prev; 
endmodule



`timescale 1ns / 1ps
module tb();

reg clk,in;
wire out;

posedge_input dut(clk,in,out);

initial
    {clk,in} = 2'b0;

always #3 clk = ~clk;

initial
begin
    #10
    in = 1'b1;
    #15
    in = 1'b0;
    #10
    in = 1'b1;
    #5
    in = 1'b0;
    #20
    $finish;
end
endmodule
