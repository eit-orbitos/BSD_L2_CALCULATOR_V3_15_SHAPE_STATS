# V3.15.4 - SHAPE statistics for 19 rank-2 curves with analytic Sha = 1.
# Run from the repository root:  sage examples/rank2_sha1_shape_stats.sage
# Generators: Cremona ecdata allgens (already Gauss-reduced and saturated there).
# Reference regulators: Cremona / data/shape_stats_reduced_basis_v3_15_4.csv.
load("bsd_calculator.sage")

CURVES = [
    ("655a1", [0, 0, 1, -13, 18], [[QQ('1'), QQ('2')], [QQ('3'), QQ('2')]], 0.0989535198921938),
    ("664a1", [0, 0, 0, -7, 10], [[QQ('1'), QQ('2')], [QQ('3'), QQ('4')]], 0.0966760504530515),
    ("944e1", [0, 0, 0, -19, 34], [[QQ('1'), QQ('4')], [QQ('3'), QQ('2')]], 0.117860680313585),
    ("1001c1", [0, 0, 1, -199, 1092], [[QQ('20'), QQ('71')], [QQ('-13'), QQ('38')]], 0.0360107457561596),
    ("707a1", [0, 1, 1, -12, 12], [[QQ('3'), QQ('3')], [QQ('1'), QQ('1')]], 0.112857456320488),
    ("997c1", [0, -1, 1, -24, 54], [[QQ('3'), QQ('0')], [QQ('1'), QQ('5')]], 0.249705466521919),
    ("446d1", [1, -1, 0, -4, 4], [[QQ('2'), QQ('0')], [QQ('1'), QQ('0')]], 0.0973430975694571),
    ("571b1", [0, 1, 1, -4, 2], [[QQ('1'), QQ('0')], [QQ('0'), QQ('1')]], 0.177253140262005),
    ("794a1", [1, 0, 1, -3, 2], [[QQ('1'), QQ('0')], [QQ('-1'), QQ('2')]], 0.149049991080623),
    ("916c1", [0, 0, 0, -4, 1], [[QQ('0'), QQ('1')], [QQ('2'), QQ('1')]], 0.136468199155202),
    ("718b1", [1, 0, 1, -5, 0], [[QQ('-1'), QQ('2')], [QQ('3'), QQ('2')]], 0.169858359469645),
    ("389a1", [0, 1, 1, -2, 0], [[QQ('0'), QQ('0')], [QQ('1'), QQ('0')]], 0.152460177943144),
    ("563a1", [1, 1, 1, -15, 16], [[QQ('2'), QQ('-2')], [QQ('4'), QQ('4')]], 0.219229003517995),
    ("643a1", [1, 0, 0, -4, 3], [[QQ('1'), QQ('0')], [QQ('2'), QQ('1')]], 0.229179621568847),
    ("681c1", [0, -1, 1, 0, 2], [[QQ('0'), QQ('1')], [QQ('3'), QQ('4')]], 0.136079688950694),
    ("817a1", [0, 1, 1, 1, 6], [[QQ('4'), QQ('9')], [QQ('-3/4'), QQ('15/8')]], 0.256256382257684),
    ("433a1", [1, 0, 0, 0, 1], [[QQ('0'), QQ('1')], [QQ('-1'), QQ('1')]], 0.224694163418167),
    ("997b1", [0, -1, 1, -5, -3], [[QQ('-1'), QQ('0')], [QQ('-3/4'), QQ('-3/8')]], 0.571019259287367),
    ("709a1", [0, -1, 1, -2, 0], [[QQ('0'), QQ('0')], [QQ('-1'), QQ('0')]], 0.258683172736407),
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
    print_bsd_row(EllipticCurve(QQ, ainvs), gens=gens)
