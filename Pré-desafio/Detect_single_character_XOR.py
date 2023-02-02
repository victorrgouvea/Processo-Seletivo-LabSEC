# LabSEC Pré-desafio - Cryptopals - Detect single-character XOR - Challenge 4

from Single_byte_XOR_cipher import single_byte_xor_cipher


def detect_single_character_xor(file_path):
    '''
    Takes a file with hex strings and find witch one was
    encrypted by single-character XOR.
    '''
    
    # Dicts to keep the score and origin file string from a 
    # text that has already gone throw the cipher function
    text_score = {}
    text_file_string = {}

    # Apply the cipher function to each line of the file
    # and keep the results in the dicts
    with open(file_path) as file:
        for line in file:
            hex_string = line.strip()
            score, key, text = single_byte_xor_cipher(hex_string)
            text_score[text] = score
            text_file_string[text] = hex_string

    # Get the key of the text with the bigger score and
    # use it to find the origin file line in the other dict
    max_score_text = max(text_score, key=text_score.get)
    file_string = text_file_string[max_score_text]

    return file_string, max_score_text


# Challenge exemple:

print('--------------------- Challenge 4 ---------------------')

encrypted_string, xord_message = detect_single_character_xor('challenge4.txt')
print('File string:', encrypted_string)
print('Decrypted message:', xord_message)
