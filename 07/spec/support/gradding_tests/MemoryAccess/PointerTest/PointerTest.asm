// push constant 3030
@3030 //    0
D=A //    1
@SP //    2
A=M //    3
M=D //    4
@SP //    5
M=M+1 //    6
// pop pointer 0
@SP //    7
A=M-1 //    8
D=M //    9
@THAT //    10
M=D //    11
@SP //    12
M=M-1 //    13
// push constant 3040
@3040 //    14
D=A //    15
@SP //    16
A=M //    17
M=D //    18
@SP //    19
M=M+1 //    20
// pop pointer 1
@SP //    21
A=M-1 //    22
D=M //    23
@THAT //    24
M=D //    25
@SP //    26
M=M-1 //    27
// push constant 32
@32 //    28
D=A //    29
@SP //    30
A=M //    31
M=D //    32
@SP //    33
M=M+1 //    34
// pop this 2
@THIS //    35
D=M //    36
@2 //    37
D=D+A //    38
@addr //    39
M=D //    40
@SP //    41
A=M-1 //    42
D=M //    43
@addr //    44
A=M //    45
M=D  //    46
@SP //    47
M=M-1 //    48
// push constant 46
@46 //    49
D=A //    50
@SP //    51
A=M //    52
M=D //    53
@SP //    54
M=M+1 //    55
// pop that 6
@THAT //    56
D=M //    57
@6 //    58
D=D+A //    59
@addr //    60
M=D //    61
@SP //    62
A=M-1 //    63
D=M //    64
@addr //    65
A=M //    66
M=D  //    67
@SP //    68
M=M-1 //    69
// push pointer 0
@THAT //    70
D=M //    71
@SP //    72
A=M //    73
M=D //    74
@SP //    75
M=M+1 //    76
// push pointer 1
@THAT //    77
D=M //    78
@SP //    79
A=M //    80
M=D //    81
@SP //    82
M=M+1 //    83
// add
@SP //    84
M=M-1 //    85
A=M //    86
D=M //    87
@SP //    88
M=M-1 //    89
A=M //    90
M=D+M //    91
@SP //    92
M=M+1 //    93
// push this 2
@THIS //    94
D=M //    95
@2 //    96
A=D+A //    97
D=M //    98
@SP //    99
A=M //    100
M=D //    101
@SP //    102
M=M+1 //    103
// sub
@SP //    104
M=M-1 //    105
A=M //    106
D=M //    107
@SP //    108
M=M-1 //    109
A=M //    110
M=M-D //    111
@SP //    112
M=M+1 //    113
// push that 6
@THAT //    114
D=M //    115
@6 //    116
A=D+A //    117
D=M //    118
@SP //    119
A=M //    120
M=D //    121
@SP //    122
M=M+1 //    123
// add
@SP //    124
M=M-1 //    125
A=M //    126
D=M //    127
@SP //    128
M=M-1 //    129
A=M //    130
M=D+M //    131
@SP //    132
M=M+1 //    133
