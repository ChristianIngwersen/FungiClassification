#!/bin/sh
### General options
### -- specify queue --
#BSUB -q gpua100
### -- set the job Name --
#BSUB -J fungi 
### -- ask for number of cores (default: 1) --
#BSUB -n 16
### -- Select the resources: 1 gpu in exclusive process mode --
#BSUB -gpu "num=1:mode=exclusive_process"
### -- set walltime limit: hh:mm --  maximum 24 hours for GPU-queues right now
#BSUB -W 2:00
# specify system resources
#BSUB -R "span[hosts=1]"
#BSUB -R "rusage[mem=4GB]"
### -- set the email address --
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u your_email_address
### -- send notification at start --
##BSUB -B
### -- send notification at completion--
##BSUB -N
### -- Specify the output and error file. %J is the job-id --
### -- -o and -e mean append, -oo and -eo mean overwrite --
#BSUB -o /work1/patmjen/summerschool22/experiments/batch_output/train_v1_%J.out
#BSUB -e /work1/patmjen/summerschool22/experiments/batch_output/train_v1_%J.err
# -- end of LSF options --

source init.sh

nvidia-smi

export WANDB_API_KEY=$(cat ~/WANDB_api_key)
wandb online

EXP_POSTFIX=${LSB_JOBID:-NOID}

EXP_DIR=/work1/patmjen/summerschool22/experiments/fungi_clf/run_${EXP_POSTFIX}
mkdir --parents ${EXP_DIR}
TRIAL_ID=$(ls -1 ${EXP_DIR} | wc -l)
EXP_DIR=${EXP_DIR}/trial_${TRIAL_ID}
mkdir --parents ${EXP_DIR}

python -u fungi_classification.py \
    --image_dir="/dtu-compute/fungiimages/DF20M/" \
    --network_dir="${EXP_DIR}" \

