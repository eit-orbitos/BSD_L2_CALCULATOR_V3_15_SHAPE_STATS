# Corrections in V3.15.4

**Package:** BSD_L2_CALCULATOR_V3_15_SHAPE_STATS
**Created by:** Toni Mladenovski
**Base:** V3.15.3, GitHub `main` commit `664c512`

## C1 — Retracted golden example "570.l1 / 570l1"

The V3.10–V3.15.3 example used `ainvs = [1, -1, 0, -116, 400]` labelled `570l1`, rank 2, torsion 2, Sha 4.

Independent check (PARI/GP 2.19, Cremona ecdata):

```text
[1,-1,0,-116,400]:  conductor 75242, torsion trivial, analytic rank 2
                     generators (0,20), (3,7); Reg = 1.14214402092650
                     analytic Sha = 1 (given that these two points span the free part)
points (4,4), (8,-12), (12,-6): NOT on this curve (checked by exact substitution)
Cremona 570l1:      [1,0,0,9335,-737383], rank 0
conductor 570:      no curve of rank 2 in the Cremona tables
```

The V3.15 note that rejected an "N=75242" row was rejecting this same equation. The rows in `shape_stats_v315.csv` and `shape_compensation_570l1_v311.csv` (N=570, tors 2, Sha 4) cannot belong to one curve and are retracted.

**Replacement:** `194766c4` (main) and `194040co6`, rank 2, torsion Z/2, analytic Sha 4.

## C2 — sin²θ was defined circularly

V3.15.3: `sin2theta = Reg / (h1*h2)`. Multiplying back by h1*h2 returns Reg by definition, so the "SHAPE closure" checked nothing.
V3.15.4: `sin2theta = 1 - <P,Q>^2/(h1*h2)` from the height pairing; `h1*h2 - <P,Q>^2` is compared with Sage's regulator / pairing matrix and with the Cremona value.

## C3 — The angle statistics depended on the chosen basis

`E.gens()` returned non-reduced bases for 17 of the 19 curves. Regulators were right (all 19 agree to the printed digits), but sin²θ is not basis-invariant. After Gauss reduction (2|b| ≤ min(h1,h2)), sin²θ ≥ 3/4 always.

```text
V3.15.3 (unreduced):  min 0.0356392702428 at 655a1, max 0.971116536959 at 709a1
V3.15.4 (reduced):    min 0.892949617649  at 446d1, max 0.999705991491 at 1001c1
unchanged rows:       433a1, 709a1
```

The V3.15.3 conclusion "655a1 has nearly parallel generators" is withdrawn: it was a property of the basis, not of the curve.

## C4 — Package layout

- `bsd_calculator.sage` contained the 570l1 example; the calculator code was in `MANIFEST.json`.
- `examples/` did not exist; several `.sage` files contained Markdown or a different example; the 19-curve table was in `TASKLOG_BSD_L2_CALCULATOR_V3_12.md`.
- Examples used `load("../bsd_calculator.sage")`, which fails when run from the root as documented.
- `E.sha().an()` was used for rank 2; depending on the Sage version it is not available there, so V3.15.4 uses only its own Sha proxy.

All files are now in their documented places; `MANIFEST.json` is valid JSON with SHA-256 hashes. The V3.15.3 files are kept unchanged in `archive/v3_15_3_retracted/`.

## Still open

- ~~Run all four SageMath examples and record their output.~~ Done: SageMath 10.7, all four exit 0, 241/241 checks against `data/` pass — see `validation/SAGE_VALIDATION_v3_15_4.md` (single host, single build).
- Saturation: PARI checks only p ≤ 100 (author-reported); Sage `E.saturation()` (primes up to a Sage-computed bound) returned index 1 in the validation run but is not a formal certificate; the generators themselves come from the Cremona tables.
- The PARI/GP script has not been re-run independently of the author.
