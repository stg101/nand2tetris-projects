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
// push argument 0
@ARG //    21
D=M //    22
@0 //    23
A=D+A //    24
D=M //    25
@SP //    26
A=M //    27
M=D //    28
@SP //    29
M=M+1 //    30
// push local 0
@LCL //    31
D=M //    32
@0 //    33
A=D+A //    34
D=M //    35
@SP //    36
A=M //    37
M=D //    38
@SP //    39
M=M+1 //    40
// add
@SP //    41
M=M-1 //    42
A=M //    43
D=M //    44
@SP //    45
M=M-1 //    46
A=M //    47
M=D+M //    48
@SP //    49
M=M+1 //    50
// pop local 0
@LCL //    51
D=M //    52
@0 //    53
D=D+A //    54
@addr //    55
M=D //    56
@SP //    57
A=M-1 //    58
D=M //    59
@addr //    60
A=M //    61
M=D  //    62
@SP //    63
M=M-1 //    64
// push argument 0
@ARG //    65
D=M //    66
@0 //    67
A=D+A //    68
D=M //    69
@SP //    70
A=M //    71
M=D //    72
@SP //    73
M=M+1 //    74
// push constant 1
@1 //    75
D=A //    76
@SP //    77
A=M //    78
M=D //    79
@SP //    80
M=M+1 //    81
// sub
@SP //    82
M=M-1 //    83
A=M //    84
D=M //    85
@SP //    86
M=M-1 //    87
A=M //    88
M=M-D //    89
@SP //    90
M=M+1 //    91
// pop argument 0
@ARG //    92
D=M //    93
@0 //    94
D=D+A //    95
@addr //    96
M=D //    97
@SP //    98
A=M-1 //    99
D=M //    100
@addr //    101
A=M //    102
M=D  //    103
@SP //    104
M=M-1 //    105
// push argument 0
@ARG //    106
D=M //    107
@0 //    108
A=D+A //    109
D=M //    110
@SP //    111
A=M //    112
M=D //    113
@SP //    114
M=M+1 //    115
// if-goto LOOP_START
// push local 0
@LCL //    116
D=M //    117
@0 //    118
A=D+A //    119
D=M //    120
@SP //    121
A=M //    122
M=D //    123
@SP //    124
M=M+1 //    125
