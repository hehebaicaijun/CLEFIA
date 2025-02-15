module CON_0to23(
input [3:0] Round,
output reg [63:0] CON
);
always@(*)
begin
case (Round)
    4'b0001 : CON = 64'hf56b7aeb_994a8a42;
    4'b0010 : CON = 64'h96a4bd75_fa854521;
    4'b0011 : CON = 64'h735b768a_1f7abac4;
    4'b0100 : CON = 64'hd5bc3b45_b99d5d62;
    4'b0101 : CON = 64'h52d73592_3ef636e5;
    4'b0110 : CON = 64'hc57a1ac9_a95b9b72;
    4'b0111 : CON = 64'h5ab42554_369555ed;
    4'b1000 : CON = 64'h1553ba9a_7972b2a2;
    4'b1001 : CON = 64'he6b85d4d_8a995951;
    4'b1010 : CON = 64'h4b550696_2774b4fc;
    4'b1011 : CON = 64'hc9bb034b_a59a5a7e;
    4'b1100 : CON = 64'h88cc81a5_e4ed2d3f;
    default : CON = 0;
endcase
end
endmodule