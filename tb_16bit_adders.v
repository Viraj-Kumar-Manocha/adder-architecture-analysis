`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 03:21:43
// Design Name: 
// Module Name: tb_16bit_adders
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


module tb_16bit_adders;
reg Cin;
reg [15:0] A,B;
wire [15:0]S_RCA,S_CLA;
wire Cout_RCA,Cout_CLA;
integer i;

rca_16bit unit1(.A(A),.B(B),.Cin(Cin),.S(S_RCA),.Cout(Cout_RCA));
cla_16bit unit2(.A(A),.B(B),.Cin(Cin),.S(S_CLA),.Cout(Cout_CLA));

initial begin 
    $display ("Starting test of 16 bit RCA and CLA");
    $monitor ("T=%0t | A=%h | B=%h | RCA = (%b) %h | CLA = (%b) %h",$time,A,B,Cout_RCA,S_RCA,Cout_CLA,S_CLA);

    // Edge cases
    A = 16'h0000; B = 16'h0000; Cin = 1'b0; #10;
    A = 16'h0000; B = 16'h0000; Cin = 1'b1; #10;
    A = 16'hFFFF; B = 16'h0000; Cin = 1'b0; #10;
    A = 16'hFFFF; B = 16'h0001; Cin = 1'b1; #10;
    A = 16'hAAAA; B = 16'h5555; Cin = 1'b1; #10;

    //random cases
   for (i=0;i<10;i=i+1) begin
        A = $urandom;
        B = $urandom;
        Cin = $urandom;
        #10;
    
        if ({Cout_RCA, S_RCA} !== (A + B + Cin )) begin
            $display("ERROR in RCA: A=%h B=%h", A, B);
        end

        if ({Cout_CLA, S_CLA} !== (A + B + Cin)) begin
            $display("ERROR in CLA: A=%h B=%h", A, B);
        end
    end 
$display("16 bit test completed");
$finish;
end
endmodule
