// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// SETUP
// @24576

// @16384
// @24576
@24575
D=A
@max_addr
M=D

@SCREEN
D=A
@screen_addr
M=D

@max_addr
D=M-D
@max_row
M=D

(LOOP)
    // LOAD KEY VALUE
    @KBD
    D=M

    // @1
    // D=A

    @N_PRESS
    D;JEQ 
        @row_index
        M=0
    
        (FILL_LOOP_BLACK)    
            @max_row
            D=M
            @row_index
            D=D-M
            @FILL_END_BLACK
            D;JLT
                @screen_addr
                D=M
                @row_index
                A=D+M
                M=-1
    
                @row_index
                M=M+1    
            @FILL_LOOP_BLACK
            0;JMP
        (FILL_END_BLACK)

        @N_PRESS_END
        0;JMP
    (N_PRESS)
        @row_index
        M=0

        (FILL_LOOP_WHITE)    
            @max_row
            D=M
            @row_index
            D=D-M
            @FILL_END_WHITE
            D;JLT
                @screen_addr
                D=M
                @row_index
                A=D+M
                M=0

                @row_index
                M=M+1    
            @FILL_LOOP_WHITE
            0;JMP
        (FILL_END_WHITE)

        @N_PRESS_END
        0;JMP
    (N_PRESS_END)

@LOOP
0;JMP