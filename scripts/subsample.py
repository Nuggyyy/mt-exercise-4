en_lines = []
nl_lines = []

# read 100000 lines from src and trg files
with open("data/train.en-nl.en", "r", encoding="utf-8") as f:
    count = 0
    while count < 100000:
        line = f.readline()
        en_lines.append(line)
        count += 1

with open("data/train.en-nl.nl", "r", encoding="utf-8") as f:
    count = 0
    while count < 100000:
        line = f.readline()
        nl_lines.append(line)
        count += 1

# write 100000 lines to src and trg subsampled files
with open("data/train.en-nl.subsample.en", "w", encoding="utf-8") as f:
    for line in en_lines:
        f.write(line)

with open("data/train.en-nl.subsample.nl", "w", encoding="utf-8") as f:
    for line in nl_lines:
        f.write(line)







