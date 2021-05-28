# CPC Basic and Z80 adventures 

## Introduction
This is the documentation of my journey into learning Z80 assembly. I typed small BASIC programs back in the day and now I am spicing up with Z80 wizardry.
This is **NOT** a tutorial on Z80 neither a full-detailed guide, it is a practical guide to mess around Z80 and CPC. I wish I had found a document like this but it looks that did not exist, thus I am sharing it for you not to reinvent the wheel again.

I have used Linux but on Windows you can also do it.
I will use WinAPE http://www.winape.net/downloads.jsp running under linux with WINE (sudo apt install wine).
**If you are using a non-english language some characters will be taken as accents by Linux and wont be correctly interpreted by WinAPE. You can use the Autotype function or add English keyboard layout to Linux and change it when writing in WinAPE**
Also I will use iDSK tools https://github.com/cpcsdk/idsk but you can use similar tools.

Binary numbers are composed of binary digits that are 0's or 1's. The conversion to decimal is done by multiplying each digit by the i-th power of two.
The rightmost bit is the least significative bit (LSB) and will have index 0, on the contrary, the leftmost bit is the most signigicative (MSB) and will have the highest index.
For example and 8bit binary number (separated in groups of 4 to be more readable) 0001 0001 corresponds to 1\*2^4+1\*2^0=16+1=17

Hexadecimal is a numbering system that uses base 16 system and offers a compact view of a long binary number. Digits are 0,1,2,3,4,5,6,7,8,9,A,B,C,D,D,E,F and yes letters are used to represent 10,11,12,13,14,15. Thus, we take our friend 0001 0001 and for each group of 4 bytes we take the conversion to hexa 0001 0001 -> 11. FF corresponds to 255 in decimal and 1111 1111 in binary.

For hexadecimal numbers I will use &,#,$,h indistinctively or any other symbol normally used for that. Locomotive BASIC uses &.

These are some of resources I used to on my way to write this.
- CPCWiki, a helpful community https://www.cpcwiki.eu/forum/programming/
- ACPC.me, full of documentation, books, etc, ... https://acpc.me
- Locomotive BASIC https://www.cpcwiki.eu/index.php/Locomotive_BASIC
- For a good Z80 tutorial you can visit https://www.chibiakumas.com/z80/index.php
- Z80 Assembly programming for the Amstrad CPC https://www.chibiakumas.com/z80/AmstradCPC.php
- Soft968 (incomplete) https://www.cpcwiki.eu/index.php/Soft968:_CPC_464/664/6128_Firmware
- Soft968 (full) https://archive.org/details/SOFT968TheAmstrad6128FirmwareManual
- Firmware guide http://www.cantrell.org.uk/david/tech/cpc/cpc-firmware/
- Amstrad CPC464 Whole Memory Guide https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/MELBOURNE_HOUSE/AMSTRAD_CPC464_whole_memory_guide(Don_THOMSON)(acme).pdf
- The Ins and Outs of the Amstrad CPC 464 https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/MELBOURNE_HOUSE/The_Ins_and_Outs_of_the_AMSTRAD_CPC464(Don_THOMSON)(acme).pdf
- Assembly_language_programming_for_the_AMSTRAD_CPC464-664-6128 https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/ARGUS_BOOK/Assembly_language_programming_for_the_AMSTRAD_CPC464-664-6128(AP-DJ_STEPHENSON)(acme).pdf
- The Bible, Programming the Z80 https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/SYBEX/Programming_the_Z80(Rodnay_ZAKS_1982_Edition3Revised)[OCR].pdf
- A nice page with clearly explained Z80 instructions http://www.z80.info/z80code.htm
- Locomotive basic 1.1 disassembly http://www.cpctech.org.uk/docs/basic.asm
- CPC6128 operating system ROM http://www.cpctech.org.uk/docs/os.asm
- Z80 timings https://wiki.octoate.de/lib/exe/fetch.php/amstradcpc:z80_cpc_timings_cheat_sheet.20131019.pdf
- Markdown cheatsheet https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet
- and many others ...


## Index

[BASIC internals](#BASIC-internals)

[Assembly](#Assembly)

[Mixing asm and BASIC](#Mixing-asm-and-BASIC)

[Jumpblock](#Jumpblock)

[RSX](#RSX)

[ROM](#Rom)

[TODOs](#TODOs)

## BASIC internals
[Up](#CPC-Basic-and-Z80-adventures) [Previous](#Index) [Next](#Assembly)

Now let's start and go back to your good old BASIC days and type the following code on WinAPE. If you are new to CPC world, welcome aboard!
It is worth to mention that this is not a BASIC tutorial but BASIC internal decoding and file structure.

```basic
10 REM Hello
20 PRINT "Hello World!"
```

Create a disk on WinAPE (File->Drive A->New blank disk  and set **hello.dsk** as name and format it) if you have not done it or use and existing one (File->Drive A->Insert Disc Image) and save the program with 
```basic
SAVE "hello.bas"
```

This will create a file with AMSDOS header (http://www.cpcwiki.eu/index.php/AMSDOS_Header) with the bytecodes for the BASIC program (https://cpctech.cpcwiki.de/docs/bastech.html)

If you want to save it as ascii (and without AMSDOS header) use
```basic
SAVE "hello.txt",a
```
Now, on WinAPE you can remove the disc with File->Drive A->Remove disk

And go to the command line to use iDSK tool to list the contents of the disk.
```bash
iDSK hello.dsk -l
 
DSK : hello.dsk
HELLO   .BAS 0
HELLO   .TXT 0
------------------------------------
```

Now, we can take a look inside a .BAS file and will report the size of the code in ascii

```
iDSK hello.dsk -b hello.bas

DSK : hello.dsk
Amsdos file : hello.bas
Taille du fichier : 35
10 REM Hello
20 PRINT "Hello World!"
```

Or just
```
iDSK hello.dsk -a hello.txt
DSK : hello.dsk
Amsdos file : hello.txt
Taille du fichier : 1024
10 REM Hello
20 PRINT "Hello World!"

------------------------------------
```

Of course we can also open it with our favourite text editor.

If you load a txt file it will be interpreted as BASIC

```basic
LOAD "hello.txt"
LIST
10 REM Hello
20 PRINT "Hello World!"
```

ASCII is nice and human readable but let's dive into the .BAS file which is much more interesting (Reference on  https://cpctech.cpcwiki.de/docs/bastech.html)

We can use iDSK to see the hex values
```
iDSK hello.dsk -h HELLO.BAS
DSK : hello.dsk
Amsdos file : HELLO.BAS
#0000 0C 00 0A 00 C5 20 48 65 6C 6C 6F 00 15 00 14 00 | ......Hello.....
#0010 BF 20 22 48 65 6C 6C 6F 20 57 6F 72 6C 64 21 22 | .."Hello.World!"
#0020 00 00 00 1A 22 0D 0A 1A 00 00 00 00 00 00 00 00 | ...."...........
```

The command above does not show the first 128 bytes (AMSDOS header) and below you have an explanation of the BASIC bytecode.

```
0c 00                          ; length of data 12 (&0c) bytes
0a 00                          ; line number 10 (&0a)
c5                             ; c5 is REM code
20 48 65 6c 6c 6f              ; string ' Hello' , 20 is blank char and so on
00                             ; end of line marker

15 00                          ; length of data 21 (&15) bytes
14 00                          ; line number 20 (&14)
bf                             ; bf is PRINT code
20 22 48 65 6c 6c 6f           ; string ' "Hello'
20 57 6f 72 6c 64 21 22        ; string ' World!"'
00                             ; end of line marker
00 00                          ; length of line 0 is end of basic program

```

We can also use my python tool bin2txt.py to extract the bytes to a txt file and a lot more things that we will discover soon.

```
python bin2txt.py -f HELLO.BAS --totxt --hexprefix="" --hex --out out.txt --printout
Name:  HELLO   BAS
User:  0
Type:  0 (BASIC)
Length:  35 / 0x23 bytes
Logical length  35 / 0x23 bytes
Entry address  0 / 0x0
Load address:  368 / 0x170
Checksum:  0x361
0c,00,0a,00,c5,20,48,65,6c,6c,6f,00,15,00,14,00,bf,20,22,48,65,6c,6c,6f,20,57,6f,72,6c,64
21,22,00,00,00
```


## Assembly
[Up](#CPC-Basic-and-Z80-adventures) [Previous](#BASIC-internals) [Next](#Mixing-asm-and-BASIC)


And now that we know some things about BASIC, and even we got down to the internal representation of a BASIC program, we are gonna play like the BIG boys, we are gonna play with **Z80 assembly**.

Simplifying, assembly is a list of statements of operation codes (mnemonics) and parameters where these parameters can be numbers or registers. If the parameter in between parentheses "()" indicates it is a memory pointer.

Labels are used to reference lines of code and the assembler will assign an address to them.

```asm
label_init:
;DO THINGS
jp label_init
```

### Registers

Registers are special internal memory of 8-bit. Internally they are in pairs forming a 16-bit register.

The important Z80 8-bit registers are A, B, C, D, E, F, H and L and can store any number from 0 to 255. A set of important 16-bit registers are AF BC DE HL, IX, IY and can store a number from 0 to 65535. Changing H will also affect HL.
There are more registers but for now is enough.

- **A** is also called the "accumulator". It is the primary register for arithmetic operations and accessing memory. It cannot be used to store information as all 8bit calculations are done against this register.

- **BC** B and C form BC pair. B is usually a good option for a 8bit loop and C is usually used for I/O ports. BC pair is usually used to store **length** of a memory block.

- **DE** D and E form DE pair. Similar to BC but it is normally used to store **destination** addresses.

- **HL** The general 16 bit register, it's used pretty much everywhere you use 16 bit registers. It's most common uses are for 16 bit arithmetic and storing the addresses of stuff (strings, pictures, labels, etc.). Note that HL usually holds the original address while DE holds the destination address.

- **IX** Similar to HL but is slower. IX is commonly used as a pointer in instructions LD (IY+d),r LD r,(IY+d) with d from -128 to 27

- **SP** This is the stack pointer where CALL and PUSH store their values.

- **F** Flag register comes in the pair AF. It will be used mainly in conditional operations. Bit 7 is SF sign flag (<0 S=1), bit 6 is ZF zero flag and bit 0 is CF carry flag.

### Instructions
Regarding instructions you will encounter LD, CP, JP, JR, RET, CALL on the following examples.

- **LD**: I would seay this the main instruction, it LOADS or stores to a variable. A register will be used for one-byte numbers and for two-byte numbers, any two-byte register is fine, but HL is usually the best choice. 
    - ld a, 5 ; sets value 5 to accumulator register

- **CP**: Comparison. It compares origin value with register A and sets Z flag to 1 if same values.
    - cp 5    ; compares current value and accumulator

- **JP**: Jump Absolute. Goes to the specified  adress
    - jp 0    ; goes to 0

- **JR**: Jump Relative. Similar to JP, but faster because it takes 2 bytes instead of 3. It is used to jump to near places +-127 bytes and allows relocatable routines :)
    - jr 1    ; goes to next instruction, useless here

- **CALL**: Jumps to a subroutine and the return location is stored in the stack. Thus we can go back from RET. Remember that subroutines are called by a CALL and terminated by a RET. 
    - CALL &bb5a    ; call TXT OUTPUT
    - CALL NZ &bb5a ; call TXT OUPUT if flag Z is not activated 

- **RET**: Pops the stack and jumps to the address stored in the stack. With and argument is a conditional instruction (ret z). It is the best friend of CALL.
    - ret z   ; goes back if Z==1


### Directives
- **org**: Defines where the code starts. References to addresses will change according to this. As seen , JR will not be affected by this value.
    - org &1200
    
- **equ**: Sets a value to a label. Think of it as a constant.
    - five equ 5
    
- **defb**: Sets memory to specified values.
    - defb 20              ; it will store one byte
    - defb "defb example"  ; it will store a sequence of bytes

### Comments
Comments are placed after **;** and I **encourage** you to use them now that you are starting to learn and later when you get experience so you annotate all the dark magic you write. Failing to do so, will get you **exciting** moments trying to guess what you wrote.


For more information on Z80 instructions I find this link extremely clear http://www.z80.info/z80code.htm

### Hello world from the assembly side
The following code prints the "Hello World!" string and have full explanations of what it does.

```asm
        TXT_OUTPUT      equ &bb5a 
	                        ; TXT OUTPUT Output a character or controlcode to the Text VDU
                                ; Info on firmware calls www.cpcwiki.eu/imgs/7/73/S968se14.pdf

        org      &1200          ; our code will start at &1200

main:                         
        ld      hl,message      ; load address of string in HL
        call    printString     ; print it
        ret

printString:
        ld      a,(hl)          ; load char index stored in HL into A
        cp      0               ; if 0 (last char) then Z flag will be set
        ret     z               ; returns if Z flag is set
        inc     hl              ; hl=hl+1
        call    TXT_OUTPUT      ; call TXT_OUTPUT
        jr      printString

message:
        defb    "Hello World!",0 ; String is ended with 0 and prinString will stop on 0
```

It is always safe to put defb after code (especially ret or jump), so this data will not be executed.

We can also use "or a" instead of "cp 0" which is faster, but we are not in a hurry this time. But remember, first make it work, then make it fast and beware of the optimisation bugs included.

Once you have taken a look to the asm code, let's put it into WinAPE (Assembler->Show assembler), copypaste it and then assemble it (Ctrl+F9). If all was correct it should give 0 errors.

WinAPE shows the binary digits generated for this program

```asm
WinAPE Z80 Assembler V1.0.13

000001  0000  (BB5A)                TXT_OUTPUT      equ &bb5a 
000002  0000                	                        ; TXT OUTPUT Output a character or controlcode to the Text VDU
000003  0000                                                ; Info on firmware calls www.cpcwiki.eu/imgs/7/73/S968se14.pdf
000005  0000  (1200)                org      &1200          ; our code will start at &1200
000007  1200                main
000008  1200  21 10 12              ld      hl,message      ; load address of string in HL
000009  1203  CD 07 12              call    printString     ; print it
000010  1206  C9                    ret
000012  1207                printString
000013  1207  7E                    ld      a,(hl)          ; load char index stored in HL into A
000014  1208  BF                    cp      0               ; if 0 then Z flag will be set
000015  1209  C8                    ret     z               ; returns if Z flag is set
000016  120A  23                    inc     hl              ; hl=hl+1
000017  120B  CD 5A BB              call    TXT_OUTPUT      ; call TXT_OUTPUT
000018  120E  18 F7                 jr      printString
000020  1210                message
000021  1210  48 65 6C 6C           defb    "Hello World!",0 ; String is ended with 0 and prinString will stop on 0
        1214  6F 20 57 6F 
        1218  72 6C 64 21 
        121C  00 
```

The generated code goes from &1200 to &121C, having a size of &1D (20 in decimal) bytes.
The first instruction at address &1200 is 21 10 12 that corresponds to LD HL,nn instruction (code &21) and address 1210 (first byte after operation code 10 is least significant one). You can check instruction codes at http://map.grauw.nl/resources/z80instr.php

And to run it call starting address (&1200) from BASIC as we set org &1200 in the asm code.
```basic
call &1200
```
If everything was fine, now you are seeing "Hello world!" on the screen.

Now save as a binary file starting at &1200 and size &1D (29).
save "hello.bin",b,&1200,&1D

But an easier way is to tell the assembler to write it for us. Then, we can add it to a dsk file with WinAPE or iDSK.

```asm
write "hello.bin"
```

iDSK can disassemble the program but it does not know that there is a string starting at &1200, so it will interprete these bytes as Z80 instructions :) Take into account that these defb regions sholud not be executed. In this example there is a jump just before the defb and this help us to keep things right.

```
iDSK hello.dsk -z hello.bin
DSK : hello.dsk
Amsdos file : hello.bin
Taille du fichier : 29
1200 21 10 12       LD HL,1210
1203 CD 07 12       CALL 1207
1206 C9             RET
1207 7E             LD A,(HL)
1208 BF             CP A
1209 C8             RET Z
120A 23             INC HL
120B CD 5A BB       CALL BB5A    ; TXT_OUTPUT
120E 18 F7          JR 1207      ; This jump prevents going into defb area
1210 48             LD C,B       ; This is a string but iDSK does not know it
1211 65             LD H,L       ; and interprets it as instructions
1212 6C             LD L,H
1213 6C             LD L,H
1214 6F             LD L,A
1215 20 57          JR NZ,126E
1217 6F             LD L,A
1218 72             LD (HL),D
1219 6C             LD L,H
121A 64             LD H,H
121B 21 00 1A       LD HL,1A00

```
iDSK can also show and hexadecimal view of the file.

```
iDSK hello.dsk -h hello.bin
DSK : hello.dsk
Amsdos file : hello.bin
#0000 21 10 12 CD 07 12 C9 7E BF C8 23 CD 5A BB 18 F7 | !.........#.Z...
#0010 48 65 6C 6C 6F 20 57 6F 72 6C 64 21 00 1A 00 00 | Hello.World!....
```

bin2txt.py script can also extract hex values that can be pasted on  https://onlinedisassembler.com
```
python bin2txt.py --file  hello.bin --totxt  --hex --hexprefix="" --sep=" " --linesize 16 --printout --out hello_bin.txt
21 11 12 cd 07 12 c9 7e fe 00 c8 23 cd 5a bb 18
f6 48 65 6c 6c 6f 20 57 6f 72 6c 64 21 00
```

Ok, we saved the file, switch off the computer, but next day we want to load it.
First, we need reserve memory and as we will be using the program at &1200, the last BASIC memory will be one bye less, i.e. &11FF. Then we LOAD an CALL.

```basic
MEMORY &11FF
LOAD "hello.bin", &1200
CALL &1200
```
If MEMORY is not set, we will get "Memory full" message.

### Memory
We have already used memory address &1200 which is in the area of BASIC (0170-HIMEM) and later we will use functions from the jumpblock (bb5a) and RST routines (0008). This table shows you the memory layout.

| RAM | ROM | External |
|-|-|-|
| FFFF-C000 Screen memory (16k) | 16k Upper ROM (BASIC) | 16k max. 252 ext ROMS |
| BFFF-B100 Stack, firmware and jumblock | 3FFF-0000 16k firmware ROM |  |
| B0FF-AC00 BASIC Workspace |  |  |
| -ABFF Background data (&500 bytes used by AMSDOS if present) |  |  |
| -     User defined graphics |  |  |
| -     Space for machine code routines |  |  |
| - HIMEM Strings area |  |  |
| -     FREE SPACE (used by AMSDOS for loading and saving) |  |  |
| -     Arrays area |  |  |
| -     Variables and DEF FNs area |  |  |
| -0170 Program area |  |  |
| 016F-0040 Foreground workspace |  |  |
| 003F-0000 RST routines |  |  |

## Mixing asm and BASIC
[Up](#CPC-Basic-and-Z80-adventures) [Previous](#Assembly) [Next](#Jumpblock)

### BASIC from asm

Now we know a little bit of assembly and we have also seen how a BASIC code is stored in memory.

So the next question is, could it be possible to "write" BASIC code from asm?
Yes, it is.

For this example I will use code borrowed from USIFAC card and we will write our HELLO.BAS directly from asm. (USIFAC is a Serial interface board and much more. Take a look at https://www.cpcwiki.eu/forum/amstrad-cpc-hardware/usifac-iimake-your-pc-or-usb-stick-an-hdd-for-amstrad-access-dsk-and-many-more!/)

It is important to remember that BASIC programs start at &170 (see memory table above). The following program takes a bytes representing a BASIC program and copies them on 170. We have already shoewn that these bytes can be extracted with iDSK hello.dsk -h hello.bas

Before we commented that HL register is normally used for general purpose or **source**, DE for **DEstination** and BC for **length**. Here we have an example.

```asm
data_size equ 39                                ; size of BASIC file, we know it is 39 bytes
addr    equ &170                                ; BASIC files normally start at 170, let's write in this area
org	&1200                                   ; and store our program in &1200

main:
                                                ; we will use 16-bit registers (hl, de, ... to deal with memory addresses that take 2 bytes &AABB)
	ld	hl, basic_code                  ; hl = address where basic_code is starts, i.e. org + something but the assembler does it for us
	ld 	de, addr                        ; de = &170
	ld	bc, data_size                   ; bc = data size
	ldir                                    ; ldir copies a block from hl address to de address of length bc (i.e. memcpy)
        ret                                     ; do not forget to go back from call
	
basic_code:
defb  &0c,&00,&0a,&00,&c5,&20,&48,&65,&6c,&6c,&6f,&00,&15,&00,&14,&00
defb  &bf,&20,&22,&48,&65,&6c,&6c,&6f,&20,&57,&6f,&72,&6c,&64,&21,&22
defb  &00,&00,&00
```

Basic code can be easily extracted using bin2txt:
```
python bin2txt.py --file  HELLO.BAS --totxt  --prefix defb --hex --linesize 16 --printout  
Name:  HELLO   BAS
User:  0
Type:  0 (BASIC)
Length:  35 / 0x23 bytes
Logical length  35 / 0x23 bytes
Entry address  0 / 0x0
Load address:  368 / 0x170
Checksum:  0x361
defb  &0c,&00,&0a,&00,&c5,&20,&48,&65,&6c,&6c,&6f,&00,&15,&00,&14,&00
defb  &bf,&20,&22,&48,&65,&6c,&6c,&6f,&20,&57,&6f,&72,&6c,&64,&21,&22
defb  &00,&00,&00
```

Now compile it, execute it with CALL, type LIST command and our Hello World! code will appear. Of course you can also RUN it.

```
list
Ready
CALL &1200
Ready
list
10 REM Hello
20 PRINT "Hello World!"
Ready
RUN
Hello World!
Ready
```

And what about running the BASIC program from asm? Well, we will do this later.



### asm from BASIC
Another way to mix BASIC and asm is to embed machine code into BASIC.
Machine code is entered by DATA statements and a READ loop will POKE these values into memory. Then CALL at the required address and you are done.

And it is possible to automagically convert your binary file into bas using the following command

```
python bin2txt.py --file  hello.bin --totxt  --prefix="DATA " --hex --hexprefix=""  --linesize 16 --printout  --basicLoader --callAddress "&1200"
```

And here is the results

```basic
10 REM MACHINE CODE LOADER
20 size= 30
30 addr= &1200
40 FOR b=0 TO size-1: READ a$:POKE addr+b,VAL("&"+a$):NEXT
50 CALL  &1200
60 DATA   21,11,12,cd,07,12,c9,7e,fe,00,c8,23,cd,5a,bb,18
70 DATA   f6,48,65,6c,6c,6f,20,57,6f,72,6c,64,21,00
```

And of course you can use it without the loader

```
python bin2txt.py --file  hello.bin --totxt --hex --hexprefix="&" --prefix DATA --linesize 16 --printout 
DATA  &21,&11,&12,&cd,&07,&12,&c9,&7e,&fe,&00,&c8,&23,&cd,&5a,&bb,&18
DATA  &f6,&48,&65,&6c,&6c,&6f,&20,&57,&6f,&72,&6c,&64,&21,&00
```

We could get rid of VAL("&"+a$) and just use a number if we have data already converted to decimal.

```
python bin2txt.py --file  hello.bin --totxt  --prefix DATA --linesize 16 --printout 
DATA   33, 17, 18,205,  7, 18,201,126,254,  0,200, 35,205, 90,187, 24
DATA  246, 72,101,108,108,111, 32, 87,111,114,108,100, 33,  0
```

### References
- https://www.sean.co.uk/books/amstrad/amstrad7.shtm
- https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/VIRGIN/Machine_code_routines_for_your_AMSTRAD(Clive_GIFFORD_Scott_VINCENT_autographed)(acme).pdf
- https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/MICRO_PRESS/Machine_Code_for_Beginners_on_the_AMSTRAD(Steve_KRAMER)(acme).pdf
- https://acpc.me/ACME/LITTERATURE_LIVRES/[ENG]ENGLISH/ARGUS_BOOK/Assembly_language_programming_for_the_AMSTRAD_CPC464-664-6128(AP-DJ_STEPHENSON)(acme).pdf


## Jumpblock

[Up](#CPC-Basic-and-Z80-adventures) [Previous](#Mixing-asm-and-BASIC) [Next](#RSX)

In the examples above you have noticed that we have used CALL &XXXX. These are calls to utilities provided by the firmware such as printing a char in screen. In particular, this function is called from &BB5A and is known as TXT OUTPUT. Different computers can have different addresses for the firmware function but a solution to have a common entry point is to share a common address and then jump from there to the routine code. This set of jumps is known as jumpblock.

Jumpblock is located at B100-BFFF. For more info check Soft968 Chapter 2. ROMs, RAM and the Restart Instructions (http://www.cpcwiki.eu/imgs/f/f6/S968se02.pdf)
 Chapter 14. Firmware jumpblocks https://cpctech.cpcwiki.de/docs/manual/s968se14.pdf and Chapter 18 The Low Kernel Jumpblock .https://cpctech.cpcwiki.de/docs/manual/s968se18.pdf

With this BASIC code we get the instructions executed when calling &bb5a (or you can "Pause" WinAPE and go to address &bb5a).

```basic
10 a=PEEK(&bb5a)
20 b=PEEK(&bb5b)
30 c=PEEK(&bb5c)
40 print hex$(a),hex$(b),hex$(c)
CF FE 93
```

So the jumpblock call for bb5a is CF FE 93 where CF corresponds to RST 1 instruction that jumps to &0008 where resides LOW JUMP. The next two bytes (FE 93) are interpreted as the destination address where the last significant byte is first (see http://www.cantrell.org.uk/david/tech/cpc/cpc-firmware/firmware.pdf pg.38). RST instruction is used to jump to an address in just 1 cycle and is equivalent to CALL &00XX. 

```
001   &0008   LOW JUMP (RST 1)
      Action: Jumps to a routine in either the lower ROM or low RAM
      Entry:  No entry conditions - all  the  registers are passed to
              the destination routine unchanged
      Exit:   The registers are as set  by  the  routine in the lower
              ROM or RAM or are returned unaltered
      Notes:  The RST 1 instruction  is  followed  by  a two byte low
              address, which is defmed as follows:
                if bit 15 is set, then the upper ROM is disabled
                if bit 14 is set, then the lower ROM is disabled
                bits 13 to 0 contain the address of the routine to
                  jump to
              This command is used by the  majority of entries in the
              main firmware jumpblock
```

Thus, 93 fe corresponds to value 93fe that after removing bit15 and bit14 results in address 13fe. If you are interested in the TXT OUTPUT routine check firmware disassembly at &13fe http://cpctech.cpc-live.com/docs/os.asm

```
      93       FE
-> 1001 0011 1111 1110
   ||      
   |-lower ROM enabled
   -upper ROM disabled
```

Now image that we want to print only uppercase characters, so we will need to modify the jumblock for &bb5a, then subtract 32 to any character between 'a' and 'z' and call the original routine. Take into account that we have not to corrupt any register that could be in use. From the documentation of bb5a we know takes register A as input and preserves other registers at output, thus, we should behave in the same way and we will use push and pop instructions.

The code for our uppercase function will be:
	      
``` asm	      
org &1200

;overwrite jumbplock at bb5a
;we should preserve all registers
push hl
ld l, &c3                       ; jp code 
ld (&bb5a), hl
ld hl, uppercase_txt_output     ; address of new code
ld (&bb5b), hl
pop hl

; A-Z chars range from 65 to 90
; a-z chars range from 97 to 122
;there is an offset of 32 for upper-lower

uppercase_txt_output:
cp 'a'                 ; A-'a'   C=1 if A<'a'
jr c, not_lowercase    ; if character < 'a' is not a lowercase
cp 'z'+1               ; A-'z'+1 C=0 if A>'z'  
jr nc, not_lowercase   ; if character > 'z' is not a lowercase
sub 32                 ; sub 32 to convert it to UPPER case

not_lowercase:
defb &cf,&fe,&93 ; call original jumpblock for TXT OUTPUT

ret
```

Call it from BASIC and you will see messages uppercased 
```
call &1200
READY
10 print "hello"
run
HELLO
READY
```
but if you Pause on WinAPE and look for "hello" (F7) it will in lowercase.


We can also use parameters in CALL and for example CALL &1200,0 to restore the original function. Register A has the number of parameters, and IX has the list of parameters. The first parameter is stored in IX(0) and IX(1), the second in IX(2) and IX(3) and so on.  (See more info on CALL parameters http://www.cpcwiki.eu/index.php?title=Technical_information_about_Locomotive_BASIC&mobileaction=toggle_view_desktop)

``` asm	      
org &1200

cp 1                            ; check number of parameters of external call
jp nz, install                  ; if no params install
ld a,(ix+0)                     ; our param value is 8bit, so here ix+1 is not needed
cp 0
jc nc, restore                  ; if param1 == 0 then restore

restore:
push hl
ld l, &cf                       ; rst
ld (&bb5a), hl
ld hl, &93fe                    ; original bytes
ld (&bb5b), hl
pop hl
ret                             ; all done

install:
;overwrite jumbplock at bb5a
;we should preserve all registers
push hl
ld l, &c3                       ; jp code 
ld (&bb5a), hl
ld hl, uppercase_txt_output     ; address of new code
ld (&bb5b), hl
pop hl

; A-Z chars range from 65 to 90
; a-z chars range from 97 to 122
;there is an offset of 32 for upper-lower

uppercase_txt_output:
cp 'a'                 ; A-'a'   C=1 if A<'a'
jr c, not_lowercase    ; if character < 'a' is not a lowercase
cp 'z'+1               ; A-'z'+1 C=0 if A>'z'  
jr nc, not_lowercase   ; if character > 'z' is not a lowercase
sub 32                 ; sub 32 to convert it to UPPER case

not_lowercase:
defb &cf,&fe,&93 ; call original jumpblock for TXT OUTPUT

;defb &cf,&c5,&9b ; call original jumpblock for KM READ CHAR   BB09
;defb &cf,&e1,&9c ; call original jumpblock for KM READ KEY   BB1B

ret
```

## RSX
[Up](#Index) [Previous](#Jumpblock) [Next](#Rom)

We already know about BASIC, asm and jumpblocks where we bypassed TXT OUTPUT. Let's dive even deeper and explore RSX.

RSX commands are preceded by the pipe "|" symbol and are a way to extend BASIC commands. Probably you know |TAPE and |DISC an even |BASIC but now we have the opportunity to implement our own RSX.

RSX structure is the following:
 - Installation routine which calls KL LOG EXT
 - 4 empty bytes for kernel workspace
 - Jumblock address
 	- Jumpblock
 - Command names. Last byte of each string has bit7 = 1. Last command is the end of table marker **0**
 - Code for commands 
 
In the installation routine we register our commands by calling KL LOG EXT with the address of the jump table in register BC and, the address of 4 bytes space in HL.  
 
We will take the example at  https://www.cpcwiki.eu/index.php/Programming:An_example_to_define_a_RSX to write our Hello World RSX edition, ouyeah!


```asm
; RSX Hello World

.kl_log_ext equ &bcd1

;; this can be any address in the range &0040-&a7ff.
org &8000

;;-------------------------------------------------------------------------------
;; install RSX

ld hl, work_space		;;address of a 4 byte workspace useable by Kernel
ld bc, jump_table		;;address of command name table and routine handlers
jp kl_log_ext		        ;;Install RSX's

.work_space                ;Space for kernel to use
defs 4
;;-------------------------------------------------------------------------------
;; RSX definition

.jump_table
defw name_table            ;address pointing to RSX commands 

                           ;list of jump commands associated with each command
                           
                           ;The name (in the name_table) and jump instruction
                           ;(in the jump_table), must be in the same
                           ;order.

                           ;i.e. the first name in the name_table refers to the
                           ;first jump in the jump_table, and vice versa.

jp rsx_hello           ;routine for COMMAND1 RSX
jp rsx_bye           ;routine for COMMAND2 RSX


;; the table of RSX function names
;; the names must be in capitals.

.name_table
defb "HELL","O"+&80     ;the last letter of each RSX name must have bit 7 set to 1.
defb "BY","E"+&80     ;This is used by the Kernel to identify the end of the name.
                      ;as you see +&80 does the trick

defb 0                     ;end of name table marker

; Code for the example RSXs

.rsx_hello                           ; we use a point at the beginning instead of colon at end
        ld      hl,hello_message      ; load address of string in HL
        call    printString     ; print it        
ret

.rsx_bye
        ld      hl,bye_message      ; load address of string in HL
        call    printString     ; print it        
ret


        TXT_OUTPUT      equ &bb5a

printString:
        ld      a,(hl)          ; load char pointed by HL into A
        cp      0               ; if 0 then Z flag will be set
        ret     z               ; returns if Z flag is set
        inc     hl              ; increase pointer
        call    TXT_OUTPUT      ; call TXT_OUTPUT
        jr      printString


hello_message:
defb "Hello World from RSX!",0

bye_message:
defb "See you soon!",0
```

If everything was ok we will see this text:
```basic
|HELLO
Hello World from RSX!
Ready
|BYE
See you soon!
Ready
```
RSX allows parameters and will be 2-byte numbers or strings. Byte 0 of the string will be the length and byte 1-2 the address of the string. Register A contains the number of parameters and IX the address of parameters.

In BASIC 1.0 (CPC464) parameters are passed in a variable and in BASIC 1.1 it is also possible to write them directly

```basic
REM BASIC 1.0
a$="*.BAS":|DIR,@a$

REM BASIC 1.1
|DIR,"*.BAS" 
``` 

For more info check http://www.cpcwiki.eu/index.php?title=Technical_information_about_Locomotive_BASIC&mobileaction=toggle_view_desktop#Passing_parameters_to_a_RSX_.28Resident_System_Extension.29_command_or_binary_function

### TODOs
|REFNUM,@CHARTRING$,INDEXNUM,@REFNUM
RSX with parameters.
Can RSX return value???

### References
For a more detailed information and to know all the insights check the following references.
[968] Soft968 Chapter 10. Expansion ROMs, Resident System Extensions and RAM Programs https://www.cpcwiki.eu/imgs/f/f6/S968se10.pdf
[EXA] RSX example https://www.cpcwiki.eu/index.php/Programming:An_example_to_define_a_RSX
[ANA] RSX Anatomy https://cpcrulez.fr/coding_RSX-anatomy_of_an_RSX-part_1_AA.htm

## ROM
[Up](#Index) [Previous](#RSX)

And after doing our first RSX it is time to go for ROMs. In particular we will explore Foreground Roms that contain one or more programs. The on-board BASIC is the default foreground program.

The structture is similar to an RSX but we will need an initalization routine. Upper ROM are located at C000.

The first four bytes will be the following:
- ROM type: 0 for foreground, 1 for background, 2 for extension (onboard ROM is type &80)
- ROM Mark number
- ROM Version number
- ROM Modification level

After, there will be a jumplock (sequence of JP instructions) beginning with the entry to the initialisation routine and then jumps that match the external command words. Finally the name table with a list of commands where the last byte of these command names will have the bit 7 set to 1 (value+&80) being 0 the last command.

- Address of command name table (2bytes)
- Jumpblock entry 0
- Jumpblock entry 1
- ...
- Name of command for entry 0
- Name of command for entry 1
- ...
- 0 to specify end of name table

In constrast to RSX the first entry of the jumpblock is called automatically by the kernel.

And the code for a Hello World foreground ROM will be this:
```asm
TXT_OUTPUT      equ &bb5a 
ORG #C000       ; Start of ROM
write "HELLO.ROM"

	; ROM header			
	defb 1			;Background ROM
	defb 0			;Mark 0
	defb 5			;Version 5
	defb 0			;Modification 0
	defw NAME_TABLE		;Address of name table


RSXTable:
	defw RSXNames  ;define word because address takes 2 bytes
	jp Bootup      ; power-up entry
	jp rsx_hello   ; function 1
	jp rsx_bye     ; function 2


RSXNames:
	defb "HELLO INI","T"+&80 ; Putting a blank makes it imposible to call from BASIC, if we want that
        defb "HELL","O"+&80     ;the last letter of each RSX name must have bit 7 set to 1.
	defb "BY","E"+&80     ;This is used by the Kernel to identify the end of the name.

	db 0                     ;end of name table marker


Bootup:
	push 	af
	push 	bc
	push 	de
	push 	hl
	ld 	hl, boot_message
                call printString
	pop 	hl
	pop 	de
	pop 	bc
	pop 	af
	ret

printString:
        ld      a,(hl)          ; load char index stored in HL into A
        cp      0               ; if 0 then Z flag will be set
        ret     z               ; returns if Z flag is set
        inc     hl              ; hl=hl+1
        call    TXT_OUTPUT      ; call TXT_OUTPUT
        jr      printString


; Code for the example RSXs

.rsx_hello                           ; here  we use a point at the beginning instead of colon at end
        ld      hl,hello_message      ; load address of string in HL
        call    printString     ; print it        
ret

rsx_bye:
        ld      hl,bye_message      ; load address of string in HL
        call    printString     ; print it        
ret

boot_message:
	defb " Hello World from ROM!",13,10,13,10,0

hello_message:
	defb "Hello World from RSX!",0

bye_message:
	defb "Bye!",0
```
With write "HELLO.ROM" the assembler saves it to a file. Then on WinAPE we go to Setup->Memory->ROM and select for example Upper 5 and Select File...

If all was ok we will see the sentence Hello World from ROM! before the Ready message. 

If we want to check what is doing we can go to WinAPE Debugger and select Memory->Any Rom->UpperROM and select slot 5.

BASIC is the default foreground program (http://cpctech.cpc-live.com/docs/basic.asm) and has a header for a foreground ROM, not a real jumptable but the boot function and only command name |BASIC, try it.

```asm
; Disassembly of Locomotive BASIC v1.1
; 

defb &80		;; foreground rom
defb &01
defb &02
defb &00

defw &c040		;; name table

;BOOT_FUNCTION

c040
defb "BASI","C"+&80			;; |BASIC
```

### Model detection ROM
At this moment you may be tired of the Hello World example. While it is a good example to start learning I feel it is moment for including more advanced things. So let's add model detection capability to our ROM.
I will borrow again some code from Amstrad diagnostics, in particular the model detection function can be found on (https://github.com/llopis/amstrad-diagnostics/blob/main/src/Model.asm) and some other utilities.

The language detection is done by analizing the good old known boot message that for an English CPC6128 is *Amstrad 128K Microcomputer (v3)*, being **v** for English ROM, **s** for Spanish and **f** for French. The model can be detected by checking the digit next to the language letter and it is expected to be **1** for our lovely coloured-keys CPC464, **2** for CPC664 and **3** for CPC6128.

Other differences in ROMs are found at byte &0006. CPC6128 has &0591, CPC 664 &7B05 and CPC464 &0580

And now the trick is to go to the address where this message resides and check it and according to http://cpctech.cpc-live.com/docs/os.asm or even inspecting the ROM with WinAPE Debugger Memory->Any Rom->Lower and look for "Microcomputer" or just a simple hexviewer. Thus, layout letter is found at &069e and model is the next byte at &069f.
Machine name can be get by inspecting LK1-LK3 internal switches and code is found at &0723

```asm
;;======================================================================

0677 210202    ld      hl,$0202
067a cd7011    call    $1170			; TXT SET CURSOR

067d cd2307    call    $0723			; get pointer to machine name (based on LK1-LK3 on PCB)

0680 cdfc06    call    $06fc			; display message

0683 218806    ld      hl,$0688			; "128K Microcomputer.." message
0686 1874      jr      $06fc            ; 

0688 
defb " 128K Microcomputer  (v3)"
defb &1f,&02,&04
defb "Copyright"
defb &1f,&02,&04
defb &a4								;; copyright symbol
defb "1985 Amstrad Consumer Electronics plc"
defb &1f,&0c,&05
defb "and Locomotive Software Ltd."
defb &1f,&01,&07
defb 0
;...

;;-----------------------------------------------------------------------
;; get a pointer to the machine name
;; HL = machine name
0723 06f5      ld      b,$f5			;; PPI port B input
0725 ed78      in      a,(c)
0727 2f        cpl     
0728 e60e      and     $0e				;; isolate LK1-LK3 (defines machine name on startup)
072a 0f        rrca    
;; A = machine name number
072b 213807    ld      hl,$0738			; table of names
072e 3c        inc     a
072f 47        ld      b,a

;; B = index of string wanted

;; keep getting bytes until end of string marker (0) is found
;; decrement string count and continue until we have got string
;; wanted
0730 7e        ld      a,(hl)			; get byte
0731 23        inc     hl
0732 b7        or      a				; end of string?
0733 20fb      jr      nz,$0730         ; 

0735 10f9      djnz    $0730            ; (-$07)
0737 c9        ret   

;...

;; start-up names
0738 
defb "Arnold",0							;; this name can't be chosen
defb "Amstrad",0
defb "Orion",0
defb "Schneider",0
defb "Awa",0
defb "Solavox",0
defb "Saisho",0
defb "Triumph",0
defb "Isp",0

```

So we have located all the memory positions we need to explore but this time we want to read ROM instead of RAM, interesting and for that we will access the Gate Array at address &7F00. The Gate Array is a special chip that manages screen, interrupt and memory which is our now interest. Bits 7-5 select the register and bits 4-0 set the value. In this occasion we will set bits 7-6 to 10 (Register 2) that controls ROM configuration and screen mode with negated bit 3 to enable Upper ROM, negated bit 2 to enable Lower ROM and bits 2-1 for mode. 
So we just have to set register 2 with Lower Rom enabled and mode 1 with the following value 10001001.

IN, OUT instructions are used to communicate to other systems. In the following example, first we set register BC to  &7F00 | %10001001 or #7F89 being the high byte B=#7F and C=#89
We will use OUT (C),r that places r in the address stored **BC** (Yes, I got a funny time until I discovered in this case (C) means (BC) :) ). In the following case OUT (C),C sets the configuration byte which is C into the address of **BC** even that the mnemonic is (c).

It also happens that the low byte is ignored for addressing, this &7FXX will select the gate array
From https://www.cpcwiki.eu/index.php/Gate_Array we see that The gate array is selected when bit 15 of the I/O port address is set to "0" and bit 14 of the I/O port address is set to "1". The values of the other bits are ignored. However, to avoid conflict with other devices in the system, these bits should be set to "1". 


```asm
ld 	bc, &7F00 | %10001001                  ; GA select lower rom, and mode 1
out 	(c),c                                  ; 8 top bits (B) for address, 
```
Similarly, IN r,(C) gets data from address BC. The following code reads PPI Port B register at address &F5XX by first setting the high byte &F5 of the address to B (the low byte XX is IGNORED) and gets a value from BC address into A.

```asm
 ld      b,&f5			;; PPI port B input
 in      a,(c)
```


It is also the first time here we deal with IX register and we will make use of their pointer facilities to load 2 bytes into HL starting at IX address.

```asm
;  Code from github.com/llopis/amstrad-diagnostics

;; IN  - Address to read
;; OUT - HL: Contents of address
@ReadFromLowerROM:
	ld 	bc, #7F00 | %10001001                  ; GA select lower rom, and mode 1
	out 	(c),c                                  ; 8 top bits (B) for address, 
	ld	l, (ix)
	ld	h, (ix+1)
	ld 	bc, RESTORE_ROM_CONFIG
	out 	(c),c
	ret
	DEFINE RESTORE_ROM_CONFIG #7F00 + %10001001
```

Ok, this is getting longer than expected but we are not the noobs we were at the beginning of this document and we reached till here in order to select a Lower ROM and read info about vendor, model and language.

```asm
; RSX Hello World

.kl_log_ext equ &bcd1

;; this can be any address in the range &0040-&a7ff.
org &8000

;;-------------------------------------------------------------------------------
;; install RSX

ld hl, work_space		;;address of a 4 byte workspace useable by Kernel
ld bc, jump_table		;;address of command name table and routine handlers
jp kl_log_ext		;;Install RSX's

.work_space                ;Space for kernel to use
defs 4
;;-------------------------------------------------------------------------------
;; RSX definition

.jump_table
	defw name_table            ;address pointing to RSX commands 

                           ;list of jump commands associated with each command
                           
                           ;The name (in the name_table) and jump instruction
                           ;(in the jump_table), must be in the same
                           ;order.

                           ;i.e. the first name in the name_table refers to the
                           ;first jump in the jump_table, and vice versa.

	jp rsx_hello           ;routine for COMMAND1 RSX
	jp rsx_bye           ;routine for COMMAND2 RSX
                jp rsx_model


;; the table of RSX function names
;; the names must be in capitals.

.name_table
	defb "HELL","O"+&80     ;the last letter of each RSX name must have bit 7 set to 1.
	defb "BY","E"+&80     ;This is used by the Kernel to identify the end of the name.
                                                 ;as you see +&80 does the trick
	defb "MODE","L"+&80 
	defb 0                     ;end of name table marker

; Code for the example RSXs

.rsx_hello                           ; we use a point at the beginning instead of colon at end
        ld      hl,hello_message      ; load address of string in HL
        call    printString     ; print it        
ret

.rsx_bye
        ld      hl,bye_message      ; load address of string in HL
        call    printString     ; print it        
ret

.rsx_model



;in this example we will skip Plus computers
; as homework you can include the needed code, but who cares about Plus?
.notPlus
	ld	ix, #0006
	call	ReadFromLowerROM
	ld	a, l
	cp	#91
	jr	nz, not6128
	ld	a, h
	cp	#05
	jr	nz, not6128

	;; 6128
	ld	a, MODEL_CPC6128
	ld	(ModelType), a

	ld	ix, #069E
	call	ReadFromLowerROM
	;; Check that the word we read is 'x3' where x is the language. If the 3 isn't there, leave it in English
	ld	a, h
	cp	'3'
	jr	nz, englishKeyboard
	jr	checkLanguageFromVersionString


.not6128
	ld	ix, #0683
	call	ReadFromLowerROM
	ld	a, h

	;; 464 or 664
	cp	'2'
	jr	nz, not664

	;; 664
      	ld	a, MODEL_CPC664
	ld	(ModelType), a
	jr	englishKeyboard

	;; 464
.not664
	ld	ix, #0682
	call	ReadFromLowerROM
	ld	a, h
	cp	'1'
	jr	z, Is464

      	ld	a, MODEL_UNKNOWNCPC
	ld	(ModelType), a
	jr	englishKeyboard

.Is464
      	ld	a, MODEL_CPC464
	ld	(ModelType), a

.checkLanguageFromVersionString
	ld	a, l
	cp	's'
	jr	z, spanishKeyboard

	ld	a, l
	cp	'f'
	jr	z, frenchKeyboard

	jr printResults

.englishKeyboard	
	ld	a, KEYBOARD_LANGUAGE_ENGLISH
	ld	(KeyboardLanguage), a
	ret

.spanishKeyboard
	ld	a, KEYBOARD_LANGUAGE_SPANISH
	ld	(KeyboardLanguage), a
	ret

.frenchKeyboard
	ld	a, KEYBOARD_LANGUAGE_FRENCH
	ld	(KeyboardLanguage), a
	ret

;now print the results

.printResults
ld hl, model_txt
call printString

	ld	a, (ModelType)
	ld	e, a
	ld	d, 0
	ld	hl, ModelNameTableOffset
	add	hl, de
	ld	a, (hl)
	ld	e, a
	ld	hl, ModelNames
	add	hl, de

call printString

ld hl,crlf
call printString

ld hl, language_txt
call printString

	ld	a, (KeyboardLanguage)
	ld	e, a
	ld	d, 0
	ld	hl, LanguageTableOffset
	add	hl, de
	ld	a, (hl)
	ld	e, a
	ld	hl, KeyboardLanguages
	add	hl, de

call printString

ld hl,crlf
call printString
ld hl, vendor_txt
call printString


ld 	bc, #7F00 + %10001001                        ; GA select lower rom, and mode 1
	out 	(c),c


;;-----------------------------------------------------------------------
;; get a pointer to the machine name
;; HL = machine name
 ld      b,&f5			;; PPI port B input
 in      a,(c)

	ld 	bc, RESTORE_ROM_CONFIG
	out 	(c),c


 cpl     
and     &0e				;; isolate LK1-LK3 (defines machine name on startup)
rrca    
;; A = machine name number
 ld      hl,VendorNames			; table of names
inc     a
	ld	e, a
	ld	d, 0
	ld	hl, VendorTableOffset
	add	hl, de
	ld	a, (hl)
	ld	e, a
	ld	hl, VendorNames
	add	hl, de

 	
call printString



;enable RAM
;call &0723

ld hl,crlf
call printString


        TXT_OUTPUT      equ &bb5a

printString:
        ld      a,(hl)          ; load char pointed by HL into A
        or      a               ; if 0 then Z flag will be set
        ret     z               ; returns if Z flag is set
        inc     hl              ; increase pointer
        call    TXT_OUTPUT      ; call TXT_OUTPUT
        jr      printString

ReadFromLowerROM:
 	ld 	bc, #7F00 + %10001001                        ; GA select lower rom, and mode 1
	out 	(c),c
	ld	l, (ix)
	ld	h, (ix+1)
	ld 	bc, RESTORE_ROM_CONFIG
	out 	(c),c
	ret

ReadFromLowerRAM:
 	ld 	bc, #7F00 + %10000101                        ; GA select lower ram, and mode 1
	out 	(c),c
	ld	l, (ix)
	ld	h, (ix+1)
	ld 	bc, RESTORE_RAM_CONFIG
	out 	(c),c
	ret


hello_message:
defb "Hello World from RSX!",0

bye_message:
defb "Bye!",0

crlf:
defb 10,13,0

model_txt:
defb "Model:",0

language_txt:
defb "Language:",0

vendor_txt:
defb "Vendor:",0


ModelType: db 0
KeyboardLanguage: db 0
Vendor: db 0


ModelNames:
TxtUnknown: db "UNKNOWN CPC", 0
TxtModelCPC464: db "CPC 464", 0 
TxtModelCPC664: db "CPC 664", 0 
TxtModelCPC6128: db "CPC 6128", 0 

ModelNameTableOffset:
	defb 0
	defb TxtModelCPC464 - TxtUnknown
	defb TxtModelCPC664 - TxtUnknown
	defb TxtModelCPC6128 - TxtUnknown

MODEL_UNKNOWNCPC	EQU 0
MODEL_CPC464 		EQU 1
MODEL_CPC664 		EQU 2
MODEL_CPC6128 		EQU 3


KeyboardLanguages:
TxtEnglish: defb "English",0
TxtSpanish: defb "Spanish",0
TxtFrench: defb "French",0

LanguageTableOffset:
	defb 0
	;defb TxtEnglish - TxtUnknown
	defb TxtSpanish - TxtEnglish
	defb TxtFrench - TxtEnglish


KEYBOARD_LANGUAGE_ENGLISH EQU 0
KEYBOARD_LANGUAGE_SPANISH EQU 1
KEYBOARD_LANGUAGE_FRENCH EQU 2

VendorNames:
TxtArnold defb "Arnold",0							;; this name can't be chosen
TxtAmstrad defb "Amstrad",0
TxtOrion defb "Orion",0
TxtSchneider defb "Schneider",0
TxtAwa defb "Awa",0
TxtSolavox defb "Solavox",0
TxtSaisho defb "Saisho",0
TxtTriumph defb "Triumph",0
TxtIsp defb "Isp",0

VendorTableOffset:
defb 0 
defb TxtAmstrad-TxtArnold
defb TxtOrion-TxtArnold
defb TxtSchneider-TxtArnold
defb TxtAwa-TxtArnold
defb TxtSolavox-TxtArnold
defb TxtSaisho-TxtArnold
defb TxtTriumph-TxtArnold
defb TxtIsp-TxtArnold

VENDOR_ARNOLD EQU 0
VENDOR_AMSTRAD EQU 1
VENDOR_ORION EQU 2
VENDOR_SCHNEIDER EQU 3
VENDOR_AWA EQU 4
VENDOR_SOLAVOX EQU 5
VENDOR_SAISHO EQU 6
VENDOR_TRIUMPH EQU 7
VENDOR_ISP EQU 8


RESTORE_ROM_CONFIG EQU #7F00 + %10001001
RESTORE_RAM_CONFIG EQU #7F00 + %10000101
```



I have condensed the gate array explanation as much as I could but if you want to fully discover the Gate-Array take a look at the following references:

- https://www.cpcwiki.eu/index.php/Gate_Array
- https://archive.org/details/SOFT968TheAmstrad6128FirmwareManual
- Soft968, Appendix XI, The Alternate Register Set http://www.cpcwiki.eu/imgs/c/cc/S968ap11.pdf


### Lower Rom
Peviously we have set one Upper ROM on C000 that can take advantage of the lower ROM calls. But image we don't need them or maybe they are not available because system ROM is corrupted. This is done in the Amstrad Diagnostics (https://github.com/llopis/amstrad-diagnostics/) from which I am getting inspiration and recommend you to explore it.

A Lower ROM will be similar to our Upper ROM but it will start at 0 and we will have to supply a minimal boot that sets RST vectors, CRTC (see https://github.com/llopis/amstrad-diagnostics/blob/main/src/HardwareInit.asm)

We will also need to implement our own text routines.

For more and complete information check the following references.

### References:
[968] Soft968, Chapter 10. Expansion ROMs, Resident System Extensions and RAM Programs http://www.cpcwiki.eu/imgs/f/f6/S968se10.pdf
[INS] The Ins and Outs of the AMSTRAD CPC464 https://acpc.me/ACME/LIVRES/[ENG]ENGLISH/MELBOURNE_HOUSE/The_Ins_and_Outs_of_the_AMSTRAD_CPC464(Don_THOMSON)(acme).pdf
https://www.cpcwiki.eu/forum/amstrad-cpc-hardware/very-simple-expansion-interface-(new-to-cpc)/100/
[DIAG] Amstrad Diagnostics https://github.com/llopis/amstrad-diagnostics/

# DRAFT AREA

## Inner peripherals

Address|Output|Input
-|-|-
00XX to 7EXX|Do not use|Do not use
7FXX|Video Gate Array|Do not use
80XX to BBXX|Do not use|Do not use
BCXX|CRTC Register Select|Do not use
BDXX|CRTC Data|Do not use
BEXX|Do not use|Reserved(CRTC Status)
BFXX|Do not use|CRTC Data
C0XX to DEXX|Donotuse|Do not use
DFXX|Expansion ROM Select|Do not use
E0XX to EEXX|Donotuse|Donotuse
EFXX|PrinterLatch|Donotuse
F0XX to F3XX|Do not use|Do not use
F4XX|PPI PortA Data|PPI PortA Data
F5XX|PPI PortB Data|PPI PortB Data
F6XX|PPI PortC Data|PPI PortC Data
F7XX|PPI Control|Undefined
F8XX|Expansion Bus|Expansion Bus
F9XX|Expansion Bus|Expansion Bus
FAXX|Expansion Bus|Expansion Bus
FBXX|Expansion Bus|Expansion Bus
FCXX to FEXX|Do not use|Do not use
FFXX|Not used|Not used

The arrangement of I/O addresses, summarised in the table given here, appears even more complex than the memory map, but the hardware decoding is relatively simple.
- If address bit A15 is low, the Video Gate Array is selected.
- If address bit A14 is low, the CRT Controller is selected.
- If address bit A13 is low, the expansion ROM number must be set.
- If address bit A12 is low, the printer latch is selected.
- If address bit A11 is low, the PPI isselected.
- If address bit A10 is low, an expansion channel is implied.
Not more than one of bits A10 to A15 may be low in a given address, which accounts for the large number of ‘donotuse’ restrictions. It is especially important that this rule is observed for inputs, since physical damage could otherwise occur. In the case of the CRT Controller and the PPI, bits A8 and A9 select a particular function of the device


## Analysis of Roms
- Amstrad diag
- 

## Interface cards
IN OUT
Clocks
https://bmpc.github.io/2021/03/14/interface-with-amstrad-cpc6128-using-a-microcontroller.html

## 


Let's see how would it be the code

```asm
ORG   #C000		;Start of ROM

			;Header			
DEFB 1			;Background ROM
DEFB 0			;Mark 0
DEFB 5			;Version 5
DEFB 0			;Modification 0
DEFW NAME_TABLE		;Address of name table

			;Jumpblock
JP EMS_ENTRY		;0 Background ROM power-up entry
JP HELLO		;1
JP BYE;			;2

NAME_TABLE:             ;Name table ending with 0
DEFB 'MY RO','M'+#80	;0  With the space it cannot be called from BASIC
DEFB 'HELL','O'+#80	;1
DEFB 'BY','E'+#80	;2
DEFB 0			;End of table marker
```

Each of the entries to the foreground ROM represents a separate program. The first entry

idea for code function with info on memory pool with  BC,DE;HL registers

KL ROM WALK looks for background roms and initialises any that finds. (calls 1st entry??)

KL INIT BACK initializes a particular background ROM

KL FIND COMMAND 
