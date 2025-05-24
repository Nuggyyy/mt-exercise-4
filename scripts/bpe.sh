scripts=$(dirname "$0")
base=$scripts/..
data=$base/data
bpe=$base/bpe2

# Learn BPE codes (copy from bpe.sh)
echo "Learning BPE codes..."
subword-nmt learn-joint-bpe-and-vocab \
    --input $data/train.tok.en $data/train.tok.nl \
    -s 4000 \
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