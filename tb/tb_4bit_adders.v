`timescale 1ns / 1ps

module tb_4bit_adders;
reg [3:0] a,b;
reg cin;
wire [3:0] sum_cla,sum_rca;
wire cout_cla,cout_rca;
reg [5:0] expected;
reg [10:0] passed;

cla_4bit cla_unit(.a(a),.b(b),.cin(cin),.sum(sum_cla),.cout(cout_cla),.p(),.g());
rca_4bit rca_unit(.a(a),.b(b),.cin(cin),.sum(sum_rca),.cout(cout_rca));

initial begin
    a=0;b=0;cin=0;
    passed = 0;
    repeat (1000) begin
        a = $urandom%16;
        b= $urandom%16;
        cin = $urandom%2;
        expected = a + b + cin;
        #10;
        if ({cout_cla,sum_cla} != expected || {cout_rca,sum_rca} != expected) begin
            $display ("Test Failed, a=%d, b=%d, cin=%d, sum_cla=%d, sum_rca=%d, expected= %d",a,b,cin,{cout_cla,sum_cla},{cout_rca,sum_rca},expected);
        end
        else begin
            passed = passed + 1;
            $display ("Test Passed=%d, a=%d, b=%d, cin=%d, sum_cla=%d, sum_rca=%d, expected= %d",passed,a,b,cin,{cout_cla,sum_cla},{cout_rca,sum_rca},expected);
        end
    #10;
    end
    $display("=====================TEST OVER====================");
    $display("Total Passed Cases = %d",passed);
    $display("Success = %d percent",passed/10);        
end
endmodule
