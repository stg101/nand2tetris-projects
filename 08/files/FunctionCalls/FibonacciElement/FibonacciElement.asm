// function Sys.init 0
(Sys.init)
// push constant 4
@4 //    0
D=A //    1
@SP //    2
A=M //    3
M=D //    4
@SP //    5
M=M+1 //    6
// call Main.fibonacci 1
@Main.fibonacci$ret.0 //    7
D=M //    8
@SP //    9
A=M //    10
M=D //    11
@SP //    12
M=M+1 //    13
@LCL //    14
D=M //    15
@SP //    16
A=M //    17
M=D //    18
@SP //    19
M=M+1 //    20
@ARG //    21
D=M //    22
@SP //    23
A=M //    24
M=D //    25
@SP //    26
M=M+1 //    27
@THIS //    28
D=M //    29
@SP //    30
A=M //    31
M=D //    32
@SP //    33
M=M+1 //    34
@THAT //    35
D=M //    36
@SP //    37
A=M //    38
M=D //    39
@SP //    40
M=M+1 //    41
@5 //    42
D=A //    43
@SP //    44
D=M-D //    45
@temp_diff //    46
M=D //    47
@1 //    48
D=A //    49
@temp_diff //    50
D=M-D //    51
@ARG //    52
M=D //    53
@SP //    54
D=M //    55
@LCL //    56
M=D //    57
@Main.fibonacci //    58
0;JMP //    59
(Main.fibonacci$ret.0)
// label WHILE
(WHILE)
// goto WHILE
@WHILE //    60
0;JMP //    61
// function Main.fibonacci 0
(Main.fibonacci)
// push argument 0
@ARG //    62
D=M //    63
@0 //    64
A=D+A //    65
D=M //    66
@SP //    67
A=M //    68
M=D //    69
@SP //    70
M=M+1 //    71
// push constant 2
@2 //    72
D=A //    73
@SP //    74
A=M //    75
M=D //    76
@SP //    77
M=M+1 //    78
// lt
@SP //    79
M=M-1 //    80
A=M //    81
D=M //    82
@SP //    83
M=M-1 //    84
A=M //    85
D=M-D //    86
@94 //    87
D;JLT //    88
@SP //    89
A=M //    90
M=0 //    91
@97 //    92
0;JMP //    93
@SP //    94
A=M //    95
M=-1 //    96
@SP //    97
M=M+1 //    98
// if-goto IF_TRUE
@SP //    99
M=M-1 //    100
A=M //    101
D=M //    102
@IF_TRUE //    103
D;JNE //    104
// goto IF_FALSE
@IF_FALSE //    105
0;JMP //    106
// label IF_TRUE
(IF_TRUE)
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
// return
@LCL //    117
D=M //    118
@endFrame //    119
M=D //    120
@5 //    121
D=A //    122
@endFrame //    123
D=M-D //    124
A=D //    125
D=M //    126
@retAddr //    127
M=D //    128
@ARG //    129
D=M //    130
@0 //    131
D=D+A //    132
@addr //    133
M=D //    134
@SP //    135
A=M-1 //    136
D=M //    137
@addr //    138
A=M //    139
M=D  //    140
@SP //    141
M=M-1 //    142
@1 //    143
D=A //    144
@ARG //    145
D=D+M //    146
@SP //    147
M=D //    148
@1 //    149
D=A //    150
@endFrame //    151
D=M-D //    152
A=D //    153
D=M //    154
@THAT //    155
M=D //    156
@2 //    157
D=A //    158
@endFrame //    159
D=M-D //    160
A=D //    161
D=M //    162
@THIS //    163
M=D //    164
@3 //    165
D=A //    166
@endFrame //    167
D=M-D //    168
A=D //    169
D=M //    170
@ARG //    171
M=D //    172
@4 //    173
D=A //    174
@endFrame //    175
D=M-D //    176
A=D //    177
D=M //    178
@LCL //    179
M=D //    180
@retAddr //    181
A=M //    182
0;JMP //    183
// label IF_FALSE
(IF_FALSE)
// push argument 0
@ARG //    184
D=M //    185
@0 //    186
A=D+A //    187
D=M //    188
@SP //    189
A=M //    190
M=D //    191
@SP //    192
M=M+1 //    193
// push constant 2
@2 //    194
D=A //    195
@SP //    196
A=M //    197
M=D //    198
@SP //    199
M=M+1 //    200
// sub
@SP //    201
M=M-1 //    202
A=M //    203
D=M //    204
@SP //    205
M=M-1 //    206
A=M //    207
M=M-D //    208
@SP //    209
M=M+1 //    210
// call Main.fibonacci 1
@Main.fibonacci$ret.1 //    211
D=M //    212
@SP //    213
A=M //    214
M=D //    215
@SP //    216
M=M+1 //    217
@LCL //    218
D=M //    219
@SP //    220
A=M //    221
M=D //    222
@SP //    223
M=M+1 //    224
@ARG //    225
D=M //    226
@SP //    227
A=M //    228
M=D //    229
@SP //    230
M=M+1 //    231
@THIS //    232
D=M //    233
@SP //    234
A=M //    235
M=D //    236
@SP //    237
M=M+1 //    238
@THAT //    239
D=M //    240
@SP //    241
A=M //    242
M=D //    243
@SP //    244
M=M+1 //    245
@5 //    246
D=A //    247
@SP //    248
D=M-D //    249
@temp_diff //    250
M=D //    251
@1 //    252
D=A //    253
@temp_diff //    254
D=M-D //    255
@ARG //    256
M=D //    257
@SP //    258
D=M //    259
@LCL //    260
M=D //    261
@Main.fibonacci //    262
0;JMP //    263
(Main.fibonacci$ret.1)
// push argument 0
@ARG //    264
D=M //    265
@0 //    266
A=D+A //    267
D=M //    268
@SP //    269
A=M //    270
M=D //    271
@SP //    272
M=M+1 //    273
// push constant 1
@1 //    274
D=A //    275
@SP //    276
A=M //    277
M=D //    278
@SP //    279
M=M+1 //    280
// sub
@SP //    281
M=M-1 //    282
A=M //    283
D=M //    284
@SP //    285
M=M-1 //    286
A=M //    287
M=M-D //    288
@SP //    289
M=M+1 //    290
// call Main.fibonacci 1
@Main.fibonacci$ret.2 //    291
D=M //    292
@SP //    293
A=M //    294
M=D //    295
@SP //    296
M=M+1 //    297
@LCL //    298
D=M //    299
@SP //    300
A=M //    301
M=D //    302
@SP //    303
M=M+1 //    304
@ARG //    305
D=M //    306
@SP //    307
A=M //    308
M=D //    309
@SP //    310
M=M+1 //    311
@THIS //    312
D=M //    313
@SP //    314
A=M //    315
M=D //    316
@SP //    317
M=M+1 //    318
@THAT //    319
D=M //    320
@SP //    321
A=M //    322
M=D //    323
@SP //    324
M=M+1 //    325
@5 //    326
D=A //    327
@SP //    328
D=M-D //    329
@temp_diff //    330
M=D //    331
@1 //    332
D=A //    333
@temp_diff //    334
D=M-D //    335
@ARG //    336
M=D //    337
@SP //    338
D=M //    339
@LCL //    340
M=D //    341
@Main.fibonacci //    342
0;JMP //    343
(Main.fibonacci$ret.2)
// add
@SP //    344
M=M-1 //    345
A=M //    346
D=M //    347
@SP //    348
M=M-1 //    349
A=M //    350
M=D+M //    351
@SP //    352
M=M+1 //    353
// return
@LCL //    354
D=M //    355
@endFrame //    356
M=D //    357
@5 //    358
D=A //    359
@endFrame //    360
D=M-D //    361
A=D //    362
D=M //    363
@retAddr //    364
M=D //    365
@ARG //    366
D=M //    367
@0 //    368
D=D+A //    369
@addr //    370
M=D //    371
@SP //    372
A=M-1 //    373
D=M //    374
@addr //    375
A=M //    376
M=D  //    377
@SP //    378
M=M-1 //    379
@1 //    380
D=A //    381
@ARG //    382
D=D+M //    383
@SP //    384
M=D //    385
@1 //    386
D=A //    387
@endFrame //    388
D=M-D //    389
A=D //    390
D=M //    391
@THAT //    392
M=D //    393
@2 //    394
D=A //    395
@endFrame //    396
D=M-D //    397
A=D //    398
D=M //    399
@THIS //    400
M=D //    401
@3 //    402
D=A //    403
@endFrame //    404
D=M-D //    405
A=D //    406
D=M //    407
@ARG //    408
M=D //    409
@4 //    410
D=A //    411
@endFrame //    412
D=M-D //    413
A=D //    414
D=M //    415
@LCL //    416
M=D //    417
@retAddr //    418
A=M //    419
0;JMP //    420
