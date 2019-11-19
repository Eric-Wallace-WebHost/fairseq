# set this stuff
DATA_PATH=wmt16.en-de.joined-dict.newstest2014/
CKPT=wmt16.en-de.joined-dict.transformer/model.pt

# get moses
git clone https://github.com/moses-smt/mosesdecoder
MOSES_PATH=./mosesdecoder

OUTPUT_PATH=interactive_output
mkdir -p $OUTPUT_PATH
TRANS_PATH=$OUTPUT_PATH/translations
mkdir -p $TRANS_PATH
RESULT_PATH=$TRANS_PATH/results
mkdir -p $RESULT_PATH

python ../../interactive.py $DATA_PATH --path $CKPT --batch-size 1 --beam 4 --lenpen 0.6 --remove-bpe --log-format simple --buffer-size 12800 --source-lang en --target-lang de #\
	#< $DATA_PATH/test.en-de.en.bpe \
	#> $RESULT_PATH/res.txt

#cat $RESULT_PATH/res.txt | awk -F '\t' '/^H\t/ {print $3}' > $RESULT_PATH/hyp.txt
#cat $RESULT_PATH/hyp.txt | perl $MOSES_PATH/scripts/tokenizer/detokenizer.perl -q -threads 8 -a -l de > $RESULT_PATH/hyp.detok.txt
#cat $RESULT_PATH/hyp.detok.txt | perl $MOSES_PATH/scripts/tokenizer/tokenizer.perl -l de > $RESULT_PATH/hyp.tok.txt
#cat $RESULT_PATH/hyp.tok.txt | perl -ple 's{(\S)-(\S)}{$1 ##AT##-##AT## $2}g' > $RESULT_PATH/hyp.tok.atat.txt
#perl $MOSES_PATH/scripts/generic/multi-bleu.perl $DATA_PATH/test-en-de.de.tok.atat < $RESULT_PATH/hyp.tok.atat.txt > $RESULT_PATH/bleu.txt
## cat $RESULT_PATH/hyp.detok.txt | sacrebleu -t wmt14 -l en-de --width 2 > $RESULT_PATH/bleu.txt
#cat $RESULT_PATH/bleu.txt
