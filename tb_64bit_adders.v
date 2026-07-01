`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2026 03:22:03
// Design Name: 
// Module Name: tb_64bit_adders
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


module tb_64bit_adders;
reg [63:0] a,b;
reg cin;
wire cout_rca,cout_cla;
wire [63:0] sum_rca,sum_cla;
reg[64:0] expected;
reg [10:0] passed;

cla_64bit cla_unit(.A(a),.B(b),.Cin(cin),.Cout(cout_cla),.S(sum_cla));
rca_64bit rca_unit(.A(a),.B(b),.Cin(cin),.Cout(cout_rca),.Sum(sum_rca));

initial begin
    passed = 0;
    a =0; b = 0; cin =0;
    repeat (1000) begin
        a = {$urandom,$urandom}; //random is 32 bit signed number, and urandom is 32 bit unsignes
        b = {$urandom,$urandom};
        cin = $urandom%2;
        expected = a + b + cin;
        #25;
        if ({cout_cla,sum_cla}==expected && {cout_rca,sum_rca}==expected) begin
            passed = passed + 1;
            $display ("Test Passed , Total Pass = %d",passed);
        end
        else begin
            $display ("Test Failed, a=%d, b=%d, cin=%d, cout_cla=%d, sum_cla=%d, cout_rca=%d, sum_rca=%d, expected=%d",
                        a,b,cin,cout_cla,sum_cla,cout_rca,sum_rca,expected);     
        end
        #30; 
   end
   $display ("==============TEST COMPLETE=============");
   $display ("Total Passed Cases = %d",passed);
   $display ("Success Rate = %d",passed/10);
   $finish;
   end
endmodule
