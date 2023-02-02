# LabSEC Pré-desafio - Cryptopals - Single-byte XOR cipher - Challenge 3

import string
from Fixed_XOR import fixed_xor  # Due to this import, the first two lines of
                                 # prints when this file is executed are from Fixed_XOR.py


# Dict with the frequency of each letter in the english dictionary
char_frequency = {
        'a': 0.08167, 'b': 0.01492, 'c': 0.02782, 'd': 0.04253,
        'e': 0.12702, 'f': 0.02228, 'g': 0.02015, 'h': 0.06094,
        'i': 0.06094, 'j': 0.00153, 'k': 0.00772, 'l': 0.04025,
        'm': 0.02406, 'n': 0.06749, 'o': 0.07507, 'p': 0.01929,
        'q': 0.00095, 'r': 0.05987, 's': 0.06327, 't': 0.09056,
        'u': 0.02758, 'v': 0.00978, 'w': 0.0236, 'x': 0.0015,
        'y': 0.01974, 'z': 0.00074
    }

def single_byte_xor_cipher(hex_string):
    '''
    Takes a hex string to discover the single-byte key that can be xor'd
    with the string and gives the byte object of the xor'd message, its key
    and score(determined by character frequency and presence of most used punctuation)
    '''
    ciphertext = bytes.fromhex(hex_string)
    
    # Dict to keep a tuple with the score and decoded text from each key
    # tuple = (score, text)
    key_score_text = {}
    
    # Try each possible key
    for key in range(256):
        key_ext = bytes([key]) * len(ciphertext)  # Extend the key to use fixed_xor
        xored_text = fixed_xor(ciphertext, key_ext)

        # Start calculating score:
        score = 0.0
        count_bad_chars = 0
        punctuation = " .!?',"  # most used punctuation in english

        for byte_digit in xored_text:
            char = chr(byte_digit)

            # Gets the score for a lowercase letter
            if char in string.ascii_lowercase:
                score += char_frequency[char]

            # 50% discount on uppercase letters as it is not as much used as lowercase
            elif char in string.ascii_uppercase:
                score += 0.5 * char_frequency[char.lower()]

            # if the char is not a letter or most used punctuation, add 1 to the counter
            # to reduce the score later for better accuracy
            elif char not in punctuation:
                count_bad_chars += 1

        # Reducing score for each bad char by 10%
        for i in range(count_bad_chars):
            score *= 0.9

        # Keeping the values in the dict
        key_score_text[key] = (score, xored_text)

    # Aux variables
    max_score = -1
    max_key = ''
    max_text = ''

    # Loop to find the best score and it text and key
    for key in key_score_text.keys():
        score = (key_score_text[key])[0]
        text = (key_score_text[key])[1]
        if score > max_score:
            max_score = score
            max_key = key
            max_text = text

    
    return max_score, max_key, max_text

# Challenge exemple:

a, b, c = single_byte_xor_cipher('1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736')
print('Score:', a)
print('Key:', b)
print('Text(in byte):', c)
