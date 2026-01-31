    `timescale 1ns / 1ps
    module ff_sync(
        input clk_des,
        input signal_in,
        output reg signal_out
        );
        
        reg ff;
        
        always @(posedge clk_des)
        begin
            ff <= signal_in;
            signal_out <= ff;
        end
    endmodule



`timescale 1ns/1ps

module tb();

reg clk_des,signal_in;
wire signal_out;

ff_sync dut (clk_des,signal_in,signal_out);

initial
begin
    clk_des = 0;
    signal_in = 0;
end

always #10 clk_des = ~clk_des;

initial
begin
    #20
    signal_in = 1;
    #30
    signal_in = 0;
    #10;
    signal_in = 1;
    $finish;
end
endmodule