# V3.15.4 - rank-0 curves with analytic Sha = 9.
# Run from the repository root:  sage examples/rank0_sha9.sage
load("bsd_calculator.sage")

CURVES = [
    ("2849a1", [1, 1, 1, -53484, -4843180]),
    ("4343b1", [0, 0, 1, -325259, -71398995]),
    ("5389a1", [1, 0, 1, -35590, -2587197]),
]

print(BSD_HEADER)
for label, ainvs in CURVES:
    print_bsd_row(EllipticCurve(QQ, ainvs), gens=[])
