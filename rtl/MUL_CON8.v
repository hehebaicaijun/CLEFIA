module MUL_CON8(
input     [7:0]     din,  //data in, 8 bits
output    [7:0]     dout  //data out, 8 bits
);

wire [7:0] x;//x=2*din

MUL_CON2 u0(
    .din(din),
    .dout(x)
);

MUL_CON4 u1(
    .din(x),
    .dout(dout)
);
endmodule