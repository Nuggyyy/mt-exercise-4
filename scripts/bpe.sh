scripts=$(dirname "$0")
base=$scripts/..
data=$base/data

subword-nmt learn-joint-bpe-and-vocab \
    --input $data/train.en data/train.nl \
    -s 2000 \
    --total-symbols \
    -o $data/bpe.codes \
    --write-vocabulary $data/vocab.en $data/vocab.nl


