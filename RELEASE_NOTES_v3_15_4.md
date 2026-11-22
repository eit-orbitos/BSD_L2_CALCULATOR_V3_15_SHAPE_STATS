# Release Notes — BSD L2 Calculator V3.15.4

**Created by:** Toni Mladenovski
**Type:** correction release candidate — not a BSD proof. Not yet tagged, released or deposited; no V3.15.4 DOI assigned (10.5281/zenodo.23148670 is the previous version's DOI).

## Changes

- Retracted the "570l1" example (`[1,-1,0,-116,400]` has conductor 75242 and analytic Sha 1).
- New main rank-2 Sha = 4 example: `194766c4`; second check `194040co6`.
- `sin²θ` now computed from the height pairing; the Gram determinant is checked against the regulator.
- Bases are Gauss-reduced before measuring the angle; sin²θ ∈ [3/4, 1].
- New 19-curve table: min 0.892950 (446d1), max 0.999706 (1001c1).
- Saturation check of the generators (Sage `E.saturation`, PARI `ellsaturation` up to 100).
- Independent PARI/GP script in `verification/`.
- Repaired layout: calculator in `bsd_calculator.sage`, runnable `examples/`, data in `data/`, valid SHA-256 `MANIFEST.json`.
- V3.15.3 files archived unchanged in `archive/v3_15_3_retracted/`.
- README: explicit 570l1 retraction, basis dependence of the angle (sin²θ ≥ 3/4 only for a Gauss-reduced basis), reported angle labelled as the acute representative, saturation sources separated.
- Added `validation/` with the SageMath run record.

## Checks actually run

| Check | Result |
|---|---|
| Input ZIP SHA-256 and 31 manifest entries | verified |
| SageMath 10.7, all 4 examples from a clean checkout at repo root | exit 0 ×4 |
| Numerical comparison with `data/*.csv` | 241/241 PASS (Sha ≈ 9 ×3, ≈ 1 ×19, ≈ 4 ×2; 655a1 basis-dependence behaviour confirmed) |
| Sage `E.saturation()` | index 1 for all 21 rank-2 curves |
| PARI/GP script | author-reported; not re-run in this validation |

Single host and single SageMath build. Details: `validation/SAGE_VALIDATION_v3_15_4.md`.

Details: `CORRECTIONS_v3_15_4.md`.

## Claim boundary

```text
BSD_PROOF: NO
COMPUTATIONAL_VERIFICATION: YES
SHAPE_STATS: SAMPLE_ONLY, REDUCED_BASIS
```
