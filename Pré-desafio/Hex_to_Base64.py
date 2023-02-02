# LabSEC Pré-desafio - Cryptopals - Convert hex to base64 - Challenge 1

import base64


def hex_to_base64(hex_input):
    '''
    Hex string input is transformed into a bytes object, to
    then be encoded using base64 and finally use de decode function
    to decode the bytes object back to string
    '''
    base_64 = base64.b64encode(bytes.fromhex(hex_input)).decode()
    return base_64


# Challenge exemple

print('--------------------- Challenge 1 ---------------------')

hex = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'

converted_input = hex_to_base64(hex)

print(hex, 'in base64:')
print('->', converted_input)
