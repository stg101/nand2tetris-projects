// push constant 0
@0 //    0
D=A //    1
@SP //    2
A=M //    3
M=D //    4
@SP //    5
M=M+1 //    6
// pop local 0
@LCL //    7
D=M //    8
@0 //    9
D=D+A //    10
@addr //    11
M=D //    12
@SP //    13
A=M-1 //    14
D=M //    15
@addr //    16
A=M //    17
M=D  //    18
@SP //    19
M=M-1 //    20
// label LOOP_START
(LOOP_START) //    21
// push argument 0
@ARG //    22
D=M //    23
@0 //    24
A=D+A //    25
D=M //    26
@SP //    27
A=M //    28
M=D //    29
@SP //    30
M=M+1 //    31
// push local 0
@LCL //    32
D=M //    33
@0 //    34
A=D+A //    35
D=M //    36
@SP //    37
A=M //    38
M=D //    39
@SP //    40
M=M+1 //    41
// add
@SP //    42
M=M-1 //    43
A=M //    44
D=M //    45
@SP //    46
M=M-1 //    47
A=M //    48
M=D+M //    49
@SP //    50
M=M+1 //    51
// pop local 0
@LCL //    52
D=M //    53
@0 //    54
D=D+A //    55
@addr //    56
M=D //    57
@SP //    58
A=M-1 //    59
D=M //    60
@addr //    61
A=M //    62
M=D  //    63
@SP //    64
M=M-1 //    65
// push argument 0
@ARG //    66
D=M //    67
@0 //    68
A=D+A //    69
D=M //    70
@SP //    71
A=M //    72
M=D //    73
@SP //    74
M=M+1 //    75
// push constant 1
@1 //    76
D=A //    77
@SP //    78
A=M //    79
M=D //    80
@SP //    81
M=M+1 //    82
// sub
@SP //    83
M=M-1 //    84
A=M //    85
D=M //    86
@SP //    87
M=M-1 //    88
A=M //    89
M=M-D //    90
@SP //    91
M=M+1 //    92
// pop argument 0
@ARG //    93
D=M //    94
@0 //    95
D=D+A //    96
@addr //    97
M=D //    98
@SP //    99
A=M-1 //    100
D=M //    101
@addr //    102
A=M //    103
M=D  //    104
@SP //    105
M=M-1 //    106
// push argument 0
@ARG //    107
D=M //    108
@0 //    109
A=D+A //    110
D=M //    111
@SP //    112
A=M //    113
M=D //    114
@SP //    115
M=M+1 //    116
// if-goto LOOP_START
@SP //    117
A=M-1 //    118
D=M //    119
@LOOP_START //    120
D;JNE //    121
// push local 0
@LCL //    122
D=M //    123
@0 //    124
A=D+A //    125
D=M //    126
@SP //    127
A=M //    128
M=D //    129
@SP //    130
M=M+1 //    131
