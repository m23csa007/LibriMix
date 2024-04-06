#!/bin/bash
set -eu  # Exit on error

# Define the storage directory path
storage_dir="/kaggle/working"

# Define the directory paths for LibriSpeech, WHAM, and LibriMix datasets
librispeech_dir="/kaggle/input/librispeech/LibriSpeech"
wham_dir="/kaggle/input/wham-noise/wham_noise"
librimix_outdir="${storage_dir}"

# Path to python
python_path=python

# Generate LibriMix dataset for 2 speakers
metadata_dir=metadata/myLibri2Mix
"$python_path" scripts/create_librimix_from_metadata.py --librispeech_dir "$librispeech_dir" \
    --wham_dir "$wham_dir" \
    --metadata_dir "$metadata_dir" \
    --librimix_outdir "$librimix_outdir" \
    --n_src 2 \
    --freqs 8k 16k \
    --modes min max \
    --types mix_clean mix_both mix_single
