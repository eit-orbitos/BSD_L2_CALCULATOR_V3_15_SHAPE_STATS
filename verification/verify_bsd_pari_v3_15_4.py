#!/usr/bin/env python3
"""BSD L2 Calculator V3.15.4 - independent PARI/GP cross-check.

Usage: python3 -I verify_bsd_pari_v3_15_4.py ALLGENS_FILE LABEL[,LABEL...] > out.csv

ALLGENS_FILE: a Cremona ecdata allgens file (github.com/JohnCremona/ecdata/allgens).
For each curve it writes one CSV row:
  - free generators exactly as listed by Cremona (projective [x:y:z] -> affine x/z, y/z),
  - on_curve check for every generator,
  - Gram matrix of the canonical height pairing (ellheightmatrix),
  - Reg = det(Gram), angle factor 1 - b^2/(h1*h2) in the Cremona basis,
  - Gauss/LLL-reduced basis (qflllgram) and its angle factor (>= 3/4 for a reduced rank-2 basis),
  - saturation check (ellsaturation up to bound SAT_BOUND): index 1 = no prime p <= bound divides the index,
  - L^(r)(E,1)/r! from ellanalyticrank, and Sha_an = (L^(r)/r!) / (ellbsd(E) * Reg).

Notes:
  * PARI's ellanalyticrank returns L^(r)(E,1) WITHOUT division by r!; we divide here.
  * PARI's ellbsd(E) = Omega * prod(c_p) / |T|^2 for the given model.
  * Height normalization: PARI ellheight == Sage P.height() (both match Cremona regulators).
  * PARI status messages go to stderr, so stdout stays clean CSV.
"""
import sys, re, math, cypari2

SAT_BOUND = 100

pari = cypari2.Pari()
pari.allocatemem(2 * 10**9, silent=True)  # "silent" keeps the stack-size message off stdout
pari.set_real_precision(40)

gens_file, labels = sys.argv[1], sys.argv[2].split(",")
db = {}
for line in open(gens_file):
    t = line.split()
    db[t[0] + t[1] + t[2]] = t

HEADER = ["label", "ainvs", "rank", "torsion_structure", "gen1", "gen2", "gens_on_curve",
          "h1", "h2", "b12", "Reg", "sin2_cremona_basis", "reduced_gen1", "reduced_gen2",
          "h1_red", "h2_red", "b12_red", "sin2_reduced", "theta_reduced_deg",
          "gauss_reduced_ok", "saturation_index_upto_%d" % SAT_BOUND,
          "lead_Lr_over_rfact", "bsd_const_Omega_cp_over_T2", "sha_an"]
print(",".join(HEADER))

def fmt(v):
    if isinstance(v, float):
        return "%.15g" % v
    return '"%s"' % v if ("," in str(v)) else str(v)

def pt(P):
    return "(%s;%s)" % (P[0], P[1])

for lab in labels:
    t = db[lab]
    ainvs, rank, tors = t[3], int(t[4]), t[5]
    pts = re.findall(r"\[(-?\d+):(-?\d+):(\d+)\]", " ".join(t[6:]))[:rank]
    E = pari.ellinit(ainvs)
    P = [pari("[%s/%s,%s/%s]" % (x, z, y, z)) for x, y, z in pts]
    on = all(int(pari.ellisoncurve(E, Q)) for Q in P)
    row = {"label": lab, "ainvs": ainvs.replace(",", " "), "rank": rank,
           "torsion_structure": tors, "gens_on_curve": on}
    reg = pari(1)
    if rank >= 1:
        G = pari.ellheightmatrix(E, P)
        reg = pari.matdet(G)
        row["Reg"] = float(reg)
        row["gen1"] = pt(P[0])
        row["h1"] = float(G[0, 0])
        sat = pari.ellsaturation(E, P, SAT_BOUND)
        row["saturation_index_upto_%d" % SAT_BOUND] = int(round(float((reg / pari.matdet(pari.ellheightmatrix(E, sat))).sqrt())))
    if rank == 2:
        h1, h2, b = float(G[0, 0]), float(G[1, 1]), float(G[0, 1])
        U = pari.qflllgram(G)
        R = U.mattranspose() * G * U
        a, c, d = float(R[0, 0]), float(R[1, 1]), float(R[0, 1])
        Pr = [pari.elladd(E, pari.ellmul(E, P[0], U[0, j]), pari.ellmul(E, P[1], U[1, j])) for j in range(2)]
        s2r = 1 - d * d / (a * c)
        row.update(gen2=pt(P[1]), h2=h2, b12=b, sin2_cremona_basis=1 - b * b / (h1 * h2),
                   reduced_gen1=pt(Pr[0]), reduced_gen2=pt(Pr[1]), h1_red=a, h2_red=c, b12_red=d,
                   sin2_reduced=s2r, theta_reduced_deg=math.degrees(math.asin(math.sqrt(s2r))),
                   gauss_reduced_ok=(2 * abs(d) <= min(a, c) + 1e-12))
    r, Lr = pari.ellanalyticrank(E)
    lead = Lr / pari.factorial(int(r))
    c = pari.ellbsd(E)
    row.update(lead_Lr_over_rfact=float(lead), bsd_const_Omega_cp_over_T2=float(c),
               sha_an=float(lead / (c * reg)))
    print(",".join(fmt(row.get(k, "")) for k in HEADER))
    sys.stdout.flush()
