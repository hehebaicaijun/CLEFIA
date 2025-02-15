module xorpost(
input           [127:0]     din,  //data in
input           [ 31:0]     WK2,
input           [ 31:0]     WK3,
output          [127:0]     dout  //data out
);

assign dout[127:96] = din[127:96];
assign dout[ 95:64] = din[ 95:64] ^ WK2;
assign dout[ 63:32] = din[ 63:32];
assign dout[ 31: 0] = din[ 31: 0] ^ WK3;

endmodule