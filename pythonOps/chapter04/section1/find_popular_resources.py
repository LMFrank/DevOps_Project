from collections import Counter

c = Counter()
with open('access.log') as f:
    for line in f:
        c[line.split()[6]] += 1

print("Popular resources: {0}".format(c.most_common(10)))