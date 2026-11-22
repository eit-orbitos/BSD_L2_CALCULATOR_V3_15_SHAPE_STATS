# V3.15.4 - why sin^2(theta) needs a reduced basis.
# Run from the repository root:  sage examples/basis_dependence_655a1.sage
# The same subgroup, spanned by a skewed basis, has the same regulator
# (Gram determinant) but a much smaller angle factor. Gauss reduction
# restores the intrinsic angle (sin^2(theta) >= 3/4).
load("bsd_calculator.sage")

E = EllipticCurve(QQ, [0, 0, 1, -13, 18])          # 655a1
P, Q = E([1, 2]), E([3, 2])                         # Cremona generators
Qs = Q + 7 * P
Ps = P - 3 * Qs                                     # skewed basis of the same lattice

for name, basis, red in [("cremona", (P, Q), False),
                         ("skewed", (Ps, Qs), False),
                         ("skewed_then_reduced", (Ps, Qs), True)]:
    s = analyze_shape(E, gens=list(basis), reduce_basis=red)
    print("{0}: sin2theta = {1:.12g}, theta = {2:.6f} deg, gram_det = {3:.12g}, gauss_reduced = {4}".format(
        name, float(s["sin2theta"]), float(s["theta_deg"]), float(s["gram_det"]), s["gauss_reduced"]))
