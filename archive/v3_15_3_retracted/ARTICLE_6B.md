load("../bsd_calculator.sage")

E = EllipticCurve(QQ, [1, -1, 0, -116, 400]).global_minimal_model()

print("label,N,rank,leading_value,raw_l_derivative,omega,regulator,cprod,tors,sha_proxy,sha_an,nearest_square,square_error,square_ok")
print_bsd_row(E)

print("\nDETAILS")
print("ainvs =", E.ainvs())
print("gens =", E.gens())
print("torsion_points =", E.torsion_points())
print("bad_primes =", E.bad_primes())
