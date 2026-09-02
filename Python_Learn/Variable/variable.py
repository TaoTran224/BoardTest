from decimal import*
from fractions import Fraction
getcontext().prec = 30
print(10/3)
print(Decimal(10)/Decimal(7))

print(Fraction(10, 70))

print(complex(10, 70))
print(complex(10, 70).real)

print(complex(10, 70).imag)
print(10*3)
print(10%3)
