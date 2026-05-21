load("../bsd_calculator.sage")

E = EllipticCurve(QQ, [1, -1, 0, -116, 400]).global_minimal_model()

omega = omega_bsd(E)
Lpp = raw_l_derivative(E, 2)
lead = leading_l_value(E, 2)
Reg = RR(E.regulator())
cprod = RR(E.tamagawa_product())
tors = RR(E.torsion_order())
sha = RR(E.sha().an())

exact_no_sha = RR(2) * omega * Reg * cprod / RR(tors**2)
exact_with_sha = exact_no_sha * sha

shape = analyze_shape(E)
h1h2 = shape["h1h2"]
sin2theta = shape["sin2theta"]

shape_no_sha = RR(2) * omega * h1h2 * cprod / RR(tors**2)
shape_with_sha = shape_no_sha * sha

print("N =", E.conductor())
print("rank =", E.rank())
print("sha =", sha)
print("Lpp =", Lpp)
print("Lpp_over_2 =", lead)
print("exact_no_sha =", exact_no_sha)
print("exact_with_sha =", exact_with_sha)
print("Lpp / exact_no_sha =", Lpp / exact_no_sha)
print("Lpp / exact_with_sha =", Lpp / exact_with_sha)
print("h1h2 =", h1h2)
print("Reg =", Reg)
print("Reg / h1h2 =", Reg / h1h2)
print("sin2theta =", sin2theta)
print("shape_no_sha =", shape_no_sha)
print("shape_with_sha =", shape_with_sha)
print("Lpp / shape_no_sha =", Lpp / shape_no_sha)
print("Lpp / shape_with_sha =", Lpp / shape_with_sha)
