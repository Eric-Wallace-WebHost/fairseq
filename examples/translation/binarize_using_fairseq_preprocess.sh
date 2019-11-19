#export OUTPUTDIR=preprocessed_original
export OUTPUTDIR=google/binarized
export SYSTEM=google
mkdir -p $OUTPUTDIR
for LANG in en de; do
	cp ${SYSTEM}/wmt14.en-de.${LANG}.train.${SYSTEM}.bpe ${SYSTEM}/bpe.train.wmt14.en-de.${LANG}
	cp ${SYSTEM}/wmt14.en-de.${LANG}.dev.${SYSTEM}.bpe ${SYSTEM}/bpe.dev.wmt14.en-de.${LANG}
	cp ${SYSTEM}/wmt14.en-de.${LANG}.test.${SYSTEM}.bpe ${SYSTEM}/bpe.test.wmt14.en-de.${LANG}
done

fairseq-preprocess --source-lang en --target-lang de \
    --trainpref ${SYSTEM}/bpe.train.wmt14.en-de --validpref ${SYSTEM}/bpe.dev.wmt14.en-de --testpref ${SYSTEM}/bpe.test.wmt14.en-de \
    --joined-dictionary \
    --destdir $OUTPUTDIR \
    --workers 32 \
    --nwordssrc 32768 --nwordstgt 32768


for LANG in en de; do
    rm ${SYSTEM}/bpe.dev.wmt14.en-de.${LANG}
    rm ${SYSTEM}/bpe.train.wmt14.en-de.${LANG}
    rm ${SYSTEM}/bpe.test.wmt14.en-de.${LANG}
done
