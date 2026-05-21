# V3.15 SHAPE Statistics — Mordell-Weil Orthogonality

**Created by:** Mr. Toni Mladenovski  
**Document ID:** BSD_L2_V3_15_SHAPE_STATS  
**Status:** PASS  
**Scope:** 19 rank-2 elliptic curves with analytic Sha approximately 1

## Purpose

V3.15 sorts rank-2 curves by the angle factor in the Mordell-Weil height lattice.

For rank 2, the regulator can be decomposed as:

```text
Reg(E) = h1*h2*sin^2(theta)
```

where `h1` and `h2` are canonical heights of two independent generators, and `theta` is the canonical height-pairing angle.

## Main result

The sample shows wide variation:

```text
min sin²θ = 0.0356392702428 at 655a1
max sin²θ = 0.971116536959 at 709a1
```

This proves computationally, for the sample, that:

```text
Reg is not generally close to h1h2.
The angle factor sin²θ is essential.
```

## Parallel extreme

```text
Curve: 655a1
N = 655
sin²θ = 0.0356392702428
theta = 10.88180849°
h1h2 = 2.77653047377
Reg = 0.0989535198922
```

The generators are nearly parallel in the height pairing, so the product `h1h2` greatly overestimates the regulator.

## Orthogonal extreme

```text
Curve: 709a1
N = 709
sin²θ = 0.971116536959
theta = 80.21500926°
h1h2 = 0.266377064844
Reg = 0.258683172736
```

The generators are nearly orthogonal, so `h1h2` is close to the true regulator.

## Correct rank-2 formula

The clean rank-2 BSD + SHAPE decomposition is:

```text
L''(E,1)/2 = Omega_E * h1*h2 * sin²θ * |Sha(E)| * product(c_p) / tors²
```

This is not a new theorem; it is the standard BSD formula with the regulator written as a Gram determinant / angle factor.

## Important correction

The previously mixed `570l1_SH4` row with `N=75242` is rejected from this stats table. The real golden curve is:

```text
570.l1 / 570l1
ainvs = [1, -1, 0, -116, 400]
N = 570
rank = 2
torsion = 2
Sha = 4
```

## Claim boundary

```text
BSD_PROOF: NO
COMPUTATIONAL_VERIFICATION: YES
SHAPE_STATS: SAMPLE_ONLY
```
