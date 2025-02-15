module M1(
input    [7:0]   s0,
input    [7:0]   s1,
input    [7:0]   s2,
input    [7:0]   s3,
output   [7:0]   y0,
output   [7:0]   y1,
output   [7:0]   y2,
output   [7:0]   y3
);

//cn*s[i], n=2,8,a, i=0~3
wire     [7:0]    s   [3:0];
wire     [7:0]   c2s   [3:0];
wire     [7:0]   c8s   [3:0];
wire     [7:0]   cas   [3:0];

//use 2D array to store s
assign s[0] = s0;
assign s[1] = s1;
assign s[2] = s2;
assign s[3] = s3;

genvar i;
generate
    for ( i = 0; i <= 3; i = i + 1) begin : mult
        MUL_CON2 u0(
            .din(s[i]),
            .dout(c2s[i])
        );

        MUL_CON8 u1(
            .din(s[i]),
            .dout(c8s[i])
        );

        MUL_CONa u2(
            .din(s[i]),
            .dout(cas[i])
        );
    end
endgenerate

assign y0 =  (s[0] ^ c8s[1]) ^ (c2s[2] ^ cas[3]);
assign y1 = (c8s[0] ^  s[1]) ^ (cas[2] ^ c2s[3]);
assign y2 = (c2s[0] ^ cas[1]) ^  (s[2] ^ c8s[3]);
assign y3 = (cas[0] ^ c2s[1]) ^ (c8s[2] ^  s[3]);
endmodule