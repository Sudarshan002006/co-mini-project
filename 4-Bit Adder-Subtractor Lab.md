Digital logic mini-project · combinational circuits

# 4-Bit Binary Adder-Subtractor

One circuit, two operations. A mode input **M** drives four XOR gates that pass or invert B, and the same M feeds the first carry-in. M = 0 gives A + B; M = 1 gives A + B′ + 1, which is A − B in two's complement. Toggle any bit and every wire below updates from a gate-level simulation.

4 × XOR4 × full adder (ripple carry)overflow V = C3 ⊕ C4512 test vectors

Column addition inside the circuit

Live schematic

## Gate-level circuit

logic 1logic 0

Click the A, B and M input boxes on the schematic to toggle them. Bit 0 (LSB) is on the right, so carries ripple right to left.

### Signal trace, stage by stage

| Stage | Ai | Bi | M | Bi ⊕ M | Cin | Si | Cout |
| --- | --- | --- | --- | --- | --- | --- | --- |

Verification

## Exhaustive test: every A, B and M combination

16 values of A × 16 values of B × 2 modes = 512 vectors. Each one runs through the gate-level circuit and is compared with a separate arithmetic reference model on S, Cout and V. Click any row to load it into the circuit.

Fault injection

Pick a fault to see the test bench catch a broken circuit. The schematic and the readout use the same faulty circuit.

| # | M | A | B | B ⊕ M | Expected S | Circuit S | Cout | V | Unsigned | Signed | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

Theory

## How one circuit does both

An XOR gate with one input tied to a control line acts as a controlled inverter: B ⊕ 0 = B and B ⊕ 1 = B′. Subtraction in two's complement is A − B = A + B′ + 1. The XOR gates supply B′ and the carry-in C0 = M supplies the +1, so no extra hardware is needed.

Xᵢ = Bᵢ ⊕ M\
Sᵢ = Aᵢ ⊕ Xᵢ ⊕ Cᵢ\
Cᵢ₊₁ = Aᵢ·Xᵢ + Cᵢ·(Aᵢ ⊕ Xᵢ)\
C₀ = M V = C₃ ⊕ C₄

- **M = 0:** X = B, C0 = 0, so S = A + B. Cout = 1 means the unsigned sum exceeded 15.
- **M = 1:** X = B′, C0 = 1, so S = A + B′ + 1 = A − B. Cout = 1 means A ≥ B (no borrow); Cout = 0 means a borrow occurred.
- **Overflow V:** for signed numbers (−8 to +7), V = 1 when the carry into the sign bit differs from the carry out of it, meaning the true answer doesn't fit in 4 bits.

### Worked example: 6 − 3

A = 0110, B = 0011, M = 1\
B ⊕ 1111 = 1100, C0 = 1\
0110 + 1100 + 1 = 1 0011 → S = 0011 (3), Cout = 1, V = 0

Building block

## Full adder truth table

| A | B | Cin | Sum | Cout |
| --- | --- | --- | --- | --- |

### Components for a hardware build

- 2 × 74LS86 (quad 2-input XOR): 4 gates for Bᵢ ⊕ M, 1 for overflow V
- 1 × 74LS83 / 74LS283 (4-bit full adder with fast carry), or 4 discrete full adders built from 74LS86 + 74LS08 + 74LS32
- 9 SPDT switches (A3–A0, B3–B0, M) with pull-down resistors
- 6 LEDs with 330 Ω resistors (S3–S0, Cout, V), 5 V supply, breadboard

HDL implementation

## Verilog source and self-checking testbench

```

```

Run with Icarus Verilog: iverilog -o sim add_sub_4bit.v tb_add_sub.v && vvp sim. The testbench applies the same 512 vectors as the table above and prints PASS when all of them match.