scripts=$(dirname "$0")
base=$scripts/..
data=$base/data
sampled_data=$base/sampled_data

PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/train.en-nl.subsample.en > $sampled_data/train.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/train.en-nl.subsample.nl > $sampled_data/train.nl
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/dev.en-nl.en > $sampled_data/dev.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/dev.en-nl.nl > $sampled_data/dev.nl
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/test.en-nl.en > $sampled_data/test.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/test.en-nl.nl > $sampled_data/test.nl




