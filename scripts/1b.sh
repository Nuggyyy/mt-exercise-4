#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
data=$base/data
bpe=$base/bpe

mkdir -p $bpe

# Tokenize (copy from tokenize.sh)
echo "Tokenizing data..."
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/train.en-nl.subsample.en > $data/train.tok.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/train.en-nl.subsample.nl > $data/train.tok.nl
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/dev.en-nl.en > $data/dev.tok.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/dev.en-nl.nl > $data/dev.tok.nl
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/test.en-nl.en > $data/test.tok.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/test.en-nl.nl > $data/test.tok.nl

# Learn BPE codes (copy from bpe.sh)
echo "Learning BPE codes..."
subword-nmt learn-joint-bpe-and-vocab \
    --input $data/train.tok.en $data/train.tok.nl \
    -s 2000 \
    --total-symbols \
    --output $bpe/codes.bpe \
    --write-vocabulary $bpe/vocab.en $bpe/vocab.nl

# Apply BPE to all files
echo "Applying BPE..."
for lang in en nl; do
    for split in train dev test; do
    subword-nmt apply-bpe \
        -c $bpe/codes.bpe \
        --vocabulary $bpe/vocab.$lang \
        --vocabulary-threshold 1 \
        < $data/$split.tok.$lang > $data/$split.bpe.$lang
    done
done

# Create joint vocabulary file
echo "Creating joint vocabulary..."
cat $data/train.bpe.en $data/train.bpe.nl | \
    tr ' ' '\n' | sort | uniq > $bpe/vocab.joint

echo "Done! BPE files saved to $bpe/"