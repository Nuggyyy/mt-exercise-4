#! /bin/bash

scripts=$(dirname "$0")
base=$scripts/..

data=$base/sampled_data
configs=$base/configs

translations=$base/translations

mkdir -p $translations

src=en
trg=nl


num_threads=4
device=0

# measure time

SECONDS=0

model_name=bpe_4k

echo "###############################################################################"
echo "model_name $model_name"

translations_sub=$translations/$model_name

mkdir -p $translations_sub

PYTHONIOENCODING=utf-8 CUDA_VISIBLE_DEVICES=$device OMP_NUM_THREADS=$num_threads python -m joeynmt translate $configs/$model_name.yaml < $data/test.en-nl.$src > $translations_sub/test.$model_name.$trg

# compute case-sensitive BLEU 

cat $translations_sub/test.$model_name.$trg | sacrebleu $data/test.$trg

# Detokenize
#sacremoses -l $trg detokenize \
#    < $translations_sub/test.$model_name.$trg \
#    > $translations_sub/test.$model_name.detok.$trg
#
## Compute BLEU
#echo "BLEU score:"
#sacrebleu $data/test.$trg -i $translations_sub/test.$model_name.detok.$trg


echo "time taken:"
echo "$SECONDS seconds"
