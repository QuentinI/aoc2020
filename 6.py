from functools import reduce
print(sum(map(lambda x: len(set("".join(x.split("\n")))), open("6.in", "r").read().split("\n\n"))))
print(sum(map(lambda x: len(reduce(lambda a, b: a.intersection(b), map(set, x.strip().split("\n")))), open("6.in", "r").read().split("\n\n"))))
