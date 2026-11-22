# Release Notes — BSD L2 Calculator V3.15 SHAPE Stats

**Created by:** Mr. Toni Mladenovski  
**Status:** Computational verification package update — not a BSD proof

## New in V3.15

Added Mordell-Weil orthogonality statistics for 19 rank-2 curves with Sha=1.

## Main result

```text
min sin²θ = 0.0356392702428 at 655a1
max sin²θ = 0.971116536959 at 709a1
```

## Interpretation

The regulator is not generally equal to h1h2. The correct rank-2 SHAPE decomposition is:

```text
Reg(E) = h1*h2*sin²θ
```

and therefore:

```text
L''(E,1)/2 = Omega_E * h1*h2 * sin²θ * |Sha(E)| * product(c_p) / tors²
```

## Claim boundary

```text
BSD_PROOF: NO
COMPUTATIONAL_VERIFICATION: YES
SHAPE_STATS: SAMPLE_ONLY
```
