 # BSD L2 Calculator V3.15.3

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23148220.svg)](https://doi.org/10.5281/zenodo.23148670)

**Created by:** Toni Mladenovski
**Status:** Computational verification package — not a proof of BSD
**Version:** V3.15.3
**Zenodo DOI:** https://doi.org/10.5281/zenodo.23148220


## Purpose

This repository provides a SageMath rank-aware calculator for the Birch and Swinnerton-Dyer leading coefficient formula for elliptic curves over Q.

It verifies the BSD leading-coefficient normalization on three important classes:

| Class | Example | Rank | Torsion | Sha |
|---|---:|---:|---:|---:|
| Rank-0 nontrivial Sha | `2849a1`, `4343b1`, `5389a1` | 0 | varies | 9 |
| Rank-2 trivial Sha | `389a1` and sample curves | 2 | varies | 1 |
| Rank-2 nontrivial Sha | `570.l1 / 570l1` | 2 | 2 | 4 |

## Standard BSD leading coefficient formula

For Mordell-Weil rank r:

```text
L^(r)(E,1)/r! = Omega_E * Reg(E) * |Sha(E)| * product(c_p) / tors^2
```

The calculator computes:

```text
Sha_proxy = (L^(r)(E,1)/r! * tors^2) / (Omega_E * Reg(E) * product(c_p))
```

For rank 0, Reg=1.

## Golden example: rank-2 Sha=4

```text
label: 570.l1 / 570l1
ainvs: [1, -1, 0, -116, 400]
conductor: 570
rank: 2
torsion_order: 2
analytic_sha: 4
generators: (4,4), (8,-12)
torsion point: (12,-6)
Tamagawa product: 4
bad primes: [2, 3, 5, 19]
```

Verified BSD compensation:

```text
Lpp / exact_no_sha = 4
Lpp / exact_with_sha = 1
```

Meaning:

```text
Without Sha, the rank-2 BSD product misses by factor 4.
With Sha=4, the product closes exactly.
```

## SHAPE branch closure

For rank 2, the regulator is:

```text
Reg(E) = h1*h2*sin^2(theta)
```

For `570.l1`:

```text
Reg / h1h2 = 0.9308746792 = sin^2(theta)
```

Thus the full rank-2 formula can be written as:

```text
L''(E,1)/2 = Omega_E * h1*h2 * sin^2(theta) * |Sha(E)| * product(c_p) / tors^2
```

This is not a new theorem; it is the standard regulator determinant expressed through two-generator height geometry.

## Correct claim boundary

```text
BSD_PROOF: NO
COMPUTATIONAL_VERIFICATION: YES
NORMALIZATION_CONFIRMED_ON_EXAMPLES: YES
RANK_AWARE_CALCULATOR: YES
```

This repository does not prove BSD. It provides computational verification and examples using SageMath/Cremona/LMFDB data.

## Run examples

```bash
sage examples/rank0_sha9.sage
sage examples/rank2_sha1.sage
sage examples/rank2_sha4_570l1.sage
sage examples/shape_compensation_570l1.sage
```


## V3.15 SHAPE Statistics Addendum

V3.15 adds a sorted Mordell-Weil orthogonality table for 19 rank-2 Sha=1 curves.

```text
min sin²θ = 0.0356392702428 at 655a1
max sin²θ = 0.971116536959 at 709a1
```

This confirms that the angle factor is essential:

```text
Reg(E) = h1*h2*sin²θ
```

and the clean rank-2 decomposition is:

```text
L''(E,1)/2 = Omega_E * h1*h2 * sin²θ * |Sha(E)| * product(c_p) / tors²
```
