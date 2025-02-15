//Data randomization block in paper
module GFN(
input     [127:0]     din,  //data in, 128 bits
input     [ 63:0]     RK,
output    [127:0]     dout  //data out
);


//wire define
wire      [31:0]      din32     [3:0];    //seperate din to 32-bit data din32
wire      [31:0]      RK32      [1:0];    //seperate RK to 32-bit like RK0,RK1 in Fig.1
wire      [ 7:0]      f0_k      [3:0];    //seperate RK32 to k, like k0, k1, k2, k3 in Fig.1
wire      [ 7:0]      f1_k      [3:0];
wire      [ 7:0]      f0_x      [3:0];    //seperate din32 to x, like x0, x1, x2, x3 in Fig.1
wire      [ 7:0]      f1_x      [3:0];
wire      [ 7:0]      f0_xor    [3:0];    //xor (in f) result
wire      [ 7:0]      f1_xor    [3:0];
wire      [ 7:0]      f0_s      [3:0];    //S-box result 
wire      [ 7:0]      f1_s      [3:0];
wire      [ 7:0]      f0_y      [3:0];    //y0, y1, y2, y3
wire      [ 7:0]      f1_y      [3:0];
wire      [31:0]      f0_dout;            //combine y to f output
wire      [31:0]      f1_dout;


//assign
assign RK32[0] = RK[63:32];
assign RK32[1] = RK[31: 0];
assign f0_dout = {f0_y[0], f0_y[1], f0_y[2], f0_y[3]};
assign f1_dout = {f1_y[0], f1_y[1], f1_y[2], f1_y[3]};

genvar i;
generate
    for ( i = 0; i <= 3; i = i + 1) begin : step0
        assign din32[i] = din[127-32*i : 96-32*i];
        assign f0_k[i] = RK32[0][31-8*i : 24-8*i];
        assign f1_k[i] = RK32[1][31-8*i : 24-8*i];
        assign f0_x[i] = din32[0][31-8*i : 24-8*i];
        assign f1_x[i] = din32[2][31-8*i : 24-8*i];
    end
endgenerate


//f0
//step0: din32[0] seperate to x0~3, and RK[0] seperate to k0~3 (shown above)
//step1: f0_xor = f0_x ^ f0_k
//step2: f0_s = S(f0_xor), function S is implemented by look-up-table
//step3: y = f0_s * M0, it is matrix multiplication and implemented by constant_multipier and xor.
genvar m;
generate
    for ( m = 0; m <= 3; m = m + 1) begin : step1_f0
        assign f0_xor[m] = f0_x[m] ^ f0_k[m];
    end
endgenerate

genvar n;
generate
    for ( n = 0; n <= 1; n = n + 1) begin : step2_f0
        S0 u0(
            .din(f0_xor[2*n]),
            .dout(f0_s[2*n])
        );

        S1 u1(
            .din(f0_xor[2*n+1]),
            .dout(f0_s[2*n+1])
        );
    end
endgenerate

M0 u2(                                      //step3_f0
    .s0(f0_s[0]),
    .s1(f0_s[1]),
    .s2(f0_s[2]),
    .s3(f0_s[3]),
    .y0(f0_y[0]),
    .y1(f0_y[1]),
    .y2(f0_y[2]),
    .y3(f0_y[3])
);


//f1
//same like f0
genvar j;
generate
    for ( j = 0; j <= 3; j = j + 1) begin : step1_f1
        assign f1_xor[j] = f1_x[j] ^ f1_k[j];
    end
endgenerate

genvar k;
generate
    for ( k = 0; k <= 1; k = k + 1) begin : step2_f1
        S1 u3(
            .din(f1_xor[2*k]),
            .dout(f1_s[2*k])
        );

        S0 u4(
            .din(f1_xor[2*k+1]),
            .dout(f1_s[2*k+1])
        );
    end
endgenerate

M1 u5(                                      //step3_f1
    .s0(f1_s[0]),
    .s1(f1_s[1]),
    .s2(f1_s[2]),
    .s3(f1_s[3]),
    .y0(f1_y[0]),
    .y1(f1_y[1]),
    .y2(f1_y[2]),
    .y3(f1_y[3])
);


//XOR after f0,f1
assign dout[ 95:64] = f0_dout ^ din32[1];
assign dout[ 31: 0] = f1_dout ^ din32[3];
//dout from din
assign dout[127:96] = din32[0];
assign dout[ 63:32] = din32[2];
endmodule