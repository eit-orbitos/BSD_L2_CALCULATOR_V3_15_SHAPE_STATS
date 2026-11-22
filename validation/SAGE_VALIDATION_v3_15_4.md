# SageMath Validation Record — BSD L2 Calculator V3.15.4

**Package:** BSD_L2_CALCULATOR_V3_15_SHAPE_STATS, V3.15.4 (candidate, unreleased)
**Validated tree:** candidate input `BSD_L2_CALCULATOR_V3_15_4.zip` (SHA-256 `f29ed7a70af17d0aff224f6a54d4566156d05ead3398ae771e5cb8b7c5bfd711`), applied unchanged on branch `v3.15.4` on top of `main` = `664c512e730956be72339d667460422793e327e9`
**Run by:** Tasklet (AI agent), on behalf of Toni Mladenovski, 2026-11-22
**Status:** computational check of BSD normalization on the listed examples — not a proof of BSD, not an independent human review

## Environment

```text
SageMath:      10.7 (Release Date 2025-08-09), conda-forge package sagelib 10.7 (py311hcfc6d0b_3)
Python:        3.11.18
PARI (in Sage): 2.17.4   cypari2 2.2.2   eclib 20250627
Installer:     micromamba 2.10.0, channel conda-forge (core sagelib only, not the full `sage` metapackage)
Host:          x86_64, Intel Xeon Platinum 8559C, Debian 13.7 sandbox, single host
Cremona DB:    NOT installed (database_cremona_mini_ellcurve absent). The examples build curves from
               a-invariants, so this does not affect any number; it only means the `label` column of the
               BSD rows prints the a-invariants instead of the Cremona label.
```

## Procedure

1. Fresh `git clone` of branch `v3.15.4` (candidate content, commit with unchanged input files) into an empty directory; `git status` clean.
2. From the repository root, each example run once:

```bash
sage examples/rank0_sha9.sage
sage examples/rank2_sha1_shape_stats.sage
sage examples/rank2_sha4_194766c4.sage
sage examples/basis_dependence_655a1.sage
```

3. stdout+stderr captured to `validation/sage_output/<example>.out`.
4. Numerical comparison against `data/*.csv` with `python3 validation/check_sage_outputs_v3_15_4.py`.

No example failed, so no rerun was needed. The files under `bsd_calculator.sage`, `examples/` and `data/` were not modified after this run (later commits change documentation, `CITATION.cff`, `validation/` and `MANIFEST.json` only).

## Exit codes

| Example | Exit code | Wall time (s) |
|---|---:|---:|
| `examples/rank0_sha9.sage` | 0 | 2 |
| `examples/rank2_sha1_shape_stats.sage` | 0 | 3 |
| `examples/rank2_sha4_194766c4.sage` | 0 | 2 |
| `examples/basis_dependence_655a1.sage` | 0 | 1 |

## Acceptance criteria and tolerances

| Check | Criterion |
|---|---|
| Analytic Sha | `sha_proxy` nearest square = 9 (3 rank-0 curves), 1 (19 rank-2 curves), 4 (194766c4, 194040co6); relative distance to that square < 1e-4 (`nearest_square` tolerance in `bsd_calculator.sage`) |
| Reference agreement | h1, h2, ⟨P,Q⟩, Gram determinant, sin²θ, θ and L^(r)(E,1)/r! agree with `data/*.csv` to relative error < 1e-9 (Sage prints 12 significant digits) |
| Gram determinant | h1·h2 − ⟨P,Q⟩² agrees with det(E.height_pairing_matrix(gens)) and with the tabulated Cremona regulator to relative error < 1e-12 |
| Reduced basis | `gauss_reduced = True`, 3/4 ≤ sin²θ ≤ 1, 0 < θ ≤ 90° (acute representative) |
| Saturation | Sage `E.saturation()` index = 1 |
| 655a1 | skewed basis: same Gram determinant (rel. < 1e-9), sin²θ < 3/4 and `gauss_reduced = False`; after reduction sin²θ equals the Cremona-basis value (rel. < 1e-9) |

## Result of the comparison script

```text
rank0: 3 curves, sha_proxy nearest square 9, max rel err 1.974e-15
rank2_sha1_shape_stats.out: 19 curves, sha nearest square 1, max rel dev vs CSV 6.32e-11, sin2 range [0.892949617649, 0.999705991491]
rank2_sha4_194766c4.out: 2 curves, sha nearest square 4, max rel dev vs CSV 5.56e-11, sin2 range [0.929324266743, 0.959876006415]
655a1: det cremona/skewed/reduced = 0.0989535198922/0.0989535198922/0.0989535198922; sin2 = 0.998222799921/0.000336278254903/0.998222799921
CHECKS 241/241 PASS
```

## Saturation — what was and was not checked

| Check | Status in this validation |
|---|---|
| Sage `E.saturation([P,Q])`, default `max_prime=-1` (saturates at every prime up to a bound computed by Sage) | **RUN** — index 1 for all 21 rank-2 curves. Relies on Sage/eclib's implementation and height bounds; not a formally certified proof. |
| PARI `ellsaturation(E, P, 100)` in `verification/verify_bsd_pari_v3_15_4.py` | **NOT RE-RUN here.** Values in `data/` are the author's reported PARI/GP 2.19 output (`saturation_index_upto_100 = 1`), i.e. no prime p ≤ 100 divides the index. |
| Published Cremona generators (ecdata `allgens`) as a saturated basis | **RELIED ON** as the source of the generators; not re-derived. |

## Raw output

### `sage examples/rank0_sha9.sage`

```text
label,N,rank,leading_value,raw_l_derivative,omega,regulator,cprod,tors,sha_proxy,nearest_square,square_error,square_ok
[1, 1, 1, -53484, -4843180],2849,0,1.41148663484,1.41148663484,0.156831848316,1,4,2,9,9.0,1.974e-15,True
[0, 0, 1, -325259, -71398995],4343,0,3.59844384016,3.59844384016,0.199913546675,1,2,1,9,9.0,7.895e-16,True
[1, 0, 1, -35590, -2587197],5389,0,1.5641612883,1.5641612883,0.347591397399,1,2,2,9,9.0,1.382e-15,True
```

### `sage examples/rank2_sha1_shape_stats.sage`

```text
label,N,P_reduced,Q_reduced,h1,h2,pairing,gram_det,sin2theta,theta_deg,relerr_vs_sage_pairing_matrix,relerr_vs_cremona_reg,gauss_reduced,saturation_index
655a1,655,(1;2),(3;2),0.106438087887,0.931336659263,-0.013273028989,0.0989535198922,0.998222799921,87.58387435,1.100e-16,4.436e-16,True,1
664a1,664,(1;2),(3;4),0.157072863509,0.629916087441,-0.0476095911709,0.0966760504531,0.977091057448,81.29442491,3.128e-18,1.157e-17,True,1
944e1,944,(1;4),(3;2),0.274914182439,0.438289734873,0.0512970157079,0.117860680314,0.978161351626,81.50175873,3.928e-17,1.624e-16,True,1
1001c1,1001,(20;71),(-13;38),0.0675165128609,0.533518909807,0.0032543170368,0.0360107457562,0.999705991491,89.01751967,9.411e-17,2.034e-16,True,1
707a1,707,(3;3),(1;1),0.152273889929,0.770246205727,-0.0665652283733,0.11285745632,0.962221923402,78.79232036,1.580e-17,4.218e-15,True,1
997c1,997,(3;0),(1;5),0.199678403911,1.25650895449,-0.0345287707545,0.249705466522,0.995248119063,86.04724441,1.096e-16,2.010e-16,True,1
446d1,446,(2;0),(1;0),0.270241658916,0.403390724613,0.108027223613,0.0973430975695,0.892949617649,70.90196159,4.848e-17,3.745e-16,True,1
571b1,571,(1;0),(0;1),0.2895173665,0.61317176618,0.0164540175905,0.177253140262,0.998474939244,87.76191460,5.897e-17,3.467e-16,True,1
794a1,794,(1;0),(-1;2),0.27121516018,0.566216994104,-0.0672059645555,0.149049991081,0.970588391561,80.12506510,1.974e-17,9.437e-16,True,1
916c1,916,(0;1),(2;1),0.272741202034,0.521262919749,-0.0755094441312,0.136468199155,0.959895328454,78.44774828,3.006e-17,1.376e-15,True,1
718b1,718,(-1;2),(3;2),0.264622542422,0.670608307277,0.08717634869,0.16985835947,0.957174584698,78.05673446,7.175e-17,2.778e-16,True,1
389a1,389,(0;0),(1;0),0.327000773652,0.476711659344,0.0585226748449,0.152460177943,0.978029305692,81.47591476,1.573e-16,1.600e-15,True,1
563a1,563,(2;-2),(4;4),0.169462490112,1.30536726254,0.0445172247844,0.219229003518,0.991041199523,84.56877037,4.904e-17,2.137e-15,True,1
643a1,643,(1;0),(2;1),0.296130237666,0.782097357704,-0.0492245350043,0.229179621569,0.989537880633,84.12926249,2.578e-17,3.258e-16,True,1
681c1,681,(0;1),(3;4),0.188873861431,0.729150137722,-0.0404686684212,0.136079688951,0.988108161357,83.73946174,3.808e-17,1.873e-15,True,1
817a1,817,(4;9),(-3/4;15/8),0.26763956254,0.972878797108,-0.0642220632246,0.256256382258,0.984159843878,82.76971148,7.976e-17,9.074e-16,True,1
433a1,433,(0;1),(-1;1),0.463307138146,0.541484699372,-0.161800998136,0.224694163418,0.895646453808,71.15325020,1.592e-16,1.133e-15,True,1
997b1,997,(-1;0),(-3/4;-3/8),0.345586368992,1.69970996734,-0.1279739687,0.571019259287,0.972118774985,80.38791455,7.100e-17,9.361e-18,True,1
709a1,709,(0;0),(-1;0),0.422747701497,0.630108842462,-0.0877148340217,0.258683172736,0.971116536959,80.21500926,3.468e-17,1.223e-15,True,1

label,N,rank,leading_value,raw_l_derivative,omega,regulator,cprod,tors,sha_proxy,nearest_square,square_error,square_ok
[0, 0, 1, -13, 18],655,2,0.888192110828,1.77638422166,4.48792580494,0.0989535198922,2,1,1,1.0,1.998e-15,True
[0, 0, 0, -7, 10],664,2,1.37420267614,2.74840535227,3.55362747468,0.0966760504531,4,1,1,1.0,0.000e+00,True
[0, 0, 0, -19, 34],944,2,1.62161758289,3.24323516577,3.43969163119,0.117860680314,4,1,1,1.0,4.441e-16,True
[0, 0, 1, -199, 1092],1001,2,0.98602644955,1.9720528991,2.28178753509,0.0360107457562,12,1,1,1.0,2.220e-16,True
[0, 1, 1, -12, 12],707,2,0.973851346027,1.94770269205,4.31451929619,0.11285745632,2,1,1,1.0,2.331e-15,True
[0, -1, 1, -24, 54],997,2,1.2202850721,2.4405701442,4.88689770831,0.249705466522,1,1,1,1.0,2.220e-16,True
[1, -1, 0, -4, 4],446,2,0.94028260469,1.88056520938,4.82973435286,0.0973430975695,2,1,1,1.0,9.992e-16,True
[0, 1, 1, -4, 2],571,2,0.903160516972,1.80632103394,5.09531461974,0.177253140262,1,1,1,1.0,6.661e-16,True
[1, 0, 1, -3, 2],794,2,1.29454191213,2.58908382426,4.34264337336,0.149049991081,2,1,1,1.0,2.442e-15,True
[0, 0, 0, -4, 1],916,2,1.59754815056,3.19509630112,3.90212557565,0.136468199155,3,1,1,1.0,2.220e-16,True
[1, 0, 1, -5, 0],718,2,1.25178115277,2.50356230554,3.6847793558,0.16985835947,2,1,1,1.0,1.776e-15,True
[0, 1, 1, -2, 0],389,2,0.759316500288,1.51863300058,4.98042512171,0.152460177943,1,1,1,1.0,1.998e-15,True
[1, 1, 1, -15, 16],563,2,1.134555917,2.26911183401,5.17520902252,0.219229003518,1,1,1,1.0,1.110e-15,True
[1, 0, 0, -4, 3],643,2,1.14826173655,2.2965234731,5.01031343314,0.229179621569,1,1,1,1.0,1.554e-15,True
[0, -1, 1, 0, 2],681,2,1.02627114739,2.05254229479,3.77084616855,0.136079688951,2,1,1,1.0,1.776e-15,True
[0, 1, 1, 1, 6],817,2,1.56647038942,3.13294077885,3.056451464,0.256256382258,2,1,1,1.0,2.220e-16,True
[1, 0, 0, 0, 1],433,2,0.947020780866,1.89404156173,4.214710193,0.224694163418,1,1,1,1.0,2.220e-16,True
[0, -1, 1, -5, -3],997,2,1.80057372833,3.60114745665,3.1532626948,0.571019259287,1,1,1,1.0,4.441e-16,True
[0, -1, 1, -2, 0],709,2,1.05370165381,2.10740330762,4.07332894004,0.258683172736,1,1,1,1.0,1.554e-15,True
```

### `sage examples/rank2_sha4_194766c4.sage`

```text
label,N,P_reduced,Q_reduced,h1,h2,pairing,gram_det,sin2theta,theta_deg,relerr_vs_sage_pairing_matrix,relerr_vs_cremona_reg,gauss_reduced,saturation_index
194766c4,194766,(5488;388078),(15424;1899178),8.40494045106,9.34965913815,-2.356678669,73.0293939449,0.929324266743,74.58258864,1.242e-16,1.392e-16,True,1
194040co6,194040,(255990;129052966),(618065/16;385385049/64),10.5540403133,10.5669225522,2.11536693998,107.048949312,0.959876006415,78.44492740,1.039e-16,2.706e-15,True,1

label,N,rank,leading_value,raw_l_derivative,omega,regulator,cprod,tors,sha_proxy,nearest_square,square_error,square_ok
[1, 0, 0, -2077504, -1152726172],194766,2,18.3671502474,36.7343004948,0.125751764154,73.0293939449,2,2,4,4.0,8.882e-16,True
  194766c4: torsion = (2,), L''(E,1)/2 / (Omega*Reg*prod c_p/tors^2) = 4  (expected 4)
[0, 0, 0, -456382227, -3752677112114],194040,2,13.9865233347,27.9730466695,0.0326638501,107.048949312,4,2,4,4.0,6.661e-16,True
  194040co6: torsion = (2,), L''(E,1)/2 / (Omega*Reg*prod c_p/tors^2) = 4  (expected 4)
```

### `sage examples/basis_dependence_655a1.sage`

```text
cremona: sin2theta = 0.998222799921, theta = 87.583874 deg, gram_det = 0.0989535198922, gauss_reduced = True
skewed: sin2theta = 0.000336278254903, theta = 1.050743 deg, gram_det = 0.0989535198922, gauss_reduced = False
skewed_then_reduced: sin2theta = 0.998222799921, theta = 87.583874 deg, gram_det = 0.0989535198922, gauss_reduced = True
```

## Limits

- One host, one SageMath build; no cross-platform or cross-version reproduction.
- Analytic Sha values are numerical evaluations of the BSD quotient, not proofs of the order of Sha.
- Rank is taken as the number of supplied independent generators (the examples pass `gens`); analytic rank was not separately certified here.
- The PARI/GP script was not executed in this validation.
