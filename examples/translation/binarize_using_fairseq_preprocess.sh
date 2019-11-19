export OUTPUTDIR=preprocessed_original
mkdir -p $OUTPUTDIR
for LANG in en de; do
	cp wmt14.en-de.${LANG}.train.bpe $OUTPUTDIR/bpe.train.wmt14.en-de.${LANG}
	cp wmt14.en-de.${LANG}.dev.bpe $OUTPUTDIR/bpe.dev.wmt14.en-de.${LANG}
	cp wmt14.en-de.${LANG}.test.bpe $OUTPUTDIR/bpe.test.wmt14.en-de.${LANG}
done

fairseq-preprocess --source-lang en --target-lang de \
    --trainpref $OUTPUTDIR/bpe.train.wmt14.en-de --validpref $OUTPUTDIR/bpe.dev.wmt14.en-de --testpref $OUTPUTDIR/bpe.test.wmt14.en-de \
    --joined-dictionary \
    --destdir $OUTPUTDIR \
    --workers 32 \
    --nwordssrc 32768 --nwordstgt 32768


for LANG in en de; do
    rm $OUTPUTDIR/bpe.dev.wmt14.en-de.${LANG}
    rm $OUTPUTDIR/bpe.train.wmt14.en-de.${LANG}
    rm $OUTPUTDIR/bpe.test.wmt14.en-de.${LANG}
done
