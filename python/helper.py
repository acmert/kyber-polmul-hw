
def modinv(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
        raise Exception('Modular inverse does not exist')
    else:
        return x % m

# Bit-Reverse integer
def intReverse(a,n):
    b = ('{:0'+str(n)+'b}').format(a)
    return int(b[::-1],2)

# Bit-Reversed index
def indexReverse(a,r):
    n = len(a)
    b = [0]*n
    for i in range(n):
        rev_idx = intReverse(i,r)
        b[rev_idx] = a[i]
    return b

# Check if input is m-th (could be n or 2n) primitive root of unity of q
def isrootofunity(w,m,q):
    if pow(w,m,q) != 1:
        return False
    elif pow(w,m//2,q) != (q-1):
        return False
    else:
        v = w
        for i in range(1,m):
            if v == 1:
                return False
            else:
                v = (v*w) % q
        return True
        
def egcd(a, b):
    if a == 0:
        return (b, 0, 1)
    else:
        g, y, x = egcd(b % a, a)
        return (g, x - (b // a) * y, y)
        
# ---------------------------------------------------------------------------------------
        
# Multiplies two "deg" degree polynomial in x^"deg"-w^k where k is some power
# A,B: input polynomials
# wk: w^k
# deg: degree
# q: coefficient modulus
# C: output polynomial
def PolWiseMult(A,B,wk,deg,q):
    C = [0] * ((2 * deg)-1)
    # D = [0] * ((2 * deg)-1)

    if deg == 1:
        # if final degree is 1
        D = [(x*y)%q for x,y in zip(A,B)]
        return D[0:deg]
    else:
        # if final degree is larger than 1
        for indexA, elemA in enumerate(A):
            for indexB, elemB in enumerate(B):
                C[indexA + indexB] = (C[indexA + indexB] + elemA * elemB) % q

        D = [_ for _ in C]
        for i in range(len(A)-1):
            D[i] = (C[i] + C[i + len(A)]*wk) % q

    return D[0:deg]
    
# A,B: input polynomials in x^n+1
# q: coefficient modulus
# D: output polynomial in x^n+1
def SchoolbookModPolMul_NWC(A, B, q):
    C = [0] * (2 * len(A))
    D = [0] * (len(A))
    for indexA, elemA in enumerate(A):
        for indexB, elemB in enumerate(B):
            C[indexA + indexB] = (C[indexA + indexB] + elemA * elemB) % q

    for i in range(len(A)):
        D[i] = (C[i] - C[i + len(A)]) % q
    return D
        
        
