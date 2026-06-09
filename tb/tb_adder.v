`timescale 1ns / 1ps
//exhaustive and self checking testbench for 4 bit rca and cla 

module tb_adder;
reg [3:0] a,b;
reg cin;
wire [4:0]rca_out,cla_out;
integer i,j;

rca_4bit r1(.a(a),.b(b),.cin(cin),.sum(rca_out[3:0]),.cout(rca_out[4]));
cla_4bit c1(.a(a),.b(b),.cin(cin),.sum(cla_out[3:0]),.cout(cla_out[4]));

initial begin
$monitor("Time = %0t | a=%b  b=%b  cin=%b | RCA = %b | CLA = %b",$time,a,b,cin,rca_out,cla_out);
for (i=0;i<16;i=i+1) begin
    for(j=0;j<16;j=j+1) begin
            a = i;b=j;cin = 1'b0;
            #2;
            if (rca_out !== cla_out) begin
                 $display("ERROR at time %0t: a=%b b=%b cin=%b | RCA=%b CLA=%b",
                 $time, a, b, cin, rca_out, cla_out);
        end
    end
end
for (i=0;i<16;i=i+1) begin
    for(j=0;j<16;j=j+1) begin
            a = i;b=j;cin = 1'b1;
            #2;
            if (rca_out !== cla_out) begin
                 $display("ERROR at time %0t: a=%b b=%b cin=%b | RCA=%b CLA=%b",
                 $time, a, b, cin, rca_out, cla_out);
        end
    end
end
$finish;
end
endmodule
