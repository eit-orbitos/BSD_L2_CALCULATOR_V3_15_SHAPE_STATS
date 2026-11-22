load("../bsd_calculator.sage")

LABELS = ["2849a1", "4343b1", "5389a1"]
print("label,N,rank,leading_value,raw_l_derivative,omega,regulator,cprod,tors,sha_proxy,sha_an,nearest_square,square_error,square_ok")
for lab in LABELS:
    print_bsd_row(lab)
