`timescale 1ns/1ps
// Exhaustive self-checking testbench: 16 x 16 x 2 = 512 vectors

module tb_add_sub;
  reg  [3:0] A, B;
  reg        M;
  wire [3:0] S;
  wire       Cout, V;

  integer a, b, m;
  integer sa, sb, sr;
  integer errors;
  reg [4:0] exp_u;
  reg [3:0] exp_s;
  reg       exp_c, exp_v;

  add_sub_4bit dut (.A(A), .B(B), .M(M), .S(S), .Cout(Cout), .V(V));

  initial begin
    errors = 0;
    $display(" M    A     B  |   S   Cout V");
    for (m = 0; m < 2; m = m + 1)
      for (a = 0; a < 16; a = a + 1)
        for (b = 0; b < 16; b = b + 1) begin
          A = a; B = b; M = m;
          #5;

          sa = (a > 7) ? a - 16 : a;      // signed value of A
          sb = (b > 7) ? b - 16 : b;      // signed value of B

          if (m == 0) begin
            exp_u = a + b;
            exp_c = exp_u[4];
            sr    = sa + sb;
          end else begin
            exp_u = a - b;
            exp_c = (a >= b);             // 1 = no borrow
            sr    = sa - sb;
          end
          exp_s = exp_u[3:0];
          exp_v = (sr > 7) || (sr < -8);

          $display(" %0d  %b  %b  |  %b   %b    %b", M, A, B, S, Cout, V);

          if (S !== exp_s || Cout !== exp_c || V !== exp_v) begin
            errors = errors + 1;
            $display("   FAIL: expected S=%b Cout=%b V=%b", exp_s, exp_c, exp_v);
          end
        end

    if (errors == 0) $display("PASS: all 512 combinations verified");
    else             $display("FAILED: %0d mismatches", errors);
    $finish;
  end
endmodule
