 python ../../train.py google/binarized/ \
  --save-interval=1 \
  --arch=transformer_vaswani_wmt_en_de_big \
  --attention-dropout=0.1 \
  --no-progress-bar \
  --criterion=label_smoothed_cross_entropy \
  --source-lang=en \
  --lr-scheduler=inverse_sqrt \
  --min-lr 1e-11 \
  --skip-invalid-size-inputs-valid-test \
  --target-lang=de \
  --label-smoothing=0.1 \
  --update-freq=1 \
  --optimizer adam \
  --adam-betas '(0.9, 0.98)' \
  --warmup-init-lr 1e-07 \
  --lr 0.0005 \
  --warmup-updates 4000 \
  --share-all-embeddings \
  --dropout 0.3 \
  --weight-decay 0.0 \
  --valid-subset=valid \
  --max-epoch=500 \
  --num_cores=8 \
  --log_steps=100 \
  --input_shapes 512x16 256x32 128x64 64x128 32x256 \
  --max-target-positions=256 #\
 # --restore-file wmt16.en-de.joined-dict.transformer/model.pt \
 # --reset-dataloader \
 # --reset-optimizer \
 # --reset-lr-scheduler \
 # --reset-meters
