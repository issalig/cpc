; Disassembly of AMSDOS ROM 
; 
; memory usage:

;; under BASIC:
;; BE56	= drive
;; BE57 = track
;; BE58 = sector ID (0 based)

;; under CPM:
;; ad33,34,35: jp xxxx
;; ad36,37: stack pointer storage
;; ad38,39: hl storage
;; ad3c,3d: storage for firmware's BC register pair
;; ad3e,3f: storage for interrupt mode 1 vector
;; ad40: flag to indicate if alternate register set should be saved when executing ENTER FIRMWARE
;; ad41: cursor state: enabled (!=0), disabled (==0)
;; ad42: keyboard flag: wait for char (!=0), read char (==0)


c000 defb &01,&00,&05,&00
c004 defw &c072						;; RSX command table

;; RSX function table
c006 c3bcc1    jp      $c1bc		;; CPM ROM - init function
c009 c3b2c1    jp      $c1b2		;; |CPM
c00c c3d1cc    jp      $ccd1		;; |DISC
c00f c3d5cc    jp      $ccd5		;; |DISC.IN
c012 c3e4cc    jp      $cce4		;; |DISC.OUT
c015 c3fdcc    jp      $ccfd		;; |TAPE
c018 c301cd    jp      $cd01		;; |TAPE.IN
c01b c318cd    jp      $cd18		;; |TAPE.OUT
c01e c3dacd    jp      $cdda		;; |A
c021 c3ddcd    jp      $cddd		;; |B
c024 c3e4cd    jp      $cde4		;; |DRIVE
c027 c3fecd    jp      $cdfe		;; |USER
c02a c32ed4    jp      $d42e		;; |DIR
c02d c38ad4    jp      $d48a		;; |ERA
c030 c3c4d4    jp      $d4c4		;; |REN

;; CP/M 2.1 EXTENDED JUMPBLOCK
c033 c372ca    jp      $ca72		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: SET MESSAGE
c036 c30dc6    jp      $c60d		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: SETUP DISC
c039 c381c5    jp      $c581		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: SELECT FORMAT
c03c c366c6    jp      $c666		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: READ SECTOR
c03f c34ec6    jp      $c64e		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: WRITE SECTOR
c042 c352c6    jp      $c652		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: FORMAT TRACK
c045 c363c7    jp      $c763		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: MOVE TRACK
c048 c330c6    jp      $c630		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: GET DRIVE STATUS
c04b c303c6    jp      $c603		;; BIOS & CP/M 2.1 EXTENDED JUMPBLOCK: SET RETRY COUNT
c04e c368c1    jp      $c168		;; CP/M 2.1 EXTENDED JUMPBLOCK: ENTER FIRMWARE
c051 c3dbc0    jp      $c0db		;; CP/M 2.1 EXTENDED JUMPBLOCK: SET REG SAVE
c054 c389c3    jp      $c389		;; CP/M 2.1 EXTENDED JUMPBLOCK: SET SIO (initialise serial interface)
c057 c301c3    jp      $c301		;; CP/M 2.1 EXTENDED JUMPBLOCK: SET CMND BUFFER
c05a c3dbc3    jp      $c3db		;; CP/M 2.1 EXTENDED JUMPBLOCK: D0 IN STATUS (serial interface: test for byte received channel 0)
c05d c3f7c3    jp      $c3f7		;; CP/M 2.1 EXTENDED JUMPBLOCK: D0 IN (serial interface: read recieve byte channel 0)
c060 c335c4    jp      $c435		;; CP/M 2.1 EXTENDED JUMPBLOCK: D0 OUT STATUS (serial interface: has transmitted data channel 0)
c063 c345c4    jp      $c445		;; CP/M 2.1 EXTENDED JUMPBLOCK: D0 OUT (serial interface: transmit byte channel 0)
c066 c3e3c3    jp      $c3e3		;; CP/M 2.1 EXTENDED JUMPBLOCK: D1 IN STATUS (serial interface: test for byte received channel 1)
c069 c3ffc3    jp      $c3ff		;; CP/M 2.1 EXTENDED JUMPBLOCK: D1 IN (serial interface: read receive byte channel 1)
c06c c33ac4    jp      $c43a		;; CP/M 2.1 EXTENDED JUMPBLOCK: D1 OUT STATUS (serial interface: has transmitted data channel 1)
c06f c34bc4    jp      $c44b		;; CP/M 2.1 EXTENDED JUMPBLOCK: D1 OUT (serial interface: transmit byte channel 1)

;; RSX command table
c072 
defb "CPM RO","M"+&80			;; init function
defb "CP","M"+&80				;; |CPM
defb "DIS","C"+&80				;; |DISC
defb "DISC.I","N"+&80			;; |DISC.IN
defb "DISC.OU","T"+&80			;; |DISC.OUT
defb "TAP","E"+&80				;; |TAPE
defb "TAPE.I","N"+&80			;; |TAPE.IN
defb "TAPE.OU","T"+&80			;; |TAPE.OUT
defb "A"+&80					;; |A
defb "B"+&80					;; |B
defb "DRIV","E"+&80				;; |DRIVE
defb "USE","R"+&80				;; |USER
defb "DI","R"+&80				;; |DIR
defb "ER","A"+&80				;; |ERA
defb "RE","N"+&80				;; |REN
defb 1+&80						;; BIOS: SET MESSAGE
defb 2+&80						;; BIOS: SETUP DISC
defb 3+&80						;; BIOS: SELECT FORMAT
defb 4+&80						;; BIOS: READ SECTOR
defb 5+&80						;; BIOS: WRITE SECTOR
defb 6+&80						;; BIOS: FORMAT TRACK
defb 7+&80						;; BIOS: MOVE TRACK
defb 8+&80						;; BIOS: GET DRIVE STATUS
defb 9+&80						;; BIOS: SET RETRY COUNT
defb 0

;;=========================================================
  
c0c0 2a3900    ld      hl,($0039)
c0c3 223ead    ld      ($ad3e),hl
c0c6 3ec3      ld      a,$c3
c0c8 3233ad    ld      ($ad33),a
c0cb af        xor     a
c0cc 3240ad    ld      ($ad40),a
c0cf f3        di      
c0d0 d9        exx     
c0d1 ed433cad  ld      ($ad3c),bc
c0d5 d9        exx     
c0d6 21fac0    ld      hl,$c0fa
c0d9 181a      jr      $c0f5            ; (+$1a)

;;=========================================================
;; CP/M 2.1 EXTENDED JUMPBLOCK: SET REG SAVE

c0db 2140ad    ld      hl,$ad40
c0de be        cp      (hl)
c0df c8        ret     z

c0e0 c5        push    bc
c0e1 46        ld      b,(hl)
c0e2 77        ld      (hl),a
c0e3 b7        or      a
c0e4 78        ld      a,b
c0e5 c1        pop     bc
c0e6 28e7      jr      z,$c0cf          ; (-$19)

c0e8 f3        di      
c0e9 08        ex      af,af'
c0ea d9        exx     
c0eb ed4b3cad  ld      bc,($ad3c)
c0ef b7        or      a
c0f0 08        ex      af,af'
c0f1 d9        exx     
c0f2 2132c1    ld      hl,$c132

;; setup vector
c0f5 2234ad    ld      ($ad34),hl
c0f8 fb        ei      
c0f9 c9        ret     

;;----------------------------------------------------------

c0fa f3        di      
c0fb 08        ex      af,af'
c0fc d9        exx     
c0fd 2238ad    ld      ($ad38),hl
c100 e1        pop     hl
;; store stack pointer
c101 ed7336ad  ld      ($ad36),sp
c105 3100c0    ld      sp,$c000
c108 d5        push    de
c109 c5        push    bc
c10a f5        push    af
c10b fde5      push    iy
c10d ed4b3cad  ld      bc,($ad3c)
c111 b7        or      a
c112 cd4fc1    call    $c14f
c115 f3        di      
c116 08        ex      af,af'
c117 d9        exx     
c118 ed433cad  ld      ($ad3c),bc
c11c 2163c1    ld      hl,$c163
c11f 223900    ld      ($0039),hl
c122 fde1      pop     iy
c124 f1        pop     af
c125 c1        pop     bc
c126 d1        pop     de
c127 2a38ad    ld      hl,($ad38)
c12a 08        ex      af,af'
c12b d9        exx    
;; restore stack pointer 
c12c ed7b36ad  ld      sp,($ad36)
c130 fb        ei      
c131 c9        ret     

;;-------------------------------------------------------------
c132 f3        di      
c133 08        ex      af,af'
c134 d9        exx     

;; pop address of execution vector from stack
c135 e1        pop     hl

c136 ed7336ad  ld      ($ad36),sp
c13a 3100c0    ld      sp,$c000
c13d cd4fc1    call    $c14f
c140 f3        di      
c141 d9        exx     
c142 2163c1    ld      hl,$c163
c145 223900    ld      ($0039),hl
c148 d9        exx     
c149 ed7b36ad  ld      sp,($ad36)
c14d fb        ei      
c14e c9        ret     
 


;;-------------------------------------------------------------
;; HL = address of exection address

;; restore interrupt vector
c14f ed5b3ead  ld      de,($ad3e)
c153 ed533900  ld      ($0039),de

c157 fd2148ac  ld      iy,$ac48
;; get execution address
c15b 5e        ld      e,(hl)
c15c 23        inc     hl
c15d 56        ld      d,(hl)
;; push onto stack (will be popped off by RET and then executed)
c15e d5        push    de
c15f 08        ex      af,af'
c160 d9        exx     
c161 fb        ei      
c162 c9        ret     

c163 cd33ad    call    $ad33
defw &0038

;;=======================================================================
;; CP/M 2.1 EXTENDED JUMPBLOCK: ENTER FIRMWARE

c168 223aad    ld      ($ad3a),hl			; store HL parameter

;; address of parameter is on top off the stack
;; but we want to change this so return address is on stack after
;; parameter

c16b e1        pop     hl					; get address of parameter to &ad33 from stack
c16c e5        push    hl					; store it back on stack
c16d 23        inc     hl					; skip parameter
c16e 23        inc     hl
;; HL = return address
;; top of stack has address of parameter
c16f e3        ex      (sp),hl				; store return address on stack and return
											; address of parameter to HL
c170 e5        push    hl					; store address of parameter back onto the stack
c171 2a3aad    ld      hl,($ad3a)			; restore HL parameter
c174 c333ad    jp      $ad33
;;=======================================================================

c177 2163c1    ld      hl,$c163
c17a 223900    ld      ($0039),hl
c17d eb        ex      de,hl
c17e e9        jp      (hl)

;;=======================================================================
;; C/PM BIOS CALLS

c17f c3b2c1    jp      $c1b2				;; boot
c182 c3bec2    jp      $c2be				;; wboot
c185 c3e1c2    jp      $c2e1				;; const
c188 c3c3c2    jp      $c2c3				;; conin
c18b c3c8c2    jp      $c2c8				;; conout
c18e c3d2c2    jp      $c2d2				;; list
c191 c3d7c2    jp      $c2d7				;; punch
c194 c3dcc2    jp      $c2dc				;; reader
c197 c3e9c2    jp      $c2e9				;; home
c19a c3f2c2    jp      $c2f2				;; seldsk		
c19d c324c5    jp      $c524				;; settrk
c1a0 c329c5    jp      $c529				;; setsec
c1a3 c31ac5    jp      $c51a				;; setdma
c1a6 c3f7c2    jp      $c2f7				;; read
c1a9 c3fcc2    jp      $c2fc				;; write
c1ac c3cdc2    jp      $c2cd				;; lstst
c1af c35ac5    jp      $c55a				;; sectran

;;===========================================================================
;; |CPM function

c1b2 cd12b9    call    $b912			; firmware function: HI: KL CURR SELECTION
c1b5 4f        ld      c,a
c1b6 21dcc1    ld      hl,$c1dc
c1b9 c316bd    jp      $bd16			; firmware function: MC START PROGRAM

;;===========================================================================
;; ROM startup function

c1bc 3806      jr      c,$c1c4          ; (+$06)

;; is the disc rom, rom 0?
c1be cd12b9    call    $b912			; firmware function: HI: KL CURR SELECTION
c1c1 b7        or      a				; rom 0?
c1c2 2818      jr      z,$c1dc          ; if yes then boot CPM.

c1c4 fde5      push    iy
c1c6 d5        push    de
c1c7 1100fb    ld      de,$fb00
c1ca 19        add     hl,de
c1cb e5        push    hl
c1cc 23        inc     hl
c1cd e5        push    hl
c1ce fde1      pop     iy
c1d0 cdddc5    call    $c5dd			; setup default settings
c1d3 cda0cc    call    $cca0			; setup firmware; and patch firmware functions to use disc functions
c1d6 e1        pop     hl
c1d7 d1        pop     de
c1d8 fde1      pop     iy
c1da 37        scf     
c1db c9        ret     

;;==================================================================
;; boot CPM
c1dc 3100c0    ld      sp,$c000
c1df fd2148ac  ld      iy,$ac48
c1e3 1133ad    ld      de,$ad33
c1e6 01a500    ld      bc,$00a5
c1e9 cdafca    call    $caaf			; clear memory
c1ec 2141ad    ld      hl,$ad41
c1ef 35        dec     (hl)
;; setup IOBYTE
c1f0 3e81      ld      a,$81
c1f2 320300    ld      ($0003),a
;; reset user number/drive number
c1f5 af        xor     a
c1f6 320400    ld      ($0004),a

c1f9 2133c0    ld      hl,$c033			; initialise extended jumpblock
c1fc 1180be    ld      de,$be80			; start of CP/M 2.1 extended jumpblock
c1ff 013f00    ld      bc,$003f
c202 edb0      ldir    
c204 cdc0c0    call    $c0c0

c207 cdddc5    call    $c5dd			; setup default settings
;; load boot sector
c20a 0e41      ld      c,$41			; sector id
c20c 110000    ld      de,$0000			; track 0, drive 0
c20f 210001    ld      hl,$0100			; load address
c212 cd66c6    call    $c666			; BIOS: READ SECTOR
c215 dcacc2    call    c,$c2ac			; if loaded ok, check data is different
c218 300a      jr      nc,$c224         ; if loaded ok and data is the same,
										; or failed to load, then report error

;; start execute sequence
c21a eb        ex      de,hl
c21b 017fc1    ld      bc,$c17f			;; CP/M BIOS CALLS
c21e 3133ad    ld      sp,$ad33
c221 c377c1    jp      $c177

;;-----------------------------------------------------------------------------

c224 3e0f      ld      a,$0f			; "Failed to load boot sector"
c226 cdb8ca    call    $cab8			; display message with "Retry,Ignore and Cancel"
c229 18df      jr      $c20a            ; try again

;;-----------------------------------------------------------------------------

c22b cd6fc8    call    $c86f
c22e cdb0c8    call    $c8b0
c231 014801    ld      bc,$0148
c234 110000    ld      de,$0000
c237 e5        push    hl
c238 cd99c2    call    $c299			; load contiguous sectors
c23b e1        pop     hl
c23c dcacc2    call    c,$c2ac			; if loaded ok, check data is different
c23f 3051      jr      nc,$c292         ; if loaded ok and data is the same,
										; or failed to load, then report error

c241 e5        push    hl
c242 23        inc     hl
c243 5e        ld      e,(hl)
c244 23        inc     hl
c245 56        ld      d,(hl)
c246 21a4fc    ld      hl,$fca4
c249 19        add     hl,de
c24a eb        ex      de,hl
c24b e1        pop     hl
c24c 010002    ld      bc,$0200
c24f edb0      ldir    
c251 eb        ex      de,hl
c252 01490a    ld      bc,$0a49
c255 110000    ld      de,$0000
c258 cd99c2    call    $c299			; load contiguous sectors
c25b 3035      jr      nc,$c292			; if loaded ok and data is the same,
										; or failed to load, then report error        
c25d eb        ex      de,hl
c25e 2100ea    ld      hl,$ea00
c261 19        add     hl,de
c262 e5        push    hl
c263 2106f2    ld      hl,$f206
c266 19        add     hl,de

;; setup vector for CP/M BDOS function
c267 3ec3      ld      a,$c3
c269 320500    ld      ($0005),a
c26c 220600    ld      ($0006),hl

;; setup vector for CP/M BOOT function
c26f 320000    ld      ($0000),a
c272 210300    ld      hl,$0003
c275 19        add     hl,de
c276 220100    ld      ($0001),hl		;; WBOOT address

c279 217fc1    ld      hl,$c17f			;; CP/M BIOS CALLS
c27c 013300    ld      bc,$0033
c27f edb0      ldir    

c281 210400    ld      hl,$0004
c284 7e        ld      a,(hl)
c285 e60f      and     $0f
c287 fe02      cp      $02
c289 3802      jr      c,$c28d          ; (+$02)
c28b 3600      ld      (hl),$00
c28d 4e        ld      c,(hl)
c28e d1        pop     de
c28f c377c1    jp      $c177

;;--------------------------------------------------------------
c292 3e0e      ld      a,$0e			; "Failed to load CP/M"
c294 cdb8ca    call    $cab8			; display message with "Retry,Ignore and Cancel"
c297 1892      jr      $c22b            

;;==============================================================
;; load contiguous sectors over one or more tracks
;; 
;; assumptions:
;;
;; - single sided
;; - VENDOR/SYSTEM format
;; - 512 bytes per sector
;;
;; entry:
;; B = number of sectors
;; C = starting sector ID
;; HL = load address
;; D = starting track, E = drive

c299 cd66c6    call    $c666			; BIOS: READ SECTOR
c29c d0        ret     nc

;; increment sector ID
c29d 79        ld      a,c
c29e 0c        inc     c
;; test if ID exceeds ID of last sector on track
c29f fe49      cp      $49				
c2a1 3803      jr      c,$c2a6          

;; ID has exceeded last sector on track...

;; reset ID to ID of first sector on track
c2a3 0e41      ld      c,$41
;; increment track
c2a5 14        inc     d


;; add 512 to load address
c2a6 24        inc     h
c2a7 24        inc     h
;; load next sector
c2a8 10ef      djnz    $c299            ; (-$11)
c2aa 37        scf     
c2ab c9        ret     

;;==============================================================
;; check 512 bytes
;; 
;; HL = address
;; return: 
;;  - carry set: data is different
;;  - carry clear: data is the same

c2ac e5        push    hl
c2ad 010200    ld      bc,$0002

;; C = number of 256 byte blocks

;; get first byte
c2b0 7e        ld      a,(hl)

;; check 256 bytes
c2b1 be        cp      (hl)
c2b2 23        inc     hl
c2b3 37        scf     
c2b4 2006      jr      nz,$c2bc         ; (+$06)
c2b6 10f9      djnz    $c2b1            ; (-$07)

;; next block of 256 bytes
c2b8 0d        dec     c
c2b9 20f6      jr      nz,$c2b1         ; (-$0a)

;; data is the same
c2bb b7        or      a
c2bc e1        pop     hl
c2bd c9        ret     

;--------------------------------------------------------------
c2be cd33ad    call    $ad33
defw &c22b
c2c3 2186c4    ld      hl,&c486
c2c6 181c      jr      $c2e4

;--------------------------------------------------------------
c2c8 218fc4    ld      hl,$c48f
c2cb 1817      jr      $c2e4            ; (+$17)
;--------------------------------------------------------------
c2cd 2198c4    ld      hl,$c498
c2d0 1812      jr      $c2e4            ; (+$12)
;--------------------------------------------------------------
c2d2 21a1c4    ld      hl,$c4a1
c2d5 180d      jr      $c2e4            ; (+$0d)
;--------------------------------------------------------------
c2d7 21aac4    ld      hl,$c4aa
c2da 1808      jr      $c2e4            ; (+$08)
;--------------------------------------------------------------
c2dc 21bcc4    ld      hl,$c4bc
c2df 1803      jr      $c2e4            ; (+$03)
;--------------------------------------------------------------
c2e1 217dc4    ld      hl,$c47d
;--------------------------------------------------------------

c2e4 cd33ad    call    $ad33
defw &c46a
;;============================================================

c2e9 cd68c1    call    $c168			;; CP/M 2.1 EXTENDED JUMPBLOCK: ENTER FIRMWARE
defw &c51f
c2ee 2189be    ld      hl,$be89
c2f1 c9        ret     

;;============================================================
c2f2 cd33ad    call    $ad33
defw &c4f0								;; setup XDPB, and get address of drive's XDPB
;;============================================================
c2f7 cd33ad    call    $ad33
defw &c54c
;;============================================================
c2fc cd33ad    call    $ad33
defw &c52e
;;============================================================
;; CP/M 2.1 EXTENDED JUMPBLOCK:: SET CMND BUFFER
c301 32c5ad    ld      ($adc5),a
c304 018100    ld      bc,$0081
c307 1142ad    ld      de,$ad42
c30a edb0      ldir    
c30c 2143ad    ld      hl,$ad43
c30f 22c3ad    ld      ($adc3),hl
c312 c9        ret     

;;----------------------------------------------------------------------------------

c313 2141ad    ld      hl,$ad41
c316 7e        ld      a,(hl)
c317 b7        or      a
c318 2804      jr      z,$c31e          ; (+$04)
c31a 35        dec     (hl)
c31b cc81bb    call    z,$bb81			; firmware function: TXT CUR ON
c31e cd09bb    call    $bb09			; firmware function: KM READ CHAR
c321 dc0cbb    call    c,$bb0c			; firmware function: KM CHAR RETURN
c324 9f        sbc     a,a
c325 c9        ret     

;;----------------------------------------------------------------------------------

c326 2142ad    ld      hl,$ad42
c329 7e        ld      a,(hl)
c32a b7        or      a
c32b 281b      jr      z,$c348          ; (+$1b)
c32d cd09bb    call    $bb09			; firmware function: KM READ CHAR
c330 300c      jr      nc,$c33e         ; (+$0c)
c332 21c5ad    ld      hl,$adc5
c335 34        inc     (hl)
c336 35        dec     (hl)
c337 c0        ret     nz

c338 2142ad    ld      hl,$ad42
c33b 3600      ld      (hl),$00
c33d c9        ret     

;;----------------------------------------------------------------------------------

c33e 35        dec     (hl)
c33f 2ac3ad    ld      hl,($adc3)
c342 7e        ld      a,(hl)
c343 23        inc     hl
c344 22c3ad    ld      ($adc3),hl
c347 c9        ret     

;;----------------------------------------------------------------------------------

c348 2141ad    ld      hl,$ad41
c34b 7e        ld      a,(hl)
c34c b7        or      a
c34d c481bb    call    nz,$bb81				;; firmware function: TXT CUR ON
c350 3600      ld      (hl),$00
c352 c306bb    jp      $bb06				;; firmware function: KM WAIT CHAR
c355 3e1a      ld      a,$1a
c357 c9        ret     

;;----------------------------------------------------------------------------------


c358 3eff      ld      a,$ff
c35a c9        ret     

;;----------------------------------------------------------------------------------


c35b 2141ad    ld      hl,$ad41
c35e 7e        ld      a,(hl)
c35f b7        or      a
c360 cc84bb    call    z,$bb84				;; firmware function: TXT CUR OFF
c363 36ff      ld      (hl),$ff
c365 79        ld      a,c
c366 cd5abb    call    $bb5a				;; firmware function: TXT OUTPUT
c369 fe20      cp      $20
c36b d0        ret     nc

c36c cd78bb    call    $bb78				;; firmware function: TXT GET CURSOR
c36f cd87bb    call    $bb87				;; firmware function: TXT VALIDATE
c372 d8        ret     c

c373 cd8abb    call    $bb8a				;; firmware function: TXT PLACE CURSOR
c376 c38dbb    jp      $bb8d				;; firmware function: TXT REMOVE CURSOR

;;----------------------------------------------------------------------------------

c379 cd2ebd    call    $bd2e				;; firmware function: MC BUSY PRINTER
c37c 3f        ccf     
c37d 9f        sbc     a,a
c37e c9        ret     
;;----------------------------------------------------------------------------------

c37f 79        ld      a,c
c380 cd2bbd    call    $bd2b				;; firmware function: MC PRINT CHAR
c383 d8        ret     c
c384 cdd3c4    call    $c4d3
c387 18f6      jr      $c37f            ; (-$0a)

;;====================================================================================
;; Serial interface 

;; IC's:
;; Intel 8253 Programmable Interval timer
;; Zilog Z80 DART

;; I/O ports:
;; fadc - Z80 DART channel 0 data
;; fadd - Z80 DART channel 0 control
;; fade - Z80 DART channel 1 data
;; fadf - Z80 DART channel 1 control
;; fbdc - 8253 channel 0 counter
;; fbdd - 8253 channel 1 counter
;; fbde - 8253 channel 2 counter
;; fbdf - 8253 control

;; memory locations used by serial functions:
;;
;; adc6 - Z80 DART's "write register 5" for channel 0
;; adc7 - Z80 DART's "write register 5" for channel 1

;;====================================================================================
;; serial interface: init
;;
;; entry:
;; HL = address of 12 byte buffer 
;;
;; 0 1 Z80 DART's "write register 4" for channel 0
;; 1 1 Z80 DART's "write register 5" for channel 0
;; 2 1 Z80 DART's "write register 3" for channel 0
;; 3 1 Z80 DART's "write register 4" for channel 1
;; 4 1 Z80 DART's "write register 5" for channel 1
;; 5 1 Z80 DART's "write register 3" for channel 1
;; 6 2 8253 channel 0 count
;; 8 2 8253 channel 1 count
;; 10 2 8253 channel 2 count
;;
;; exit:
;; BC, DE, HL corrupt
;;
;; notes:
;; - adc6 will hold the state of Z80 DART's "write register 5" for channel 0
;; - adc7 will hold the state of Z80 DART's "write register 5" for channel 1


c389 f3        di      
c38a 01ddfa    ld      bc,$fadd			;; Base I/O address for Z80 DART registers
c38d 11c6ad    ld      de,$adc6			;; Base address of stored "write register 5" for channel 0 and 1
c390 cdbdc3    call    $c3bd			;; setup Z80 DART channel 0
c393 03        inc     bc
c394 03        inc     bc
c395 13        inc     de				;; DE = $adc7
										;; BC = I/O address of Z80 DART channel 1
c396 cdbdc3    call    $c3bd			;; setup Z80 DART channel 1

;;--------------------------------------------------------------------------------------
;; setup 8253 Programmable Interval Timer

c399 3e36      ld      a,$36			;; %00110110
										;; - select channel 0
										;; - read/load LSB then MSB
										;; - mode 3
										;; - binary 16 bit
c39b 1edc      ld      e,$dc			;; $dc (8253 channel 0)
c39d cdaec3    call    $c3ae			;; set channel 1 count, mode and countdown mode

c3a0 3e76      ld      a,$76			;; %01110110
										;; - select channel 1
										;; - read/load LSB then MSB
										;; - mode 3
										;; - binary 16 bit

c3a2 1c        inc     e				;; E = $dd (8253 channel 1)
c3a3 cdaec3    call    $c3ae			;; set channel 1 count, mode and countdown mode
c3a6 3eb6      ld      a,$b6			;; %10110110
										;; - select channel 2
										;; - read/load LSB then MSB
										;; - mode 3
										;; - binary 16 bit

c3a8 1c        inc     e				;; E = $de (8253 channel 2)
c3a9 cdaec3    call    $c3ae			;; set channel 1 count, mode and countdown mode

c3ac fb        ei      
c3ad c9        ret     

;;=====================================================================
;; initialise 8253 channel
;;
;; entry conditions:
;; A = 8253 Control 
;; bit 7,6: channel number
;; bit 5,4: read/load
;; bit 3,2,1: mode number
;; bit 0: 
;; E = &dc (8253 channel 0), &dd (8253 channel 1) or &de (8253 channel 2) or $df (8253 channel 3)
;; HL = address of parameter buffer (control word followed by time constant)
;;
;; exit conditions:

c3ae 01dffb    ld      bc,$fbdf			;; I/O address of 8253 control
c3b1 ed79      out     (c),a

c3b3 4b        ld      c,e				;; BC = I/O address for channel counter
c3b4 7e        ld      a,(hl)
c3b5 23        inc     hl
c3b6 ed79      out     (c),a			;; set low byte of count
c3b8 7e        ld      a,(hl)
c3b9 23        inc     hl
c3ba ed79      out     (c),a			;; set high byte of count
c3bc c9        ret     

;;=====================================================================
;; BC = I/O address of channel's control register
;; HL = pointer to buffer containing: write register 4, write register 5 and write register 3 for channel

c3bd 3e18      ld      a,$18			;; "channel reset"
c3bf ed79      out     (c),a			;; write to "write register 0" of Z80 DART channel

c3c1 3e04      ld      a,$04
c3c3 ed79      out     (c),a			;; select "write register 4" of Z80 DART channel
c3c5 7e        ld      a,(hl)
c3c6 23        inc     hl
c3c7 ed79      out     (c),a			;; write to "write register 4" of Z80 DART channel

c3c9 3e05      ld      a,$05
c3cb ed79      out     (c),a			;; select "write register 5" of Z80 DART
c3cd 7e        ld      a,(hl)
c3ce 12        ld      (de),a			;; store current value
c3cf 23        inc     hl
c3d0 ed79      out     (c),a
c3d2 3e03      ld      a,$03			;; select "write register 3" of Z80 DART
c3d4 ed79      out     (c),a
c3d6 7e        ld      a,(hl)
c3d7 23        inc     hl
c3d8 ed79      out     (c),a			;; write to "write register 3" of Z80 DART channel
c3da c9        ret     


;;=====================================================================
;; serial interface: test for byte received through channel 0

c3db 01ddfa    ld      bc,$fadd			
c3de 21c6ad    ld      hl,$adc6
c3e1 1806      jr      $c3e9            

;;=====================================================================
;; serial interface: test for byte received through channel 1

c3e3 01dffa    ld      bc,$fadf
c3e6 21c7ad    ld      hl,$adc7


;;---------------------------------------------------------------------
;; BC = I/O address of channel's control register
;; HL = address of channels "write register 5" 

c3e9 ed78      in      a,(c)			; read "read register 0" of Z80 DART
c3eb 0f        rrca 					; transfer bit 0 ("Rx character available")   
c3ec 9f        sbc     a,a
c3ed d8        ret     c

c3ee cd24c4    call    $c424			; set DTR

c3f1 ed78      in      a,(c)			; read "read register 0" of Z80 DART
c3f3 0f        rrca    					; transfer bit 0 ("Rx character available")
c3f4 9f        sbc     a,a
c3f5 1829      jr      $c420            ; clear DTR


;;=================================================================
;; serial interface: read received byte from channel 0
;;
;; exit:
;; A = received byte

c3f7 01ddfa    ld      bc,$fadd			
c3fa 21c6ad    ld      hl,$adc6
c3fd 1806      jr      $c405            

;;=================================================================
;; serial interface: read received byte from channel 1
;;
;; exit:
;; A = received byte

c3ff 01dffa    ld      bc,$fadf
c402 21c7ad    ld      hl,$adc7

;;-----------------------------------------------------------------
;; BC = I/O address of channel's control register
;; HL = address of channels "write register 5" 

c405 ed78      in      a,(c)			; read "read register 0" of Z80 DART
c407 0f        rrca    					; transfer bit 0 ("Rx character available")    
c408 3812      jr      c,$c41c          

c40a cd24c4    call    $c424			; set DTR

c40d cdc5c4    call    $c4c5
c410 fe1a      cp      $1a
c412 280c      jr      z,$c420          ; clear DTR

c414 ed78      in      a,(c)			; read "read register 0" of Z80 DART
c416 0f        rrca     				; transfer bit 0 ("Rx character available")   
c417 30f4      jr      nc,$c40d			
      
c419 cd20c4    call    $c420			; clear DTR

c41c 0b        dec     bc				; BC = I/O address of channel's data register
c41d ed78      in      a,(c)			; read data
c41f c9        ret     

;;========================================================================
;; clear DTR output
;; 
;; BC = I/O address of channel's control register
;; HL contains old state of Z80 DART's "write register 5"

c420 1e00      ld      e,$00
c422 1802      jr      $c426            

;;========================================================================
;; set DTR output
;;
;; BC = I/O address of channel's control register
;; HL contains old state of Z80 DART's "write register 5"

c424 1e80      ld      e,$80


;;-------------------------------------------------------------------------------
;; set or clear DTR
;; 
;; entry:
;; E = OR value ($80 will set DTR, $00 will clear DTR)
;; BC = I/O address of channel's control register
;; HL = pointer to Z80 DART's "write register 5" data
;;
;; exit:
;; All registers preserved

c426 f3        di      
c427 f5        push    af

c428 3e05      ld      a,$05			; select write register 5
c42a ed79      out     (c),a

c42c 7e        ld      a,(hl)			; HL contains old state of this register
c42d e67f      and     $7f				; keep all bits but DTR
c42f b3        or      e				; combine with E which contains new state
c430 ed79      out     (c),a			; output

c432 f1        pop     af
c433 fb        ei      
c434 c9        ret     

;;============================================================
;; serial interface: test if possible to transmit for channel 0
;;
c435 01ddfa    ld      bc,$fadd			
c438 1803      jr      $c43d            

;;============================================================
;; serial interface: test if possible to transmit for channel 1
;;
c43a 01dffa    ld      bc,$fadf

;;-------------------------------------------------------------
;; entry:
;; BC = I/O address of channel's control register
;; exit:
;; A = 0 if Tx buffer is empty
;; A <>0 if Tx buffer is full

c43d ed78      in      a,(c)			; read "read register 0" of Z80 DART
c43f e604      and     $04				; isolate "Tx buffer full" status
c441 c8        ret     z

;; Tx buffer full

c442 37        scf     
c443 9f        sbc     a,a
c444 c9        ret     

;;============================================================
;; serial interface: transmit byte through channel 0
;;
;; C = data byte to transmit

c445 79        ld      a,c
c446 01ddfa    ld      bc,$fadd			
c449 1804      jr      $c44f            


;;============================================================
;; serial interface: transmit byte through channel 1
;;
;; C = data byte to transmit


c44b 79        ld      a,c
c44c 01dffa    ld      bc,$fadf

;;-------------------------------------------------------------
;; A = data byte to transmit
;; BC = I/O address of channel's control register

c44f f5        push    af
c450 cdd3c4    call    $c4d3
c453 cd3dc4    call    $c43d			; Tx buffer empty?
c456 30f8      jr      nc,$c450         ; (-$08)
c458 f1        pop     af

c459 0b        dec     bc				; BC = I/O address of channel's data register
c45a ed79      out     (c),a			; write data
c45c c9        ret     

;;============================================================
c45d 21b3c4    ld      hl,$c4b3
c460 1808      jr      $c46a            ; (+$08)
;;============================================================
c462 21bcc4    ld      hl,$c4bc
c465 1803      jr      $c46a            ; (+$03)
;;============================================================
c467 21a1c4    ld      hl,$c4a1
;;--------------------------------------------------------
;; HL = table of functions

;; offset      count       description
;;
;; 0           1           shift
;; 1		   (2*n)       entries in table

c46a 46        ld      b,(hl)			; shift
c46b 23        inc     hl

c46c 3a0300    ld      a,($0003)		;; get IOBYTE
										;; bit 7,6: LIST field
										;; bit 5,4: PUNCH field
										;; bit 3,2: READER field
										;; bit 1,0: CONSOLE field

;; shift A to isolate the appropiate field
;; and multiply it by 2 to use as a look up into a table
;; of 16-bit addressess
c46f 07        rlca						;; x2
c470 10fd      djnz    $c46f            ;; ..loop

;; A = offset into table
c472 e606      and     $06				; %110 
c474 1600      ld      d,$00
c476 5f        ld      e,a
c477 19        add     hl,de
c478 5e        ld      e,(hl)			; get address of function 
c479 23        inc     hl
c47a 56        ld      d,(hl)
c47b eb        ex      de,hl
c47c e9        jp      (hl)				; execute function

;;--------------------------------------------------------

c47d 
defb &01							;; shift for CONSOLE field of IOBYTE
defw &bea7
defw &c313							;; read char
defw &c45d							;; list
defw &beb3

c486 
defb &01							;; shift for CONSOLE field of IOBYTE
defw &beaa
defw &c326						;; read keyboard
defw &c462
defw &beb6

c48f 
defb &01							;; shift for CONSOLE field of IOBYTE
defw &beb0
defw &c35b						;; write char to screen
defw &c467
defw &bebc

c498 
defb &03							;; shift for READER field of IOBYTE
defw &bead
defw &c358						;; unimplemented function?
defw &c379						;; test printer is ready
defw &beb9

c4a1 
defb &03							;; shift for READER field of IOBYTE
defw &beb0
defw &c35b						;; write char to screen
defw &c37f						;; print char
defw &bebc

c4aa 
defb &05							;; shift for PUNCH field of IOBYTE
defw &beb0
defw &c35a						;; unimplemented (no errro)
defw &bebc
defw &c35b						;; write char to screen

c4b3:
defb &07							;; shift for LIST field of IOBYTE
defw &bea7
defw &c358					;; unimplemented function??
defw &beb3
defw &c313					;; peek at keyboard buffer

c4bc:
defb &07							;; shift for LIST field of IOBYTE
defw &beaa
defw &c355					;; end of stream??
defw &beb6
defw &c326					;; read char into buffer?


;;--------------------------------------------------------------------------

c4c5 cdd3c4    call    $c4d3
c4c8 fe13      cp      $13
c4ca c0        ret     nz

c4cb e5        push    hl
c4cc c5        push    bc
c4cd cd26c3    call    $c326
c4d0 c1        pop     bc
c4d1 e1        pop     hl
c4d2 c9        ret     

c4d3 e5        push    hl
c4d4 d5        push    de
c4d5 c5        push    bc
c4d6 cd13c3    call    $c313
c4d9 b7        or      a
c4da 280f      jr      z,$c4eb          ; (+$0f)
c4dc cd26c3    call    $c326
c4df fe03      cp      $03
c4e1 2008      jr      nz,$c4eb         ; (+$08)
c4e3 3e0d      ld      a,$0d			; "...^C"
c4e5 cdebca    call    $caeb			; display message
c4e8 c32bc2    jp      $c22b
c4eb c1        pop     bc
c4ec d1        pop     de
c4ed e1        pop     hl
c4ee c9        ret     

;;=================================================================================
;; unused

c4ef ff        rst     $38

;;=================================================================================
;; setup XDPB, and get address of drive's XDPB
;;
;; entry:
;; IY = base address of AMSDOS work RAM
;; C = drive index
;; E = ?
;;
;; exit:
;; carry clear:
;;    error
;; carry set: 
;;    HL = address of drive's XDPB
;; XDPB is updated to reflect format

c4f0 79        ld      a,c
c4f1 fe02      cp      $02
c4f3 210000    ld      hl,$0000
c4f6 d0        ret     nc				; quit if drive index is >=2

;; drive is 0 or 1

c4f7 7b        ld      a,e
c4f8 1f        rra						; transfer bit 0 into carry
c4f9 380f      jr      c,$c50a          ; force

c4fb 59        ld      e,c
c4fc 3e18      ld      a,$18			;; XDPB: detect format flag
c4fe cd5cca    call    $ca5c			;; get XDPB parameter by index
c501 b7        or      a				;; test detect format flag
										;; 0: detect format
										;; <>0: do not detect format
c502 2006      jr      nz,$c50a         

;; detect format using "read id"

c504 e5        push    hl
c505 cd6cc5    call    $c56c			; detect format on disc and setup XDPB
c508 e1        pop     hl
c509 d0        ret     nc


c50a 79        ld      a,c
c50b 3253be    ld      ($be53),a

;; get offset of XDPB in AMSDOS work ram
c50e 211002    ld      hl,$0210			;; offset of XDPB for drive 0
c511 b7        or      a
c512 2803      jr      z,$c517          
c514 212002    ld      hl,$0220			;; offset of XDPB for drive 1

;; calculate address of XDPB 
c517 c39fca    jp      $ca9f			;; HL = HL + IY

;;=================================================================================
;; CP/M function "setdma"
;;
;; BC = address

c51a ed4360be  ld      ($be60),bc
c51e c9        ret     

;;=================================================================================

c51f cd6fc8    call    $c86f
c522 0e00      ld      c,$00
c524 79        ld      a,c
c525 3254be    ld      ($be54),a
c528 c9        ret     

;;=================================================================================
;; CP/M function "setsec"
;;
;; C = sector

c529 79        ld      a,c
c52a 3255be    ld      ($be55),a
c52d c9        ret     

;;=================================================================================

c52e c5        push    bc
c52f 79        ld      a,c
c530 fe02      cp      $02
c532 ccebc7    call    z,$c7eb
c535 cd00c8    call    $c800
c538 dc1bc8    call    c,$c81b
c53b cd32c8    call    $c832
c53e c1        pop     bc
c53f d0        ret     nc

c540 cdb6c8    call    $c8b6
c543 0d        dec     c
c544 37        scf     
c545 cc6fc8    call    z,$c86f
c548 d0        ret     nc
c549 3e00      ld      a,$00
c54b c9        ret     

c54c af        xor     a
c54d 3259be    ld      ($be59),a
c550 cd32c8    call    $c832
c553 cdc7c8    call    $c8c7
c556 d0        ret     nc
c557 3e00      ld      a,$00
c559 c9        ret     

;;=================================================================================
;; CP/M function "sectran"

c55a 60        ld      h,b
c55b 69        ld      l,c
c55c c9        ret     

;;=================================================================================
;; E = bits 1,0: drive, bit 2: side

c55d 017efb    ld      bc,$fb7e			;; BC = I/O address of FDC main status register
c560 3e4a      ld      a,$4a			;; read id
c562 cd5cc9    call    $c95c			;; fdc: send command byte
c565 7b        ld      a,e				;; drive 
c566 cd5cc9    call    $c95c			;; fdc: send command byte
c569 c3f9c8    jp      $c8f9

;;=================================================================================
;; detect format on disc and setup XDPB
;;
;; 
;; E = drive
;;
;; NOTES:
;; - uses current track
;; - performs a read ID and uses sector ID to select the format

c56c cd76c9    call    $c976			;; spin up drive motor
c56f 3e16      ld      a,$16			;; XDPB: current track
c571 cd5cca    call    $ca5c			;; get XDPB parameter by index
c574 57        ld      d,a				;; D = current track
c575 0e10      ld      c,$10
c577 215dc5    ld      hl,$c55d			;; read id function
c57a cdffc6    call    $c6ff			;; execute function with retry
c57d d0        ret     nc

;; read id succeeded

;; get sector id
c57e 3a51be    ld      a,($be51)		;; R from result phase data

;; select format

;;=================================================================================
;;BIOS: SELECT FORMAT
;;
;; entry:
;; A = id of format
;; &41 (SYSTEM/VENDOR), &c1 (DATA), &01 (IBM)
;;
;; these are the only formats supported by AMSDOS
;;
;; only bits 7 and 6 of the id are important so:
;; 
;; %11xxxxxx = DATA
;; %10xxxxxx = IBM
;; %01xxxxxx = SYSTEM
;; %00xxxxxx = IBM
;;

c581 f5        push    af
c582 af        xor     a				;; XDPB: SPT
c583 cd63ca    call    $ca63			;; get address of XDPB parameter
c586 e5        push    hl
c587 eb        ex      de,hl
c588 2143ca    ld      hl,$ca43			; full XPDB (setup for SYSTEM format)
c58b 011600    ld      bc,$0016
c58e edb0      ldir    
c590 e1        pop     hl
c591 f1        pop     af
c592 e6c0      and     $c0
c594 fe40      cp      $40				; system?
c596 37        scf     
c597 c8        ret     z				

c598 11cac5    ld      de,$c5ca			; definition for DATA format
c59b fec0      cp      $c0				; DATA FORMAT
c59d 2803      jr      z,$c5a2          ; (+$03)

c59f 11c0c5    ld      de,$c5c0			; definition for IBM format

c5a2 1a        ld      a,(de)
c5a3 13        inc     de
c5a4 77        ld      (hl),a
c5a5 23        inc     hl
c5a6 1a        ld      a,(de)
c5a7 13        inc     de
c5a8 77        ld      (hl),a
c5a9 010400    ld      bc,$0004
c5ac 09        add     hl,bc
c5ad 1a        ld      a,(de)
c5ae 13        inc     de
c5af 77        ld      (hl),a
c5b0 23        inc     hl
c5b1 1a        ld      a,(de)
c5b2 13        inc     de
c5b3 77        ld      (hl),a
c5b4 010700    ld      bc,$0007
c5b7 09        add     hl,bc
c5b8 eb        ex      de,hl
c5b9 010600    ld      bc,$0006
c5bc edb0      ldir    
c5be 37        scf     
c5bf c9        ret     

;; offset 0,1:
;; offset 2,3: number of clusters
;; offset 4,5:
;; offset 6: first sector id
;; offset 7: sectors per track
;; offset 8: gap length for reading/writing
;; offset 9: gap length for format

;; IBM format
c5c0 
defb &20, &00, &9b, &00, &01, &00, &01, &08, &2a, &50
;; DATA format
c5ca:
defb &24, &00, &b3, &00, &00, &00, &c1, &09, &2a, &52

;; default BIOS: SETUP DISC parameters
c5d4:
defw &0032			;; motor on time in 20ms units
defw &00fa			;; motor off time in 20ms units
defb &af			;; write off time in 10ms units
defb &0f			;; head settle time in 1ms units
defb &0c			;; step rate in 1ms units
defb &01			;; head unload delay
defb &03			;; head load delay and dma flag

;;=================================================================================

c5dd 1140be    ld      de,$be40
c5e0 013d00    ld      bc,$003d
c5e3 cdafca    call    $caaf				; clear memory

c5e6 cdf4c9    call    $c9f4

c5e9 cde8c9    call    $c9e8				;; turn off drive motor & set drive motor status flag

;; initialise disc parameters
c5ec 21d4c5    ld      hl,$c5d4
c5ef cd0dc6    call    $c60d				;; BIOS: SETUP DISC

;; get the 'rom select' for this rom
c5f2 cd12b9    call    $b912				;; firmware function: KL CURR SELECTION

;; setup event for controlling drive motor off
c5f5 4f        ld      c,a					;; rom select
c5f6 0680      ld      b,$80				;; event class
c5f8 216dbe    ld      hl,$be6d				;; address of event block
c5fb 11d6c9    ld      de,$c9d6				;; event routine (drive motor ticker function)
c5fe cdefbc    call    $bcef				;; firmware function: KL INIT EVENT

;; finally set the retry count
c601 3e10      ld      a,$10				;; default retry count (16)


;;==========================================================
;; BIOS: SET RETRY COUNT
;; 
;; entry:
;; A = new count
;;
;; exit:
;; A = previous count
;; 
c603 e5        push    hl
c604 2a66be    ld      hl,($be66)
c607 3266be    ld      ($be66),a
c60a 7d        ld      a,l
c60b e1        pop     hl
c60c c9        ret     

;;==========================================================
;; BIOS: SETUP DISC
;; 
;; entry:
;; HL = nine bytes making up parameter block

c60d 1144be    ld      de,$be44
c610 010700    ld      bc,$0007
c613 edb0      ldir    

c615 017efb    ld      bc,$fb7e			;; BC = I/O address of FDC main status register
c618 3e03      ld      a,$03			;; specify command
c61a cd5cc9    call    $c95c			;; fdc: send command byte
c61d 3a4abe    ld      a,($be4a)
c620 3d        dec     a
c621 07        rlca    
c622 07        rlca    
c623 07        rlca    
c624 2f        cpl     
c625 e6f0      and     $f0
c627 b6        or      (hl)
c628 cd5cc9    call    $c95c			;; fdc: send command byte
c62b 23        inc     hl
c62c 7e        ld      a,(hl)
c62d c35cc9    jp      $c95c			;; fdc: send command byte

;;==================================================================
;; BIOS: GET DRIVE STATUS
;;
;; entry:
;; A = drive number
;;
;; exit:
;; A = status byte

c630 cd38c6    call    $c638
c633 d0        ret     nc

c634 3a4cbe    ld      a,($be4c)		;; drive status byte
c637 c9        ret     

;;==================================================================
;; sense drive status
;; A = drive 

c638 cd76c9    call    $c976			;; start disc motor			
c63b f5        push    af
c63c cd47c9    call    $c947			;; clear fdc interrupt
c63f 017efb    ld      bc,$fb7e			;; BC = I/O address of FDC main status register
c642 3e04      ld      a,$04			;; sense drive status command
c644 cd5cc9    call    $c95c			;; fdc: send command byte
c647 f1        pop     af
c648 cd5cc9    call    $c95c			;; fdc: send command byte
c64b c31cc9    jp      $c91c			;; fdc: get result phase

;;==================================================================
;; BIOS: WRITE SECTOR
;;
;; entry:
;; HL = buffer
;; E = drive & side
;; D = track
;; C = sector id
;;
;; NOTES:
;; - H parameter is forced to 0
;; - N parameter comes from XDPB
;; - R parameter defined by user
;; - only 1 sector written at a time
;; - C parameter defined by user (must be valid track number)
;; - double density only
;; - "write data" only

c64e 3e45      ld      a,$45			;; write data
c650 1802      jr      $c654            

;;==================================================================
;; BIOS: FORMAT TRACK
;;
;; entry:
;; HL = table of C,H,R,N for each sector
;; E = drive
;; D = track
;;
;; NOTES:
;; - N parameter for format from XDPB
;; - SC parameter for format from XDPB
;; - GPL parameter for format from XDPB
;; - D parameter for format from XDPB
;; - double density only
;; - C,H,R,N for each sector id field can be any values therefore possible to write
;;   strange formats

c652 3e4d      ld      a,$4d			;; "format track" command (mfm)
c654 cd76c9    call    $c976			
c657 0611      ld      b,$11
c659 cd6dc6    call    $c66d
c65c 3a48be    ld      a,($be48)
c65f 3d        dec     a
c660 03        inc     bc
c661 03        inc     bc
c662 03        inc     bc
c663 20fa      jr      nz,$c65f         ; (-$06)
c665 c9        ret     

;;==================================================================
;; BIOS: READ SECTOR
;;
;; HL = buffer
;; E = drive
;; D = track
;; C = sector id
;;
;; NOTES:
;; - H parameter is forced to 0
;; - N parameter comes from XDPB
;; - R parameter defined by user
;; - only 1 sector read at a time
;; - C parameter defined by user (must be valid track number)
;; - double density only
;; - "read data" only + skip


c666 cd76c9    call    $c976
c669 3e66      ld      a,$66			;; read data (mfm, skip)

c66b 0610      ld      b,$10

c66d 2262be    ld      ($be62),hl
c670 67        ld      h,a				;; fdc command code
c671 69        ld      l,c				;; R = sector id
c672 2274be    ld      ($be74),hl
c675 48        ld      c,b
c676 217cc6    ld      hl,$c67c			;; execute "read data","write data" or "format track" command
c679 c3ffc6    jp      $c6ff			;; execute function with retry

;;==================================================================
;; execute "read data","write data" or "format track" command
;; 
;; E = drive and side
;; D = C parameter

c67c 2a74be    ld      hl,($be74)
;; (&be74) = R parameter
;; (&be75) = fdc command code

c67f 017efb    ld      bc,$fb7e			;; BC = I/O address for FDC main status register
c682 7c        ld      a,h				;; fdc command code
c683 cd5cc9    call    $c95c			;; fdc: send command byte
c686 7b        ld      a,e				;; drive and side
c687 cd5cc9    call    $c95c			;; fdc: send command byte
c68a 7c        ld      a,h
c68b fe4d      cp      $4d				;; "format track"  command?
c68d 2016      jr      nz,$c6a5         ;; "read data" or "write data"

;;------------------------------------------------------------------
;; "format track" command
c68f 3e14      ld      a,$14			;; N parameter
c691 cd59c9    call    $c959			;; write XDPB parameter to FDC
c694 3e10      ld      a,$10			;; SC parameter
c696 cd59c9    call    $c959			;; write XDPB parameter to FDC
c699 3e12      ld      a,$12			;; GPL parameter
c69b cd59c9    call    $c959			;; write XDPB parameter to FDC
c69e 3e13      ld      a,$13			;; D parameter
c6a0 cd5cca    call    $ca5c			;; get XDPB parameter by index
c6a3 181c      jr      $c6c1            

;;------------------------------------------------------------------

;; "read data" or "write data" command
c6a5 7a        ld      a,d				;; C parameter
c6a6 cd5cc9    call    $c95c			;; fdc: send command byte
c6a9 af        xor     a				;; H parameter
c6aa cd5cc9    call    $c95c			;; fdc: send command byte
c6ad 7d        ld      a,l				;; R parameter
c6ae cd5cc9    call    $c95c			;; fdc: send command byte
c6b1 3e14      ld      a,$14			;; N parameter
c6b3 cd59c9    call    $c959			;; write XDPB parameter to FDC
c6b6 7d        ld      a,l				;; EOT parameter
c6b7 cd5cc9    call    $c95c			;; fdc: send command byte
c6ba 3e11      ld      a,$11			;; GPL parameter
c6bc cd59c9    call    $c959			;; write XDPB parameter to FDC
c6bf 3eff      ld      a,$ff			;; DTL parameter


c6c1 cdd1c6    call    $c6d1			;; send last byte of command and transfer execution data

c6c4 fb        ei      
c6c5 cd07c9    call    $c907
c6c8 d8        ret     c

c6c9 c0        ret     nz

c6ca 3a4dbe    ld      a,($be4d)
c6cd 87        add     a,a
c6ce d8        ret     c

c6cf af        xor     a
c6d0 c9        ret     

;;==================================================================
;; send last byte of command and transfer execution data
;; 
;; A = command byte
;; H = first command byte (contains FDC command code)

c6d1 f3        di						;; disable interrupts (prevents overrun condition)
c6d2 cd5cc9    call    $c95c			;; fdc: send command byte
c6d5 7c        ld      a,h				;; get FDC command code
c6d6 2a62be    ld      hl,($be62)		;; address of buffer to transfer data to/from 
c6d9 fe66      cp      $66				;; write data command?
c6db 2018      jr      nz,$c6f5         ;; fdc: write data in execution phase
c6dd 1806      jr      $c6e5            ;; fdc: read data in execution phase


;;==================================================================
;; fdc: read data in execution phase
;;
;; quits if data is ready and execution phase has ended

c6df 0c        inc     c				; BC = I/O address for FDC data register
c6e0 ed78      in      a,(c)			; read from FDC data register
c6e2 77        ld      (hl),a			; write to RAM
c6e3 0d        dec     c				; BC = I/O address for FDC main status register
c6e4 23        inc     hl				; increment RAM pointer
;; start here
c6e5 ed78      in      a,(c)			; read FDC main status register
c6e7 f2e5c6    jp      p,$c6e5			; data ready?
c6ea e620      and     $20				; execution phase active?
c6ec 20f1      jr      nz,$c6df         ; go to transfer byte
;; execution phase over
c6ee c9        ret     

;;==================================================================
;; fdc: write data in execution phase
;;
;; quits if data is ready and execution phase has ended

c6ef 0c        inc     c				; BC = I/O address for FDC data register
c6f0 7e        ld      a,(hl)			; read from RAM
c6f1 ed79      out     (c),a			; write to FDC data register
c6f3 0d        dec     c				; BC = I/O address for FDC main status register
c6f4 23        inc     hl				; increment RAM pointer
;; start here
c6f5 ed78      in      a,(c)			; read main status register
c6f7 f2f5c6    jp      p,$c6f5			; data ready?
c6fa e620      and     $20				; execution phase active?
c6fc 20f1      jr      nz,$c6ef         ; go to transfer byte
;; execution phase over
c6fe c9        ret     

;;==================================================================
;; execute function with retry
;;
;; HL = function to execute
;; E = drive & side
;; D = track
;; C = message code if error

c6ff 3a66be    ld      a,($be66)		; retry count
c702 47        ld      b,a

c703 cd2bc7    call    $c72b
c706 d8        ret     c
c707 2819      jr      z,$c722          ; display message then try again
c709 78        ld      a,b
c70a e604      and     $04
c70c 2809      jr      z,$c717          ; (+$09)

;; move to track 39
c70e d5        push    de
c70f 1627      ld      d,$27			; 39
c711 cd66c7    call    $c766			; move to track
c714 d1        pop     de
;; try command again
c715 18ec      jr      $c703            ; (-$14)

c717 e5        push    hl
c718 3e17      ld      a,$17			;; XDPB: aligned flag
c71a cd63ca    call    $ca63			;; get address of XDPB parameter
c71d 3600      ld      (hl),$00
c71f e1        pop     hl
;; try command again
c720 18e1      jr      $c703            ; (-$1f)


;;-------------------------------------------------------------
;; display message, then try again
;;
;; C = message code

c722 79        ld      a,c
c723 c5        push    bc
c724 cd7aca    call    $ca7a			; display message if enabled
c727 c1        pop     bc
c728 20d5      jr      nz,$c6ff         ; try again
c72a c9        ret     

;;-------------------------------------------------------------
;; try command
;;
;; will attempt command,
;; if failure will step up to higher track and try command,
;; if failure again, will step down to lower track and try command.

;; B = retry count
;; D = current track
;; other parameters as required by command
;;
;; assumes tracks are in range 0-39

c72b cd54c7    call    $c754			; move to track, and execute function
c72e d8        ret     c				
c72f c8        ret     z

c730 cd47c9    call    $c947			;; clear fdc interrupt

;; try command again
c733 cd54c7    call    $c754			; move to track and execute function
c736 d8        ret     c
c737 c8        ret     z

;; attempt step to higher track...
c738 7a        ld      a,d				;; get current track
c739 fe27      cp      $27				;; 39?

c73b 05        dec     b
c73c 300a      jr      nc,$c748         
c73e 04        inc     b

;; if not at track 39, do step to higher track 
c73f 14        inc     d
c740 cd66c7    call    $c766			; move to track
c743 15        dec     d

;; try command again
c744 cd54c7    call    $c754			; move to track and execute function
c747 d8        ret     c
c748 c8        ret     z

c749 7a        ld      a,d				;; get track number
c74a b7        or      a				;; at 0?
c74b 2002      jr      nz,$c74f			;; if not at track zero, do step to lower track
										;; and try command again

;; at track zero; can't step to lower track

c74d 05        dec     b				;; decrement retry count
c74e c9        ret     

;; do step to lower track
c74f 15        dec     d
c750 cd66c7    call    $c766			; move to track
c753 14        inc     d

;;-------------------------------------------------------------
;; entry:
;; HL = function to execute
;; D = track
;; E = drive & side
;; B = retry count

;; exit:
;; carry set - function executed with no errors
;; carry clear & zero clear - try again
;; carry clear & zero set - decrement retry count


c754 cd66c7    call    $c766			; move to track
c757 e5        push    hl
c758 c5        push    bc

;; execute function
c759 cd1e00    call    $001e			;firmware function: "PCHL INSTRUCTION"
c75c c1        pop     bc
c75d e1        pop     hl
c75e d8        ret     c
c75f 20f3      jr      nz,$c754         
c761 05        dec     b
c762 c9        ret     

;;=======================================================================
;; BIOS: MOVE TRACK
;;
;; entry:
;; E = drive
;; D = track

c763 cd76c9    call    $c976

c766 e5        push    hl
c767 d5        push    de
c768 c5        push    bc
c769 3a66be    ld      a,($be66)		; retry count
c76c 47        ld      b,a
c76d 3e17      ld      a,$17			;; XDPB: aligned flag
c76f cd63ca    call    $ca63			;; get address of XDPB parameter
c772 7e        ld      a,(hl)
c773 b7        or      a
c774 201f      jr      nz,$c795         ; 

c776 c5        push    bc
c777 017efb    ld      bc,$fb7e			;; BC = I/O address of FDC main status register
c77a 3e07      ld      a,$07			;; recalibrate command
c77c cd5cc9    call    $c95c			;; fdc: send command byte
c77f 7b        ld      a,e
c780 cd5cc9    call    $c95c			;; fdc: send command byte
c783 3e28      ld      a,$28
c785 cdc7c7    call    $c7c7
c788 302a      jr      nc,$c7b4         ; (+$2a)
c78a 3e16      ld      a,$16			;; XDPB: current track
c78c cd63ca    call    $ca63			;; get address of XDPB parameter
c78f 3600      ld      (hl),$00
c791 23        inc     hl
c792 36ff      ld      (hl),$ff
c794 c1        pop     bc

c795 2b        dec     hl
c796 7e        ld      a,(hl)
c797 92        sub     d
c798 2828      jr      z,$c7c2          ; (+$28)

c79a c5        push    bc
c79b 017efb    ld      bc,$fb7e			;; BC = I/O address of FDC main status register
c79e 3e0f      ld      a,$0f			;; seek command
c7a0 cd5cc9    call    $c95c			;; fdc: send command byte
c7a3 7b        ld      a,e
c7a4 cd5cc9    call    $c95c			;; fdc: send command byte
c7a7 7a        ld      a,d
c7a8 cd5cc9    call    $c95c			;; fdc: send command byte
c7ab 96        sub     (hl)
c7ac 3002      jr      nc,$c7b0         ; (+$02)
c7ae 7e        ld      a,(hl)
c7af 92        sub     d
c7b0 72        ld      (hl),d
c7b1 cdc7c7    call    $c7c7
c7b4 c1        pop     bc
c7b5 380b      jr      c,$c7c2          ; (+$0b)
c7b7 20bd      jr      nz,$c776         ; (-$43)
c7b9 05        dec     b
c7ba caadc9    jp      z,$c9ad
c7bd cd47c9    call    $c947			;; clear fdc interrupt
c7c0 18b4      jr      $c776            ; (-$4c)
c7c2 c1        pop     bc
c7c3 d1        pop     de
c7c4 e1        pop     hl
c7c5 37        scf     
c7c6 c9        ret     

c7c7 f5        push    af
c7c8 3a4abe    ld      a,($be4a)
c7cb cde0c7    call    $c7e0			; delay
c7ce f1        pop     af
c7cf 3d        dec     a
c7d0 20f5      jr      nz,$c7c7         ; (-$0b)

c7d2 3a49be    ld      a,($be49)
c7d5 cde0c7    call    $c7e0
c7d8 3e08      ld      a,$08			;; sense interrupt status command
c7da cd5cc9    call    $c95c			;; fdc: send command byte
c7dd c3f9c8    jp      $c8f9

;;==================================================================
;; delay

c7e0 f5        push    af
c7e1 3ef6      ld      a,$f6
c7e3 3d        dec     a
c7e4 20fd      jr      nz,$c7e3         ; (-$03)
c7e6 f1        pop     af
c7e7 3d        dec     a
c7e8 20f6      jr      nz,$c7e0         ; (-$0a)
c7ea c9        ret     

;;==================================================================

c7eb 2153be    ld      hl,$be53
c7ee 5e        ld      e,(hl)
c7ef 3e03      ld      a,$03			;; XDPB: BLM
c7f1 cd5cca    call    $ca5c			;; get XDPB parameter by index
c7f4 3c        inc     a
c7f5 1159be    ld      de,$be59
c7f8 12        ld      (de),a
c7f9 13        inc     de
c7fa 010300    ld      bc,$0003
c7fd edb0      ldir    
c7ff c9        ret     

c800 1159be    ld      de,$be59
c803 1a        ld      a,(de)
c804 b7        or      a
c805 c8        ret     z

c806 13        inc     de
c807 2153be    ld      hl,$be53
c80a 0603      ld      b,$03
c80c 1a        ld      a,(de)
c80d ae        xor     (hl)
c80e 2006      jr      nz,$c816         ; (+$06)
c810 13        inc     de
c811 23        inc     hl
c812 10f8      djnz    $c80c            ; (-$08)
c814 37        scf     
c815 c9        ret     

c816 af        xor     a
c817 3259be    ld      ($be59),a
c81a c9        ret     

c81b f5        push    af
c81c 2159be    ld      hl,$be59
c81f 35        dec     (hl)
c820 23        inc     hl
c821 5e        ld      e,(hl)
c822 23        inc     hl
c823 23        inc     hl
c824 34        inc     (hl)
c825 af        xor     a				;; XDPB: SPT
c826 cd5cca    call    $ca5c			;; get XDPB parameter by index
c829 be        cp      (hl)
c82a 2004      jr      nz,$c830         ; (+$04)
c82c 3600      ld      (hl),$00
c82e 2b        dec     hl
c82f 34        inc     (hl)
c830 f1        pop     af
c831 c9        ret     

c832 f5        push    af
c833 cd54c8    call    $c854
c836 3819      jr      c,$c851          ; (+$19)
c838 cd6fc8    call    $c86f
c83b c1        pop     bc
c83c d0        ret     nc

c83d c5        push    bc
c83e cd80c8    call    $c880
c841 f1        pop     af
c842 3806      jr      c,$c84a          ; (+$06)

c844 cda2c8    call    $c8a2			;; generate sector ID, drive, track and address of sector buffer
c847 cd66c6    call    $c666			;; BIOS: READ SECTOR
c84a f5        push    af
c84b 9f        sbc     a,a
c84c 325ebe    ld      ($be5e),a
c84f f1        pop     af
c850 c9        ret     

c851 f1        pop     af
c852 37        scf     
c853 c9        ret     

c854 3a5ebe    ld      a,($be5e)
c857 b7        or      a
c858 c8        ret     z

c859 0153be    ld      bc,$be53
c85c 2156be    ld      hl,$be56
c85f 5e        ld      e,(hl)
c860 0a        ld      a,(bc)
c861 ae        xor     (hl)
c862 c0        ret     nz

c863 03        inc     bc
c864 23        inc     hl
c865 0a        ld      a,(bc)
c866 ae        xor     (hl)
c867 c0        ret     nz

c868 cd92c8    call    $c892
c86b ae        xor     (hl)
c86c c0        ret     nz

c86d 37        scf     
c86e c9        ret     

c86f 215ebe    ld      hl,$be5e
c872 3600      ld      (hl),$00
c874 2b        dec     hl
c875 7e        ld      a,(hl)
c876 b7        or      a
c877 37        scf     
c878 c8        ret     z

c879 34        inc     (hl)
c87a cda2c8    call    $c8a2		;; generate sector ID, drive, track and address of sector buffer
c87d c34ec6    jp      $c64e		;; BIOS: WRITE SECTOR



c880 2156be    ld      hl,$be56
c883 0153be    ld      bc,$be53
c886 0a        ld      a,(bc)
c887 77        ld      (hl),a
c888 5f        ld      e,a
c889 23        inc     hl
c88a 03        inc     bc
c88b 0a        ld      a,(bc)
c88c 77        ld      (hl),a
c88d cd92c8    call    $c892
c890 77        ld      (hl),a
c891 c9        ret     

c892 03        inc     bc
c893 23        inc     hl
c894 3e15      ld      a,$15			;; XDPB: records per sector
c896 cd5cca    call    $ca5c			;; get XDPB parameter by index
c899 57        ld      d,a
c89a 0a        ld      a,(bc)
c89b cb3a      srl     d
c89d d8        ret     c

c89e cb3f      srl     a
c8a0 18f9      jr      $c89b            ; (-$07)

;;=============================================================================
;; generate sector ID, drive, track and address of sector buffer
;;
;; used for read and write functions

c8a2 ed5b56be  ld      de,($be56)		;; drive and track
c8a6 3e0f      ld      a,$0f			;; XDPB: first sector ID			
c8a8 cd5cca    call    $ca5c			;; get XDPB parameter by index
c8ab 2158be    ld      hl,$be58			;; current sector index
c8ae 86        add     a,(hl)			;; add first sector ID value
c8af 4f        ld      c,a				;; C = final sector ID
c8b0 21b002    ld      hl,$02b0			;; offset of sector buffer in AMSDOS work ram
c8b3 c39fca    jp      $ca9f			;; HL = HL + IY

;;=============================================================================

c8b6 e5        push    hl
c8b7 d5        push    de
c8b8 c5        push    bc
c8b9 f5        push    af
c8ba 3eff      ld      a,$ff
c8bc 325dbe    ld      ($be5d),a
c8bf cdd6c8    call    $c8d6
c8c2 cd1bb9    call    $b91b			;; firmware function: KL LDIR
c8c5 180a      jr      $c8d1            ; (+$0a)

;;-----------------------------------------------------------------------


c8c7 e5        push    hl
c8c8 d5        push    de
c8c9 c5        push    bc
c8ca f5        push    af
c8cb cdd6c8    call    $c8d6
c8ce eb        ex      de,hl
c8cf edb0      ldir    

c8d1 f1        pop     af
c8d2 c1        pop     bc
c8d3 d1        pop     de
c8d4 e1        pop     hl
c8d5 c9        ret     

;;-----------------------------------------------------------------------

c8d6 2153be    ld      hl,$be53
c8d9 5e        ld      e,(hl)
c8da 3e15      ld      a,$15			;; XDPB: records per sector
c8dc cd5cca    call    $ca5c			;; get XDPB parameter by index
c8df 3d        dec     a
c8e0 23        inc     hl
c8e1 23        inc     hl
c8e2 a6        and     (hl)
c8e3 118000    ld      de,$0080
c8e6 213002    ld      hl,$0230
c8e9 3c        inc     a
c8ea 19        add     hl,de
c8eb 3d        dec     a
c8ec 20fc      jr      nz,$c8ea         ; (-$04)
c8ee eb        ex      de,hl
c8ef cd98ca    call    $ca98			;; DE = IY+DE
c8f2 2a60be    ld      hl,($be60)
c8f5 018000    ld      bc,$0080
c8f8 c9        ret     

;;=================================================================
c8f9 cd1cc9    call    $c91c			;; fdc get result phase
c8fc d8        ret     c

c8fd 3a4cbe    ld      a,($be4c)		;; get result phase data byte: fdc status register 0 
c900 e608      and     $08				;; isolate "not ready" flag 
c902 c8        ret     z

;; "not ready" flag is set
c903 3e13      ld      a,$13			;; "Drive <drive>: disc missing"
c905 180d      jr      $c914            

;;=================================================================
c907 cdf9c8    call    $c8f9
c90a d8        ret     c

c90b c0        ret     nz

c90c 3a4dbe    ld      a,($be4d)		;; get result phase data byte: fdc status register 1
c90f e602      and     $02				; isolate "not writeable" flag
c911 c8        ret     z

;; "not writeable" flag is set
;; therefore drive is write protected

c912 3e12      ld      a,$12			; "Drive <drive>: is write protected"
c914 cd7aca    call    $ca7a			; display message if enabled
c917 d8        ret     c

c918 caadc9    jp      z,$c9ad
c91b c9        ret     

;;=================================================================
;; fdc: get result phase
;;
;; read result phase of fdc command
;;
;; entry:
;; BC = I/O address of FDC main status register
;; 
;; exit:
;; D = number of bytes read in result phase
;; A = command result code (bit 7 and 6 of fdc status register 0)
;;
;; zero clear and carry clear if condition was not "command completed successfully"
;; zero set and carry set if condition was "command completed successfully"
;;
;; be4b: number of bytes received in result phase
;; be4c..be53: buffer for result phase data

c91c e5        push    hl
c91d d5        push    de
c91e 1600      ld      d,$00			; initialise count of result bytes received
c920 214cbe    ld      hl,$be4c			; buffer for result phase data
c923 e5        push    hl

c924 ed78      in      a,(c)			; read FDC main status register
c926 fec0      cp      $c0				; "data ready" & "data direction from fdc to cpu"
c928 38fa      jr      c,$c924          

c92a 0c        inc     c				; BC = I/O address of FDC data register
c92b ed78      in      a,(c)			; read data from FDC data register
c92d 0d        dec     c				; BC = I/O address of FDC main status register
c92e 77        ld      (hl),a			; store result byte in buffer
c92f 23        inc     hl				; increment buffer point
c930 14        inc     d				; increment count of result bytes received

c931 3e05      ld      a,$05			
c933 3d        dec     a				
c934 20fd      jr      nz,$c933			

;; is FDC busy 
;; - if set, FDC has not completed command and furthur result bytes are
;; available to be read,
;; - if clear, FDC has completed command and all result bytes have been
;; read by CPU

c936 ed78      in      a,(c)			; read FDC main status register
c938 e610      and     $10				; "FDC busy"?
c93a 20e8      jr      nz,$c924         

c93c e1        pop     hl
;; HL = start of result phase data buffer
c93d 7e        ld      a,(hl)			; read first status byte (FDC status register 0)
c93e e6c0      and     $c0				; isolate execution status
c940 2b        dec     hl
c941 72        ld      (hl),d			; store count
c942 d1        pop     de
c943 e1        pop     hl
c944 c0        ret     nz

c945 37        scf     
c946 c9        ret     

;;========================================================
;; clear fdc interrupt

c947 c5        push    bc
c948 017efb    ld      bc,$fb7e			; BC = I/O address of FDC main status register

c94b 3e08      ld      a,$08			;; sense interrupt status
c94d cd5cc9    call    $c95c			;; ;; fdc: send command byte 
c950 cd1cc9    call    $c91c			;; fdc: get result phase
c953 fe80      cp      $80				;; "invalid"?
c955 20f4      jr      nz,$c94b         

c957 c1        pop     bc
c958 c9        ret     

;;========================================================
;; write XDPB parameter to FDC
;;
;; A = XDPB parameter index

;; get data for parameter defined in A register
c959 cd5cca    call    $ca5c			;; get XDPB parameter by index

;;========================================================
;; fdc: send command byte
;;
;; BC = I/O address of FDC main status register
;; A = data byte to write to FDC

c95c f5        push    af
c95d f5        push    af
;; fdc ready to accept data?
c95e ed78      in      a,(c)			; read FDC main status register
c960 87        add     a,a				; transfer bit 7 ("data ready") to carry
c961 30fb      jr      nc,$c95e         
;; data direction to fdc?
c963 87        add     a,a				; transfer bit 6 ("data direction") to carry
c964 3003      jr      nc,$c969         

;; conditions not met: fail
c966 f1        pop     af
c967 f1        pop     af
c968 c9        ret     

;;--------------------------------------------------------
;; conditions match to write command byte to fdc
c969 f1        pop     af
c96a 0c        inc     c				; BC = I/O address for FDC data register
c96b ed79      out     (c),a			; write data to FDC data register
c96d 0d        dec     c				; BC = I/O address for FDC main status register

;; delay
c96e 3e05      ld      a,$05
c970 3d        dec     a
c971 00        nop     
c972 20fc      jr      nz,$c970         

;; success
c974 f1        pop     af
c975 c9        ret     

;;====================================================================

c976 2276be    ld      ($be76),hl
c979 e3        ex      (sp),hl
c97a d5        push    de
c97b c5        push    bc
c97c ed7364be  ld      ($be64),sp
c980 e5        push    hl
c981 21adc9    ld      hl,$c9ad
c984 e3        ex      (sp),hl
c985 e5        push    hl
c986 d5        push    de
c987 c5        push    bc
c988 f5        push    af
c989 cddfc9    call    $c9df			;; delete ticker

;; is motor already on?
c98c 3a5fbe    ld      a,($be5f)		;; get motor state flag
c98f b7        or      a
c990 2014      jr      nz,$c9a6         

;; motor wasn't already on, switch it on

c992 017efa    ld      bc,$fa7e			;; motor on
c995 3e01      ld      a,$01
c997 ed79      out    (c),a

;; install ticker
c999 ed5b44be  ld      de,($be44)
c99d cdcdc9    call    $c9cd

;; wait until motor flag signals drive is on
c9a0 3a5fbe    ld      a,($be5f)
c9a3 b7        or      a
c9a4 28fa      jr      z,$c9a0          

c9a6 f1        pop     af
c9a7 c1        pop     bc
c9a8 d1        pop     de
c9a9 2a76be    ld      hl,($be76)
c9ac c9        ret     

;;=====================================================================

c9ad ed7b64be  ld      sp,($be64)
c9b1 f5        push    af
c9b2 ed5b46be  ld      de,($be46)
c9b6 cdcdc9    call    $c9cd			;; turn off ticker
c9b9 f1        pop     af
c9ba c1        pop     bc
c9bb d1        pop     de
c9bc e1        pop     hl
c9bd 3e00      ld      a,$00
c9bf d8        ret     c

c9c0 214cbe    ld      hl,$be4c
c9c3 7e        ld      a,(hl)
c9c4 e608      and     $08
c9c6 23        inc     hl
c9c7 b6        or      (hl)
c9c8 f640      or      $40
c9ca 2b        dec     hl
c9cb 2b        dec     hl
c9cc c9        ret     

;;===========================================================================
;; install motor off ticker

c9cd 2167be    ld      hl,$be67			;; address of event block
c9d0 010000    ld      bc,$0000
c9d3 c3e9bc    jp      $bce9			;; firmware function: kl add ticker

;;===========================================================================
;; drive motor ticker function

c9d6 215fbe    ld      hl,$be5f

;; change motor flag state
c9d9 7e        ld      a,(hl)
c9da 2f        cpl     
c9db 77        ld      (hl),a

;; new state is off?
c9dc b7        or      a
c9dd 2806      jr      z,$c9e5          ;; turn off motor, set flag, and delete ticker

;; new state is on. 
c9df 2167be    ld      hl,$be67			;; address of event block
c9e2 c3ecbc    jp      $bcec			;; firmware function: kl del ticker

;;===========================================================================
;; turn off motor

;; delete ticker
c9e5 cddfc9    call    $c9df

;; turn off drive motor
c9e8 3e00      ld      a,$00			
c9ea 017efa    ld      bc,$fa7e
c9ed ed79      out     (c),a

;; set disc motor flag
c9ef af        xor     a
c9f0 325fbe    ld      ($be5f),a
c9f3 c9        ret     

;;===========================================================================

c9f4 212002    ld      hl,$0220			;; offset of XDPB for drive 1
c9f7 11d001    ld      de,$01d0
c9fa cd03ca    call    $ca03
c9fd 211002    ld      hl,$0210			;; offset of XDPB for drive 0
ca00 119001    ld      de,$0190

ca03 cd98ca    call    $ca98			;; DE = IY+DE
ca06 ed5342be  ld      ($be42),de		;; address of XDPB

ca0a d5        push    de
ca0b cd9fca    call    $ca9f			;; HL = HL + IY
ca0e 2240be    ld      ($be40),hl
ca11 e5        push    hl
ca12 2143ca    ld      hl,$ca43
ca15 011900    ld      bc,$0019
ca18 edb0      ldir    
ca1a 4b        ld      c,e
ca1b 42        ld      b,d
ca1c e1        pop     hl
ca1d 3600      ld      (hl),$00
ca1f 23        inc     hl
ca20 3600      ld      (hl),$00
ca22 110700    ld      de,$0007
ca25 19        add     hl,de
ca26 113002    ld      de,$0230
ca29 cd98ca    call    $ca98			;; DE = IY+DE
ca2c 73        ld      (hl),e
ca2d 23        inc     hl
ca2e 72        ld      (hl),d
ca2f 23        inc     hl
ca30 d1        pop     de
ca31 73        ld      (hl),e
ca32 23        inc     hl
ca33 72        ld      (hl),d
ca34 23        inc     hl
ca35 71        ld      (hl),c
ca36 23        inc     hl
ca37 70        ld      (hl),b
ca38 23        inc     hl
ca39 eb        ex      de,hl
ca3a 211000    ld      hl,$0010
ca3d 09        add     hl,bc
ca3e eb        ex      de,hl
ca3f 73        ld      (hl),e
ca40 23        inc     hl
ca41 72        ld      (hl),d
ca42 c9        ret     

;; DPB variables 
ca43:
defb &24,&00,&03,&07,&00,&aa,&00,&3f,&00,&c0,&00,&10,&00,&02,&00,&41,&09,&2a,&52,&e5,&02,&04,&00,&00,&00


;;===========================================================================
;; get XDPB parameter by index
;;
;; entry:
;; A = XDPB parameter index
;; E = drive
;; exit:
;; A = parameter data
;; HL,DE preserved
;; Flags corrupt
;;
;;
;; offset		length		
;; 0			2						SPT
;; 2			1						BSH
;; 3			1						BLM
;; 4			1						EXM
;; 5			2						DSM
;; 7			2						DRM
;; 9			1						AL0
;; 10 ($0a)		1						AL1
;; 11 ($0b)		2						CKS
;; 13 ($0d)		2						OFF
;; 15 ($0f)		1						sector id
;; 16 ($10)		1						sectors/track
;; 17 ($11)		1						gap length (read/write)
;; 18 ($12)		1						gap length (format)
;; 19 ($13)		1						filler byte
;; 20 ($14)		1						sector size (N)
;; 21 ($15)		1						records per sector
;; 22 ($16)		1						current track
;; 23 ($17)		1						aligned
;; 24 ($18)		1						auto select


ca5c e5        push    hl
ca5d cd63ca    call    $ca63			;; get address of XDPB parameter
ca60 7e        ld      a,(hl)
ca61 e1        pop     hl
ca62 c9        ret     


;;===========================================================================
;; get address of XDPB parameter
;;
;; entry:
;; A = XDPB parameter index
;; E = drive (E=0 or E>1 -> drive 0, E=1 -> drive 1)
;; exit:
;; DE preserved
;; HL = address of XDPB parameter data
;; Flags corrupt

ca63 d5        push    de
ca64 2a42be    ld      hl,($be42)		; HL = XDPB for drive 0 
ca67 1d        dec     e
ca68 114000    ld      de,$0040			; size of XDPB data
ca6b 2001      jr      nz,$ca6e         ; 
ca6d 19        add     hl,de			; HL = XDPB for drive 1
;; add offset of XDPB parameter index
ca6e 5f        ld      e,a
ca6f 19        add     hl,de
ca70 d1        pop     de
ca71 c9        ret     

;;===========================================================================
;; BIOS: SET MESSAGE
;; A = boolean state
;; A=0: enable messages
;; A<>0: disable messages
ca72 2a78be    ld      hl,($be78)
ca75 3278be    ld      ($be78),a
ca78 7d        ld      a,l
ca79 c9        ret     

;;===========================================================================
;; display message if enabled with with "Retry,Ignore and Cancel"
;;
;; A = message code
ca7a f5        push    af
ca7b 3a78be    ld      a,($be78)		; messages enabled?
ca7e b7        or      a
ca7f 2005      jr      nz,$ca86         ; (+$05)
ca81 f1        pop     af
ca82 4b        ld      c,e
ca83 c3b8ca    jp      $cab8			; display message with "Retry,Ignore and Cancel"
ca86 f1        pop     af
ca87 af        xor     a
ca88 c9        ret     

;;===============================================================
;; unused

ca89 ff        rst     $38
ca8a ff        rst     $38
ca8b ff        rst     $38
ca8c ff        rst     $38
ca8d ff        rst     $38
ca8e ff        rst     $38
ca8f ff        rst     $38

;;===============================================================
;; BC = IY+BC

;; push IY onto stack
ca90 fde5      push    iy
;; exchange HL with top of stack (HL now on top of stack)
ca92 e3        ex      (sp),hl
;; add BC
ca93 09        add     hl,bc
;; transfer result to BC
ca94 44        ld      b,h
ca95 4d        ld      c,l
;; restore original HL value
ca96 e1        pop     hl
ca97 c9        ret     

;;===============================================================
;; DE = IY+DE

;; push IY onto stack
ca98 fde5      push    iy
;; exchange HL with top of stack (HL now on top of stack)
ca9a e3        ex      (sp),hl
;; add DE
ca9b 19        add     hl,de
;; swap DE and HL (transfers result to HL)
ca9c eb        ex      de,hl
;; restore original HL value
ca9d e1        pop     hl
ca9e c9        ret     

;;===============================================================
;; HL = HL + IY
ca9f d5        push    de
caa0 fde5      push    iy
caa2 d1        pop     de
caa3 19        add     hl,de
caa4 d1        pop     de
caa5 c9        ret     


;;===============================================================
;; convert character to upper case 
;;
;; A = character code
;;
caa6 fe61      cp      $61			; 'a'
caa8 d8        ret     c
caa9 fe7b      cp      $7b			; 'z'
caab d0        ret     nc
caac c6e0      add     a,$e0
caae c9        ret     


;;===============================================================
;; clear memory
;;
;; DE = address
;; BC = length

caaf af        xor     a
cab0 12        ld      (de),a
cab1 13        inc     de
cab2 0b        dec     bc
cab3 78        ld      a,b
cab4 b1        or      c
cab5 20f8      jr      nz,$caaf         ; (-$08)
cab7 c9        ret     

;;===============================================================
;; display message ignoring "bios: set message" state.
;; 
;; A = message code

cab8 cdebca    call    $caeb			; display message
cabb 3e14      ld      a,$14			; "Retry, Ignore or Cancel?" message
cabd cdebca    call    $caeb			; display message

;; clear keyboard buffer
cac0 cd09bb    call    $bb09			; firmware function: KM READ CHAR
cac3 38fb      jr      c,$cac0          ; keep reading chars until buffer is empty

cac5 cd81bb    call    $bb81			; firmware function: TXT CUR ON

cac8 cd06bb    call    $bb06			; firmware function: KM WAIT CHAR
cacb cda6ca    call    $caa6			; convert character to upper case
cace fe43      cp      $43				; 'C'
cad0 2811      jr      z,$cae3          ; 

cad2 fe49      cp      $49				; 'I'
cad4 37        scf     
cad5 280c      jr      z,$cae3          ; 
cad7 fe52      cp      $52				; 'R'
cad9 2807      jr      z,$cae2          

;; invalid char entered

;; make a audible beep
cadb 3e07      ld      a,$07
cadd cd5abb    call    $bb5a			; firmware function: txt output
;; check keys
cae0 18e6      jr      $cac8            ;

;;--------------------------------------------------------------

cae2 b7        or      a
cae3 cd5abb    call    $bb5a			; firmware function: txt output
cae6 cd84bb    call    $bb84			; firmware function: txt cur off

;;--------------------------------------------------------------
;; display CR,LF
cae9 3e00      ld      a,$00

;;--------------------------------------------------------------
;; display message
;; 
;; A = message code

caeb e5        push    hl
caec c5        push    bc
caed f5        push    af
caee e67f      and     $7f
caf0 2186cb    ld      hl,$cb86
caf3 47        ld      b,a
caf4 04        inc     b
caf5 1805      jr      $cafc            ; (+$05)

;; count strings to find start of string wanted
caf7 7e        ld      a,(hl)			; get character
caf8 23        inc     hl				; increment pointer
caf9 3c        inc     a				; increment character code (&ff->&00)
cafa 20fb      jr      nz,$caf7         ; if not zero, not found end of string marker, 
										; if zero found end of string marker
cafc 10f9      djnz    $caf7			; decrement string count

;; HL = start of string to display

cafe 7e        ld      a,(hl)			; get character/code from string
caff 23        inc     hl				; increment pointer
cb00 feff      cp      $ff				; end of string marker?
cb02 280b      jr      z,$cb0f          

;; not end of string marker

cb04 e5        push    hl
cb05 d5        push    de
cb06 c5        push    bc
cb07 cd13cb    call    $cb13			; "execute character/code"
cb0a c1        pop     bc
cb0b d1        pop     de
cb0c e1        pop     hl
cb0d 18ef      jr      $cafe            ; loop for next character/code in string

;; finished displaying string...
cb0f f1        pop     af
cb10 c1        pop     bc
cb11 e1        pop     hl
cb12 c9        ret     

;;-------------------------------------------------------------------

;; -ve codes:
;; 0x0ff = end of string marker
;; 0x0fe = display letter of current drive (C = drive number)
;; 0x0fd = display filename (DE = address of filename)
;; 0x0fc = display 3 digit number (DE = number)
;; 0x080-0x0fb = display message indicated by bits 6..0
;;
;; +ve codes:
;; &00-&1f, &21-&7f = display character
;; &20 = if there is enough space on line, then display space, otherwise display a new-line
;;


cb13 b7        or      a				; +ve code?
cb14 f266cb    jp      p,$cb66

;; -ve code
cb17 fefe      cp      $fe				
cb19 2846      jr      z,$cb61			; display drive letter
cb1b fefc      cp      $fc
cb1d 281a      jr      z,$cb39			; display current user number  
cb1f fefd      cp      $fd
cb21 20c8      jr      nz,$caeb         ; display message

;; display name part of filename
cb23 0608      ld      b,$08
cb25 cd2fcb    call    $cb2f
;; display filename and extension seperator 
cb28 3e2e      ld      a,$2e			; '.'
cb2a cd83cb    call    $cb83
;; display extension part of filename
cb2d 0603      ld      b,$03

;;-------------------------------------------------------------------
;; display string
;; DE = pointer to characters
;; B = length of string in characters
cb2f 13        inc     de
cb30 1a        ld      a,(de)
cb31 e67f      and     $7f
cb33 cd83cb    call    $cb83
cb36 10f7      djnz    $cb2f            ; (-$09)
cb38 c9        ret     

;;-------------------------------------------------------------------
;; code 0x0fc
;;
;; display 3 digit number 

cb39 eb        ex      de,hl
cb3a 1620      ld      d,$20
cb3c 019cff    ld      bc,$ff9c
cb3f cd4dcb    call    $cb4d
cb42 01f6ff    ld      bc,$fff6
cb45 cd4dcb    call    $cb4d
cb48 7d        ld      a,l
cb49 c630      add     a,$30			; '0'
cb4b 1836      jr      $cb83            ; (+$36)

;;-------------------------------------------------------------------
;; display furthur digits (used by display user number)
cb4d 3eff      ld      a,$ff
cb4f e5        push    hl
cb50 3c        inc     a
cb51 09        add     hl,bc
cb52 3004      jr      nc,$cb58         ; (+$04)
cb54 e3        ex      (sp),hl
cb55 e1        pop     hl
cb56 18f7      jr      $cb4f            ; (-$09)
cb58 e1        pop     hl
cb59 b7        or      a
cb5a 2802      jr      z,$cb5e          ; (+$02)

cb5c 1630      ld      d,$30			; '0'
cb5e 82        add     a,d
cb5f 1822      jr      $cb83            ; (+$22)

;;-------------------------------------------------------------------
;; code 0x0fe
;;
;; display letter of current drive
;;
;; C = current drive 

cb61 79        ld      a,c
cb62 c641      add     a,$41
cb64 181d      jr      $cb83            ; print character

;;-------------------------------------------------------------------
;; +ve code (0-&7f)

cb66 f5        push    af
cb67 fe20      cp      $20				; space?
cb69 2017      jr      nz,$cb82         

;; ' ' (space)
cb6b e5        push    hl
cb6c d5        push    de
cb6d cd69bb    call    $bb69			; firmware function: txt get window
cb70 cd78bb    call    $bb78			; firmware function: txt get cursor
cb73 7a        ld      a,d
cb74 d604      sub     $04
cb76 3f        ccf     
cb77 3001      jr      nc,$cb7a         ; (+$01)
cb79 bc        cp      h
cb7a d1        pop     de
cb7b e1        pop     hl
cb7c 3004      jr      nc,$cb82         ; (+$04)

cb7e f1        pop     af
cb7f c3e9ca    jp      $cae9			; display CR, LF

cb82 f1        pop     af
cb83 c35abb    jp      $bb5a			; firmware function: txt output




;; messages, terminated with &FF
cb86:
defb &0d,&0a,0x0ff		;; 0
defb "   ",0x0ff		;; 1
defb &fc,"K",0x0ff		;; 2
defb &97,&82," free",&97,0x0ff		;; 3	"K free"
defb &80,"Bad command",&80,0x0ff		;; 4 "Bad command"
defb &9b,"already exists",&80,0x0ff		;; 5 "<filename> already exists"
defb &9b,"not found",&80,0x0ff		;; 6 "<filename> not found"
defb &95,"directory ",&9a,0x0ff		;; 7 "Drive <drive>: directory full"
defb &98,&9a,0x0ff		;; 8 "disc full"
defb &98,"changed, closing ",&fd,&80,0x0ff		;; 9 "disc changed, closing <filename>"
defb &9b,"is ",&9d," only",&80,0x0ff		;; a "<filename> is read only"
defb &fd,0x0ff		;; b "<filename>"
defb &95,"user",&fc,&80,0x0ff		;; c "Drive <drive>: user <user>"
defb "...^C",0x0ff		;; d "..^C"
defb &96,"CP/M",&80,0x0ff		;; e "Failed to load CP/M"
defb &96,"boot sector",&80,0x0ff		;; f "Failed to load boot sector"
defb &95,&9d,&99,0x0ff		;; 10 "Drive <drive>: read fail"
defb &95,&9c,&99,0x0ff		;; 11 "Drive <drive>: write fail"
defb &98,"is ",&9c," protected",&80,0x0ff		;; 12 "Drive <drive>: is write protected"
defb &98,"missing",&80,0x0ff		;; 13 "Drive <drive>: disc missing"
defb &80,"Retry, Ignore or Cancel? ",0x0ff		;; 14 "Retry,Ignore or Cancel? "
defb &80,"Drive ",&fe,": ",0x0ff		;; 15 "Drive <drive>: "
defb &80,"Failed to load ",0x0ff		;; 16 "Failed to load "
defb &80,&80,0x0ff		;; 17
defb &95,"disc ",0x0ff		;; 18 "Drive <drive>: disc"
defb " fail",&80,0x0ff		;; 19 "fail"
defb "full",&80,0x0ff		;; 1a "full"
defb &80,&fd," ",0x0ff		;; 1b "<filename>"
defb "write",0x0ff		;; 1c "write"
defb "read",0x0ff		;; 1d "read"
defb &ff,0x0ff		;; 1e
defb &ff,0x0ff		;; 1f
defb &ff,0x0ff		;; 20

;;==============================================================================

cca0 af        xor     a
cca1 fd7700    ld      (iy+$00),a
cca4 fd7701    ld      (iy+$01),a
cca7 3d        dec     a
cca8 fd7708    ld      (iy+$08),a
ccab fd772c    ld      (iy+$2c),a
;; store base address of AMSDOS work ram
ccae fd227dbe  ld      ($be7d),iy

;; store firmware jumpblock for cassette operations:
;; cas in open, cas in direct, cas in close, cas in abandon
;; cas out open, cas out direct, cas out close, cas out abandon
;; cas in char, cas out char, cas catalog
ccb2 2177bc    ld      hl,$bc77			; firmware function: cas in open
ccb5 116401    ld      de,$0164
ccb8 cd98ca    call    $ca98			;; DE = IY+DE
ccbb 012700    ld      bc,$0027
ccbe edb0      ldir    

;; write FAR call address (to handle firmware CAS functions)
;; into AMSDOS work ram at offset &18b
;; the same far address is used for all CAS functions
ccc0 eb        ex      de,hl
ccc1 3630      ld      (hl),$30			; function to execute in AMSDOS rom ($cd30)
ccc3 23        inc     hl
ccc4 36cd      ld      (hl),$cd
ccc6 23        inc     hl
ccc7 cd12b9    call    $b912			; firmware function: kl curr selection
ccca 77        ld      (hl),a			; current selection


cccb 3ec9      ld      a,$c9
cccd 327fbe    ld      ($be7f),a

ccd0 af        xor     a

;; ===================================================================
;; |DISC 
ccd1 cde4cc    call    $cce4
ccd4 d0        ret     nc

;; ===================================================================
;; |DISC.IN

ccd5 2177bc    ld      hl,$bc77			; firmware function: cas in open
ccd8 0607      ld      b,$07
ccda cde9cc    call    $cce9
ccdd d0        ret     nc

ccde 219bbc    ld      hl,$bc9b			; firmware function: cas catalog
cce1 04        inc     b
cce2 1805      jr      $cce9            ; (+$05)

;; ===================================================================
;; |DISC.OUT

cce4 218cbc    ld      hl,$bc8c			; firmware function: cas out open
cce7 0605      ld      b,$05

cce9 b7        or      a				; test for zero parameters
ccea 203f      jr      nz,$cd2b         ; error


ccec 118b01    ld      de,$018b			; offset of FAR call to handle firmware CAS functions
										; in AMSDOS work ram
ccef cd98ca    call    $ca98			; DE = IY+DE

ccf2 36df      ld      (hl),$df			; firmware function: FAR CALL
ccf4 23        inc     hl
ccf5 73        ld      (hl),e			; low byte of address of far address
ccf6 23        inc     hl
ccf7 72        ld      (hl),d			; high byte of address of far address
ccf8 23        inc     hl
ccf9 10f7      djnz    $ccf2            ; (-$09)
ccfb 37        scf     
ccfc c9        ret     

;; ==========================================================================
;; |TAPE

ccfd cd18cd    call    $cd18
cd00 d0        ret     nc

;; ==========================================================================
;; |TAPE.IN

cd01 216401    ld      hl,$0164
cd04 1177bc    ld      de,$bc77			; firmware function: cas in open
cd07 011500    ld      bc,$0015
cd0a cd21cd    call    $cd21
cd0d d0        ret     nc

cd0e 218801    ld      hl,$0188
cd11 119bbc    ld      de,$bc9b			; firmware function: cas catalog
cd14 0e03      ld      c,$03
cd16 1809      jr      $cd21            ; (+$09)

;; ==========================================================================
;; |TAPE.OUT

cd18 217901    ld      hl,$0179
cd1b 118cbc    ld      de,$bc8c			; firmware function: cas out open
cd1e 010f00    ld      bc,$000f
cd21 b7        or      a
cd22 2007      jr      nz,$cd2b         ; (+$07)
cd24 cd9fca    call    $ca9f			; HL = HL + IY
cd27 edb0      ldir    
cd29 37        scf     
cd2a c9        ret     

;----------------------------------------------------------------------------

cd2b 3e04      ld      a,$04			; "Bad command"
cd2d c3ebca    jp      $caeb			; display message



;; ==========================================================================

;; firmware will execute here
;; for all CAS functions
;; 
;; 
cd30 fd2a7dbe  ld      iy,($be7d)				;; base of AMSDOS work ram

cd34 f3        di								;; disable interrupts   
cd35 08        ex      af,af'
cd36 d9        exx     
cd37 79        ld      a,c
cd38 d1        pop     de
cd39 c1        pop     bc
cd3a e1        pop     hl
cd3b e3        ex      (sp),hl
cd3c c5        push    bc
cd3d d5        push    de
cd3e 4f        ld      c,a
cd3f 067f      ld      b,$7f
;; HL = return address
cd41 11d210    ld      de,$10d2					; convert to address in ROM
												; HL = HL + $10d2
												; e.g. $bc77+$10d2 = $cd4c!

cd44 19        add     hl,de
cd45 e5        push    hl
cd46 d9        exx     
cd47 08        ex      af,af'
cd48 fb        ei      
cd49 c37fbe    jp      $be7f					;; RET instruction

cd4c c3afce    jp      $ceaf					;; CAS IN OPEN
cd4f c3b6d1    jp      $d1b6					;; CAS IN CLOSE
cd52 c3bcd1    jp      $d1bc					;; CAS IN ABANDON
cd55 c364cf    jp      $cf64					;; CAS IN CHAR
cd58 c3f5cf    jp      $cff5					;; CAS IN DIRECT
cd5b c369d0    jp      $d069					;; CAS RETURN
cd5e c365d0    jp      $d065					;; CAS TEST EOF
cd61 c337cf    jp      $cf37					;; CAS OUT OPEN
cd64 c3d8d1    jp      $d1d8					;; CAS OUT CLOSE
cd67 c3c2d1    jp      $d1c2					;; CAS OUT ABANDON
cd6a c38fd0    jp      $d08f					;; CAS OUT CHAR
cd6d c3d8d0    jp      $d0d8					;; CAS OUT DIRECT
cd70 c313d5    jp      $d513					;; CAS CATALOG

;;==========================================================================
;; calculate return address (in case of an error)

cd73 cd77cd    call    $cd77
cd76 c9        ret     

;;==========================================================================
;; calculate return address (in case of an error)

cd77 e5        push    hl
cd78 210600    ld      hl,$0006
cd7b 39        add     hl,sp
cd7c fd7506    ld      (iy+$06),l
cd7f fd7407    ld      (iy+$07),h
cd82 e1        pop     hl
cd83 c9        ret     

;;==========================================================================

cd84 cd77cd    call    $cd77
cd87 f5        push    af
cd88 fd7e08    ld      a,(iy+$08)
cd8b 1807      jr      $cd94            ; (+$07)

;;==========================================================================

cd8d cd77cd    call    $cd77
cd90 f5        push    af
cd91 fd7e2c    ld      a,(iy+$2c)
cd94 feff      cp      $ff
cd96 2812      jr      z,$cdaa          ; (+$12)
cd98 cd16ce    call    $ce16			; setup XDPB for drive
cd9b f1        pop     af
cd9c c9        ret     

;;==========================================================================

cd9d fd7e08    ld      a,(iy+$08)
cda0 1803      jr      $cda5            ; (+$03)

cda2 fd7e2c    ld      a,(iy+$2c)
cda5 cd77cd    call    $cd77
cda8 3c        inc     a
cda9 c8        ret     z

cdaa 3e0e      ld      a,$0e
cdac b7        or      a
cdad 180a      jr      $cdb9			; quit            

;; =========================================================================

cdaf 3e04      ld      a,$04			; "Bad command"

;;--------------------------------------------------------------------------

cdb1 cdcadb    call    $dbca
cdb4 c60c      add     a,$0c
cdb6 f680      or      $80
cdb8 bf        cp      a

;;--------------------------------------------------------------------------
;; get stored return address
cdb9 fd6e06    ld      l,(iy+$06)
cdbc fd6607    ld      h,(iy+$07)

cdbf f9        ld      sp,hl
cdc0 c9        ret     

;; =========================================================================
;; test for two parameters
;; A = number of parameters

cdc1 3d        dec     a

;;--------------------------------------------------------------------------
;; test for a single parameter
;; A = number of parameters

cdc2 3d        dec     a
cdc3 c8        ret     z

;; .. too many parameters
cdc4 c3afcd    jp      $cdaf				; display "Bad command" and quit command

;; =========================================================================
;; get string parameter

;; get address of string descriptor block
cdc7 cdcfcd    call    $cdcf				; get 16-bit integer parameter
;; get length of string
cdca 46        ld      b,(hl)
cdcb 23        inc     hl
;; fetch address of string into HL
cdcc c3f9db    jp      $dbf9

;; =========================================================================
;; get parameter 
;;
;; for a string this will be the address of the string descriptor block
;; for a integer, this will be the value of the integer
;; for a real, this will be the address of the 5-byte real value

cdcf dd6e00    ld      l,(ix+$00)		
cdd2 dd6601    ld      h,(ix+$01)
cdd5 dd23      inc     ix
cdd7 dd23      inc     ix
cdd9 c9        ret     

;; =========================================================================
;; |A
cdda af        xor     a				;; drive 0 index
cddb 1802      jr      $cddf

;; =========================================================================
;; |B

cddd 3e01      ld      a,$01			;; drive 1 index
;;--------------------------------------------------------------------------
cddf cd73cd    call    $cd73			;; calculate return address (in case of an error)
cde2 1813      jr      $cdf7			;; setup XDPB for drive and store drive number in AMSDOS work RAM           

;; ==========================================================================
;; |DRIVE

cde4 cd73cd    call    $cd73			; calculate return address (in case of an error)
cde7 cdc2cd    call    $cdc2			; test for a single parameter
cdea cdc7cd    call    $cdc7			; get string parameter
cded 05        dec     b
cdee c2afcd    jp      nz,$cdaf			; display "Bad command" and quit command

;; HL = start of string parameter
cdf1 7e        ld      a,(hl)			; get first character of string
cdf2 cda6ca    call    $caa6			; convert character to upper case
cdf5 d641      sub     $41				; convert character into drive ID ('A'->0, 'B'->1)

;;--------------------------------------------------------------------------
;; A = drive number

cdf7 cd16ce    call    $ce16			; setup XDPB for drive
;; store drive number in AMSDOS work RAM
cdfa fd7700    ld      (iy+$00),a
cdfd c9        ret     

;; ========================================================================
;; |USER

cdfe cd73cd    call    $cd73				; calculate return address (in case of an error)
ce01 cdc2cd    call    $cdc2				; test for a single parameter
ce04 cdcfcd    call    $cdcf				; get 16-bit integer parameter
;; HL = user number
;; check user number is in the range 0-15
ce07 111000    ld      de,$0010
ce0a cdf3db    call    $dbf3				; HL = HL - DE
ce0d d2afcd    jp      nc,$cdaf				; display "Bad command" and quit command
;; L = user number
;; store user number in AMSDOS work RAM
ce10 fd7501    ld      (iy+$01),l
ce13 c9        ret     

;;------------------------------------------------------------------------------

ce14 0a        ld      a,(bc)
ce15 03        inc     bc

;;------------------------------------------------------------------------------
;; setup XDPB for drive

;; A = drive number
ce16 e5        push    hl
ce17 d5        push    de
ce18 c5        push    bc
ce19 f5        push    af
ce1a 4f        ld      c,a
ce1b 1eff      ld      e,$ff
ce1d fd7e08    ld      a,(iy+$08)
ce20 b9        cp      c
ce21 2808      jr      z,$ce2b          ; (+$08)
ce23 fd7e2c    ld      a,(iy+$2c)
ce26 b9        cp      c
ce27 2802      jr      z,$ce2b          ; (+$02)

ce29 1e00      ld      e,$00


ce2b d5        push    de
ce2c c5        push    bc
ce2d cdf0c4    call    $c4f0			;; setup XDPB, and get address of drive's XDPB

ce30 c1        pop     bc
ce31 d1        pop     de

ce32 7c        ld      a,h				; offset is 0?
ce33 b5        or      l
ce34 caafcd    jp      z,$cdaf			; display "Bad command" and quit command

;; store address of drive's XDPB
ce37 fd7503    ld      (iy+$03),l
ce3a fd7404    ld      (iy+$04),h

ce3d fd7305    ld      (iy+$05),e
;; store drive
ce40 fd7102    ld      (iy+$02),c
ce43 f1        pop     af
ce44 c1        pop     bc
ce45 d1        pop     de
ce46 e1        pop     hl
ce47 c9        ret     

;;==================================================================================

ce48 215000    ld      hl,$0050
ce4b cd5ace    call    $ce5a
ce4e e5        push    hl
ce4f 114200    ld      de,$0042
ce52 19        add     hl,de
ce53 3680      ld      (hl),$80
ce55 e1        pop     hl
ce56 c9        ret     

ce57 219a00    ld      hl,$009a
ce5a c5        push    bc
ce5b d5        push    de
ce5c cd9fca    call    $ca9f				;; HL = HL + IY
ce5f 3600      ld      (hl),$00
ce61 23        inc     hl
ce62 73        ld      (hl),e
ce63 23        inc     hl
ce64 72        ld      (hl),d
ce65 23        inc     hl
ce66 73        ld      (hl),e
ce67 23        inc     hl
ce68 72        ld      (hl),d
ce69 23        inc     hl
ce6a e5        push    hl
ce6b c5        push    bc
ce6c 014500    ld      bc,$0045
ce6f eb        ex      de,hl
ce70 cdafca    call    $caaf				; clear memory
ce73 c1        pop     bc
ce74 60        ld      h,b
ce75 69        ld      l,c
ce76 d1        pop     de
ce77 d5        push    de
ce78 010c00    ld      bc,$000c
ce7b edb0      ldir    
ce7d e1        pop     hl
ce7e d1        pop     de
ce7f e5        push    hl
ce80 011200    ld      bc,$0012
ce83 09        add     hl,bc
ce84 3616      ld      (hl),$16
ce86 23        inc     hl
ce87 23        inc     hl
ce88 23        inc     hl
ce89 73        ld      (hl),e
ce8a 23        inc     hl
ce8b 72        ld      (hl),d
ce8c 23        inc     hl
ce8d 36ff      ld      (hl),$ff
ce8f e1        pop     hl
ce90 c1        pop     bc
ce91 c9        ret     

;;=================================================================================
;; generate AMSDOS file header checksum
;;
;; entry:
;; HL = address of header
;; exit:
;; DE = generated checksum
;; HL = address of header + 67

;; put initial address onto stack
ce92 e5        push    hl

ce93 210000    ld      hl,$0000			; initialise checksum
ce96 54        ld      d,h
ce97 0643      ld      b,$43			; number of bytes

;; get address from stack
ce99 e3        ex      (sp),hl			
;; HL = address
ce9a 7e        ld      a,(hl)			; get byte
ce9b 23        inc     hl				; increment pointer
;; store address back to stack
ce9c e3        ex      (sp),hl
;; update checksum with data byte
;; A = data byte
ce9d 5f        ld      e,a
;; DE = 16-bit version of data byte
ce9e 19        add     hl,de			; update checksum
ce9f 10f8      djnz    $ce99            ; (-$08)
;; HL = checksum
cea1 eb        ex      de,hl
;; DE = checksum
cea2 e1        pop     hl
cea3 c9        ret     

;;=================================================================================
;; generate and store checksum
;;
;; HL = address of file header

cea4 e5        push    hl
cea5 cd92ce    call    $ce92			; generate checksum
cea8 73        ld      (hl),e			; store checksum
cea9 23        inc     hl
ceaa 72        ld      (hl),d
ceab e1        pop     hl
ceac c3f9d3    jp      $d3f9


;;========================================================================
;; CAS IN OPEN
;;
;; B = filename length in characters
;; HL = address of filename
;; DE = address of 2K buffer

ceaf cd9dcd    call    $cd9d
ceb2 d5        push    de
ceb3 cd6fda    call    $da6f
ceb6 cd14ce    call    $ce14

;; HL = pointer to start of filename
ceb9 210900    ld      hl,$0009
cebc 09        add     hl,bc
cebd 7e        ld      a,(hl)			; get first byte of file extension
										; - if A=0, then no extension is defined.
										; - if A!=0, then A is the first ASCII
										; character of the extension
cebe 3c        inc     a				
cebf 2808      jr      z,$cec9

;;----------------------------------------------------------------------
;; extension has been specified..

cec1 cd51d6    call    $d651
cec4 d20cd5    jp      nc,$d50c			; display "<filename> not found"
cec7 181e      jr      $cee7            ; 

;;----------------------------------------------------------------------
;; extension not specified
;;
;; try the default extensions

cec9 cda8d2    call    $d2a8			; replace extension with '   '
cecc cd51d6    call    $d651
cecf 3816      jr      c,$cee7          

ced1 cdb3d2    call    $d2b3			; replace extension with 'BAS'
ced4 cd51d6    call    $d651
ced7 380e      jr      c,$cee7          ; (+$0e)

ced9 cdb7d2    call    $d2b7			; replace extension with 'BIN'
cedc cd51d6    call    $d651

cedf f5        push    af
cee0 d4a8d2    call    nc,$d2a8			; replace extension with '   '
cee3 f1        pop     af
cee4 d20cd5    jp      nc,$d50c			; display "<filename> not found"

;;----------------------------------------------------------------------
cee7 d1        pop     de
cee8 cd48ce    call    $ce48
ceeb e5        push    hl
ceec 110800    ld      de,$0008
ceef cd98ca    call    $ca98			;; DE = IY+DE
cef2 0b        dec     bc
cef3 0a        ld      a,(bc)
cef4 12        ld      (de),a

cef5 cd9cd7    call    $d79c

cef8 21e400    ld      hl,$00e4
cefb cd9fca    call    $ca9f			;; HL = HL + IY

cefe cd92d3    call    $d392
cf01 301f      jr      nc,$cf22         ; (+$1f)

cf03 e5        push    hl
cf04 d5        push    de
cf05 cd92ce    call    $ce92			; generate file header checksum
cf08 cdf9db    call    $dbf9			; LD HL,(HL)
cf0b cdf3db    call    $dbf3			; HL = HL - DE
cf0e d1        pop     de
cf0f e1        pop     hl
cf10 200d      jr      nz,$cf1f         ; (+$0d)

;;------------------------------------------------------------------
;; file has a header

cf12 115500    ld      de,$0055
cf15 cd98ca    call    $ca98			;; DE = IY+DE
cf18 014500    ld      bc,$0045
cf1b edb0      ldir    
cf1d 1803      jr      $cf22            ; (+$03)

;;------------------------------------------------------------------
;; file doesn't have a header

cf1f cd9cd7    call    $d79c

;;------------------------------------------------------------------
cf22 e1        pop     hl
									;; HL = address of in-memory header
cf23 e5        push    hl
cf24 111500    ld      de,$0015
cf27 19        add     hl,de
cf28 5e        ld      e,(hl)		
cf29 23        inc     hl
cf2a 56        ld      d,(hl)		;; DE = data location (from header)
cf2b 23        inc     hl
cf2c 23        inc     hl
cf2d 4e        ld      c,(hl)
cf2e 23        inc     hl
cf2f 46        ld      b,(hl)		;; BC = logical file length (from header)
cf30 e1        pop     hl			;; HL = address of buffer containing header
cf31 37        scf					;; carry true
cf32 9f        sbc     a,a			;; zero false
cf33 fd7e67    ld      a,(iy+$67)	;; A = file type (from header)
cf36 c9        ret     


;;=======================================================================
;; CAS OUT OPEN
;;
;; HL = address of filename
;; B = length of filename
;; DE = address of 2K buffer

cf37 cda2cd    call    $cda2
cf3a d5        push    de
cf3b cd6ada    call    $da6a
cf3e cd14ce    call    $ce14
cf41 d1        pop     de
cf42 cd57ce    call    $ce57
cf45 e5        push    hl
cf46 cdabd2    call    $d2ab			; replace extension with '$$$'
cf49 cd76d6    call    $d676
cf4c 60        ld      h,b
cf4d 69        ld      l,c
cf4e 2b        dec     hl
cf4f 112c00    ld      de,$002c
cf52 cd98ca    call    $ca98			;; DE = IY+DE
cf55 010d00    ld      bc,$000d
cf58 edb0      ldir    
cf5a 011700    ld      bc,$0017
cf5d cdafca    call    $caaf			;; clear memory
cf60 e1        pop     hl
cf61 37        scf     
cf62 9f        sbc     a,a
cf63 c9        ret     


;;=======================================================================
;; CAS IN CHAR
;;
;; A = character read

cf64 e5        push    hl
cf65 d5        push    de
cf66 c5        push    bc
cf67 cd74cf    call    $cf74
cf6a c1        pop     bc
cf6b d1        pop     de
cf6c e1        pop     hl
cf6d d0        ret     nc

cf6e fe1a      cp      $1a				;; soft end of file?
cf70 37        scf     
cf71 c0        ret     nz

cf72 b7        or      a
cf73 c9        ret     

;;-----------------------------------------------------------------------

cf74 cd84cd    call    $cd84
cf77 fde5      push    iy
cf79 d1        pop     de

cf7a 215000    ld      hl,$0050
cf7d 19        add     hl,de
cf7e 7e        ld      a,(hl)			; get read mode
cf7f fe02      cp      $02				; reading in direct mode?
cf81 caaacd    jp      z,$cdaa
cf84 3601      ld      (hl),$01			; read in character mode

cf86 219500    ld      hl,$0095
cf89 19        add     hl,de
cf8a 7e        ld      a,(hl)
cf8b 23        inc     hl
cf8c b6        or      (hl)
cf8d 23        inc     hl
cf8e b6        or      (hl)
cf8f 2836      jr      z,$cfc7          ; hard end of file

cf91 216800    ld      hl,$0068
cf94 19        add     hl,de
cf95 7e        ld      a,(hl)
cf96 23        inc     hl
cf97 b6        or      (hl)
cf98 2b        dec     hl
cf99 cccbcf    call    z,$cfcb

cf9c 7e        ld      a,(hl)
cf9d 23        inc     hl
cf9e b6        or      (hl)
cf9f 2826      jr      z,$cfc7          ; hard end of file

cfa1 46        ld      b,(hl)
cfa2 2b        dec     hl
cfa3 4e        ld      c,(hl)
cfa4 0b        dec     bc
cfa5 71        ld      (hl),c
cfa6 23        inc     hl
cfa7 70        ld      (hl),b
cfa8 219500    ld      hl,$0095
cfab 19        add     hl,de
cfac 0603      ld      b,$03
cfae 7e        ld      a,(hl)
cfaf d601      sub     $01
cfb1 77        ld      (hl),a
cfb2 3003      jr      nc,$cfb7         ; (+$03)
cfb4 23        inc     hl
cfb5 10f7      djnz    $cfae            ; (-$09)
cfb7 215300    ld      hl,$0053
cfba 19        add     hl,de
cfbb 5e        ld      e,(hl)
cfbc 23        inc     hl
cfbd 56        ld      d,(hl)
cfbe eb        ex      de,hl
cfbf e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
cfc0 eb        ex      de,hl
cfc1 13        inc     de
cfc2 72        ld      (hl),d
cfc3 2b        dec     hl
cfc4 73        ld      (hl),e
cfc5 37        scf     
cfc6 c9        ret     
;;-----------------------------------------------------------------------------
cfc7 3e0f      ld      a,$0f			; hard end of file
cfc9 b7        or      a
cfca c9        ret     
;;-----------------------------------------------------------------------------

cfcb e5        push    hl
cfcc d5        push    de
cfcd e5        push    hl
cfce 215100    ld      hl,$0051
cfd1 19        add     hl,de
cfd2 cdf9db    call    $dbf9			; LD HL,(HL)
cfd5 e5        push    hl
cfd6 011000    ld      bc,$0010
cfd9 cd49d0    call    $d049
cfdc 3e10      ld      a,$10
cfde 91        sub     c
cfdf 47        ld      b,a
cfe0 0e00      ld      c,$00
cfe2 cb38      srl     b
cfe4 cb19      rr      c
cfe6 d1        pop     de
cfe7 e1        pop     hl
cfe8 71        ld      (hl),c
cfe9 23        inc     hl
cfea 70        ld      (hl),b
cfeb 01eaff    ld      bc,$ffea
cfee 09        add     hl,bc
cfef 73        ld      (hl),e
cff0 23        inc     hl
cff1 72        ld      (hl),d
cff2 d1        pop     de
cff3 e1        pop     hl
cff4 c9        ret     

;;=======================================================================
;; CAS IN DIRECT
;; 
;; HL = load address

cff5 cd84cd    call    $cd84
cff8 e5        push    hl
cff9 215000    ld      hl,$0050
cffc cd9fca    call    $ca9f				;; HL = HL + IY
cfff 7e        ld      a,(hl)
d000 fe01      cp      $01					;; reading in character mode?
d002 caaacd    jp      z,$cdaa
d005 3602      ld      (hl),$02				;; read in direct mode

d007 114500    ld      de,$0045
d00a 19        add     hl,de
d00b 5e        ld      e,(hl)
d00c 23        inc     hl
d00d 56        ld      d,(hl)
d00e e1        pop     hl
d00f d5        push    de
d010 e5        push    hl
d011 eb        ex      de,hl
d012 3e07      ld      a,$07
d014 cdebdb    call    $dbeb			;; HL shift right by A
d017 44        ld      b,h
d018 4d        ld      c,l
d019 e1        pop     hl
d01a cd49d0    call    $d049
d01d d1        pop     de
d01e 301e      jr      nc,$d03e         ; (+$1e)
d020 7b        ld      a,e
d021 e67f      and     $7f
d023 2819      jr      z,$d03e          ; (+$19)
d025 f5        push    af
d026 e5        push    hl
d027 21e400    ld      hl,$00e4
d02a cd9fca    call    $ca9f
d02d e5        push    hl
d02e 010100    ld      bc,$0001
d031 cd49d0    call    $d049
d034 e1        pop     hl
d035 d1        pop     de
d036 c1        pop     bc
d037 3005      jr      nc,$d03e         ; (+$05)
d039 48        ld      c,b
d03a 0600      ld      b,$00
d03c edb0      ldir    
d03e 216f00    ld      hl,$006f
d041 cd9fca    call    $ca9f
d044 37        scf     
d045 9f        sbc     a,a
d046 c3f9db    jp      $dbf9			; LD HL,(HL)
d049 1814      jr      $d05f            ; (+$14)
d04b cd92d3    call    $d392
d04e d0        ret     nc

d04f 116700    ld      de,$0067
d052 cd98ca    call    $ca98			;; DE = IY+DE
d055 1a        ld      a,(de)
d056 1f        rra     
d057 dc52d2    call    c,$d252
d05a 118000    ld      de,$0080
d05d 19        add     hl,de
d05e 0b        dec     bc
d05f 78        ld      a,b
d060 b1        or      c
d061 20e8      jr      nz,$d04b         ; (-$18)
d063 37        scf     
d064 c9        ret     

;;=======================================================================
;; CAS TEST EOF

d065 cd64cf    call    $cf64
d068 d0        ret     nc

;;=======================================================================
;; CAS RETURN

d069 e5        push    hl
d06a d5        push    de
d06b f5        push    af
d06c 215300    ld      hl,$0053
d06f cd9fca    call    $ca9f
d072 5e        ld      e,(hl)
d073 23        inc     hl
d074 56        ld      d,(hl)
d075 1b        dec     de
d076 72        ld      (hl),d
d077 2b        dec     hl
d078 73        ld      (hl),e
d079 54        ld      d,h
d07a 5d        ld      e,l
d07b 214200    ld      hl,$0042
d07e 19        add     hl,de
d07f cdabd7    call    $d7ab
d082 211500    ld      hl,$0015
d085 19        add     hl,de
d086 34        inc     (hl)
d087 2002      jr      nz,$d08b         ; (+$02)
d089 23        inc     hl
d08a 34        inc     (hl)
d08b f1        pop     af
d08c d1        pop     de
d08d e1        pop     hl
d08e c9        ret     

;;=======================================================================
;; CAS OUT CHAR
;;
;; A = character

d08f cd8dcd    call    $cd8d
d092 e5        push    hl
d093 d5        push    de
d094 c5        push    bc
d095 f5        push    af
d096 fde5      push    iy
d098 d1        pop     de
d099 219a00    ld      hl,$009a
d09c 19        add     hl,de
d09d 7e        ld      a,(hl)
d09e fe02      cp      $02
d0a0 caaacd    jp      z,$cdaa
d0a3 3601      ld      (hl),$01
d0a5 21b200    ld      hl,$00b2
d0a8 19        add     hl,de
d0a9 e5        push    hl
d0aa cdf9db    call    $dbf9			; LD HL,(HL)
d0ad 0100f8    ld      bc,$f800
d0b0 09        add     hl,bc
d0b1 d5        push    de
d0b2 dc18d1    call    c,$d118
d0b5 d1        pop     de
d0b6 e1        pop     hl
d0b7 34        inc     (hl)
d0b8 23        inc     hl
d0b9 2001      jr      nz,$d0bc         ; (+$01)
d0bb 34        inc     (hl)
d0bc 21df00    ld      hl,$00df
d0bf 19        add     hl,de
d0c0 cdabd7    call    $d7ab
d0c3 219d00    ld      hl,$009d
d0c6 19        add     hl,de
d0c7 f1        pop     af
d0c8 4e        ld      c,(hl)
d0c9 23        inc     hl
d0ca 46        ld      b,(hl)
d0cb 2b        dec     hl
d0cc 02        ld      (bc),a
d0cd 34        inc     (hl)
d0ce 2002      jr      nz,$d0d2         ; (+$02)
d0d0 23        inc     hl
d0d1 34        inc     (hl)
d0d2 c1        pop     bc
d0d3 d1        pop     de
d0d4 e1        pop     hl
d0d5 37        scf     
d0d6 9f        sbc     a,a
d0d7 c9        ret     

;;=======================================================================
;; CAS OUT DIRECT
;; 
;; HL = load address
;; DE = length
;; BC = execution address
;; A = type

d0d8 cd8dcd    call    $cd8d
d0db f5        push    af
d0dc e5        push    hl
d0dd d5        push    de
d0de 219a00    ld      hl,$009a
d0e1 cd9fca    call    $ca9f
d0e4 7e        ld      a,(hl)
d0e5 fe01      cp      $01
d0e7 caaacd    jp      z,$cdaa
d0ea 3602      ld      (hl),$02
d0ec 112000    ld      de,$0020
d0ef 19        add     hl,de
d0f0 70        ld      (hl),b
d0f1 2b        dec     hl
d0f2 71        ld      (hl),c
d0f3 c1        pop     bc
d0f4 2b        dec     hl
d0f5 70        ld      (hl),b
d0f6 2b        dec     hl
d0f7 71        ld      (hl),c
d0f8 112900    ld      de,$0029
d0fb 19        add     hl,de
d0fc 70        ld      (hl),b
d0fd 2b        dec     hl
d0fe 71        ld      (hl),c
d0ff 11d3ff    ld      de,$ffd3
d102 19        add     hl,de
d103 71        ld      (hl),c
d104 23        inc     hl
d105 70        ld      (hl),b
d106 c1        pop     bc
d107 23        inc     hl
d108 71        ld      (hl),c
d109 23        inc     hl
d10a 70        ld      (hl),b
d10b 11e6ff    ld      de,$ffe6
d10e 19        add     hl,de
d10f 71        ld      (hl),c
d110 23        inc     hl
d111 70        ld      (hl),b
d112 f1        pop     af
d113 111500    ld      de,$0015
d116 19        add     hl,de
d117 77        ld      (hl),a
d118 fde5      push    iy
d11a d1        pop     de
d11b 21b600    ld      hl,$00b6
d11e 19        add     hl,de
d11f 7e        ld      a,(hl)
d120 b7        or      a
d121 2818      jr      z,$d13b          ; (+$18)
d123 21b100    ld      hl,$00b1
d126 19        add     hl,de
d127 7e        ld      a,(hl)
d128 e60f      and     $0f
d12a fe06      cp      $06
d12c 280d      jr      z,$d13b          ; (+$0d)
d12e 212c00    ld      hl,$002c
d131 19        add     hl,de
d132 d5        push    de
d133 eb        ex      de,hl
d134 cda7d7    call    $d7a7
d137 cd7dd7    call    $d77d
d13a d1        pop     de
d13b 21b200    ld      hl,$00b2
d13e 19        add     hl,de
d13f e5        push    hl
d140 5e        ld      e,(hl)
d141 23        inc     hl
d142 56        ld      d,(hl)
d143 01e8ff    ld      bc,$ffe8
d146 09        add     hl,bc
d147 cdf9db    call    $dbf9			; LD HL,(HL)
d14a e5        push    hl
d14b cd64d1    call    $d164
d14e c1        pop     bc
d14f e1        pop     hl
d150 3600      ld      (hl),$00
d152 23        inc     hl
d153 3600      ld      (hl),$00
d155 23        inc     hl
d156 23        inc     hl
d157 23        inc     hl
d158 3600      ld      (hl),$00
d15a 11e7ff    ld      de,$ffe7
d15d 19        add     hl,de
d15e 71        ld      (hl),c
d15f 23        inc     hl
d160 70        ld      (hl),b
d161 37        scf     
d162 9f        sbc     a,a
d163 c9        ret     

d164 d5        push    de
d165 3e07      ld      a,$07
d167 eb        ex      de,hl
d168 cdebdb    call    $dbeb			;; HL shift right by A
d16b eb        ex      de,hl
d16c 42        ld      b,d
d16d 4b        ld      c,e
d16e cd88d1    call    $d188
d171 c1        pop     bc
d172 79        ld      a,c
d173 e67f      and     $7f
d175 c8        ret     z

d176 4f        ld      c,a
d177 0600      ld      b,$00
d179 11e400    ld      de,$00e4
d17c cd98ca    call    $ca98			;; DE = IY+DE
d17f d5        push    de
d180 cd1bb9    call    $b91b			;; firmware function: KL LDIR
d183 3e1a      ld      a,$1a
d185 12        ld      (de),a
d186 e1        pop     hl
d187 03        inc     bc
d188 1827      jr      $d1b1            ; (+$27)
d18a e5        push    hl
d18b 11b100    ld      de,$00b1
d18e cd98ca    call    $ca98			;; DE = IY+DE
d191 1a        ld      a,(de)
d192 1f        rra     
d193 3013      jr      nc,$d1a8         ; (+$13)
d195 c5        push    bc
d196 11e400    ld      de,$00e4
d199 cd98ca    call    $ca98			;; DE = IY+DE
d19c d5        push    de
d19d 018000    ld      bc,$0080
d1a0 cd1bb9    call    $b91b			;; firmware function: KL LDIR
d1a3 e1        pop     hl
d1a4 c1        pop     bc
d1a5 cd52d2    call    $d252
d1a8 cdafd3    call    $d3af
d1ab e1        pop     hl
d1ac 118000    ld      de,$0080
d1af 19        add     hl,de
d1b0 0b        dec     bc
d1b1 78        ld      a,b
d1b2 b1        or      c
d1b3 20d5      jr      nz,$d18a         ; (-$2b)
d1b5 c9        ret     

;;=======================================================================
;; CAS IN CLOSE

d1b6 cd84cd    call    $cd84
d1b9 cde5c9    call    $c9e5

;;-----------------------------------------------------------------------
;; CAS IN ABANDON

d1bc fd3608ff  ld      (iy+$08),$ff
d1c0 186e      jr      $d230            ; (+$6e)

;;=======================================================================
;; CAS OUT ABANDON

d1c2 cd8dcd    call    $cd8d
d1c5 112d00    ld      de,$002d
d1c8 cd98ca    call    $ca98			;; DE = IY+DE
d1cb af        xor     a
d1cc cd3cd8    call    $d83c
d1cf 1b        dec     de
d1d0 3eff      ld      a,$ff
d1d2 12        ld      (de),a
d1d3 cd1fc5    call    $c51f
d1d6 1858      jr      $d230            ; (+$58)

;;=======================================================================
;; CAS OUT CLOSE

d1d8 21df00    ld      hl,$00df
d1db cd9fca    call    $ca9f
d1de 7e        ld      a,(hl)
d1df 23        inc     hl
d1e0 b6        or      (hl)
d1e1 23        inc     hl
d1e2 b6        or      (hl)
d1e3 28dd      jr      z,$d1c2          ; (-$23)
d1e5 cd8dcd    call    $cd8d
d1e8 cd18d1    call    $d118
d1eb 112c00    ld      de,$002c
d1ee cd98ca    call    $ca98			;; DE = IY+DE
d1f1 d5        push    de
d1f2 cd8cd7    call    $d78c
d1f5 019f00    ld      bc,$009f
d1f8 cd90ca    call    $ca90			;; BC = IY+BC
d1fb 211200    ld      hl,$0012
d1fe 09        add     hl,bc
d1ff 5e        ld      e,(hl)
d200 210900    ld      hl,$0009
d203 09        add     hl,bc
d204 7e        ld      a,(hl)
d205 3c        inc     a
d206 2016      jr      nz,$d21e         ; (+$16)
d208 7b        ld      a,e
d209 e60e      and     $0e
d20b 2005      jr      nz,$d212         ; (+$05)
d20d cdb3d2    call    $d2b3			; replace extension with 'BAS'
d210 180c      jr      $d21e            ; (+$0c)
d212 fe02      cp      $02
d214 2005      jr      nz,$d21b         ; (+$05)
d216 cdb7d2    call    $d2b7			; replace extension with 'BIN'
d219 1803      jr      $d21e            ; (+$03)
d21b cda8d2    call    $d2a8			; replace extension with '   '
d21e 60        ld      h,b
d21f 69        ld      l,c
d220 7b        ld      a,e
d221 e60f      and     $0f
d223 fe06      cp      $06
d225 c4a4ce    call    nz,$cea4			; generate and store checksum
d228 c1        pop     bc
d229 3eff      ld      a,$ff
d22b 02        ld      (bc),a
d22c 03        inc     bc
d22d cddad2    call    $d2da
d230 37        scf     
d231 9f        sbc     a,a
d232 c9        ret     

d233 fd6602    ld      h,(iy+$02)
d236 fd360500  ld      (iy+$05),$00
d23a 110800    ld      de,$0008
d23d cd43d2    call    $d243
d240 112c00    ld      de,$002c
d243 cd98ca    call    $ca98			;; DE = IY+DE
d246 1a        ld      a,(de)
d247 bc        cp      h
d248 c0        ret     nz

d249 3eff      ld      a,$ff
d24b 12        ld      (de),a
d24c 13        inc     de
d24d 3e09      ld      a,$09			; "disc changed, closing <filename>"
d24f c3cadb    jp      $dbca

d252 e5        push    hl
d253 c5        push    bc
d254 e5        push    hl
d255 110101    ld      de,$0101
d258 0681      ld      b,$81
d25a 180e      jr      $d26a            ; (+$0e)

d25c e3        ex      (sp),hl
d25d e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d25e e3        ex      (sp),hl
d25f ae        xor     (hl)
d260 ddae00    xor     (ix+$00)
d263 e3        ex      (sp),hl
d264 77        ld      (hl),a
d265 23        inc     hl
d266 e3        ex      (sp),hl
d267 dd23      inc     ix
d269 23        inc     hl
d26a 15        dec     d
d26b 2006      jr      nz,$d273         ; (+$06)
d26d 160b      ld      d,$0b
d26f dd2181d2  ld      ix,$d281
d273 1d        dec     e
d274 2005      jr      nz,$d27b         ; (+$05)
d276 1e0d      ld      e,$0d
d278 218cd2    ld      hl,$d28c
d27b 10df      djnz    $d25c            ; (-$21)
d27d e1        pop     hl
d27e d1        pop     de
d27f e1        pop     hl
d280 c9        ret     

d281 49        ld      c,c
d282 b1        or      c
d283 36f0      ld      (hl),$f0
d285 2e1e      ld      l,$1e
d287 062a      ld      b,$2a
d289 2819      jr      z,$d2a4          ; (+$19)
d28b eae29d    jp      pe,$9de2
d28e db1a      in      a,($1a)
d290 42        ld      b,d
d291 29        add     hl,hl
d292 39        add     hl,sp
d293 c6b3      add     a,$b3
d295 c690      add     a,$90
d297 45        ld      b,l
d298 8a        adc     a,d
;;================================================================
;; extensions list
d299:
defb "   "
defb "$$$"
defb "BAK"
defb "BAS"
defb "BIN"


;;================================================================
;; "   "
;; HL = address of filename
d2a8 af        xor     a
d2a9 180e      jr      $d2b9            ; (+$0e)
;;================================================================
;; "$$$"
;; HL = address of filename
d2ab 3e03      ld      a,$03
d2ad 180a      jr      $d2b9            ; (+$0a)
;;================================================================
;; "BAK"
;; HL = address of filename
d2af 3e06      ld      a,$06
d2b1 1806      jr      $d2b9            ; (+$06)
;;================================================================
;; "BAS"
;; HL = address of filename
d2b3 3e09      ld      a,$09
d2b5 1802      jr      $d2b9            ; (+$02)
;;================================================================
;; "BIN"
;; HL = address of filename
d2b7 3e0c      ld      a,$0c
;;----------------------------------------------------------------
;; A = offset into table
;; HL = address of filename
d2b9 d5        push    de

;; add base of table ($d299)
d2ba c699      add     a,$99
d2bc 5f        ld      e,a
d2bd ced2      adc     a,$d2
d2bf 93        sub     e
d2c0 57        ld      d,a
d2c1 1807      jr      $d2ca            ; (+$07)
;;================================================================

d2c3 d5        push    de
d2c4 11a800    ld      de,$00a8
d2c7 cd98ca    call    $ca98			;; DE = IY+DE

;;----------------------------------------------------------------
;; replace extension
;;
;; HL = address of filename (8.3 format)
;; DE = pointer to replacement extension
;;
;; AF corrupt
d2ca e5        push    hl
d2cb c5        push    bc

d2cc 210900    ld      hl,$0009			;; add offset to get pointer to extension
d2cf 09        add     hl,bc

d2d0 010300    ld      bc,$0003			;; length of extension
d2d3 eb        ex      de,hl
d2d4 edb0      ldir						;; copy bytes
d2d6 c1        pop     bc
d2d7 e1        pop     hl
d2d8 d1        pop     de
d2d9 c9        ret     

d2da 210c00    ld      hl,$000c
d2dd 09        add     hl,bc
d2de 36ff      ld      (hl),$ff
d2e0 23        inc     hl
d2e1 23        inc     hl
d2e2 36ff      ld      (hl),$ff
d2e4 cd83d6    call    $d683
d2e7 e5        push    hl
d2e8 210000    ld      hl,$0000
d2eb e3        ex      (sp),hl
d2ec cda2d6    call    $d6a2
d2ef e3        ex      (sp),hl
d2f0 3028      jr      nc,$d31a         ; (+$28)
d2f2 cdafd2    call    $d2af			; replace extension with 'BAK'
d2f5 cdd8d7    call    $d7d8
d2f8 3008      jr      nc,$d302         ; (+$08)
d2fa 2601      ld      h,$01
d2fc cdd9d9    call    $d9d9			; get read/write state of file
d2ff 3801      jr      c,$d302          ; (+$01)
d301 24        inc     h
d302 cdc3d2    call    $d2c3
d305 cdd8d7    call    $d7d8
d308 3008      jr      nc,$d312         ; (+$08)
d30a 2e01      ld      l,$01
d30c cdd9d9    call    $d9d9			; get read/write state of file
d30f 3801      jr      c,$d312          ; (+$01)
d311 2c        inc     l
d312 7c        ld      a,h
d313 b7        or      a
d314 28d5      jr      z,$d2eb          ; (-$2b)
d316 7d        ld      a,l
d317 b7        or      a
d318 28d1      jr      z,$d2eb          ; (-$2f)
d31a f1        pop     af
d31b 7d        ld      a,l
d31c b7        or      a
d31d 2843      jr      z,$d362          ; (+$43)
d31f 3d        dec     a
d320 2866      jr      z,$d388          ; (+$66)
d322 7c        ld      a,h
d323 b7        or      a
d324 283c      jr      z,$d362          ; (+$3c)
d326 3d        dec     a
d327 2845      jr      z,$d36e          ; (+$45)
d329 cd83d6    call    $d683
d32c cda2d6    call    $d6a2
d32f d0        ret     nc

d330 cd35d3    call    $d335
d333 18f7      jr      $d32c            ; (-$09)
d335 cdafd2    call    $d2af			; replace extension with 'BAK'
d338 cdd8d7    call    $d7d8
d33b daaad4    jp      c,$d4aa
d33e cd51d3    call    $d351
d341 d8        ret     c

d342 cdc3d2    call    $d2c3
d345 cdd8d7    call    $d7d8
d348 d0        ret     nc

d349 c5        push    bc
d34a 42        ld      b,d
d34b 4b        ld      c,e
d34c cdafd2    call    $d2af			; replace extension with 'BAK'
d34f 180d      jr      $d35e            
d351 cdabd2    call    $d2ab			; replace extension with '$$$'
d354 cdd8d7    call    $d7d8
d357 d0        ret     nc

d358 c5        push    bc
d359 42        ld      b,d
d35a 4b        ld      c,e
d35b cdc3d2    call    $d2c3
d35e c1        pop     bc
d35f c37ad9    jp      $d97a
d362 cd83d6    call    $d683
d365 cda2d6    call    $d6a2
d368 d0        ret     nc

d369 cd3ed3    call    $d33e
d36c 18f7      jr      $d365            ; (-$09)
d36e cd83d6    call    $d683
d371 cda2d6    call    $d6a2
d374 d0        ret     nc

d375 cd7ad3    call    $d37a
d378 18f7      jr      $d371            ; (-$09)
d37a cd51d3    call    $d351
d37d d8        ret     c

d37e cdc3d2    call    $d2c3
d381 cdd8d7    call    $d7d8
d384 daaad4    jp      c,$d4aa
d387 c9        ret     

d388 cdc3d2    call    $d2c3
d38b 50        ld      d,b
d38c 59        ld      e,c
d38d 3e0a      ld      a,$0a			; "<filename> is read only"
d38f c3b1cd    jp      $cdb1


d392 e5        push    hl
d393 d5        push    de
d394 c5        push    bc
d395 e5        push    hl
d396 110800    ld      de,$0008
d399 cd98ca    call    $ca98			;; DE = IY+DE
d39c cd10d4    call    $d410
d39f 3008      jr      nc,$d3a9         ; (+$08)
d3a1 eb        ex      de,hl
d3a2 e3        ex      (sp),hl
d3a3 cde8d9    call    $d9e8
d3a6 d1        pop     de
d3a7 1848      jr      $d3f1            ; (+$48)
d3a9 e1        pop     hl
d3aa c1        pop     bc
d3ab d1        pop     de
d3ac e1        pop     hl
d3ad b7        or      a
d3ae c9        ret     

d3af e5        push    hl
d3b0 d5        push    de
d3b1 c5        push    bc
d3b2 e5        push    hl
d3b3 112c00    ld      de,$002c
d3b6 cd98ca    call    $ca98			;; DE = IY+DE
d3b9 cdc8d6    call    $d6c8
d3bc 380b      jr      c,$d3c9          ; (+$0b)
d3be 3e08      ld      a,$08			; "disc full"
d3c0 c2b1cd    jp      nz,$cdb1


d3c3 cd8cd7    call    $d78c
d3c6 cdfad6    call    $d6fa
d3c9 cd2fd7    call    $d72f
d3cc 0e00      ld      c,$00
d3ce 3818      jr      c,$d3e8          ; (+$18)
d3d0 d5        push    de
d3d1 eb        ex      de,hl
d3d2 cd93d8    call    $d893
d3d5 eb        ex      de,hl
d3d6 3e08      ld      a,$08			; "disc full"
d3d8 d2b1cd    jp      nc,$cdb1


d3db 73        ld      (hl),e
d3dc 78        ld      a,b
d3dd b7        or      a
d3de 2802      jr      z,$d3e2          ; (+$02)
d3e0 23        inc     hl
d3e1 72        ld      (hl),d
d3e2 d1        pop     de
d3e3 cd2fd7    call    $d72f
d3e6 0e02      ld      c,$02
d3e8 eb        ex      de,hl
d3e9 e3        ex      (sp),hl
d3ea cdf3d9    call    $d9f3
d3ed d1        pop     de
d3ee cd7dd7    call    $d77d
d3f1 cda7d7    call    $d7a7
d3f4 c1        pop     bc
d3f5 d1        pop     de
d3f6 e1        pop     hl
d3f7 37        scf     
d3f8 c9        ret     

d3f9 e5        push    hl
d3fa 112c00    ld      de,$002c
d3fd cd98ca    call    $ca98			;; DE = IY+DE
d400 cd9cd7    call    $d79c
d403 cd10d4    call    $d410
d406 eb        ex      de,hl
d407 e1        pop     hl
d408 0e00      ld      c,$00
d40a daf3d9    jp      c,$d9f3
d40d c3afcd    jp      $cdaf			; display "Bad command" and quit command

;;--------------------------------------------------------------------------

d410 cdc8d6    call    $d6c8
d413 3812      jr      c,$d427          ; (+$12)
d415 c0        ret     nz

d416 cdfad6    call    $d6fa
d419 d5        push    de
d41a 42        ld      b,d
d41b 4b        ld      c,e
d41c 03        inc     bc
d41d c5        push    bc
d41e cdb3d7    call    $d7b3
d421 eb        ex      de,hl
d422 d1        pop     de
d423 dcdfdb    call    c,$dbdf			;; copy 32 bytes from HL to DE 
d426 d1        pop     de
d427 dc0cd7    call    c,$d70c
d42a da2fd7    jp      c,$d72f
d42d c9        ret     

;; ====================================================================================
;; |DIR

d42e cd73cd    call    $cd73				; calculate return address (in case of an error)
d431 0600      ld      b,$00
d433 b7        or      a
d434 2806      jr      z,$d43c          ; (+$06)
d436 cdc2cd    call    $cdc2			; test for a single parameter
d439 cdc7cd    call    $cdc7			; get string parameter
d43c cda6da    call    $daa6
d43f cd14ce    call    $ce14
d442 cdd0db    call    $dbd0			; "Drive <drive>: user <user>"
d445 3e0c      ld      a,$0c
d447 cd72d4    call    $d472
d44a 65        ld      h,l
d44b e5        push    hl
d44c cd83d6    call    $d683
d44f cd98d6    call    $d698
d452 301a      jr      nc,$d46e         
d454 cddfd9    call    $d9df			; get hidden state of file
d457 38f6      jr      c,$d44f          
d459 e3        ex      (sp),hl
d45a c5        push    bc
d45b 7c        ld      a,h
d45c bd        cp      l
d45d c4c4db    call    nz,$dbc4			; display 3 spaces
d460 cce9ca    call    z,$cae9			; display CR, LF
d463 cdc8db    call    $dbc8			; display filename
d466 2d        dec     l
d467 2001      jr      nz,$d46a         ; (+$01)
d469 6c        ld      l,h
d46a c1        pop     bc
d46b e3        ex      (sp),hl
d46c 18e1      jr      $d44f            ; (-$1f)
d46e e1        pop     hl
d46f c371d5    jp      $d571

;;==========================================================================
;; A = number of characters to display

d472 c603      add     a,$03
d474 67        ld      h,a
d475 d5        push    de
d476 e5        push    hl
d477 cd69bb    call    $bb69			; firmware function: txt get window
d47a 7a        ld      a,d
d47b e1        pop     hl
d47c d1        pop     de
d47d c604      add     a,$04
d47f 2e00      ld      l,$00
d481 2c        inc     l
d482 94        sub     h
d483 30fc      jr      nc,$d481         ; (-$04)
d485 2d        dec     l
d486 c0        ret     nz

d487 2e01      ld      l,$01
d489 c9        ret     

;; =========================================================================
;; |ERA

d48a cd73cd    call    $cd73				; calculate return address (in case of an error)
d48d cdc2cd    call    $cdc2			; test for a single parameter
d490 cdc7cd    call    $cdc7			; get string parameter
d493 cd8dda    call    $da8d
d496 cd14ce    call    $ce14
d499 cd83d6    call    $d683
d49c cd98d6    call    $d698
d49f 306b      jr      nc,$d50c         ; display "<filename> not found"
d4a1 cdb1d4    call    $d4b1
d4a4 cd98d6    call    $d698
d4a7 38f8      jr      c,$d4a1          ; (-$08)
d4a9 c9        ret     

;;=============================================================================

d4aa cdb1d4    call    $d4b1
d4ad d2b8cd    jp      nc,$cdb8
d4b0 c9        ret     

;;=============================================================================

d4b1 cdd9d9    call    $d9d9			; get read/write state of file
d4b4 3f        ccf     
d4b5 3e0a      ld      a,$0a			; "<filename> is read only"
d4b7 d2cadb    jp      nc,$dbca

d4ba af        xor     a
d4bb cd3cd8    call    $d83c
d4be 3ee5      ld      a,$e5
d4c0 12        ld      (de),a
d4c1 c37ad9    jp      $d97a

;;=============================================================================
;;|REN

d4c4 cd73cd    call    $cd73			; calculate return address (in case of an error)
d4c7 cdc1cd    call    $cdc1			; test for two parameters
d4ca cdc7cd    call    $cdc7			; get string parameter
d4cd cd5bda    call    $da5b
d4d0 c5        push    bc
d4d1 cdc7cd    call    $cdc7			; get string parameter
d4d4 cd60da    call    $da60
d4d7 e1        pop     hl
d4d8 0a        ld      a,(bc)
d4d9 be        cp      (hl)
d4da c2afcd    jp      nz,$cdaf			; display "Bad command" and quit command
d4dd cd14ce    call    $ce14
d4e0 23        inc     hl
d4e1 e5        push    hl
d4e2 cd44d6    call    $d644
d4e5 e1        pop     hl
d4e6 c5        push    bc
d4e7 44        ld      b,h
d4e8 4d        ld      c,l
d4e9 cd83d6    call    $d683
d4ec cd98d6    call    $d698
d4ef 301b      jr      nc,$d50c         ; display "<filename> not found"
d4f1 cdd9d9    call    $d9d9			; get read/write state of file
d4f4 da8dd3    jp      c,$d38d
d4f7 e3        ex      (sp),hl
d4f8 e5        push    hl
d4f9 c5        push    bc
d4fa 010c00    ld      bc,$000c
d4fd edb0      ldir    
d4ff c1        pop     bc
d500 e1        pop     hl
d501 e3        ex      (sp),hl
d502 cd7ad9    call    $d97a
d505 cd98d6    call    $d698
d508 38e7      jr      c,$d4f1          ; (-$19)
d50a e1        pop     hl
d50b c9        ret     

;;=============================================================================
;; display "<filename> not found"
d50c 50        ld      d,b
d50d 59        ld      e,c
d50e 3e06      ld      a,$06			; "<filename> not found"
d510 c3b1cd    jp      $cdb1

;;=============================================================================
;; CAS CATALOG

d513 cd73cd    call    $cd73				; calculate return address (in case of an error)
d516 d5        push    de
d517 dde1      pop     ix
d519 010008    ld      bc,$0800
d51c cdafca    call    $caaf			; clear memory
d51f cd86da    call    $da86
d522 cd14ce    call    $ce14
d525 cdd0db    call    $dbd0			; "Drive <drive>: user <user>"
d528 af        xor     a
d529 f5        push    af
d52a cd83d6    call    $d683
d52d cd98d6    call    $d698
d530 300c      jr      nc,$d53e         
d532 cddfd9    call    $d9df			; get hidden state of file
d535 38f6      jr      c,$d52d          
d537 e3        ex      (sp),hl
d538 cdaad5    call    $d5aa
d53b e3        ex      (sp),hl
d53c 38ef      jr      c,$d52d          ; (-$11)
d53e 3e11      ld      a,$11
d540 cd72d4    call    $d472
d543 55        ld      d,l
d544 f1        pop     af
d545 1e00      ld      e,$00
d547 1c        inc     e
d548 92        sub     d
d549 30fc      jr      nc,$d547         ; (-$04)
d54b 82        add     a,d
d54c 2001      jr      nz,$d54f         ; (+$01)
d54e 1d        dec     e
d54f dde5      push    ix
d551 e1        pop     hl
d552 4b        ld      c,e
d553 42        ld      b,d
d554 e5        push    hl

;; display all directory entries
d555 cd7ad5    call    $d57a			; display entry from directory
d558 d5        push    de
d559 eb        ex      de,hl
d55a 2600      ld      h,$00
d55c cd3ad6    call    $d63a			;; HL = HL * 14
d55f 19        add     hl,de
d560 d1        pop     de
d561 10f2      djnz    $d555            ; (-$0e)

d563 e1        pop     hl
d564 d5        push    de
d565 110e00    ld      de,$000e
d568 19        add     hl,de
d569 d1        pop     de
d56a 0d        dec     c
d56b 2804      jr      z,$d571          ; (+$04)
d56d 7e        ld      a,(hl)
d56e b7        or      a
d56f 20e2      jr      nz,$d553         ; (-$1e)
d571 cdc2d8    call    $d8c2
d574 3e03      ld      a,$03			; "free"
d576 b7        or      a
d577 c3ebca    jp      $caeb			; display message

;;================================================================================
;; display a entry from the directory list
;;
;; offset		length		description
;; 0			1			marker (0=end of list, <>0 = entry)
;; 1			11			filename (8 chars name, 3 chars extension)
;; 12			2			length of file in K
;; length = 14

d57a e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d57b b7        or      a				; end of filename list marker?
d57c c8        ret     z

d57d e5        push    hl
d57e d5        push    de
d57f c5        push    bc
d580 78        ld      a,b
d581 ba        cp      d
d582 c4c4db    call    nz,$dbc4			; display 3 spaces
d585 cce9ca    call    z,$cae9			; display CR, LF
d588 eb        ex      de,hl
d589 cdc8db    call    $dbc8			; display filename

d58c cdd9d9    call    $d9d9			; get read/write state of file

;; display character indicating read/write state of file
d58f 3e2a      ld      a,$2a			; '*'
d591 3802      jr      c,$d595          
d593 3e20      ld      a,$20			; ' '
d595 cd5abb    call    $bb5a			; firmware function: TXT OUTPUT

;; display file size
d598 210c00    ld      hl,$000c
d59b 19        add     hl,de
d59c e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d59d 5f        ld      e,a
d59e 23        inc     hl
d59f e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d5a0 57        ld      d,a
;; DE = size of file in K
d5a1 3e02      ld      a,$02			; "K"
d5a3 cdebca    call    $caeb			; display message
d5a6 c1        pop     bc
d5a7 d1        pop     de
d5a8 e1        pop     hl
d5a9 c9        ret     

;;===============================================================================


d5aa c5        push    bc
d5ab 4c        ld      c,h
d5ac 0600      ld      b,$00
d5ae dde5      push    ix
d5b0 e1        pop     hl
d5b1 e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d5b2 b7        or      a
d5b3 2850      jr      z,$d605          ; (+$50)
d5b5 04        inc     b
d5b6 cd23d6    call    $d623			; compare filenames
d5b9 280f      jr      z,$d5ca          ; (+$0f)
d5bb 3026      jr      nc,$d5e3         ; (+$26)
d5bd d5        push    de
d5be 110e00    ld      de,$000e
d5c1 19        add     hl,de
d5c2 d1        pop     de
d5c3 78        ld      a,b
d5c4 fe92      cp      $92
d5c6 38e9      jr      c,$d5b1          ; (-$17)
d5c8 1856      jr      $d620            ; (+$56)


d5ca e5        push    hl
d5cb cdf2d8    call    $d8f2
d5ce e3        ex      (sp),hl
d5cf 110c00    ld      de,$000c
d5d2 19        add     hl,de
d5d3 e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d5d4 5f        ld      e,a
d5d5 23        inc     hl
d5d6 e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d5d7 57        ld      d,a
d5d8 2b        dec     hl
d5d9 e3        ex      (sp),hl
d5da 19        add     hl,de
d5db eb        ex      de,hl
d5dc e1        pop     hl
d5dd 73        ld      (hl),e
d5de 23        inc     hl
d5df 72        ld      (hl),d
d5e0 37        scf     
d5e1 183d      jr      $d620            ; (+$3d)
d5e3 79        ld      a,c
d5e4 fe92      cp      $92
d5e6 2838      jr      z,$d620          ; (+$38)
d5e8 e5        push    hl
d5e9 d5        push    de
d5ea c5        push    bc
d5eb eb        ex      de,hl
d5ec 79        ld      a,c
d5ed 90        sub     b
d5ee 3c        inc     a
d5ef 6f        ld      l,a
d5f0 2600      ld      h,$00
d5f2 cd3ad6    call    $d63a			;; HL = HL * 14
d5f5 44        ld      b,h
d5f6 4d        ld      c,l
d5f7 19        add     hl,de
d5f8 2b        dec     hl
d5f9 eb        ex      de,hl
d5fa 210e00    ld      hl,$000e
d5fd 19        add     hl,de
d5fe eb        ex      de,hl
d5ff cd1eb9    call    $b91e			;; firmware function: KL LDDR
d602 c1        pop     bc
d603 d1        pop     de
d604 e1        pop     hl
d605 0c        inc     c
d606 c5        push    bc
d607 d5        push    de
d608 36ff      ld      (hl),$ff			;; write entry marker
d60a 23        inc     hl
d60b 13        inc     de
d60c eb        ex      de,hl
d60d 010b00    ld      bc,$000b
d610 cd1bb9    call    $b91b			;; firmware function: KL LDIR
d613 eb        ex      de,hl
d614 e3        ex      (sp),hl
d615 eb        ex      de,hl
d616 cdf2d8    call    $d8f2
d619 eb        ex      de,hl
d61a e1        pop     hl
d61b 73        ld      (hl),e			;; write size of file in K
d61c 23        inc     hl
d61d 72        ld      (hl),d
d61e c1        pop     bc
d61f 37        scf     
d620 61        ld      h,c
d621 c1        pop     bc
d622 c9        ret     

;;===================================================================================
;; compare filenames
;;
;; HL = filename1
;; DE = filename2
;; 
;; zero flag set = filenames are identical
;; zero flag clear = filenames are different
;;
;; - filenames not converted to upper case!
;; - filenames in directory entry form (8:3)

d623 e5        push    hl
d624 d5        push    de
d625 c5        push    bc
d626 060b      ld      b,$0b			; 8:3 (8 chars for filename, and 3 chars for extension)
d628 13        inc     de
d629 23        inc     hl

d62a 1a        ld      a,(de)
d62b e67f      and     $7f				; isolate ASCII code (removing possible flag in bit 7)
d62d 4f        ld      c,a

d62e e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
d62f e67f      and     $7f				; isolate ASCII code (removing possible flag in bit 7)

d631 b9        cp      c				; compare character
d632 2002      jr      nz,$d636         
;; character is the same
d634 10f2      djnz    $d628            
;; if execution gets to here then all all characters are the same

;;---------------------------------------------------
d636 c1        pop     bc
d637 d1        pop     de
d638 e1        pop     hl
d639 c9        ret     

;;===================================================================================
;; HL = HL*14
;;
;; All registers preserved
d63a d5        push    de
d63b 54        ld      d,h
d63c 5d        ld      e,l
d63d 29        add     hl,hl			; x2
d63e 19        add     hl,de			; x3
d63f 29        add     hl,hl			; x6
d640 19        add     hl,de			; x7
d641 29        add     hl,hl			; x14
d642 d1        pop     de
d643 c9        ret     
;;===================================================================================

d644 cd83d6    call    $d683
d647 cd98d6    call    $d698
d64a 3025      jr      nc,$d671         
d64c 3e05      ld      a,$05			; "<filename> already exists"
d64e c3b1cd    jp      $cdb1

;;----------------------------------------------------------------------------
;; check if filename exists

d651 cd83d6    call    $d683
d654 cd98d6    call    $d698
d657 3018      jr      nc,$d671         ; (+$18)
d659 e5        push    hl
d65a 210900    ld      hl,$0009
d65d cd9fca    call    $ca9f
d660 eb        ex      de,hl
d661 cddfdb    call    $dbdf			;; copy 32 bytes from HL to DE 
d664 e1        pop     hl
d665 fd7e05    ld      a,(iy+$05)
d668 b7        or      a
d669 37        scf     
d66a c0        ret     nz

d66b cda2d6    call    $d6a2
d66e 38fb      jr      c,$d66b          ; (-$05)
d670 37        scf     
d671 fd3605ff  ld      (iy+$05),$ff
d675 c9        ret     

d676 cd83d6    call    $d683
d679 cd98d6    call    $d698
d67c 30f3      jr      nc,$d671         ; (-$0d)
d67e cdaad4    call    $d4aa
d681 18f6      jr      $d679            ; (-$0a)

d683 c5        push    bc
d684 cd1fc5    call    $c51f
d687 c1        pop     bc
d688 21ffff    ld      hl,$ffff
d68b fd7e05    ld      a,(iy+$05)
d68e b7        or      a
d68f c0        ret     nz

d690 e5        push    hl
d691 cd14d8    call    $d814
d694 e1        pop     hl
d695 c3a8d9    jp      $d9a8
d698 cda2d6    call    $d6a2
d69b d0        ret     nc

d69c cdd8d7    call    $d7d8
d69f 30f7      jr      nc,$d698         ; (-$09)
d6a1 c9        ret     

d6a2 23        inc     hl
d6a3 fd7e05    ld      a,(iy+$05)
d6a6 b7        or      a
d6a7 2011      jr      nz,$d6ba         ; (+$11)
d6a9 cd1cd9    call    $d91c
d6ac d0        ret     nc

d6ad 1a        ld      a,(de)
d6ae fee5      cp      $e5
d6b0 37        scf     
d6b1 c8        ret     z

d6b2 cda8d9    call    $d9a8
d6b5 3eff      ld      a,$ff
d6b7 c33cd8    jp      $d83c
d6ba cdb8d9    call    $d9b8
d6bd d0        ret     nc

d6be c31cd9    jp      $d91c
d6c1 212100    ld      hl,$0021
d6c4 19        add     hl,de
d6c5 c3f9db    jp      $dbf9			; LD HL,(HL)

d6c8 212300    ld      hl,$0023
d6cb 19        add     hl,de
d6cc 7e        ld      a,(hl)
d6cd b7        or      a
d6ce c0        ret     nz
d6cf cdc1d6    call    $d6c1
d6d2 7c        ld      a,h
d6d3 1f        rra     
d6d4 1f        rra     
d6d5 1f        rra     
d6d6 1f        rra     
d6d7 e60f      and     $0f
d6d9 47        ld      b,a
d6da 29        add     hl,hl
d6db 7c        ld      a,h
d6dc e61f      and     $1f
d6de 4f        ld      c,a
d6df c5        push    bc
d6e0 210f00    ld      hl,$000f
d6e3 19        add     hl,de
d6e4 7e        ld      a,(hl)
d6e5 a8        xor     b
d6e6 200f      jr      nz,$d6f7         ; (+$0f)
d6e8 3e04      ld      a,$04
d6ea cd54da    call    $da54
d6ed 2f        cpl     
d6ee 47        ld      b,a
d6ef 2b        dec     hl
d6f0 2b        dec     hl
d6f1 7e        ld      a,(hl)
d6f2 a9        xor     c
d6f3 a0        and     b
d6f4 2001      jr      nz,$d6f7         ; (+$01)
d6f6 37        scf     
d6f7 c1        pop     bc
d6f8 9f        sbc     a,a
d6f9 c9        ret     

d6fa 210d00    ld      hl,$000d
d6fd 19        add     hl,de
d6fe 71        ld      (hl),c
d6ff 23        inc     hl
d700 23        inc     hl
d701 70        ld      (hl),b
d702 23        inc     hl
d703 eb        ex      de,hl
d704 011100    ld      bc,$0011
d707 cdafca    call    $caaf
d70a eb        ex      de,hl
d70b c9        ret     

d70c d5        push    de
d70d cdc1d6    call    $d6c1
d710 7c        ld      a,h
d711 e60f      and     $0f
d713 67        ld      h,a
d714 e5        push    hl
d715 211000    ld      hl,$0010
d718 19        add     hl,de
d719 4e        ld      c,(hl)
d71a 0600      ld      b,$00
d71c 2b        dec     hl
d71d 2b        dec     hl
d71e 2b        dec     hl
d71f 66        ld      h,(hl)
d720 68        ld      l,b
d721 3e01      ld      a,$01
d723 cdebdb    call    $dbeb			;; HL shift right by A
d726 09        add     hl,bc
d727 d1        pop     de
d728 13        inc     de
d729 cdf3db    call    $dbf3			; HL = HL - DE
d72c 3f        ccf     
d72d d1        pop     de
d72e c9        ret     

d72f cdc1d6    call    $d6c1
d732 3e03      ld      a,$03
d734 cd54da    call    $da54
d737 a5        and     l
d738 4f        ld      c,a
d739 3e02      ld      a,$02
d73b cd54da    call    $da54
d73e cdebdb    call    $dbeb			;; HL shift right by A
d741 3e06      ld      a,$06
d743 cd54da    call    $da54
d746 47        ld      b,a
d747 b7        or      a
d748 7d        ld      a,l
d749 211100    ld      hl,$0011
d74c 19        add     hl,de
d74d 280e      jr      z,$d75d          ; (+$0e)
d74f e607      and     $07
d751 87        add     a,a
d752 85        add     a,l
d753 6f        ld      l,a
d754 8c        adc     a,h
d755 95        sub     l
d756 67        ld      h,a
d757 e5        push    hl
d758 cdf9db    call    $dbf9			; LD HL,(HL)
d75b 180b      jr      $d768            ; (+$0b)

d75d e60f      and     $0f
d75f 85        add     a,l
d760 6f        ld      l,a
d761 8c        adc     a,h
d762 95        sub     l
d763 67        ld      h,a
d764 e5        push    hl
d765 6e        ld      l,(hl)
d766 2600      ld      h,$00
d768 7c        ld      a,h
d769 b5        or      l
d76a 280f      jr      z,$d77b          ; (+$0f)
d76c f1        pop     af
d76d 3e02      ld      a,$02
d76f cd54da    call    $da54
d772 29        add     hl,hl
d773 3d        dec     a
d774 20fc      jr      nz,$d772         ; (-$04)
d776 79        ld      a,c
d777 b5        or      l
d778 6f        ld      l,a
d779 37        scf     
d77a c9        ret     

d77b e1        pop     hl
d77c c9        ret     

d77d 211000    ld      hl,$0010
d780 19        add     hl,de
d781 7e        ld      a,(hl)
d782 34        inc     (hl)
d783 b7        or      a
d784 f0        ret     p

d785 3601      ld      (hl),$01
d787 2b        dec     hl
d788 2b        dec     hl
d789 2b        dec     hl
d78a 34        inc     (hl)
d78b c9        ret     

d78c d5        push    de
d78d d5        push    de
d78e cdbbd7    call    $d7bb
d791 e3        ex      (sp),hl
d792 23        inc     hl
d793 cddfdb    call    $dbdf			;; copy 32 bytes from HL to DE 
d796 e1        pop     hl
d797 cd7ad9    call    $d97a
d79a d1        pop     de
d79b c9        ret     

;;--------------------------------------------------------------------------
;; set length to 0

d79c 212100    ld      hl,$0021
d79f 19        add     hl,de
d7a0 af        xor     a
d7a1 77        ld      (hl),a
d7a2 23        inc     hl
d7a3 77        ld      (hl),a
d7a4 23        inc     hl
d7a5 77        ld      (hl),a
d7a6 c9        ret     
;;--------------------------------------------------------------------------

d7a7 212100    ld      hl,$0021
d7aa 19        add     hl,de
d7ab 34        inc     (hl)
d7ac c0        ret     nz

d7ad 23        inc     hl
d7ae 34        inc     (hl)
d7af c0        ret     nz

d7b0 23        inc     hl
d7b1 34        inc     (hl)
d7b2 c9        ret     

;;-----------------------------------------------------------------------

d7b3 cd83d6    call    $d683
d7b6 cd98d6    call    $d698
d7b9 1811      jr      $d7cc            ; (+$11)
d7bb 21ffff    ld      hl,$ffff
d7be 23        inc     hl
d7bf cd1cd9    call    $d91c
d7c2 3e07      ld      a,$07			; "Drive <drive>: directory full"
d7c4 d2b1cd    jp      nc,$cdb1

d7c7 1a        ld      a,(de)
d7c8 fee5      cp      $e5
d7ca 20f2      jr      nz,$d7be         ; (-$0e)
d7cc f5        push    af
d7cd fd7e05    ld      a,(iy+$05)
d7d0 b7        or      a
d7d1 3e09      ld      a,$09
d7d3 cab8cd    jp      z,$cdb8
d7d6 f1        pop     af
d7d7 c9        ret     

d7d8 c5        push    bc
d7d9 d5        push    de
d7da e5        push    hl
d7db 60        ld      h,b
d7dc 69        ld      l,c
d7dd 1a        ld      a,(de)
d7de ae        xor     (hl)
d7df 202d      jr      nz,$d80e         ; (+$2d)
d7e1 23        inc     hl
d7e2 13        inc     de
d7e3 060b      ld      b,$0b
d7e5 7e        ld      a,(hl)
d7e6 fe3f      cp      $3f
d7e8 2806      jr      z,$d7f0          ; (+$06)
d7ea 1a        ld      a,(de)
d7eb ae        xor     (hl)
d7ec e67f      and     $7f
d7ee 201e      jr      nz,$d80e         ; (+$1e)
d7f0 23        inc     hl
d7f1 13        inc     de
d7f2 10f1      djnz    $d7e5            ; (-$0f)
d7f4 7e        ld      a,(hl)
d7f5 3c        inc     a
d7f6 280c      jr      z,$d804          ; (+$0c)
d7f8 3e04      ld      a,$04
d7fa cd54da    call    $da54
d7fd 2f        cpl     
d7fe 47        ld      b,a
d7ff 1a        ld      a,(de)
d800 ae        xor     (hl)
d801 a0        and     b
d802 200a      jr      nz,$d80e         ; (+$0a)
d804 23        inc     hl
d805 13        inc     de
d806 23        inc     hl
d807 13        inc     de
d808 7e        ld      a,(hl)
d809 3c        inc     a
d80a 2802      jr      z,$d80e          ; (+$02)
d80c 1a        ld      a,(de)
d80d ae        xor     (hl)
d80e e1        pop     hl
d80f d1        pop     de
d810 c1        pop     bc
d811 c0        ret     nz

d812 37        scf     
d813 c9        ret     

d814 3e05      ld      a,$05
d816 cd45da    call    $da45
d819 3e03      ld      a,$03
d81b cdebdb    call    $dbeb			;; HL shift right by A
d81e 23        inc     hl
d81f eb        ex      de,hl
d820 3e0e      ld      a,$0e
d822 cd3fda    call    $da3f
d825 3600      ld      (hl),$00
d827 23        inc     hl
d828 1b        dec     de
d829 7a        ld      a,d
d82a b3        or      e
d82b 20f8      jr      nz,$d825         ; (-$08)
d82d 3e09      ld      a,$09
d82f cd45da    call    $da45
d832 eb        ex      de,hl
d833 3e0e      ld      a,$0e
d835 cd3fda    call    $da3f
d838 73        ld      (hl),e
d839 23        inc     hl
d83a 72        ld      (hl),d
d83b c9        ret     

d83c e5        push    hl
d83d d5        push    de
d83e c5        push    bc
d83f 4f        ld      c,a
d840 211000    ld      hl,$0010
d843 19        add     hl,de
d844 0610      ld      b,$10
d846 5e        ld      e,(hl)
d847 23        inc     hl
d848 3e06      ld      a,$06
d84a cd54da    call    $da54
d84d b7        or      a
d84e 2803      jr      z,$d853          ; (+$03)
d850 05        dec     b
d851 7e        ld      a,(hl)
d852 23        inc     hl
d853 57        ld      d,a
d854 b3        or      e
d855 280e      jr      z,$d865          ; (+$0e)
d857 e5        push    hl
d858 3e05      ld      a,$05
d85a cd45da    call    $da45
d85d 7d        ld      a,l
d85e 93        sub     e
d85f 7c        ld      a,h
d860 9a        sbc     a,d
d861 d46cd8    call    nc,$d86c
d864 e1        pop     hl
d865 10df      djnz    $d846            ; (-$21)
d867 c1        pop     bc
d868 d1        pop     de
d869 e1        pop     hl
d86a 37        scf     
d86b c9        ret     

d86c c5        push    bc
d86d d5        push    de
d86e d5        push    de
d86f eb        ex      de,hl
d870 3e03      ld      a,$03
d872 cdebdb    call    $dbeb			;; HL shift right by A
d875 eb        ex      de,hl
d876 3e0e      ld      a,$0e
d878 cd3fda    call    $da3f
d87b 19        add     hl,de
d87c d1        pop     de
d87d 7b        ld      a,e
d87e e607      and     $07
d880 5f        ld      e,a
d881 3e01      ld      a,$01
d883 1c        inc     e
d884 0f        rrca    
d885 1d        dec     e
d886 20fc      jr      nz,$d884         ; (-$04)
d888 47        ld      b,a
d889 a1        and     c
d88a 4f        ld      c,a
d88b 78        ld      a,b
d88c 2f        cpl     
d88d a6        and     (hl)
d88e b1        or      c
d88f 77        ld      (hl),a
d890 d1        pop     de
d891 c1        pop     bc
d892 c9        ret     

d893 c5        push    bc
d894 d5        push    de
d895 3e05      ld      a,$05
d897 cd45da    call    $da45
d89a eb        ex      de,hl
d89b 3e0e      ld      a,$0e
d89d cd3fda    call    $da3f
d8a0 018008    ld      bc,$0880
d8a3 7e        ld      a,(hl)
d8a4 a1        and     c
d8a5 280c      jr      z,$d8b3          ; (+$0c)
d8a7 0f        rrca    
d8a8 4f        ld      c,a
d8a9 7a        ld      a,d
d8aa b3        or      e
d8ab 2812      jr      z,$d8bf          ; (+$12)
d8ad 1b        dec     de
d8ae 10f3      djnz    $d8a3            ; (-$0d)
d8b0 23        inc     hl
d8b1 18ed      jr      $d8a0            ; (-$13)
d8b3 7e        ld      a,(hl)
d8b4 b1        or      c
d8b5 77        ld      (hl),a
d8b6 3e05      ld      a,$05
d8b8 cd45da    call    $da45
d8bb b7        or      a
d8bc ed52      sbc     hl,de
d8be 37        scf     
d8bf d1        pop     de
d8c0 c1        pop     bc
d8c1 c9        ret     

d8c2 c5        push    bc
d8c3 e5        push    hl
d8c4 210000    ld      hl,$0000
d8c7 e5        push    hl
d8c8 3e05      ld      a,$05
d8ca cd45da    call    $da45
d8cd eb        ex      de,hl
d8ce 3e0e      ld      a,$0e
d8d0 cd3fda    call    $da3f
d8d3 018008    ld      bc,$0880
d8d6 7e        ld      a,(hl)
d8d7 a1        and     c
d8d8 2003      jr      nz,$d8dd         ; (+$03)
d8da e3        ex      (sp),hl
d8db 23        inc     hl
d8dc e3        ex      (sp),hl
d8dd 79        ld      a,c
d8de 0f        rrca    
d8df 4f        ld      c,a
d8e0 7a        ld      a,d
d8e1 b3        or      e
d8e2 2806      jr      z,$d8ea          ; (+$06)
d8e4 1b        dec     de
d8e5 10ef      djnz    $d8d6            ; (-$11)
d8e7 23        inc     hl
d8e8 18e9      jr      $d8d3            ; (-$17)
d8ea e1        pop     hl
d8eb cd10d9    call    $d910
d8ee eb        ex      de,hl
d8ef e1        pop     hl
d8f0 c1        pop     bc
d8f1 c9        ret     

d8f2 d5        push    de
d8f3 211000    ld      hl,$0010
d8f6 19        add     hl,de
d8f7 110010    ld      de,$1000
d8fa 3e06      ld      a,$06
d8fc cd54da    call    $da54
d8ff b7        or      a
d900 7e        ld      a,(hl)
d901 23        inc     hl
d902 2803      jr      z,$d907          ; (+$03)
d904 b6        or      (hl)
d905 15        dec     d
d906 23        inc     hl
d907 b7        or      a
d908 2801      jr      z,$d90b          ; (+$01)
d90a 1c        inc     e
d90b 15        dec     d
d90c 20ec      jr      nz,$d8fa         ; (-$14)
d90e eb        ex      de,hl
d90f d1        pop     de
d910 3e02      ld      a,$02
d912 cd54da    call    $da54
d915 3d        dec     a
d916 3d        dec     a
d917 3d        dec     a
d918 c8        ret     z

d919 29        add     hl,hl
d91a 18fb      jr      $d917            ; (-$05)
d91c e5        push    hl
d91d c5        push    bc
d91e 7d        ld      a,l
d91f e603      and     $03
d921 2011      jr      nz,$d934         ; (+$11)
d923 eb        ex      de,hl
d924 3e07      ld      a,$07
d926 cd45da    call    $da45
d929 cdf3db    call    $dbf3			; HL = HL - DE
d92c 3f        ccf     
d92d eb        ex      de,hl
d92e 3015      jr      nc,$d945         ; (+$15)
d930 cd48d9    call    $d948
d933 af        xor     a
d934 47        ld      b,a
d935 3e08      ld      a,$08
d937 cd3fda    call    $da3f
d93a 112000    ld      de,$0020
d93d 04        inc     b
d93e 1801      jr      $d941            ; (+$01)
d940 19        add     hl,de
d941 10fd      djnz    $d940            ; (-$03)
d943 eb        ex      de,hl
d944 37        scf     
d945 c1        pop     bc
d946 e1        pop     hl
d947 c9        ret     

d948 3e02      ld      a,$02
d94a cdebdb    call    $dbeb			;; HL shift right by A
d94d eb        ex      de,hl
d94e 3e08      ld      a,$08
d950 cd3fda    call    $da3f
d953 cde8d9    call    $d9e8
d956 3e0b      ld      a,$0b
d958 cd45da    call    $da45
d95b eb        ex      de,hl
d95c cdf3db    call    $dbf3			; HL = HL - DE
d95f eb        ex      de,hl
d960 d0        ret     nc

d961 3e0c      ld      a,$0c
d963 cd3fda    call    $da3f
d966 19        add     hl,de
d967 cdc8d9    call    $d9c8
d96a be        cp      (hl)
d96b c8        ret     z

d96c f5        push    af
d96d eb        ex      de,hl
d96e 29        add     hl,hl
d96f 29        add     hl,hl
d970 cdb8d9    call    $d9b8
d973 eb        ex      de,hl
d974 d1        pop     de
d975 da33d2    jp      c,$d233
d978 72        ld      (hl),d
d979 c9        ret     

d97a e5        push    hl
d97b c5        push    bc
d97c 3e02      ld      a,$02
d97e cdebdb    call    $dbeb			;; HL shift right by A
d981 eb        ex      de,hl
d982 3e08      ld      a,$08
d984 cd3fda    call    $da3f
d987 0e01      ld      c,$01
d989 cdf3d9    call    $d9f3
d98c 3e0b      ld      a,$0b
d98e cd45da    call    $da45
d991 eb        ex      de,hl
d992 cdf3db    call    $dbf3			; HL = HL - DE
d995 eb        ex      de,hl
d996 300a      jr      nc,$d9a2         ; (+$0a)
d998 3e0c      ld      a,$0c
d99a cd3fda    call    $da3f
d99d 19        add     hl,de
d99e cdc8d9    call    $d9c8
d9a1 77        ld      (hl),a
d9a2 c1        pop     bc
d9a3 e1        pop     hl
d9a4 cdb8d9    call    $d9b8
d9a7 d8        ret     c

d9a8 d5        push    de
d9a9 e5        push    hl
d9aa eb        ex      de,hl
d9ab 13        inc     de
d9ac 3e02      ld      a,$02
d9ae cd35da    call    $da35
d9b1 73        ld      (hl),e
d9b2 23        inc     hl
d9b3 72        ld      (hl),d
d9b4 e1        pop     hl
d9b5 d1        pop     de
d9b6 37        scf     
d9b7 c9        ret     

d9b8 d5        push    de
d9b9 e5        push    hl
d9ba 3e02      ld      a,$02
d9bc cd35da    call    $da35
d9bf 5e        ld      e,(hl)
d9c0 23        inc     hl
d9c1 56        ld      d,(hl)
d9c2 e1        pop     hl
d9c3 cdf3db    call    $dbf3			; HL = HL - DE
d9c6 d1        pop     de
d9c7 c9        ret     

d9c8 c5        push    bc
d9c9 e5        push    hl
d9ca 0680      ld      b,$80
d9cc 3e08      ld      a,$08
d9ce cd3fda    call    $da3f

d9d1 af        xor     a
d9d2 86        add     a,(hl)
d9d3 23        inc     hl
d9d4 10fc      djnz    $d9d2            ; (-$04)
d9d6 e1        pop     hl
d9d7 c1        pop     bc
d9d8 c9        ret     

;;==============================================================
;; get read only, read/write state

d9d9 e5        push    hl
d9da 210900    ld      hl,$0009
d9dd 1804      jr      $d9e3            ; (+$04)

;;==============================================================
;; get system, directory state

d9df e5        push    hl
d9e0 210a00    ld      hl,$000a

;;--------------------------------------------------------------
;; HL = offset into directory entry
;; DE = address of directory entry
d9e3 19        add     hl,de
;; get byte
d9e4 7e        ld      a,(hl)
;; transfer bit 7 into carry
d9e5 87        add     a,a
d9e6 e1        pop     hl
d9e7 c9        ret     
;;------------------------------------------

d9e8 c5        push    bc
d9e9 d5        push    de
d9ea e5        push    hl
d9eb cd06da    call    $da06
d9ee cd4cc5    call    $c54c
d9f1 180b      jr      $d9fe            ; (+$0b)
d9f3 c5        push    bc
d9f4 d5        push    de
d9f5 e5        push    hl
d9f6 c5        push    bc
d9f7 cd06da    call    $da06
d9fa c1        pop     bc
d9fb cd2ec5    call    $c52e
d9fe b7        or      a
d9ff c2b6cd    jp      nz,$cdb6
da02 e1        pop     hl
da03 d1        pop     de
da04 c1        pop     bc
da05 c9        ret     

da06 d5        push    de
da07 44        ld      b,h
da08 4d        ld      c,l
da09 cd1ac5    call    $c51a			; CP/M function "setdma"
da0c d1        pop     de
da0d 3e0d      ld      a,$0d
da0f cd45da    call    $da45
da12 44        ld      b,h
da13 4d        ld      c,l
da14 af        xor     a
da15 cd45da    call    $da45
da18 0b        dec     bc
da19 03        inc     bc
da1a 7b        ld      a,e
da1b 95        sub     l
da1c 5f        ld      e,a
da1d 7a        ld      a,d
da1e 9c        sbc     a,h
da1f 57        ld      d,a
da20 30f7      jr      nc,$da19         ; (-$09)
da22 19        add     hl,de
da23 e5        push    hl
da24 cd24c5    call    $c524
da27 c1        pop     bc
da28 af        xor     a
da29 cd3fda    call    $da3f
da2c eb        ex      de,hl
da2d cd5ac5    call    $c55a			;; CP/M function "sectran"
da30 4d        ld      c,l
da31 44        ld      b,h
da32 c329c5    jp      $c529			;; CP/M function "setsec"

da35 fd8603    add     a,(iy+$03)
da38 6f        ld      l,a
da39 fd8e04    adc     a,(iy+$04)
da3c 95        sub     l
da3d 67        ld      h,a
da3e c9        ret     

da3f cd35da    call    $da35
da42 c3f9db    jp      $dbf9			; LD HL,(HL)


da45 f5        push    af
da46 3e0a      ld      a,$0a
da48 cd3fda    call    $da3f
da4b f1        pop     af
da4c 85        add     a,l
da4d 6f        ld      l,a
da4e 8c        adc     a,h
da4f 95        sub     l
da50 67        ld      h,a
da51 c3f9db    jp      $dbf9			; LD HL,(HL)
da54 e5        push    hl
da55 cd45da    call    $da45
da58 7d        ld      a,l
da59 e1        pop     hl
da5a c9        ret     

da5b 11e400    ld      de,$00e4
da5e 1803      jr      $da63            ; (+$03)

da60 11f400    ld      de,$00f4

da63 0e20      ld      c,$20
da65 cd74da    call    $da74
da68 182b      jr      $da95            ; (+$2b)

;;--------------------------------------------------------------
da6a cd6fda    call    $da6f
da6d 1826      jr      $da95            ; (+$26)
;;--------------------------------------------------------------

da6f 0eff      ld      c,$ff
da71 11e400    ld      de,$00e4

da74 cda0da    call    $daa0
da77 c5        push    bc
da78 160b      ld      d,$0b
da7a 03        inc     bc
da7b 03        inc     bc
da7c 0a        ld      a,(bc)
da7d fe3f      cp      $3f
da7f 2869      jr      z,$daea			; display "Bad command" and quit command
da81 15        dec     d
da82 20f7      jr      nz,$da7b         ; (-$09)
da84 c1        pop     bc
da85 c9        ret     

da86 0600      ld      b,$00
da88 cda6da    call    $daa6
da8b 1808      jr      $da95            ; (+$08)


da8d 0e20      ld      c,$20
da8f 11e400    ld      de,$00e4
da92 cda0da    call    $daa0

da95 210d00    ld      hl,$000d
da98 09        add     hl,bc
da99 36ff      ld      (hl),$ff
da9b 23        inc     hl
da9c 23        inc     hl
da9d 36ff      ld      (hl),$ff
da9f c9        ret     

;;------------------------------------------------------------------

daa0 cdb6da    call    $dab6
daa3 2845      jr      z,$daea			; display "Bad command" and quit command
daa5 c9        ret     

;;------------------------------------------------------------------

daa6 0e20      ld      c,$20
daa8 11e400    ld      de,$00e4
daab cdb6da    call    $dab6
daae c5        push    bc
daaf 0e0b      ld      c,$0b
dab1 cc8edb    call    z,$db8e			; fill with wildcard
dab4 c1        pop     bc
dab5 c9        ret     

dab6 e5        push    hl
dab7 cd98ca    call    $ca98			;; DE = IY+DE
daba d5        push    de
dabb fd7e00    ld      a,(iy+$00)
dabe 12        ld      (de),a
dabf 13        inc     de
dac0 fd7e01    ld      a,(iy+$01)
dac3 12        ld      (de),a
dac4 13        inc     de
dac5 c5        push    bc
dac6 41        ld      b,c
dac7 0e08      ld      c,$08
dac9 cd85db    call    $db85			; fill spaces
dacc 78        ld      a,b				
dacd 0e03      ld      c,$03
dacf cd90db    call    $db90			; fill with byte
dad2 010300    ld      bc,$0003
dad5 cdafca    call    $caaf
dad8 c1        pop     bc
dad9 d1        pop     de
dada e1        pop     hl
dadb d5        push    de
dadc cdedda    call    $daed
dadf d1        pop     de
dae0 3008      jr      nc,$daea			; display "Bad command" and quit command
dae2 42        ld      b,d
dae3 4b        ld      c,e
dae4 13        inc     de
dae5 13        inc     de
dae6 1a        ld      a,(de)
dae7 fe20      cp      $20
dae9 c9        ret     

daea c3afcd    jp      $cdaf			; display "Bad command" and quit command

daed 2b        dec     hl
daee cd97db    call    $db97
daf1 3f        ccf     
daf2 d8        ret     c

daf3 4f        ld      c,a
daf4 e5        push    hl
daf5 c5        push    bc
daf6 fe3a      cp      $3a
daf8 2806      jr      z,$db00          ; (+$06)
dafa cda5db    call    $dba5
dafd 38f7      jr      c,$daf6          ; (-$09)
daff 37        scf     
db00 c1        pop     bc
db01 e1        pop     hl
db02 79        ld      a,c
db03 383e      jr      c,$db43          ; (+$3e)
db05 13        inc     de
db06 fe30      cp      $30
db08 381f      jr      c,$db29          ; (+$1f)
db0a fe3a      cp      $3a
db0c 301b      jr      nc,$db29         ; (+$1b)
db0e d630      sub     $30
db10 4f        ld      c,a
db11 12        ld      (de),a
db12 cda5db    call    $dba5
db15 fe30      cp      $30
db17 3810      jr      c,$db29          ; (+$10)
db19 fe3a      cp      $3a
db1b 300c      jr      nc,$db29         ; (+$0c)
db1d b7        or      a
db1e 0d        dec     c
db1f c0        ret     nz

db20 c6da      add     a,$da
db22 fe10      cp      $10
db24 d0        ret     nc

db25 12        ld      (de),a
db26 cda5db    call    $dba5
db29 1b        dec     de
db2a fe51      cp      $51
db2c 300a      jr      nc,$db38         ; (+$0a)
db2e fe41      cp      $41
db30 3806      jr      c,$db38          ; (+$06)
db32 d641      sub     $41
db34 12        ld      (de),a
db35 cda5db    call    $dba5
db38 cd9bdb    call    $db9b
db3b ee3a      xor     $3a
db3d c0        ret     nz

db3e cd97db    call    $db97
db41 3f        ccf     
db42 d8        ret     c

db43 13        inc     de
db44 13        inc     de
db45 fe2e      cp      $2e				; '.'
db47 c8        ret     z

db48 0e08      ld      c,$08
db4a cd58db    call    $db58
db4d d8        ret     c

db4e ee2e      xor     $2e				; '.'
db50 c0        ret     nz

db51 cd97db    call    $db97
db54 0e03      ld      c,$03
db56 302d      jr      nc,$db85			; fill spaces
db58 fe20      cp      $20
db5a 3829      jr      c,$db85          ; fill spaces
db5c e5        push    hl
db5d c5        push    bc
db5e 47        ld      b,a
db5f 21b2db    ld      hl,$dbb2
db62 7e        ld      a,(hl)
db63 23        inc     hl
db64 b7        or      a
db65 2804      jr      z,$db6b          ; (+$04)
db67 b8        cp      b
db68 20f8      jr      nz,$db62         ; (-$08)
db6a 37        scf     
db6b 78        ld      a,b
db6c c1        pop     bc
db6d e1        pop     hl
db6e 3815      jr      c,$db85          ; fill spaces
db70 0d        dec     c
db71 f8        ret     m

db72 fe2a      cp      $2a
db74 cc8edb    call    z,$db8e			; fill with wildcard
db77 12        ld      (de),a
db78 13        inc     de
db79 cda5db    call    $dba5
db7c 3007      jr      nc,$db85         ; fill spaces
db7e fe20      cp      $20
db80 20d6      jr      nz,$db58         ; (-$2a)
db82 cd9bdb    call    $db9b


;;--------------------------------------------------------
;; fill with spaces
;;
;; C = count
;; DE = buffer

db85 f5        push    af
db86 3e20      ld      a,$20
db88 cd90db    call    $db90			; fill with byte
db8b f1        pop     af
db8c 3f        ccf     
db8d c9        ret     

;;========================================================
;; fill with wildcard token
;;
;; C = count
;; DE = buffer
db8e 3e3f      ld      a,$3f			; '?'

;;========================================================
;; fill with any byte
;;
;; DE = buffer
;; A = byte
;; C = count-1

db90 0c        inc     c

db91 0d        dec     c				; decrement count
db92 c8        ret     z
db93 12        ld      (de),a			; write byte
db94 13        inc     de				; increment pointer
db95 18fa      jr      $db91            

;;========================================================


db97 cda5db    call    $dba5
db9a d0        ret     nc

db9b fe20      cp      $20
db9d 37        scf     
db9e c0        ret     nz

db9f cda5db    call    $dba5
dba2 38f7      jr      c,$db9b          ; (-$09)
dba4 c9        ret     

;;========================================================
;; convert bytes to upper case

dba5 78        ld      a,b
dba6 b7        or      a
dba7 c8        ret     z

dba8 23        inc     hl
dba9 05        dec     b
dbaa e7        rst     $20				; firmware function: RST 4 - LOW: RAM LAM
dbab e67f      and     $7f
dbad cda6ca    call    $caa6			; convert character to upper case
dbb0 37        scf     
dbb1 c9        ret     
;;========================================================
;; table of invalid characters
dbb2 
defb '<'
defb '>'
defb '.'
defb ','
defb ';'
defb ':'
defb '='
defb '['
defb ']'
defb '_'
defb '%'
defb '|'
defb '('
defb ')'
defb '/'
defb '\'
defb &7f
defb 0
;;========================================================
;; display 3 spaces
dbc4 3e01      ld      a,$01			; "   " (3 spaces)
dbc6 1802      jr      $dbca            

;;=======================================================
;; display filename
dbc8 3e0b      ld      a,$0b			; "<filename>"

dbca c5        push    bc
dbcb fd4e02    ld      c,(iy+$02)
dbce 180a      jr      $dbda            

;;=======================================================
;; display "Drive <drive> : user <user> "

dbd0 c5        push    bc
dbd1 0a        ld      a,(bc)
dbd2 5f        ld      e,a
dbd3 1600      ld      d,$00			;; DE = user
dbd5 0b        dec     bc
dbd6 0a        ld      a,(bc)
dbd7 4f        ld      c,a				;; C = drive index

dbd8 3e0c      ld      a,$0c			; "Drive <drive> : user <user> "
dbda cdebca    call    $caeb			; display message
dbdd c1        pop     bc
dbde c9        ret     

;;====================================================================================
;; copy 32 bytes from HL to DE 
;; 
;; HL,DE,BC preserved

dbdf e5        push    hl
dbe0 d5        push    de
dbe1 c5        push    bc
dbe2 012000    ld      bc,$0020
dbe5 edb0      ldir    
dbe7 c1        pop     bc
dbe8 d1        pop     de
dbe9 e1        pop     hl
dbea c9        ret     

;;====================================================================================
;; HL shift right by A

dbeb cb3c      srl     h
dbed cb1d      rr      l
dbef 3d        dec     a
dbf0 20f9      jr      nz,$dbeb         
dbf2 c9        ret     

;;====================================================================================
;; HL = HL-DE
dbf3 e5        push    hl
dbf4 b7        or      a
dbf5 ed52      sbc     hl,de
dbf7 e1        pop     hl
dbf8 c9        ret     

;;====================================================================================
;; LD HL,(HL)
dbf9 d5        push    de
dbfa 5e        ld      e,(hl)
dbfb 23        inc     hl
dbfc 56        ld      d,(hl)
dbfd eb        ex      de,hl
dbfe d1        pop     de
dbff c9        ret     

;;====================================================================================


dc00 ff        rst     $38
dc01 ff        rst     $38
dc02 ff        rst     $38
dc03 ff        rst     $38
dc04 ff        rst     $38
dc05 ff        rst     $38
dc06 ff        rst     $38
dc07 ff        rst     $38
dc08 ff        rst     $38
dc09 ff        rst     $38
dc0a ff        rst     $38
dc0b ff        rst     $38
dc0c ff        rst     $38
dc0d ff        rst     $38
dc0e ff        rst     $38
dc0f ff        rst     $38
dc10 ff        rst     $38
dc11 ff        rst     $38
dc12 ff        rst     $38
dc13 ff        rst     $38
dc14 ff        rst     $38
dc15 ff        rst     $38
dc16 ff        rst     $38
dc17 ff        rst     $38
dc18 ff        rst     $38
dc19 ff        rst     $38
dc1a ff        rst     $38
dc1b ff        rst     $38
dc1c ff        rst     $38
dc1d ff        rst     $38
dc1e ff        rst     $38
dc1f ff        rst     $38
dc20 ff        rst     $38
dc21 ff        rst     $38
dc22 ff        rst     $38
dc23 ff        rst     $38
dc24 ff        rst     $38
dc25 ff        rst     $38
dc26 ff        rst     $38
dc27 ff        rst     $38
dc28 ff        rst     $38
dc29 ff        rst     $38
dc2a ff        rst     $38
dc2b ff        rst     $38
dc2c ff        rst     $38
dc2d ff        rst     $38
dc2e ff        rst     $38
dc2f ff        rst     $38
dc30 ff        rst     $38
dc31 ff        rst     $38
dc32 ff        rst     $38
dc33 ff        rst     $38
dc34 ff        rst     $38
dc35 ff        rst     $38
dc36 ff        rst     $38
dc37 ff        rst     $38
dc38 ff        rst     $38
dc39 ff        rst     $38
dc3a ff        rst     $38
dc3b ff        rst     $38
dc3c ff        rst     $38
dc3d ff        rst     $38
dc3e ff        rst     $38
dc3f ff        rst     $38
dc40 ff        rst     $38
dc41 ff        rst     $38
dc42 ff        rst     $38
dc43 ff        rst     $38
dc44 ff        rst     $38
dc45 ff        rst     $38
dc46 ff        rst     $38
dc47 ff        rst     $38
dc48 ff        rst     $38
dc49 ff        rst     $38
dc4a ff        rst     $38
dc4b ff        rst     $38
dc4c ff        rst     $38
dc4d ff        rst     $38
dc4e ff        rst     $38
dc4f ff        rst     $38
dc50 ff        rst     $38
dc51 ff        rst     $38
dc52 ff        rst     $38
dc53 ff        rst     $38
dc54 ff        rst     $38
dc55 ff        rst     $38
dc56 ff        rst     $38
dc57 ff        rst     $38
dc58 ff        rst     $38
dc59 ff        rst     $38
dc5a ff        rst     $38
dc5b ff        rst     $38
dc5c ff        rst     $38
dc5d ff        rst     $38
dc5e ff        rst     $38
dc5f ff        rst     $38
dc60 ff        rst     $38
dc61 ff        rst     $38
dc62 ff        rst     $38
dc63 ff        rst     $38
dc64 ff        rst     $38
dc65 ff        rst     $38
dc66 ff        rst     $38
dc67 ff        rst     $38
dc68 ff        rst     $38
dc69 ff        rst     $38
dc6a ff        rst     $38
dc6b ff        rst     $38
dc6c ff        rst     $38
dc6d ff        rst     $38
dc6e ff        rst     $38
dc6f ff        rst     $38
dc70 ff        rst     $38
dc71 ff        rst     $38
dc72 ff        rst     $38
dc73 ff        rst     $38
dc74 ff        rst     $38
dc75 ff        rst     $38
dc76 ff        rst     $38
dc77 ff        rst     $38
dc78 ff        rst     $38
dc79 ff        rst     $38
dc7a ff        rst     $38
dc7b ff        rst     $38
dc7c ff        rst     $38
dc7d ff        rst     $38
dc7e ff        rst     $38
dc7f ff        rst     $38
dc80 ff        rst     $38
dc81 ff        rst     $38
dc82 ff        rst     $38
dc83 ff        rst     $38
dc84 ff        rst     $38
dc85 ff        rst     $38
dc86 ff        rst     $38
dc87 ff        rst     $38
dc88 ff        rst     $38
dc89 ff        rst     $38
dc8a ff        rst     $38
dc8b ff        rst     $38
dc8c ff        rst     $38
dc8d ff        rst     $38
dc8e ff        rst     $38
dc8f ff        rst     $38
dc90 ff        rst     $38
dc91 ff        rst     $38
dc92 ff        rst     $38
dc93 ff        rst     $38
dc94 ff        rst     $38
dc95 ff        rst     $38
dc96 ff        rst     $38
dc97 ff        rst     $38
dc98 ff        rst     $38
dc99 ff        rst     $38
dc9a ff        rst     $38
dc9b ff        rst     $38
dc9c ff        rst     $38
dc9d ff        rst     $38
dc9e ff        rst     $38
dc9f ff        rst     $38
dca0 ff        rst     $38
dca1 ff        rst     $38
dca2 ff        rst     $38
dca3 ff        rst     $38
dca4 ff        rst     $38
dca5 ff        rst     $38
dca6 ff        rst     $38
dca7 ff        rst     $38
dca8 ff        rst     $38
dca9 ff        rst     $38
dcaa ff        rst     $38
dcab ff        rst     $38
dcac ff        rst     $38
dcad ff        rst     $38
dcae ff        rst     $38
dcaf ff        rst     $38
dcb0 ff        rst     $38
dcb1 ff        rst     $38
dcb2 ff        rst     $38
dcb3 ff        rst     $38
dcb4 ff        rst     $38
dcb5 ff        rst     $38
dcb6 ff        rst     $38
dcb7 ff        rst     $38
dcb8 ff        rst     $38
dcb9 ff        rst     $38
dcba ff        rst     $38
dcbb ff        rst     $38
dcbc ff        rst     $38
dcbd ff        rst     $38
dcbe ff        rst     $38
dcbf ff        rst     $38
dcc0 ff        rst     $38
dcc1 ff        rst     $38
dcc2 ff        rst     $38
dcc3 ff        rst     $38
dcc4 ff        rst     $38
dcc5 ff        rst     $38
dcc6 ff        rst     $38
dcc7 ff        rst     $38
dcc8 ff        rst     $38
dcc9 ff        rst     $38
dcca ff        rst     $38
dccb ff        rst     $38
dccc ff        rst     $38
dccd ff        rst     $38
dcce ff        rst     $38
dccf ff        rst     $38
dcd0 ff        rst     $38
dcd1 ff        rst     $38
dcd2 ff        rst     $38
dcd3 ff        rst     $38
dcd4 ff        rst     $38
dcd5 ff        rst     $38
dcd6 ff        rst     $38
dcd7 ff        rst     $38
dcd8 ff        rst     $38
dcd9 ff        rst     $38
dcda ff        rst     $38
dcdb ff        rst     $38
dcdc ff        rst     $38
dcdd ff        rst     $38
dcde ff        rst     $38
dcdf ff        rst     $38
dce0 ff        rst     $38
dce1 ff        rst     $38
dce2 ff        rst     $38
dce3 ff        rst     $38
dce4 ff        rst     $38
dce5 ff        rst     $38
dce6 ff        rst     $38
dce7 ff        rst     $38
dce8 ff        rst     $38
dce9 ff        rst     $38
dcea ff        rst     $38
dceb ff        rst     $38
dcec ff        rst     $38
dced ff        rst     $38
dcee ff        rst     $38
dcef ff        rst     $38
dcf0 ff        rst     $38
dcf1 ff        rst     $38
dcf2 ff        rst     $38
dcf3 ff        rst     $38
dcf4 ff        rst     $38
dcf5 ff        rst     $38
dcf6 ff        rst     $38
dcf7 ff        rst     $38
dcf8 ff        rst     $38
dcf9 ff        rst     $38
dcfa ff        rst     $38
dcfb ff        rst     $38
dcfc ff        rst     $38
dcfd ff        rst     $38
dcfe ff        rst     $38
dcff ff        rst     $38
dd00 ff        rst     $38
dd01 ff        rst     $38
dd02 ff        rst     $38
dd03 ff        rst     $38
dd04 ff        rst     $38
dd05 ff        rst     $38
dd06 ff        rst     $38
dd07 ff        rst     $38
dd08 ff        rst     $38
dd09 ff        rst     $38
dd0a ff        rst     $38
dd0b ff        rst     $38
dd0c ff        rst     $38
dd0d ff        rst     $38
dd0e ff        rst     $38
dd0f ff        rst     $38
dd10 ff        rst     $38
dd11 ff        rst     $38
dd12 ff        rst     $38
dd13 ff        rst     $38
dd14 ff        rst     $38
dd15 ff        rst     $38
dd16 ff        rst     $38
dd17 ff        rst     $38
dd18 ff        rst     $38
dd19 ff        rst     $38
dd1a ff        rst     $38
dd1b ff        rst     $38
dd1c ff        rst     $38
dd1d ff        rst     $38
dd1e ff        rst     $38
dd1f ff        rst     $38
dd20 ff        rst     $38
dd21 ff        rst     $38
dd22 ff        rst     $38
dd23 ff        rst     $38
dd24 ff        rst     $38
dd25 ff        rst     $38
dd26 ff        rst     $38
dd27 ff        rst     $38
dd28 ff        rst     $38
dd29 ff        rst     $38
dd2a ff        rst     $38
dd2b ff        rst     $38
dd2c ff        rst     $38
dd2d ff        rst     $38
dd2e ff        rst     $38
dd2f ff        rst     $38
dd30 ff        rst     $38
dd31 ff        rst     $38
dd32 ff        rst     $38
dd33 ff        rst     $38
dd34 ff        rst     $38
dd35 ff        rst     $38
dd36 ff        rst     $38
dd37 ff        rst     $38
dd38 ff        rst     $38
dd39 ff        rst     $38
dd3a ff        rst     $38
dd3b ff        rst     $38
dd3c ff        rst     $38
dd3d ff        rst     $38
dd3e ff        rst     $38
dd3f ff        rst     $38
dd40 ff        rst     $38
dd41 ff        rst     $38
dd42 ff        rst     $38
dd43 ff        rst     $38
dd44 ff        rst     $38
dd45 ff        rst     $38
dd46 ff        rst     $38
dd47 ff        rst     $38
dd48 ff        rst     $38
dd49 ff        rst     $38
dd4a ff        rst     $38
dd4b ff        rst     $38
dd4c ff        rst     $38
dd4d ff        rst     $38
dd4e ff        rst     $38
dd4f ff        rst     $38
dd50 ff        rst     $38
dd51 ff        rst     $38
dd52 ff        rst     $38
dd53 ff        rst     $38
dd54 ff        rst     $38
dd55 ff        rst     $38
dd56 ff        rst     $38
dd57 ff        rst     $38
dd58 ff        rst     $38
dd59 ff        rst     $38
dd5a ff        rst     $38
dd5b ff        rst     $38
dd5c ff        rst     $38
dd5d ff        rst     $38
dd5e ff        rst     $38
dd5f ff        rst     $38
dd60 ff        rst     $38
dd61 ff        rst     $38
dd62 ff        rst     $38
dd63 ff        rst     $38
dd64 ff        rst     $38
dd65 ff        rst     $38
dd66 ff        rst     $38
dd67 ff        rst     $38
dd68 ff        rst     $38
dd69 ff        rst     $38
dd6a ff        rst     $38
dd6b ff        rst     $38
dd6c ff        rst     $38
dd6d ff        rst     $38
dd6e ff        rst     $38
dd6f ff        rst     $38
dd70 ff        rst     $38
dd71 ff        rst     $38
dd72 ff        rst     $38
dd73 ff        rst     $38
dd74 ff        rst     $38
dd75 ff        rst     $38
dd76 ff        rst     $38
dd77 ff        rst     $38
dd78 ff        rst     $38
dd79 ff        rst     $38
dd7a ff        rst     $38
dd7b ff        rst     $38
dd7c ff        rst     $38
dd7d ff        rst     $38
dd7e ff        rst     $38
dd7f ff        rst     $38
dd80 ff        rst     $38
dd81 ff        rst     $38
dd82 ff        rst     $38
dd83 ff        rst     $38
dd84 ff        rst     $38
dd85 ff        rst     $38
dd86 ff        rst     $38
dd87 ff        rst     $38
dd88 ff        rst     $38
dd89 ff        rst     $38
dd8a ff        rst     $38
dd8b ff        rst     $38
dd8c ff        rst     $38
dd8d ff        rst     $38
dd8e ff        rst     $38
dd8f ff        rst     $38
dd90 ff        rst     $38
dd91 ff        rst     $38
dd92 ff        rst     $38
dd93 ff        rst     $38
dd94 ff        rst     $38
dd95 ff        rst     $38
dd96 ff        rst     $38
dd97 ff        rst     $38
dd98 ff        rst     $38
dd99 ff        rst     $38
dd9a ff        rst     $38
dd9b ff        rst     $38
dd9c ff        rst     $38
dd9d ff        rst     $38
dd9e ff        rst     $38
dd9f ff        rst     $38
dda0 ff        rst     $38
dda1 ff        rst     $38
dda2 ff        rst     $38
dda3 ff        rst     $38
dda4 ff        rst     $38
dda5 ff        rst     $38
dda6 ff        rst     $38
dda7 ff        rst     $38
dda8 ff        rst     $38
dda9 ff        rst     $38
ddaa ff        rst     $38
ddab ff        rst     $38
ddac ff        rst     $38
ddad ff        rst     $38
ddae ff        rst     $38
ddaf ff        rst     $38
ddb0 ff        rst     $38
ddb1 ff        rst     $38
ddb2 ff        rst     $38
ddb3 ff        rst     $38
ddb4 ff        rst     $38
ddb5 ff        rst     $38
ddb6 ff        rst     $38
ddb7 ff        rst     $38
ddb8 ff        rst     $38
ddb9 ff        rst     $38
ddba ff        rst     $38
ddbb ff        rst     $38
ddbc ff        rst     $38
ddbd ff        rst     $38
ddbe ff        rst     $38
ddbf ff        rst     $38
ddc0 ff        rst     $38
ddc1 ff        rst     $38
ddc2 ff        rst     $38
ddc3 ff        rst     $38
ddc4 ff        rst     $38
ddc5 ff        rst     $38
ddc6 ff        rst     $38
ddc7 ff        rst     $38
ddc8 ff        rst     $38
ddc9 ff        rst     $38
ddca ff        rst     $38
ddcb ff        rst     $38
ddcc ff        rst     $38
ddcd ff        rst     $38
ddce ff        rst     $38
ddcf ff        rst     $38
ddd0 ff        rst     $38
ddd1 ff        rst     $38
ddd2 ff        rst     $38
ddd3 ff        rst     $38
ddd4 ff        rst     $38
ddd5 ff        rst     $38
ddd6 ff        rst     $38
ddd7 ff        rst     $38
ddd8 ff        rst     $38
ddd9 ff        rst     $38
ddda ff        rst     $38
dddb ff        rst     $38
dddc ff        rst     $38
dddd ff        rst     $38
ddde ff        rst     $38
dddf ff        rst     $38
dde0 ff        rst     $38
dde1 ff        rst     $38
dde2 ff        rst     $38
dde3 ff        rst     $38
dde4 ff        rst     $38
dde5 ff        rst     $38
dde6 ff        rst     $38
dde7 ff        rst     $38
dde8 ff        rst     $38
dde9 ff        rst     $38
ddea ff        rst     $38
ddeb ff        rst     $38
ddec ff        rst     $38
dded ff        rst     $38
ddee ff        rst     $38
ddef ff        rst     $38
ddf0 ff        rst     $38
ddf1 ff        rst     $38
ddf2 ff        rst     $38
ddf3 ff        rst     $38
ddf4 ff        rst     $38
ddf5 ff        rst     $38
ddf6 ff        rst     $38
ddf7 ff        rst     $38
ddf8 ff        rst     $38
ddf9 ff        rst     $38
ddfa ff        rst     $38
ddfb ff        rst     $38
ddfc ff        rst     $38
ddfd ff        rst     $38
ddfe ff        rst     $38
ddff ff        rst     $38
de00 ff        rst     $38
de01 ff        rst     $38
de02 ff        rst     $38
de03 ff        rst     $38
de04 ff        rst     $38
de05 ff        rst     $38
de06 ff        rst     $38
de07 ff        rst     $38
de08 ff        rst     $38
de09 ff        rst     $38
de0a ff        rst     $38
de0b ff        rst     $38
de0c ff        rst     $38
de0d ff        rst     $38
de0e ff        rst     $38
de0f ff        rst     $38
de10 ff        rst     $38
de11 ff        rst     $38
de12 ff        rst     $38
de13 ff        rst     $38
de14 ff        rst     $38
de15 ff        rst     $38
de16 ff        rst     $38
de17 ff        rst     $38
de18 ff        rst     $38
de19 ff        rst     $38
de1a ff        rst     $38
de1b ff        rst     $38
de1c ff        rst     $38
de1d ff        rst     $38
de1e ff        rst     $38
de1f ff        rst     $38
de20 ff        rst     $38
de21 ff        rst     $38
de22 ff        rst     $38
de23 ff        rst     $38
de24 ff        rst     $38
de25 ff        rst     $38
de26 ff        rst     $38
de27 ff        rst     $38
de28 ff        rst     $38
de29 ff        rst     $38
de2a ff        rst     $38
de2b ff        rst     $38
de2c ff        rst     $38
de2d ff        rst     $38
de2e ff        rst     $38
de2f ff        rst     $38
de30 ff        rst     $38
de31 ff        rst     $38
de32 ff        rst     $38
de33 ff        rst     $38
de34 ff        rst     $38
de35 ff        rst     $38
de36 ff        rst     $38
de37 ff        rst     $38
de38 ff        rst     $38
de39 ff        rst     $38
de3a ff        rst     $38
de3b ff        rst     $38
de3c ff        rst     $38
de3d ff        rst     $38
de3e ff        rst     $38
de3f ff        rst     $38
de40 ff        rst     $38
de41 ff        rst     $38
de42 ff        rst     $38
de43 ff        rst     $38
de44 ff        rst     $38
de45 ff        rst     $38
de46 ff        rst     $38
de47 ff        rst     $38
de48 ff        rst     $38
de49 ff        rst     $38
de4a ff        rst     $38
de4b ff        rst     $38
de4c ff        rst     $38
de4d ff        rst     $38
de4e ff        rst     $38
de4f ff        rst     $38
de50 ff        rst     $38
de51 ff        rst     $38
de52 ff        rst     $38
de53 ff        rst     $38
de54 ff        rst     $38
de55 ff        rst     $38
de56 ff        rst     $38
de57 ff        rst     $38
de58 ff        rst     $38
de59 ff        rst     $38
de5a ff        rst     $38
de5b ff        rst     $38
de5c ff        rst     $38
de5d ff        rst     $38
de5e ff        rst     $38
de5f ff        rst     $38
de60 ff        rst     $38
de61 ff        rst     $38
de62 ff        rst     $38
de63 ff        rst     $38
de64 ff        rst     $38
de65 ff        rst     $38
de66 ff        rst     $38
de67 ff        rst     $38
de68 ff        rst     $38
de69 ff        rst     $38
de6a ff        rst     $38
de6b ff        rst     $38
de6c ff        rst     $38
de6d ff        rst     $38
de6e ff        rst     $38
de6f ff        rst     $38
de70 ff        rst     $38
de71 ff        rst     $38
de72 ff        rst     $38
de73 ff        rst     $38
de74 ff        rst     $38
de75 ff        rst     $38
de76 ff        rst     $38
de77 ff        rst     $38
de78 ff        rst     $38
de79 ff        rst     $38
de7a ff        rst     $38
de7b ff        rst     $38
de7c ff        rst     $38
de7d ff        rst     $38
de7e ff        rst     $38
de7f ff        rst     $38
de80 ff        rst     $38
de81 ff        rst     $38
de82 ff        rst     $38
de83 ff        rst     $38
de84 ff        rst     $38
de85 ff        rst     $38
de86 ff        rst     $38
de87 ff        rst     $38
de88 ff        rst     $38
de89 ff        rst     $38
de8a ff        rst     $38
de8b ff        rst     $38
de8c ff        rst     $38
de8d ff        rst     $38
de8e ff        rst     $38
de8f ff        rst     $38
de90 ff        rst     $38
de91 ff        rst     $38
de92 ff        rst     $38
de93 ff        rst     $38
de94 ff        rst     $38
de95 ff        rst     $38
de96 ff        rst     $38
de97 ff        rst     $38
de98 ff        rst     $38
de99 ff        rst     $38
de9a ff        rst     $38
de9b ff        rst     $38
de9c ff        rst     $38
de9d ff        rst     $38
de9e ff        rst     $38
de9f ff        rst     $38
dea0 ff        rst     $38
dea1 ff        rst     $38
dea2 ff        rst     $38
dea3 ff        rst     $38
dea4 ff        rst     $38
dea5 ff        rst     $38
dea6 ff        rst     $38
dea7 ff        rst     $38
dea8 ff        rst     $38
dea9 ff        rst     $38
deaa ff        rst     $38
deab ff        rst     $38
deac ff        rst     $38
dead ff        rst     $38
deae ff        rst     $38
deaf ff        rst     $38
deb0 ff        rst     $38
deb1 ff        rst     $38
deb2 ff        rst     $38
deb3 ff        rst     $38
deb4 ff        rst     $38
deb5 ff        rst     $38
deb6 ff        rst     $38
deb7 ff        rst     $38
deb8 ff        rst     $38
deb9 ff        rst     $38
deba ff        rst     $38
debb ff        rst     $38
debc ff        rst     $38
debd ff        rst     $38
debe ff        rst     $38
debf ff        rst     $38
dec0 ff        rst     $38
dec1 ff        rst     $38
dec2 ff        rst     $38
dec3 ff        rst     $38
dec4 ff        rst     $38
dec5 ff        rst     $38
dec6 ff        rst     $38
dec7 ff        rst     $38
dec8 ff        rst     $38
dec9 ff        rst     $38
deca ff        rst     $38
decb ff        rst     $38
decc ff        rst     $38
decd ff        rst     $38
dece ff        rst     $38
decf ff        rst     $38
ded0 ff        rst     $38
ded1 ff        rst     $38
ded2 ff        rst     $38
ded3 ff        rst     $38
ded4 ff        rst     $38
ded5 ff        rst     $38
ded6 ff        rst     $38
ded7 ff        rst     $38
ded8 ff        rst     $38
ded9 ff        rst     $38
deda ff        rst     $38
dedb ff        rst     $38
dedc ff        rst     $38
dedd ff        rst     $38
dede ff        rst     $38
dedf ff        rst     $38
dee0 ff        rst     $38
dee1 ff        rst     $38
dee2 ff        rst     $38
dee3 ff        rst     $38
dee4 ff        rst     $38
dee5 ff        rst     $38
dee6 ff        rst     $38
dee7 ff        rst     $38
dee8 ff        rst     $38
dee9 ff        rst     $38
deea ff        rst     $38
deeb ff        rst     $38
deec ff        rst     $38
deed ff        rst     $38
deee ff        rst     $38
deef ff        rst     $38
def0 ff        rst     $38
def1 ff        rst     $38
def2 ff        rst     $38
def3 ff        rst     $38
def4 ff        rst     $38
def5 ff        rst     $38
def6 ff        rst     $38
def7 ff        rst     $38
def8 ff        rst     $38
def9 ff        rst     $38
defa ff        rst     $38
defb ff        rst     $38
defc ff        rst     $38
defd ff        rst     $38
defe ff        rst     $38
deff ff        rst     $38
df00 ff        rst     $38
df01 ff        rst     $38
df02 ff        rst     $38
df03 ff        rst     $38
df04 ff        rst     $38
df05 ff        rst     $38
df06 ff        rst     $38
df07 ff        rst     $38
df08 ff        rst     $38
df09 ff        rst     $38
df0a ff        rst     $38
df0b ff        rst     $38
df0c ff        rst     $38
df0d ff        rst     $38
df0e ff        rst     $38
df0f ff        rst     $38
df10 ff        rst     $38
df11 ff        rst     $38
df12 ff        rst     $38
df13 ff        rst     $38
df14 ff        rst     $38
df15 ff        rst     $38
df16 ff        rst     $38
df17 ff        rst     $38
df18 ff        rst     $38
df19 ff        rst     $38
df1a ff        rst     $38
df1b ff        rst     $38
df1c ff        rst     $38
df1d ff        rst     $38
df1e ff        rst     $38
df1f ff        rst     $38
df20 ff        rst     $38
df21 ff        rst     $38
df22 ff        rst     $38
df23 ff        rst     $38
df24 ff        rst     $38
df25 ff        rst     $38
df26 ff        rst     $38
df27 ff        rst     $38
df28 ff        rst     $38
df29 ff        rst     $38
df2a ff        rst     $38
df2b ff        rst     $38
df2c ff        rst     $38
df2d ff        rst     $38
df2e ff        rst     $38
df2f ff        rst     $38
df30 ff        rst     $38
df31 ff        rst     $38
df32 ff        rst     $38
df33 ff        rst     $38
df34 ff        rst     $38
df35 ff        rst     $38
df36 ff        rst     $38
df37 ff        rst     $38
df38 ff        rst     $38
df39 ff        rst     $38
df3a ff        rst     $38
df3b ff        rst     $38
df3c ff        rst     $38
df3d ff        rst     $38
df3e ff        rst     $38
df3f ff        rst     $38
df40 ff        rst     $38
df41 ff        rst     $38
df42 ff        rst     $38
df43 ff        rst     $38
df44 ff        rst     $38
df45 ff        rst     $38
df46 ff        rst     $38
df47 ff        rst     $38
df48 ff        rst     $38
df49 ff        rst     $38
df4a ff        rst     $38
df4b ff        rst     $38
df4c ff        rst     $38
df4d ff        rst     $38
df4e ff        rst     $38
df4f ff        rst     $38
df50 ff        rst     $38
df51 ff        rst     $38
df52 ff        rst     $38
df53 ff        rst     $38
df54 ff        rst     $38
df55 ff        rst     $38
df56 ff        rst     $38
df57 ff        rst     $38
df58 ff        rst     $38
df59 ff        rst     $38
df5a ff        rst     $38
df5b ff        rst     $38
df5c ff        rst     $38
df5d ff        rst     $38
df5e ff        rst     $38
df5f ff        rst     $38
df60 ff        rst     $38
df61 ff        rst     $38
df62 ff        rst     $38
df63 ff        rst     $38
df64 ff        rst     $38
df65 ff        rst     $38
df66 ff        rst     $38
df67 ff        rst     $38
df68 ff        rst     $38
df69 ff        rst     $38
df6a ff        rst     $38
df6b ff        rst     $38
df6c ff        rst     $38
df6d ff        rst     $38
df6e ff        rst     $38
df6f ff        rst     $38
df70 ff        rst     $38
df71 ff        rst     $38
df72 ff        rst     $38
df73 ff        rst     $38
df74 ff        rst     $38
df75 ff        rst     $38
df76 ff        rst     $38
df77 ff        rst     $38
df78 ff        rst     $38
df79 ff        rst     $38
df7a ff        rst     $38
df7b ff        rst     $38
df7c ff        rst     $38
df7d ff        rst     $38
df7e ff        rst     $38
df7f ff        rst     $38
df80 ff        rst     $38
df81 ff        rst     $38
df82 ff        rst     $38
df83 ff        rst     $38
df84 ff        rst     $38
df85 ff        rst     $38
df86 ff        rst     $38
df87 ff        rst     $38
df88 ff        rst     $38
df89 ff        rst     $38
df8a ff        rst     $38
df8b ff        rst     $38
df8c ff        rst     $38
df8d ff        rst     $38
df8e ff        rst     $38
df8f ff        rst     $38
df90 ff        rst     $38
df91 ff        rst     $38
df92 ff        rst     $38
df93 ff        rst     $38
df94 ff        rst     $38
df95 ff        rst     $38
df96 ff        rst     $38
df97 ff        rst     $38
df98 ff        rst     $38
df99 ff        rst     $38
df9a ff        rst     $38
df9b ff        rst     $38
df9c ff        rst     $38
df9d ff        rst     $38
df9e ff        rst     $38
df9f ff        rst     $38
dfa0 ff        rst     $38
dfa1 ff        rst     $38
dfa2 ff        rst     $38
dfa3 ff        rst     $38
dfa4 ff        rst     $38
dfa5 ff        rst     $38
dfa6 ff        rst     $38
dfa7 ff        rst     $38
dfa8 ff        rst     $38
dfa9 ff        rst     $38
dfaa ff        rst     $38
dfab ff        rst     $38
dfac ff        rst     $38
dfad ff        rst     $38
dfae ff        rst     $38
dfaf ff        rst     $38
dfb0 ff        rst     $38
dfb1 ff        rst     $38
dfb2 ff        rst     $38
dfb3 ff        rst     $38
dfb4 ff        rst     $38
dfb5 ff        rst     $38
dfb6 ff        rst     $38
dfb7 ff        rst     $38
dfb8 ff        rst     $38
dfb9 ff        rst     $38
dfba ff        rst     $38
dfbb ff        rst     $38
dfbc ff        rst     $38
dfbd ff        rst     $38
dfbe ff        rst     $38
dfbf ff        rst     $38
dfc0 ff        rst     $38
dfc1 ff        rst     $38
dfc2 ff        rst     $38
dfc3 ff        rst     $38
dfc4 ff        rst     $38
dfc5 ff        rst     $38
dfc6 ff        rst     $38
dfc7 ff        rst     $38
dfc8 ff        rst     $38
dfc9 ff        rst     $38
dfca ff        rst     $38
dfcb ff        rst     $38
dfcc ff        rst     $38
dfcd ff        rst     $38
dfce ff        rst     $38
dfcf ff        rst     $38
dfd0 ff        rst     $38
dfd1 ff        rst     $38
dfd2 ff        rst     $38
dfd3 ff        rst     $38
dfd4 ff        rst     $38
dfd5 ff        rst     $38
dfd6 ff        rst     $38
dfd7 ff        rst     $38
dfd8 ff        rst     $38
dfd9 ff        rst     $38
dfda ff        rst     $38
dfdb ff        rst     $38
dfdc ff        rst     $38
dfdd ff        rst     $38
dfde ff        rst     $38
dfdf ff        rst     $38
dfe0 ff        rst     $38
dfe1 ff        rst     $38
dfe2 ff        rst     $38
dfe3 ff        rst     $38
dfe4 ff        rst     $38
dfe5 ff        rst     $38
dfe6 ff        rst     $38
dfe7 ff        rst     $38
dfe8 ff        rst     $38
dfe9 ff        rst     $38
dfea ff        rst     $38
dfeb ff        rst     $38
dfec ff        rst     $38
dfed ff        rst     $38
dfee ff        rst     $38
dfef ff        rst     $38
dff0 ff        rst     $38
dff1 ff        rst     $38
dff2 ff        rst     $38
dff3 ff        rst     $38
dff4 ff        rst     $38
dff5 ff        rst     $38
dff6 ff        rst     $38
dff7 ff        rst     $38
dff8 ff        rst     $38
dff9 ff        rst     $38
dffa ff        rst     $38
dffb ff        rst     $38
dffc ff        rst     $38
dffd ff        rst     $38
dffe ff        rst     $38
dfff ff        rst     $38

;; 0047 = right column of window
;; 0048 = current cursor state
;; 0049 = current display mode
;; 004d, 4e = y coordinate of one edge of graphics window
e000 c3fbec    jp      $ecfb
e003 c3eaec    jp      $ecea
e006 c326ed    jp      $ed26
e009 c315ed    jp      $ed15
e00c c3a9ef    jp      $efa9
e00f c3bbef    jp      $efbb
e012 c3b5ef    jp      $efb5
e015 c3d3ed    jp      $edd3
e018 c3b0ed    jp      $edb0
e01b c31dee    jp      $ee1d
e01e c366ee    jp      $ee66
e021 c37dee    jp      $ee7d
e024 c345ef    jp      $ef45
e027 c3a2ee    jp      $eea2
e02a c3c6ef    jp      $efc6
e02d c3ceef    jp      $efce
e030 c3d8ef    jp      $efd8
e033 c3d2ef    jp      $efd2
e036 c3f2ef    jp      $eff2
e039 c316f0    jp      $f016
e03c c332f0    jp      $f032
e03f c35cf0    jp      $f05c
e042 c385f0    jp      $f085
e045 c3aef0    jp      $f0ae
e048 c313ef    jp      $ef13
e04b c346ef    jp      $ef46
e04e c376ef    jp      $ef76
e051 c3b0ec    jp      $ecb0
e054 c3b6e1    jp      $e1b6
e057 c3f1e1    jp      $e1f1
e05a c370e2    jp      $e270
e05d c377e2    jp      $e277
e060 c383e2    jp      $e283
e063 c38fe2    jp      $e28f
e066 c398e2    jp      $e298
e069 c39fe2    jp      $e29f
e06c c3aee2    jp      $e2ae
e06f c3b5e2    jp      $e2b5
e072 c3bce2    jp      $e2bc
e075 c3d5e2    jp      $e2d5
e078 c3e4e2    jp      $e2e4
e07b c3ece2    jp      $e2ec
e07e c3fbe2    jp      $e2fb
e081 c30ae3    jp      $e30a
e084 c313e3    jp      $e313
e087 c339e3    jp      $e339
e08a c340e3    jp      $e340
e08d c397e3    jp      $e397
e090 c3b8e3    jp      $e3b8
e093 c3d6e3    jp      $e3d6
e096 c3fde3    jp      $e3fd
e099 c303e4    jp      $e403
e09c c39ae4    jp      $e49a
e09f c3cde4    jp      $e4cd
e0a2 c3d3e4    jp      $e4d3
e0a5 c3d9e4    jp      $e4d9
e0a8 c33ce5    jp      $e53c
e0ab c364e5    jp      $e564
e0ae c372e5    jp      $e572
e0b1 c380e5    jp      $e580
e0b4 c387e5    jp      $e587
e0b7 c38ee5    jp      $e58e
e0ba c3a4e5    jp      $e5a4
e0bd c3bde5    jp      $e5bd
e0c0 c373e7    jp      $e773
e0c3 c38de8    jp      $e88d
e0c6 c345ec    jp      $ec45
e0c9 c39aff    jp      $ff9a
e0cc c3aaff    jp      $ffaa
e0cf c3b2ff    jp      $ffb2
e0d2 c3c6ff    jp      $ffc6
e0d5 c3d0ff    jp      $ffd0
e0d8 c3a1ff    jp      $ffa1
e0db c3b2ff    jp      $ffb2
e0de c3ebff    jp      $ffeb
e0e1 c324fb    jp      $fb24
e0e4 c390ff    jp      $ff90
e0e7 c374fc    jp      $fc74
e0ea c357fc    jp      $fc57
e0ed c3dcfa    jp      $fadc
e0f0 c3ecfa    jp      $faec
e0f3 c30ff3    jp      $f30f
e0f6 c3e4f3    jp      $f3e4
e0f9 c383f5    jp      $f583
e0fc c3b3f5    jp      $f5b3
e0ff c309f2    jp      $f209
e102 c3fbf1    jp      $f1fb
e105 c3f4f1    jp      $f1f4
e108 c395f5    jp      $f595
e10b c3e4f4    jp      $f4e4
e10e c3b5f2    jp      $f2b5
e111 c37bf2    jp      $f27b
e114 c34af2    jp      $f24a
e117 c308f3    jp      $f308
e11a c328f2    jp      $f228
e11d c389f7    jp      $f789
e120 c355fb    jp      $fb55
e123 c3cbf5    jp      $f5cb
e126 c354fb    jp      $fb54
e129 c3bcfb    jp      $fbbc
e12c c3edfa    jp      $faed
e12f c383f7    jp      $f783
e132 c3defb    jp      $fbde
e135 c34efc    jp      $fc4e
e138 c3aaf5    jp      $f5aa
e13b c39ef5    jp      $f59e
e13e c38cf5    jp      $f58c
e141 c330fb    jp      $fb30
e144 c318fc    jp      $fc18
e147 c3bff5    jp      $f5bf
e14a c30afb    jp      $fb0a
e14d c33dfb    jp      $fb3d
e150 c33efb    jp      $fb3e
e153 c308fc    jp      $fc08
e156 c36afb    jp      $fb6a
e159 c344fc    jp      $fc44
e15c c34ffc    jp      $fc4f
e15f c3bdf2    jp      $f2bd
e162 c361ff    jp      $ff61
e165 c374ff    jp      $ff74
e168 c3d4fb    jp      $fbd4
e16b c31dfc    jp      $fc1d
e16e c3e4fa    jp      $fae4
e171 c3e6fb    jp      $fbe6
e174 c345fc    jp      $fc45
e177 c302f2    jp      $f202
e17a c3a6f2    jp      $f2a6
e17d c3eefb    jp      $fbee
e180 c36cfc    jp      $fc6c
e183 c31dfb    jp      $fb1d
e186 c3a4f1    jp      $f1a4
e189 c3b9f1    jp      $f1b9
e18c c387ff    jp      $ff87
e18f c38efc    jp      $fc8e
e192 c38cfc    jp      $fc8c
e195 c3f2f0    jp      $f0f2
e198 c37ff1    jp      $f17f
e19b c32bf1    jp      $f12b
e19e c350f1    jp      $f150
e1a1 c3acfa    jp      $faac
e1a4 c358fa    jp      $fa58
e1a7 c382fa    jp      $fa82
e1aa c394fc    jp      $fc94
e1ad c366f8    jp      $f866
e1b0 c3b0fd    jp      $fdb0
e1b3 c3e2fd    jp      $fde2
e1b6 210000    ld      hl,$0000
e1b9 226404    ld      ($0464),hl
e1bc 226004    ld      ($0460),hl
e1bf 2a9701    ld      hl,($0197)
e1c2 2b        dec     hl
e1c3 226204    ld      ($0462),hl
e1c6 2a9701    ld      hl,($0197)
e1c9 226804    ld      ($0468),hl
e1cc cdd4fb    call    $fbd4
e1cf 226a04    ld      ($046a),hl
e1d2 2a9701    ld      hl,($0197)
e1d5 110100    ld      de,$0001
e1d8 eb        ex      de,hl
e1d9 cdeefb    call    $fbee
e1dc 227004    ld      ($0470),hl
e1df 2a9901    ld      hl,($0199)
e1e2 227804    ld      ($0478),hl
e1e5 2b        dec     hl
e1e6 110100    ld      de,$0001
e1e9 eb        ex      de,hl
e1ea cdeefb    call    $fbee
e1ed 227204    ld      ($0472),hl
e1f0 c9        ret     

e1f1 cd98e2    call    $e298
e1f4 110100    ld      de,$0001
e1f7 cd24fb    call    $fb24
e1fa 2815      jr      z,$e211          ; (+$15)
e1fc 2a9901    ld      hl,($0199)
e1ff eb        ex      de,hl
e200 2a8d01    ld      hl,($018d)
e203 cd0afb    call    $fb0a
e206 e5        push    hl
e207 cdaee2    call    $e2ae
e20a 2b        dec     hl
e20b d1        pop     de
e20c cdbcfb    call    $fbbc
e20f 1803      jr      $e214            ; (+$03)
e211 2a9901    ld      hl,($0199)
e214 227804    ld      ($0478),hl
e217 2a5e04    ld      hl,($045e)
e21a 110100    ld      de,$0001
e21d cd24fb    call    $fb24
e220 280d      jr      z,$e22f          ; (+$0d)
e222 2a8d01    ld      hl,($018d)
e225 e5        push    hl
e226 cdaee2    call    $e2ae
e229 e5        push    hl
e22a cdb0ed    call    $edb0
e22d d1        pop     de
e22e d1        pop     de
e22f cd98e2    call    $e298
e232 110100    ld      de,$0001
e235 cd24fb    call    $fb24
e238 2805      jr      z,$e23f          ; (+$05)
e23a cdaee2    call    $e2ae
e23d 1803      jr      $e242            ; (+$03)
e23f 210000    ld      hl,$0000
e242 e5        push    hl
e243 cd26ed    call    $ed26
e246 d1        pop     de
e247 2a7804    ld      hl,($0478)
e24a 2b        dec     hl
e24b 226604    ld      ($0466),hl
e24e 2a7804    ld      hl,($0478)
e251 226c04    ld      ($046c),hl
e254 cdd4fb    call    $fbd4
e257 226e04    ld      ($046e),hl
e25a cdffeb    call    $ebff
e25d 2803      jr      z,$e262          ; (+$03)
e25f cdc4e5    call    $e5c4
e262 2a5e04    ld      hl,($045e)
e265 110200    ld      de,$0002
e268 cd24fb    call    $fb24
e26b c8        ret     z

e26c cd03e4    call    $e403
e26f c9        ret     

e270 2a5c04    ld      hl,($045c)
e273 225e04    ld      ($045e),hl
e276 c9        ret     

e277 cd70e2    call    $e270
e27a 210000    ld      hl,$0000
e27d 225c04    ld      ($045c),hl
e280 c3f1e1    jp      $e1f1
e283 cd70e2    call    $e270
e286 210100    ld      hl,$0001
e289 225c04    ld      ($045c),hl
e28c c3f1e1    jp      $e1f1
e28f 210200    ld      hl,$0002
e292 225c04    ld      ($045c),hl
e295 c315ed    jp      $ed15
e298 cd90ff    call    $ff90
e29b 2a5c04    ld      hl,($045c)
e29e c9        ret     

e29f cd90ff    call    $ff90
e2a2 210800    ld      hl,$0008
e2a5 39        add     hl,sp
e2a6 5e        ld      e,(hl)
e2a7 23        inc     hl
e2a8 56        ld      d,(hl)
e2a9 eb        ex      de,hl
e2aa 225a04    ld      ($045a),hl
e2ad c9        ret     

e2ae cd90ff    call    $ff90
e2b1 2a5a04    ld      hl,($045a)
e2b4 c9        ret     

e2b5 cd90ff    call    $ff90
e2b8 2a5804    ld      hl,($0458)
e2bb c9        ret     

e2bc cd90ff    call    $ff90
e2bf cd73e7    call    $e773
e2c2 210800    ld      hl,$0008
e2c5 39        add     hl,sp
e2c6 5e        ld      e,(hl)
e2c7 23        inc     hl
e2c8 56        ld      d,(hl)
e2c9 eb        ex      de,hl
e2ca 225804    ld      ($0458),hl
e2cd e5        push    hl
e2ce cd45ef    call    $ef45
e2d1 d1        pop     de
e2d2 c373e7    jp      $e773
e2d5 210100    ld      hl,$0001
e2d8 7d        ld      a,l
e2d9 325504    ld      ($0455),a
e2dc cd39e3    call    $e339
e2df 7d        ld      a,l
e2e0 325404    ld      ($0454),a
e2e3 c9        ret     

e2e4 210000    ld      hl,$0000
e2e7 7d        ld      a,l
e2e8 325504    ld      ($0455),a
e2eb c9        ret     

e2ec 210300    ld      hl,$0003
e2ef 7d        ld      a,l
e2f0 325504    ld      ($0455),a
e2f3 cdb5e2    call    $e2b5
e2f6 7d        ld      a,l
e2f7 325404    ld      ($0454),a
e2fa c9        ret     

e2fb 210200    ld      hl,$0002
e2fe 7d        ld      a,l
e2ff 325504    ld      ($0455),a
e302 cd39e3    call    $e339
e305 7d        ld      a,l
e306 325404    ld      ($0454),a
e309 c9        ret     

e30a cd90ff    call    $ff90
e30d 2a5504    ld      hl,($0455)
e310 2600      ld      h,$00
e312 c9        ret     

e313 cd90ff    call    $ff90
e316 cd73e7    call    $e773
e319 210800    ld      hl,$0008
e31c 39        add     hl,sp
e31d 5e        ld      e,(hl)
e31e 23        inc     hl
e31f 56        ld      d,(hl)
e320 eb        ex      de,hl
e321 225604    ld      ($0456),hl
e324 cd73e7    call    $e773
e327 cd0ae3    call    $e30a
e32a 110300    ld      de,$0003
e32d cd24fb    call    $fb24
e330 c0        ret     nz

e331 2a5604    ld      hl,($0456)
e334 7d        ld      a,l
e335 325404    ld      ($0454),a
e338 c9        ret     

e339 cd90ff    call    $ff90
e33c 2a5604    ld      hl,($0456)
e33f c9        ret     

e340 cd90ff    call    $ff90
e343 21f301    ld      hl,$01f3
e346 cd09f2    call    $f209
e349 cd4af2    call    $f24a
e34c cdb0fd    call    $fdb0
e34f cd87ff    call    $ff87
e352 210800    ld      hl,$0008
e355 39        add     hl,sp
e356 cdfbf1    call    $f1fb
e359 cde4f4    call    $f4e4
e35c 21e701    ld      hl,$01e7
e35f cdfbf1    call    $f1fb
e362 cd0ff3    call    $f30f
e365 cd4af2    call    $f24a
e368 21f301    ld      hl,$01f3
e36b cd09f2    call    $f209
e36e cd4af2    call    $f24a
e371 cde2fd    call    $fde2
e374 cd87ff    call    $ff87
e377 211000    ld      hl,$0010
e37a 39        add     hl,sp
e37b cdfbf1    call    $f1fb
e37e cde4f4    call    $f4e4
e381 21df01    ld      hl,$01df
e384 cdfbf1    call    $f1fb
e387 cd0ff3    call    $f30f
e38a cd4af2    call    $f24a
e38d cd8de8    call    $e88d
e390 eb        ex      de,hl
e391 211000    ld      hl,$0010
e394 39        add     hl,sp
e395 f9        ld      sp,hl
e396 c9        ret     

e397 cd90ff    call    $ff90
e39a 211000    ld      hl,$0010
e39d 39        add     hl,sp
e39e cd09f2    call    $f209
e3a1 cd4af2    call    $f24a
e3a4 211000    ld      hl,$0010
e3a7 39        add     hl,sp
e3a8 cd09f2    call    $f209
e3ab cd4af2    call    $f24a
e3ae cd8de8    call    $e88d
e3b1 eb        ex      de,hl
e3b2 211000    ld      hl,$0010
e3b5 39        add     hl,sp
e3b6 f9        ld      sp,hl
e3b7 c9        ret     

e3b8 cd90ff    call    $ff90
e3bb 21f301    ld      hl,$01f3
e3be cd09f2    call    $f209
e3c1 210800    ld      hl,$0008
e3c4 39        add     hl,sp
e3c5 cdfbf1    call    $f1fb
e3c8 cd0ff3    call    $f30f
e3cb cd4af2    call    $f24a
e3ce cdd6e3    call    $e3d6
e3d1 eb        ex      de,hl
e3d2 cd87ff    call    $ff87
e3d5 c9        ret     

e3d6 cd90ff    call    $ff90
e3d9 cd73e7    call    $e773
e3dc 21f301    ld      hl,$01f3
e3df e5        push    hl
e3e0 210a00    ld      hl,$000a
e3e3 39        add     hl,sp
e3e4 cd09f2    call    $f209
e3e7 cd4af2    call    $f24a
e3ea cd45ec    call    $ec45
e3ed cd87ff    call    $ff87
e3f0 e1        pop     hl
e3f1 cd28f2    call    $f228
e3f4 cd89f7    call    $f789
e3f7 22fb01    ld      ($01fb),hl
e3fa c373e7    jp      $e773
e3fd 21f301    ld      hl,$01f3
e400 c309f2    jp      $f209
e403 2a6604    ld      hl,($0466)
e406 e5        push    hl
e407 2a5804    ld      hl,($0458)
e40a e5        push    hl
e40b cda2ee    call    $eea2
e40e d1        pop     de
e40f d1        pop     de
e410 c373e7    jp      $e773
e413 cd90ff    call    $ff90
e416 211000    ld      hl,$0010
e419 39        add     hl,sp
e41a cd09f2    call    $f209
e41d cd4af2    call    $f24a
e420 cd02e7    call    $e702
e423 cd87ff    call    $ff87
e426 cd4af2    call    $f24a
e429 211000    ld      hl,$0010
e42c 39        add     hl,sp
e42d cd09f2    call    $f209
e430 cd4af2    call    $f24a
e433 cd02e7    call    $e702
e436 cd87ff    call    $ff87
e439 cd4af2    call    $f24a
e43c cdd9e4    call    $e4d9
e43f eb        ex      de,hl
e440 211000    ld      hl,$0010
e443 39        add     hl,sp
e444 f9        ld      sp,hl
e445 2a7604    ld      hl,($0476)
e448 e5        push    hl
e449 2a7404    ld      hl,($0474)
e44c e5        push    hl
e44d cd1cec    call    $ec1c
e450 d1        pop     de
e451 d1        pop     de
e452 cdffeb    call    $ebff
e455 2842      jr      z,$e499          ; (+$42)
e457 2a9701    ld      hl,($0197)
e45a ed5b7404  ld      de,($0474)
e45e cd6afb    call    $fb6a
e461 227404    ld      ($0474),hl
e464 110000    ld      de,$0000
e467 eb        ex      de,hl
e468 cd54fb    call    $fb54
e46b 280b      jr      z,$e478          ; (+$0b)
e46d 2a9701    ld      hl,($0197)
e470 eb        ex      de,hl
e471 2a7404    ld      hl,($0474)
e474 19        add     hl,de
e475 227404    ld      ($0474),hl
e478 2a7804    ld      hl,($0478)
e47b ed5b7604  ld      de,($0476)
e47f cd6afb    call    $fb6a
e482 227604    ld      ($0476),hl
e485 110000    ld      de,$0000
e488 eb        ex      de,hl
e489 cd54fb    call    $fb54
e48c 280b      jr      z,$e499          ; (+$0b)
e48e 2a7804    ld      hl,($0478)
e491 eb        ex      de,hl
e492 2a7604    ld      hl,($0476)
e495 19        add     hl,de
e496 227604    ld      ($0476),hl
e499 c9        ret     

e49a cd90ff    call    $ff90
e49d 211000    ld      hl,$0010
e4a0 39        add     hl,sp
e4a1 cd09f2    call    $f209
e4a4 cd4af2    call    $f24a
e4a7 211000    ld      hl,$0010
e4aa 39        add     hl,sp
e4ab cd09f2    call    $f209
e4ae cd4af2    call    $f24a
e4b1 cd13e4    call    $e413
e4b4 eb        ex      de,hl
e4b5 211000    ld      hl,$0010
e4b8 39        add     hl,sp
e4b9 f9        ld      sp,hl
e4ba 2a5404    ld      hl,($0454)
e4bd e5        push    hl
e4be 2a7604    ld      hl,($0476)
e4c1 e5        push    hl
e4c2 2a7404    ld      hl,($0474)
e4c5 e5        push    hl
e4c6 cddaec    call    $ecda
e4c9 d1        pop     de
e4ca d1        pop     de
e4cb d1        pop     de
e4cc c9        ret     

e4cd 21df01    ld      hl,$01df
e4d0 c309f2    jp      $f209
e4d3 21e701    ld      hl,$01e7
e4d6 c309f2    jp      $f209
e4d9 cdedfa    call    $faed
e4dc f0        ret     p

e4dd ff        rst     $38
e4de 211800    ld      hl,$0018
e4e1 39        add     hl,sp
e4e2 e5        push    hl
e4e3 2a7004    ld      hl,($0470)
e4e6 cdcbf5    call    $f5cb
e4e9 cda6f2    call    $f2a6
e4ec e1        pop     hl
e4ed e5        push    hl
e4ee cd09f2    call    $f209
e4f1 cd0ff3    call    $f30f
e4f4 e1        pop     hl
e4f5 cd28f2    call    $f228
e4f8 212000    ld      hl,$0020
e4fb 39        add     hl,sp
e4fc e5        push    hl
e4fd 2a7204    ld      hl,($0472)
e500 cdcbf5    call    $f5cb
e503 212200    ld      hl,$0022
e506 39        add     hl,sp
e507 cdfbf1    call    $f1fb
e50a cd08f3    call    $f308
e50d e1        pop     hl
e50e cd28f2    call    $f228
e511 211800    ld      hl,$0018
e514 39        add     hl,sp
e515 cd09f2    call    $f209
e518 cd4af2    call    $f24a
e51b cdc8e6    call    $e6c8
e51e eb        ex      de,hl
e51f cd87ff    call    $ff87
e522 eb        ex      de,hl
e523 227404    ld      ($0474),hl
e526 212000    ld      hl,$0020
e529 39        add     hl,sp
e52a cd09f2    call    $f209
e52d cd4af2    call    $f24a
e530 cdc8e6    call    $e6c8
e533 eb        ex      de,hl
e534 cd87ff    call    $ff87
e537 eb        ex      de,hl
e538 227604    ld      ($0476),hl
e53b c9        ret     

e53c 21e701    ld      hl,$01e7
e53f cd09f2    call    $f209
e542 cd4af2    call    $f24a
e545 21df01    ld      hl,$01df
e548 cd09f2    call    $f209
e54b cd4af2    call    $f24a
e54e cdd9e4    call    $e4d9
e551 eb        ex      de,hl
e552 211000    ld      hl,$0010
e555 39        add     hl,sp
e556 f9        ld      sp,hl
e557 2a7404    ld      hl,($0474)
e55a 22ef01    ld      ($01ef),hl
e55d 2a7604    ld      hl,($0476)
e560 22f101    ld      ($01f1),hl
e563 c9        ret     

e564 cd80e5    call    $e580
e567 c8        ret     z

e568 cd73e7    call    $e773
e56b 210000    ld      hl,$0000
e56e 22fd01    ld      ($01fd),hl
e571 c9        ret     

e572 cd80e5    call    $e580
e575 c0        ret     nz

e576 210100    ld      hl,$0001
e579 22fd01    ld      ($01fd),hl
e57c cd73e7    call    $e773
e57f c9        ret     

e580 cd90ff    call    $ff90
e583 2afd01    ld      hl,($01fd)
e586 c9        ret     

e587 210000    ld      hl,$0000
e58a 22ff01    ld      ($01ff),hl
e58d c9        ret     

e58e cd73e7    call    $e773
e591 210100    ld      hl,$0001
e594 22ff01    ld      ($01ff),hl
e597 2a7804    ld      hl,($0478)
e59a 7c        ld      a,h
e59b b5        or      l
e59c 2803      jr      z,$e5a1          ; (+$03)
e59e cdc4e5    call    $e5c4
e5a1 c373e7    jp      $e773
e5a4 2af101    ld      hl,($01f1)
e5a7 e5        push    hl
e5a8 2aef01    ld      hl,($01ef)
e5ab e5        push    hl
e5ac cdb0ec    call    $ecb0
e5af d1        pop     de
e5b0 d1        pop     de
e5b1 2803      jr      z,$e5b6          ; (+$03)
e5b3 cd5104    call    $0451
e5b6 210200    ld      hl,$0002
e5b9 22ff01    ld      ($01ff),hl
e5bc c9        ret     

e5bd cd90ff    call    $ff90
e5c0 2aff01    ld      hl,($01ff)
e5c3 c9        ret     

e5c4 1803      jr      $e5c9            ; (+$03)
e5c6 cd3ce5    call    $e53c
e5c9 2aef01    ld      hl,($01ef)
e5cc 110000    ld      de,$0000
e5cf eb        ex      de,hl
e5d0 cd54fb    call    $fb54
e5d3 2830      jr      z,$e605          ; (+$30)
e5d5 21e701    ld      hl,$01e7
e5d8 cd09f2    call    $f209
e5db cd4af2    call    $f24a
e5de 21df01    ld      hl,$01df
e5e1 e5        push    hl
e5e2 2a9701    ld      hl,($0197)
e5e5 cdcbf5    call    $f5cb
e5e8 cda6f2    call    $f2a6
e5eb e1        pop     hl
e5ec e5        push    hl
e5ed cd09f2    call    $f209
e5f0 cd0ff3    call    $f30f
e5f3 e1        pop     hl
e5f4 cd28f2    call    $f228
e5f7 cd4af2    call    $f24a
e5fa cdd9e4    call    $e4d9
e5fd eb        ex      de,hl
e5fe 211000    ld      hl,$0010
e601 39        add     hl,sp
e602 f9        ld      sp,hl
e603 18c1      jr      $e5c6            ; (-$3f)
e605 1803      jr      $e60a            ; (+$03)
e607 cd3ce5    call    $e53c
e60a 2aef01    ld      hl,($01ef)
e60d eb        ex      de,hl
e60e 2a9701    ld      hl,($0197)
e611 cd3dfb    call    $fb3d
e614 2830      jr      z,$e646          ; (+$30)
e616 21e701    ld      hl,$01e7
e619 cd09f2    call    $f209
e61c cd4af2    call    $f24a
e61f 21df01    ld      hl,$01df
e622 e5        push    hl
e623 2a9701    ld      hl,($0197)
e626 cdcbf5    call    $f5cb
e629 cda6f2    call    $f2a6
e62c e1        pop     hl
e62d e5        push    hl
e62e cd09f2    call    $f209
e631 cd08f3    call    $f308
e634 e1        pop     hl
e635 cd28f2    call    $f228
e638 cd4af2    call    $f24a
e63b cdd9e4    call    $e4d9
e63e eb        ex      de,hl
e63f 211000    ld      hl,$0010
e642 39        add     hl,sp
e643 f9        ld      sp,hl
e644 18c1      jr      $e607            ; (-$3f)
e646 1803      jr      $e64b            ; (+$03)
e648 cd3ce5    call    $e53c
e64b 2af101    ld      hl,($01f1)
e64e 110000    ld      de,$0000
e651 eb        ex      de,hl
e652 cd54fb    call    $fb54
e655 2830      jr      z,$e687          ; (+$30)
e657 21e701    ld      hl,$01e7
e65a e5        push    hl
e65b 2a7804    ld      hl,($0478)
e65e cdcbf5    call    $f5cb
e661 cda6f2    call    $f2a6
e664 e1        pop     hl
e665 e5        push    hl
e666 cd09f2    call    $f209
e669 cd08f3    call    $f308
e66c e1        pop     hl
e66d cd28f2    call    $f228
e670 cd4af2    call    $f24a
e673 21df01    ld      hl,$01df
e676 cd09f2    call    $f209
e679 cd4af2    call    $f24a
e67c cdd9e4    call    $e4d9
e67f eb        ex      de,hl
e680 211000    ld      hl,$0010
e683 39        add     hl,sp
e684 f9        ld      sp,hl
e685 18c1      jr      $e648            ; (-$3f)
e687 1803      jr      $e68c            ; (+$03)
e689 cd3ce5    call    $e53c
e68c 2af101    ld      hl,($01f1)
e68f eb        ex      de,hl
e690 2a7804    ld      hl,($0478)
e693 cd3dfb    call    $fb3d
e696 c8        ret     z

e697 21e701    ld      hl,$01e7
e69a e5        push    hl
e69b 2a7804    ld      hl,($0478)
e69e cdcbf5    call    $f5cb
e6a1 cda6f2    call    $f2a6
e6a4 e1        pop     hl
e6a5 e5        push    hl
e6a6 cd09f2    call    $f209
e6a9 cd0ff3    call    $f30f
e6ac e1        pop     hl
e6ad cd28f2    call    $f228
e6b0 cd4af2    call    $f24a
e6b3 21df01    ld      hl,$01df
e6b6 cd09f2    call    $f209
e6b9 cd4af2    call    $f24a
e6bc cdd9e4    call    $e4d9
e6bf eb        ex      de,hl
e6c0 211000    ld      hl,$0010
e6c3 39        add     hl,sp
e6c4 f9        ld      sp,hl
e6c5 18c2      jr      $e689            ; (-$3e)
e6c7 c9        ret     

e6c8 cd90ff    call    $ff90
e6cb 210800    ld      hl,$0008
e6ce 39        add     hl,sp
e6cf cd09f2    call    $f209
e6d2 21cf01    ld      hl,$01cf
e6d5 cdfbf1    call    $f1fb
e6d8 cdaaf5    call    $f5aa
e6db 280d      jr      z,$e6ea          ; (+$0d)
e6dd cd02f2    call    $f202
e6e0 40        ld      b,b
e6e1 80        add     a,b
e6e2 00        nop     
e6e3 00        nop     
e6e4 00        nop     
e6e5 00        nop     
e6e6 00        nop     
e6e7 00        nop     
e6e8 180b      jr      $e6f5            ; (+$0b)
e6ea cd02f2    call    $f202
e6ed c0        ret     nz

e6ee 7f        ld      a,a
e6ef ff        rst     $38
e6f0 ff        rst     $38
e6f1 ff        rst     $38
e6f2 ff        rst     $38
e6f3 ff        rst     $38
e6f4 b8        cp      b
e6f5 210800    ld      hl,$0008
e6f8 39        add     hl,sp
e6f9 cdfbf1    call    $f1fb
e6fc cd0ff3    call    $f30f
e6ff c389f7    jp      $f789
e702 cd90ff    call    $ff90
e705 210800    ld      hl,$0008
e708 39        add     hl,sp
e709 cd09f2    call    $f209
e70c cdf4f1    call    $f1f4
e70f c23e80    jp      nz,$803e
e712 00        nop     
e713 00        nop     
e714 00        nop     
e715 00        nop     
e716 00        nop     
e717 cdaaf5    call    $f5aa
e71a 281e      jr      z,$e73a          ; (+$1e)
e71c 210800    ld      hl,$0008
e71f 39        add     hl,sp
e720 cd09f2    call    $f209
e723 cdf4f1    call    $f1f4
e726 42        ld      b,d
e727 3e80      ld      a,$80
e729 00        nop     
e72a 00        nop     
e72b 00        nop     
e72c 00        nop     
e72d 00        nop     
e72e cd9ef5    call    $f59e
e731 2807      jr      z,$e73a          ; (+$07)
e733 210800    ld      hl,$0008
e736 39        add     hl,sp
e737 c309f2    jp      $f209
e73a c35104    jp      $0451
e73d cd90ff    call    $ff90
e740 210800    ld      hl,$0008
e743 39        add     hl,sp
e744 4e        ld      c,(hl)
e745 23        inc     hl
e746 46        ld      b,(hl)
e747 60        ld      h,b
e748 69        ld      l,c
e749 118000    ld      de,$0080
e74c cddcfa    call    $fadc
e74f 280a      jr      z,$e75b          ; (+$0a)
e751 2100ff    ld      hl,$ff00
e754 50        ld      d,b
e755 59        ld      e,c
e756 cde6fb    call    $fbe6
e759 44        ld      b,h
e75a 4d        ld      c,l
e75b 210a00    ld      hl,$000a
e75e 39        add     hl,sp
e75f 5e        ld      e,(hl)
e760 23        inc     hl
e761 56        ld      d,(hl)
e762 210200    ld      hl,$0002
e765 cddcfa    call    $fadc
e768 2806      jr      z,$e770          ; (+$06)
e76a 60        ld      h,b
e76b 69        ld      l,c
e76c cdd4fb    call    $fbd4
e76f c9        ret     

e770 60        ld      h,b
e771 69        ld      l,c
e772 c9        ret     

e773 cd90ff    call    $ff90
e776 cd80e5    call    $e580
e779 c8        ret     z

e77a cd39e3    call    $e339
e77d 7d        ld      a,l
e77e 320102    ld      ($0201),a
e781 2afb01    ld      hl,($01fb)
e784 23        inc     hl
e785 23        inc     hl
e786 23        inc     hl
e787 110600    ld      de,$0006
e78a eb        ex      de,hl
e78b cd0afb    call    $fb0a
e78e 110f00    ld      de,$000f
e791 eb        ex      de,hl
e792 cd6afb    call    $fb6a
e795 229c04    ld      ($049c),hl
e798 2afb01    ld      hl,($01fb)
e79b 23        inc     hl
e79c 23        inc     hl
e79d 23        inc     hl
e79e 115a00    ld      de,$005a
e7a1 eb        ex      de,hl
e7a2 cd0afb    call    $fb0a
e7a5 229a04    ld      ($049a),hl
e7a8 110100    ld      de,$0001
e7ab cddcfa    call    $fadc
e7ae 280c      jr      z,$e7bc          ; (+$0c)
e7b0 2a9c04    ld      hl,($049c)
e7b3 110f00    ld      de,$000f
e7b6 cd6cfc    call    $fc6c
e7b9 229c04    ld      ($049c),hl
e7bc 2a9c04    ld      hl,($049c)
e7bf 110600    ld      de,$0006
e7c2 cdbcfb    call    $fbbc
e7c5 112801    ld      de,$0128
e7c8 19        add     hl,de
e7c9 229804    ld      ($0498),hl
e7cc 2aef01    ld      hl,($01ef)
e7cf 228804    ld      ($0488),hl
e7d2 2af101    ld      hl,($01f1)
e7d5 228a04    ld      ($048a),hl
e7d8 218c04    ld      hl,$048c
e7db 44        ld      b,h
e7dc 4d        ld      c,l
e7dd 1808      jr      $e7e7            ; (+$08)
e7df 210400    ld      hl,$0004
e7e2 50        ld      d,b
e7e3 59        ld      e,c
e7e4 19        add     hl,de
e7e5 44        ld      b,h
e7e6 4d        ld      c,l
e7e7 50        ld      d,b
e7e8 59        ld      e,c
e7e9 219804    ld      hl,$0498
e7ec cd4efc    call    $fc4e
e7ef 287b      jr      z,$e86c          ; (+$7b)
e7f1 21fcff    ld      hl,$fffc
e7f4 09        add     hl,bc
e7f5 5e        ld      e,(hl)
e7f6 23        inc     hl
e7f7 56        ld      d,(hl)
e7f8 eb        ex      de,hl
e7f9 227a04    ld      ($047a),hl
e7fc 21feff    ld      hl,$fffe
e7ff 09        add     hl,bc
e800 5e        ld      e,(hl)
e801 23        inc     hl
e802 56        ld      d,(hl)
e803 eb        ex      de,hl
e804 227c04    ld      ($047c),hl
e807 2a9a04    ld      hl,($049a)
e80a e5        push    hl
e80b 2a9804    ld      hl,($0498)
e80e 23        inc     hl
e80f 229804    ld      ($0498),hl
e812 5e        ld      e,(hl)
e813 1600      ld      d,$00
e815 d5        push    de
e816 cd3de7    call    $e73d
e819 d1        pop     de
e81a d1        pop     de
e81b eb        ex      de,hl
e81c 2a8804    ld      hl,($0488)
e81f 19        add     hl,de
e820 eb        ex      de,hl
e821 60        ld      h,b
e822 69        ld      l,c
e823 73        ld      (hl),e
e824 23        inc     hl
e825 72        ld      (hl),d
e826 eb        ex      de,hl
e827 227e04    ld      ($047e),hl
e82a 2a9a04    ld      hl,($049a)
e82d 23        inc     hl
e82e e5        push    hl
e82f 2a9804    ld      hl,($0498)
e832 23        inc     hl
e833 229804    ld      ($0498),hl
e836 5e        ld      e,(hl)
e837 1600      ld      d,$00
e839 d5        push    de
e83a cd3de7    call    $e73d
e83d d1        pop     de
e83e d1        pop     de
e83f eb        ex      de,hl
e840 2a8a04    ld      hl,($048a)
e843 19        add     hl,de
e844 eb        ex      de,hl
e845 210200    ld      hl,$0002
e848 09        add     hl,bc
e849 73        ld      (hl),e
e84a 23        inc     hl
e84b 72        ld      (hl),d
e84c eb        ex      de,hl
e84d 228004    ld      ($0480),hl
e850 2a0102    ld      hl,($0201)
e853 e5        push    hl
e854 2a8004    ld      hl,($0480)
e857 e5        push    hl
e858 2a7e04    ld      hl,($047e)
e85b e5        push    hl
e85c cddaec    call    $ecda
e85f d1        pop     de
e860 d1        pop     de
e861 2a0102    ld      hl,($0201)
e864 e3        ex      (sp),hl
e865 cdb0e9    call    $e9b0
e868 d1        pop     de
e869 c3dfe7    jp      $e7df
e86c 2a9404    ld      hl,($0494)
e86f 227a04    ld      ($047a),hl
e872 2a9604    ld      hl,($0496)
e875 227c04    ld      ($047c),hl
e878 2a8804    ld      hl,($0488)
e87b 227e04    ld      ($047e),hl
e87e 2a8a04    ld      hl,($048a)
e881 228004    ld      ($0480),hl
e884 2a0102    ld      hl,($0201)
e887 e5        push    hl
e888 cdb0e9    call    $e9b0
e88b d1        pop     de
e88c c9        ret     

e88d cd90ff    call    $ff90
e890 211000    ld      hl,$0010
e893 39        add     hl,sp
e894 cd09f2    call    $f209
e897 cd4af2    call    $f24a
e89a cd02e7    call    $e702
e89d cd87ff    call    $ff87
e8a0 cd4af2    call    $f24a
e8a3 211000    ld      hl,$0010
e8a6 39        add     hl,sp
e8a7 cd09f2    call    $f209
e8aa cd4af2    call    $f24a
e8ad cd02e7    call    $e702
e8b0 cd87ff    call    $ff87
e8b3 cd4af2    call    $f24a
e8b6 cdd9e4    call    $e4d9
e8b9 eb        ex      de,hl
e8ba 211000    ld      hl,$0010
e8bd 39        add     hl,sp
e8be f9        ld      sp,hl
e8bf 2a7604    ld      hl,($0476)
e8c2 e5        push    hl
e8c3 2a7404    ld      hl,($0474)
e8c6 e5        push    hl
e8c7 cd1cec    call    $ec1c
e8ca d1        pop     de
e8cb d1        pop     de
e8cc cd73e7    call    $e773
e8cf 2aef01    ld      hl,($01ef)
e8d2 227a04    ld      ($047a),hl
e8d5 2af101    ld      hl,($01f1)
e8d8 227c04    ld      ($047c),hl
e8db 2a7404    ld      hl,($0474)
e8de 22ef01    ld      ($01ef),hl
e8e1 227e04    ld      ($047e),hl
e8e4 2a7604    ld      hl,($0476)
e8e7 22f101    ld      ($01f1),hl
e8ea 228004    ld      ($0480),hl
e8ed 21df01    ld      hl,$01df
e8f0 e5        push    hl
e8f1 210a00    ld      hl,$000a
e8f4 39        add     hl,sp
e8f5 cd09f2    call    $f209
e8f8 e1        pop     hl
e8f9 cd28f2    call    $f228
e8fc 21e701    ld      hl,$01e7
e8ff e5        push    hl
e900 211200    ld      hl,$0012
e903 39        add     hl,sp
e904 cd09f2    call    $f209
e907 e1        pop     hl
e908 cd28f2    call    $f228
e90b cdffeb    call    $ebff
e90e caa0e9    jp      z,$e9a0
e911 cd0ae3    call    $e30a
e914 ca9be9    jp      z,$e99b
e917 2a5404    ld      hl,($0454)
e91a e5        push    hl
e91b cdb0e9    call    $e9b0
e91e d1        pop     de
e91f 229e04    ld      ($049e),hl
e922 110100    ld      de,$0001
e925 eb        ex      de,hl
e926 cdeefb    call    $fbee
e929 44        ld      b,h
e92a 4d        ld      c,l
e92b 2a7604    ld      hl,($0476)
e92e e5        push    hl
e92f 2a7404    ld      hl,($0474)
e932 e5        push    hl
e933 cdb0ec    call    $ecb0
e936 d1        pop     de
e937 d1        pop     de
e938 2861      jr      z,$e99b          ; (+$61)
e93a 2a7e04    ld      hl,($047e)
e93d 227a04    ld      ($047a),hl
e940 2a8004    ld      hl,($0480)
e943 227c04    ld      ($047c),hl
e946 2a9e04    ld      hl,($049e)
e949 29        add     hl,hl
e94a 116804    ld      de,$0468
e94d 19        add     hl,de
e94e 5e        ld      e,(hl)
e94f 23        inc     hl
e950 56        ld      d,(hl)
e951 d5        push    de
e952 217a04    ld      hl,$047a
e955 09        add     hl,bc
e956 09        add     hl,bc
e957 d1        pop     de
e958 e5        push    hl
e959 7e        ld      a,(hl)
e95a 23        inc     hl
e95b 66        ld      h,(hl)
e95c 6f        ld      l,a
e95d 19        add     hl,de
e95e eb        ex      de,hl
e95f e1        pop     hl
e960 73        ld      (hl),e
e961 23        inc     hl
e962 72        ld      (hl),d
e963 2a7404    ld      hl,($0474)
e966 227e04    ld      ($047e),hl
e969 2a7604    ld      hl,($0476)
e96c 228004    ld      ($0480),hl
e96f 2a9e04    ld      hl,($049e)
e972 29        add     hl,hl
e973 116804    ld      de,$0468
e976 19        add     hl,de
e977 5e        ld      e,(hl)
e978 23        inc     hl
e979 56        ld      d,(hl)
e97a d5        push    de
e97b 217e04    ld      hl,$047e
e97e 09        add     hl,bc
e97f 09        add     hl,bc
e980 d1        pop     de
e981 e5        push    hl
e982 7e        ld      a,(hl)
e983 23        inc     hl
e984 66        ld      h,(hl)
e985 6f        ld      l,a
e986 19        add     hl,de
e987 eb        ex      de,hl
e988 e1        pop     hl
e989 73        ld      (hl),e
e98a 23        inc     hl
e98b 72        ld      (hl),d
e98c 2a7e04    ld      hl,($047e)
e98f 227404    ld      ($0474),hl
e992 2a8004    ld      hl,($0480)
e995 227604    ld      ($0476),hl
e998 c317e9    jp      $e917
e99b cdc4e5    call    $e5c4
e99e 180d      jr      $e9ad            ; (+$0d)
e9a0 cd0ae3    call    $e30a
e9a3 2808      jr      z,$e9ad          ; (+$08)
e9a5 2a5404    ld      hl,($0454)
e9a8 e5        push    hl
e9a9 cdb0e9    call    $e9b0
e9ac d1        pop     de
e9ad c373e7    jp      $e773
e9b0 cd90ff    call    $ff90
e9b3 21ffff    ld      hl,$ffff
e9b6 228604    ld      ($0486),hl
e9b9 228404    ld      ($0484),hl
e9bc 22a204    ld      ($04a2),hl
e9bf 210000    ld      hl,$0000
e9c2 228204    ld      ($0482),hl
e9c5 21ffff    ld      hl,$ffff
e9c8 22a004    ld      ($04a0),hl
e9cb 2aa004    ld      hl,($04a0)
e9ce 23        inc     hl
e9cf 22a004    ld      ($04a0),hl
e9d2 110200    ld      de,$0002
e9d5 eb        ex      de,hl
e9d6 cd54fb    call    $fb54
e9d9 ca57ea    jp      z,$ea57
e9dc 21ffff    ld      hl,$ffff
e9df 44        ld      b,h
e9e0 4d        ld      c,l
e9e1 03        inc     bc
e9e2 60        ld      h,b
e9e3 69        ld      l,c
e9e4 110200    ld      de,$0002
e9e7 eb        ex      de,hl
e9e8 cd54fb    call    $fb54
e9eb 2867      jr      z,$ea54          ; (+$67)
e9ed 60        ld      h,b
e9ee 69        ld      l,c
e9ef 29        add     hl,hl
e9f0 29        add     hl,hl
e9f1 116004    ld      de,$0460
e9f4 19        add     hl,de
e9f5 5e        ld      e,(hl)
e9f6 23        inc     hl
e9f7 56        ld      d,(hl)
e9f8 d5        push    de
e9f9 60        ld      h,b
e9fa 69        ld      l,c
e9fb 29        add     hl,hl
e9fc e5        push    hl
e9fd 2aa004    ld      hl,($04a0)
ea00 29        add     hl,hl
ea01 29        add     hl,hl
ea02 d1        pop     de
ea03 19        add     hl,de
ea04 117a04    ld      de,$047a
ea07 19        add     hl,de
ea08 5e        ld      e,(hl)
ea09 23        inc     hl
ea0a 56        ld      d,(hl)
ea0b eb        ex      de,hl
ea0c 22a404    ld      ($04a4),hl
ea0f d1        pop     de
ea10 eb        ex      de,hl
ea11 cd54fb    call    $fb54
ea14 2814      jr      z,$ea2a          ; (+$14)
ea16 210000    ld      hl,$0000
ea19 e5        push    hl
ea1a c5        push    bc
ea1b 2aa004    ld      hl,($04a0)
ea1e e5        push    hl
ea1f cda1ea    call    $eaa1
ea22 d1        pop     de
ea23 d1        pop     de
ea24 d1        pop     de
ea25 22a204    ld      ($04a2),hl
ea28 1828      jr      $ea52            ; (+$28)
ea2a 60        ld      h,b
ea2b 69        ld      l,c
ea2c 29        add     hl,hl
ea2d 29        add     hl,hl
ea2e 116204    ld      de,$0462
ea31 19        add     hl,de
ea32 5e        ld      e,(hl)
ea33 23        inc     hl
ea34 56        ld      d,(hl)
ea35 d5        push    de
ea36 2aa404    ld      hl,($04a4)
ea39 d1        pop     de
ea3a eb        ex      de,hl
ea3b cd55fb    call    $fb55
ea3e 2812      jr      z,$ea52          ; (+$12)
ea40 210100    ld      hl,$0001
ea43 e5        push    hl
ea44 c5        push    bc
ea45 2aa004    ld      hl,($04a0)
ea48 e5        push    hl
ea49 cda1ea    call    $eaa1
ea4c d1        pop     de
ea4d d1        pop     de
ea4e d1        pop     de
ea4f 22a204    ld      ($04a2),hl
ea52 188d      jr      $e9e1            ; (-$73)
ea54 c3cbe9    jp      $e9cb
ea57 2a8204    ld      hl,($0482)
ea5a 7c        ld      a,h
ea5b b5        or      l
ea5c 203f      jr      nz,$ea9d         ; (+$3f)
ea5e 2a7c04    ld      hl,($047c)
ea61 e5        push    hl
ea62 2a7a04    ld      hl,($047a)
ea65 e5        push    hl
ea66 cdb0ec    call    $ecb0
ea69 d1        pop     de
ea6a d1        pop     de
ea6b 2030      jr      nz,$ea9d         ; (+$30)
ea6d 2a8004    ld      hl,($0480)
ea70 e5        push    hl
ea71 2a7e04    ld      hl,($047e)
ea74 e5        push    hl
ea75 cdb0ec    call    $ecb0
ea78 d1        pop     de
ea79 d1        pop     de
ea7a 2021      jr      nz,$ea9d         ; (+$21)
ea7c 210800    ld      hl,$0008
ea7f 39        add     hl,sp
ea80 5e        ld      e,(hl)
ea81 23        inc     hl
ea82 56        ld      d,(hl)
ea83 d5        push    de
ea84 2a8004    ld      hl,($0480)
ea87 e5        push    hl
ea88 2a7e04    ld      hl,($047e)
ea8b e5        push    hl
ea8c 2a7c04    ld      hl,($047c)
ea8f e5        push    hl
ea90 2a7a04    ld      hl,($047a)
ea93 e5        push    hl
ea94 cd7dee    call    $ee7d
ea97 eb        ex      de,hl
ea98 210a00    ld      hl,$000a
ea9b 39        add     hl,sp
ea9c f9        ld      sp,hl
ea9d 2aa204    ld      hl,($04a2)
eaa0 c9        ret     

eaa1 cd90ff    call    $ff90
eaa4 210a00    ld      hl,$000a
eaa7 39        add     hl,sp
eaa8 4e        ld      c,(hl)
eaa9 23        inc     hl
eaaa 46        ld      b,(hl)
eaab 210800    ld      hl,$0008
eaae 39        add     hl,sp
eaaf 5e        ld      e,(hl)
eab0 23        inc     hl
eab1 56        ld      d,(hl)
eab2 eb        ex      de,hl
eab3 22a804    ld      ($04a8),hl
eab6 60        ld      h,b
eab7 69        ld      l,c
eab8 29        add     hl,hl
eab9 e5        push    hl
eaba 2aa804    ld      hl,($04a8)
eabd 110100    ld      de,$0001
eac0 cd18fc    call    $fc18
eac3 29        add     hl,hl
eac4 29        add     hl,hl
eac5 d1        pop     de
eac6 19        add     hl,de
eac7 117a04    ld      de,$047a
eaca 19        add     hl,de
eacb 5e        ld      e,(hl)
eacc 23        inc     hl
eacd 56        ld      d,(hl)
eace d5        push    de
eacf 60        ld      h,b
ead0 69        ld      l,c
ead1 29        add     hl,hl
ead2 e5        push    hl
ead3 2aa804    ld      hl,($04a8)
ead6 29        add     hl,hl
ead7 29        add     hl,hl
ead8 d1        pop     de
ead9 19        add     hl,de
eada 117a04    ld      de,$047a
eadd 19        add     hl,de
eade 5e        ld      e,(hl)
eadf 23        inc     hl
eae0 56        ld      d,(hl)
eae1 e1        pop     hl
eae2 cd18fc    call    $fc18
eae5 22aa04    ld      ($04aa),hl
eae8 7c        ld      a,h
eae9 b5        or      l
eaea caa7eb    jp      z,$eba7
eaed 2aaa04    ld      hl,($04aa)
eaf0 cdcbf5    call    $f5cb
eaf3 cd4af2    call    $f24a
eaf6 210100    ld      hl,$0001
eaf9 50        ld      d,b
eafa 59        ld      e,c
eafb eb        ex      de,hl
eafc cd18fc    call    $fc18
eaff 29        add     hl,hl
eb00 e5        push    hl
eb01 2aa804    ld      hl,($04a8)
eb04 29        add     hl,hl
eb05 29        add     hl,hl
eb06 d1        pop     de
eb07 19        add     hl,de
eb08 117a04    ld      de,$047a
eb0b 19        add     hl,de
eb0c 5e        ld      e,(hl)
eb0d 23        inc     hl
eb0e 56        ld      d,(hl)
eb0f d5        push    de
eb10 210100    ld      hl,$0001
eb13 50        ld      d,b
eb14 59        ld      e,c
eb15 eb        ex      de,hl
eb16 cd18fc    call    $fc18
eb19 29        add     hl,hl
eb1a e5        push    hl
eb1b 2aa804    ld      hl,($04a8)
eb1e 110100    ld      de,$0001
eb21 cd18fc    call    $fc18
eb24 29        add     hl,hl
eb25 29        add     hl,hl
eb26 d1        pop     de
eb27 19        add     hl,de
eb28 117a04    ld      de,$047a
eb2b 19        add     hl,de
eb2c 5e        ld      e,(hl)
eb2d 23        inc     hl
eb2e 56        ld      d,(hl)
eb2f e1        pop     hl
eb30 cd18fc    call    $fc18
eb33 cdcbf5    call    $f5cb
eb36 cd4af2    call    $f24a
eb39 211c00    ld      hl,$001c
eb3c 39        add     hl,sp
eb3d 5e        ld      e,(hl)
eb3e 23        inc     hl
eb3f 56        ld      d,(hl)
eb40 eb        ex      de,hl
eb41 29        add     hl,hl
eb42 e5        push    hl
eb43 60        ld      h,b
eb44 69        ld      l,c
eb45 29        add     hl,hl
eb46 29        add     hl,hl
eb47 d1        pop     de
eb48 19        add     hl,de
eb49 116004    ld      de,$0460
eb4c 19        add     hl,de
eb4d 5e        ld      e,(hl)
eb4e 23        inc     hl
eb4f 56        ld      d,(hl)
eb50 eb        ex      de,hl
eb51 22ac04    ld      ($04ac),hl
eb54 e5        push    hl
eb55 60        ld      h,b
eb56 69        ld      l,c
eb57 29        add     hl,hl
eb58 e5        push    hl
eb59 2aa804    ld      hl,($04a8)
eb5c 29        add     hl,hl
eb5d 29        add     hl,hl
eb5e d1        pop     de
eb5f 19        add     hl,de
eb60 117a04    ld      de,$047a
eb63 19        add     hl,de
eb64 5e        ld      e,(hl)
eb65 23        inc     hl
eb66 56        ld      d,(hl)
eb67 e1        pop     hl
eb68 cd18fc    call    $fc18
eb6b cdcbf5    call    $f5cb
eb6e cd7bf2    call    $f27b
eb71 cde4f4    call    $f4e4
eb74 cd7bf2    call    $f27b
eb77 cde4f3    call    $f3e4
eb7a cd4af2    call    $f24a
eb7d cdc8e6    call    $e6c8
eb80 eb        ex      de,hl
eb81 cd87ff    call    $ff87
eb84 d5        push    de
eb85 210100    ld      hl,$0001
eb88 50        ld      d,b
eb89 59        ld      e,c
eb8a eb        ex      de,hl
eb8b cd18fc    call    $fc18
eb8e 29        add     hl,hl
eb8f e5        push    hl
eb90 2aa804    ld      hl,($04a8)
eb93 29        add     hl,hl
eb94 29        add     hl,hl
eb95 d1        pop     de
eb96 19        add     hl,de
eb97 117a04    ld      de,$047a
eb9a 19        add     hl,de
eb9b d1        pop     de
eb9c e5        push    hl
eb9d 7e        ld      a,(hl)
eb9e 23        inc     hl
eb9f 66        ld      h,(hl)
eba0 6f        ld      l,a
eba1 19        add     hl,de
eba2 eb        ex      de,hl
eba3 e1        pop     hl
eba4 73        ld      (hl),e
eba5 23        inc     hl
eba6 72        ld      (hl),d
eba7 2aac04    ld      hl,($04ac)
ebaa e5        push    hl
ebab 60        ld      h,b
ebac 69        ld      l,c
ebad 29        add     hl,hl
ebae e5        push    hl
ebaf 2aa804    ld      hl,($04a8)
ebb2 29        add     hl,hl
ebb3 29        add     hl,hl
ebb4 d1        pop     de
ebb5 19        add     hl,de
ebb6 117a04    ld      de,$047a
ebb9 19        add     hl,de
ebba d1        pop     de
ebbb 73        ld      (hl),e
ebbc 23        inc     hl
ebbd 72        ld      (hl),d
ebbe 60        ld      h,b
ebbf 69        ld      l,c
ebc0 29        add     hl,hl
ebc1 eb        ex      de,hl
ebc2 210c00    ld      hl,$000c
ebc5 39        add     hl,sp
ebc6 7e        ld      a,(hl)
ebc7 23        inc     hl
ebc8 66        ld      h,(hl)
ebc9 6f        ld      l,a
ebca 19        add     hl,de
ebcb 22a604    ld      ($04a6),hl
ebce eb        ex      de,hl
ebcf 2a8404    ld      hl,($0484)
ebd2 cd24fb    call    $fb24
ebd5 2806      jr      z,$ebdd          ; (+$06)
ebd7 210100    ld      hl,$0001
ebda 228204    ld      ($0482),hl
ebdd 2aa604    ld      hl,($04a6)
ebe0 eb        ex      de,hl
ebe1 2a8604    ld      hl,($0486)
ebe4 cd24fb    call    $fb24
ebe7 2806      jr      z,$ebef          ; (+$06)
ebe9 210100    ld      hl,$0001
ebec 228204    ld      ($0482),hl
ebef 2a8404    ld      hl,($0484)
ebf2 228604    ld      ($0486),hl
ebf5 2aa604    ld      hl,($04a6)
ebf8 228404    ld      ($0484),hl
ebfb 2aa604    ld      hl,($04a6)
ebfe c9        ret     

ebff cd90ff    call    $ff90
ec02 2aff01    ld      hl,($01ff)
ec05 110100    ld      de,$0001
ec08 cd24fb    call    $fb24
ec0b 2807      jr      z,$ec14          ; (+$07)
ec0d 2a7804    ld      hl,($0478)
ec10 7c        ld      a,h
ec11 b5        or      l
ec12 2004      jr      nz,$ec18         ; (+$04)
ec14 210000    ld      hl,$0000
ec17 c9        ret     

ec18 210100    ld      hl,$0001
ec1b c9        ret     

ec1c cd90ff    call    $ff90
ec1f 2aff01    ld      hl,($01ff)
ec22 110200    ld      de,$0002
ec25 cd24fb    call    $fb24
ec28 281a      jr      z,$ec44          ; (+$1a)
ec2a 210a00    ld      hl,$000a
ec2d 39        add     hl,sp
ec2e 5e        ld      e,(hl)
ec2f 23        inc     hl
ec30 56        ld      d,(hl)
ec31 d5        push    de
ec32 210a00    ld      hl,$000a
ec35 39        add     hl,sp
ec36 5e        ld      e,(hl)
ec37 23        inc     hl
ec38 56        ld      d,(hl)
ec39 d5        push    de
ec3a cdb0ec    call    $ecb0
ec3d d1        pop     de
ec3e d1        pop     de
ec3f 2803      jr      z,$ec44          ; (+$03)
ec41 cd5104    call    $0451
ec44 c9        ret     


;;===============================================================================================

ec45 cd90ff    call    $ff90
ec48 210800    ld      hl,$0008
ec4b 39        add     hl,sp
ec4c cd09f2    call    $f209
ec4f 21c701    ld      hl,$01c7
ec52 cdfbf1    call    $f1fb
ec55 cdaaf5    call    $f5aa
ec58 281c      jr      z,$ec76          ; (+$1c)
ec5a 210800    ld      hl,$0008
ec5d 39        add     hl,sp
ec5e e5        push    hl
ec5f 21c701    ld      hl,$01c7
ec62 cd09f2    call    $f209
ec65 cda6f2    call    $f2a6
ec68 e1        pop     hl
ec69 e5        push    hl
ec6a cd09f2    call    $f209
ec6d cd08f3    call    $f308
ec70 e1        pop     hl
ec71 cd28f2    call    $f228
ec74 18d2      jr      $ec48            ; (-$2e)
ec76 210800    ld      hl,$0008
ec79 39        add     hl,sp
ec7a cd09f2    call    $f209
ec7d cdf4f1    call    $f1f4
ec80 00        nop     
ec81 00        nop     
ec82 00        nop     
ec83 00        nop     
ec84 00        nop     
ec85 00        nop     
ec86 00        nop     
ec87 00        nop     
ec88 cd95f5    call    $f595
ec8b 281c      jr      z,$eca9          ; (+$1c)
ec8d 210800    ld      hl,$0008
ec90 39        add     hl,sp
ec91 e5        push    hl
ec92 21c701    ld      hl,$01c7
ec95 cd09f2    call    $f209
ec98 cda6f2    call    $f2a6
ec9b e1        pop     hl
ec9c e5        push    hl
ec9d cd09f2    call    $f209
eca0 cd0ff3    call    $f30f
eca3 e1        pop     hl
eca4 cd28f2    call    $f228
eca7 18cd      jr      $ec76            ; (-$33)
eca9 210800    ld      hl,$0008
ecac 39        add     hl,sp
ecad c309f2    jp      $f209
ecb0 c5        push    bc
ecb1 210400    ld      hl,$0004
ecb4 39        add     hl,sp
ecb5 5e        ld      e,(hl)
ecb6 23        inc     hl
ecb7 56        ld      d,(hl)
ecb8 23        inc     hl
ecb9 4e        ld      c,(hl)
ecba 23        inc     hl
ecbb 46        ld      b,(hl)
ecbc 2a6604    ld      hl,($0466)
ecbf 7c        ld      a,h
ecc0 17        rla     
ecc1 3811      jr      c,$ecd4          ; (+$11)
ecc3 ed42      sbc     hl,bc
ecc5 380d      jr      c,$ecd4          ; (+$0d)
ecc7 2a6204    ld      hl,($0462)
ecca ed52      sbc     hl,de
eccc 3806      jr      c,$ecd4          ; (+$06)
ecce c1        pop     bc
eccf 210000    ld      hl,$0000
ecd2 a5        and     l
ecd3 c9        ret     

ecd4 c1        pop     bc
ecd5 210100    ld      hl,$0001
ecd8 b5        or      l
ecd9 c9        ret     

ecda e1        pop     hl
ecdb 22ae04    ld      ($04ae),hl
ecde cdb0ec    call    $ecb0
ece1 2003      jr      nz,$ece6         ; (+$03)
ece3 cd66ee    call    $ee66
ece6 2aae04    ld      hl,($04ae)
ece9 e9        jp      (hl)


;;===============================================================================================

;; set display mode 
ecea 3a4900    ld      a,($0049)
eced cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc0e								;; firmware function: scr set mode 

ecf2 3a4a00    ld      a,($004a)
ecf5 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &be9e								
ecfa c7        rst     $00

;;===============================================================================================

ecfb af        xor     a
ecfc 324800    ld      ($0048),a
ecff 3d        dec     a
ed00 324000    ld      ($0040),a
ed03 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc11								;; firmware function: scr get mode
ed08 324900    ld      ($0049),a
ed0b af        xor     a
ed0c cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &be9e
ed11 324a00    ld      ($004a),a
ed14 c9        ret     


;;===============================================================================================

ed15 c5        push    bc
ed16 3ab801    ld      a,($01b8)
ed19 cd34ee    call    $ee34
ed1c 3e81      ld      a,$81
ed1e 324000    ld      ($0040),a
ed21 cd50ee    call    $ee50							;; enable cursor
ed24 c1        pop     bc
ed25 c9        ret     


;;===============================================================================================

ed26 c5        push    bc
ed27 210400    ld      hl,$0004
ed2a 39        add     hl,sp
ed2b 3a4000    ld      a,($0040)
ed2e be        cp      (hl)
ed2f caaeed    jp      z,$edae
ed32 e5        push    hl
ed33 f5        push    af
ed34 cd43ee    call    $ee43							;; disable cursor
ed37 f1        pop     af
ed38 b7        or      a
ed39 3ab701    ld      a,($01b7)
ed3c fc34ee    call    m,$ee34
ed3f cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb78												;; firmware function: txt get cursor
ed44 3a4000    ld      a,($0040)
ed47 e67f      and     $7f
ed49 3d        dec     a
ed4a 85        add     a,l
ed4b 6f        ld      l,a
ed4c e3        ex      (sp),hl
ed4d 7e        ld      a,(hl)
ed4e 324000    ld      ($0040),a
ed51 d601      sub     $01
ed53 6f        ld      l,a
ed54 d259ed    jp      nc,$ed59
ed57 2e18      ld      l,$18
ed59 3a4700    ld      a,($0047)						;; right column of window
ed5c 67        ld      h,a
ed5d 1600      ld      d,$00
ed5f 1e18      ld      e,$18
ed61 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE							
defw &bb66												;; firmware function: txt win enable
ed66 e1        pop     hl
ed67 cd24ee    call    $ee24
ed6a 21c700    ld      hl,$00c7
ed6d 224b00    ld      ($004b),hl
ed70 210000    ld      hl,$0000
ed73 118f01    ld      de,$018f
ed76 3a4000    ld      a,($0040)
ed79 b7        or      a
ed7a ca8ced    jp      z,$ed8c
ed7d 6f        ld      l,a
ed7e 29        add     hl,hl
ed7f 29        add     hl,hl
ed80 29        add     hl,hl
ed81 2b        dec     hl
ed82 224b00    ld      ($004b),hl
ed85 23        inc     hl
ed86 29        add     hl,hl
ed87 2b        dec     hl
ed88 cdc5f0    call    $f0c5									;; HL = -HL
ed8b 19        add     hl,de
ed8c 224d00    ld      ($004d),hl
ed8f cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbd2														;; firmware function: gra win height
ed94 2a4b00    ld      hl,($004b)
ed97 23        inc     hl
ed98 cdc5f0    call    $f0c5									;; HL = -HL
ed9b 119001    ld      de,$0190
ed9e 19        add     hl,de
ed9f 114001    ld      de,$0140
eda2 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbc9														;; firmware function: gra set origin
eda7 3a4000    ld      a,($0040)
edaa b7        or      a
edab c450ee    call    nz,$ee50							;; enable cursor
edae c1        pop     bc
edaf c9        ret     

edb0 c5        push    bc
edb1 cd43ee    call    $ee43							;; disable cursor
edb4 cd5dee    call    $ee5d
edb7 cdfded    call    $edfd
edba daceed    jp      c,$edce
edbd c2c8ed    jp      nz,$edc8								;; fill area

edc0 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb6c													;; firmware function: txt clear window
edc5 c3ceed    jp      $edce

;;=================================================================================================
;; B = mask
;; H = left column
;; D = right column
;; L = top line
;; E = bottom line
edc8 78        ld      a,b
edc9 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc44												;; firmware function: scr fill box
edce cd50ee    call    $ee50							;; enable cursor
edd1 c1        pop     bc
edd2 c9        ret     
;;=================================================================================================

edd3 3a4000    ld      a,($0040)
edd6 b7        or      a
edd7 c8        ret     z

edd8 c5        push    bc
edd9 cd43ee    call    $ee43							;; disable cursor
eddc cd5dee    call    $ee5d
eddf cdfded    call    $edfd
ede2 daf8ed    jp      c,$edf8
ede5 78        ld      a,b
ede6 06ff      ld      b,$ff
ede8 c2f3ed    jp      nz,$edf3
edeb cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc4d													;; firmware function: scr hw roll
edf0 c3f8ed    jp      $edf8

edf3 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc50													;; firmware function: scr sw roll
edf8 cd50ee    call    $ee50								;; enable cursor
edfb c1        pop     bc
edfc c9        ret     

edfd cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb99													;; firmware function: txt get paper
ee02 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc2c													;; firmware function: scr ink encode
ee07 47        ld      b,a
ee08 1d        dec     e
ee09 2d        dec     l
ee0a 2600      ld      h,$00
ee0c 3a4700    ld      a,($0047)
ee0f 57        ld      d,a
ee10 3e18      ld      a,$18
ee12 bd        cp      l
ee13 d8        ret     c

ee14 bb        cp      e
ee15 d8        ret     c

ee16 7b        ld      a,e
ee17 ee18      xor     $18
ee19 c0        ret     nz

ee1a 7d        ld      a,l
ee1b b7        or      a
ee1c c9        ret     

ee1d c5        push    bc
ee1e cd5dee    call    $ee5d
ee21 c1        pop     bc
ee22 65        ld      h,l
ee23 6b        ld      l,e
ee24 3a4000    ld      a,($0040)
ee27 e67f      and     $7f
ee29 3d        dec     a
ee2a 5f        ld      e,a
ee2b 7d        ld      a,l						;; line number
ee2c 93        sub     e
ee2d 6f        ld      l,a
ee2e cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb75										;; firmware function: txt set cursor
ee33 c9        ret     

;;===============================================================
;; A = display mode
;; set display mode
ee34 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc0e										;; firmware function: scr set mode
ee39 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb69										;; firmware function: txt get window
ee3e 7a        ld      a,d
ee3f 324700    ld      ($0047),a
ee42 c9        ret     

;;===============================================================
;; disable cursor

ee43 214800    ld      hl,$0048					
ee46 7e        ld      a,(hl)					;; get current state
ee47 b7        or      a
ee48 c0        ret     nz
;; currently enabled
ee49 35        dec     (hl)
ee4a cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb7e										;; firmware function: txt cur disable
ee4f c9        ret     

;;===============================================================
;; enable cursor

ee50 214800    ld      hl,$0048
ee53 7e        ld      a,(hl)					;; get current state
ee54 b7        or      a
ee55 c8        ret     z
;; currently disabled
ee56 34        inc     (hl)
ee57 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb7b										;; firmware function: txt cur enable
ee5c c9        ret     

;;===============================================================

ee5d 210800    ld      hl,$0008
ee60 39        add     hl,sp
ee61 5e        ld      e,(hl)
ee62 2b        dec     hl
ee63 2b        dec     hl
ee64 6e        ld      l,(hl)
ee65 c9        ret     

ee66 c5        push    bc
ee67 210900    ld      hl,$0009
ee6a 39        add     hl,sp
ee6b cdd6ee    call    $eed6
ee6e cdf3ee    call    $eef3
ee71 d5        push    de
ee72 cd02ef    call    $ef02
ee75 e1        pop     hl
ee76 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbea											;; firmware function: gra plot absolute
ee7b c1        pop bc
ee7c c9        ret     

ee7d c5        push    bc
ee7e 210d00    ld      hl,$000d
ee81 39        add     hl,sp
ee82 cdd6ee    call    $eed6
ee85 cdf3ee    call    $eef3
ee88 d5        push    de
ee89 cd02ef    call    $ef02
ee8c e3        ex      (sp),hl
ee8d cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbc0											;; firmware function: gra move absolute
ee92 e1        pop     hl
ee93 cdf3ee    call    $eef3
ee96 d5        push    de
ee97 cd02ef    call    $ef02
ee9a e1        pop     hl
ee9b cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbf6											;; firmware function: gra line absolute
eea0 c1        pop     bc
eea1 c9        ret     

eea2 c5        push    bc
eea3 210700    ld      hl,$0007
eea6 39        add     hl,sp
eea7 cd0def    call    $ef0d
eeaa eb        ex      de,hl
eeab cdc5f0    call    $f0c5									;; HL = -HL
eeae 118f01    ld      de,$018f
eeb1 d5        push    de
eeb2 19        add     hl,de
eeb3 eb        ex      de,hl
eeb4 2a4d00    ld      hl,($004d)
eeb7 eb        ex      de,hl
eeb8 cdb9f0    call    $f0b9
eebb d2bfee    jp      nc,$eebf
eebe eb        ex      de,hl
eebf d1        pop     de
eec0 d5        push    de
eec1 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbd2											;; firmware function: gra win height
eec6 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbdb											;; firmware function: gra clear window
eecb d1        pop     de
eecc 2a4d00    ld      hl,($004d)
eecf cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbd2											;; firmware function: gra win height
eed4 c1        pop bc
eed5 c9        ret     

eed6 cd0def    call    $ef0d
eed9 7a        ld      a,d
eeda 3d        dec     a
eedb fe01      cp      $01
eedd cae1ee    jp      z,$eee1
eee0 af        xor     a
eee1 e5        push    hl
eee2 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc59											;; firmware function: scr access
eee7 e1        pop     hl
eee8 7b        ld      a,e
eee9 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbde											;; firmware function: gra set pen
eeee c9        ret     

eeef 210000    ld      hl,$0000
eef2 c9        ret     

eef3 cd0def    call    $ef0d
eef6 e5        push    hl
eef7 2a4b00    ld      hl,($004b)
eefa eb        ex      de,hl
eefb cdc5f0    call    $f0c5									;; HL = -HL
eefe 19        add     hl,de
eeff eb        ex      de,hl
ef00 e1        pop     hl
ef01 c9        ret     

ef02 cd0def    call    $ef0d
ef05 e5        push    hl
ef06 21c0fe    ld      hl,$fec0
ef09 19        add     hl,de
ef0a eb        ex      de,hl
ef0b e1        pop     hl
ef0c c9        ret     

ef0d 56        ld      d,(hl)
ef0e 2b        dec     hl
ef0f 5e        ld      e,(hl)
ef10 2b        dec     hl
ef11 7b        ld      a,e
ef12 c9        ret     


;;===============================================================================================

ef13 c5        push    bc
ef14 210b00    ld      hl,$000b
ef17 39        add     hl,sp
ef18 cdd6ee    call    $eed6
ef1b cd0def    call    $ef0d
ef1e d5        push    de
ef1f cdf3ee    call    $eef3
ef22 d5        push    de
ef23 cd02ef    call    $ef02
ef26 e1        pop     hl
ef27 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bbc0										; firmware function: gra move absolute

ef2c 3eff      ld      a,$ff
ef2e cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb63										; firmware function: txt set graphic
ef33 e1        pop     hl

ef34 7e        ld      a,(hl)					; get character
ef35 23        inc     hl						; increment pointer
ef36 b7        or      a						; test for end of string marker
ef37 c45abb    call    nz,$bb5a					; firmware function: txt output
ef3a c234ef    jp      nz,$ef34					; loop if not end of string marker

ef3d af        xor     a
ef3e cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb63										; firmware function: txt set graphic
ef43 c1        pop     bc
ef44 c9        ret     

ef45 c9        ret     


;;===============================================================================================

ef46 c5        push    bc
ef47 210b00    ld      hl,$000b
ef4a 39        add     hl,sp
ef4b cd6cef    call    $ef6c
ef4e 47        ld      b,a
ef4f cd6cef    call    $ef6c
ef52 4f        ld      c,a
ef53 87        add     a,a
ef54 87        add     a,a
ef55 87        add     a,a
ef56 81        add     a,c
ef57 80        add     a,b
ef58 47        ld      b,a
ef59 cd6cef    call    $ef6c
ef5c 4f        ld      c,a
ef5d 87        add     a,a
ef5e 81        add     a,c
ef5f 80        add     a,b
ef60 47        ld      b,a
ef61 4f        ld      c,a
ef62 cd0def    call    $ef0d
ef65 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc32												;; firmware function: scr set ink

ef6a c1        pop bc
ef6b c9        ret     

ef6c cd0def    call    $ef0d
ef6f e603      and     $03
ef71 fe03      cp      $03
ef73 d8        ret     c

ef74 af        xor     a
ef75 c9        ret     

ef76 c5        push    bc
ef77 210500    ld      hl,$0005
ef7a 39        add     hl,sp
ef7b cd0def    call    $ef0d
ef7e cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bc35											;; firmware function: scr get ink
ef83 214100    ld      hl,$0041
ef86 3e06      ld      a,$06
ef88 3600      ld      (hl),$00
ef8a 23        inc     hl
ef8b 3d        dec     a
ef8c c288ef    jp      nz,$ef88
ef8f 68        ld      l,b
ef90 2609      ld      h,$09
ef92 cdcff0    call    $f0cf
ef95 324300    ld      ($0043),a
ef98 2603      ld      h,$03
ef9a cdcff0    call    $f0cf
ef9d 324100    ld      ($0041),a
efa0 7d        ld      a,l
efa1 324500    ld      ($0045),a
efa4 214100    ld      hl,$0041
efa7 c1        pop     bc
efa8 c9        ret     


;;===============================================================================================

efa9 110700    ld      de,$0007
efac 210400    ld      hl,$0004
efaf cddeef    call    $efde
efb2 2600      ld      h,$00
efb4 c9        ret     

efb5 110400    ld      de,$0004
efb8 c3dbef    jp      $efdb
efbb 3a4000    ld      a,($0040)
efbe b7        or      a
efbf c8        ret     z

efc0 110a00    ld      de,$000a
efc3 c3dbef    jp      $efdb
efc6 2e07      ld      l,$07
efc8 e5        push    hl
efc9 cdbbef    call    $efbb
efcc e1        pop     hl
efcd c9        ret     

efce 2a0600    ld      hl,($0006)
efd1 c9        ret     

efd2 112b00    ld      de,$002b
efd5 c3dbef    jp      $efdb
efd8 110d00    ld      de,$000d
efdb 210200    ld      hl,$0002
efde 39        add     hl,sp
efdf c5        push    bc
efe0 4e        ld      c,(hl)
efe1 2a0100    ld      hl,($0001)
efe4 19        add     hl,de
efe5 7e        ld      a,(hl)
efe6 23        inc     hl
efe7 66        ld      h,(hl)
efe8 6f        ld      l,a
efe9 cdf1ef    call    $eff1
efec 6f        ld      l,a
efed 67        ld      h,a
efee b7        or      a
efef c1        pop     bc
eff0 c9        ret     

eff1 e9        jp      (hl)
eff2 210200    ld      hl,$0002
eff5 39        add     hl,sp
eff6 cd25f0    call    $f025								;; get state of joystick 0 or 1
eff9 2106f0    ld      hl,$f006
effc e60f      and     $0f
effe 5f        ld      e,a
efff 1600      ld      d,$00
f001 19        add     hl,de
f002 6e        ld      l,(hl)
f003 2600      ld      h,$00
f005 c9        ret     

f006 ff        rst     $38
f007 00        nop     
f008 04        inc     b
f009 ff        rst     $38
f00a 0607      ld      b,$07
f00c 05        dec     b
f00d 0602      ld      b,$02
f00f 010302    ld      bc,$0203
f012 ff        rst     $38
f013 00        nop     
f014 04        inc     b
f015 ff        rst     $38
f016 210200    ld      hl,$0002
f019 39        add     hl,sp
f01a cd25f0    call    $f025							;; get state of joystick 0 or 1
f01d 210000    ld      hl,$0000
f020 e630      and     $30
f022 c8        ret     z

f023 23        inc     hl
f024 c9        ret     

;;===================================================================================
;; get state of joystick 0 or 1

f025 eb        ex      de,hl
f026 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bb24												;; firmware function: km get joystick
f02b eb        ex      de,hl
f02c 7e        ld      a,(hl)
f02d b7        or      a
f02e 7a        ld      a,d								;; joystick 0
f02f c8        ret     z
f030 7b        ld      a,e								;; joystick 1
f031 c9        ret     

;;===================================================================================

f032 c5        push    bc
f033 210500    ld      hl,$0005
f036 39        add     hl,sp
f037 cd0def    call    $ef0d
f03a 21f6ff    ld      hl,$fff6
f03d 39        add     hl,sp
f03e f9        ld      sp,hl
f03f e5        push    hl
f040 0609      ld      b,$09
f042 1a        ld      a,(de)
f043 77        ld      (hl),a
f044 13        inc     de
f045 23        inc     hl
f046 05        dec     b
f047 c242f0    jp      nz,$f042
f04a e1        pop     hl
f04b e5        push    hl
f04c cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bcaa													;; firmware function: sound queue
f051 d24cf0    jp      nc,$f04c
f054 e1        pop     hl
f055 110a00    ld      de,$000a
f058 19        add     hl,de
f059 f9        ld      sp,hl
f05a c1        pop     bc
f05b c9        ret     

f05c c5        push    bc
f05d 210500    ld      hl,$0005
f060 39        add     hl,sp
f061 cd0def    call    $ef0d
f064 21eeff    ld      hl,$ffee
f067 39        add     hl,sp
f068 f9        ld      sp,hl
f069 e5        push    hl
f06a 0611      ld      b,$11
f06c 1a        ld      a,(de)
f06d 77        ld      (hl),a
f06e 13        inc     de
f06f 23        inc     hl
f070 05        dec     b
f071 c26cf0    jp      nz,$f06c
f074 e1        pop     hl
f075 e5        push    hl
f076 7e        ld      a,(hl)
f077 23        inc     hl
f078 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bcbf														;; firmware function: sound tone envelope
f07d e1        pop     hl
f07e 111200    ld      de,$0012
f081 19        add     hl,de
f082 f9        ld      sp,hl
f083 c1        pop     bc
f084 c9        ret     

f085 c5        push    bc
f086 210500    ld      hl,$0005
f089 39        add     hl,sp
f08a cd0def    call    $ef0d
f08d 21eeff    ld      hl,$ffee
f090 39        add     hl,sp
f091 f9        ld      sp,hl
f092 e5        push    hl
f093 0611      ld      b,$11
f095 1a        ld      a,(de)
f096 77        ld      (hl),a
f097 13        inc     de
f098 23        inc     hl
f099 05        dec     b
f09a c295f0    jp      nz,$f095
f09d e1        pop     hl
f09e e5        push    hl
f09f 7e        ld      a,(hl)
f0a0 23        inc     hl
f0a1 cd9bbe    call    $be9b			;; CPM2.1 extended jumpblock: ENTER FIRMWARE
defw &bcbc															;; firmware function: sound ampl envelope
f0a6 e1        pop     hl
f0a7 111200    ld      de,$0012
f0aa 19        add     hl,de
f0ab f9        ld      sp,hl
f0ac c1        pop     bc
f0ad c9        ret     

f0ae c5        push    bc
f0af 210400    ld      hl,$0004
f0b2 39        add     hl,sp
f0b3 7e        ld      a,(hl)
f0b4 cdb3bc    call    $bcb3										;; firmware function: sound release
f0b7 c1        pop     bc
f0b8 c9        ret     

f0b9 c5        push    bc
f0ba 47        ld      b,a
f0bb 7c        ld      a,h
f0bc ba        cp      d
f0bd c2c2f0    jp      nz,$f0c2
f0c0 7d        ld      a,l
f0c1 bb        cp      e
f0c2 78        ld      a,b
f0c3 c1        pop     bc
f0c4 c9        ret     

;;=====================================================================
;; HL = -HL
f0c5 f5        push    af
f0c6 7c        ld      a,h
f0c7 2f        cpl     
f0c8 67        ld      h,a
f0c9 7d        ld      a,l
f0ca 2f        cpl     
f0cb 6f        ld      l,a
f0cc 23        inc     hl
f0cd f1        pop     af
f0ce c9        ret     

;;=====================================================================

f0cf 7c        ld      a,h
f0d0 b7        or      a
f0d1 c8        ret     z

f0d2 c5        push    bc
f0d3 0608      ld      b,$08
f0d5 4c        ld      c,h
f0d6 2600      ld      h,$00
f0d8 b7        or      a
f0d9 7d        ld      a,l
f0da 17        rla     
f0db 6f        ld      l,a
f0dc 7c        ld      a,h
f0dd 17        rla     
f0de 67        ld      h,a
f0df b9        cp      c
f0e0 dae9f0    jp      c,$f0e9
f0e3 91        sub     c
f0e4 67        ld      h,a
f0e5 7d        ld      a,l
f0e6 f601      or      $01
f0e8 6f        ld      l,a
f0e9 05        dec     b
f0ea c2d8f0    jp      nz,$f0d8
f0ed 7d        ld      a,l
f0ee 6c        ld      l,h
f0ef c1        pop     bc
f0f0 37        scf     
f0f1 c9        ret     

f0f2 210200    ld      hl,$0002
f0f5 39        add     hl,sp
f0f6 c5        push    bc
f0f7 01ff7f    ld      bc,$7fff
f0fa 5e        ld      e,(hl)
f0fb 23        inc     hl
f0fc 56        ld      d,(hl)
f0fd 23        inc     hl
f0fe 7e        ld      a,(hl)
f0ff 23        inc     hl
f100 66        ld      h,(hl)
f101 6f        ld      l,a
f102 78        ld      a,b
f103 b1        or      c
f104 ca16f1    jp      z,$f116
f107 1a        ld      a,(de)
f108 be        cp      (hl)
f109 c21bf1    jp      nz,$f11b
f10c b7        or      a
f10d ca16f1    jp      z,$f116
f110 23        inc     hl
f111 13        inc     de
f112 0b        dec     bc
f113 c302f1    jp      $f102
f116 c1        pop     bc
f117 210000    ld      hl,$0000
f11a c9        ret     

f11b c1        pop     bc
f11c da25f1    jp      c,$f125
f11f 210100    ld      hl,$0001
f122 7d        ld      a,l
f123 b4        or      h
f124 c9        ret     

f125 21ffff    ld      hl,$ffff
f128 7d        ld      a,l
f129 b4        or      h
f12a c9        ret     

f12b 210200    ld      hl,$0002
f12e 39        add     hl,sp
f12f c5        push    bc
f130 01ff7f    ld      bc,$7fff
f133 5e        ld      e,(hl)
f134 23        inc     hl
f135 56        ld      d,(hl)
f136 d5        push    de
f137 23        inc     hl
f138 7e        ld      a,(hl)
f139 23        inc     hl
f13a 66        ld      h,(hl)
f13b 6f        ld      l,a
f13c 78        ld      a,b
f13d b1        or      c
f13e ca4df1    jp      z,$f14d
f141 7e        ld      a,(hl)
f142 12        ld      (de),a
f143 b7        or      a
f144 ca4df1    jp      z,$f14d
f147 23        inc     hl
f148 13        inc     de
f149 0b        dec     bc
f14a c33cf1    jp      $f13c
f14d e1        pop     hl
f14e c1        pop     bc
f14f c9        ret     

f150 210200    ld      hl,$0002
f153 39        add     hl,sp
f154 7e        ld      a,(hl)
f155 23        inc     hl
f156 66        ld      h,(hl)
f157 6f        ld      l,a
f158 110000    ld      de,$0000
f15b af        xor     a
f15c be        cp      (hl)
f15d ca65f1    jp      z,$f165
f160 13        inc     de
f161 23        inc     hl
f162 c35cf1    jp      $f15c
f165 eb        ex      de,hl
f166 7d        ld      a,l
f167 b4        or      h
f168 c9        ret     

f169 210200    ld      hl,$0002
f16c 39        add     hl,sp
f16d c5        push    bc
f16e 5e        ld      e,(hl)
f16f 23        inc     hl
f170 56        ld      d,(hl)
f171 d5        push    de
f172 23        inc     hl
f173 5e        ld      e,(hl)
f174 23        inc     hl
f175 56        ld      d,(hl)
f176 23        inc     hl
f177 4e        ld      c,(hl)
f178 23        inc     hl
f179 46        ld      b,(hl)
f17a eb        ex      de,hl
f17b d1        pop     de
f17c c302f1    jp      $f102
f17f c5        push    bc
f180 01ff7f    ld      bc,$7fff
f183 210400    ld      hl,$0004
f186 39        add     hl,sp
f187 5e        ld      e,(hl)
f188 23        inc     hl
f189 56        ld      d,(hl)
f18a d5        push    de
f18b 23        inc     hl
f18c 7e        ld      a,(hl)
f18d 23        inc     hl
f18e 66        ld      h,(hl)
f18f 6f        ld      l,a
f190 eb        ex      de,hl
f191 78        ld      a,b
f192 b1        or      c
f193 ca4df1    jp      z,$f14d
f196 7e        ld      a,(hl)
f197 b7        or      a
f198 caa0f1    jp      z,$f1a0
f19b 23        inc     hl
f19c 0b        dec     bc
f19d c391f1    jp      $f191
f1a0 eb        ex      de,hl
f1a1 c33cf1    jp      $f13c
f1a4 d1        pop     de
f1a5 e1        pop     hl
f1a6 e5        push    hl
f1a7 73        ld      (hl),e
f1a8 23        inc     hl
f1a9 72        ld      (hl),d
f1aa 23        inc     hl
f1ab d5        push    de
f1ac eb        ex      de,hl
f1ad 210000    ld      hl,$0000
f1b0 39        add     hl,sp
f1b1 eb        ex      de,hl
f1b2 73        ld      (hl),e
f1b3 23        inc     hl
f1b4 72        ld      (hl),d
f1b5 af        xor     a
f1b6 67        ld      h,a
f1b7 6f        ld      l,a
f1b8 c9        ret     

f1b9 e1        pop     hl
f1ba e1        pop     hl
f1bb 5e        ld      e,(hl)
f1bc 23        inc     hl
f1bd 56        ld      d,(hl)
f1be 23        inc     hl
f1bf d5        push    de
f1c0 5e        ld      e,(hl)
f1c1 23        inc     hl
f1c2 56        ld      d,(hl)
f1c3 e1        pop     hl
f1c4 eb        ex      de,hl
f1c5 73        ld      (hl),e
f1c6 23        inc     hl
f1c7 72        ld      (hl),d
f1c8 2b        dec     hl
f1c9 d1        pop     de
f1ca f9        ld      sp,hl
f1cb eb        ex      de,hl
f1cc 7c        ld      a,h
f1cd b5        or      l
f1ce c9        ret     

f1cf eb        ex      de,hl
f1d0 2a0701    ld      hl,($0107)
f1d3 c5        push    bc
f1d4 1a        ld      a,(de)
f1d5 77        ld      (hl),a
f1d6 23        inc     hl
f1d7 e67f      and     $7f
f1d9 d640      sub     $40
f1db 77        ld      (hl),a
f1dc 23        inc     hl
f1dd 3600      ld      (hl),$00
f1df 0603      ld      b,$03
f1e1 23        inc     hl
f1e2 13        inc     de
f1e3 1a        ld      a,(de)
f1e4 77        ld      (hl),a
f1e5 05        dec     b
f1e6 c2e1f1    jp      nz,$f1e1
f1e9 0605      ld      b,$05
f1eb af        xor     a
f1ec 23        inc     hl
f1ed 77        ld      (hl),a
f1ee 05        dec     b
f1ef c2ecf1    jp      nz,$f1ec
f1f2 c1        pop     bc
f1f3 c9        ret     

f1f4 d1        pop     de
f1f5 210800    ld      hl,$0008
f1f8 19        add     hl,de
f1f9 e5        push    hl
f1fa eb        ex      de,hl
f1fb eb        ex      de,hl
f1fc 2a0901    ld      hl,($0109)
f1ff c30df2    jp      $f20d

f202 d1        pop     de
f203 210800    ld      hl,$0008
f206 19        add     hl,de
f207 e5        push    hl
f208 eb        ex      de,hl
f209 eb        ex      de,hl
f20a 2a0701    ld      hl,($0107)

f20d c5        push    bc
f20e 1a        ld      a,(de)
f20f 77        ld      (hl),a
f210 23        inc     hl
f211 e67f      and     $7f
f213 d640      sub     $40
f215 77        ld      (hl),a
f216 23        inc     hl
f217 3600      ld      (hl),$00
f219 0607      ld      b,$07
f21b 23        inc     hl
f21c 13        inc     de
f21d 1a        ld      a,(de)
f21e 77        ld      (hl),a
f21f 05        dec     b
f220 c21bf2    jp      nz,$f21b
f223 23        inc     hl
f224 3600      ld      (hl),$00
f226 c1        pop     bc
f227 c9        ret     

f228 c5        push    bc
f229 e5        push    hl
f22a cd0df6    call    $f60d
f22d d1        pop     de
f22e 2a0701    ld      hl,($0107)
f231 7e        ld      a,(hl)
f232 e680      and     $80
f234 47        ld      b,a
f235 23        inc     hl
f236 7e        ld      a,(hl)
f237 c640      add     a,$40
f239 e67f      and     $7f
f23b b0        or      b
f23c 12        ld      (de),a
f23d 23        inc     hl
f23e 0607      ld      b,$07
f240 13        inc     de
f241 23        inc     hl
f242 7e        ld      a,(hl)
f243 12        ld      (de),a
f244 05        dec     b
f245 c240f2    jp      nz,$f240
f248 c1        pop     bc
f249 c9        ret     

f24a e1        pop     hl
f24b 22b004    ld      ($04b0),hl
f24e cd0df6    call    $f60d
f251 2a0701    ld      hl,($0107)
f254 110900    ld      de,$0009
f257 19        add     hl,de
f258 56        ld      d,(hl)
f259 2b        dec     hl
f25a 5e        ld      e,(hl)
f25b 2b        dec     hl
f25c d5        push    de
f25d 56        ld      d,(hl)
f25e 2b        dec     hl
f25f 5e        ld      e,(hl)
f260 2b        dec     hl
f261 d5        push    de
f262 56        ld      d,(hl)
f263 2b        dec     hl
f264 5e        ld      e,(hl)
f265 2b        dec     hl
f266 d5        push    de
f267 56        ld      d,(hl)
f268 2b        dec     hl
f269 2b        dec     hl
f26a 7e        ld      a,(hl)
f26b c640      add     a,$40
f26d e67f      and     $7f
f26f 5f        ld      e,a
f270 2b        dec     hl
f271 7e        ld      a,(hl)
f272 e680      and     $80
f274 b3        or      e
f275 5f        ld      e,a
f276 d5        push    de
f277 2ab004    ld      hl,($04b0)
f27a e9        jp      (hl)
f27b e1        pop     hl
f27c 22b004    ld      ($04b0),hl
f27f 2a0901    ld      hl,($0109)
f282 d1        pop     de
f283 73        ld      (hl),e
f284 23        inc     hl
f285 7b        ld      a,e
f286 e67f      and     $7f
f288 d640      sub     $40
f28a 77        ld      (hl),a
f28b 23        inc     hl
f28c 3600      ld      (hl),$00
f28e 23        inc     hl
f28f 72        ld      (hl),d
f290 23        inc     hl
f291 d1        pop     de
f292 73        ld      (hl),e
f293 23        inc     hl
f294 72        ld      (hl),d
f295 23        inc     hl
f296 d1        pop     de
f297 73        ld      (hl),e
f298 23        inc     hl
f299 72        ld      (hl),d
f29a 23        inc     hl
f29b d1        pop     de
f29c 73        ld      (hl),e
f29d 23        inc     hl
f29e 72        ld      (hl),d
f29f 23        inc     hl
f2a0 3600      ld      (hl),$00
f2a2 2ab004    ld      hl,($04b0)
f2a5 e9        jp      (hl)
f2a6 2a0901    ld      hl,($0109)
f2a9 eb        ex      de,hl
f2aa 2a0701    ld      hl,($0107)
f2ad 220901    ld      ($0109),hl
f2b0 eb        ex      de,hl
f2b1 220701    ld      ($0107),hl
f2b4 c9        ret     

f2b5 2a0701    ld      hl,($0107)
f2b8 7e        ld      a,(hl)
f2b9 ee80      xor     $80
f2bb 77        ld      (hl),a
f2bc c9        ret     

f2bd 2a0701    ld      hl,($0107)
f2c0 23        inc     hl
f2c1 7e        ld      a,(hl)
f2c2 fec0      cp      $c0
f2c4 c235fb    jp      nz,$fb35
f2c7 c329fb    jp      $fb29
f2ca af        xor     a
f2cb 3d        dec     a
f2cc c1        pop     bc
f2cd c9        ret     

f2ce af        xor     a
f2cf 3c        inc     a
f2d0 c1        pop     bc
f2d1 c9        ret     

f2d2 c5        push    bc
f2d3 2a0701    ld      hl,($0107)
f2d6 eb        ex      de,hl
f2d7 2a0901    ld      hl,($0109)
f2da 1a        ld      a,(de)
f2db b7        or      a
f2dc fae6f2    jp      m,$f2e6
f2df ae        xor     (hl)
f2e0 facef2    jp      m,$f2ce
f2e3 c3ebf2    jp      $f2eb
f2e6 ae        xor     (hl)
f2e7 facaf2    jp      m,$f2ca
f2ea eb        ex      de,hl
f2eb 23        inc     hl
f2ec 13        inc     de
f2ed 1a        ld      a,(de)
f2ee be        cp      (hl)
f2ef facaf2    jp      m,$f2ca
f2f2 c2cef2    jp      nz,$f2ce
f2f5 0609      ld      b,$09
f2f7 23        inc     hl
f2f8 13        inc     de
f2f9 1a        ld      a,(de)
f2fa be        cp      (hl)
f2fb dacaf2    jp      c,$f2ca
f2fe c2cef2    jp      nz,$f2ce
f301 05        dec     b
f302 c2f7f2    jp      nz,$f2f7
f305 af        xor     a
f306 c1        pop     bc
f307 c9        ret     

f308 2a0901    ld      hl,($0109)
f30b 7e        ld      a,(hl)
f30c ee80      xor     $80
f30e 77        ld      (hl),a
f30f c5        push    bc
f310 2a0701    ld      hl,($0107)
f313 110b00    ld      de,$000b
f316 19        add     hl,de
f317 0607      ld      b,$07
f319 af        xor     a
f31a 77        ld      (hl),a
f31b 23        inc     hl
f31c 05        dec     b
f31d c21af3    jp      nz,$f31a
f320 2a0901    ld      hl,($0109)
f323 110b00    ld      de,$000b
f326 19        add     hl,de
f327 0607      ld      b,$07
f329 77        ld      (hl),a
f32a 23        inc     hl
f32b 05        dec     b
f32c c229f3    jp      nz,$f329
f32f 2a0701    ld      hl,($0107)
f332 eb        ex      de,hl
f333 2a0901    ld      hl,($0109)
f336 23        inc     hl
f337 13        inc     de
f338 1a        ld      a,(de)
f339 96        sub     (hl)
f33a f240f3    jp      p,$f340
f33d eb        ex      de,hl
f33e 2f        cpl     
f33f 3c        inc     a
f340 1b        dec     de
f341 2b        dec     hl
f342 220901    ld      ($0109),hl
f345 eb        ex      de,hl
f346 220701    ld      ($0107),hl
f349 fe09      cp      $09
f34b d234f6    jp      nc,$f634
f34e 4f        ld      c,a
f34f e5        push    hl
f350 d5        push    de
f351 c609      add     a,$09
f353 5f        ld      e,a
f354 1600      ld      d,$00
f356 19        add     hl,de
f357 22b204    ld      ($04b2),hl
f35a d1        pop     de
f35b 210900    ld      hl,$0009
f35e 19        add     hl,de
f35f 22b404    ld      ($04b4),hl
f362 e1        pop     hl
f363 eb        ex      de,hl
f364 1a        ld      a,(de)
f365 ae        xor     (hl)
f366 f2c6f3    jp      p,$f3c6
f369 1a        ld      a,(de)
f36a b7        or      a
f36b fa8df3    jp      m,$f38d
f36e 0607      ld      b,$07
f370 2ab204    ld      hl,($04b2)
f373 eb        ex      de,hl
f374 2ab404    ld      hl,($04b4)
f377 1a        ld      a,(de)
f378 9e        sbc     a,(hl)
f379 12        ld      (de),a
f37a 1b        dec     de
f37b 2b        dec     hl
f37c 05        dec     b
f37d c277f3    jp      nz,$f377
f380 1a        ld      a,(de)
f381 de00      sbc     a,$00
f383 12        ld      (de),a
f384 1b        dec     de
f385 0d        dec     c
f386 f280f3    jp      p,$f380
f389 eb        ex      de,hl
f38a c3a8f3    jp      $f3a8
f38d 0607      ld      b,$07
f38f 2ab404    ld      hl,($04b4)
f392 eb        ex      de,hl
f393 2ab204    ld      hl,($04b2)
f396 1a        ld      a,(de)
f397 9e        sbc     a,(hl)
f398 77        ld      (hl),a
f399 1b        dec     de
f39a 2b        dec     hl
f39b 05        dec     b
f39c c296f3    jp      nz,$f396
f39f 3e00      ld      a,$00
f3a1 9e        sbc     a,(hl)
f3a2 77        ld      (hl),a
f3a3 2b        dec     hl
f3a4 0d        dec     c
f3a5 f29ff3    jp      p,$f39f
f3a8 23        inc     hl
f3a9 7e        ld      a,(hl)
f3aa b7        or      a
f3ab 3e01      ld      a,$01
f3ad f2bff3    jp      p,$f3bf
f3b0 110f00    ld      de,$000f
f3b3 19        add     hl,de
f3b4 3e00      ld      a,$00
f3b6 9e        sbc     a,(hl)
f3b7 77        ld      (hl),a
f3b8 2b        dec     hl
f3b9 1d        dec     e
f3ba f2b4f3    jp      p,$f3b4
f3bd 3e81      ld      a,$81
f3bf 2a0701    ld      hl,($0107)
f3c2 77        ld      (hl),a
f3c3 c334f6    jp      $f634
f3c6 0607      ld      b,$07
f3c8 2ab204    ld      hl,($04b2)
f3cb eb        ex      de,hl
f3cc 2ab404    ld      hl,($04b4)
f3cf 1a        ld      a,(de)
f3d0 8e        adc     a,(hl)
f3d1 12        ld      (de),a
f3d2 1b        dec     de
f3d3 2b        dec     hl
f3d4 05        dec     b
f3d5 c2cff3    jp      nz,$f3cf
f3d8 1a        ld      a,(de)
f3d9 ce00      adc     a,$00
f3db 12        ld      (de),a
f3dc 1b        dec     de
f3dd 0d        dec     c
f3de f2d8f3    jp      p,$f3d8
f3e1 c334f6    jp      $f634
f3e4 c5        push    bc
f3e5 2a0701    ld      hl,($0107)
f3e8 eb        ex      de,hl
f3e9 2a0901    ld      hl,($0109)
f3ec 1a        ld      a,(de)
f3ed ae        xor     (hl)
f3ee 12        ld      (de),a
f3ef 23        inc     hl
f3f0 13        inc     de
f3f1 1a        ld      a,(de)
f3f2 96        sub     (hl)
f3f3 4f        ld      c,a
f3f4 d5        push    de
f3f5 e5        push    hl
f3f6 7e        ld      a,(hl)
f3f7 fec0      cp      $c0
f3f9 c201f4    jp      nz,$f401
f3fc e1        pop     hl
f3fd e1        pop     hl
f3fe c3bff6    jp      $f6bf
f401 13        inc     de
f402 23        inc     hl
f403 0608      ld      b,$08
f405 13        inc     de
f406 23        inc     hl
f407 1a        ld      a,(de)
f408 be        cp      (hl)
f409 c220f4    jp      nz,$f420
f40c 05        dec     b
f40d c205f4    jp      nz,$f405
f410 e1        pop     hl
f411 e1        pop     hl
f412 0c        inc     c
f413 71        ld      (hl),c
f414 23        inc     hl
f415 3600      ld      (hl),$00
f417 23        inc     hl
f418 3601      ld      (hl),$01
f41a 0608      ld      b,$08
f41c af        xor     a
f41d c358f6    jp      $f658
f420 d1        pop     de
f421 e1        pop     hl
f422 71        ld      (hl),c
f423 da29f4    jp      c,$f429
f426 0c        inc     c
f427 71        ld      (hl),c
f428 2b        dec     hl
f429 d5        push    de
f42a 110900    ld      de,$0009
f42d 19        add     hl,de
f42e 0608      ld      b,$08
f430 11e404    ld      de,$04e4
f433 7e        ld      a,(hl)
f434 12        ld      (de),a
f435 2b        dec     hl
f436 13        inc     de
f437 05        dec     b
f438 c233f4    jp      nz,$f433
f43b e1        pop     hl
f43c 110900    ld      de,$0009
f43f 19        add     hl,de
f440 0608      ld      b,$08
f442 11ec04    ld      de,$04ec
f445 7e        ld      a,(hl)
f446 12        ld      (de),a
f447 2b        dec     hl
f448 13        inc     de
f449 05        dec     b
f44a c245f4    jp      nz,$f445
f44d 0608      ld      b,$08
f44f 21dc04    ld      hl,$04dc
f452 af        xor     a
f453 77        ld      (hl),a
f454 23        inc     hl
f455 05        dec     b
f456 c253f4    jp      nz,$f453
f459 3e40      ld      a,$40
f45b 32db04    ld      ($04db),a
f45e 21dc04    ld      hl,$04dc
f461 0610      ld      b,$10
f463 b7        or      a
f464 7e        ld      a,(hl)
f465 8f        adc     a,a
f466 77        ld      (hl),a
f467 23        inc     hl
f468 05        dec     b
f469 c264f4    jp      nz,$f464
f46c 9f        sbc     a,a
f46d e601      and     $01
f46f 4f        ld      c,a
f470 0608      ld      b,$08
f472 11e404    ld      de,$04e4
f475 21ec04    ld      hl,$04ec
f478 b7        or      a
f479 1a        ld      a,(de)
f47a 9e        sbc     a,(hl)
f47b 12        ld      (de),a
f47c 13        inc     de
f47d 23        inc     hl
f47e 05        dec     b
f47f c279f4    jp      nz,$f479
f482 79        ld      a,c
f483 de00      sbc     a,$00
f485 c296f4    jp      nz,$f496
f488 21dc04    ld      hl,$04dc
f48b 34        inc     (hl)
f48c 21db04    ld      hl,$04db
f48f 35        dec     (hl)
f490 c25ef4    jp      nz,$f45e
f493 c3c8f4    jp      $f4c8
f496 21db04    ld      hl,$04db
f499 35        dec     (hl)
f49a cac8f4    jp      z,$f4c8
f49d 21dc04    ld      hl,$04dc
f4a0 0610      ld      b,$10
f4a2 b7        or      a
f4a3 7e        ld      a,(hl)
f4a4 8f        adc     a,a
f4a5 77        ld      (hl),a
f4a6 23        inc     hl
f4a7 05        dec     b
f4a8 c2a3f4    jp      nz,$f4a3
f4ab 9f        sbc     a,a
f4ac 4f        ld      c,a
f4ad 0608      ld      b,$08
f4af 11e404    ld      de,$04e4
f4b2 21ec04    ld      hl,$04ec
f4b5 b7        or      a
f4b6 1a        ld      a,(de)
f4b7 8e        adc     a,(hl)
f4b8 12        ld      (de),a
f4b9 13        inc     de
f4ba 23        inc     hl
f4bb 05        dec     b
f4bc c2b6f4    jp      nz,$f4b6
f4bf 79        ld      a,c
f4c0 ce00      adc     a,$00
f4c2 c296f4    jp      nz,$f496
f4c5 c388f4    jp      $f488
f4c8 2a0701    ld      hl,($0107)
f4cb 110c00    ld      de,$000c
f4ce 19        add     hl,de
f4cf 3600      ld      (hl),$00
f4d1 2b        dec     hl
f4d2 3600      ld      (hl),$00
f4d4 11dc04    ld      de,$04dc
f4d7 0608      ld      b,$08
f4d9 2b        dec     hl
f4da 1a        ld      a,(de)
f4db 77        ld      (hl),a
f4dc 13        inc     de
f4dd 05        dec     b
f4de c2d9f4    jp      nz,$f4d9
f4e1 c334f6    jp      $f634
f4e4 c5        push    bc
f4e5 2a0701    ld      hl,($0107)
f4e8 eb        ex      de,hl
f4e9 2a0901    ld      hl,($0109)
f4ec 1a        ld      a,(de)
f4ed ae        xor     (hl)
f4ee 12        ld      (de),a
f4ef 23        inc     hl
f4f0 13        inc     de
f4f1 1a        ld      a,(de)
f4f2 fec0      cp      $c0
f4f4 ca4ef6    jp      z,$f64e
f4f7 86        add     a,(hl)
f4f8 12        ld      (de),a
f4f9 7e        ld      a,(hl)
f4fa fec0      cp      $c0
f4fc ca4ef6    jp      z,$f64e
f4ff d5        push    de
f500 110900    ld      de,$0009
f503 19        add     hl,de
f504 0608      ld      b,$08
f506 11ec04    ld      de,$04ec
f509 7e        ld      a,(hl)
f50a 12        ld      (de),a
f50b 2b        dec     hl
f50c 13        inc     de
f50d 05        dec     b
f50e c209f5    jp      nz,$f509
f511 e1        pop     hl
f512 110900    ld      de,$0009
f515 19        add     hl,de
f516 0608      ld      b,$08
f518 11e404    ld      de,$04e4
f51b 7e        ld      a,(hl)
f51c 12        ld      (de),a
f51d 2b        dec     hl
f51e 13        inc     de
f51f 05        dec     b
f520 c21bf5    jp      nz,$f51b
f523 0608      ld      b,$08
f525 21dc04    ld      hl,$04dc
f528 af        xor     a
f529 77        ld      (hl),a
f52a 23        inc     hl
f52b 05        dec     b
f52c c229f5    jp      nz,$f529
f52f 3e40      ld      a,$40
f531 32db04    ld      ($04db),a
f534 21dc04    ld      hl,$04dc
f537 0610      ld      b,$10
f539 b7        or      a
f53a 7e        ld      a,(hl)
f53b 8f        adc     a,a
f53c 77        ld      (hl),a
f53d 23        inc     hl
f53e 05        dec     b
f53f c23af5    jp      nz,$f53a
f542 d265f5    jp      nc,$f565
f545 0608      ld      b,$08
f547 11dc04    ld      de,$04dc
f54a 21ec04    ld      hl,$04ec
f54d b7        or      a
f54e 1a        ld      a,(de)
f54f 8e        adc     a,(hl)
f550 12        ld      (de),a
f551 13        inc     de
f552 23        inc     hl
f553 05        dec     b
f554 c24ef5    jp      nz,$f54e
f557 0608      ld      b,$08
f559 1a        ld      a,(de)
f55a ce00      adc     a,$00
f55c 12        ld      (de),a
f55d d265f5    jp      nc,$f565
f560 13        inc     de
f561 05        dec     b
f562 c259f5    jp      nz,$f559
f565 21db04    ld      hl,$04db
f568 35        dec     (hl)
f569 c234f5    jp      nz,$f534
f56c 2a0701    ld      hl,($0107)
f56f 110c00    ld      de,$000c
f572 19        add     hl,de
f573 11e204    ld      de,$04e2
f576 060a      ld      b,$0a
f578 1a        ld      a,(de)
f579 77        ld      (hl),a
f57a 13        inc     de
f57b 2b        dec     hl
f57c 05        dec     b
f57d c278f5    jp      nz,$f578
f580 c334f6    jp      $f634
f583 cdd2f2    call    $f2d2
f586 ca35fb    jp      z,$fb35
f589 c329fb    jp      $fb29
f58c cdd2f2    call    $f2d2
f58f ca29fb    jp      z,$fb29
f592 c335fb    jp      $fb35
f595 cdd2f2    call    $f2d2
f598 fa35fb    jp      m,$fb35
f59b c329fb    jp      $fb29
f59e cdd2f2    call    $f2d2
f5a1 fa35fb    jp      m,$fb35
f5a4 ca35fb    jp      z,$fb35
f5a7 c329fb    jp      $fb29
f5aa cdd2f2    call    $f2d2
f5ad fa29fb    jp      m,$fb29
f5b0 c335fb    jp      $fb35
f5b3 cdd2f2    call    $f2d2
f5b6 fa29fb    jp      m,$fb29
f5b9 ca29fb    jp      z,$fb29
f5bc c335fb    jp      $fb35
f5bf c5        push    bc
f5c0 7c        ld      a,h
f5c1 b5        or      l
f5c2 ca4ef6    jp      z,$f64e
f5c5 eb        ex      de,hl
f5c6 0600      ld      b,$00
f5c8 c3e1f5    jp      $f5e1
f5cb c5        push    bc
f5cc 7c        ld      a,h
f5cd b5        or      l
f5ce ca4ef6    jp      z,$f64e
f5d1 eb        ex      de,hl
f5d2 0600      ld      b,$00
f5d4 7a        ld      a,d
f5d5 b7        or      a
f5d6 f2e1f5    jp      p,$f5e1
f5d9 2f        cpl     
f5da 57        ld      d,a
f5db 7b        ld      a,e
f5dc 2f        cpl     
f5dd 5f        ld      e,a
f5de 13        inc     de
f5df 0680      ld      b,$80
f5e1 2a0701    ld      hl,($0107)
f5e4 70        ld      (hl),b
f5e5 23        inc     hl
f5e6 7a        ld      a,d
f5e7 b7        or      a
f5e8 c2f8f5    jp      nz,$f5f8
f5eb 3601      ld      (hl),$01
f5ed 23        inc     hl
f5ee 3600      ld      (hl),$00
f5f0 23        inc     hl
f5f1 73        ld      (hl),e
f5f2 0607      ld      b,$07
f5f4 af        xor     a
f5f5 c304f6    jp      $f604
f5f8 3602      ld      (hl),$02
f5fa 23        inc     hl
f5fb 3600      ld      (hl),$00
f5fd 23        inc     hl
f5fe 72        ld      (hl),d
f5ff 23        inc     hl
f600 73        ld      (hl),e
f601 0606      ld      b,$06
f603 af        xor     a
f604 23        inc     hl
f605 77        ld      (hl),a
f606 05        dec     b
f607 c204f6    jp      nz,$f604
f60a c392f6    jp      $f692
f60d 2a0701    ld      hl,($0107)
f610 110a00    ld      de,$000a
f613 19        add     hl,de
f614 7e        ld      a,(hl)
f615 fe80      cp      $80
f617 d8        ret     c

f618 c221f6    jp      nz,$f621
f61b 2b        dec     hl
f61c 7e        ld      a,(hl)
f61d f601      or      $01
f61f 77        ld      (hl),a
f620 c9        ret     

f621 c5        push    bc
f622 010008    ld      bc,$0800
f625 37        scf     
f626 2b        dec     hl
f627 7e        ld      a,(hl)
f628 89        adc     a,c
f629 77        ld      (hl),a
f62a 05        dec     b
f62b c226f6    jp      nz,$f626
f62e b7        or      a
f62f c234f6    jp      nz,$f634
f632 c1        pop     bc
f633 c9        ret     

f634 2a0701    ld      hl,($0107)
f637 23        inc     hl
f638 7e        ld      a,(hl)
f639 54        ld      d,h
f63a 5d        ld      e,l
f63b 23        inc     hl
f63c 4f        ld      c,a
f63d af        xor     a
f63e be        cp      (hl)
f63f c294f6    jp      nz,$f694
f642 0608      ld      b,$08
f644 23        inc     hl
f645 be        cp      (hl)
f646 c260f6    jp      nz,$f660
f649 0d        dec     c
f64a 05        dec     b
f64b c244f6    jp      nz,$f644
f64e af        xor     a
f64f 2a0701    ld      hl,($0107)
f652 060a      ld      b,$0a
f654 77        ld      (hl),a
f655 23        inc     hl
f656 36c0      ld      (hl),$c0
f658 23        inc     hl
f659 77        ld      (hl),a
f65a 05        dec     b
f65b c258f6    jp      nz,$f658
f65e c1        pop     bc
f65f c9        ret     

f660 3e08      ld      a,$08
f662 90        sub     b
f663 47        ld      b,a
f664 ca80f6    jp      z,$f680
f667 2b        dec     hl
f668 79        ld      a,c
f669 12        ld      (de),a
f66a d5        push    de
f66b 13        inc     de
f66c 3e0f      ld      a,$0f
f66e 90        sub     b
f66f 4f        ld      c,a
f670 7e        ld      a,(hl)
f671 12        ld      (de),a
f672 13        inc     de
f673 23        inc     hl
f674 0d        dec     c
f675 c270f6    jp      nz,$f670
f678 af        xor     a
f679 12        ld      (de),a
f67a 13        inc     de
f67b 05        dec     b
f67c c279f6    jp      nz,$f679
f67f d1        pop     de
f680 1a        ld      a,(de)
f681 b7        or      a
f682 fa8df6    jp      m,$f68d
f685 fe40      cp      $40
f687 da92f6    jp      c,$f692
f68a c3bff6    jp      $f6bf
f68d fec1      cp      $c1
f68f daaef6    jp      c,$f6ae
f692 c1        pop     bc
f693 c9        ret     

f694 0c        inc     c
f695 79        ld      a,c
f696 12        ld      (de),a
f697 060f      ld      b,$0f
f699 d5        push    de
f69a 211000    ld      hl,$0010
f69d 19        add     hl,de
f69e 54        ld      d,h
f69f 5d        ld      e,l
f6a0 1b        dec     de
f6a1 1a        ld      a,(de)
f6a2 77        ld      (hl),a
f6a3 2b        dec     hl
f6a4 05        dec     b
f6a5 c2a0f6    jp      nz,$f6a0
f6a8 3600      ld      (hl),$00
f6aa d1        pop     de
f6ab c380f6    jp      $f680
f6ae af        xor     a
f6af 2a0701    ld      hl,($0107)
f6b2 23        inc     hl
f6b3 36c1      ld      (hl),$c1
f6b5 23        inc     hl
f6b6 77        ld      (hl),a
f6b7 23        inc     hl
f6b8 3601      ld      (hl),$01
f6ba 0608      ld      b,$08
f6bc c358f6    jp      $f658
f6bf 2a0701    ld      hl,($0107)
f6c2 23        inc     hl
f6c3 363f      ld      (hl),$3f
f6c5 23        inc     hl
f6c6 3600      ld      (hl),$00
f6c8 3eff      ld      a,$ff
f6ca 0607      ld      b,$07
f6cc 23        inc     hl
f6cd 77        ld      (hl),a
f6ce 05        dec     b
f6cf c2ccf6    jp      nz,$f6cc
f6d2 23        inc     hl
f6d3 3600      ld      (hl),$00
f6d5 c1        pop     bc
f6d6 c9        ret     

f6d7 c5        push    bc
f6d8 2a0701    ld      hl,($0107)
f6db 3600      ld      (hl),$00
f6dd 23        inc     hl
f6de 3603      ld      (hl),$03
f6e0 110400    ld      de,$0004
f6e3 19        add     hl,de
f6e4 5d        ld      e,l
f6e5 54        ld      d,h
f6e6 0605      ld      b,$05
f6e8 af        xor     a
f6e9 23        inc     hl
f6ea 77        ld      (hl),a
f6eb 05        dec     b
f6ec c2e9f6    jp      nz,$f6e9
f6ef 0604      ld      b,$04
f6f1 2a0301    ld      hl,($0103)
f6f4 23        inc     hl
f6f5 23        inc     hl
f6f6 23        inc     hl
f6f7 7e        ld      a,(hl)
f6f8 2a0301    ld      hl,($0103)
f6fb b7        or      a
f6fc f210f7    jp      p,$f710
f6ff 3e00      ld      a,$00
f701 9e        sbc     a,(hl)
f702 12        ld      (de),a
f703 23        inc     hl
f704 1b        dec     de
f705 05        dec     b
f706 c2fff6    jp      nz,$f6ff
f709 1b        dec     de
f70a 3e80      ld      a,$80
f70c 12        ld      (de),a
f70d c334f6    jp      $f634
f710 7e        ld      a,(hl)
f711 12        ld      (de),a
f712 23        inc     hl
f713 1b        dec     de
f714 05        dec     b
f715 c210f7    jp      nz,$f710
f718 c334f6    jp      $f634
f71b c5        push    bc
f71c 2a0301    ld      hl,($0103)
f71f 54        ld      d,h
f720 5d        ld      e,l
f721 af        xor     a
f722 77        ld      (hl),a
f723 23        inc     hl
f724 77        ld      (hl),a
f725 23        inc     hl
f726 77        ld      (hl),a
f727 23        inc     hl
f728 77        ld      (hl),a
f729 2a0701    ld      hl,($0107)
f72c 4e        ld      c,(hl)
f72d 23        inc     hl
f72e 7e        ld      a,(hl)
f72f b7        or      a
f730 ca92f6    jp      z,$f692
f733 fa92f6    jp      m,$f692
f736 fe05      cp      $05
f738 d261f7    jp      nc,$f761
f73b 47        ld      b,a
f73c 23        inc     hl
f73d 85        add     a,l
f73e 6f        ld      l,a
f73f d243f7    jp      nc,$f743
f742 24        inc     h
f743 7e        ld      a,(hl)
f744 12        ld      (de),a
f745 13        inc     de
f746 2b        dec     hl
f747 05        dec     b
f748 c243f7    jp      nz,$f743
f74b 79        ld      a,c
f74c b7        or      a
f74d f292f6    jp      p,$f692
f750 0604      ld      b,$04
f752 2a0301    ld      hl,($0103)
f755 3e00      ld      a,$00
f757 9e        sbc     a,(hl)
f758 77        ld      (hl),a
f759 23        inc     hl
f75a 05        dec     b
f75b c255f7    jp      nz,$f755
f75e c392f6    jp      $f692
f761 eb        ex      de,hl
f762 79        ld      a,c
f763 b7        or      a
f764 fa75f7    jp      m,$f775
f767 367f      ld      (hl),$7f
f769 23        inc     hl
f76a 36ff      ld      (hl),$ff
f76c 23        inc     hl
f76d 36ff      ld      (hl),$ff
f76f 23        inc     hl
f770 36ff      ld      (hl),$ff
f772 c3dcf7    jp      $f7dc
f775 3680      ld      (hl),$80
f777 23        inc     hl
f778 3600      ld      (hl),$00
f77a 23        inc     hl
f77b 3600      ld      (hl),$00
f77d 23        inc     hl
f77e 3600      ld      (hl),$00
f780 c3dcf7    jp      $f7dc
f783 c5        push    bc
f784 0e00      ld      c,$00
f786 c38cf7    jp      $f78c
f789 c5        push    bc
f78a 0e01      ld      c,$01
f78c 2a0701    ld      hl,($0107)
f78f 46        ld      b,(hl)
f790 23        inc     hl
f791 7e        ld      a,(hl)
f792 b7        or      a
f793 ca99f7    jp      z,$f799
f796 f29ff7    jp      p,$f79f
f799 210000    ld      hl,$0000
f79c c392f6    jp      $f692
f79f fe03      cp      $03
f7a1 d2c3f7    jp      nc,$f7c3
f7a4 23        inc     hl
f7a5 85        add     a,l
f7a6 6f        ld      l,a
f7a7 d2abf7    jp      nc,$f7ab
f7aa 24        inc     h
f7ab 5e        ld      e,(hl)
f7ac 2b        dec     hl
f7ad 56        ld      d,(hl)
f7ae eb        ex      de,hl
f7af 79        ld      a,c
f7b0 b7        or      a
f7b1 ca92f6    jp      z,$f692
f7b4 78        ld      a,b
f7b5 b7        or      a
f7b6 f292f6    jp      p,$f692
f7b9 7c        ld      a,h
f7ba 2f        cpl     
f7bb 67        ld      h,a
f7bc 7d        ld      a,l
f7bd 2f        cpl     
f7be 6f        ld      l,a
f7bf 23        inc     hl
f7c0 c392f6    jp      $f692
f7c3 79        ld      a,c
f7c4 b7        or      a
f7c5 c2cef7    jp      nz,$f7ce
f7c8 21ffff    ld      hl,$ffff
f7cb c3dcf7    jp      $f7dc
f7ce 78        ld      a,b
f7cf b7        or      a
f7d0 fad9f7    jp      m,$f7d9
f7d3 21ff7f    ld      hl,$7fff
f7d6 c3dcf7    jp      $f7dc
f7d9 210080    ld      hl,$8000
f7dc c1        pop     bc
f7dd c9        ret     

f7de 40        ld      b,b
f7df 80        add     a,b
f7e0 00        nop     
f7e1 00        nop     
f7e2 00        nop     
f7e3 00        nop     
f7e4 00        nop     
f7e5 00        nop     
f7e6 40        ld      b,b
f7e7 0c        inc     c
f7e8 cccccc    call    z,$cccc
f7eb cccccd    call    z,$cdcc
f7ee 40        ld      b,b
f7ef 0147ae    ld      bc,$ae47
f7f2 14        inc     d
f7f3 7a        ld      a,d
f7f4 e1        pop     hl
f7f5 48        ld      c,b
f7f6 3f        ccf     
f7f7 20c4      jr      nz,$f7bd         ; (-$3c)
f7f9 9b        sbc     a,e
f7fa a5        and     l
f7fb e3        ex      (sp),hl
f7fc 54        ld      d,h
f7fd 00        nop     
f7fe 3f        ccf     
f7ff 03        inc     bc
f800 46        ld      b,(hl)
f801 dc5d63    call    c,$635d
f804 88        adc     a,b
f805 66        ld      h,(hl)
f806 3e53      ld      a,$53
f808 e2d623    jp      po,$23d6
f80b 8d        adc     a,l
f80c a3        and     e
f80d cd3e08    call    $083e
f810 63        ld      h,e
f811 7b        ld      a,e
f812 d0        ret     nc

f813 5a        ld      e,d
f814 f6c8      or      $c8
f816 3d        dec     a
f817 d6bf      sub     $bf
f819 94        sub     h
f81a d5        push    de
f81b e5        push    hl
f81c 7a        ld      a,d
f81d 66        ld      h,(hl)
f81e 3d        dec     a
f81f 15        dec     d
f820 79        ld      a,c
f821 8e        adc     a,(hl)
f822 e2308c    jp      po,$8c30
f825 3d        dec     a
f826 3d        dec     a
f827 02        ld      (bc),a
f828 25        dec     h
f829 c1        pop     bc
f82a 7d        ld      a,l
f82b 04        inc     b
f82c dad33c    jp      c,$3cd3
f82f 36f9      ld      (hl),$f9
f831 bf        cp      a
f832 b3        or      e
f833 af        xor     a
f834 7b        ld      a,e
f835 80        add     a,b
f836 3c        inc     a
f837 05        dec     b
f838 7f        ld      a,a
f839 5f        ld      e,a
f83a f8        ret     m

f83b 5e        ld      e,(hl)
f83c 59        ld      e,c
f83d 263b      ld      h,$3b
f83f 8c        adc     a,h
f840 bc        cp      h
f841 cc096f    call    z,$6f09
f844 50        ld      d,b
f845 9a        sbc     a,d
f846 3b        dec     sp
f847 0e12      ld      c,$12
f849 e1        pop     hl
f84a 34        inc     (hl)
f84b 24        inc     h
f84c bb        cp      e
f84d 43        ld      b,e
f84e 3b        dec     sp
f84f 016849    ld      bc,$4968
f852 b8        cp      b
f853 6a        ld      l,d
f854 12        ld      (de),a
f855 ba        cp      d
f856 3a2407    ld      a,($0724)
f859 5f        ld      e,a
f85a 3d        dec     a
f85b ceac      adc     a,$ac
f85d 33        inc     sp
f85e 3a039a    ld      a,($9a03)
f861 56        ld      d,(hl)
f862 52        ld      d,d
f863 fb        ei      
f864 1138c5    ld      de,$c538
f867 210c00    ld      hl,$000c
f86a 39        add     hl,sp
f86b 5e        ld      e,(hl)
f86c 23        inc     hl
f86d 56        ld      d,(hl)
f86e eb        ex      de,hl
f86f 22f404    ld      ($04f4),hl
f872 210400    ld      hl,$0004
f875 39        add     hl,sp
f876 cd09f2    call    $f209
f879 210f00    ld      hl,$000f
f87c 22f604    ld      ($04f6),hl
f87f 2a0701    ld      hl,($0107)
f882 7e        ld      a,(hl)
f883 b7        or      a
f884 f293f8    jp      p,$f893
f887 cdb5f2    call    $f2b5
f88a 2af404    ld      hl,($04f4)
f88d 362d      ld      (hl),$2d
f88f 23        inc     hl
f890 22f404    ld      ($04f4),hl
f893 010000    ld      bc,$0000
f896 cdbdf2    call    $f2bd
f899 ca19f9    jp      z,$f919
f89c cdf4f1    call    $f1f4
f89f 41        ld      b,c
f8a0 0a        ld      a,(bc)
f8a1 00        nop     
f8a2 00        nop     
f8a3 00        nop     
f8a4 00        nop     
f8a5 00        nop     
f8a6 00        nop     
f8a7 2a0701    ld      hl,($0107)
f8aa 23        inc     hl
f8ab 7e        ld      a,(hl)
f8ac fe01      cp      $01
f8ae fa12f9    jp      m,$f912
f8b1 caf9f8    jp      z,$f8f9
f8b4 fe02      cp      $02
f8b6 c2c1f8    jp      nz,$f8c1
f8b9 23        inc     hl
f8ba 23        inc     hl
f8bb 7e        ld      a,(hl)
f8bc fe27      cp      $27
f8be da01f9    jp      c,$f901
f8c1 cd12fa    call    $fa12
f8c4 cdf4f1    call    $f1f4
f8c7 40        ld      b,b
f8c8 19        add     hl,de
f8c9 99        sbc     a,c
f8ca 99        sbc     a,c
f8cb 99        sbc     a,c
f8cc 99        sbc     a,c
f8cd 99        sbc     a,c
f8ce 9a        sbc     a,d
f8cf cd1efa    call    $fa1e
f8d2 03        inc     bc
f8d3 cd95f5    call    $f595
f8d6 c2cff8    jp      nz,$f8cf
f8d9 cd12fa    call    $fa12
f8dc 2a0701    ld      hl,($0107)
f8df 23        inc     hl
f8e0 23        inc     hl
f8e1 23        inc     hl
f8e2 7e        ld      a,(hl)
f8e3 fe0a      cp      $0a
f8e5 da19f9    jp      c,$f919
f8e8 0b        dec     bc
f8e9 cd1efa    call    $fa1e
f8ec c319f9    jp      $f919
f8ef 2a0701    ld      hl,($0107)
f8f2 23        inc     hl
f8f3 7e        ld      a,(hl)
f8f4 fe01      cp      $01
f8f6 c201f9    jp      nz,$f901
f8f9 23        inc     hl
f8fa 23        inc     hl
f8fb 7e        ld      a,(hl)
f8fc fe0a      cp      $0a
f8fe da19f9    jp      c,$f919
f901 cde4f3    call    $f3e4
f904 03        inc     bc
f905 c3eff8    jp      $f8ef
f908 2a0701    ld      hl,($0107)
f90b 23        inc     hl
f90c 7e        ld      a,(hl)
f90d fe01      cp      $01
f90f f219f9    jp      p,$f919
f912 cd1efa    call    $fa1e
f915 0b        dec     bc
f916 c308f9    jp      $f908
f919 2af604    ld      hl,($04f6)
f91c 2b        dec     hl
f91d 29        add     hl,hl
f91e 29        add     hl,hl
f91f 29        add     hl,hl
f920 11def7    ld      de,$f7de
f923 19        add     hl,de
f924 cdfbf1    call    $f1fb
f927 cd0ff3    call    $f30f
f92a cdf4f1    call    $f1f4
f92d 41        ld      b,c
f92e 0a        ld      a,(bc)
f92f 00        nop     
f930 00        nop     
f931 00        nop     
f932 00        nop     
f933 00        nop     
f934 00        nop     
f935 cdaaf5    call    $f5aa
f938 ca49f9    jp      z,$f949
f93b 210100    ld      hl,$0001
f93e cdbff5    call    $f5bf
f941 03        inc     bc
f942 2af604    ld      hl,($04f6)
f945 23        inc     hl
f946 22f604    ld      ($04f6),hl
f949 60        ld      h,b
f94a 69        ld      l,c
f94b 22f804    ld      ($04f8),hl
f94e 3eff      ld      a,$ff
f950 32fa04    ld      ($04fa),a
f953 78        ld      a,b
f954 b7        or      a
f955 fa61f9    jp      m,$f961
f958 79        ld      a,c
f959 fe0f      cp      $0f
f95b d268f9    jp      nc,$f968
f95e c388f9    jp      $f988
f961 79        ld      a,c
f962 2f        cpl     
f963 fe01      cp      $01
f965 da6ff9    jp      c,$f96f
f968 af        xor     a
f969 32fa04    ld      ($04fa),a
f96c c388f9    jp      $f988
f96f 2af404    ld      hl,($04f4)
f972 3630      ld      (hl),$30
f974 23        inc     hl
f975 362e      ld      (hl),$2e
f977 23        inc     hl
f978 b7        or      a
f979 ca83f9    jp      z,$f983
f97c 3630      ld      (hl),$30
f97e 23        inc     hl
f97f 3d        dec     a
f980 c27cf9    jp      nz,$f97c
f983 22f404    ld      ($04f4),hl
f986 3eff      ld      a,$ff
f988 4f        ld      c,a
f989 06ff      ld      b,$ff
f98b 04        inc     b
f98c 3af604    ld      a,($04f6)
f98f b8        cp      b
f990 dabdf9    jp      c,$f9bd
f993 cabdf9    jp      z,$f9bd
f996 2a0701    ld      hl,($0107)
f999 23        inc     hl
f99a 7e        ld      a,(hl)
f99b fe01      cp      $01
f99d 3e30      ld      a,$30
f99f c2a7f9    jp      nz,$f9a7
f9a2 23        inc     hl
f9a3 23        inc     hl
f9a4 86        add     a,(hl)
f9a5 3600      ld      (hl),$00
f9a7 2af404    ld      hl,($04f4)
f9aa 77        ld      (hl),a
f9ab 23        inc     hl
f9ac 78        ld      a,b
f9ad b9        cp      c
f9ae c2b4f9    jp      nz,$f9b4
f9b1 362e      ld      (hl),$2e
f9b3 23        inc     hl
f9b4 22f404    ld      ($04f4),hl
f9b7 cd1efa    call    $fa1e
f9ba c38bf9    jp      $f98b
f9bd 2af404    ld      hl,($04f4)
f9c0 2b        dec     hl
f9c1 7e        ld      a,(hl)
f9c2 fe30      cp      $30
f9c4 cac0f9    jp      z,$f9c0
f9c7 3afa04    ld      a,($04fa)
f9ca b7        or      a
f9cb cad8f9    jp      z,$f9d8
f9ce 7e        ld      a,(hl)
f9cf fe2e      cp      $2e
f9d1 ca0efa    jp      z,$fa0e
f9d4 23        inc     hl
f9d5 c30efa    jp      $fa0e
f9d8 23        inc     hl
f9d9 3665      ld      (hl),$65
f9db 23        inc     hl
f9dc 362b      ld      (hl),$2b
f9de 3af904    ld      a,($04f9)
f9e1 b7        or      a
f9e2 3af804    ld      a,($04f8)
f9e5 f2ecf9    jp      p,$f9ec
f9e8 362d      ld      (hl),$2d
f9ea 2f        cpl     
f9eb 3c        inc     a
f9ec 23        inc     hl
f9ed fe64      cp      $64
f9ef daf7f9    jp      c,$f9f7
f9f2 3631      ld      (hl),$31
f9f4 23        inc     hl
f9f5 d664      sub     $64
f9f7 0600      ld      b,$00
f9f9 fe0a      cp      $0a
f9fb da04fa    jp      c,$fa04
f9fe 04        inc     b
f9ff d60a      sub     $0a
fa01 c3f9f9    jp      $f9f9
fa04 c630      add     a,$30
fa06 5f        ld      e,a
fa07 3e30      ld      a,$30
fa09 80        add     a,b
fa0a 77        ld      (hl),a
fa0b 23        inc     hl
fa0c 73        ld      (hl),e
fa0d 23        inc     hl
fa0e 3600      ld      (hl),$00
fa10 c1        pop     bc
fa11 c9        ret     

fa12 cda6f2    call    $f2a6
fa15 210100    ld      hl,$0001
fa18 cdbff5    call    $f5bf
fa1b c3e4f3    jp      $f3e4
fa1e c5        push    bc
fa1f 2a0701    ld      hl,($0107)
fa22 23        inc     hl
fa23 34        inc     (hl)
fa24 110900    ld      de,$0009
fa27 19        add     hl,de
fa28 af        xor     a
fa29 0608      ld      b,$08
fa2b c5        push    bc
fa2c 5e        ld      e,(hl)
fa2d eb        ex      de,hl
fa2e 2600      ld      h,$00
fa30 29        add     hl,hl
fa31 44        ld      b,h
fa32 4d        ld      c,l
fa33 29        add     hl,hl
fa34 29        add     hl,hl
fa35 09        add     hl,bc
fa36 eb        ex      de,hl
fa37 83        add     a,e
fa38 23        inc     hl
fa39 77        ld      (hl),a
fa3a 7a        ld      a,d
fa3b ce00      adc     a,$00
fa3d 2b        dec     hl
fa3e 2b        dec     hl
fa3f c1        pop     bc
fa40 05        dec     b
fa41 c22bfa    jp      nz,$fa2b
fa44 23        inc     hl
fa45 77        ld      (hl),a
fa46 b7        or      a
fa47 ca34f6    jp      z,$f634
fa4a 2b        dec     hl
fa4b 2b        dec     hl
fa4c 7e        ld      a,(hl)
fa4d b7        or      a
fa4e fa56fa    jp      m,$fa56
fa51 fe40      cp      $40
fa53 d2bff6    jp      nc,$f6bf
fa56 c1        pop     bc
fa57 c9        ret     

fa58 cd90ff    call    $ff90
fa5b 210800    ld      hl,$0008
fa5e 39        add     hl,sp
fa5f 4e        ld      c,(hl)
fa60 23        inc     hl
fa61 46        ld      b,(hl)
fa62 50        ld      d,b
fa63 59        ld      e,c
fa64 216100    ld      hl,$0061
fa67 cd3dfb    call    $fb3d
fa6a 2813      jr      z,$fa7f          ; (+$13)
fa6c 50        ld      d,b
fa6d 59        ld      e,c
fa6e 217a00    ld      hl,$007a
fa71 cd3efb    call    $fb3e
fa74 2809      jr      z,$fa7f          ; (+$09)
fa76 60        ld      h,b
fa77 69        ld      l,c
fa78 112000    ld      de,$0020
fa7b cd6cfc    call    $fc6c
fa7e c9        ret     

fa7f 60        ld      h,b
fa80 69        ld      l,c
fa81 c9        ret     

fa82 cd90ff    call    $ff90
fa85 210800    ld      hl,$0008
fa88 39        add     hl,sp
fa89 4e        ld      c,(hl)
fa8a 23        inc     hl
fa8b 46        ld      b,(hl)
fa8c 50        ld      d,b
fa8d 59        ld      e,c
fa8e 214100    ld      hl,$0041
fa91 cd3dfb    call    $fb3d
fa94 2813      jr      z,$faa9          ; (+$13)
fa96 50        ld      d,b
fa97 59        ld      e,c
fa98 215a00    ld      hl,$005a
fa9b cd3efb    call    $fb3e
fa9e 2809      jr      z,$faa9          ; (+$09)
faa0 60        ld      h,b
faa1 69        ld      l,c
faa2 112000    ld      de,$0020
faa5 cd6cfc    call    $fc6c
faa8 c9        ret     

faa9 60        ld      h,b
faaa 69        ld      l,c
faab c9        ret     

faac cd90ff    call    $ff90
faaf 210800    ld      hl,$0008
fab2 39        add     hl,sp
fab3 4e        ld      c,(hl)
fab4 23        inc     hl
fab5 46        ld      b,(hl)
fab6 60        ld      h,b
fab7 69        ld      l,c
fab8 112000    ld      de,$0020
fabb cd24fb    call    $fb24
fabe 2018      jr      nz,$fad8         ; (+$18)
fac0 60        ld      h,b
fac1 69        ld      l,c
fac2 110900    ld      de,$0009
fac5 cd24fb    call    $fb24
fac8 200e      jr      nz,$fad8         ; (+$0e)
faca 60        ld      h,b
facb 69        ld      l,c
facc 110a00    ld      de,$000a
facf cd24fb    call    $fb24
fad2 2004      jr      nz,$fad8         ; (+$04)
fad4 210000    ld      hl,$0000
fad7 c9        ret     

fad8 210100    ld      hl,$0001
fadb c9        ret     

fadc 7c        ld      a,h
fadd a2        and     d
fade 67        ld      h,a
fadf 7d        ld      a,l
fae0 a3        and     e
fae1 6f        ld      l,a
fae2 b4        or      h
fae3 c9        ret     

fae4 7c        ld      a,h
fae5 2f        cpl     
fae6 67        ld      h,a
fae7 7d        ld      a,l
fae8 2f        cpl     
fae9 6f        ld      l,a
faea b4        or      h
faeb c9        ret     

faec e9        jp      (hl)
faed e1        pop     hl
faee c5        push    bc
faef 5e        ld      e,(hl)
faf0 23        inc     hl
faf1 56        ld      d,(hl)
faf2 23        inc     hl
faf3 44        ld      b,h
faf4 4d        ld      c,l
faf5 210000    ld      hl,$0000
faf8 39        add     hl,sp
faf9 eb        ex      de,hl
fafa 39        add     hl,sp
fafb f9        ld      sp,hl
fafc d5        push    de
fafd 60        ld      h,b
fafe 69        ld      l,c
faff cdecfa    call    $faec
fb02 eb        ex      de,hl
fb03 e1        pop     hl
fb04 f9        ld      sp,hl
fb05 c1        pop     bc
fb06 eb        ex      de,hl
fb07 7c        ld      a,h
fb08 b5        or      l
fb09 c9        ret     

fb0a 7a        ld      a,d
fb0b ac        xor     h
fb0c 32fc04    ld      ($04fc),a
fb0f cd7bfb    call    $fb7b
fb12 eb        ex      de,hl
fb13 3afc04    ld      a,($04fc)
fb16 b7        or      a
fb17 fad4fb    jp      m,$fbd4
fb1a 7d        ld      a,l
fb1b b4        or      h
fb1c c9        ret     

fb1d cd94fb    call    $fb94
fb20 eb        ex      de,hl
fb21 7d        ld      a,l
fb22 b4        or      h
fb23 c9        ret     

fb24 a7        and     a
fb25 ed52      sbc     hl,de
fb27 280c      jr      z,$fb35          ; (+$0c)
fb29 210000    ld      hl,$0000
fb2c af        xor     a
fb2d 54        ld      d,h
fb2e 5d        ld      e,l
fb2f c9        ret     

fb30 a7        and     a
fb31 ed52      sbc     hl,de
fb33 28f4      jr      z,$fb29          ; (-$0c)
fb35 210100    ld      hl,$0001
fb38 7d        ld      a,l
fb39 b4        or      h
fb3a 54        ld      d,h
fb3b 5d        ld      e,l
fb3c c9        ret     

fb3d eb        ex      de,hl
fb3e 7c        ld      a,h
fb3f aa        xor     d
fb40 fa4cfb    jp      m,$fb4c
fb43 af        xor     a
fb44 ed52      sbc     hl,de
fb46 67        ld      h,a
fb47 3f        ccf     
fb48 ce00      adc     a,$00
fb4a 6f        ld      l,a
fb4b c9        ret     

fb4c 7a        ld      a,d
fb4d 07        rlca    
fb4e e601      and     $01
fb50 6f        ld      l,a
fb51 2600      ld      h,$00
fb53 c9        ret     

fb54 eb        ex      de,hl
fb55 7c        ld      a,h
fb56 aa        xor     d
fb57 fa62fb    jp      m,$fb62
fb5a af        xor     a
fb5b ed52      sbc     hl,de
fb5d 67        ld      h,a
fb5e ce00      adc     a,$00
fb60 6f        ld      l,a
fb61 c9        ret     

fb62 7c        ld      a,h
fb63 07        rlca    
fb64 e601      and     $01
fb66 6f        ld      l,a
fb67 2600      ld      h,$00
fb69 c9        ret     

fb6a 7a        ld      a,d
fb6b 32fc04    ld      ($04fc),a
fb6e cd7bfb    call    $fb7b
fb71 3afc04    ld      a,($04fc)
fb74 b7        or      a
fb75 fad4fb    jp      m,$fbd4
fb78 7c        ld      a,h
fb79 b5        or      l
fb7a c9        ret     

fb7b 7c        ld      a,h
fb7c b7        or      a
fb7d f286fb    jp      p,$fb86
fb80 2f        cpl     
fb81 67        ld      h,a
fb82 7d        ld      a,l
fb83 2f        cpl     
fb84 6f        ld      l,a
fb85 23        inc     hl
fb86 7a        ld      a,d
fb87 b7        or      a
fb88 f294fb    jp      p,$fb94
fb8b 2f        cpl     
fb8c 57        ld      d,a
fb8d 7b        ld      a,e
fb8e 2f        cpl     
fb8f 5f        ld      e,a
fb90 13        inc     de
fb91 c394fb    jp      $fb94
fb94 c5        push    bc
fb95 44        ld      b,h
fb96 4d        ld      c,l
fb97 210000    ld      hl,$0000
fb9a 3e10      ld      a,$10
fb9c 29        add     hl,hl
fb9d eb        ex      de,hl
fb9e 29        add     hl,hl
fb9f eb        ex      de,hl
fba0 d2a4fb    jp      nc,$fba4
fba3 23        inc     hl
fba4 a7        and     a
fba5 ed42      sbc     hl,bc
fba7 d2b3fb    jp      nc,$fbb3
fbaa 09        add     hl,bc
fbab 3d        dec     a
fbac c29cfb    jp      nz,$fb9c
fbaf c1        pop     bc
fbb0 7d        ld      a,l
fbb1 b4        or      h
fbb2 c9        ret     

fbb3 13        inc     de
fbb4 3d        dec     a
fbb5 c29cfb    jp      nz,$fb9c
fbb8 c1        pop     bc
fbb9 7d        ld      a,l
fbba b4        or      h
fbbb c9        ret     

fbbc c5        push    bc
fbbd 44        ld      b,h
fbbe 4d        ld      c,l
fbbf 210000    ld      hl,$0000
fbc2 3e10      ld      a,$10
fbc4 29        add     hl,hl
fbc5 eb        ex      de,hl
fbc6 29        add     hl,hl
fbc7 eb        ex      de,hl
fbc8 d2ccfb    jp      nc,$fbcc
fbcb 09        add     hl,bc
fbcc 3d        dec     a
fbcd c2c4fb    jp      nz,$fbc4
fbd0 c1        pop     bc
fbd1 7d        ld      a,l
fbd2 b4        or      h
fbd3 c9        ret     

;;===============================================================
;; HL = -HL

fbd4 7d        ld      a,l
fbd5 2f        cpl     
fbd6 6f        ld      l,a
fbd7 7c        ld      a,h
fbd8 2f        cpl     
fbd9 67        ld      h,a
fbda 23        inc     hl
fbdb 7d        ld      a,l
fbdc b4        or      h
fbdd c9        ret     

;;===============================================================

fbde 7c        ld      a,h
fbdf b5        or      l
fbe0 ca35fb    jp      z,$fb35
fbe3 c329fb    jp      $fb29

;;===============================================================

fbe6 7c        ld      a,h
fbe7 b2        or      d
fbe8 67        ld      h,a
fbe9 7d        ld      a,l
fbea b3        or      e
fbeb 6f        ld      l,a
fbec b4        or      h
fbed c9        ret     

fbee eb        ex      de,hl
fbef 7b        ld      a,e
fbf0 e61f      and     $1f
fbf2 5f        ld      e,a
fbf3 ca15fc    jp      z,$fc15
fbf6 7c        ld      a,h
fbf7 b4        or      h
fbf8 f25ffc    jp      p,$fc5f
fbfb 7c        ld      a,h
fbfc 37        scf     
fbfd 1f        rra     
fbfe 67        ld      h,a
fbff 7d        ld      a,l
fc00 1f        rra     
fc01 6f        ld      l,a
fc02 1d        dec     e
fc03 c2fbfb    jp      nz,$fbfb
fc06 b4        or      h
fc07 c9        ret     

fc08 eb        ex      de,hl
fc09 7b        ld      a,e
fc0a e61f      and     $1f
fc0c 5f        ld      e,a
fc0d ca15fc    jp      z,$fc15
fc10 29        add     hl,hl
fc11 1d        dec     e
fc12 c210fc    jp      nz,$fc10
fc15 7d        ld      a,l
fc16 b4        or      h
fc17 c9        ret     

fc18 eb        ex      de,hl
fc19 a7        and     a
fc1a ed52      sbc     hl,de
fc1c c9        ret     

fc1d eb        ex      de,hl
fc1e e1        pop     hl
fc1f c5        push    bc
fc20 42        ld      b,d
fc21 4b        ld      c,e
fc22 5e        ld      e,(hl)
fc23 23        inc     hl
fc24 56        ld      d,(hl)
fc25 1b        dec     de
fc26 7a        ld      a,d
fc27 b7        or      a
fc28 fa3dfc    jp      m,$fc3d
fc2b 23        inc     hl
fc2c 79        ld      a,c
fc2d be        cp      (hl)
fc2e ca37fc    jp      z,$fc37
fc31 23        inc     hl
fc32 23        inc     hl
fc33 23        inc     hl
fc34 c325fc    jp      $fc25
fc37 23        inc     hl
fc38 78        ld      a,b
fc39 be        cp      (hl)
fc3a c232fc    jp      nz,$fc32
fc3d 23        inc     hl
fc3e 7e        ld      a,(hl)
fc3f 23        inc     hl
fc40 66        ld      h,(hl)
fc41 6f        ld      l,a
fc42 c1        pop     bc
fc43 e9        jp      (hl)
fc44 eb        ex      de,hl
fc45 af        xor     a
fc46 ed52      sbc     hl,de
fc48 67        ld      h,a
fc49 3f        ccf     
fc4a ce00      adc     a,$00
fc4c 6f        ld      l,a
fc4d c9        ret     

fc4e eb        ex      de,hl
fc4f af        xor     a
fc50 ed52      sbc     hl,de
fc52 67        ld      h,a
fc53 ce00      adc     a,$00
fc55 6f        ld      l,a
fc56 c9        ret     

fc57 eb        ex      de,hl
fc58 7b        ld      a,e
fc59 e61f      and     $1f
fc5b 5f        ld      e,a
fc5c ca15fc    jp      z,$fc15
fc5f 7c        ld      a,h
fc60 b7        or      a
fc61 1f        rra     
fc62 67        ld      h,a
fc63 7d        ld      a,l
fc64 1f        rra     
fc65 6f        ld      l,a
fc66 1d        dec     e
fc67 c25ffc    jp      nz,$fc5f
fc6a b4        or      h
fc6b c9        ret     

fc6c 7c        ld      a,h
fc6d aa        xor     d
fc6e 67        ld      h,a
fc6f 7d        ld      a,l
fc70 ab        xor     e
fc71 6f        ld      l,a
fc72 b4        or      h
fc73 c9        ret     

fc74 d1        pop     de
fc75 210200    ld      hl,$0002
fc78 39        add     hl,sp
fc79 c5        push    bc
fc7a d5        push    de
fc7b 11fd04    ld      de,$04fd
fc7e 010600    ld      bc,$0006
fc81 edb0      ldir    
fc83 2188fc    ld      hl,$fc88
fc86 e3        ex      (sp),hl
fc87 e9        jp      (hl)
fc88 c1        pop     bc
fc89 7c        ld      a,h
fc8a b5        or      l
fc8b c9        ret     

fc8c 23        inc     hl
fc8d 23        inc     hl
fc8e 7e        ld      a,(hl)
fc8f 23        inc     hl
fc90 66        ld      h,(hl)
fc91 6f        ld      l,a
fc92 b4        or      h
fc93 c9        ret     

fc94 c5        push    bc
fc95 af        xor     a
fc96 320305    ld      ($0503),a
fc99 320405    ld      ($0504),a
fc9c 320505    ld      ($0505),a
fc9f 6f        ld      l,a
fca0 67        ld      h,a
fca1 220605    ld      ($0506),hl
fca4 cdbff5    call    $f5bf
fca7 210400    ld      hl,$0004
fcaa 39        add     hl,sp
fcab 4e        ld      c,(hl)
fcac 23        inc     hl
fcad 46        ld      b,(hl)
fcae 0a        ld      a,(bc)
fcaf fe2d      cp      $2d
fcb1 c2bafc    jp      nz,$fcba
fcb4 320305    ld      ($0503),a
fcb7 c3bffc    jp      $fcbf
fcba fe2b      cp      $2b
fcbc c2c0fc    jp      nz,$fcc0
fcbf 03        inc     bc
fcc0 0a        ld      a,(bc)
fcc1 fe30      cp      $30
fcc3 daeffc    jp      c,$fcef
fcc6 fe3a      cp      $3a
fcc8 d2effc    jp      nc,$fcef
fccb f5        push    af
fccc cd1efa    call    $fa1e
fccf cda6f2    call    $f2a6
fcd2 f1        pop     af
fcd3 d630      sub     $30
fcd5 6f        ld      l,a
fcd6 2600      ld      h,$00
fcd8 cdbff5    call    $f5bf
fcdb cd0ff3    call    $f30f
fcde 3a0505    ld      a,($0505)
fce1 b7        or      a
fce2 cabffc    jp      z,$fcbf
fce5 2a0605    ld      hl,($0506)
fce8 2b        dec     hl
fce9 220605    ld      ($0506),hl
fcec c3bffc    jp      $fcbf
fcef fe2e      cp      $2e
fcf1 c201fd    jp      nz,$fd01
fcf4 210505    ld      hl,$0505
fcf7 7e        ld      a,(hl)
fcf8 b7        or      a
fcf9 c201fd    jp      nz,$fd01
fcfc 3601      ld      (hl),$01
fcfe c3bffc    jp      $fcbf
fd01 210000    ld      hl,$0000
fd04 f620      or      $20
fd06 fe65      cp      $65
fd08 c24efd    jp      nz,$fd4e
fd0b 03        inc     bc
fd0c 0a        ld      a,(bc)
fd0d fe2d      cp      $2d
fd0f c218fd    jp      nz,$fd18
fd12 320405    ld      ($0504),a
fd15 c31dfd    jp      $fd1d
fd18 fe2b      cp      $2b
fd1a c21efd    jp      nz,$fd1e
fd1d 03        inc     bc
fd1e 0a        ld      a,(bc)
fd1f fe30      cp      $30
fd21 da38fd    jp      c,$fd38
fd24 fe3a      cp      $3a
fd26 d238fd    jp      nc,$fd38
fd29 d630      sub     $30
fd2b 29        add     hl,hl
fd2c 54        ld      d,h
fd2d 5d        ld      e,l
fd2e 29        add     hl,hl
fd2f 29        add     hl,hl
fd30 19        add     hl,de
fd31 5f        ld      e,a
fd32 1600      ld      d,$00
fd34 19        add     hl,de
fd35 c31dfd    jp      $fd1d
fd38 3a0405    ld      a,($0504)
fd3b b7        or      a
fd3c ca46fd    jp      z,$fd46
fd3f 7c        ld      a,h
fd40 2f        cpl     
fd41 67        ld      h,a
fd42 7d        ld      a,l
fd43 2f        cpl     
fd44 6f        ld      l,a
fd45 23        inc     hl
fd46 eb        ex      de,hl
fd47 2a0605    ld      hl,($0506)
fd4a 19        add     hl,de
fd4b 220605    ld      ($0506),hl
fd4e 2a0605    ld      hl,($0506)
fd51 7c        ld      a,h
fd52 b7        or      a
fd53 f294fd    jp      p,$fd94
fd56 feff      cp      $ff
fd58 c2aefd    jp      nz,$fdae
fd5b 7d        ld      a,l
fd5c 2f        cpl     
fd5d 3c        inc     a
fd5e 4f        ld      c,a
fd5f fea6      cp      $a6
fd61 d2aefd    jp      nc,$fdae
fd64 fe96      cp      $96
fd66 da7bfd    jp      c,$fd7b
fd69 cdf4f1    call    $f1f4
fd6c 47        ld      b,a
fd6d 23        inc     hl
fd6e 86        add     a,(hl)
fd6f f26fc1    jp      p,$c16f
fd72 00        nop     
fd73 00        nop     
fd74 cde4f3    call    $f3e4
fd77 79        ld      a,c
fd78 d610      sub     $10
fd7a 4f        ld      c,a
fd7b cda6f2    call    $f2a6
fd7e 210100    ld      hl,$0001
fd81 cdbff5    call    $f5bf
fd84 cd1efa    call    $fa1e
fd87 0d        dec     c
fd88 c284fd    jp      nz,$fd84
fd8b cda6f2    call    $f2a6
fd8e cde4f3    call    $f3e4
fd91 c3a4fd    jp      $fda4
fd94 c2aefd    jp      nz,$fdae
fd97 7d        ld      a,l
fd98 b7        or      a
fd99 caa4fd    jp      z,$fda4
fd9c 4f        ld      c,a
fd9d cd1efa    call    $fa1e
fda0 0d        dec     c
fda1 c29dfd    jp      nz,$fd9d
fda4 3a0305    ld      a,($0503)
fda7 b7        or      a
fda8 caaefd    jp      z,$fdae
fdab cdb5f2    call    $f2b5
fdae c1        pop     bc
fdaf c9        ret     

fdb0 cd90ff    call    $ff90
fdb3 210800    ld      hl,$0008
fdb6 39        add     hl,sp
fdb7 e5        push    hl
fdb8 210a00    ld      hl,$000a
fdbb 39        add     hl,sp
fdbc cd09f2    call    $f209
fdbf cdf4f1    call    $f1f4
fdc2 41        ld      b,c
fdc3 5a        ld      e,d
fdc4 00        nop     
fdc5 00        nop     
fdc6 00        nop     
fdc7 00        nop     
fdc8 00        nop     
fdc9 00        nop     
fdca cd0ff3    call    $f30f
fdcd e1        pop     hl
fdce cd28f2    call    $f228
fdd1 210800    ld      hl,$0008
fdd4 39        add     hl,sp
fdd5 cd09f2    call    $f209
fdd8 cd4af2    call    $f24a
fddb cde2fd    call    $fde2
fdde cd87ff    call    $ff87
fde1 c9        ret     


;;===============================================================================================

fde2 cdedfa    call    $faed
fde5 f8        ret     m

fde6 ff        rst     $38
fde7 211000    ld      hl,$0010
fdea 39        add     hl,sp
fdeb cd09f2    call    $f209
fdee 21cf01    ld      hl,$01cf
fdf1 cdfbf1    call    $f1fb
fdf4 cd95f5    call    $f595
fdf7 281e      jr      z,$fe17          ; (+$1e)
fdf9 211000    ld      hl,$0010
fdfc 39        add     hl,sp
fdfd e5        push    hl
fdfe cd02f2    call    $f202
fe01 41        ld      b,c
fe02 b4        or      h
fe03 00        nop     
fe04 00        nop     
fe05 00        nop     
fe06 00        nop     
fe07 00        nop     
fe08 00        nop     
fe09 211200    ld      hl,$0012
fe0c 39        add     hl,sp
fe0d cdfbf1    call    $f1fb
fe10 cd08f3    call    $f308
fe13 e1        pop     hl
fe14 cd28f2    call    $f228
fe17 211000    ld      hl,$0010
fe1a 39        add     hl,sp
fe1b cd09f2    call    $f209
fe1e cdf4f1    call    $f1f4
fe21 44        ld      b,h
fe22 3b        dec     sp
fe23 9a        sbc     a,d
fe24 ca0000    jp      z,$0000
fe27 00        nop     
fe28 00        nop     
fe29 cdb3f5    call    $f5b3
fe2c 280c      jr      z,$fe3a          ; (+$0c)
fe2e cd02f2    call    $f202
fe31 00        nop     
fe32 00        nop     
fe33 00        nop     
fe34 00        nop     
fe35 00        nop     
fe36 00        nop     
fe37 00        nop     
fe38 00        nop     
fe39 c9        ret     

fe3a 211000    ld      hl,$0010
fe3d 39        add     hl,sp
fe3e e5        push    hl
fe3f 211200    ld      hl,$0012
fe42 39        add     hl,sp
fe43 cd09f2    call    $f209
fe46 cd4af2    call    $f24a
fe49 cd45ec    call    $ec45
fe4c cd87ff    call    $ff87
fe4f e1        pop     hl
fe50 cd28f2    call    $f228
fe53 211000    ld      hl,$0010
fe56 39        add     hl,sp
fe57 cd09f2    call    $f209
fe5a cdf4f1    call    $f1f4
fe5d 42        ld      b,d
fe5e 010e00    ld      bc,$000e
fe61 00        nop     
fe62 00        nop     
fe63 00        nop     
fe64 00        nop     
fe65 cdb3f5    call    $f5b3
fe68 281e      jr      z,$fe88          ; (+$1e)
fe6a 211000    ld      hl,$0010
fe6d 39        add     hl,sp
fe6e e5        push    hl
fe6f cd02f2    call    $f202
fe72 42        ld      b,d
fe73 02        ld      (bc),a
fe74 1c        inc     e
fe75 00        nop     
fe76 00        nop     
fe77 00        nop     
fe78 00        nop     
fe79 00        nop     
fe7a 211200    ld      hl,$0012
fe7d 39        add     hl,sp
fe7e cdfbf1    call    $f1fb
fe81 cd08f3    call    $f308
fe84 e1        pop     hl
fe85 cd28f2    call    $f228
fe88 211000    ld      hl,$0010
fe8b 39        add     hl,sp
fe8c cd09f2    call    $f209
fe8f cdf4f1    call    $f1f4
fe92 41        ld      b,c
fe93 5a        ld      e,d
fe94 00        nop     
fe95 00        nop     
fe96 00        nop     
fe97 00        nop     
fe98 00        nop     
fe99 00        nop     
fe9a cdb3f5    call    $f5b3
fe9d 281e      jr      z,$febd          ; (+$1e)
fe9f 211000    ld      hl,$0010
fea2 39        add     hl,sp
fea3 e5        push    hl
fea4 cd02f2    call    $f202
fea7 41        ld      b,c
fea8 b4        or      h
fea9 00        nop     
feaa 00        nop     
feab 00        nop     
feac 00        nop     
fead 00        nop     
feae 00        nop     
feaf 211200    ld      hl,$0012
feb2 39        add     hl,sp
feb3 cdfbf1    call    $f1fb
feb6 cd08f3    call    $f308
feb9 e1        pop     hl
feba cd28f2    call    $f228
febd 211000    ld      hl,$0010
fec0 39        add     hl,sp
fec1 e5        push    hl
fec2 21d701    ld      hl,$01d7
fec5 cd09f2    call    $f209
fec8 cda6f2    call    $f2a6
fecb e1        pop     hl
fecc e5        push    hl
fecd cd09f2    call    $f209
fed0 cde4f3    call    $f3e4
fed3 e1        pop     hl
fed4 cd28f2    call    $f228
fed7 210400    ld      hl,$0004
feda 39        add     hl,sp
fedb e5        push    hl
fedc 211200    ld      hl,$0012
fedf 39        add     hl,sp
fee0 cd09f2    call    $f209
fee3 211200    ld      hl,$0012
fee6 39        add     hl,sp
fee7 cdfbf1    call    $f1fb
feea cde4f4    call    $f4e4
feed e1        pop     hl
feee cd28f2    call    $f228
fef1 210400    ld      hl,$0004
fef4 39        add     hl,sp
fef5 cd09f2    call    $f209
fef8 cdf4f1    call    $f1f4
fefb 3e2e      ld      a,$2e
fefd 2e53      ld      l,$53
feff b4        or      h
ff00 e4cce9    call    po,$e9cc
ff03 cde4f4    call    $f4e4
ff06 cdf4f1    call    $f1f4
ff09 bf        cp      a
ff0a 0d        dec     c
ff0b 00        nop     
ff0c c0        ret     nz

ff0d 2a8e2f    ld      hl,($2f8e)
ff10 3ecd      ld      a,$cd
ff12 0f        rrca    
ff13 f3        di      
ff14 210400    ld      hl,$0004
ff17 39        add     hl,sp
ff18 cdfbf1    call    $f1fb
ff1b cde4f4    call    $f4e4
ff1e cdf4f1    call    $f1f4
ff21 40        ld      b,b
ff22 02        ld      (bc),a
ff23 22221a    ld      ($1a22),hl
ff26 42        ld      b,d
ff27 5c        ld      e,h
ff28 ad        xor     l
ff29 cd0ff3    call    $f30f
ff2c 210400    ld      hl,$0004
ff2f 39        add     hl,sp
ff30 cdfbf1    call    $f1fb
ff33 cde4f4    call    $f4e4
ff36 cdf4f1    call    $f1f4
ff39 c0        ret     nz

ff3a 2aaaaa    ld      hl,($aaaa)
ff3d a9        xor     c
ff3e 85        add     a,l
ff3f 76        halt    
ff40 ac        xor     h
ff41 cd0ff3    call    $f30f
ff44 210400    ld      hl,$0004
ff47 39        add     hl,sp
ff48 cdfbf1    call    $f1fb
ff4b cde4f4    call    $f4e4
ff4e 21bf01    ld      hl,$01bf
ff51 cdfbf1    call    $f1fb
ff54 cd0ff3    call    $f30f
ff57 211000    ld      hl,$0010
ff5a 39        add     hl,sp
ff5b cdfbf1    call    $f1fb
ff5e c3e4f4    jp      $f4e4
ff61 eb        ex      de,hl
ff62 2a0301    ld      hl,($0103)
ff65 1a        ld      a,(de)
ff66 77        ld      (hl),a
ff67 23        inc     hl
ff68 13        inc     de
ff69 1a        ld      a,(de)
ff6a 77        ld      (hl),a
ff6b 23        inc     hl
ff6c 13        inc     de
ff6d 1a        ld      a,(de)
ff6e 77        ld      (hl),a
ff6f 23        inc     hl
ff70 13        inc     de
ff71 1a        ld      a,(de)
ff72 77        ld      (hl),a
ff73 c9        ret     

ff74 eb        ex      de,hl
ff75 2a0301    ld      hl,($0103)
ff78 7e        ld      a,(hl)
ff79 12        ld      (de),a
ff7a 13        inc     de
ff7b 23        inc     hl
ff7c 7e        ld      a,(hl)
ff7d 12        ld      (de),a
ff7e 13        inc     de
ff7f 23        inc     hl
ff80 7e        ld      a,(hl)
ff81 12        ld      (de),a
ff82 13        inc     de
ff83 23        inc     hl
ff84 7e        ld      a,(hl)
ff85 12        ld      (de),a
ff86 c9        ret     

ff87 e1        pop     hl
ff88 d9        exx     
ff89 210800    ld      hl,$0008
ff8c 39        add     hl,sp
ff8d f9        ld      sp,hl
ff8e d9        exx     
ff8f e9        jp      (hl)
ff90 e3        ex      (sp),hl
ff91 c5        push    bc
ff92 cdecfa    call    $faec
ff95 c1        pop     bc
ff96 d1        pop     de
ff97 7c        ld      a,h
ff98 b5        or      l
ff99 c9        ret     

ff9a 2a0600    ld      hl,($0006)
ff9d f9        ld      sp,hl
ff9e cdebff    call    $ffeb
ffa1 010000    ld      bc,$0000
ffa4 cd0500    call    $0005
ffa7 c3a1ff    jp      $ffa1
ffaa cd74fc    call    $fc74
ffad cdb5ff    call    $ffb5
ffb0 eb        ex      de,hl
ffb1 c9        ret     

ffb2 cd74fc    call    $fc74
ffb5 2afd04    ld      hl,($04fd)
ffb8 44        ld      b,h
ffb9 4d        ld      c,l
ffba 2aff04    ld      hl,($04ff)
ffbd eb        ex      de,hl
ffbe cd0500    call    $0005
ffc1 eb        ex      de,hl
ffc2 6f        ld      l,a
ffc3 2600      ld      h,$00
ffc5 c9        ret     

ffc6 cd74fc    call    $fc74
ffc9 cdd3ff    call    $ffd3
ffcc 6f        ld      l,a
ffcd 2600      ld      h,$00
ffcf c9        ret     

ffd0 cd74fc    call    $fc74
ffd3 2afd04    ld      hl,($04fd)
ffd6 eb        ex      de,hl
ffd7 2a0100    ld      hl,($0001)
ffda 2b        dec     hl
ffdb 2b        dec     hl
ffdc 2b        dec     hl
ffdd 19        add     hl,de
ffde 19        add     hl,de
ffdf 19        add     hl,de
ffe0 eb        ex      de,hl
ffe1 2aff04    ld      hl,($04ff)
ffe4 44        ld      b,h
ffe5 4d        ld      c,l
ffe6 2a0105    ld      hl,($0501)
ffe9 eb        ex      de,hl
ffea e9        jp      (hl)
ffeb c34e04    jp      $044e
ffee 1a        ld      a,(de)
ffef 1a        ld      a,(de)
fff0 1a        ld      a,(de)
fff1 1a        ld      a,(de)
fff2 1a        ld      a,(de)
fff3 1a        ld      a,(de)
fff4 1a        ld      a,(de)
fff5 1a        ld      a,(de)
fff6 1a        ld      a,(de)
fff7 1a        ld      a,(de)
fff8 1a        ld      a,(de)
fff9 1a        ld      a,(de)
fffa 1a        ld      a,(de)
fffb 1a        ld      a,(de)
fffc 1a        ld      a,(de)
fffd 1a        ld      a,(de)
fffe 1a        ld      a,(de)
ffff 1a        ld      a,(de)
