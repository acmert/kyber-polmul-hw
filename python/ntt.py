from helper import *
from math import log

# CRT-based modular polynomial multiplication with f(x)=x^n+1 (Negative Wrapped Convolution)
# -- utilizing CRT instead of NTT (Iterative Version)
# -- it is using w (q = 1 mod n) and final degree of CRT reduction is 2
# A: input polynomial (standard order)
# W: twiddle factor
# q: modulus
# B: output polynomial (bit-reversed order)
# NOTE: 1 iteration less executed version of "CTBasedMergedNTT_NR"
def CRT_Iterative_NWC_FD2_NR(A,w,q):
    N = len(A)
    B = [_ for _ in A]

    k=1
    lena = (N//2)

    v = int(log(lena,2))

    while lena >= 2:
        start = 0
        while start < N:
            W_pow = intReverse(k,v)
            W = pow(w,W_pow,q)
            k = k+1
            j = start
            while(j < (start + lena)):
                t = (W * B[j+lena]) % q

                B[j+lena] = (B[j] - t) % q
                B[j     ] = (B[j] + t) % q

                j = j+1
            start = j + lena
        lena = (lena//2)

    return B

# ICRT-based modular polynomial multiplication with f(x)=x^n+1 (Negative Wrapped Convolution)
# -- utilizing ICRT instead of INTT (Iterative Version)
# -- it is using w (q = 1 mod n) and final degree of CRT reduction is 2
# A: input polynomial (bit-reversed order)
# W: twiddle factor
# q: modulus
# B: output polynomial (standard order)
# NOTE: 1 iteration less executed version of "GSBasedMergedINTT_NR"
def ICRT_Iterative_NWC_FD2_RN(A,w,q):
    N = len(A)
    B = [_ for _ in A]

    k = 0
    lena = 2

    v = int(log(N//2,2))

    while lena <= (N//2):
        start = 0
        while start < N:
            W_pow = intReverse(k,v)+1
            TW = pow(w,W_pow,q)
            """
            W_pow and TW below use "w" instead of "w_inv"
            W_pow = (N//2) - 1 - intReverse(k,v)
            TW = (-pow(w,W_pow,q)) % q # here, "-" means an extra w^(n/2)
            """
            k = k+1
            j = start
            while(j < (start + lena)):
                t = B[j]

                B[j       ] = (t + B[j + lena]) % q
                B[j + lena] = (t - B[j + lena]) % q
                B[j + lena] = B[j + lena]*TW % q

                # Using technique from: https://tches.iacr.org/index.php/TCHES/article/view/8544/8109
                if (B[j]%2 == 0):
                    B[j] = (B[j] >> 1)
                else:
                    B[j] = ((B[j] >> 1) + ((q+1)//2))%q

                if (B[j+lena]%2 == 0):
                    B[j+lena] = (B[j+lena] >> 1)
                else:
                    B[j+lena] = ((B[j+lena] >> 1) + ((q+1)//2))%q

                j = j+1
            start = j + lena
        lena = 2*lena

    # This final multiplication is removed using technique in
    # https://tches.iacr.org/index.php/TCHES/article/view/8544/8109
    # N_inv = modinv(N//2,q)
    # for i in range(N):
    #    B[i] = (B[i] * N_inv) % q

    return B
    
# CRT-based modular polynomial multiplication with f(x)=x^n+1 (Negative Wrapped Convolution)
# -- utilizing CRT instead of NTT
# -- it is using w (q = 1 mod n) and final degree of CRT reduction is 2
# -- it is using Iterative version of reduction function
# A,B: n-1 degree polynomials
# w, w_inv: twiddle factors
# q: coefficient modulus
# C: n-1 degree polynomial
def FullModPolMul(A,B,w,w_inv,q):
    A_ntt = CRT_Iterative_NWC_FD2_NR(A,w,q)
    B_ntt = CRT_Iterative_NWC_FD2_NR(B,w,q)

    C_ntt = [0 for _ in range(len(A))]

    # Degree-2 modular polynomial multiplications
    for i in range(len(A)//2):
        w_pow = 2*intReverse(i,int(log(len(A)//2,2)))+1
        wk    = pow(w,w_pow,q)
        C_ntt[2*i:2*i+2] = PolWiseMult(A_ntt[2*i:2*i+2],B_ntt[2*i:2*i+2],wk,2,q)

    # NOTE: it is using w. (We cen convert it into w_inv by modification)
    C = ICRT_Iterative_NWC_FD2_RN(C_ntt,w_inv,q)

    return C

def HalfModPolMul(A,B_ntt,w,w_inv,q):
    A_ntt = CRT_Iterative_NWC_FD2_NR(A,w,q)

    C_ntt = [0 for _ in range(len(A))]

    # Degree-2 modular polynomial multiplications
    for i in range(len(A)//2):
        w_pow = 2*intReverse(i,int(log(len(A)//2,2)))+1
        wk    = pow(w,w_pow,q)
        C_ntt[2*i:2*i+2] = PolWiseMult(A_ntt[2*i:2*i+2],B_ntt[2*i:2*i+2],wk,2,q)

    # NOTE: it is using w. (We cen convert it into w_inv by modification)
    C = ICRT_Iterative_NWC_FD2_RN(C_ntt,w_inv,q)

    return C

