# USIFAC2 internals and developer guide

## Introduction
This is a **WORK IN PROGRESS** text where I document my findings. 
USIFAC2 is an expansion rom for CPC which provides a serial connection, is able to load programs from USB sticks and has wifi and bluetooth support.
You can find more info on the thread https://www.cpcwiki.eu/forum/amstrad-cpc-hardware/usifac-iimake-your-pc-or-usb-stick-an-hdd-for-amstrad-access-dsk-and-many-more!

ikonsgr, the author of USIFAC2 has nicely shared the source code and schematics and it is available at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACT6kqTr-sst-iqDeBnE9gRa?dl=0


## Theory of operation
USIFAC2 plugs in the expansion port which has access to the data and address buses among other signals. By listening to the bus it can communicate to the CPC. (TO BE COMPLETED)

## Hardware
USIFAC2 is composed of few components, a microcontroller PIC18F47Q10 (https://ww1.microchip.com/downloads/en/DeviceDoc/PIC18F27-47Q10-Data-Sheet-40002043E.pdf) , a diode and a couple of capacitors. 

### Schematics
Schematics can be found at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACT6kqTr-sst-iqDeBnE9gRa?dl=0&preview=Usifac_ii_schematic.jpg

It is **worth to note** that in a real USIFAC board (2nd green version with ch376s soldered), pin 37(RB4) on the microcontroller is connected to pin 13(A5) on the CPC while schematics do not show that connection. Thus, pin 7(RA5) and pin 37(RB4) are connected to the same signal. RB4 is used by CLCs while RA5 is used in PORTA. Not sure if this the reason to have duplicated pins.

![image](https://user-images.githubusercontent.com/7136948/154051288-c07643e3-c5f3-43d8-a7fe-0fdbfc92d0d0.png)




|MC Pin|Name|CPC Pin|Name|
|----|-----|----|----|
|  1 | RE3 | 40 | BRST, ICSP MCLR * |
|  2 | RA0 | 18 | A0 |
|  3 | RA1 | 17 | A1 |
|  4 | RA2 | 16 | A2 |
|  5 | RA3 | 15 | A3 |
|  6 | RA4 | 14 | A4 |
|  7 | RA5 | 13 | A5 |
|  8 | RE0 | 39 | READY |
|  9 | RE1 | -  | - |
| 10 | RE2 | 32 | RD |
| 11 | VDD | 27 | VCC |
| 12 | VSS |  2 | GND |
| 13 | RA7 | 11 | A7 |
| 14 | RA6 | 12 | A6 |
| 15 | RC0 | 10 | A8 |
| 16 | RC1 |  9 | A9 |
| 17 | RC2 |  8 | A10 |
| 18 | RC3 |  7 | A11 |
| 19 | RD0 | 26 | D0 |
| 20 | RD1 | 25 | D1 |
| 21 | RD2 | 24 | D2 |
| 22 | RD3 | 23 | D3 |
| 23 | RC4 |  6 | A12 |
| 24 | RC5 |  5 | A13 |
| 25 | RC6 | 31 | IORQ |
| 26 | RC7 | 42 | ROMEN |
| 27 | RD4 | 22 | D4 |
| 28 | RD5 | 21 | D5 |
| 29 | RD6 | 20 | D6 |
| 30 | RD7 | 19 | D7 |
| 31 | VSS | 2 | GND |
| 32 | VDD | 27 | VCC |
| 33 | RB0 | 39 | READY (with diode) |
| 34 | RB1 | Serial  RX |
| 35 | RB2 | Serial  TX |
| 36 | RB3 | 43 | ROMDIS |
| 37 | RB4 | 13 | A5 * |
| 38 | RB5 |  29 |  M1 | 
| 39 | RB6 |  4 | A14, ICSP CLK | 
| 40 | RB7 |  3 | A15, ICSP DAT | 

(*) Differences between schematics and real board.

### CLC
PIC18F47Q10 provides CLC (Configurable Logic Cells) which is a kind of small PLD (Programmable Logic Device) inside the microcontroller. Thus, **no additional logic circuitry is needed** as it was done in the previous usifac version. CLC configuration is stored in RAM and can be changed during execution. CLC response time is the same for all the cells and it is around 10ns. More info about CLC can be found in https://microchipdeveloper.com/8bit:clc  

In USIFAC2, 5 CLCs are used:

- CLC1 = AND(/IORQ, M1, /A10, /A5)  #I/O
- CLC2 = AND(/IORQ, M1, /A13, /A13) # Select ROM
- CLC3 = AND(/ROMEN, A14) # ROM read
- CLC4 = NOT(OR(OR(CLC1,CLC2,CLC5),AND(CLC5,CLC3))) #Enable PIC
- CLC5 = AND(/IORQ, M1, /A10, A5) #FDC

The definitions of the CLCs are found in the .gcb files from https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACCGyppKnn29U_gbG_hE6eUa/PIC%2018F47Q10/18f47q10_5_gcb_source.zip

- PPS stands for Peripheral Pin Setup and assigns pins to CLC inputs.
- POL inverts output if necessary
- SEL selects data inputs
- GLS connect inputs to gates and invert them if necessary
- CON sets gate types (AND, NAND, AND-OR, AND-OR-INVERT, OR-XOR, OR-XNOR)

Usifac2 uses the following pins for CLC inputs:

```
    CLCIN0PPS = 0x16;   //RC6->CLC4:CLCIN0   IORQ    
    CLCIN1PPS = 0x17;   //RC7->CLC4:CLCIN1   ROMEN
    CLCIN2PPS = 0x0D;   //RB5 > CLCIN2       M1
    CLCIN3PPS = 0x0E;   //RB6 > CLCIN3       A14
    CLCIN4PPS = 0x12;   //RC2->CLC4:CLCIN4   A10
    CLCIN5PPS = 0x15;   //RC5->CLC4:CLCIN5   A13
    CLCIN6PPS = 0x0C;   //RB4->CLC1:CLCIN6   A5
```

In the page 293 of the manual (https://ww1.microchip.com/downloads/en/DeviceDoc/PIC18F27-47Q10-Data-Sheet-40002043E.pdf) it is shown how the PPS are coded. For example, CLCIN6PPS is assigned to RB4 which is PORTB (01) pin 4 (100), being 01100 -> 0x0C

![image](https://user-images.githubusercontent.com/7136948/154055739-4c75364a-c230-466d-b25d-8d7b957ba9c2.png)


In particular, the configuration for CLC3 that is activated when a ROM read is requested is the following:

```
CLC3POL  = 0x00;  // not inverted
CLC3SEL0 = 0x01;  // CLCIN1PPS  ROMEN
CLC3SEL1 = 0x03;  // CLCIN3PPS  A14
CLC3SEL2 = 0x03;  // CLCIN3PPS  A14
CLC3SEL3 = 0x03;  // CLCIN3PPS  A14
CLC3GLS0 = 0x01;  // First input negated
CLC3GLS1 = 0x08;  // Second input
CLC3GLS2 = 0x20;  // Third input
CLC3GLS3 = 0x80;  // Fourth input
CLC3CON  = 0x02;  // MODE 4-input AND; 
```

The following image shows the circuit for CLC3![image](https://user-images.githubusercontent.com/7136948/154040581-1e1b2548-5491-4eb7-b54a-1cadf4d7ae56.png)

and for the rest of CLC definitions.

CLC1![image](https://user-images.githubusercontent.com/7136948/154049624-9205e62e-d8ea-4810-bff1-34dd5ea08cc3.png)
CLC2![image](https://user-images.githubusercontent.com/7136948/154049693-bc572982-65cd-4965-b400-fc752d2b204d.png)
CLC4![image](https://user-images.githubusercontent.com/7136948/154049732-b53a4d8f-4fc4-42f3-aba3-e5ddcf1c31df.png)
CLC5![image](https://user-images.githubusercontent.com/7136948/154049775-2ee4f5d9-20ff-4c26-8066-469f57d9a119.png)


You can get this drawing with MPLAB Code Configurator (MCC) (https://microchipdeveloper.com/mcc:clc) and also with GreatCowBasic but only Windows version provides this tool :(.

We will see later how software uses these CLC signals.


## Software

### Microcontroller
The main program for the microcontroller is written in Great Cow Basic (GCB) and there are versions of GCB for Windows and Linux (without GUI but we do not need it). This code is the glue between the ROM code and the rest of peripherals (USB, Serial Port, etc, ...) and includes the z80 machine code for the ROM and other convenience functions.

In particular, PIC code is available at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AAC86pJ104xlgsk8MaGW1CMKa/PIC%2018F47Q10?dl=0&subfolder_nav_tracking=1 being version 5 the last one with source code.

### How to compile

In order to compile the code for the PIC, you will need to install GreatCowBasic. It is available for both Linux and Windows (http://gcbasic.sourceforge.net/Typesetter/index.php/Download), but Linux will not have the GUI tool.
If you are a Windows user, just install the windows binaries. However, if you use Linux you need to follow the following steps.  First you need to download and install FreeBasic from https://sourceforge.net/projects/fbc
Next, download GBCBasic https://sourceforge.net/projects/gcbasic/files/GCBasic%20-%20Linux%20Distribution/GCB%40Syn.rar/download and extract the file with the unbelievable password **GCB** ```unrar x GCB@Syn.rar ```
```
cd sources/linuxbuild
chmod a+x install.sh
./install.sh build
```

If everything went well, GBC is now installed, if not just check this document https://sourceforge.net/projects/gcbasic/files/GCBasic%20-%20Linux%20Distribution/readme-linux-install-updated.txt/download

Now it is time to compile the .gcb program
```
./makehex.sh 18f47q10_5.gcb 
Great Cow BASIC (0.98.07 RC45 2021-03-31 (Linux 64 bit))
Compiling 18f47q10_5.gcb ...
Done
Assembling program ...
Program assembled successfully
```

### Microcontroller code
Microcontroller code starts with the definition of CLC and variables. 
USIFAC2 communicates to the CPC through the serial port addresses **FBDX**

CPC uses register **DF00** (A13 has to be low) in order to select the number of a external ROM. ROM 0 is BASIC, ROM 1 to 6 are external, ROM 7 is usually for AMSDOS or PARADOS on a CPC6128. (If you want to know more about ROMS, just check http://cpctech.cpc-live.com/docs/manual/s968se02.pdf)
ROMs map into $C000 to $FFFF (16kb). Thus, after writing the desired ROM number into DF000, /ROMEN signal goes low and if a valid expansion ROM has been selected via the DF00 register, then the external ROM board must send ROMDIS high. Another important signal is the M1 which stands for Machine cycle one. Each instruction cycle is composed of tree machine cycles: M1, M2 and M3. M1 is the "op code fetch" machine cycle. This signal is active low and we must make sure M1 is high when communicating with the Z80.

Pins in the microcontroller are grouped by ports, having PORT A,B,C and C 8bits and PORT E 3 bits. In particular we are interested in ports A, B and C.
- PORTA(7..0) is connected to address low byte A7..A0
- PORTC(7..0) is connected to address high byte ROMEN,IORQ,A13..A8
- PORTB(7..0) is connected to A15, A14, M1, A5, ROMDIS, TX, RX, READY

Going back to the rom selection mechanism, we can use CLC2 to detect a write on **FD00** which computes AND(/IORQ,M1,/A13). In GCB, CLCs are accesible from ```CLCDATA.X```, for example the following code shows the ROM READ section.

```
;###############################################-------------------code for ROM READ!###################################
ROM_READ_CODE:
  IF CLCDATA.2 THEN

      CPCADDRESS=PORTA                       ; A7..A0
      CPCADDRESS_H=(PORTC & 0b00111111)      ; (ROMEN,IORQ,A13..A8) & 3F -> Discard ROMEN and IORQ for high byte
      dir PORTD out                          ; D7..D0
           
```

**TO BE CONTINUED**

### ROM
In this part resides the z80 code that the board makes use of. It is written as a standard ROM with the classical header and then the jumpblock (see https://github.com/issalig/cpc/blob/main/doc/cpcz80adventures.md#Rom for more info on ROMs)

The code is written in z80 assembly and can be found at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACK-UZhsKGxsnMVRNVSnRwOa/Usifac_ii_main_rom.asm?dl=0

I recommend you to compile it with WinAPE, then you can convert it as defb instruction and paste it in the microcontroller code. (TO BE EXPANDED)
