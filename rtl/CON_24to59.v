module CON_24to59(
input [4:0] Round,
output reg [127:0] CON
);

always@(*)
begin
case(Round)
    5'b00001 : CON = 128'h7c6f68e2_104e8ecb_d2263471_be07c765;
    5'b00010 : CON = 128'h7c6f68e2_104e8ecb_d2263471_be07c765;
    5'b00011 : CON = 128'h511a3208_3d3bfbe6_1084b134_7ca565a7;
    5'b00100 : CON = 128'h511a3208_3d3bfbe6_1084b134_7ca565a7;
    5'b00101 : CON = 128'h304bf0aa_5c6aaa87_f4347855_9815d543;
    5'b00110 : CON = 128'h304bf0aa_5c6aaa87_f4347855_9815d543;
    5'b00111 : CON = 128'h4213141a_2e32f2f5_cd180a0d_a139f97a;
    5'b01000 : CON = 128'h4213141a_2e32f2f5_cd180a0d_a139f97a;
    5'b01001 : CON = 128'h5e852d36_32a464e9_c353169b_af72b274;
    5'b01010 : CON = 128'h5e852d36_32a464e9_c353169b_af72b274;
    5'b01011 : CON = 128'h8db88b4d_e199593a_7ed56d96_12f434c9;
    5'b01100 : CON = 128'h8db88b4d_e199593a_7ed56d96_12f434c9;
    5'b01101 : CON = 128'hd37b36cb_bf5a9a64_85ac9b65_e98d4d32;
    5'b01110 : CON = 128'hd37b36cb_bf5a9a64_85ac9b65_e98d4d32;
    5'b01111 : CON = 128'h7adf6582_16fe3ecd_d17e32c1_bd5f9f66;
    5'b10000 : CON = 128'h7adf6582_16fe3ecd_d17e32c1_bd5f9f66;
    5'b10001 : CON = 128'h50b63150_3c9757e7_1052b098_7c73b3a7;
    5'b10010 : CON = 128'h50b63150_3c9757e7_1052b098_7c73b3a7;
    default : CON = 0;
endcase
end
endmodule