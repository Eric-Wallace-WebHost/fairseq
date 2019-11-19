#!/bin/bash
ROOT=$(dirname "$0")
SCRIPTS=$ROOT/../../scripts
SPM_TRAIN=$SCRIPTS/spm_train.py
SPM_ENCODE=$SCRIPTS/spm_encode.py

BPESIZE=32768
TRAIN_MINLEN=1  # remove sentences with <1 BPE token
TRAIN_MAXLEN=250  # remove sentences with >250 BPE tokens
TRAIN_FILES='original/wmt14.en-de.en.train,original/wmt14.en-de.de.train'
VALID_FILES='original/wmt14.en-de.en.dev,original/wmt14.en-de.de.dev'
TEST_FILES='original/wmt14.en-de.en.test,original/wmt14-en-de.de.test'

# learn BPE with sentencepiece
python "$SPM_TRAIN" \
    --input=$TRAIN_FILES \
    --model_prefix=sentencepiece.bpe \
    --vocab_size=$BPESIZE \
    --character_coverage=0.9995 \
    --model_type=bpe

# encode train/valid/test
echo "encoding train/valid with learned BPE..."
python "$SPM_ENCODE" \
    --model "sentencepiece.bpe.model" \
    --output_format=piece \
    --inputs original/wmt14.en-de.en.train original/wmt14.en-de.de.train \
    --outputs original/wmt14.en-de.en.train.bpe original/wmt14.en-de.de.train.bpe \
    --min-len $TRAIN_MINLEN --max-len $TRAIN_MAXLEN
python "$SPM_ENCODE" \
    --model "sentencepiece.bpe.model" \
    --output_format=piece \
    --inputs original/wmt14.en-de.en.dev original/wmt14.en-de.de.dev \
    --outputs original/wmt14.en-de.en.dev.bpe original/wmt14.en-de.de.dev.bpe
python "$SPM_ENCODE" \
    --model "sentencepiece.bpe.model" \
    --output_format=piece \
    --inputs original/wmt14.en-de.en.test original/wmt14.en-de.de.test \
    --outputs original/wmt14.en-de.en.test.bpe original/wmt14.en-de.de.test.bpe 
