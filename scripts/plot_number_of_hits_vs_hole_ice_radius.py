#!/usr/bin/env python3

import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

folder = sys.argv[1]

data = pd.read_csv(folder + "/hits.txt", sep = " ", names = ["hole-ice radius [DOM radii]", "number of hits"])
print(data)

radii = data["hole-ice radius [DOM radii]"]
hits = data["number of hits"]
hits_errors = np.sqrt(hits)

fig = plt.figure()
plt.errorbar(radii, hits, yerr=hits_errors)

plt.title("ppc simulation with ppc standard hole ice")
plt.ylabel("number of hits")
plt.xlabel("hole-ice radius [DOM radii]")

fig.savefig(folder + "/hits.png")
