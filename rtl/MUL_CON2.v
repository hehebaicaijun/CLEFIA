//This module implements multiplication on the Galois field GF(2^8), in particular multiplication by 2. 
//the generating polynomial for the Galois field is z^8 + z^4 + z^3 + z^2 + 1  which = 9'h11d = 1_0001_1101
module MUL_CON2(
input     [7:0]     din,  //data in, 8 bits
output    [7:0]     dout  //data out, 8 bits
);

wire [7:0] x;

//we are calculating the result of multiplying din by 2
//so it is equivalent to right shift the lower 8 bits of the generated polynomial to get 00001110
assign x = (din[7]==1)? din ^ 8'b0000_1110 : din;

//shifting all bits in x one step to the left (which is equivalent to multiplying x by 2 in GF(2^8)) 
//and moving the previously most significant bit to the least significant position.
assign dout = (x << 1) | (x >> 7);

endmodule