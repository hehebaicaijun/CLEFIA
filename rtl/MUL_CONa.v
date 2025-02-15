module MUL_CONa(
input     [7:0]     din,  //data in, 8 bits
output    [7:0]     dout  //data out, 8 bits
);

wire [7:0] x0;//x0=2*din
wire [7:0] x1;//x1=8*din

MUL_CON2 u0(
    .din(din),
    .dout(x0)
);

MUL_CON8 u1(
    .din(din),
    .dout(x1)
);

assign dout = x0 ^ x1;
endmodule