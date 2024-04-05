#!/bin/bash
set -eu  # Exit on error

# Define the storage directory path
storage_dir="/kaggle/working"

# Define the directory paths for LibriSpeech, WHAM, and LibriMix datasets
librispeech_dir="/kaggle/input/librispeech/LibriSpeech"
wham_dir="${storage_dir}/wham_noise"
librimix_outdir="${storage_dir}"

function wham() {
    if ! test -e "$wham_dir"; then
        echo "Download wham_noise into $storage_dir"
        # If downloading stalls for more than 20s, relaunch from previous state.
        wget -c --tries=0 --read-timeout=20 https://my-bucket-a8b4b49c25c811ee9a7e8bba05fa24c7.s3.amazonaws.com/wham_noise.zip -P "$storage_dir"
        unzip -qn "$storage_dir/wham_noise.zip" -d "$storage_dir"
        rm -rf "$storage_dir/wham_noise.zip"
    fi
}

# Execute functions to download datasets concurrently
wham &
wait

# Path to python
python_path=python

# Generate LibriMix dataset for 2 speakers
metadata_dir=metadata/Libri2Mix
"$python_path" scripts/create_librimix_from_metadata.py --librispeech_dir "$librispeech_dir" \
    --wham_dir "$wham_dir" \
    --metadata_dir "$metadata_dir" \
    --librimix_outdir "$librimix_outdir" \
    --n_src 2 \
    --freqs 8k 16k \
    --modes min max \
    --types mix_clean mix_both mix_single
