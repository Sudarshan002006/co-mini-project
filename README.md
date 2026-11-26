# 4-Bit Binary Adder-Subtractor

A combinational circuit that performs **addition and subtraction** of two 4-bit binary numbers using a **mode control input (M)**, built from **XOR gates** and **full adders**, and verified for every possible input combination.

| M | Operation | How it works |
|---|-----------|--------------|
| 0 | S = A + B | XOR gates pass B unchanged, carry-in C0 = 0 |
| 1 | S = A − B | XOR gates invert B (B′), carry-in C0 = 1, so S = A + B′ + 1 (two's complement) |

## Live simulator

Open `index.html` in any browser (or visit the GitHub Pages link below). It includes:

- A gate-level schematic: toggle A, B and M and every wire and LED updates
- A column-addition readout with unsigned and signed (two's complement) results
- A stage-by-stage signal trace table
- Exhaustive verification of all 512 input combinations (16 × 16 × 2) against an arithmetic reference model
- Fault injection, to show the tests catch a broken circuit

## Circuit equations

```
Xi   = Bi ⊕ M                  (XOR gate, controlled inverter)
Si   = Ai ⊕ Xi ⊕ Ci            (full adder sum)
Ci+1 = Ai·Xi + Ci·(Ai ⊕ Xi)    (full adder carry)
C0   = M
Cout = C4                      (add: carry out, subtract: 1 = no borrow)
V    = C3 ⊕ C4                 (signed overflow)
```

### Example: 6 − 3

```
A = 0110, B = 0011, M = 1
B ⊕ 1111 = 1100, C0 = 1
0110 + 1100 + 1 = 1 0011  →  S = 0011 (3), Cout = 1, V = 0
```

## Verilog

The `verilog/` folder contains:

- `add_sub_4bit.v`: full adder module and the 4-bit adder-subtractor
- `tb_add_sub.v`: self-checking testbench that applies all 512 combinations

Run with Icarus Verilog:

```bash
cd verilog
iverilog -o sim add_sub_4bit.v tb_add_sub.v
vvp sim
```

Expected last line: `PASS: all 512 combinations verified`

## Hardware components (breadboard build)

- 2 × 74LS86 quad 2-input XOR (4 gates for Bi ⊕ M, 1 for overflow V)
- 1 × 74LS83 / 74LS283 4-bit full adder (or 4 discrete full adders from 74LS86 + 74LS08 + 74LS32)
- 9 switches (A3–A0, B3–B0, M) with pull-down resistors
- 6 LEDs with 330 Ω resistors (S3–S0, Cout, V)
- 5 V supply, breadboard, jumper wires

## Project structure

```
.
├── index.html            Interactive simulator and verification
├── README.md
└── verilog/
    ├── add_sub_4bit.v    Design
    └── tb_add_sub.v      Testbench
```
