#!/bin/bash

scripts=$(dirname "$0")
base=$scripts/..
models=$base/models
data=$base/translations/bpe_4k
results=$base/results/beam_search
mkdir -p $results

# Best model from Task 1 (adjust path)
model_dir=$models/bpe_4k  # or models/word_2k or models/bpe_4k
config=$base/configs/bpe_4k.yaml # or word_2k.yaml or bpe_4k.yaml

# Test file
test_src=$data/test.bpe_4k.nl  # or test.tok.en for word-level
test_trg=$base/sampled_data/test.nl  # raw reference for BLEU

# Beam sizes to test (1 to 10)
beam_sizes=(1 2 3 4 5 6 7 8 9 10)

# Output files
bleu_results=$results/bleu_scores.txt
time_results=$results/time_results.txt
echo -e "beam_size\tBLEU\tTime(s)" > $results/results.tsv

for beam in "${beam_sizes[@]}"; do
    echo "Testing beam size: $beam"

    # Create temporary config
    tmp_config=$results/config.beam$beam.yaml
    cp $config $tmp_config
    echo -e "\ntesting:\n  beam_size: $beam" >> $tmp_config

    # Measure translation time
    start_time=$(date +%s)
    CUDA_VISIBLE_DEVICES=0 python -m joeynmt translate $tmp_config < $test_src > $results/translations.beam$beam.nl
    end_time=$(date +%s)
    elapsed=$((end_time - start_time))

    # Compute BLEU
    bleu=$(sacrebleu $test_trg -i $results/translations.beam$beam.nl -m bleu -b -w 4)

    # Save result
    echo -e "$beam\t$bleu\t$elapsed" >> $results/results.tsv
    echo "Beam $beam: BLEU=$bleu, Time=${elapsed}s"
done


echo "Results saved to $results/results.tsv"