// function Main.fibonacci 0
(Main.Main.fibonacci) //    0
// push argument 0
@ARG //    1
D=M //    2
@0 //    3
A=D+A //    4
D=M //    5
@SP //    6
A=M //    7
M=D //    8
@SP //    9
M=M+1 //    10
// push constant 2
@2 //    11
D=A //    12
@SP //    13
A=M //    14
M=D //    15
@SP //    16
M=M+1 //    17
// lt
@SP //    18
M=M-1 //    19
A=M //    20
D=M //    21
@SP //    22
M=M-1 //    23
A=M //    24
D=M-D //    25
@33 //    26
D;JLT //    27
@SP //    28
A=M //    29
M=0 //    30
@36 //    31
0;JMP //    32
@SP //    33
A=M //    34
M=-1 //    35
@SP //    36
M=M+1 //    37
// if-goto IF_TRUE
@SP //    38
M=M-1 //    39
A=M //    40
D=M //    41
@IF_TRUE //    42
D;JNE //    43
// goto IF_FALSE
@IF_FALSE //    44
0;JMP //    45
// label IF_TRUE
(IF_TRUE) //    46
// push argument 0
@ARG //    47
D=M //    48
@0 //    49
A=D+A //    50
D=M //    51
@SP //    52
A=M //    53
M=D //    54
@SP //    55
M=M+1 //    56
// return
@LCL //    57
D=M //    58
@endFrame //    59
M=D //    60
@5 //    61
D=A //    62
@endFrame //    63
D=M-D //    64
A=D //    65
D=M //    66
@retAddr //    67
M=D //    68
@ARG //    69
D=M //    70
@0 //    71
D=D+A //    72
@addr //    73
M=D //    74
@SP //    75
A=M-1 //    76
D=M //    77
@addr //    78
A=M //    79
M=D  //    80
@SP //    81
M=M-1 //    82
@1 //    83
D=A //    84
@ARG //    85
D=D+M //    86
@SP //    87
M=D //    88
@1 //    89
D=A //    90
@endFrame //    91
D=M-D //    92
A=D //    93
D=M //    94
@THAT //    95
M=D //    96
@2 //    97
D=A //    98
@endFrame //    99
D=M-D //    100
A=D //    101
D=M //    102
@THIS //    103
M=D //    104
@3 //    105
D=A //    106
@endFrame //    107
D=M-D //    108
A=D //    109
D=M //    110
@ARG //    111
M=D //    112
@4 //    113
D=A //    114
@endFrame //    115
D=M-D //    116
A=D //    117
D=M //    118
@LCL //    119
M=D //    120
@retAddr //    121
A=M //    122
0;JMP //    123
// label IF_FALSE
(IF_FALSE) //    124
// push argument 0
@ARG //    125
D=M //    126
@0 //    127
A=D+A //    128
D=M //    129
@SP //    130
A=M //    131
M=D //    132
@SP //    133
M=M+1 //    134
// push constant 2
@2 //    135
D=A //    136
@SP //    137
A=M //    138
M=D //    139
@SP //    140
M=M+1 //    141
// sub
@SP //    142
M=M-1 //    143
A=M //    144
D=M //    145
@SP //    146
M=M-1 //    147
A=M //    148
M=M-D //    149
@SP //    150
M=M+1 //    151
// call Main.fibonacci 1
@Main.Main.fibonacci$ret.0 //    152
D=M //    153
@SP //    154
A=M //    155
M=D //    156
@SP //    157
M=M+1 //    158
@LCL //    159
D=M //    160
@SP //    161
A=M //    162
M=D //    163
@SP //    164
M=M+1 //    165
@ARG //    166
D=M //    167
@SP //    168
A=M //    169
M=D //    170
@SP //    171
M=M+1 //    172
@THIS //    173
D=M //    174
@SP //    175
A=M //    176
M=D //    177
@SP //    178
M=M+1 //    179
@THAT //    180
D=M //    181
@SP //    182
A=M //    183
M=D //    184
@SP //    185
M=M+1 //    186
@5 //    187
D=A //    188
@SP //    189
D=M-D //    190
@temp_diff //    191
M=D //    192
@1 //    193
D=A //    194
@temp_diff //    195
D=M-D //    196
@ARG //    197
M=D //    198
@SP //    199
D=M //    200
@LCL //    201
M=D //    202
(Main.Main.fibonacci$ret.0) //    203
// push argument 0
@ARG //    204
D=M //    205
@0 //    206
A=D+A //    207
D=M //    208
@SP //    209
A=M //    210
M=D //    211
@SP //    212
M=M+1 //    213
// push constant 1
@1 //    214
D=A //    215
@SP //    216
A=M //    217
M=D //    218
@SP //    219
M=M+1 //    220
// sub
@SP //    221
M=M-1 //    222
A=M //    223
D=M //    224
@SP //    225
M=M-1 //    226
A=M //    227
M=M-D //    228
@SP //    229
M=M+1 //    230
// call Main.fibonacci 1
@Main.Main.fibonacci$ret.1 //    231
D=M //    232
@SP //    233
A=M //    234
M=D //    235
@SP //    236
M=M+1 //    237
@LCL //    238
D=M //    239
@SP //    240
A=M //    241
M=D //    242
@SP //    243
M=M+1 //    244
@ARG //    245
D=M //    246
@SP //    247
A=M //    248
M=D //    249
@SP //    250
M=M+1 //    251
@THIS //    252
D=M //    253
@SP //    254
A=M //    255
M=D //    256
@SP //    257
M=M+1 //    258
@THAT //    259
D=M //    260
@SP //    261
A=M //    262
M=D //    263
@SP //    264
M=M+1 //    265
@5 //    266
D=A //    267
@SP //    268
D=M-D //    269
@temp_diff //    270
M=D //    271
@1 //    272
D=A //    273
@temp_diff //    274
D=M-D //    275
@ARG //    276
M=D //    277
@SP //    278
D=M //    279
@LCL //    280
M=D //    281
(Main.Main.fibonacci$ret.1) //    282
// add
@SP //    283
M=M-1 //    284
A=M //    285
D=M //    286
@SP //    287
M=M-1 //    288
A=M //    289
M=D+M //    290
@SP //    291
M=M+1 //    292
// return
@LCL //    293
D=M //    294
@endFrame //    295
M=D //    296
@5 //    297
D=A //    298
@endFrame //    299
D=M-D //    300
A=D //    301
D=M //    302
@retAddr //    303
M=D //    304
@ARG //    305
D=M //    306
@0 //    307
D=D+A //    308
@addr //    309
M=D //    310
@SP //    311
A=M-1 //    312
D=M //    313
@addr //    314
A=M //    315
M=D  //    316
@SP //    317
M=M-1 //    318
@1 //    319
D=A //    320
@ARG //    321
D=D+M //    322
@SP //    323
M=D //    324
@1 //    325
D=A //    326
@endFrame //    327
D=M-D //    328
A=D //    329
D=M //    330
@THAT //    331
M=D //    332
@2 //    333
D=A //    334
@endFrame //    335
D=M-D //    336
A=D //    337
D=M //    338
@THIS //    339
M=D //    340
@3 //    341
D=A //    342
@endFrame //    343
D=M-D //    344
A=D //    345
D=M //    346
@ARG //    347
M=D //    348
@4 //    349
D=A //    350
@endFrame //    351
D=M-D //    352
A=D //    353
D=M //    354
@LCL //    355
M=D //    356
@retAddr //    357
A=M //    358
0;JMP //    359
// function Sys.init 0
(Sys.Sys.init) //    360
// push constant 4
@4 //    361
D=A //    362
@SP //    363
A=M //    364
M=D //    365
@SP //    366
M=M+1 //    367
// call Main.fibonacci 1
@Sys.Main.fibonacci$ret.2 //    368
D=M //    369
@SP //    370
A=M //    371
M=D //    372
@SP //    373
M=M+1 //    374
@LCL //    375
D=M //    376
@SP //    377
A=M //    378
M=D //    379
@SP //    380
M=M+1 //    381
@ARG //    382
D=M //    383
@SP //    384
A=M //    385
M=D //    386
@SP //    387
M=M+1 //    388
@THIS //    389
D=M //    390
@SP //    391
A=M //    392
M=D //    393
@SP //    394
M=M+1 //    395
@THAT //    396
D=M //    397
@SP //    398
A=M //    399
M=D //    400
@SP //    401
M=M+1 //    402
@5 //    403
D=A //    404
@SP //    405
D=M-D //    406
@temp_diff //    407
M=D //    408
@1 //    409
D=A //    410
@temp_diff //    411
D=M-D //    412
@ARG //    413
M=D //    414
@SP //    415
D=M //    416
@LCL //    417
M=D //    418
(Sys.Main.fibonacci$ret.2) //    419
// label WHILE
(WHILE) //    420
// goto WHILE
@WHILE //    421
0;JMP //    422
