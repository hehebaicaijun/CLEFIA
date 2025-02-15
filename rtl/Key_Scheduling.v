module Key_Scheduling(
input [127:0] K,
input [127:0] L,
input [127:0] CON,
input CONTROL,
output [127:0] RK,             //RK output subject to CONTROL signal
output [127:0] L_DS
);

DoubleSwap DoubleSwap_instance1(.DS_IN(L), .DS_OUT(L_DS));
assign RK = CONTROL ? (L ^ CON ) : (L ^ CON ^ K); 

endmodule