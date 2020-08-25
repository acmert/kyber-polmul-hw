from random import randint

n  = 256
q  = 3329
w  = 17
wv = 1175
qd2= 1665

tnum = 16

for i in range(tnum//2):
    CT = 0

    A = randint(0,q-1)
    B = randint(0,q-1)
    W = pow(wv,randint(0,n//2 - 1),q)

    E = (A+B)%q
    O = ((A-B)%q * W)%q

    if E%2 == 0:
        E = (E >> 1)
    else:
        E = (E >> 1) + qd2

    if O%2 == 0:
        O = (O >> 1)
    else:
        O = (O >> 1) + qd2

    print("A={}; B={}; W={}; CT={}; #10; // E: {}, O: {}".format(A,B,W,CT,E,O))

print("#100;");

for i in range(tnum//2):
    CT = 1

    A = randint(0,q-1)
    B = randint(0,q-1)
    W = pow(w,randint(0,n//2 - 1),q)

    E = (A + B*W)%q
    O = (A - B*W)%q

    print("A={}; B={}; W={}; CT={}; #10; // E: {}, O: {}".format(A,B,W,CT,E,O))
