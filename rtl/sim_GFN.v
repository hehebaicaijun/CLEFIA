`timescale 1ns / 1ps

module sim_GFN(

    );

reg [127:0] din;
reg [63:0] RK;
wire [127:0] dout;

GFN u0(
    .din(din),
    .RK(RK),
    .dout(dout)
);

initial begin
    din = 128'h00010203_fbebdbcb_08090a0b_b7a79787;
    RK = 64'hf3e6cef9_8df75e38;
end

endmodule