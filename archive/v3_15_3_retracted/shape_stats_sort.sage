load("../bsd_calculator.sage")

LABELS = ["389a1","2534g1","1001c1","1141a1","2710d1","2674c1","2406c1","2882a1","2215a1","2366e2","2015c1"]
print("label,N,rank,leading_value,raw_l_derivative,omega,regulator,cprod,tors,sha_proxy,sha_an,nearest_square,square_error,square_ok")
for lab in LABELS:
    print_bsd_row(lab)
