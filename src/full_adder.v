`timescale 1ns / 1ps
//a single bit full adder (adds 2 bits a and b, with a carry from behind)

module full_adder(input a,
                  input b,
                  input cin,
                  output s,
                  output cout
);

assign s = a^b^cin;
assign cout = (a&b)|(b&cin)|(cin&a);

endmodule
