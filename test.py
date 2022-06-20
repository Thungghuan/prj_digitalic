#!/usr/bin/env python3

import math

a = 3580
b = 1460
c = 231

d = 754

out1 = a / (a + b + c)
out2 = math.sin(2 * math.pi * d / 1024)

out = out1 * out2

# print(out1)
# print(out1 * (2 ** 14))

# print(out2)
# print(out2 * (2 ** 12))
print(out)

print("{:0>11b}".format(int(abs(out) * (2 ** 11))))
