# V3.15.4 - golden rank-2 example with analytic Sha = 4 (replaces the retracted "570l1").
# Run from the repository root:  sage examples/rank2_sha4_194766c4.sage
# 194766c4 is the main example; 194040co6 (smallest conductor with rank 2 and
# analytic Sha > 1 in the Cremona tables) is the second check.
# Note: the L-series at conductor ~2*10^5 takes noticeably longer than the small examples.
load("bsd_calculator.sage")

CURVES = [
    ("194766c4", [1, 0, 0, -2077504, -1152726172], [[QQ('5488'), QQ('388078')], [QQ('15424'), QQ('1899178')]], 73.0293939449168),
    ("194040co6", [0, 0, 0, -456382227, -3752677112114], [[QQ('255990'), QQ('129052966')], [QQ('618065/16'), QQ('385385049/64')]], 107.048949311989),
]

def report_shape(label, ainvs, gens, reg_ref):
    E = EllipticCurve(QQ, ainvs)
    s = analyze_shape(E, gens=gens, reg_reference=reg_ref)
    print("{0},{1},{2},{3},{4:.12g},{5:.12g},{6:.12g},{7:.12g},{8:.12g},{9:.8f},{10:.3e},{11:.3e},{12},{13}".format(
        label, E.conductor(), "({};{})".format(*s["P"].xy()), "({};{})".format(*s["Q"].xy()),
        float(s["h1"]), float(s["h2"]), float(s["pairing"]), float(s["gram_det"]),
        float(s["sin2theta"]), float(s["theta_deg"]),
        float(s["gram_vs_regulator_relerr"]), float(s["gram_vs_reference_relerr"]),
        s["gauss_reduced"], s["saturation_index"]))
    return E, s

SHAPE_HEADER = "label,N,P_reduced,Q_reduced,h1,h2,pairing,gram_det,sin2theta,theta_deg,relerr_vs_sage_pairing_matrix,relerr_vs_cremona_reg,gauss_reduced,saturation_index"

print(SHAPE_HEADER)
for label, ainvs, gens, reg_ref in CURVES:
    report_shape(label, ainvs, gens, reg_ref)

print()
print(BSD_HEADER)
for label, ainvs, gens, reg_ref in CURVES:
    E = EllipticCurve(QQ, ainvs)
    r = print_bsd_row(E, gens=gens)
    no_sha = r["omega"] * r["regulator"] * r["cprod"] / r["tors"] ** 2
    print("  {0}: torsion = {1}, L''(E,1)/2 / (Omega*Reg*prod c_p/tors^2) = {2:.12g}  (expected 4)".format(
        label, E.torsion_subgroup().invariants(), float(r["leading_value"] / no_sha)))
