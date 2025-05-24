scripts=$(dirname "$0")
base=$scripts/..
data=$base/data

PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/train.en-nl.subsample.en > $data/train.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/train.en-nl.subsample.nl > $data/train.nl
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/dev.en-nl.en > $data/dev.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/dev.en-nl.nl > $data/dev.nl
PYTHONIOENCODING=utf-8 sacremoses -l en tokenize < $data/test.en-nl.en > $data/test.en
PYTHONIOENCODING=utf-8 sacremoses -l nl tokenize < $data/test.en-nl.nl > $data/test.nl




