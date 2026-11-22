# V3.11 Sha Compensation Sieve

**Created by:** Mr. Toni Mladenovski  
**Status:** PASS

## Curve

```text
570.l1 / 570l1
ainvs: [1, -1, 0, -116, 400]
conductor: 570
rank: 2
torsion_order: 2
analytic_sha: 4
```

## Result

```text
Lpp / exact_no_sha = 4
Lpp / exact_with_sha = 1
Reg/h1h2 = 0.9308746792
```

## Conclusion

Full BSD product works. SHAPE predictor alone misses the Sha factor and the angle/regulator correction sin^2(theta).
