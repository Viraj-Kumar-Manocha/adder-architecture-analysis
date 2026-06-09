`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2026 03:38:26
// Design Name: 
// Module Name: rca_16bit
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


module rca_16bit(input [15:0]A,
                 input [15:0]B,
                 input Cin,
                 output [15:0]S,
                 output Cout
    );
wire C1,C2,C3;    
rca_4bit adder1(.a(A[3:0]),.b(B[3:0]),.cin(Cin),.sum(S[3:0]),.cout(C1)); 
rca_4bit adder2(.a(A[7:4]),.b(B[7:4]),.cin(C1),.sum(S[7:4]),.cout(C2));    
rca_4bit adder3(.a(A[11:8]),.b(B[11:8]),.cin(C2),.sum(S[11:8]),.cout(C3));    
rca_4bit adder4(.a(A[15:12]),.b(B[15:12]),.cin(C3),.sum(S[15:12]),.cout(Cout));    
   
endmodule
