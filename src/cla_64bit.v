`timescale 1ns / 1ps
//64 bit cla adder using 4- 16 bit cla adders and propagation logic

module cla_64bit(input [63:0]A,
                 input [63:0]B,
                 input Cin,
                 output [63:0]S,
                 output Cout       
    );
wire [3:0]P,G,C;  //propagate,generate,carry

cla_16bit unit1(.A(A[15:0]),.B(B[15:0]),.Cin(Cin),.S(S[15:0]),.G_block(G[0]),.P_block(P[0]));
cla_16bit unit2(.A(A[31:16]),.B(B[31:16]),.Cin(C[0]),.S(S[31:16]),.G_block(G[1]),.P_block(P[1]));
cla_16bit unit3(.A(A[47:32]),.B(B[47:32]),.Cin(C[1]),.S(S[47:32]),.G_block(G[2]),.P_block(P[2]));
cla_16bit unit4(.A(A[63:48]),.B(B[63:48]),.Cin(C[2]),.S(S[63:48]),.G_block(G[3]),.P_block(P[3]));

//carry look ahead logic
assign C[0] = G[0]
             |(P[0] & Cin);

assign C[1] = G[1]
             |(P[1] & G[0])
             |(P[1] & P[0] & Cin);

assign C[2] = G[2]
             |(P[2] & G[1])
             |(P[2] & P[1] & G[0])
             |(P[2] & P[1] & P[0] & Cin);

assign C[3] = G[3]
             |(P[3] & G[2])
             |(P[3] & P[2] & G[1])
             |(P[3] & P[2] & P[1] & G[0])
             |(P[3] & P[2] & P[1] & P[0] & Cin);
             
assign Cout = C[3];    
endmodule
