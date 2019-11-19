#!/bin/bash
ROOT=$(dirname "$0")
SCRIPTS=$ROOT/../../scripts
SPM_TRAIN=$SCRIPTS/spm_train.py
SPM_ENCODE=$SCRIPTS/spm_encode.py

BPESIZE=32768
TRAIN_MINLEN=1  # remove sentences with <1 BPE token
TRAIN_MAXLEN=250  # remove sentences with >250 BPE tokens

for SYSTEM in bing google deepl; do
    TRAIN_FILES="original/wmt14.en-de.en.train,${SYSTEM}/wmt14.en-de.de.train.${SYSTEM}"
    VALID_FILES="original/wmt14.en-de.en.dev,original/wmt14.en-de.de.dev"
    TEST_FILES="original/wmt14.en-de.en.test,original/wmt14-en-de.de.test"

    # learn BPE with sentencepiece
    python "$SPM_TRAIN" \
        --input=$TRAIN_FILES \
	--model_prefix=${SYSTEM}/sentencepiece.${SYSTEM}.bpe \
	--vocab_size=$BPESIZE \
	--character_coverage=0.9995 \
	--model_type=bpe

    echo "encoding train/valid with learned BPE..."
    python "$SPM_ENCODE" \
        --model "${SYSTEM}/sentencepiece.${SYSTEM}.bpe.model" \
	--output_format=piece \
	--inputs original/wmt14.en-de.en.train ${SYSTEM}/wmt14.en-de.de.train.${SYSTEM} \
	--outputs ${SYSTEM}/wmt14.en-de.en.train.${SYSTEM}.bpe {$SYSTEM}/wmt14.en-de.de.train.${SYSTEM}.bpe \
	--min-len $TRAIN_MINLEN --max-len $TRAIN_MAXLEN
    python "$SPM_ENCODE" \
        --model "sentencepiece.${SYSTEM}.bpe.model" \
        --output_format=piece \
        --inputs original/wmt14.en-de.en.dev original/wmt14.en-de.de.dev \
        --outputs ${SYSTEM}/wmt14.en-de.en.dev.${SYSTEM}.bpe ${SYSTEM}/wmt14.en-de.de.dev.${SYSTEM}.bpe
    python "$SPM_ENCODE" \
       --model "sentencepiece.${SYSTEM}.bpe.model" \
       --output_format=piece \
       --inputs original/wmt14.en-de.en.test original/wmt14.en-de.de.test \
       --outputs ${SYSTEM}/wmt14.en-de.en.test.${SYSTEM}.bpe ${SYSTEM}/wmt14.en-de.de.test.${SYSTEM}.bpe 
