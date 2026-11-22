# BSD L2 Calculator V3.15.4

**Created by:** Toni Mladenovski
**Status:** Computational verification package — not a proof of BSD
**Version:** V3.15.4 (published correction release, see `CORRECTIONS_v3_15_4.md`)
**V3.15.4 DOI:** [10.5281/zenodo.24435439](https://doi.org/10.5281/zenodo.24435439). Published November 22, 2026.

The previous V3.15.3 DOI remains [10.5281/zenodo.23148670](https://doi.org/10.5281/zenodo.23148670); do not use it to cite V3.15.4.

**Post-release metadata update:** the DOI was added after publication. The `v3.15.4` tag and the Zenodo archive remain unchanged; this documentation update does not create a new software release.

## Purpose

A SageMath rank-aware calculator for the Birch and Swinnerton-Dyer leading-coefficient formula for elliptic curves over Q, with an independent PARI/GP cross-check.

| Class | Curves | Rank | Torsion | Analytic Sha |
|---|---|---:|---|---:|
| Rank 0, nontrivial Sha | `2849a1`, `4343b1`, `5389a1` | 0 | trivial | 9 |
| Rank 2, trivial Sha | 19 curves, `389a1` … `1001c1` (see `data/`) | 2 | trivial | 1 |
| Rank 2, nontrivial Sha | **`194766c4`** (main), `194040co6` | 2 | Z/2 | 4 |

### Historical correction: "570l1" is retracted

The former golden example "570.l1 / 570l1, `[1,-1,0,-116,400]`" used in V3.10–V3.15.3 is **retracted**: that Weierstrass equation has conductor 75242 (not 570), trivial torsion (not Z/2) and analytic Sha = 1 (not 4); Cremona's `570l1` is a different curve, `[1,0,0,9335,-737383]`, of rank 0; and no curve of conductor 570 has rank 2. The V3.15.3 files containing it are kept unchanged in `archive/v3_15_3_retracted/`. See `CORRECTIONS_v3_15_4.md` (C1).

## BSD leading coefficient

For Mordell–Weil rank r:

```text
L^(r)(E,1)/r! = Omega_E * Reg(E) * |Sha(E)| * prod(c_p) / |E(Q)_tors|^2
```

The calculator computes

```text
Sha_proxy = (L^(r)(E,1)/r! * tors^2) / (Omega_E * Reg(E) * prod(c_p))
```

with Reg = 1 for rank 0.

## Main example: 194766c4 (rank 2, Sha = 4)

```text
label:       194766c4 (Cremona)
ainvs:       [1, 0, 0, -2077504, -1152726172]
conductor:   194766
rank:        2
torsion:     Z/2
generators:  (5488, 388078), (15424, 1899178)   [Cremona, Gauss-reduced]
Reg:         73.0293939449168
sin^2(theta): 0.929324266743   (theta ≈ 74.58°)
L''(E,1)/2:  18.3671502473984
analytic Sha: 4
```

Second check: `194040co6`, `[0,0,0,-456382227,-3752677112114]`, Reg 107.048949311989, analytic Sha 4. In the Cremona tables (conductor < 200000), 194040 is the smallest conductor with rank 2 and analytic Sha > 1.

These examples are computational checks of the BSD normalization (the leading-coefficient formula reproduces a square Sha value), not proofs of the order of Sha.

### Saturation — three distinct sources

| Source | What it shows | Status |
|---|---|---|
| PARI `ellsaturation(E, P, 100)` (`verification/`) | no prime p ≤ 100 divides the index of ⟨P,Q⟩ | author-reported PARI/GP 2.19 output in `data/`; not re-run in the Sage validation |
| Sage `E.saturation([P,Q])` (default `max_prime=-1`, primes up to a Sage-computed bound) | index 1 | executed in the SageMath 10.7 validation for all 21 rank-2 curves (`validation/`); relies on Sage/eclib's implementation, not a formal certificate |
| Cremona ecdata `allgens` | published generators, tabulated as a saturated basis | relied on as the source of the generators |

## Rank-2 angle decomposition

For a basis {P, Q} of the free part, with h1 = ĥ(P), h2 = ĥ(Q) and b = ⟨P, Q⟩:

```text
Reg(E) = det [[h1, b], [b, h2]] = h1*h2 - b^2 = h1*h2*sin^2(theta),   sin^2(theta) = 1 - b^2/(h1*h2)
```

This is the standard Gram determinant, not a new theorem. V3.15.4 computes `sin^2(theta)` **from the pairing b** and compares `h1*h2 - b^2` with Sage's regulator, instead of defining `sin^2(theta) = Reg/(h1*h2)` (which made the check circular in V3.15.3).

**The angle depends on the choice of basis.** Replacing {P, Q} by another basis of the same lattice (a unimodular change of basis) keeps Reg but changes sin²θ. The package therefore Gauss-reduces the basis first (2|b| ≤ min(h1, h2)); for a Gauss-reduced rank-2 basis, **sin²θ ≥ 3/4** (θ ∈ [60°, 90°]). See `examples/basis_dependence_655a1.sage`: a skewed basis of the 655a1 lattice gives sin²θ ≈ 0.000336 with the same determinant 0.0989535198922, and reduction restores sin²θ ≈ 0.998222799921.

**Reported angle = acute representative.** θ and π − θ have the same sin²θ (the sign of ⟨P,Q⟩ depends on the signs of P and Q). All reported angles are θ = arcsin(√sin²θ) ∈ (0°, 90°], i.e. the acute representative.

## V3.15.4 SHAPE statistics (19 rank-2 curves, Sha = 1, reduced basis)

```text
min sin^2(theta) = 0.892949617649 at 446d1   (theta ≈ 70.90°)
max sin^2(theta) = 0.999705991491 at 1001c1  (theta ≈ 89.02°)
```

All 19 regulators agree with the V3.15.3 table. The V3.15.3 extremes (0.0356 at 655a1) came from a non-reduced basis returned by `E.gens()`; with the reduced Cremona basis, 655a1 has sin²θ ≈ 0.998.

## Run

Always from the repository root (the examples use `load("bsd_calculator.sage")`):

```bash
sage examples/rank0_sha9.sage
sage examples/rank2_sha1_shape_stats.sage
sage examples/rank2_sha4_194766c4.sage
sage examples/basis_dependence_655a1.sage
```

Independent cross-check without Sage (PARI/GP via `pip install cypari2`, Cremona data from https://github.com/JohnCremona/ecdata):

```bash
python3 -I verification/verify_bsd_pari_v3_15_4.py allgens.00000-09999 655a1,664a1,389a1 > out.csv
python3 -I verification/verify_bsd_pari_v3_15_4.py allgens.190000-199999 194766c4,194040co6 > gold.csv
```

## Files

| Path | Content |
|---|---|
| `bsd_calculator.sage` | calculator functions |
| `examples/` | runnable SageMath examples |
| `data/shape_stats_reduced_basis_v3_15_4.csv` | 19-curve table, reduced basis, generators, PARI cross-check |
| `data/rank2_sha4_candidates_v3_15_4.csv` | 194766c4 and 194040co6 |
| `verification/verify_bsd_pari_v3_15_4.py` | independent PARI/GP script |
| `validation/` | SageMath 10.7 validation record, raw example output, comparison script |
| `archive/v3_15_3_retracted/` | V3.15.3 files kept unchanged for the record |
| `MANIFEST.json` | SHA-256 of every file except itself (includes the archived historical `MANIFEST.json`) |

## Verification status of V3.15.4

```text
PARI/GP 2.19 cross-check:      reported by the author (all CSV values in data/); not re-run in the Sage validation
SageMath examples:             RUN — SageMath 10.7, clean checkout, repo root, all 4 examples exit 0
                               241/241 numerical checks against data/*.csv PASS
                               (Sha ≈ 9 ×3, ≈ 1 ×19, ≈ 4 ×2; Gram det & reduced sin²θ rel. dev. ≤ 6.3e-11)
                               single host, single Sage build — see validation/SAGE_VALIDATION_v3_15_4.md
```

## Claim boundary

```text
BSD_PROOF: NO
COMPUTATIONAL_VERIFICATION: YES
NORMALIZATION_CONFIRMED_ON_EXAMPLES: YES
RANK_AWARE_CALCULATOR: YES
SHAPE_STATS: SAMPLE_ONLY, REDUCED_BASIS
```

This repository does not prove BSD. Analytic Sha values are numerical evaluations of the BSD quotient, not proofs of the order of Sha.
