#!/usr/bin/env python3

import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

folder = sys.argv[1]

data = pd.read_csv(folder + "/benchmark.txt", sep = " ", names = ["hole-ice radius [DOM radii]", "execution time [s]"])
print(data)

radii = data["hole-ice radius [DOM radii]"]
times = data["execution time [s]"]

fig = plt.figure()
plt.plot(radii, times)

plt.title("ppc simulation with ppc standard hole ice")
plt.ylabel("execution time [s]")
plt.xlabel("hole-ice radius [DOM radii]")

fig.savefig(folder + "/benchmark.png")
