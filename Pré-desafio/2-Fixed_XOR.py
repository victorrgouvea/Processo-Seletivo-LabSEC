# LabSEC Pré-desafio - Cryptopals - Fixed XOR

def fixed_xor(b1, b2):

    if len(b1) != len(b2):
        print('The length of the buffers are diferent')
        return
    
    b1D = bytes.fromhex(b1)
    print(b1D)
    b2D = bytes.fromhex(b2)
    print(b2D)

    xor_result = bytearray()
    for byte1, byte2 in zip(b1D, b2D):
        xor_result.append(byte1 ^ byte2)

    return bytes(xor_result)

print(fixed_xor('1c0111001f010100061a024b53535009181c', '686974207468652062756c6c277320657965').hex())