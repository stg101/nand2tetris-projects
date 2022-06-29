// push constant 111
@111 //    0
D=A //    1
@SP //    2
A=M //    3
M=D //    4
@SP //    5
M=M+1 //    6
// push constant 333
@333 //    7
D=A //    8
@SP //    9
A=M //    10
M=D //    11
@SP //    12
M=M+1 //    13
// push constant 888
@888 //    14
D=A //    15
@SP //    16
A=M //    17
M=D //    18
@SP //    19
M=M+1 //    20
// pop static 8
@SP //    21
A=M-1 //    22
D=M //    23
@static.8 //    24
M=D //    25
@SP //    26
M=M-1 //    27
// pop static 3
@SP //    28
A=M-1 //    29
D=M //    30
@static.3 //    31
M=D //    32
@SP //    33
M=M-1 //    34
// pop static 1
@SP //    35
A=M-1 //    36
D=M //    37
@static.1 //    38
M=D //    39
@SP //    40
M=M-1 //    41
// push static 3
@static.3 //    42
D=M //    43
@SP //    44
A=M //    45
M=D //    46
@SP //    47
M=M+1 //    48
// push static 1
@static.1 //    49
D=M //    50
@SP //    51
A=M //    52
M=D //    53
@SP //    54
M=M+1 //    55
// sub
@SP //    56
M=M-1 //    57
A=M //    58
D=M //    59
@SP //    60
M=M-1 //    61
A=M //    62
M=M-D //    63
@SP //    64
M=M+1 //    65
// push static 8
@static.8 //    66
D=M //    67
@SP //    68
A=M //    69
M=D //    70
@SP //    71
M=M+1 //    72
// add
@SP //    73
M=M-1 //    74
A=M //    75
D=M //    76
@SP //    77
M=M-1 //    78
A=M //    79
M=D+M //    80
@SP //    81
M=M+1 //    82
