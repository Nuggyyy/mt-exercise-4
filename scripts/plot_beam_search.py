import pandas as pd
import matplotlib.pyplot as plt

# Load results
results = pd.read_csv("results/beam_search/results.tsv", sep="\t")

# Plot BLEU vs Beam Size
plt.figure(figsize=(10, 4))
plt.subplot(1, 2, 1)
plt.plot(results["beam_size"], results["BLEU"], marker="o")
plt.xlabel("Beam Size")
plt.ylabel("BLEU Score")
plt.title("BLEU vs Beam Size")

# Plot Time vs Beam Size
plt.subplot(1, 2, 2)
plt.plot(results["beam_size"], results["Time(s)"], marker="o", color="orange")
plt.xlabel("Beam Size")
plt.ylabel("Time (seconds)")
plt.title("Translation Time vs Beam Size")

plt.tight_layout()
plt.savefig("results/beam_search/beam_search_impact.png")
plt.show()