`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 03:38:14
// Design Name: 
// Module Name: cla_16bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cla_16bit(input [15:0]A,
                 input [15:0]B,
                 input Cin,
                 output [15:0]S,
                 output Cout,
                 output P_block,
                 output G_block
    );
wire [3:0]P,G;
wire C1,C2,C3;
wire d0,d1,d2,d3;

cla_4bit unit1(.a(A[3:0]),.b(B[3:0]),.cin(Cin),.sum(S[3:0]),.cout(d0),.p(P[0]),.g(G[0]));
cla_4bit unit2(.a(A[7:4]),.b(B[7:4]),.cin(C1),.sum(S[7:4]),.cout(d1),.p(P[1]),.g(G[1]));
cla_4bit unit3(.a(A[11:8]),.b(B[11:8]),.cin(C2),.sum(S[11:8]),.cout(d2),.p(P[2]),.g(G[2]));
cla_4bit unit4(.a(A[15:12]),.b(B[15:12]),.cin(C3),.sum(S[15:12]),.cout(d3),.p(P[3]),.g(G[3]));

//block logic
assign P_block = P[0] & P[1] & P[2] & P[3];
assign G_block = G[3]
                |(P[3] & G[2])
                |(P[3] & P[2] & G[1])
                |(P[3] & P[2] & P[1] & G[0]);

//unit logic                
assign C1 = G[0] | (P[0] & Cin);

assign C2 = G[1] 
            |(P[1] & G[0])
            |(P[1] & P[0] & Cin);

assign C3 = G[2]
            |(P[2] & G[1])
            |(P[2] & P[1] & G[0])
            |(P[2] & P[1] & P[0] & Cin);

assign Cout = G[3]
             |(P[3] & G[2])
             |(P[3] & P[2] & G[1]) 
             |(P[3] & P[2] & P[1] & G[0])
             |(P[3] & P[2] & P[1] & P[0] & Cin);
endmodule
