# LabSEC Pré-desafio - Cryptopals - Convert hex to base64

import base64


def hex_to_base64(hex_input):
    '''Hex string input is transformed into a bytes object, to
       then be encoded using base64 and finally use de decode function
       to decode the bytes object back to string'''  
    base_64 = base64.b64encode(bytes.fromhex(hex_input)).decode()
    return base_64


hex = input('Insert a hex string to be converted to base64:')

converted_input = hex_to_base64(hex)

print(hex, 'in base64:')
print('->', converted_input)
