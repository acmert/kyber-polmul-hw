
def BytestoBits(a):
    # a: l-bytes array
    # b: 8*l-bits array
    l = len(a)
    b = [0] * (8*l)

    for i,byte in a:
        for j in range(8):
            b[8*i+j] = (byte >> j)%2

    return b

def Compress(x,d,q):
    c = round(((2**d)/q)*x) % (2**d)
    return c

def Decompress(x,d,q):
    c = round(((2**d)/q)*x)
    return c

def Parse(B):
    # works with q=3329
    # B: a random-sized byte array
    # a: NTT-representation of length n=256
    """
    Kyber uses a deterministic approach to sample
    elements in Rq that are statistically close to
    a uniformly random distribution. For this sampling
    we use a function Parse: B∗ → Rq, which receives
    as input a byte stream B = b0, b1, b2, . . . and
    computes the NTT-representation a.

    The intuition behind the function Parse is that if
    the input byte array is statistically close to a
    uniformly random byte array, then the output polynomial
    is statistically close to a uniformly random element
    of Rq. It represents a uniformly random polynomial in Rq
    """
    n=256
    q=3329

    a = [0]*n

    i=0
    j=0

    while j<n:
        d = B[i] + 256*B[i+1]
        if d<(19*q):
            a[j]=d
            j=j+1
        i=i+2

    return a

# Symmetric Primitives
"""
Symmetric primitives: The design of Kyber makes use
of a pseudorandom function PRF : B^32 × B → B^∗ and
of an extendable output function XOF : B^* × B × B → B.
Kyber also makes use of two hash functions
H:B^* → B^32 and G:B^* → B^32 × B^32 and of a key-derivation
function KDF:B^* → B^*.
"""

# Sampling from a binomial distribution
def CBD(B,nu):
    # B: byte array of length 64*nu
    """
    Noise in Kyber is sampled from a centered binomial
    distribution Bη for η = 2. We define Bη as follows:
    -- Sample (a1,...,aη,b1,...,bη) ← {0,1}^2η
    -- and output sum i:1->n (ai − bi)

    When we write that a polynomial f ∈ Rq or a vector of
    such polynomials is sampled from Bη, we mean that each
    coefficient is sampled from Bη.

    For the specification of Kyber we need to define how a
    polynomial f ∈ Rq is sampled according to Bη deterministically
    from 64η bytes of output of a pseudorandom function (we
    fix n = 256 in this description). This is done by the
    function CBD.
    """
    n = 256
    # nu = 2

    f = [0]*n

    Bits = BytestoBits(B) # have length of 512*nu

    for i in range(n):
        a = sum([Bits[2*i*nu+j] for j in range(0,nu)])
        b = sum([Bits[2*i*nu+nu+j] for j in range(0,nu)])
        f[i] = a-b

    return f

# Encoding and Decoding





#
