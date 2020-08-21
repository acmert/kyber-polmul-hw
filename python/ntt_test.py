from ntt import *
from helper import *
from random import randint

# File to test Kyber NTT/INTT/Polynomial Multiplication

q = 3329
n = 256
w = 17
wv= 1175

A = [randint(0,q-1) for _ in range(n)]
B = [randint(0,q-1) for _ in range(n)]
C = SchoolbookModPolMul_NWC(A,B,q)

A_ntt = CRT_Iterative_NWC_FD2_NR(A,w,q)
B_ntt = CRT_Iterative_NWC_FD2_NR(B,w,q)

A_rec = ICRT_Iterative_NWC_FD2_RN(A_ntt,wv,q)

C_nwc0 = FullModPolMul(A,B,w,wv,q)
C_nwc1 = HalfModPolMul(A,B_ntt,w,wv,q)

# Sanity Check 1
if sum([abs(x-y) for x,y in zip(A,A_rec)]) == 0:
    print("NTT-INTT conversion works")
else:
    print("NTT-INTT does not conversion works")
    
# Sanity Check 2
if sum([abs(x-y) for x,y in zip(C,C_nwc0)]) == 0:
    print("Full polynomial multiplication works")
else:
    print("Full polynomial multiplication does not works")

# Sanity Check 3
if sum([abs(x-y) for x,y in zip(C,C_nwc1)]) == 0:
    print("Half polynomial multiplication works")
else:
    print("Half polynomial multiplication does not works")
