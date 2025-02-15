`timescale 1ns / 1ps

module sim_top(

    );

reg clk;
reg rst_n;
reg [127:0] din;
reg [127:0] key;
reg din_valid;

wire [127:0] dout;
wire dout_valid;

CLEFIA_top u0(                     
.clk(clk),
.rst_n(rst_n),
.din(din),        
.key(key),        
.din_valid(din_valid),
.dout(dout),       
.dout_valid(dout_valid)
);

always #10 clk = ~clk;

initial begin
    clk = 0;rst_n = 0;din = 0; din_valid = 0; key = 0;
    #5 rst_n = 1;
    #30 key = 128'hffeeddcc_bbaa9988_77665544_33221100; din_valid = 1; din = 128'h00010203_04050607_08090a0b_0c0d0e0f;
    #710 din = 0; din_valid = 0; key = 0;
end
endmodule