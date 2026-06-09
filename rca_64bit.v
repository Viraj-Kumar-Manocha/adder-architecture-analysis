`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.06.2026 15:39:52
// Design Name: 
// Module Name: rca_64bit
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


module rca_64bit(input [63:0]A,
                 input [63:0]B,
                 input Cin,
                 output [63:0]Sum,
                 output Cout
    );
wire C1,C2,C3;
rca_16bit unit1(.A(A[15:0]),.B(B[15:0]),.Cin(Cin),.S(Sum[15:0]),.Cout(C1));
rca_16bit unit2(.A(A[31:16]),.B(B[31:16]),.Cin(C1),.S(Sum[31:16]),.Cout(C2));
rca_16bit unit3(.A(A[47:32]),.B(B[47:32]),.Cin(C2),.S(Sum[47:32]),.Cout(C3));
rca_16bit unit4(.A(A[63:48]),.B(B[63:48]),.Cin(C3),.S(Sum[63:48]),.Cout(Cout));

endmodule
