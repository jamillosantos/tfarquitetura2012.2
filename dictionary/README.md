- Especificação dos bytes dos tipos de instruções :

Impressão: pack("C", OPC)


OPC = 0 - |OP|RG|

OPC = 1 - |OP|RG|RG|

OPC = 2 - |OP|RG|RG|RG|

OPC = 3 - |OP|RG|IMMEDIATE|

OPC = 4 - |OP|RG|RG|IMMEDIATE|

OPC = 5 - |OP|RG|LABEL|

OPC = 6 - |OP|RG|RG|LABEL|

OPC = 7 - |LABEL|

OPC = 8 - |OP|


