# bsd_calculator.sage
# BSD_L2_CALCULATOR V3.15.4
# Created by: Toni Mladenovski
# BSD_PROOF = NO
# COMPUTATIONAL_VERIFICATION = YES
#
# Usage (always from the repository root):
#   sage examples/<example>.sage
# Each example starts with load("bsd_calculator.sage"); Sage resolves the
# path relative to the current working directory.
#
# V3.15.4 changes against V3.15.3:
#   * sin^2(theta) is computed from the height pairing <P,Q>, NOT as Reg/(h1*h2).
#     The determinant h1*h2 - <P,Q>^2 is then compared with E.regulator()
#     as an independent check.
#   * The basis is Gauss-reduced first (2*|<P,Q>| <= min(h1,h2)). For a reduced
#     rank-2 basis, sin^2(theta) >= 3/4. Without reduction the angle depends on
#     the chosen generators and is not an invariant of the curve.
#   * Generators can be passed explicitly (e.g. from the Cremona tables), and
#     their saturation is checked with E.saturation().
#   * Omega is taken from E.period_lattice().omega() (real period times the
#     number of real components) on the global minimal model.

from sage.all import *
import math

RR = RealField(80)


def omega_bsd(E):
    E = E.global_minimal_model()
    return RR(E.period_lattice().omega())


def nearest_square(x, tol=1e-4):
    xf = float(x)
    if xf <= 0 or math.isnan(xf) or math.isinf(xf):
        return None, None, False
    n = round(math.sqrt(xf))
    sq = n * n
    err = abs(xf - sq) / max(1.0, abs(xf))
    return sq, err, err < tol


def raw_l_derivative(E, rank):
    """L^(r)(E,1) without division by r!."""
    L = E.lseries().dokchitser()
    if rank == 0:
        return RR(L(1))
    return RR(L.derivative(1, rank))


def leading_l_value(E, rank):
    """L^(r)(E,1)/r!  (the BSD leading coefficient)."""
    return raw_l_derivative(E, rank) / RR(factorial(rank))


def height_pairing(P, Q):
    """<P,Q> = (h(P+Q) - h(P) - h(Q)) / 2, with Sage's canonical height."""
    return (RR((P + Q).height()) - RR(P.height()) - RR(Q.height())) / RR(2)


def gauss_reduce(P, Q, max_steps=1000):
    """Gauss (Lagrange) reduction of a rank-2 basis {P, Q} in the height lattice.

    Returns (P', Q') spanning the same subgroup with
    h(P') <= h(Q') and 2*|<P',Q'>| <= h(P').
    """
    for _ in range(max_steps):
        if RR(P.height()) > RR(Q.height()):
            P, Q = Q, P
        hP = RR(P.height())
        m = (height_pairing(P, Q) / hP).round()
        if m == 0:
            return P, Q
        Q = Q - ZZ(m) * P
    raise RuntimeError("gauss_reduce did not converge")


def analyze_shape(E, gens=None, reduce_basis=True, reg_reference=None):
    """Angle data of a rank-2 Mordell-Weil basis.

    gens: optional list of two independent points on the global minimal model
          (e.g. Cremona generators). If None, E.gens() is used.
    reg_reference: optional tabulated regulator (e.g. from Cremona allbsd).
    The Gram determinant from height_pairing() is compared with:
      * E.regulator()                         if gens is None,
      * det(E.height_pairing_matrix(gens))    if gens are given
        (Sage's own pairing routine, independent of height_pairing() here),
      * reg_reference                         if supplied.
    """
    E = E.global_minimal_model()
    gens_given = gens is not None
    if gens is None:
        if E.rank() != 2:
            raise ValueError("analyze_shape expects rank 2.")
        gens = E.gens()
    gens = [E(list(P)) for P in gens]
    if len(gens) != 2:
        raise ValueError("Need exactly two independent generators.")
    P0, Q0 = gens
    sat_pts, sat_index, sat_reg = E.saturation([P0, Q0])
    P, Q = gauss_reduce(P0, Q0) if reduce_basis else (P0, Q0)
    h1 = RR(P.height())
    h2 = RR(Q.height())
    b = height_pairing(P, Q)
    hprod = h1 * h2
    gram_det = hprod - b * b
    sin2theta = RR(1) - b * b / hprod          # from the pairing, not from Reg
    if gens_given:
        reg_sage = RR(E.height_pairing_matrix([P0, Q0]).det())
    else:
        reg_sage = RR(E.regulator())
    theta_deg = RR(math.degrees(math.asin(math.sqrt(float(sin2theta)))))
    return {
        "P": P, "Q": Q, "input_gens": (P0, Q0),
        "h1": h1, "h2": h2, "pairing": b, "h1h2": hprod,
        "sin2theta": sin2theta, "theta_deg": theta_deg,
        "gram_det": gram_det, "regulator_sage": reg_sage,
        "gram_vs_regulator_relerr": abs(gram_det - reg_sage) / reg_sage,
        "gauss_reduced": bool(2 * abs(b) <= min(h1, h2) * (1 + RR(1e-12))),
        "saturation_index": ZZ(sat_index),
        "reg_reference": None if reg_reference is None else RR(reg_reference),
        "gram_vs_reference_relerr": None if reg_reference is None
            else abs(gram_det - RR(reg_reference)) / RR(reg_reference),
    }


def bsd_sha_proxy(label_or_curve, gens=None):
    """Sha_proxy = (L^(r)(E,1)/r! * tors^2) / (Omega * Reg * prod c_p).

    For rank 2, Reg is the Gram determinant of the given (or Sage's) generators;
    if they are not saturated, Sha_proxy is divided by index^2.
    """
    if isinstance(label_or_curve, str):
        E = EllipticCurve(label_or_curve).global_minimal_model()
        label = label_or_curve
    else:
        E = label_or_curve.global_minimal_model()
        try:
            label = E.cremona_label()
        except Exception:
            label = str(list(E.ainvs()))

    rank = ZZ(E.rank()) if gens is None else ZZ(len(gens))
    if rank not in [0, 1, 2]:
        raise ValueError("This calculator supports rank 0, 1, and 2 only.")

    lead = leading_l_value(E, rank)
    omega = omega_bsd(E)
    if rank == 0:
        reg = RR(1)
    elif gens is None:
        reg = RR(E.regulator())
    else:
        pts = [E(list(P)) for P in gens]
        reg = RR(E.height_pairing_matrix(pts).det())
    cprod = RR(E.tamagawa_product())
    tors = RR(E.torsion_order())
    sha_proxy = lead * tors ** 2 / (omega * reg * cprod)
    sq, sq_err, sq_ok = nearest_square(sha_proxy)
    return {
        "label": label,
        "conductor": ZZ(E.conductor()),
        "rank": int(rank),
        "leading_value": lead,
        "raw_l_derivative": lead * RR(factorial(rank)),
        "omega": omega,
        "regulator": reg,
        "cprod": int(cprod),
        "tors": int(tors),
        "sha_proxy": sha_proxy,
        "nearest_square": sq,
        "square_error": sq_err,
        "square_ok": sq_ok,
    }


BSD_HEADER = ("label,N,rank,leading_value,raw_l_derivative,omega,regulator,"
              "cprod,tors,sha_proxy,nearest_square,square_error,square_ok")


def print_bsd_row(label_or_curve, gens=None):
    r = bsd_sha_proxy(label_or_curve, gens)
    print("{label},{N},{rank},{lead:.12g},{raw:.12g},{omega:.12g},{reg:.12g},{cprod},{tors},{sha:.12g},{sq},{err:.3e},{ok}".format(
        label=r["label"], N=r["conductor"], rank=r["rank"],
        lead=float(r["leading_value"]), raw=float(r["raw_l_derivative"]),
        omega=float(r["omega"]), reg=float(r["regulator"]),
        cprod=r["cprod"], tors=r["tors"], sha=float(r["sha_proxy"]),
        sq=r["nearest_square"], err=r["square_error"], ok=r["square_ok"]))
    return r
