// 4-bit adder-subtractor using XOR gates and full adders
// M = 0 : S = A + B
// M = 1 : S = A - B  (A + ~B + 1, two's complement)

module full_adder (
  input  a, b, cin,
  output sum, cout
);
  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (cin & (a ^ b));
endmodule

module add_sub_4bit (
  input  [3:0] A,
  input  [3:0] B,
  input        M,      // mode control: 0 = add, 1 = subtract
  output [3:0] S,
  output       Cout,   // carry out (add) / NOT borrow (subtract)
  output       V       // signed overflow
);
  wire [3:0] Bx;       // B after the XOR gates
  wire [4:0] C;        // ripple carry chain

  assign Bx   = B ^ {4{M}};   // four XOR gates: Bx[i] = B[i] ^ M
  assign C[0] = M;            // +1 for two's complement when subtracting

  full_adder FA0 (.a(A[0]), .b(Bx[0]), .cin(C[0]), .sum(S[0]), .cout(C[1]));
  full_adder FA1 (.a(A[1]), .b(Bx[1]), .cin(C[1]), .sum(S[1]), .cout(C[2]));
  full_adder FA2 (.a(A[2]), .b(Bx[2]), .cin(C[2]), .sum(S[2]), .cout(C[3]));
  full_adder FA3 (.a(A[3]), .b(Bx[3]), .cin(C[3]), .sum(S[3]), .cout(C[4]));

  assign Cout = C[4];
  assign V    = C[3] ^ C[4];
endmodule
