# USIFAC2

## Introduction
This is work in progress text where I document my findings about USIFAC2. USIFAC2 is an expansion rom for CPC which provides a serial connection, is able to load programs from USB sticks and has wifi and bluetooth support.
You can find more info on the thread https://www.cpcwiki.eu/forum/amstrad-cpc-hardware/usifac-iimake-your-pc-or-usb-stick-an-hdd-for-amstrad-access-dsk-and-many-more!

ikonsgr, the author of USIFAC2 has nicely shared the source code and schematics and it is available at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACT6kqTr-sst-iqDeBnE9gRa?dl=0


## Theory of operation
USIFAC2 plugs in the expansion port which has access to the data and address buses among other signals. By listening to the bus it can communicate to the CPC. (TO BE COMPLETED)

## Hardware
USIFAC2 is composed of few components, a microcontroller PIC18F47Q10, a diode and a couple of capacitors. A schematic of the circuit is provided at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACi-NI8lLCniHfSaHBJnOl_a/Usifac_ii_schematic.jpg?dl=0

PIC18F47Q10 provides CLC (Configurable Logic Cells) which is a kind of small PLD (Programmable Logic Device) inside the microcontroller. Thus, no additional logic circuitry is needed as it was done in the previous usifac version.

In particular, 5 CLC are used:

- CLC1 = AND(/IORQ, M1, /A10, /FDC)  #I/O
- CLC2 = AND(/IORQ, M1, /A13, /A13) # Select ROM
- CLC3 = AND(/ROMEN, A14) # ROM read
- CLC4 = NOT(OR(OR(CLC1,CLC2,CLC5),AND(CLC5,CLC3))) #Enable PIC
- CLC5 = AND(/IORQ, M1, /A10, FDC) #FDC

The definitions of the CLC are found in 

## Software

### Microcontroller
The main program for the microcontroller is written in Great Cow Basic (GCB) and there are versions of GCB for Windows and Linux (without GUI but we do not need it). This code is the glue between the ROM code and the rest of peripherals (USB, Serial Port, etc, ...) and includes the z80 machine code for the ROM and other convenience functions.

In particular, PIC code is available at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AAC86pJ104xlgsk8MaGW1CMKa/PIC%2018F47Q10?dl=0&subfolder_nav_tracking=1 being version 5 the last one with source code.

### ROM
In this part resides the z80 code that the board makes use of. It is written as a standard ROM with the classical header and then the jumpblock (see https://github.com/issalig/cpc/blob/main/doc/cpcz80adventures.md#Rom for more info on ROMs)

The code is written in z80 assembly and can be found at https://www.dropbox.com/sh/ua4vgf6qjjmqlnq/AACK-UZhsKGxsnMVRNVSnRwOa/Usifac_ii_main_rom.asm?dl=0

I recommend you to compile it with WinAPE, then you can convert it as defb instruction and paste it in the microcontroller code. (TO BE EXPANDED)
