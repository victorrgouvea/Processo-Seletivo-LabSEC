# LabSEC Pré-desafio - Cryptopals - Fixed XOR - Challenge 2

def fixed_xor(b1, b2):
    '''
    Takes two bytes objects with equal lenght and delivers the XOR
    '''
    if len(b1) != len(b2):
        raise ValueError('The length of the buffers are diferent')

    # Aplies the XOR operation to each part of the byte objects
    xor_result = bytearray()
    for byte1, byte2 in zip(b1, b2):
        xor_result.append(byte1 ^ byte2)

    return bytes(xor_result)


# Challenge exemple:

print('--------------------- Challenge 2 ---------------------')

a = '1c0111001f010100061a024b53535009181c'
b = '686974207468652062756c6c277320657965'
result = fixed_xor(bytes.fromhex(a), bytes.fromhex(b)) # Passing as bytes objects

print('Decoded result:', result.decode())
print('Hex result:', result.hex())
