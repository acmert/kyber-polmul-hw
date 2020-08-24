from math import log,ceil
from random import randint

from generate_prime import *
from helper import *

# ----------------------------------------------------------

KYBER_PRM_TXT  = open("KYBER_PARAM.txt","w")
# Parameters
# --- n  (ring size)
# --- q  (modulus)
# --- PE (number of PE)
KYBER_DIN0_TXT = open("KYBER_DIN0.txt","w")
KYBER_DIN1_TXT = open("KYBER_DIN1.txt","w")
# Input polynomials
# --- Stored in order: 0, 1, 2, ..., n-1
KYBER_DIN0_MFNTT_TXT = open("KYBER_DIN0_MFNTT.txt","w")
# Output polynomials (after merged FNTT)
# --- Stored in bit-reversed order
KYBER_DOUT_MINTT_TXT = open("KYBER_DOUT_MINTT.txt","w")
# Input polynomial (after coefficient-wise multiplication)
KYBER_DOUT_TXT = open("KYBER_DOUT.txt","w")
# Output polynomial
# --- Stored in order: 0, 1, 2, ..., n-1
KYBER_W_TXT    = open("KYBER_W.txt","w")
# Twiddle factors
# --- Stored as shown in FNTT/INTT_tw_N_PE.txt
KYBER_WP_TXT   = open("KYBER_WP.txt","w")
# Twiddle factors
# --- For degree-2 polynomial multiplications after NTT operations
KYBER_WINV_TXT = open("KYBER_WINV.txt","w")
# Inverse Twiddle factors
# --- Stored as shown in FNTT/INTT_tw_N_PE.txt

# ----------------------------------------------------------

# Parallelism
PE_NUMBER = 1
PE = 2*PE_NUMBER

# ----------------------------------------------------------

n = 256
q = 3329
w = 17
wv= 1175
nv= 3303 # 128^-1 mod 3329

# Print parameters
print("Parameters for KYBER")
print("n          : {}".format(n))
print("q          : {}".format(q))
print("w          : {}".format(w))
print("w_inv      : {}".format(wv))
print("n_div2_inv : {}".format(nv))
print("")

# ----------------------------------------------------------

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

    KYBER_DIN0_MFNTT_TXT_DEBUG = open("KYBER_DIN0_MFNTT_DEBUG.txt","w")

    k=1
    lena = (N//2)

    v = int(log(lena,2))
    m = N//PE

    BRAM = []
    BRTW = []

    for i in range(PE):
        BRAM.append([])
        for j in range(v):
            BRAM[i].append([])
            for kk in range(m):
                BRAM[i][j].append([])

    for i in range(PE//2):
        BRTW.append([])
        for j in range(v):
            BRTW[i].append([])
            for kk in range(m):
                BRTW[i][j].append([])

    bram_counter = 0

    while lena >= 2:
        KYBER_DIN0_MFNTT_TXT_DEBUG.write("********************** STAGE START **********************\n")

        start = 0
        while start < N:
            W_pow = intReverse(k,v)
            W = pow(w,W_pow,q)
            k = k+1
            j = start
            while(j < (start + lena)):
                t = (W * B[j+lena]) % q

                bt1,bt2 = B[j],B[j+lena]

                B[j+lena] = (B[j] - t) % q
                B[j     ] = (B[j] + t) % q

                print("W: "+str(W_pow).ljust(5)+" A0: "+str(j).ljust(5)+" A1: "+str(j+lena).ljust(5))

                KYBER_DIN0_MFNTT_TXT_DEBUG.write("(A["+str(j).ljust(4)+"]: "+str((hex(bt1)[2:]).rstrip("L")).ljust(12)+" A["+str(j+lena).ljust(4)+"]: "+str((hex(bt2)[2:]).rstrip("L")).ljust(12)+" W["+str(W_pow).ljust(4)+"]: "+str((hex(W)[2:]).rstrip("L")).ljust(12)+") -> ("+str((hex(B[j])[2:]).rstrip("L")).ljust(12)+" "+str((hex(B[j+lena])[2:]).rstrip("L")).ljust(12)+")"+"\n")

                BRAM[(2*(bram_counter >> 0) & (PE-1))+0][bram_counter // (N//2)][(bram_counter & ((N//2)-1)) // (PE//2)] = j
                BRAM[(2*(bram_counter >> 0) & (PE-1))+1][bram_counter // (N//2)][(bram_counter & ((N//2)-1)) // (PE//2)] = j+lena

                BRTW[bram_counter & ((PE//2)-1)][bram_counter // (N//2)][(bram_counter & ((N//2)-1)) // (PE//2)] = W_pow

                bram_counter = bram_counter + 1

                j = j+1
            start = j + lena
        lena = (lena//2)

    return B,BRAM,BRTW

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

    KYBER_DOUT_MINTT_TXT_DEBUG = open("KYBER_DOUT_MINTT_DEBUG.txt","w")

    k = 0
    lena = 2

    v = int(log(N//2,2))
    m = N//PE

    BRAM = []
    BRTW = []

    for i in range(PE):
        BRAM.append([])
        for j in range(v):
            BRAM[i].append([])
            for kk in range(m):
                BRAM[i][j].append([])

    for i in range(PE//2):
        BRTW.append([])
        for j in range(v):
            BRTW[i].append([])
            for kk in range(m):
                BRTW[i][j].append([])

    bram_counter = 0

    while lena <= (N//2):
        KYBER_DOUT_MINTT_TXT_DEBUG.write("********************** STAGE START **********************\n")

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

                bt1,bt2 = B[j],B[j+lena]

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

                print("W: "+str(W_pow).ljust(5)+" A0: "+str(j).ljust(5)+" A1: "+str(j+lena).ljust(5))

                KYBER_DOUT_MINTT_TXT_DEBUG.write("(A["+str(j).ljust(4)+"]: "+str((hex(bt1)[2:]).rstrip("L")).ljust(12)+" A["+str(j+lena).ljust(4)+"]: "+str((hex(bt2)[2:]).rstrip("L")).ljust(12)+" W["+str(W_pow).ljust(4)+"]: "+str((hex(TW)[2:]).rstrip("L")).ljust(12)+") -> ("+str((hex(B[j])[2:]).rstrip("L")).ljust(12)+" "+str((hex(B[j+lena])[2:]).rstrip("L")).ljust(12)+")"+"\n")

                BRAM[(2*(bram_counter >> 0) & (PE-1))+0][bram_counter // (N//2)][(bram_counter & ((N//2)-1)) // (PE//2)] = j
                BRAM[(2*(bram_counter >> 0) & (PE-1))+1][bram_counter // (N//2)][(bram_counter & ((N//2)-1)) // (PE//2)] = j+lena

                BRTW[bram_counter & ((PE//2)-1)][bram_counter // (N//2)][(bram_counter & ((N//2)-1)) // (PE//2)] = W_pow

                bram_counter = bram_counter + 1

                j = j+1
            start = j + lena
        lena = 2*lena

    # This final multiplication is removed using technique in
    # https://tches.iacr.org/index.php/TCHES/article/view/8544/8109
    # N_inv = modinv(N//2,q)
    # for i in range(N):
    #    B[i] = (B[i] * N_inv) % q

    return B,BRAM,BRTW

def HalfModPolMul(A,B_ntt,w,w_inv,q):
    # print("---- NTT(A)")
    A_ntt,ABR,ATW = CRT_Iterative_NWC_FD2_NR(A,w,q)

    for an,bn in zip(A_ntt,B_ntt):
        KYBER_DIN0_MFNTT_TXT.write(hex(an).replace("L","")[2:]+"\n")

    C_ntt = [0 for _ in range(256)]

    print("---- Coefficient-wise multiplication:")
    KYBER_DOUT_COEFMUL_TXT_DEBUG = open("KYBER_DOUT_COEFMUL_DEBUG.txt","w")
    # Degree-2 modular polynomial multiplications
    for i in range(128):
        w_pow = 2*intReverse(i,7)+1
        print("W: "+str(w_pow).ljust(5)+" A: {}".format(range(2*i,2*i+2)))

        wk    = pow(w,w_pow,q)
        C_ntt[2*i:2*i+2] = PolWiseMult(A_ntt[2*i:2*i+2],B_ntt[2*i:2*i+2],wk,2,q)

        KYBER_WP_TXT.write(hex(wk).replace("L","")[2:]+"\n")
        KYBER_DOUT_COEFMUL_TXT_DEBUG.write("(A["+str(2*i)+":"+str(2*i+2-1)+"]="+str(A_ntt[2*i:2*i+2])+", ".ljust(5)+ \
                                            "B["+str(2*i)+":"+str(2*i+2-1)+"]="+str(B_ntt[2*i:2*i+2])+", ".ljust(5)+ \
                                            "W:"+str(wk)+") --> ".ljust(5) + \
                                            "C["+str(2*i)+":"+str(2*i+2-1)+"]="+str(C_ntt[2*i:2*i+2])+"\n")

    for cn in C_ntt:
        KYBER_DOUT_MINTT_TXT.write(hex(cn).replace("L","")[2:]+"\n")

    # NOTE: it is using w. (We cen convert it into w_inv by modification)
    print("---- INTT(C)")
    C,CBR,CTW = ICRT_Iterative_NWC_FD2_RN(C_ntt,w_inv,q)

    return C,ABR,ATW,CBR,CTW

# ----------------------------------------------------------

# Demo
A = [randint(0,q-1) for _ in range(n)]
B = [randint(0,q-1) for _ in range(n)]
C = SchoolbookModPolMul_NWC(A,B,q)

print("\n-------- Addressing for NTT --------")
A_ntt,ABR,ATW = CRT_Iterative_NWC_FD2_NR(A,w,q)
print("\n-------- Addressing for NTT --------")
B_ntt,BBR,BTW = CRT_Iterative_NWC_FD2_NR(B,w,q)

print("\n-------- Addressing for INTT --------")
A_rec,NBR,NTW = ICRT_Iterative_NWC_FD2_RN(A_ntt,wv,q)

print("\n-------- Addressing for Half Pol Mul --------")
C_nwc1,N0BR,N0TW,N1BR,N1TW = HalfModPolMul(A,B_ntt,w,wv,q)

# Sanity Check 1
if sum([abs(x-y) for x,y in zip(A,A_rec)]) == 0:
    print("NTT-INTT conversion works")
else:
    print("NTT-INTT conversion does not works")

# Sanity Check 2
if sum([abs(x-y) for x,y in zip(C,C_nwc1)]) == 0:
    print("Half polynomial multiplication works")
else:
    print("Half polynomial multiplication does not works")

# Print memory structure
def PrintBRAM(BRAM,ring=0,findeg=1):
    if ring == 0:
        v = int(math.log(n//findeg, 2))
        m = n//PE
    else:
        v = int(math.log((3*n)//findeg, 2))-1
        m = (3*n)//PE
    BS = ""
    for j in range(v):
        BS = BS+"*************************************************** stage="+str(j)+"\n"
        BS = BS+"BRAM:"

        for i in range(PE//2):
            BS = BS+"\t|"+str(2*i).ljust(5)+str(2*i+1).ljust(4)+"|"
        BS = BS+"\n"
        BS = BS+"     "
        for i in range(PE//2):
            BS = BS+"\t----------"
        BS = BS+"\n"

        for k in range(m):
            BS = BS + "AD"+str(k)+":"
            for i in range(PE//2):
                BS = BS+"\t|"+str(BRAM[2*i][j][k]).ljust(5)+str(BRAM[2*i+1][j][k]).ljust(4)+"|"
            BS = BS+"\n"

    return BS

def PrintBRTW(BRTW,ring=0,findeg=1):
    if ring == 0:
        v = int(math.log(n//findeg, 2))
        m = n//PE
    else:
        v = int(math.log((3*n)//findeg, 2))-1
        m = (3*n)//PE
    TS = ""
    for j in range(v):
        TS = TS+"*************************************************** stage="+str(j)+"\n"
        TS = TS+"TWID:"

        for i in range(PE//2):
            TS = TS+"\t|"+str(i).ljust(5)+"|"
        TS = TS+"\n"
        TS = TS+"     "
        for i in range(PE//2):
            TS = TS+"\t------"
        TS = TS+"\n"

        for k in range(m):
            TS = TS + "AD"+str(k)+":"
            for i in range(PE//2):
                TS = TS+"\t|"+str(BRTW[i][j][k]).ljust(5)+"|"
            TS = TS+"\n"

    return TS

# Write to txt
print("")
print("-------- Generated:")

KYBERF_BR  = PrintBRAM(N0BR,0,2)
KYBERI_BR  = PrintBRAM(N1BR,0,2)
KYBERF_TW  = PrintBRTW(N0TW,0,2)
KYBERI_TW  = PrintBRTW(N1TW,0,2)

# Data
KYBER_BR_TXT = open("KYBER_mem_N"+str(n)+"_PE"+str(PE_NUMBER)+".txt","w")
KYBER_BR_TXT.write("---------------------------------------------------------------------- Forward NTT (x2)\n")
KYBER_BR_TXT.write(KYBERF_BR)
KYBER_BR_TXT.write("---------------------------------------------------------------------- Degree-2 polynomial-wise multiplication\n")
KYBER_BR_TXT.write("---------------------------------------------------------------------- Inverse NTT\n")
KYBER_BR_TXT.write(KYBERI_BR)
KYBER_BR_TXT.close()
# Twiddle
KYBER_TW_TXT = open("KYBER_tw_N"+str(n)+"_PE"+str(PE_NUMBER)+".txt","w")
KYBER_TW_TXT.write("---------------------------------------------------------------------- Forward NTT (x2)\n")
KYBER_TW_TXT.write(KYBERF_TW)
KYBER_TW_TXT.write("---------------------------------------------------------------------- Degree-2 polynomial-wise multiplication\n")
KYBER_TW_TXT.write("---------------------------------------------------------------------- Inverse NTT\n")
KYBER_TW_TXT.write(KYBERI_TW)
KYBER_TW_TXT.close()

print("* KYBER_mem_N"+str(n)+"_PE"+str(PE_NUMBER)+".txt")
print("* KYBER_tw_N"+str(n)+"_PE"+str(PE_NUMBER)+".txt")

# Generate test vectors
# Parameters
KYBER_PRM_TXT.write(hex(n          ).replace("L","")[2:]+"\n")
KYBER_PRM_TXT.write(hex(q          ).replace("L","")[2:]+"\n")
KYBER_PRM_TXT.write(hex(PE_NUMBER  ).replace("L","")[2:]+"\n")
# Input/Output
for mi0,mi1,mo0 in zip(A,B_ntt,C_nwc1):
    KYBER_DIN0_TXT.write(hex(mi0).replace("L","")[2:]+"\n")
    KYBER_DIN1_TXT.write(hex(mi1).replace("L","")[2:]+"\n")
    KYBER_DOUT_TXT.write(hex(mo0).replace("L","")[2:]+"\n")
# Twiddle factor
v = int(math.log(n//2, 2))
m = n//PE
for j in range(v):
    for k in range(0,m,max(1,m>>j)):
        for i in range(PE//2):
            KYBER_W_TXT.write(hex(pow(w,N0TW[i][j][k],q)).replace("L","")[2:]+"\t  ")
        KYBER_W_TXT.write("\n")
v = int(math.log(n//2, 2))
m = n//PE
for j in range(v):
    for k in range(0,m,max(1,m>>(v-j-1))):
        for i in range(PE//2):
            KYBER_WINV_TXT.write(hex(pow(wv,N1TW[i][j][k],q)).replace("L","")[2:]+"\t  ")
        KYBER_WINV_TXT.write("\n")
KYBER_DIN0_TXT.close()
KYBER_DIN1_TXT.close()
KYBER_DOUT_TXT.close()
#
