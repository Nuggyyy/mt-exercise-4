#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
models=$base/models
data=$base/data
results=$base/results/beam_search
mkdir -p $results

# Best model from Task 1 (adjust path)
model_dir=$models/bpe_2k  # or models/word_2k or models/bpe_4k
config=$model_dir/bpe_2k.yaml # or word_2k.yaml or bpe_4k.yaml

# Test file
test_src=$data/test.bpe.en  # or test.tok.en for word-level
test_trg=$data/test.nl  # raw reference for BLEU

# Beam sizes to test (1 to 10)
beam_sizes=(1 2 3 4 5 6 7 8 9 10)

# Output files
bleu_results=$results/bleu_scores.txt
time_results=$results/time_results.txt
echo -e "beam_size\tBLEU\tTime(s)" > $results/results.tsv

# Run translation for each beam size
for beam in "${beam_sizes[@]}"; do
    echo "Testing beam size: $beam"
    
    # Translate and measure time
    start_time=$(date +%s)
    CUDA_VISIBLE_DEVICES=0 python -m joeynmt translate \
        $config \
        --input $test_src \
        --output $results/translations.beam$beam.nl \
        --beam_size $beam
    end_time=$(date +%s)
    elapsed=$((end_time - start_time))
    
    # Compute BLEU
    bleu=$(sacrebleu $test_trg -i $results/translations.beam$beam.nl -m bleu -b -w 4)
    
    # Save results
    echo -e "$beam\t$bleu\t$elapsed" >> $results/results.tsv
    echo "Beam $beam: BLEU=$bleu, Time=${elapsed}s"
done

echo "Results saved to $results/results.tsv"