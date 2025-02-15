module DoubleSwap
(
input [127:0] DS_IN,
output [127:0] DS_OUT 
);

wire [6:0] A;      //7_bits
wire [56:0] B;     //57_bits
wire [56:0] C;     //57_bits
wire [6:0] D;      //7_bits

assign A = DS_IN [6:0];
assign B = DS_IN [63:7];
assign C = DS_IN [120:64];
assign D = DS_IN [127:121];

assign DS_OUT = {C,A,D,B};

//assign DS_OUT [56:0] = B;     //57_bits
//assign DS_OUT [63:57] = D;    //7_bits
//assign DS_OUT [70:64] = A;    //7_bits
//assign DS_OUT [127:71] = C;   //57_bits


endmodule