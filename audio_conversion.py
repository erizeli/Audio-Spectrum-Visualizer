import numpy as np
from numpy import fft
import librosa # for audio loading

data, fs = librosa.load("piano_noisy.mp3", sr=48000) #data is array of audio samples, fs is sampling rate (set to 48000 Hz)

# Un-normalize the audio data to 24-bit signed integer format
max_val = 2**23 
data_int = np.clip((data * max_val).astype(np.int32), -max_val, max_val - 1) # clip ensures values are within the range of signed 24-bit integers

# Save to MIF format (using code similar to note_gen)
with open("piano_noisy.mif", "w") as f:
    f.write(f"WIDTH=24;\n")
    f.write(f"DEPTH={len(data)};\n\n")
    f.write(f"ADDRESS_RADIX=UNS;\n")
    f.write(f"DATA_RADIX=DEC;\n\n")
    f.write(f"CONTENT BEGIN\n")
    for i, sample in enumerate(data_int):
        f.write(f"\t{i}\t:\t{sample};\n")
    f.write("END;\n")
