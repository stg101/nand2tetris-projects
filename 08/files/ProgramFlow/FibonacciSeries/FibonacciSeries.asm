// push argument 1
@ARG //    0
D=M //    1
@1 //    2
A=D+A //    3
D=M //    4
@SP //    5
A=M //    6
M=D //    7
@SP //    8
M=M+1 //    9
// pop pointer 1
@SP //    10
A=M-1 //    11
D=M //    12
@THAT //    13
M=D //    14
@SP //    15
M=M-1 //    16
// push constant 0
@0 //    17
D=A //    18
@SP //    19
A=M //    20
M=D //    21
@SP //    22
M=M+1 //    23
// pop that 0
@THAT //    24
D=M //    25
@0 //    26
D=D+A //    27
@addr //    28
M=D //    29
@SP //    30
A=M-1 //    31
D=M //    32
@addr //    33
A=M //    34
M=D  //    35
@SP //    36
M=M-1 //    37
// push constant 1
@1 //    38
D=A //    39
@SP //    40
A=M //    41
M=D //    42
@SP //    43
M=M+1 //    44
// pop that 1
@THAT //    45
D=M //    46
@1 //    47
D=D+A //    48
@addr //    49
M=D //    50
@SP //    51
A=M-1 //    52
D=M //    53
@addr //    54
A=M //    55
M=D  //    56
@SP //    57
M=M-1 //    58
// push argument 0
@ARG //    59
D=M //    60
@0 //    61
A=D+A //    62
D=M //    63
@SP //    64
A=M //    65
M=D //    66
@SP //    67
M=M+1 //    68
// push constant 2
@2 //    69
D=A //    70
@SP //    71
A=M //    72
M=D //    73
@SP //    74
M=M+1 //    75
// sub
@SP //    76
M=M-1 //    77
A=M //    78
D=M //    79
@SP //    80
M=M-1 //    81
A=M //    82
M=M-D //    83
@SP //    84
M=M+1 //    85
// pop argument 0
@ARG //    86
D=M //    87
@0 //    88
D=D+A //    89
@addr //    90
M=D //    91
@SP //    92
A=M-1 //    93
D=M //    94
@addr //    95
A=M //    96
M=D  //    97
@SP //    98
M=M-1 //    99
// label MAIN_LOOP_START
(MAIN_LOOP_START) //    100
// push argument 0
@ARG //    101
D=M //    102
@0 //    103
A=D+A //    104
D=M //    105
@SP //    106
A=M //    107
M=D //    108
@SP //    109
M=M+1 //    110
// if-goto COMPUTE_ELEMENT
@SP //    111
M=M-1 //    112
A=M //    113
D=M //    114
@COMPUTE_ELEMENT //    115
D;JNE //    116
// goto END_PROGRAM
@END_PROGRAM //    117
0;JMP //    118
// label COMPUTE_ELEMENT
(COMPUTE_ELEMENT) //    119
// push that 0
@THAT //    120
D=M //    121
@0 //    122
A=D+A //    123
D=M //    124
@SP //    125
A=M //    126
M=D //    127
@SP //    128
M=M+1 //    129
// push that 1
@THAT //    130
D=M //    131
@1 //    132
A=D+A //    133
D=M //    134
@SP //    135
A=M //    136
M=D //    137
@SP //    138
M=M+1 //    139
// add
@SP //    140
M=M-1 //    141
A=M //    142
D=M //    143
@SP //    144
M=M-1 //    145
A=M //    146
M=D+M //    147
@SP //    148
M=M+1 //    149
// pop that 2
@THAT //    150
D=M //    151
@2 //    152
D=D+A //    153
@addr //    154
M=D //    155
@SP //    156
A=M-1 //    157
D=M //    158
@addr //    159
A=M //    160
M=D  //    161
@SP //    162
M=M-1 //    163
// push pointer 1
@THAT //    164
D=M //    165
@SP //    166
A=M //    167
M=D //    168
@SP //    169
M=M+1 //    170
// push constant 1
@1 //    171
D=A //    172
@SP //    173
A=M //    174
M=D //    175
@SP //    176
M=M+1 //    177
// add
@SP //    178
M=M-1 //    179
A=M //    180
D=M //    181
@SP //    182
M=M-1 //    183
A=M //    184
M=D+M //    185
@SP //    186
M=M+1 //    187
// pop pointer 1
@SP //    188
A=M-1 //    189
D=M //    190
@THAT //    191
M=D //    192
@SP //    193
M=M-1 //    194
// push argument 0
@ARG //    195
D=M //    196
@0 //    197
A=D+A //    198
D=M //    199
@SP //    200
A=M //    201
M=D //    202
@SP //    203
M=M+1 //    204
// push constant 1
@1 //    205
D=A //    206
@SP //    207
A=M //    208
M=D //    209
@SP //    210
M=M+1 //    211
// sub
@SP //    212
M=M-1 //    213
A=M //    214
D=M //    215
@SP //    216
M=M-1 //    217
A=M //    218
M=M-D //    219
@SP //    220
M=M+1 //    221
// pop argument 0
@ARG //    222
D=M //    223
@0 //    224
D=D+A //    225
@addr //    226
M=D //    227
@SP //    228
A=M-1 //    229
D=M //    230
@addr //    231
A=M //    232
M=D  //    233
@SP //    234
M=M-1 //    235
// goto MAIN_LOOP_START
@MAIN_LOOP_START //    236
0;JMP //    237
// label END_PROGRAM
(END_PROGRAM) //    238
