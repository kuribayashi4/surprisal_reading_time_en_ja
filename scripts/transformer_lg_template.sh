### for debugging ###
date
uname -a
which python
python --version

DATA_SIZE=""
SKIP=0
RANDOM_SEED=1

while getopts "sd:r:l:" opt; do
  case $opt in
    d) DATA_SIZE="$OPTARG"
    ;;
    s) SKIP=1
    ;;
    r) RANDOM_SEED="$OPTARG"
    ;;
    l) LANG="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

if [ $DATA_SIZE = "" ];then
       echo "-d is mandatory!"
       exit 1
fi

SAVE_DIR=$LANG/lstm_checkpoints_$DATA_SIZE-seed-$RANDOM_SEED
DATA_DIR=$LANG/data-bin-$DATA_SIZE
mkdir -p $SAVE_DIR
mkdir -p $SAVE_DIR/100_updates
mkdir -p $SAVE_DIR/1000_updates
mkdir -p $SAVE_DIR/10000_updates
mkdir -p $SAVE_DIR/100000_updates

if [ $SKIP -le 0 ]; then
    fairseq-train --task language_modeling \
      $DATA_DIR \
      --save-dir $SAVE_DIR/100_updates \
      --save-interval-updates 1000 \
      --keep-interval-updates 5 \
      --keep-last-epochs 10 \
      --arch transformer_lm_gpt --share-decoder-input-output-embed \
      --dropout 0.1 --decoder-embed-dim 384 --decoder-ffn-embed-dim 2048 --decoder-layers 8 --decoder-attention-heads 6 \
      --optimizer adam --adam-betas '(0.9, 0.98)' --weight-decay 0.01 --clip-norm 0.0 \
      --lr 0.0005 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
      --tokens-per-sample 768 --sample-break-mode none \
      --max-tokens 768 --update-freq 20 \
      --fp16 --seed $RANDOM_SEED \
      --tensorboard-logdir $SAVE_DIR/100_updates \
      --max-update 100 --log-format json --log-interval 10 | tee -a $SAVE_DIR/100_updates/train.log

    if [ ! -e $SAVE_DIR/1000_updates/checkpoint_last.pt ];then
        cp $SAVE_DIR/100_updates/checkpoint_last.pt $SAVE_DIR/1000_updates
    fi

    fairseq-train --task language_modeling \
      $DATA_DIR \
      --save-dir $SAVE_DIR/1000_updates \
      --save-interval-updates 1000 \
      --keep-interval-updates 5 \
      --keep-last-epochs 10 \
      --arch transformer_lm_gpt --share-decoder-input-output-embed \
      --dropout 0.1 --decoder-embed-dim 384 --decoder-ffn-embed-dim 2048 --decoder-layers 8 --decoder-attention-heads 6 \
      --optimizer adam --adam-betas '(0.9, 0.98)' --weight-decay 0.01 --clip-norm 0.0 \
      --lr 0.0005 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
      --tokens-per-sample 768 --sample-break-mode none \
      --max-tokens 768 --update-freq 20 \
      --fp16 --seed $RANDOM_SEED \
      --tensorboard-logdir $SAVE_DIR/1000_updates \
      --max-update 1000 --log-format json --log-interval 10 | tee -a $SAVE_DIR/1000_updates/train.log

    if [ ! -e $SAVE_DIR/10000_updates/checkpoint_last.pt ];then
        cp $SAVE_DIR/1000_updates/checkpoint_last.pt $SAVE_DIR/10000_updates
    fi

    fairseq-train --task language_modeling \
      $DATA_DIR \
      --save-dir $SAVE_DIR/10000_updates \
      --save-interval-updates 1000 \
      --keep-interval-updates 10 \
      --keep-last-epochs 10 \
      --arch transformer_lm_gpt --share-decoder-input-output-embed \
      --dropout 0.1 --decoder-embed-dim 384 --decoder-ffn-embed-dim 2048 --decoder-layers 8 --decoder-attention-heads 6 \
      --optimizer adam --adam-betas '(0.9, 0.98)' --weight-decay 0.01 --clip-norm 0.0 \
      --lr 0.0005 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
      --tokens-per-sample 768 --sample-break-mode none \
      --max-tokens 768 --update-freq 20 \
      --fp16 --seed $RANDOM_SEED \
      --tensorboard-logdir $SAVE_DIR/10000_updates \
      --max-update 10000 --log-format json --log-interval 10 | tee -a $SAVE_DIR/10000_updates/train.log

    if [ ! -e $SAVE_DIR/100000_updates/checkpoint_last.pt ];then
        cp $SAVE_DIR/10000_updates/checkpoint_last.pt $SAVE_DIR/100000_updates
    fi

fi

fairseq-train --task language_modeling \
  $DATA_DIR \
  --save-dir $SAVE_DIR/100000_updates \
  --save-interval-updates 10000 \
  --keep-interval-updates 10 \
  --keep-last-epochs 10 \
  --arch transformer_lm_gpt --share-decoder-input-output-embed \
  --dropout 0.1 --decoder-embed-dim 384 --decoder-ffn-embed-dim 2048 --decoder-layers 8 --decoder-attention-heads 6 \
  --optimizer adam --adam-betas '(0.9, 0.98)' --weight-decay 0.01 --clip-norm 0.0 \
  --lr 0.0005 --lr-scheduler inverse_sqrt --warmup-updates 4000 --warmup-init-lr 1e-07 \
  --tokens-per-sample 768 --sample-break-mode none \
  --max-tokens 768 --update-freq 20 \
  --fp16 --seed $RANDOM_SEED \
  --tensorboard-logdir $SAVE_DIR/100000_updates \
  --max-update 100000 --log-format json --log-interval 10 | tee -a $SAVE_DIR/100000_updates/train.log
