module shift(
input     [127:0]     din,  //data in, 128 bits
output    [127:0]     dout  //data out, 128 bits
);

assign dout[127:96] = din[ 95:64];
assign dout[ 95:64] = din[ 63:32];
assign dout[ 63:32] = din[ 31: 0];
assign dout[ 31: 0] = din[127:96];

endmodule