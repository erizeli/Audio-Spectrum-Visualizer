import numpy as np
from numpy import fft
import mif
import matplotlib.pyplot as plt

#fft.py processes the fft of a signal that is held in a MIF file.

# Load the MIF file and reverse the bits of each sample
with open('note_data.mif', 'r') as f:
    mem = mif.load(f)

# For some reason, the samples in the MIF file are stored in reverse order, so we need to reverse them back.
# Reverse the bits of each sample and convert to decimal
dec_mem = []
for i in range(len(mem)):
    mem[i] = mem[i][::-1] 
    binary_val = ''
    for j in range(len(mem[i])):
        binary_val += str(mem[i][j])
    int_val = int(binary_val, 2)
    if binary_val[0] == '1':  # 2's complement check
        int_val -= 2**len(mem[i])
    dec_mem.append(int_val)

# This block processes the samples in blocks of 16, computes the FFT, and stores the absolute values (magnitudes)
fft_mem = []
for i in range(0, len(dec_mem) - 15, 16):  
    block = dec_mem[i:i+32]
    fft_data = np.int32(np.abs(fft.fft(block, n=16)))
    for num in fft_data:
        fft_mem.append(num // 530053)  # Scale down the FFT to VGA heights

# print(fft_mem[:16])
# for i in range(22500, 26500, 16):
#     print(fft_mem[i:i+16])

# Save to MIF format (using code similar to note_gen)
with open("b5_freq.mif", "w") as f:
    f.write(f"WIDTH=9;\n")
    f.write(f"DEPTH={len(fft_mem)};\n\n")
    f.write(f"ADDRESS_RADIX=UNS;\n")
    f.write(f"DATA_RADIX=DEC;\n\n")
    f.write(f"CONTENT BEGIN\n")
    for i, sample in enumerate(fft_mem):
        f.write(f"\t{i}\t:\t{sample};\n")
    f.write("END;\n")


##### Plotting the FFT of All Samples #####
# fft_result = fft.fft(dec_mem, n=1024)

# fs = 48000 
# freqs = np.fft.fftfreq(1024, 1/fs)

# # Plot the FFT result
# plt.plot(freqs, np.abs(fft_result))
# plt.title('FFT of All Samples')
# plt.xlabel('Frequency (Hz)')
# plt.ylabel('Magnitude')
# plt.xlim(0, fs/2)  # Show only positive frequencies
# plt.show()