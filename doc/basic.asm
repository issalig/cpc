; Disassembly of Locomotive BASIC v1.1
; 

defb &80		;; foreground rom
defb &01
defb &02
defb &00

defw &c040		;; name table

c006 3100c0    ld      sp,$c000
c009 cdcbbc    call    $bccb			; firmware function: kl rom walk

c00c cd3ff5    call    $f53f
c00f da0000    jp      c,$0000			;; reset?

c012 af        xor     a
c013 3200ac    ld      ($ac00),a

c016 2133c0    ld      hl,$c033			; startup message "BASIC 1.1"
c019 cd7dc3    call    $c37d

c01c cdaade    call    $deaa
c01f cd37cb    call    $cb37
c022 cdbbbd    call    $bdbb			; maths function
c025 cddec0    call    $c0de
c028 cd45c1    call    $c145
c02b 11f000    ld      de,$00f0			; DE = 240
c02e cde9f7    call    $f7e9			; symbol after 240
c031 1825      jr      $c058            

c033
defb " BASIC 1.1",10,10,0

c040
defb "BASI","C"+&80			;; |BASIC

;;========================================================================
;; EDIT
c046 cd48cf    call    $cf48
c049 c0        ret     nz

c04a 3100c0    ld      sp,$c000
c04d cd5ce8    call    $e85c
c050 cd54e2    call    $e254

c053 cd01cb    call    $cb01			; edit
c056 385f      jr      c,$c0b7          ; (+$5f)

;; ??
c058 3100c0    ld      sp,$c000
c05b cd66c1    call    $c166
c05e cdb5de    call    $deb5
c061 dcb6bc    call    c,$bcb6			; firmware function: sound hold
c064 cdd0c4    call    $c4d0			; ON BREAK CONT

c067 cdd0c3    call    $c3d0
c06a 3a2cae    ld      a,($ae2c)		; program protection flag
;; do a new
c06d b7        or      a
c06e c445c1    call    nz,$c145

c071 3a90ad    ld      a,($ad90)		;; error number
c074 d602      sub     $02
c076 2009      jr      nz,$c081         ; (+$09)
c078 3290ad    ld      ($ad90),a

c07b cdaacb    call    $cbaa
c07e eb        ex      de,hl
c07f 38c9      jr      c,$c04a          ; (-$37)

c081 21d7c0    ld      hl,$c0d7			; "Ready" message
c084 cd8bc3    call    $c38b			;; display 0 terminated string

;;-----------------------------------------------------------------

c087 cdaade    call    $deaa
c08a 3a01ac    ld      a,($ac01)
c08d b7        or      a
c08e 281f      jr      z,$c0af          ; (+$1f)

c090 cd0dc1    call    $c10d
c093 30c3      jr      nc,$c058         ; (-$3d)

c095 cd4dde    call    $de4d ; skip space, lf or tab	
c098 cdcfee    call    $eecf
c09b 300a      jr      nc,$c0a7         
c09d cd4dde    call    $de4d ; skip space, lf or tab	
c0a0 b7        or      a
c0a1 37        scf     
c0a2 cc64e8    call    z,$e864
c0a5 30e3      jr      nc,$c08a         ; (-$1d)
c0a7 d4dec0    call    nc,$c0de
c0aa 218aac    ld      hl,$ac8a
c0ad 1808      jr      $c0b7            ; (+$08)

;;-----------------------------------------------------------------

c0af cdf9ca    call    $caf9			; edit
c0b2 30fb      jr      nc,$c0af         ; (-$05)
c0b4 cd98c3    call    $c398      ;; new text line

c0b7 cd4dde    call    $de4d ; skip space, lf or tab
c0ba b7        or      a
c0bb 28ca      jr      z,$c087          ; (-$36)
c0bd cdcfee    call    $eecf
c0c0 300b      jr      nc,$c0cd         ; (+$0b)
c0c2 cd4dfb    call    $fb4d
c0c5 cda5e7    call    $e7a5
c0c8 cd8fc1    call    $c18f
c0cb 18ba      jr      $c087            ; (-$46)

;;-----------------------------------------------------------------
c0cd cda4df    call    $dfa4
c0d0 cdd3c4    call    $c4d3			; ON BREAK STOP
c0d3 2b        dec     hl
c0d4 c360de    jp      $de60
;;========================================================================

c0d7
defb "Ready",10,0
;;========================================================================
c0de af        xor     a
c0df 1805      jr      $c0e6            ; (+$05)
;;========================================================================
c0e1 2202ac    ld      ($ac02),hl
c0e4 3eff      ld      a,$ff
c0e6 3201ac    ld      ($ac01),a
c0e9 c9        ret     
;;==================================================================
;; AUTO
c0ea 110a00    ld      de,$000a			; default line number is 10
c0ed 2802      jr      z,$c0f1          

c0ef fe2c      cp      $2c				; ','
c0f1 c448cf    call    nz,$cf48
c0f4 d5        push    de
c0f5 110a00    ld      de,$000a			; default increment is 10
c0f8 cd41de    call    $de41
c0fb dc48cf    call    c,$cf48
c0fe cd37de    call    $de37
c101 eb        ex      de,hl
c102 2204ac    ld      ($ac04),hl
c105 e1        pop     hl
c106 cde1c0    call    $c0e1
c109 c1        pop     bc
c10a c387c0    jp      $c087

;;-----------------------------------------------------------------

c10d 2a02ac    ld      hl,($ac02)
c110 eb        ex      de,hl
c111 d5        push    de
c112 cd38e2    call    $e238
c115 cddec0    call    $c0de
c118 cd01cb    call    $cb01			; edit
c11b d1        pop     de
c11c d0        ret     nc
;;========================================================================

c11d e5        push    hl
c11e 2a04ac    ld      hl,($ac04)
c121 19        add     hl,de
c122 d4e1c0    call    nc,$c0e1
c125 e1        pop     hl
c126 37        scf     
c127 c9        ret     

;;========================================================================
;; NEW
c128 c0        ret     nz
c129 cd45c1    call    $c145
c12c c358c0    jp      $c058

;;=============================================================================
;; CLEAR, CLEAR INPUT

c12f fea3      cp      $a3				; token for "INPUT"
c131 280c      jr      z,$c13f          ; CLEAR INPUT

c133 e5        push    hl
c134 cd78c1    call    $c178
c137 cd5fc1    call    $c15f
c13a cd8fc1    call    $c18f
c13d e1        pop     hl
c13e c9        ret     

;;========================================================================
;; CLEAR INPUT
c13f cd2cde    call    $de2c			; get next token skipping space
c142 c33dbd    jp      $bd3d			; firmware function: km flush
;;========================================================================

c145 2a62ae    ld      hl,($ae62)
c148 eb        ex      de,hl

c149 2a5eae    ld      hl,($ae5e) ; HIMEM
c14c cde4ff    call    $ffe4			; BC = HL-DE
c14f 62        ld      h,d
c150 6b        ld      l,e
c151 13        inc     de
c152 af        xor     a
c153 77        ld      (hl),a
c154 edb0      ldir    
c156 322cae    ld      ($ae2c),a
c159 cdead5    call    $d5ea
c15c cd6fc1    call    $c16f
c15f cd00d3    call    $d300			; close input and output streams
c162 af        xor     a
c163 cd97bd    call    $bd97			; maths: set angle mode


c166 cdccfb    call    $fbcc			; string catenation
c169 cd20da    call    $da20
c16c c3a1c1    jp      $c1a1

;;-------------------------------------------------------------------

c16f cdc5de    call    $dec5				;; TROFF
c172 cddec0    call    $c0de
c175 cd89c1    call    $c189
c178 c5        push    bc
c179 e5        push    hl
c17a cd8cf6    call    $f68c
c17d cdead5    call    $d5ea
c180 cd38d6    call    $d638
c183 cd4dea    call    $ea4d
c186 e1        pop     hl
c187 c1        pop     bc
c188 c9        ret     

;;-----------------------------------------------------------------
c189 cd99f2    call    $f299
c18c cd61e7    call    $e761        ;; ?

;;-----------------------------------------------------------------
c18f cdaccc    call    $ccac
c192 cd7ecc    call    $cc7e
c195 cda3c9    call    $c9a3
c198 cd4ff6    call    $f64f
c19b cd0ed6    call    $d60e
c19e c3d4dc    jp      $dcd4
;;-----------------------------------------------------------------


c1a1 af        xor     a
c1a2 cdb3c1    call    $c1b3
c1a5 af        xor     a
c1a6 e5        push    hl
c1a7 f5        push    af
c1a8 fe08      cp      $08
c1aa dcb4bb    call    c,$bbb4			; firmware function: txt str select
c1ad f1        pop     af
c1ae 2106ac    ld      hl,$ac06
c1b1 1804      jr      $c1b7            ; (+$04)

;;-----------------------------------------------------------------
c1b3 e5        push    hl
c1b4 2107ac    ld      hl,$ac07
c1b7 d5        push    de
c1b8 5f        ld      e,a
c1b9 7e        ld      a,(hl)
c1ba 73        ld      (hl),e
c1bb d1        pop     de
c1bc e1        pop     hl
c1bd c9        ret     

;;-----------------------------------------------------------------
c1be 3a06ac    ld      a,($ac06)
c1c1 fe08      cp      $08
c1c3 c9        ret     

;;-----------------------------------------------------------------
c1c4 3a07ac    ld      a,($ac07)
c1c7 fe09      cp      $09
c1c9 c9        ret     

;;-----------------------------------------------------------------
c1ca cdfbc1    call    $c1fb
c1cd 18d7      jr      $c1a6            ; (-$29)
c1cf cdfbc1    call    $c1fb
c1d2 1818      jr      $c1ec            ; (+$18)
c1d4 cdfbc1    call    $c1fb
c1d7 cdb3c1    call    $c1b3
c1da c1        pop     bc
c1db f5        push    af
c1dc cdc4c1    call    $c1c4
c1df cdedc1    call    $c1ed
c1e2 f1        pop     af
c1e3 18ce      jr      $c1b3            ; (-$32)


;;----------------------------------------------------------------------

c1e5 cdfbc1    call    $c1fb
c1e8 fe08      cp      $08
c1ea 3031      jr      nc,$c21d         ; (+$31)
c1ec c1        pop     bc
c1ed cda6c1    call    $c1a6
c1f0 f5        push    af
c1f1 7e        ld      a,(hl)
c1f2 fe2c      cp      $2c				; ','
c1f4 cdfcff    call    $fffc			; JP (BC)
c1f7 f1        pop     af
c1f8 c3a6c1    jp      $c1a6
c1fb 7e        ld      a,(hl)
c1fc fe23      cp      $23				; #
c1fe 3e00      ld      a,$00
c200 c0        ret     nz

c201 cd0dc2    call    $c20d
c204 f5        push    af
c205 cd41de    call    $de41
c208 d437de    call    nc,$de37
c20b f1        pop     af
c20c c9        ret     

c20d cd25de    call    $de25
defb &23

c211 3e0a      ld      a,$0a

;;========================================================================
;; check value is in range. if not give "Improper Argument" error message
;; In: A = max value
;; Out: A = value if in range
c213 c5        push    bc
c214 d5        push    de
c215 47        ld      b,a
c216 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
c219 b8        cp      b	; compare to value we want
c21a d1        pop     de
c21b c1        pop     bc
c21c d8        ret     c	;; return if less than value

;; greater than value
c21d c34dcb    jp      $cb4d			; Error: Improper Argument

;;========================================================================
;; check number is less than 2
c220 3e02      ld      a,$02
c222 18ef      jr      $c213 	; check value is in range        

;;========================================================================
;; PEN

c224 cde5c1    call    $c1e5
c227 0190bb    ld      bc,$bb90			; firmware function: txt set pen
c22a c43fc2    call    nz,$c23f
c22d cd41de    call    $de41
c230 d0        ret     nc
c231 cd20c2    call    $c220 			; check number is less than 2
c234 019fbb    ld      bc,$bb9f			; firmware function: txt set back
c237 1809      jr      $c242           

;;========================================================================
;; PAPER

c239 cde5c1    call    $c1e5
c23c 0196bb    ld      bc,$bb96			; firmware function: txt set paper
c23f cd71c2    call    $c271 ; check parameter is less than 16

c242 e5        push    hl
c243 cdfcff    call    $fffc			; JP (BC)
c246 e1        pop     hl
c247 c9        ret     

;;=========================================================================
;; BORDER

c248 cd62c2    call    $c262		 ; one or two numbers each less than 32
;; B,C = numbers which are the inks
c24b e5        push    hl
c24c cd38bc    call    $bc38			; firmware function: scr set border
c24f e1        pop     hl
c250 c9        ret     

;;=========================================================================
;; INK 

c251 cd71c2    call    $c271 ; check parameter is less than 16
c254 f5        push    af
c255 cd15de    call    $de15 ; check for comma
c258 cd62c2    call    $c262 ; one or two numbers each less than 32

;; B,C = numbers which are the inks
c25b f1        pop     af
c25c e5        push    hl
c25d cd32bc    call    $bc32			; firmware function: scr set ink
c260 e1        pop     hl
c261 c9        ret     

;;=========================================================================
;; get one or more numbers which are less than 32
;; used to get ink values
;;
;; first number in B, second number in C

c262 cd6ac2    call    $c26a
c265 41        ld      b,c
c266 cd41de    call    $de41
c269 d0        ret     nc

c26a 3e20      ld      a,$20
c26c cd13c2    call    $c213 ; check value is in range
c26f 4f        ld      c,a
c270 c9        ret     

;;========================================================================
;; check value is less than 16
c271 3e10      ld      a,$10
c273 189e      jr      $c213 ; check value is in range            

;;========================================================================
;; MODE

c275 3e03      ld      a,$03
c277 cd13c2    call    $c213 			; check value is in range
;; A = mode
c27a e5        push    hl
c27b cd0ebc    call    $bc0e			; firmware function: scr set mode
c27e e1        pop     hl
c27f c9        ret     

;;=============================================================================
;; CLS

c280 cde5c1    call    $c1e5
c283 e5        push    hl
c284 cd6cbb    call    $bb6c			; firmware function: txt clear window
c287 e1        pop     hl
c288 c9        ret     

c289 cd0dc2    call    $c20d
c28c fe08      cp      $08
c28e 308d      jr      nc,$c21d         ; (-$73)
c290 f5        push    af
c291 cd1dde    call    $de1d ; check for close bracket
c294 f1        pop     af
c295 c3ecc1    jp      $c1ec

;;========================================================================
;; COPYCHR$

c298 cd89c2    call    $c289
c29b cd60bb    call    $bb60			; firmware function: txt rd char
c29e c378fa    jp      $fa78

;;========================================================================
;; VPOS
c2a1 cd89c2    call    $c289
c2a4 e5        push    hl
c2a5 cdc7c2    call    $c2c7			; get y cursor position
c2a8 180a      jr      $c2b4            ; (+$0a)
;;========================================================================
;; POS
c2aa cd0dc2    call    $c20d
c2ad cd90c2    call    $c290
c2b0 e5        push    hl
c2b1 cdb9c2    call    $c2b9
c2b4 cd32ff    call    $ff32
c2b7 e1        pop     hl
c2b8 c9        ret     

;;========================================================================

c2b9 cdbec1    call    $c1be
c2bc 3a08ac    ld      a,($ac08)
c2bf c8        ret     z

c2c0 3a0aac    ld      a,($ac0a)
c2c3 d0        ret     nc

c2c4 c3ecc3    jp      $c3ec

;;========================================================================
;; get Y cursor position
c2c7 cd78bb    call    $bb78			; firmware function: txt get cursor
c2ca cd87bb    call    $bb87			; firmware function: txt validate
c2cd 7d        ld      a,l
c2ce c9        ret     
;;========================================================================

c2cf cdbec1    call    $c1be
c2d2 280d      jr      z,$c2e1          ; (+$0d)
c2d4 d0        ret     nc

c2d5 d5        push    de
c2d6 e5        push    hl
c2d7 cd69bb    call    $bb69			; firmware function: txt get window
c2da 7a        ld      a,d
c2db 94        sub     h
c2dc 3c        inc     a
c2dd e1        pop     hl
c2de d1        pop     de
c2df 37        scf     
c2e0 c9        ret     

;;??
c2e1 3a09ac    ld      a,($ac09)
c2e4 feff      cp      $ff
c2e6 c9        ret     

c2e7 e5        push    hl
c2e8 67        ld      h,a
c2e9 cdcfc2    call    $c2cf
c2ec 3f        ccf     
c2ed 380e      jr      c,$c2fd          ; (+$0e)
c2ef 6f        ld      l,a
c2f0 cdb9c2    call    $c2b9
c2f3 3d        dec     a
c2f4 37        scf     
c2f5 2806      jr      z,$c2fd          ; (+$06)
c2f7 84        add     a,h
c2f8 3f        ccf     
c2f9 3002      jr      nc,$c2fd         ; (+$02)
c2fb 3d        dec     a
c2fc bd        cp      l
c2fd e1        pop     hl
c2fe c9        ret     

;;========================================================================
;; LOCATE

c2ff cde5c1    call    $c1e5
c302 cd51c3    call    $c351
c305 e5        push    hl
c306 eb        ex      de,hl
c307 24        inc     h
c308 2c        inc     l
c309 cd75bb    call    $bb75			; firmware function: txt set cursor
c30c e1        pop     hl
c30d c9        ret     

;;========================================================================
;; WINDOW
c30e fee7      cp      $e7
c310 2816      jr      z,$c328          ; (+$16)
c312 cde5c1    call    $c1e5
c315 cd51c3    call    $c351
c318 d5        push    de
c319 cd15de    call    $de15 ; check for comma
c31c cd51c3    call    $c351
c31f e3        ex      (sp),hl
c320 7a        ld      a,d
c321 55        ld      d,l
c322 6f        ld      l,a
c323 cd66bb    call    $bb66			; firmware function: txt win enable
c326 e1        pop     hl
c327 c9        ret     

;;========================================================================
c328 cd2cde    call    $de2c			; get next token skipping space
c32b cd3ec3    call    $c33e 		; get number less than 8
c32e 4f        ld      c,a
c32f cd41de    call    $de41
c332 3e00      ld      a,$00
c334 dc3ec3    call    c,$c33e 		; get number less than 8
c337 47        ld      b,a
c338 e5        push    hl
c339 cdb7bb    call    $bbb7			; firmware function: txt swap streams
c33c e1        pop     hl
c33d c9        ret     

;;========================================================================
;; get number less than 8

c33e 3e08      ld      a,$08
c340 c313c2    jp      $c213 ; check value is in range
;;========================================================================
;; TAG
c343 cde5c1    call    $c1e5
c346 3eff      ld      a,$ff
c348 1804      jr      $c34e            ; (+$04)
;;========================================================================
;; TAGOFF
c34a cde5c1    call    $c1e5
c34d af        xor     a
c34e c363bb    jp      $bb63			; firmware function: txt set graphic

;;-------------------------------------------------------------------------

c351 cd58c3    call    $c358
c354 53        ld      d,e
c355 cd15de    call    $de15 ; check for comma

;;--------------------------------------------------------------------------
c358 d5        push    de
c359 cdc3ce    call    $cec3
c35c d1        pop     de
c35d 5f        ld      e,a
c35e 1d        dec     e
c35f c9        ret     

;;========================================================================
;; CURSOR

c360 cde5c1    call    $c1e5
c363 280a      jr      z,$c36f          ; (+$0a)
c365 cd20c2    call    $c220 ; check number is less than 2
c368 b7        or      a
c369 cc84bb    call    z,$bb84			; firmware function: txt cur off
c36c c481bb    call    nz,$bb81			; firmware function: txt cur on
c36f cd41de    call    $de41
c372 d0        ret     nc

c373 cd20c2    call    $c220 ; check number is less than 2
c376 b7        or      a
c377 ca7ebb    jp      z,$bb7e			; firmware function: txt cur disable
c37a c37bbb    jp      $bb7b			; firmware function: txt cur enable

c37d e5        push    hl
c37e 210184    ld      hl,$8401
c381 2208ac    ld      ($ac08),hl
c384 cd69c4    call    $c469
c387 cda1c1    call    $c1a1
c38a e1        pop     hl

;;----------------------------------------------------
;; display 0 terminated string

c38b f5        push    af
c38c e5        push    hl
c38d 7e        ld      a,(hl)			; get character
c38e 23        inc     hl
c38f b7        or      a
c390 c4a0c3    call    nz,$c3a0           ;; display text char
c393 20f8      jr      nz,$c38d         ; (-$08)

c395 e1        pop     hl
c396 f1        pop     af
c397 c9        ret     

;;-------------------------------------------------------------------
;; display return
c398 f5        push    af
c399 3e0a      ld      a,$0a
c39b cda0c3    call    $c3a0           ;; display text char
c39e f1        pop     af
c39f c9        ret     
;;-------------------------------------------------------------------
;; display char
c3a0 f5        push    af
c3a1 c5        push    bc
c3a2 cda8c3    call    $c3a8
c3a5 c1        pop     bc
c3a6 f1        pop     af
c3a7 c9        ret     
;;-------------------------------------------------------------------

c3a8 fe0a      cp      $0a
c3aa 200c      jr      nz,$c3b8         ; (+$0c)

c3ac cdbec1    call    $c1be
c3af caf5c3    jp      z,$c3f5
c3b2 d231c4    jp      nc,$c431 ; write cr, lf to file
c3b5 c3e2c3    jp      $c3e2
;;-------------------------------------------------------------------
c3b8 f5        push    af
c3b9 c5        push    bc
c3ba 4f        ld      c,a
c3bb cdc1c3    call    $c3c1
c3be c1        pop     bc
c3bf f1        pop     af
c3c0 c9        ret     
;;-------------------------------------------------------------------
c3c1 3a06ac    ld      a,($ac06)
c3c4 fe08      cp      $08
c3c6 cafcc3    jp      z,$c3fc

c3c9 d238c4    jp      nc,$c438 ; write char to file
c3cc 79        ld      a,c
c3cd c3e9c3    jp      $c3e9

;;========================================================================
c3d0 af        xor     a				; output letters using text functions
c3d1 cd63bb    call    $bb63			; firmware function: txt set graphic	
c3d4 af        xor     a				; opaque characters
c3d5 e5        push    hl
c3d6 cd9fbb    call    $bb9f			; firmware function: txt set back
c3d9 e1        pop     hl
c3da cd54bb    call    $bb54			; firmware function: txt vdu enable

c3dd cdecc3    call    $c3ec			; get x cursor position
c3e0 3d        dec     a
c3e1 c8        ret     z

c3e2 3e0d      ld      a,$0d			; print CR,LF
c3e4 cde9c3    call    $c3e9
c3e7 3e0a      ld      a,$0a
c3e9 c35abb    jp      $bb5a			; firmware function: txt output
;;========================================================================

;; get x cursor position
c3ec c5        push    bc
c3ed e5        push    hl
c3ee cdc7c2    call    $c2c7					
c3f1 7c        ld      a,h
c3f2 e1        pop     hl
c3f3 c1        pop     bc
c3f4 c9        ret     
;;========================================================================

c3f5 0e0d      ld      c,$0d
c3f7 cdfcc3    call    $c3fc
c3fa 0e0a      ld      c,$0a
c3fc e5        push    hl
c3fd 2a08ac    ld      hl,($ac08)
c400 cd11c4    call    $c411
c403 3208ac    ld      ($ac08),a
c406 e1        pop     hl

c407 79        ld      a,c
c408 cd2bbd    call    $bd2b			; firmware function: mc print char
c40b d8        ret     c

c40c cd72c4    call    $c472			; key
c40f 18f6      jr      $c407            ; 

c411 79        ld      a,c
c412 ee0d      xor     $0d
c414 2810      jr      z,$c426          ; (+$10)
c416 79        ld      a,c
c417 fe20      cp      $20				; ' '
c419 7d        ld      a,l
c41a d8        ret     c

c41b 24        inc     h
c41c 2808      jr      z,$c426          ; (+$08)
c41e bc        cp      h
c41f 2005      jr      nz,$c426         ; (+$05)
c421 cd98c3    call    $c398      ;; new text line			
c424 3e01      ld      a,$01
c426 3c        inc     a
c427 c0        ret     nz

c428 3d        dec     a
c429 c9        ret     

;;========================================================================
;; WIDTH
c42a cdc3ce    call    $cec3
c42d 3209ac    ld      ($ac09),a
c430 c9        ret     
;;========================================================================

;; write cr,lf to file
c431 0e0d      ld      c,$0d			;; cr
c433 cd38c4    call    $c438 ; write char to file
c436 0e0a      ld      c,$0a			;; lf

;; write char to file
c438 e5        push    hl
c439 2a0aac    ld      hl,($ac0a)
c43c 26ff      ld      h,$ff
c43e cd11c4    call    $c411
c441 320aac    ld      ($ac0a),a
c444 e1        pop     hl
c445 79        ld      a,c
c446 cd95bc    call    $bc95			; firmware function: cas out char
c449 d8        ret     c

c44a 2019      jr      nz,$c465         ; (+$19)
c44c c337cc    jp      $cc37

;;----------------------------------------------
;; EOF

c44f e5        push    hl
c450 cd89bc    call    $bc89			; firmware function: cas test eof
c453 28f7      jr      z,$c44c          ; (-$09)
c455 3f        ccf     
c456 9f        sbc     a,a
c457 cd2dff    call    $ff2d
c45a e1        pop     hl
c45b c9        ret     

;;----------------------------------------------
;; read byte from cassette or disc
c45c cd80bc    call    $bc80			; firmware function: cas in char
c45f d8        ret     c

c460 28ea      jr      z,$c44c          ; (-$16)
c462 ee0e      xor     $0e
c464 c0        ret     nz

c465 cd45cb    call    $cb45
c468 1f        rra     
c469 3e01      ld      a,$01
c46b 320aac    ld      ($ac0a),a
c46e c9        ret     

;;=======================================================================================
c46f c309bb    jp      $bb09			; firmware function: km read char
;;=======================================================================================

c472 cd09bb    call    $bb09			; firmware function: km read char
c475 d0        ret     nc
c476 fefc      cp      $fc				
c478 c0        ret     nz
c479 cda1c4    call    $c4a1			; key
c47c da3ecc    jp      c,$cc3e
c47f e5        push    hl
c480 c5        push    bc
c481 d5        push    de
c482 1192c4    ld      de,$c492
c485 0efd      ld      c,$fd
c487 3a0bac    ld      a,($ac0b)
c48a b7        or      a
c48b c445bb    call    nz,$bb45			; firmware function: km arm break
c48e d1        pop     de
c48f c1        pop     bc
c490 e1        pop     hl
c491 c9        ret     
;;=======================================================================================
c492 cd09bb    call    $bb09			; firmware function: km read char
c495 3004      jr      nc,$c49b         ; (+$04)
c497 feef      cp      $ef
c499 20f7      jr      nz,$c492         ; (-$09)
c49b cda1c4    call    $c4a1			; key
c49e c3f2c8    jp      $c8f2

;;=======================================================================================
c4a1 c5        push    bc
c4a2 d5        push    de
c4a3 e5        push    hl
c4a4 cdb6bc    call    $bcb6			; firmware function: sound hold
c4a7 f5        push    af
c4a8 cd40bd    call    $bd40			; firmware function: txt ask state
c4ab 47        ld      b,a
c4ac cd81bb    call    $bb81			; firmware function: txt cur on
c4af cd06bb    call    $bb06			; firmware function: km wait char
c4b2 feef      cp      $ef
c4b4 28f9      jr      z,$c4af          ; (-$07)
c4b6 cb48      bit     1,b
c4b8 c484bb    call    nz,$bb84			; firmware function: txt cur off
c4bb fefc      cp      $fc
c4bd 37        scf     
c4be 280b      jr      z,$c4cb          ; (+$0b)
c4c0 fe20      cp      $20				; ' ' 
c4c2 c40cbb    call    nz,$bb0c			; firmware function: km char return
c4c5 f1        pop     af
c4c6 f5        push    af
c4c7 dcb9bc    call    c,$bcb9			; firmware function: sound continue
c4ca b7        or      a
c4cb e1        pop     hl
c4cc e1        pop     hl
c4cd d1        pop     de
c4ce c1        pop     bc
c4cf c9        ret     

;;========================================================================
;; ON BREAK CONT
c4d0 af        xor     a
c4d1 1802      jr      $c4d5            ; (+$02)
;;========================================================================
;; ON BREAK STOP
c4d3 3eff      ld      a,$ff
;;------------------------------------------------------------------------
c4d5 320bac    ld      ($ac0b),a
c4d8 e5        push    hl
c4d9 cd48bb    call    $bb48			; firmware function: km disarm break
c4dc 18a2      jr      $c480            ; (-$5e)

;;========================================================================
;; ORIGIN

c4de cd8cc5    call    $c58c
c4e1 c5        push    bc
c4e2 d5        push    de
c4e3 cd41de    call    $de41
c4e6 3017      jr      nc,$c4ff         ; (+$17)
c4e8 cd8cc5    call    $c58c
c4eb c5        push    bc
c4ec d5        push    de
c4ed cd15de    call    $de15 ; check for comma
c4f0 cd8cc5    call    $c58c
c4f3 c5        push    bc
c4f4 e3        ex      (sp),hl
c4f5 cdd2bb    call    $bbd2			; firmware function: gra win height
c4f8 e1        pop     hl
c4f9 d1        pop     de
c4fa e3        ex      (sp),hl
c4fb cdcfbb    call    $bbcf			; firmware function: gra win width
c4fe e1        pop     hl
c4ff d1        pop     de
c500 e3        ex      (sp),hl
c501 cdc9bb    call    $bbc9			; firmware function: gra set origin
c504 e1        pop     hl
c505 c9        ret     

;;=============================================================================
;; CLG

c506 cd3dde    call    $de3d
c509 d4b4c5    call    nc,$c5b4
c50c e5        push    hl
c50d cddbbb    call    $bbdb			; firmware function: GRA CLEAR WINDOW
c510 e1        pop     hl
c511 c9        ret     

;;========================================================================
;; FILL
c512 cd71c2    call    $c271 ; check parameter is less than 16
c515 e5        push    hl
c516 f5        push    af
c517 cd64fc    call    $fc64
c51a cdfcf6    call    $f6fc
c51d 011d00    ld      bc,$001d
c520 cddeff    call    $ffde ; HL=BC?
c523 3e07      ld      a,$07
c525 da55cb    jp      c,$cb55
c528 eb        ex      de,hl
c529 f1        pop     af
c52a cd52bd    call    $bd52			; firmware function: GRA FILL
c52d e1        pop     hl
c52e c9        ret     

;;========================================================================
;; MOVE
c52f 01c0bb    ld      bc,$bbc0			; firmware function: gra move absolute
c532 1817      jr      $c54b            
;;========================================================================
;; MOVER
c534 01c3bb    ld      bc,$bbc3			; firmware function: gra move relative
c537 1812      jr      $c54b            
;;========================================================================
;; DRAW
c539 01f6bb    ld      bc,$bbf6			; firmware function: gra line absolute
c53c 180d      jr      $c54b            
;;========================================================================
;; DRAWR
c53e 01f9bb    ld      bc,$bbf9			; firmware function: gra line relative
c541 1808      jr      $c54b
;;========================================================================
;; PLOT
c543 01eabb    ld      bc,$bbea			; firmware function: gra plot absolute
c546 1803      jr      $c54b            
;;========================================================================
;; PLOTR
c548 01edbb    ld      bc,$bbed			; firmware function: gra plot relative
;;------------------------------------------------------------------------
;; plot/draw general function
c54b c5        push    bc
c54c cd8cc5    call    $c58c
c54f cd41de    call    $de41
c552 3005      jr      nc,$c559         ; (+$05)
c554 fe2c      cp      $2c				; ','
c556 c4bac5    call    nz,$c5ba
c559 cd41de    call    $de41
c55c 300a      jr      nc,$c568         ; (+$0a)
c55e 3e04      ld      a,$04
c560 cd13c2    call    $c213 ; check value is in range
c563 e5        push    hl
c564 cd59bc    call    $bc59			; firmware function: scr access 
c567 e1        pop     hl
c568 e3        ex      (sp),hl
c569 c5        push    bc
c56a e3        ex      (sp),hl
c56b c1        pop     bc
c56c cdfcff    call    $fffc			; JP (BC)
c56f e1        pop     hl
c570 c9        ret     

;;========================================================================
;; TEST
c571 01f0bb    ld      bc,$bbf0			; firmware function: GRA TEST ABSOLUTE
c574 1803      jr      $c579            ; 
;;========================================================================
;; TESTR
c576 01f3bb    ld      bc,$bbf3			; firmware function: GRA TEST RELATIVE
;;------------------------------------------------------------------------
c579 c5        push    bc
c57a cd8cc5    call    $c58c
c57d cd1dde    call    $de1d ; check for close bracket
c580 e3        ex      (sp),hl
c581 c5        push    bc
c582 e3        ex      (sp),hl
c583 c1        pop     bc
c584 cdfcff    call    $fffc			; JP (BC)
c587 cd32ff    call    $ff32
c58a e1        pop     hl
c58b c9        ret     
;;------------------------------------------------------------------------
c58c cdd8ce    call    $ced8 ; get number
c58f d5        push    de
c590 cd15de    call    $de15 ; check for comma
c593 cdd8ce    call    $ced8 ; get number
c596 42        ld      b,d
c597 4b        ld      c,e
c598 d1        pop     de
c599 c9        ret     

;;========================================================================
;; GRAPHICS PAPER/GRAPHICS PEN and set graphics draw mode
c59a feba      cp      $ba				; token for "PAPER"
c59c 2813      jr      z,$c5b1    		; set graphics paper
      
c59e cd25de    call    $de25
defb &bb								; token for "PEN"
c5a2 fe2c      cp      $2c				; ','
c5a4 c4bac5    call    nz,$c5ba			; set graphics pen

c5a7 cd41de    call    $de41
c5aa d0        ret     nc

;; set graphics background mode
c5ab cd20c2    call    $c220 ; check number is less than 2
c5ae c346bd    jp      $bd46			; firmware function: GRA SET BACK

;; set graphics paper
c5b1 cd2cde    call    $de2c			; get next token skipping space
c5b4 cd71c2    call    $c271 			; check parameter is less than 16
c5b7 c3e4bb    jp      $bbe4			; firmware function: GRA SET PAPER	

;; set graphics pen
c5ba cd71c2    call    $c271 			; check parameter is less than 16
c5bd c3debb    jp      $bbde			; firmware function: GRA SET PEN

;;========================================================================
;; MASK

c5c0 fe2c      cp      $2c				; ','
c5c2 2806      jr      z,$c5ca          ; 

c5c4 cdb8ce    call    $ceb8 			; get number and check it's less than 255 
c5c7 cd4cbd    call    $bd4c			; firmware function: GRA SET LINE MASK	

c5ca cd41de    call    $de41
c5cd d0        ret     nc

c5ce cd20c2    call    $c220 			; check number is less than 2
c5d1 c349bd    jp      $bd49			; firmware function: GRA SET FIRST

;;========================================================================
;; FOR

c5d4 cdecd6    call    $d6ec
c5d7 e5        push    hl
c5d8 c5        push    bc
c5d9 d5        push    de
c5da cd76ca    call    $ca76
c5dd 2212ac    ld      ($ac12),hl
c5e0 d5        push    de
c5e1 e5        push    hl
c5e2 eb        ex      de,hl
c5e3 cdd9c6    call    $c6d9
c5e6 cc5df6    call    z,$f65d
c5e9 e1        pop     hl
c5ea cd3dde    call    $de3d
c5ed 110000    ld      de,$0000
c5f0 d4bfd6    call    nc,$d6bf
c5f3 44        ld      b,h
c5f4 4d        ld      c,l
c5f5 e1        pop     hl
c5f6 e3        ex      (sp),hl
c5f7 7a        ld      a,d
c5f8 b3        or      e
c5f9 c4d8ff    call    nz,$ffd8 ; HL=DE?
c5fc c29ec6    jp      nz,$c69e
c5ff eb        ex      de,hl
c600 cdb1de    call    $deb1
c603 e3        ex      (sp),hl
c604 cdadde    call    $dead
c607 e1        pop     hl
c608 f1        pop     af
c609 e3        ex      (sp),hl
c60a d5        push    de
c60b c5        push    bc
c60c e5        push    hl
c60d 010516    ld      bc,$1605
c610 b9        cp      c
c611 2809      jr      z,$c61c          ; (+$09)
c613 010210    ld      bc,$1002
c616 b9        cp      c
c617 3e0d      ld      a,$0d
c619 c255cb    jp      nz,$cb55
c61c 78        ld      a,b
c61d cd72f6    call    $f672
c620 73        ld      (hl),e
c621 23        inc     hl
c622 72        ld      (hl),d
c623 23        inc     hl
c624 e3        ex      (sp),hl
c625 cd21de    call    $de21
c628 cd62cf    call    $cf62
c62b 79        ld      a,c
c62c cdfffe    call    $feff
c62f e5        push    hl
c630 210dac    ld      hl,$ac0d
c633 cd83ff    call    $ff83
c636 e1        pop     hl
c637 cd25de    call    $de25
defb &ec
c6eb cd62cf    call    $cf62
c63e e3        ex      (sp),hl
c63f 79        ld      a,c
c640 cdfffe    call    $feff
c643 cd83ff    call    $ff83
c646 eb        ex      de,hl
c647 e3        ex      (sp),hl
c648 eb        ex      de,hl
c649 210100    ld      hl,$0001
c64c cd35ff    call    $ff35
c64f eb        ex      de,hl
c650 7e        ld      a,(hl)
c651 fee6      cp      $e6
c653 2006      jr      nz,$c65b         ; (+$06)
c655 cd2cde    call    $de2c			; get next token skipping space
c658 cd62cf    call    $cf62
c65b 79        ld      a,c
c65c cdfffe    call    $feff
c65f e3        ex      (sp),hl
c660 cd83ff    call    $ff83
c663 cdc4fd    call    $fdc4
c666 eb        ex      de,hl
c667 77        ld      (hl),a
c668 23        inc     hl
c669 eb        ex      de,hl
c66a e1        pop     hl
c66b cd37de    call    $de37
c66e eb        ex      de,hl
c66f 73        ld      (hl),e
c670 23        inc     hl
c671 72        ld      (hl),d
c672 23        inc     hl
c673 eb        ex      de,hl
c674 cdb1de    call    $deb1
c677 eb        ex      de,hl
c678 73        ld      (hl),e
c679 23        inc     hl
c67a 72        ld      (hl),d
c67b 23        inc     hl
c67c d1        pop     de
c67d 73        ld      (hl),e
c67e 23        inc     hl
c67f 72        ld      (hl),d
c680 23        inc     hl
c681 ed5b12ac  ld      de,($ac12)
c685 73        ld      (hl),e
c686 23        inc     hl
c687 72        ld      (hl),d
c688 23        inc     hl
c689 70        ld      (hl),b
c68a d1        pop     de
c68b 210dac    ld      hl,$ac0d
c68e cd87ff    call    $ff87
c691 af        xor     a
c692 320cac    ld      ($ac0c),a
c695 e1        pop     hl
c696 cdadde    call    $dead
c699 2a12ac    ld      hl,($ac12)
c69c 1809      jr      $c6a7            ; (+$09)
c69e cd45cb    call    $cb45
c6a1 01
;;========================================================================
;; NEXT
c6a2 3eff      ld      a,$ff
c6a4 320cac    ld      ($ac0c),a
c6a7 eb        ex      de,hl
c6a8 cdd9c6    call    $c6d9
c6ab 20f1      jr      nz,$c69e         ; (-$0f)
c6ad eb        ex      de,hl
c6ae cd5df6    call    $f65d
c6b1 eb        ex      de,hl
c6b2 e5        push    hl
c6b3 cd02c7    call    $c702
c6b6 280f      jr      z,$c6c7          ; (+$0f)
c6b8 f1        pop     af
c6b9 23        inc     hl
c6ba 5e        ld      e,(hl)
c6bb 23        inc     hl
c6bc 56        ld      d,(hl)
c6bd 23        inc     hl
c6be 7e        ld      a,(hl)
c6bf 23        inc     hl
c6c0 66        ld      h,(hl)
c6c1 6f        ld      l,a
c6c2 cdadde    call    $dead
c6c5 eb        ex      de,hl
c6c6 c9        ret     

c6c7 010500    ld      bc,$0005
c6ca 09        add     hl,bc
c6cb 5e        ld      e,(hl)
c6cc 23        inc     hl
c6cd 56        ld      d,(hl)
c6ce e1        pop     hl
c6cf cd5df6    call    $f65d
c6d2 eb        ex      de,hl
c6d3 cd41de    call    $de41
c6d6 38cf      jr      c,$c6a7          ; (-$31)
c6d8 c9        ret     

c6d9 2a6fb0    ld      hl,($b06f)
c6dc e5        push    hl
c6dd 2b        dec     hl
c6de 46        ld      b,(hl)
c6df 23        inc     hl
c6e0 7d        ld      a,l
c6e1 90        sub     b
c6e2 6f        ld      l,a
c6e3 9f        sbc     a,a
c6e4 84        add     a,h
c6e5 67        ld      h,a
c6e6 e3        ex      (sp),hl
c6e7 78        ld      a,b
c6e8 fe07      cp      $07
c6ea 380f      jr      c,$c6fb          ; (+$0f)
c6ec 2000      jr      nz,$c6ee         ; (+$00)
c6ee e5        push    hl
c6ef 2b        dec     hl
c6f0 2b        dec     hl
c6f1 7e        ld      a,(hl)
c6f2 2b        dec     hl
c6f3 6e        ld      l,(hl)
c6f4 67        ld      h,a
c6f5 cdd8ff    call    $ffd8 ; HL=DE?
c6f8 e1        pop     hl
c6f9 2004      jr      nz,$c6ff         ; (+$04)
c6fb eb        ex      de,hl
c6fc e1        pop     hl
c6fd 78        ld      a,b
c6fe c9        ret     

c6ff e1        pop     hl
c700 18da      jr      $c6dc            ; (-$26)
c702 5e        ld      e,(hl)
c703 23        inc     hl
c704 56        ld      d,(hl)
c705 23        inc     hl
c706 e5        push    hl
c707 fe10      cp      $10
c709 282c      jr      z,$c737          ; (+$2c)
c70b 010500    ld      bc,$0005
c70e 79        ld      a,c
c70f eb        ex      de,hl
c710 cd6cff    call    $ff6c
c713 e1        pop     hl
c714 3a0cac    ld      a,($ac0c)
c717 b7        or      a
c718 2810      jr      z,$c72a          ; (+$10)
c71a e5        push    hl
c71b 09        add     hl,bc
c71c cd0cfd    call    $fd0c
c71f e1        pop     hl
c720 e5        push    hl
c721 2b        dec     hl
c722 56        ld      d,(hl)
c723 2b        dec     hl
c724 5e        ld      e,(hl)
c725 eb        ex      de,hl
c726 cd83ff    call    $ff83
c729 e1        pop     hl
c72a e5        push    hl
c72b 0e05      ld      c,$05
c72d cd49fd    call    $fd49
c730 e1        pop     hl
c731 010a00    ld      bc,$000a
c734 09        add     hl,bc
c735 96        sub     (hl)
c736 c9        ret     

c737 eb        ex      de,hl
c738 5e        ld      e,(hl)
c739 23        inc     hl
c73a 56        ld      d,(hl)
c73b 3a0cac    ld      a,($ac0c)
c73e b7        or      a
c73f 2816      jr      z,$c757          ; (+$16)
c741 e3        ex      (sp),hl
c742 e5        push    hl
c743 23        inc     hl
c744 23        inc     hl
c745 7e        ld      a,(hl)
c746 23        inc     hl
c747 66        ld      h,(hl)
c748 6f        ld      l,a
c749 cd4add    call    $dd4a
c74c 3e06      ld      a,$06
c74e d255cb    jp      nc,$cb55
c751 eb        ex      de,hl
c752 e1        pop     hl
c753 e3        ex      (sp),hl
c754 72        ld      (hl),d
c755 2b        dec     hl
c756 73        ld      (hl),e
c757 e1        pop     hl
c758 7e        ld      a,(hl)
c759 23        inc     hl
c75a e5        push    hl
c75b 66        ld      h,(hl)
c75c 6f        ld      l,a
c75d eb        ex      de,hl
c75e cd02de    call    $de02
c761 e1        pop     hl
c762 23        inc     hl
c763 23        inc     hl
c764 23        inc     hl
c765 96        sub     (hl)
c766 c9        ret     

;;========================================================================
;; IF

c767 cd62cf    call    $cf62
c76a fea0      cp      $a0
c76c 2804      jr      z,$c772          ; (+$04)
c76e cd25de    call    $de25
defb &eb
c772 cdc4fd    call    $fdc4
c775 cc5be9    call    z,$e95b
c778 c8        ret     z

c779 cd3dde    call    $de3d
c77c d8        ret     c

c77d fe1e      cp      $1e				; 16-bit integer BASIC line number
c77f 2805      jr      z,$c786          
c781 fe1d      cp      $1d				; 16-bit BASIC program line memory address pointer
c783 c28fde    jp      nz,$de8f

;;========================================================================
;; GOTO

c786 cd27e8    call    $e827
c789 c0        ret     nz

c78a eb        ex      de,hl
c78b c9        ret     

;;========================================================================
;; GOSUB

c78c cd27e8    call    $e827
c78f c0        ret     nz

c790 eb        ex      de,hl
c791 0e00      ld      c,$00
c793 e5        push    hl
c794 3e06      ld      a,$06
c796 cd72f6    call    $f672
c799 71        ld      (hl),c
c79a 23        inc     hl
c79b 73        ld      (hl),e
c79c 23        inc     hl
c79d 72        ld      (hl),d
c79e 23        inc     hl
c79f eb        ex      de,hl
c7a0 cdb1de    call    $deb1
c7a3 eb        ex      de,hl
c7a4 73        ld      (hl),e
c7a5 23        inc     hl
c7a6 72        ld      (hl),d
c7a7 23        inc     hl
c7a8 3606      ld      (hl),$06
c7aa 23        inc     hl
c7ab cd5df6    call    $f65d
c7ae e1        pop     hl
c7af c9        ret     

;;========================================================================
;; RETURN

c7b0 c0        ret     nz
c7b1 cdcfc7    call    $c7cf
c7b4 cd5df6    call    $f65d
c7b7 4e        ld      c,(hl)
c7b8 23        inc     hl
c7b9 5e        ld      e,(hl)
c7ba 23        inc     hl
c7bb 56        ld      d,(hl)
c7bc 23        inc     hl
c7bd 7e        ld      a,(hl)
c7be 23        inc     hl
c7bf 66        ld      h,(hl)
c7c0 6f        ld      l,a
c7c1 cdadde    call    $dead
c7c4 eb        ex      de,hl
c7c5 79        ld      a,c
c7c6 fe01      cp      $01
c7c8 d8        ret     c

c7c9 ca51c9    jp      z,$c951
c7cc c361c9    jp      $c961
c7cf 2a6fb0    ld      hl,($b06f)
c7d2 2b        dec     hl
c7d3 7e        ld      a,(hl)
c7d4 f5        push    af
c7d5 7d        ld      a,l
c7d6 96        sub     (hl)
c7d7 6f        ld      l,a
c7d8 9f        sbc     a,a
c7d9 84        add     a,h
c7da 67        ld      h,a
c7db 23        inc     hl
c7dc f1        pop     af
c7dd fe06      cp      $06
c7df c8        ret     z

c7e0 b7        or      a
c7e1 20ef      jr      nz,$c7d2         ; (-$11)
c7e3 cd45cb    call    $cb45
c7e6 03        inc     bc

;;========================================================================
;; WHILE
c7e7 e5        push    hl
c7e8 cdc9ca    call    $cac9
c7eb e5        push    hl
c7ec eb        ex      de,hl
c7ed 2214ac    ld      ($ac14),hl
c7f0 cd5dc8    call    $c85d
c7f3 cc5df6    call    z,$f65d
c7f6 3e07      ld      a,$07
c7f8 cd72f6    call    $f672
c7fb eb        ex      de,hl
c7fc cdb1de    call    $deb1
c7ff eb        ex      de,hl
c800 73        ld      (hl),e
c801 23        inc     hl
c802 72        ld      (hl),d
c803 23        inc     hl
c804 d1        pop     de
c805 73        ld      (hl),e
c806 23        inc     hl
c807 72        ld      (hl),d
c808 23        inc     hl
c809 eb        ex      de,hl
c80a e3        ex      (sp),hl
c80b eb        ex      de,hl
c80c 73        ld      (hl),e
c80d 23        inc     hl
c80e 72        ld      (hl),d
c80f 23        inc     hl
c810 3607      ld      (hl),$07
c812 23        inc     hl
c813 cd5df6    call    $f65d
c816 eb        ex      de,hl
c817 d1        pop     de
c818 182a      jr      $c844            ; (+$2a)

;;========================================================================
;; WEND

c81a c0        ret     nz
c81b eb        ex      de,hl
c81c cd5dc8    call    $c85d
c81f 3e1e      ld      a,$1e          ; 16-bit line number
c821 c255cb    jp      nz,$cb55
c824 e5        push    hl
c825 110700    ld      de,$0007
c828 19        add     hl,de
c829 cd5df6    call    $f65d
c82c cdb1de    call    $deb1
c82f 2214ac    ld      ($ac14),hl
c832 e1        pop     hl
c833 5e        ld      e,(hl)
c834 23        inc     hl
c835 56        ld      d,(hl)
c836 23        inc     hl
c837 eb        ex      de,hl
c838 cdadde    call    $dead
c83b eb        ex      de,hl
c83c 5e        ld      e,(hl)
c83d 23        inc     hl
c83e 56        ld      d,(hl)
c83f 23        inc     hl
c840 7e        ld      a,(hl)
c841 23        inc     hl
c842 66        ld      h,(hl)
c843 6f        ld      l,a
c844 d5        push    de
c845 cd62cf    call    $cf62
c848 cdc4fd    call    $fdc4
c84b d1        pop     de
c84c c0        ret     nz

c84d 2a14ac    ld      hl,($ac14)
c850 cdadde    call    $dead
c853 3e07      ld      a,$07
c855 cd62f6    call    $f662
c858 cd5df6    call    $f65d
c85b eb        ex      de,hl
c85c c9        ret     

c85d 2a6fb0    ld      hl,($b06f)
c860 2b        dec     hl
c861 e5        push    hl
c862 7d        ld      a,l
c863 96        sub     (hl)
c864 6f        ld      l,a
c865 9f        sbc     a,a
c866 84        add     a,h
c867 67        ld      h,a
c868 23        inc     hl
c869 e3        ex      (sp),hl
c86a 7e        ld      a,(hl)
c86b fe07      cp      $07
c86d 380e      jr      c,$c87d          ; (+$0e)
c86f 200e      jr      nz,$c87f         ; (+$0e)
c871 2b        dec     hl
c872 2b        dec     hl
c873 2b        dec     hl
c874 7e        ld      a,(hl)
c875 2b        dec     hl
c876 6e        ld      l,(hl)
c877 67        ld      h,a
c878 cdd8ff    call    $ffd8 ; HL=DE?
c87b 2002      jr      nz,$c87f         ; (+$02)
c87d e1        pop     hl
c87e c9        ret     

c87f e1        pop     hl
c880 18de      jr      $c860            ; (-$22)

;;========================================================================
;; ON

c882 fe9c      cp      $9c
c884 cab8cc    jp      z,$ccb8
c887 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
c88a 4f        ld      c,a
c88b 7e        ld      a,(hl)
c88c fea0      cp      $a0
c88e f5        push    af
c88f 2805      jr      z,$c896          ; (+$05)
c891 cd25de    call    $de25
defb &9f
c895 2b        dec     hl
c896 cd2cde    call    $de2c			; get next token skipping space
c899 0d        dec     c
c89a 280a      jr      z,$c8a6          ; (+$0a)
c89c cd48cf    call    $cf48
c89f cd41de    call    $de41
c8a2 38f5      jr      c,$c899          ; (-$0b)
c8a4 f1        pop     af
c8a5 c9        ret     

c8a6 cd27e8    call    $e827
c8a9 c4a3e9    call    nz,$e9a3			;; DATA
c8ac f1        pop     af
c8ad c290c7    jp      nz,$c790
c8b0 eb        ex      de,hl
c8b1 c9        ret     

c8b2 af        xor     a
c8b3 3216ac    ld      ($ac16),a
c8b6 cdfbbc    call    $bcfb			; firmware function: kl next sync 
c8b9 301d      jr      nc,$c8d8         ; (+$1d)
c8bb 47        ld      b,a
c8bc 3a16ac    ld      a,($ac16)
c8bf e67f      and     $7f
c8c1 3216ac    ld      ($ac16),a
c8c4 c5        push    bc
c8c5 e5        push    hl
c8c6 cdfebc    call    $bcfe			; firmware function: kl do sync
c8c9 e1        pop     hl
c8ca c1        pop     bc
c8cb 3a16ac    ld      a,($ac16)
c8ce 17        rla     
c8cf f5        push    af
c8d0 78        ld      a,b
c8d1 d401bd    call    nc,$bd01			; firmware function: kl done sync
c8d4 f1        pop     af
c8d5 17        rla     
c8d6 30de      jr      nc,$c8b6         ; (-$22)
c8d8 3a16ac    ld      a,($ac16)
c8db e604      and     $04
c8dd c47fc4    call    nz,$c47f
c8e0 2a1bae    ld      hl,($ae1b)
c8e3 3a16ac    ld      a,($ac16)
c8e6 e603      and     $03
c8e8 c8        ret     z

c8e9 1f        rra     
c8ea da3ecc    jp      c,$cc3e
c8ed 23        inc     hl
c8ee f1        pop     af
c8ef c377de    jp      $de77
c8f2 221cac    ld      ($ac1c),hl
c8f5 3e04      ld      a,$04
c8f7 3052      jr      nc,$c94b         ; (+$52)
c8f9 2a1aac    ld      hl,($ac1a)
c8fc 7c        ld      a,h
c8fd b5        or      l
c8fe c4b5de    call    nz,$deb5
c901 3e41      ld      a,$41
c903 3046      jr      nc,$c94b         ; (+$46)
c905 c5        push    bc
c906 cdb9bc    call    $bcb9			; firmware function: sound continue
c909 c1        pop     bc
c90a 1117ac    ld      de,$ac17
c90d 0e02      ld      c,$02
c90f 1822      jr      $c933            ; (+$22)
c911 d5        push    de
c912 cd25de    call    $de25
defb &9f
c916 cd27e8    call    $e827
c919 42        ld      b,d
c91a 4b        ld      c,e
c91b d1        pop     de
c91c e5        push    hl
c91d 210a00    ld      hl,$000a
c920 19        add     hl,de
c921 71        ld      (hl),c
c922 23        inc     hl
c923 70        ld      (hl),b
c924 e1        pop     hl
c925 c9        ret     

c926 23        inc     hl
c927 23        inc     hl
c928 23        inc     hl
c929 eb        ex      de,hl
c92a cdb5de    call    $deb5
c92d 3e40      ld      a,$40
c92f 301a      jr      nc,$c94b         ; (+$1a)
c931 0e01      ld      c,$01
c933 d5        push    de
c934 cd93c7    call    $c793
c937 2a1bae    ld      hl,($ae1b)
c93a eb        ex      de,hl
c93b e1        pop     hl
c93c 70        ld      (hl),b
c93d 23        inc     hl
c93e 73        ld      (hl),e
c93f 23        inc     hl
c940 72        ld      (hl),d
c941 23        inc     hl
c942 5e        ld      e,(hl)
c943 23        inc     hl
c944 56        ld      d,(hl)
c945 eb        ex      de,hl
c946 221bae    ld      ($ae1b),hl
c949 3ec2      ld      a,$c2
c94b 2116ac    ld      hl,$ac16
c94e b6        or      (hl)
c94f 77        ld      (hl),a
c950 c9        ret     

c951 7e        ld      a,(hl)
c952 23        inc     hl
c953 5e        ld      e,(hl)
c954 23        inc     hl
c955 56        ld      d,(hl)
c956 d5        push    de
c957 01f7ff    ld      bc,$fff7
c95a 09        add     hl,bc
c95b cd01bd    call    $bd01			; firmware function: KL DONE SYNC
c95e e1        pop     hl
c95f 1811      jr      $c972            ; (+$11)
c961 7e        ld      a,(hl)
c962 2a1cac    ld      hl,($ac1c)
c965 01fcff    ld      bc,$fffc			; JP (BC)
c968 09        add     hl,bc
c969 cd01bd    call    $bd01			; firmware function: KL DONE SYNC
c96c cd7fc4    call    $c47f
c96f 2a18ac    ld      hl,($ac18)
c972 f1        pop     af
c973 c360de    jp      $de60

;;========================================================================
;; ON BREAK, ON BREAK CONT, ON BREAK STOP

c976 cd7cc9    call    $c97c
c979 c32cde    jp      $de2c			; get next token skipping space
c97c fe8b      cp      $8b				; token for "CONT"
c97e cad0c4    jp      z,$c4d0			; ON BREAK CONT
c981 fece      cp      $ce				; token for "STOP"
c983 110000    ld      de,$0000
c986 2808      jr      z,$c990          ; ON BREAK STOP

;; 
c988 cd25de    call    $de25
defb &9f								; token for "GOSUB"
c98c cd27e8    call    $e827
c98f 2b        dec     hl
c990 ed531aac  ld      ($ac1a),de
c994 c3d3c4    jp      $c4d3			; ON BREAK STOP

;;========================================================================
;; DI
c997 e5        push    hl
c998 cd04bd    call    $bd04			; firmware function: KL EVENT DISABLE
c99b e1        pop     hl
c99c c9        ret     
;;========================================================================
;; EI
c99d e5        push    hl
c99e cd07bd    call    $bd07			; firmware function: KL EVENT ENABLE
c9a1 e1        pop     hl
c9a2 c9        ret     
;;========================================================================
c9a3 cda7bc    call    $bca7			; firmware function: SOUND RESET
c9a6 2142ac    ld      hl,$ac42
c9a9 0604      ld      b,$04
c9ab e5        push    hl
c9ac cdecbc    call    $bcec			; firmware function: KL DEL TICKER
c9af e1        pop     hl
c9b0 111200    ld      de,$0012
c9b3 19        add     hl,de
c9b4 10f5      djnz    $c9ab            
c9b6 cd48bb    call    $bb48			; firmware function: KL DISARM BREAK
c9b9 cdf5bc    call    $bcf5			; firmware function: KL SYNC RESET
c9bc 210000    ld      hl,$0000
c9bf 221aac    ld      ($ac1a),hl
c9c2 cd7fc4    call    $c47f
c9c5 211eac    ld      hl,$ac1e
c9c8 110503    ld      de,$0305
c9cb 010008    ld      bc,$0800
c9ce cddac9    call    $c9da
c9d1 2148ac    ld      hl,$ac48
c9d4 110b04    ld      de,$040b
c9d7 010102    ld      bc,$0201
c9da c5        push    bc
c9db d5        push    de
c9dc 0efd      ld      c,$fd
c9de 1126c9    ld      de,$c926
c9e1 cdefbc    call    $bcef			; firmware function: KL INIT EVENT
c9e4 d1        pop     de
c9e5 d5        push    de
c9e6 1600      ld      d,$00
c9e8 19        add     hl,de
c9e9 d1        pop     de
c9ea c1        pop     bc
c9eb 79        ld      a,c
c9ec b7        or      a
c9ed 2802      jr      z,$c9f1          ; (+$02)
c9ef cb00      rlc     b
c9f1 15        dec     d
c9f2 20e6      jr      nz,$c9da         ; (-$1a)
c9f4 c9        ret     

;;========================================================================
;; SQ

c9f5 cd19de    call    $de19 ; check for open bracket
c9f8 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
c9fb f5        push    af
c9fc cd10ca    call    $ca10
c9ff b7        or      a
ca00 201d      jr      nz,$ca1f         ; (+$1d)
ca02 cd1dde    call    $de1d ; check for close bracket
ca05 cd11c9    call    $c911
ca08 f1        pop     af
ca09 e5        push    hl
ca0a eb        ex      de,hl
ca0b cdb0bc    call    $bcb0				; firmware function: sound arm event
ca0e e1        pop     hl
ca0f c9        ret     

ca10 1f        rra     
ca11 111eac    ld      de,$ac1e
ca14 d8        ret     c

ca15 1f        rra     
ca16 112aac    ld      de,$ac2a
ca19 d8        ret     c

ca1a 1f        rra     
ca1b 1136ac    ld      de,$ac36
ca1e d8        ret     c

ca1f c34dcb    jp      $cb4d			; Error: Improper Argument

;;==================================================================
;; AFTER
ca22 cdcece    call    $cece
ca25 010000    ld      bc,$0000
ca28 1805      jr      $ca2f            ; (+$05)
;;==================================================================
;; EVERY
ca2a cdcece    call    $cece
ca2d 42        ld      b,d
ca2e 4b        ld      c,e
ca2f d5        push    de
ca30 c5        push    bc
ca31 cd41de    call    $de41
ca34 110000    ld      de,$0000
ca37 dcd8ce    call    c,$ced8 ; get number
ca3a eb        ex      de,hl
ca3b cd62ca    call    $ca62
ca3e e5        push    hl
ca3f 010600    ld      bc,$0006
ca42 09        add     hl,bc
ca43 eb        ex      de,hl
ca44 cd11c9    call    $c911
ca47 d1        pop     de
ca48 c1        pop     bc
ca49 e3        ex      (sp),hl
ca4a eb        ex      de,hl
ca4b cde9bc    call    $bce9			; firmware function: kl add ticker
ca4e e1        pop     hl
ca4f c9        ret     

;;========================================================
;; REMAIN

ca50 cdb6fe    call    $feb6
ca53 cd62ca    call    $ca62
ca56 cdecbc    call    $bcec			; firmware function: kl del ticker
ca59 3803      jr      c,$ca5e          ; (+$03)
ca5b 110000    ld      de,$0000
ca5e eb        ex      de,hl
ca5f c335ff    jp      $ff35
ca62 7c        ld      a,h
ca63 b7        or      a
ca64 20b9      jr      nz,$ca1f         ; (-$47)
ca66 7d        ld      a,l
ca67 fe04      cp      $04
ca69 30b4      jr      nc,$ca1f         ; (-$4c)
ca6b 87        add     a,a
ca6c 87        add     a,a
ca6d 87        add     a,a
ca6e 85        add     a,l
ca6f 87        add     a,a
ca70 6f        ld      l,a
ca71 0142ac    ld      bc,$ac42
ca74 09        add     hl,bc
ca75 c9        ret     

ca76 eb        ex      de,hl
ca77 cdb1de    call    $deb1
ca7a eb        ex      de,hl
ca7b 2b        dec     hl
ca7c 0601      ld      b,$01
ca7e 0e1a      ld      c,$1a
ca80 cddde9    call    $e9dd
ca83 e5        push    hl
ca84 cd2cde    call    $de2c			; get next token skipping space
ca87 feb0      cp      $b0
ca89 2808      jr      z,$ca93          ; (+$08)
ca8b e1        pop     hl
ca8c fe9e      cp      $9e
ca8e 20ee      jr      nz,$ca7e         ; (-$12)
ca90 04        inc     b
ca91 18eb      jr      $ca7e            ; (-$15)
ca93 f1        pop     af
ca94 eb        ex      de,hl
ca95 e5        push    hl
ca96 cdb1de    call    $deb1
ca99 e3        ex      (sp),hl
ca9a cdadde    call    $dead
ca9d eb        ex      de,hl
ca9e 05        dec     b
ca9f 2824      jr      z,$cac5          ; (+$24)
caa1 cd2cde    call    $de2c			; get next token skipping space
caa4 280e      jr      z,$cab4          ; (+$0e)
caa6 c5        push    bc
caa7 d5        push    de
caa8 cdbfd6    call    $d6bf
caab d1        pop     de
caac c1        pop     bc
caad cd41de    call    $de41
cab0 3002      jr      nc,$cab4         ; (+$02)
cab2 10f2      djnz    $caa6            ; (-$0e)
cab4 2b        dec     hl
cab5 78        ld      a,b
cab6 b7        or      a
cab7 280c      jr      z,$cac5          ; (+$0c)
cab9 eb        ex      de,hl
caba cdb1de    call    $deb1
cabd e3        ex      (sp),hl
cabe cdadde    call    $dead
cac1 e1        pop     hl
cac2 eb        ex      de,hl
cac3 18b9      jr      $ca7e            ; (-$47)
cac5 d1        pop     de
cac6 c32cde    jp      $de2c			; get next token skipping space
cac9 2b        dec     hl
caca eb        ex      de,hl
cacb cdb1de    call    $deb1
cace eb        ex      de,hl
cacf 0600      ld      b,$00
cad1 04        inc     b
cad2 0e1d      ld      c,$1d
cad4 cddde9    call    $e9dd
cad7 e5        push    hl
cad8 cd2cde    call    $de2c			; get next token skipping space
cadb e1        pop     hl
cadc fed6      cp      $d6
cade 28f1      jr      z,$cad1          ; (-$0f)
cae0 fed5      cp      $d5
cae2 20ee      jr      nz,$cad2         ; (-$12)
cae4 10ec      djnz    $cad2            ; (-$14)
cae6 cd2cde    call    $de2c			; get next token skipping space
cae9 c32cde    jp      $de2c			; get next token skipping space

caec cdf9ca    call    $caf9			; edit
caef d8        ret     c

caf0 cda1c1    call    $c1a1
caf3 3100c0    ld      sp,$c000
caf6 c35dde    jp      $de5d

;;------------------------------------------------------------------------------------------
caf9 218aac    ld      hl,$ac8a
cafc 3600      ld      (hl),$00
cafe c35ebd    jp      $bd5e			; TEXT INPUT

;;------------------------------------------------------------------------------------------
cb01 218aac    ld      hl,$ac8a
cb04 cd5ebd    call    $bd5e		; TEXT INPUT
cb07 c398c3    jp      $c398      ;; new text line
;;------------------------------------------------------------------------------------------

cb0a c5        push    bc
cb0b 218aac    ld      hl,$ac8a
cb0e e5        push    hl
cb0f 0600      ld      b,$00
cb11 0ef5      ld      c,$f5
cb13 3600      ld      (hl),$00
cb15 cd5cc4    call    $c45c ; read byte from cassette or disc
cb18 301a      jr      nc,$cb34         ; (+$1a)
cb1a fe0d      cp      $0d
cb1c 2810      jr      z,$cb2e          ; (+$10)
cb1e 4f        ld      c,a
cb1f 04        inc     b
cb20 1004      djnz    $cb26            ; (+$04)
cb22 fe0a      cp      $0a
cb24 28eb      jr      z,$cb11          ; (-$15)
cb26 77        ld      (hl),a
cb27 23        inc     hl
cb28 10e9      djnz    $cb13            ; (-$17)
cb2a cd45cb    call    $cb45
cb2d 17        rla     
cb2e 79        ld      a,c
cb2f fe0a      cp      $0a
cb31 28de      jr      z,$cb11          ; (-$22)
cb33 37        scf     
cb34 e1        pop     hl
cb35 c1        pop     bc
cb36 c9        ret     

cb37 af        xor     a
cb38 3291ad    ld      ($ad91),a
cb3b 3290ad    ld      ($ad90),a
cb3e cdb1de    call    $deb1
cb41 228cad    ld      ($ad8c),hl
cb44 c9        ret     

;;========================================================================
;; - byte following call is error code
cb45 e3        ex      (sp),hl
cb46 7e        ld      a,(hl)
cb47 180c      jr      $cb55            
;;========================================================================
;; Error: Syntax Error
cb49 3e02      ld      a,$02
cb4b 1808      jr      $cb55            ; (+$08)
;;========================================================================
;; Error: Improper Argument

cb4d 3e05      ld      a,$05
cb4f 1804      jr      $cb55            ; (+$04)
;;========================================================================
;; ERROR
cb51 cdc3ce    call    $cec3
cb54 c0        ret     nz

cb55 cd3bcb    call    $cb3b
cb58 2a1bae    ld      hl,($ae1b)
cb5b 228ead    ld      ($ad8e),hl
cb5e cd83cc    call    $cc83
cb61 cd3cf6    call    $f63c
cb64 3100c0    ld      sp,$c000
cb67 2a19ae    ld      hl,($ae19)
cb6a cd6ef6    call    $f66e
cb6d cdccfb    call    $fbcc
cb70 cd20da    call    $da20
cb73 cdaacb    call    $cbaa
cb76 2a96ad    ld      hl,($ad96)
cb79 eb        ex      de,hl
cb7a 2198ad    ld      hl,$ad98
cb7d 300c      jr      nc,$cb8b         ; (+$0c)
cb7f 7a        ld      a,d
cb80 b3        or      e
cb81 2808      jr      z,$cb8b          ; (+$08)
cb83 a6        and     (hl)
cb84 2005      jr      nz,$cb8b         ; (+$05)
cb86 35        dec     (hl)
cb87 eb        ex      de,hl
cb88 c377de    jp      $de77
cb8b 3600      ld      (hl),$00
cb8d 3a90ad    ld      a,($ad90)
cb90 cd8cce    call    $ce8c
cb93 2a8cad    ld      hl,($ad8c)
cb96 cdadde    call    $dead
cb99 3a90ad    ld      a,($ad90)
cb9c ee20      xor     $20
cb9e 2004      jr      nz,$cba4         ; (+$04)
cba0 3a91ad    ld      a,($ad91)
cba3 17        rla     
cba4 d404cc    call    nc,$cc04
cba7 c358c0    jp      $c058
;;=======================================================================

cbaa 2a8cad    ld      hl,($ad8c)
cbad cdb8de    call    $deb8
cbb0 d8        ret     c
cbb1 210000    ld      hl,$0000
cbb4 c9        ret     
;;=======================================================================

cbb5 d5        push    de
cbb6 e5        push    hl
cbb7 21f6cd    ld      hl,$cdf6
cbba 1e0b      ld      e,$0b
cbbc 1807      jr      $cbc5            ; (+$07)
cbbe d5        push    de
cbbf e5        push    hl
cbc0 21bfcd    ld      hl,$cdbf
cbc3 1e06      ld      e,$06
cbc5 f5        push    af
cbc6 e5        push    hl
cbc7 2a96ad    ld      hl,($ad96)
cbca 7c        ld      a,h
cbcb b5        or      l
cbcc e1        pop     hl
cbcd 7b        ld      a,e
cbce c255cb    jp      nz,$cb55
cbd1 af        xor     a
cbd2 cda6c1    call    $c1a6
cbd5 f5        push    af
cbd6 eb        ex      de,hl
cbd7 cd79ce    call    $ce79
cbda eb        ex      de,hl
cbdb cd98c3    call    $c398      ;; new text line
cbde f1        pop     af
cbdf cda6c1    call    $c1a6
cbe2 f1        pop     af
cbe3 e1        pop     hl
cbe4 d1        pop     de
cbe5 c9        ret     

cbe6 cdd0c3    call    $c3d0
cbe9 21f1cb    ld      hl,$cbf1
cbec cd15cc    call    $cc15
cbef 181c      jr      $cc0d            ; (+$1c)
cfb1:
defb "Undefined line ",0

cc01 111ccc    ld      de,$cc1c			; "Break"
cc04 cda1c1    call    $c1a1
cc07 cdd0c3    call    $c3d0
cc0a cd79ce    call    $ce79
cc0d cdb5de    call    $deb5
cc10 d0        ret     nc

cc11 eb        ex      de,hl
cc12 2121cc    ld      hl,$cc21		;; " in " message
cc15 cd8bc3    call    $c38b		;; display 0 terminated string
cc18 eb        ex      de,hl
cc19 c344ef    jp      $ef44

cc1c:
"Brea","k"+&80		(&eb)

cc21:
defb " in ",0

;;========================================================================
;; STOP

cc26 c0        ret     nz
cc27 e5        push    hl
cc28 cd01cc    call    $cc01
cc2b e1        pop     hl
cc2c cd66cc    call    $cc66
cc2f 1832      jr      $cc63            ; (+$32)

;;========================================================================
;; END
cc31 c0        ret     nz
cc32 cd66cc    call    $cc66
cc35 1823      jr      $cc5a            ; (+$23)
cc37 3291ad    ld      ($ad91),a
cc3a cd45cb    call    $cb45
cc3d 20cd      jr      nz,$cc0c         ; (-$33)
cc3f 01cc2a    ld      bc,$2acc
cc42 1b        dec     de
cc43 ae        xor     (hl)
cc44 cd83cc    call    $cc83
cc47 181a      jr      $cc63            ; (+$1a)
cc49 cdb5de    call    $deb5
cc4c 3012      jr      nc,$cc60         ; (+$12)
cc4e cd7ecc    call    $cc7e
cc51 3a98ad    ld      a,($ad98)
cc54 b7        or      a
cc55 3e13      ld      a,$13
cc57 c255cb    jp      nz,$cb55
cc5a cdedd2    call    $d2ed			; CLOSEIN
cc5d cdf5d2    call    $d2f5			; CLOSEOUT
cc60 cdaade    call    $deaa
cc63 c358c0    jp      $c058
cc66 eb        ex      de,hl
cc67 cdb5de    call    $deb5
cc6a eb        ex      de,hl
cc6b d0        ret     nc

cc6c 7e        ld      a,(hl)
cc6d fe01      cp      $01
cc6f 280b      jr      z,$cc7c          ; (+$0b)
cc71 23        inc     hl
cc72 7e        ld      a,(hl)
cc73 23        inc     hl
cc74 b6        or      (hl)
cc75 2807      jr      z,$cc7e          ; (+$07)
cc77 23        inc     hl
cc78 cdadde    call    $dead
cc7b 23        inc     hl
cc7c 1805      jr      $cc83            ; (+$05)
cc7e 210000    ld      hl,$0000
cc81 180c      jr      $cc8f            ; (+$0c)
cc83 eb        ex      de,hl
cc84 cdb5de    call    $deb5
cc87 d0        ret     nc

cc88 cdb1de    call    $deb1
cc8b 2294ad    ld      ($ad94),hl
cc8e eb        ex      de,hl
cc8f 2292ad    ld      ($ad92),hl
cc92 c9        ret     

;;=============================================================================
;; CONT
cc93 c0        ret     nz
cc94 2a92ad    ld      hl,($ad92)
cc97 7c        ld      a,h
cc98 b5        or      l
cc99 3e11      ld      a,$11
cc9b ca55cb    jp      z,$cb55
cc9e e5        push    hl
cc9f 2a94ad    ld      hl,($ad94)
cca2 cdadde    call    $dead
cca5 cdb9bc    call    $bcb9			; firmware function: sound continue
cca8 e1        pop     hl
cca9 c360de    jp      $de60
ccac af        xor     a
ccad 3298ad    ld      ($ad98),a
ccb0 110000    ld      de,$0000
ccb3 ed5396ad  ld      ($ad96),de
ccb7 c9        ret     

ccb8 cd2cde    call    $de2c			; get next token skipping space
ccbb cd25de    call    $de25
defb &a0
ccbf cd48cf    call    $cf48
ccc2 e5        push    hl
ccc3 cd5ce8    call    $e85c
ccc6 eb        ex      de,hl
ccc7 e1        pop     hl
ccc8 18e9      jr      $ccb3            ; (-$17)

;;========================================================================
;; ON BREAK GOTO
ccca cdb0cc    call    $ccb0
cccd 3a98ad    ld      a,($ad98)
ccd0 b7        or      a
ccd1 c8        ret     z

ccd2 c364cb    jp      $cb64

;;========================================================================
;; RESUME

ccd5 2811      jr      z,$cce8          ; (+$11)
ccd7 feb0      cp      $b0
ccd9 2814      jr      z,$ccef          ; (+$14)
ccdb cd27e8    call    $e827
ccde c0        ret     nz

ccdf cdfacc    call    $ccfa
cce2 eb        ex      de,hl
cce3 23        inc     hl
cce4 f1        pop     af
cce5 c377de    jp      $de77
cce8 cdfacc    call    $ccfa
cceb f1        pop     af
ccec c360de    jp      $de60
ccef cd2cde    call    $de2c			; get next token skipping space
ccf2 c0        ret     nz

ccf3 cdfacc    call    $ccfa
ccf6 23        inc     hl
ccf7 c3a3e9    jp      $e9a3			;; DATA

ccfa 3a98ad    ld      a,($ad98)
ccfd b7        or      a
ccfe 3e14      ld      a,$14
cd00 ca55cb    jp      z,$cb55
cd03 af        xor     a
cd04 3290ad    ld      ($ad90),a
cd07 3298ad    ld      ($ad98),a
cd0a 2a8cad    ld      hl,($ad8c)
cd0d cdadde    call    $dead
cd10 2a8ead    ld      hl,($ad8e)
cd13 c9        ret     

cd14:
defb "pe"		;;
cd16:
defb "in"		;;
cd18:
defb "er"		;;
cd1a:
defb "ex"		;;
cd1c:
defb "ion"		;;
cd1f:
defb " fu"		;;
cd22:
defb "com"		;;
cd25:
defb "ran"		;;
cd28:
defb "t o"		;;
cd2b:
defb "men"		;;
cd2e:
defb "ted"		;;
cd31:
defb "WEND"		;;
cd35:
defb "o",&00,"n"		;;
cd38:
defb "File "		;;
cd3d:
defb "not "		;;
cd41:
defb "too "		;;
cd45:
defb " mis"		;;
cd49:
defb "L",&01,"e "		;;
cd4d:
defb "NEXT"		;;
cd51:
defb "s",&04," "		;;
cd54:
defb ,&05,"ll"		;;
cd57:
defb " ",&02,"ror"		;;
cd5c:
defb "RESUME"		;;
cd62:
defb "Str",&01,"g "		;;
cd68:
defb " ",&06,"mand"		;;
cd6e:
defb ,&10,"s",&01,"g"		;;
cd72:
defb "Unknown"		;;
cd79:
defb ,&0f,"long"		;;
cd7e:
defb "already "		;;
cd86:
defb "Un",&03,"pec",&0a," "		;;
cd8e:
defb "irect",&18		;;
cd94:
defb ,&1a,&15		;;
cd96:
defb ,&1d,&12		;;
cd98:
defb "Syntax",&15		;;
cd9f:
defb ,&1d,"RETURN"		;;
cda6:
defb "DATA ",&03,"haus",&0a		;;
cdb1:
defb "Impro",&00,"r argu",&09,"t"		;;
cdbf:
defb "Ov",&02,"flow"		;;
cdc6:
defb "Memory",&14		;;
cdcd:
defb ,&11,"does ",&0e,&03,"ist"		;;
cdd8:
defb "Subscrip",&08,"u",&08,"f ",&07,"ge"		;;
cde8:
defb "Array ",&1c,"di",&09,"s",&04,"ed"		;;
cdf6:
defb "Divi",&13,"by z",&02,"o"		;;
ce01:
defb "Invalid d",&1e		;;
ce0b:
defb "Ty",&00,&10,"match"		;;
ce14:
defb ,&17,"space",&14		;;
ce1b:
defb ,&17,&1b		;;
ce1d:
defb ,&17,&03,"pres",&13,&0f,&06,"pl",&03		;;
ce29:
defb "Can",&0e,"CONT",&01,"ue"		;;
ce34:
defb ,&1a," us",&02,&05,"nct",&04		;;
ce3e:
defb ,&16,&19		;;
ce40:
defb ,&1d,&16		;;
ce42:
defb "D",&1e," found"		;;
ce4a:
defb "O",&00,&07,"d",&19		;;
ce4f:
defb ,&11,&1b		;;
ce51:
defb "EOF met"		;;
ce58:
defb ,&0d,"ty",&00,&15		;;
ce5d:
defb ,&12,&19		;;
ce5f:
defb ,&0d,&1c,&0c		;;
ce62:
defb ,&1a,&18		;;
ce64:
defb ,&0b,&19		;;
ce66:
defb ,&1d,&0b		;;
ce68:
defb ,&0d,&0e,&0c		;;
ce6b:
defb "Broken ",&01		;;

;;------------------------------------------------------
ce73 1114cd    ld      de,$cd14
ce76 cd92ce    call    $ce92
ce79 d5        push    de
ce7a 1a        ld      a,(de)			; get code
ce7b e67f      and     $7f
ce7d fe20      cp      $20

;; if &20<code<&7f -> code is a ASCII character. Display character.
;; if &00<code<&1f -> code is a message number. Display this message.
ce7f d4a0c3    call    nc,$c3a0           ;; display text char
ce82 dc73ce    call    c,$ce73			  ;; display message
ce85 d1        pop     de
;; get char
ce86 1a        ld      a,(de)
ce87 13        inc     de
;; end of string marker
ce88 17        rla     
ce89 30ee      jr      nc,$ce79         ; (-$12)

ce8b c9        ret     
;;------------------------------------------------------

ce8c 1194cd    ld      de,$cd94
ce8f fe21      cp      $21
ce91 d0        ret     nc

ce92 b7        or      a
ce93 c8        ret     z

ce94 c5        push    bc
ce95 47        ld      b,a
ce96 1a        ld      a,(de)
ce97 13        inc     de
ce98 17        rla     
ce99 30fb      jr      nc,$ce96         ; (-$05)
ce9b 10f9      djnz    $ce96            ; (-$07)
ce9d c1        pop     bc
ce9e c9        ret     

ce9f d3c7      out     ($c7),a
cea1 c7        rst     $00
cea2 c7        rst     $00
cea3 c7        rst     $00
cea4 c7        rst     $00
cea5 c7        rst     $00
cea6 c7        rst     $00
cea7 c7        rst     $00
cea8 c7        rst     $00
cea9 c7        rst     $00
ceaa c7        rst     $00
ceab c7        rst     $00
ceac c7        rst     $00
cead c7        rst     $00
ceae c7        rst     $00
ceaf c7        rst     $00
ceb0 c7        rst     $00
ceb1 c7        rst     $00
ceb2 c7        rst     $00
ceb3 c7        rst     $00
ceb4 c7        rst     $00
ceb5 c7        rst     $00
ceb6 c7        rst     $00
ceb7 c7        rst     $00

;;----------------------------------------------------------------------

;; get number
ceb8 cdd8ce    call    $ced8 			; get number
cebb f5        push    af

;; if high byte is set it's higher than 256
cebc 7a        ld      a,d
cebd b7        or      a
cebe 200b      jr      nz,$cecb   		; Error: Improper argument      

;; it's lower than 256 return number
cec0 f1        pop     af
cec1 7b        ld      a,e
cec2 c9        ret     

;;----------------------------------------------------------------------
cec3 cdd8ce    call    $ced8 ; get number
cec6 f5        push    af
cec7 7a        ld      a,d
cec8 b3        or      e
cec9 20f1      jr      nz,$cebc         ; (-$0f)

cecb c34dcb    jp      $cb4d			; Error: Improper Argument

cece cdd8ce    call    $ced8 ; get number
ced1 f5        push    af
ced2 7a        ld      a,d
ced3 17        rla     
ced4 38f5      jr      c,$cecb          ; (-$0b)
ced6 f1        pop     af
ced7 c9        ret     

ced8 cd62cf    call    $cf62
cedb f5        push    af
cedc eb        ex      de,hl
cedd cdb6fe    call    $feb6
cee0 eb        ex      de,hl
cee1 f1        pop     af
cee2 c9        ret     

cee3 cd62cf    call    $cf62
cee6 cd66ff    call    $ff66
cee9 200d      jr      nz,$cef8         ; (+$0d)
ceeb e5        push    hl
ceec 2aa0b0    ld      hl,($b0a0)
ceef cd58fb    call    $fb58
cef2 eb        ex      de,hl
cef3 e1        pop     hl
cef4 c9        ret     

cef5 cd62cf    call    $cf62
cef8 f5        push    af
cef9 c5        push    bc
cefa e5        push    hl
cefb cdebfe    call    $feeb
cefe eb        ex      de,hl
ceff e1        pop     hl
cf00 c1        pop     bc
cf01 f1        pop     af
cf02 c9        ret     

cf03 cd62cf    call    $cf62
cf06 c3f5fb    jp      $fbf5
cf09 cd62cf    call    $cf62
cf0c c35eff    jp      $ff5e
cf0f 010100    ld      bc,$0001
cf12 11ffff    ld      de,$ffff
cf15 cd41de    call    $de41
cf18 d43dde    call    nc,$de3d
cf1b d8        ret     c

cf1c fe23      cp      $23				; #
cf1e c8        ret     z

cf1f fef5      cp      $f5
cf21 280a      jr      z,$cf2d          ; (+$0a)
cf23 cd48cf    call    $cf48
cf26 42        ld      b,d
cf27 4b        ld      c,e
cf28 c8        ret     z

cf29 cd41de    call    $de41
cf2c d8        ret     c

cf2d cd25de    call    $de25
defb &f5
cf31 11ffff    ld      de,$ffff
cf34 c8        ret     z

cf35 cd41de    call    $de41
cf38 d8        ret     c

cf39 cd48cf    call    $cf48
cf3c c441de    call    nz,$de41
cf3f eb        ex      de,hl
cf40 cddeff    call    $ffde ; HL=BC?
cf43 da4dcb    jp      c,$cb4d			; Error: Improper Argument
cf46 eb        ex      de,hl
cf47 c9        ret     

cf48 7e        ld      a,(hl)
cf49 23        inc     hl
cf4a 5e        ld      e,(hl)
cf4b 23        inc     hl
cf4c 56        ld      d,(hl)
cf4d fe1e      cp      $1e          ; 16-bit line number
cf4f 280e      jr      z,$cf5f          ; (+$0e)
cf51 fe1d      cp      $1d          ; 16-bit line address pointer
cf53 c249cb    jp      nz,$cb49			; Error: Syntax Error
cf56 e5        push    hl
cf57 eb        ex      de,hl
cf58 23        inc     hl
cf59 23        inc     hl
cf5a 23        inc     hl
cf5b 5e        ld      e,(hl)
cf5c 23        inc     hl
cf5d 56        ld      d,(hl)
cf5e e1        pop     hl
cf5f c32cde    jp      $de2c			; get next token skipping space

cf62 c5        push    bc
cf63 0600      ld      b,$00
cf65 cd6dcf    call    $cf6d
cf68 c1        pop     bc
cf69 2b        dec     hl
cf6a c32cde    jp      $de2c			; get next token skipping space

cf6d 2b        dec     hl
cf6e c5        push    bc
cf6f cd33d0    call    $d033			; process tokenised line
cf72 e5        push    hl
cf73 e1        pop     hl
cf74 c1        pop     bc
cf75 7e        ld      a,(hl)
cf76 feee      cp      $ee
cf78 d8        ret     c

cf79 fefe      cp      $fe
cf7b d0        ret     nc

cf7c fef4      cp      $f4
cf7e 3845      jr      c,$cfc5          ; (+$45)
cf80 cc66ff    call    z,$ff66
cf83 2012      jr      nz,$cf97         ; (+$12)
cf85 c5        push    bc
cf86 e5        push    hl
cf87 2aa0b0    ld      hl,($b0a0)
cf8a e3        ex      (sp),hl
cf8b cd33d0    call    $d033			; process tokenised line
cf8e cd5eff    call    $ff5e
cf91 e3        ex      (sp),hl
cf92 cd1df9    call    $f91d
cf95 18dc      jr      $cf73            ; (-$24)
cf97 7e        ld      a,(hl)
cf98 d6f4      sub     $f4
cf9a 5f        ld      e,a
cf9b 87        add     a,a
cf9c 83        add     a,e
cf9d c6ed      add     a,$ed
cf9f 5f        ld      e,a
cfa0 cecf      adc     a,$cf
cfa2 93        sub     e
cfa3 57        ld      d,a
cfa4 eb        ex      de,hl
cfa5 78        ld      a,b
cfa6 be        cp      (hl)
cfa7 eb        ex      de,hl
cfa8 d0        ret     nc

cfa9 c5        push    bc
cfaa cd74ff    call    $ff74
cfad d5        push    de
cfae c5        push    bc
cfaf 1a        ld      a,(de)
cfb0 47        ld      b,a
cfb1 cd6ecf    call    $cf6e
cfb4 c1        pop     bc
cfb5 e3        ex      (sp),hl
cfb6 23        inc     hl
cfb7 7e        ld      a,(hl)
cfb8 23        inc     hl
cfb9 66        ld      h,(hl)
cfba 6f        ld      l,a
cfbb eb        ex      de,hl
cfbc 79        ld      a,c
cfbd cd62f6    call    $f662
cfc0 cdfeff    call    $fffe			; JP (DE)
cfc3 18ae      jr      $cf73            ; (-$52)
cfc5 78        ld      a,b
cfc6 fe0a      cp      $0a
cfc8 d0        ret     nc

cfc9 c5        push    bc
cfca 7e        ld      a,(hl)
cfcb d6ed      sub     $ed
cfcd 47        ld      b,a
cfce cd66ff    call    $ff66
cfd1 110bd0    ld      de,$d00b
cfd4 20d4      jr      nz,$cfaa         ; (-$2c)
cfd6 e5        push    hl
cfd7 2aa0b0    ld      hl,($b0a0)
cfda e3        ex      (sp),hl
cfdb c5        push    bc
cfdc 060a      ld      b,$0a
cfde cd6ecf    call    $cf6e
cfe1 c1        pop     bc
cfe2 e3        ex      (sp),hl
cfe3 c5        push    bc
cfe4 cd3ff9    call    $f93f
cfe7 c1        pop     bc
cfe8 cd13d0    call    $d013
cfeb 1886      jr      $cf73            ; (-$7a)
cfed 0c        inc     c
cfee 0c        inc     c
cfef fd0c      inc     c
cff1 21fd12    ld      hl,$12fd
cff4 35        dec     (hl)
cff5 fd12      ld      (de),a
cff7 52        ld      d,d
cff8 fd1636    ld      d,$36
cffb d5        push    de
cffc 1067      djnz    $d065            ; (+$67)
cffe fd0687    ld      b,$87
d001 fd0e79    ld      c,$79
d004 fd04      inc     b
d006 92        sub     d
d007 fd02      ld      (bc),a
d009 9c        sbc     a,h
d00a fd0a      ld      a,(bc)
d00c 0ed0      ld      c,$d0
d00e c5        push    bc
d00f cd49fd    call    $fd49
d012 c1        pop     bc
d013 c601      add     a,$01
d015 8f        adc     a,a
d016 a0        and     b
d017 c6ff      add     a,$ff
d019 9f        sbc     a,a
d01a c32dff    jp      $ff2d

;;=======================================================================
;; -
d01d 0614      ld      b,$14
d01f cd6dcf    call    $cf6d
d022 e5        push    hl
d023 cdb4fd    call    $fdb4
d026 e1        pop     hl
d027 c9        ret     

;;=======================================================================
;; NOT
d028 0608      ld      b,$08
d02a cd6dcf    call    $cf6d
d02d e5        push    hl
d02e cda6fd    call    $fda6
d031 e1        pop     hl
d032 c9        ret     

;;==========================================================================
;; process tokenised line

d033 cd2cde    call    $de2c			; get next token skipping space
d036 281d      jr      z,$d055          ; (+$1d)
d038 fe0e      cp      $0e
d03a 3838      jr      c,$d074          ; 
d03c fe20      cp      $20				; (space)
d03e 3852      jr      c,$d092          ; 
d040 fe22      cp      $22				; (double quote)
d042 ca79f8    jp      z,$f879

d045 feff      cp      $ff				; keyword with &ff prefix?
d047 cadad0    jp      z,$d0da

d04a e5        push    hl
d04b 2159d0    ld      hl,$d059
d04e cdb4ff    call    $ffb4
d051 e3        ex      (sp),hl
d052 c32cde    jp      $de2c			; get next token skipping space

;---------------------------------------------------------------------------
d055 cd45cb    call    $cb45
d058 16									; Error: Operand Missing
;---------------------------------------------------------------------------

d059:
defb &08
defw &d0d7				;; Error: Syntax Error

defb &f5				;; -
defw &d01d

defb &f4				;; +
defw &d036

defb &28				;; (
defw &d0d1

defb &fe				;; NOT
defw &d028

defb &e3				;; ERL
defw &d142

defb &e4				;; FN
defw &d18a

defb &ac				;; MID$
defw &f9e2

defb &40				;; @
defw &d14e

;;---------------------------------------------------------------------------
;; code &00-&0d

d074 cdc9d6    call    $d6c9
d077 300b      jr      nc,$d084         ; (+$0b)
d079 fe03      cp      $03
d07b 280f      jr      z,$d08c          ; (+$0f)
d07d e5        push    hl
d07e eb        ex      de,hl
d07f cd6cff    call    $ff6c
d082 e1        pop     hl
d083 c9        ret     

;;---------------------------------------------------------------------------

d084 fe03      cp      $03
d086 c21bff    jp      nz,$ff1b
d089 1191d0    ld      de,$d091
d08c ed53a0b0  ld      ($b0a0),de
d090 c9        ret     

d091 00        nop     

;;---------------------------------------------------------------------------
;; code &0e-&1f

d092 d60e      sub     $0e
d094 5f        ld      e,a
d095 1600      ld      d,$00
d097 fe0a      cp      $0a
d099 381b      jr      c,$d0b6          

d09b 23        inc     hl
d09c 5e        ld      e,(hl)
d09d fe0b      cp      $0b				
d09f 2815      jr      z,$d0b6          

d0a1 23        inc     hl
d0a2 56        ld      d,(hl)
d0a3 fe0f      cp      $0f
d0a5 380f      jr      c,$d0b6          ; (+$0f)
d0a7 fe11      cp      $11
d0a9 3812      jr      c,$d0bd          ; (+$12)
d0ab 202a      jr      nz,$d0d7         ;; Error: Syntax Error
d0ad 2b        dec     hl
d0ae 3e05      ld      a,$05
d0b0 cd6cff    call    $ff6c
d0b3 2b        dec     hl
d0b4 1818      jr      $d0ce            ; (+$18)
;;---------------------------------------------------------------------------
;; number constant 0-10
d0b6 eb        ex      de,hl
d0b7 cd35ff    call    $ff35
d0ba eb        ex      de,hl
d0bb 1811      jr      $d0ce            ; (+$11)
;;---------------------------------------------------------------------------
d0bd e5        push    hl
d0be fe0f      cp      $0f
d0c0 2007      jr      nz,$d0c9         ; (+$07)
d0c2 13        inc     de
d0c3 eb        ex      de,hl
d0c4 23        inc     hl
d0c5 23        inc     hl
d0c6 5e        ld      e,(hl)
d0c7 23        inc     hl
d0c8 56        ld      d,(hl)
d0c9 eb        ex      de,hl
d0ca cd89fe    call    $fe89
d0cd e1        pop     hl
d0ce c32cde    jp      $de2c			; get next token skipping space
;;=======================================================================
;; (
d0d1 cd62cf    call    $cf62
d0d4 c31dde    jp      $de1d ; check for close bracket

;;---------------------------------------------------------------------------
d0d7 c349cb    jp      $cb49			; Error: Syntax Error

;;---------------------------------------------------------------------------
;; keywords with &ff prefix

d0da 23        inc     hl
d0db 4e        ld      c,(hl)			;; get keyword code
d0dc cd2cde    call    $de2c			; get next token skipping space

;; A = keyword id
d0df 79        ld      a,c
d0e0 fe40      cp      $40
d0e2 3805      jr      c,$d0e9          ; (+$05)
d0e4 fe4a      cp      $4a
d0e6 da10d1    jp      c,$d110

;;-------------------------------------------------------------------------

d0e9 cd19de    call    $de19 ; check for open bracket
d0ec 79        ld      a,c
d0ed 87        add     a,a
d0ee c61e      add     a,$1e
d0f0 4f        ld      c,a

;; &00-&1d -> &1e->&58
;; &71-&7f -> &00->&1c
;; &40-&49 -> &9e->&b0

d0f1 fe59      cp      $59
d0f3 30e2      jr      nc,$d0d7         ; Error: Syntax Error
d0f5 fe1d      cp      $1d
d0f7 3809      jr      c,$d102          ; (+$09)

;; &ff prefix, then &00-&1d
d0f9 cdd1d0    call    $d0d1
d0fc e5        push    hl
d0fd cd02d1    call    $d102
d100 e1        pop     hl
d101 c9        ret     

;;---------------------------------------------------------------------------
;; &ff prefix, then &71-&7f

d102 11e5d1    ld      de,$d1e5			; functions
d105 e5        push    hl
d106 eb        ex      de,hl
d107 0600      ld      b,$00
d109 09        add     hl,bc
d10a 7e        ld      a,(hl)
d10b 23        inc     hl
d10c 66        ld      h,(hl)
d10d 6f        ld      l,a
d10e e3        ex      (sp),hl
d10f c9        ret     

;;==========================================================================
;; keywords: &ff, &40-&49
;; 
;; A = keyword index (&40-&49)

d110 87        add     a,a				;; &40->&80, &41->&82...
d111 4f        ld      c,a

;; A = keyword index
;; C = offset in table
d112 1197d0    ld      de,$d097			; d117-&80
d115 18ee      jr      $d105            
;;------------------------------------------------------------

;; internal variables
d117:
defw &c44f		;; EOF
defw &d130		;; ERR
defw &d148		;; HIMEM
defw &fa7e		;; INKEY$
defw &d51d		;; PI
defw &d5c1		;; RND
defw &d139		;; TIME
defw &d161		;; XPOS
defw &d168		;; YPOS
defw &d12b		;; DERR

;;==========================================================================
;; DERR
d12b 3a91ad    ld      a,($ad91)
d12e 1803      jr      $d133            
;;==========================================================================
;; ERR
d130 3a90ad    ld      a,($ad90)
d133 e5        push    hl
d134 cd32ff    call    $ff32
d137 e1        pop     hl
d138 c9        ret     
;;==========================================================================
;; TIME
d139 e5        push    hl
d13a cd0dbd    call    $bd0d		;; firmware function: KL TIME PLEASE
d13d cda5fe    call    $fea5
d140 e1        pop     hl
d141 c9        ret     
;;=======================================================================
;; ERL
d142 e5        push    hl
d143 cdaacb    call    $cbaa
d146 1814      jr      $d15c            ; (+$14)
;;==========================================================================
;; HIMEM
d148 e5        push    hl
d149 2a5eae    ld      hl,($ae5e) ; HIMEM
d14c 180e      jr      $d15c            ; (+$0e)

;;==========================================================================
;; @ operator
d14e cdc9d6    call    $d6c9
d151 d24dcb    jp      nc,$cb4d			; Error: Improper Argument

d154 e5        push    hl
d155 eb        ex      de,hl
d156 78        ld      a,b
d157 fe03      cp      $03
d159 cc58fb    call    z,$fb58
d15c cd89fe    call    $fe89
d15f e1        pop     hl
d160 c9        ret     
;;==========================================================================
;; XPOS
d161 e5        push    hl
d162 cdc6bb    call    $bbc6			;; firmware function: gra ask cursor 
d165 eb        ex      de,hl
d166 1804      jr      $d16c           
;;==========================================================================
;; YPOS
d168 e5        push    hl
d169 cdc6bb    call    $bbc6			;; firmware function: gra ask cursor
d16c cd35ff    call    $ff35
d16f e1        pop     hl
d170 c9        ret     
;;========================================================================
;; DEF

d171 cd25de    call    $de25
defb &e4
d175 eb        ex      de,hl
d176 cdb5de    call    $deb5
d179 eb        ex      de,hl
d17a 3e0c      ld      a,$0c
d17c d255cb    jp      nc,$cb55
d17f cddbd6    call    $d6db
d182 eb        ex      de,hl
d183 73        ld      (hl),e
d184 23        inc     hl
d185 72        ld      (hl),d
d186 eb        ex      de,hl
d187 c3a3e9    jp      $e9a3			;; DATA
;;=======================================================================
;; FN
d18a cddbd6    call    $d6db
d18d c5        push    bc
d18e e5        push    hl
d18f eb        ex      de,hl
d190 5e        ld      e,(hl)
d191 23        inc     hl
d192 56        ld      d,(hl)
d193 eb        ex      de,hl
d194 7c        ld      a,h
d195 b5        or      l
d196 3e12      ld      a,$12
d198 ca55cb    jp      z,$cb55
d19b cd2ada    call    $da2a
d19e 7e        ld      a,(hl)
d19f fe28      cp      $28
d1a1 2028      jr      nz,$d1cb         ; (+$28)
d1a3 cd2cde    call    $de2c			; get next token skipping space
d1a6 e3        ex      (sp),hl
d1a7 cd19de    call    $de19 ; check for open bracket
d1aa e3        ex      (sp),hl
d1ab cd6ada    call    $da6a
d1ae e3        ex      (sp),hl
d1af d5        push    de
d1b0 cd62cf    call    $cf62
d1b3 e3        ex      (sp),hl
d1b4 78        ld      a,b
d1b5 cd9fd6    call    $d69f
d1b8 e1        pop     hl
d1b9 cd41de    call    $de41
d1bc 3006      jr      nc,$d1c4         ; (+$06)
d1be e3        ex      (sp),hl
d1bf cd15de    call    $de15 ; check for comma
d1c2 18e7      jr      $d1ab            ; (-$19)

d1c4 cd1dde    call    $de1d ; check for close bracket
d1c7 e3        ex      (sp),hl
d1c8 cd1dde    call    $de1d ; check for close bracket
d1cb cd49da    call    $da49
d1ce cd21de    call    $de21
d1d1 cd62cf    call    $cf62
d1d4 c249cb    jp      nz,$cb49			; Error: Syntax Error
d1d7 cd66ff    call    $ff66
d1da cc8afb    call    z,$fb8a
d1dd cd52da    call    $da52
d1e0 e1        pop     hl
d1e1 f1        pop     af
d1e2 c3fffe    jp      $feff

;; function table
d1e5
defw &f964					;; BIN$
defw &f98f					;; DEC$
defw &f969					;; HEX$
defw &fae5					;; INSTR$
defw &f9d3					;; LEFT$
defw &d243					;; MAX
defw &d23f					;; MIN
defw &c2aa					;; POS	
defw &f9d8					;; RIGHT$
defw &d26a					;; ROUND	
defw &fa8d					;; STRING$	
defw &c571					;; TEST		
defw &c576					;; TESTR
defw &c298					;; COPYCHR$		
defw &c2a1					;; VPOS

defw &fdb0                                                                     ;; ABS    
defw &fa6e                                                                     ;; ASC
defw &d57e                                                                    ;; ATN
defw &fa74                                                                     ;; CHR$
defw &feb6                                                                     ;; CINT
defw &d574                                                                    ;; COS
defw &ff14                                                                     ;; CREAL
defw &d560                                                                    ;; EXP
defw &fe0e                                                                     ;; FIX
defw &fc53                                                                     ;; FRE
defw &d456                                                                    ;; INKEY
defw &f219                                                                     ;; INP
defw &fe13                                                                     ;; INT
defw &d470                                                                    ;; JOY
defw &fa69                                                                     ;; LEN
defw &d56a                                                                    ;; LOG
defw &d565                                                                    ;; LOG10
defw &f8ec                                                                     ;; LOWER$
defw &f208                                                                     ;; PEEK
defw &ca50                                                                    ;; REMAIN
defw &ff2a                                                                     ;; SGN
defw &d56f                                                                     ;; SIN
defw &faad                                                                     ;; SPACE$
defw &d37b                                                                    ;; SQ
defw &d531                                                                    ;; SQR
defw &f9bc                                                                     ;; STR$
defw &d579                                                                    ;; TAN
defw &feeb                                                                     ;; UNT
defw &f8fa                                                                     ;; UPPER$
defw &fabe                                                                     ;; VAL

d233 31d5bc    ld      sp,$bcd5
d236 f9        ld      sp,hl
d237 79        ld      a,c
d238 d5        push    de
d239 eb        ex      de,hl
d23a fefa      cp      $fa
d23c f8        ret     m

d23d be        cp      (hl)
d23e fa

;;========================================================================
;; MIN
d23f 06ff	   ld      b,&ff
d241 1802      jr      $d245            ; (+$02)

;;========================================================================
;; MAX
d243 0601      ld      b,$01
;;------------------------------------------------------------------------
d245 cd62cf    call    $cf62
d248 cd41de    call    $de41
d24b d21dde    jp      nc,$de1d ; check for close bracket
d24e cd74ff    call    $ff74
d251 cd62cf    call    $cf62
d254 e5        push    hl
d255 79        ld      a,c
d256 cd62f6    call    $f662
d259 c5        push    bc
d25a e5        push    hl
d25b cd49fd    call    $fd49
d25e e1        pop     hl
d25f c1        pop     bc
d260 b7        or      a
d261 2804      jr      z,$d267          ; (+$04)
d263 b8        cp      b
d264 c46fff    call    nz,$ff6f
d267 e1        pop     hl
d268 18de      jr      $d248            ; (-$22)
;;========================================================================
;; ROUND
d26a cd62cf    call    $cf62
d26d cd74ff    call    $ff74
d270 cd41de    call    $de41
d273 110000    ld      de,$0000
d276 dcd8ce    call    c,$ced8 ; get number
d279 cd1dde    call    $de1d ; check for close bracket
d27c e5        push    hl
d27d d5        push    de
d27e 212700    ld      hl,$0027
d281 19        add     hl,de
d282 114f00    ld      de,$004f
d285 cdd8ff    call    $ffd8 ; HL=DE?
d288 d24dcb    jp      nc,$cb4d			; Error: Improper Argument
d28b d1        pop     de
d28c 79        ld      a,c
d28d cd62f6    call    $f662
d290 43        ld      b,e
d291 cdd5fd    call    $fdd5
d294 e1        pop     hl
d295 c9        ret     

;;=============================================================================
;; CAT
d296 c0        ret     nz
d297 e5        push    hl
d298 cd00d3    call    $d300
d29b cd2af7    call    $f72a
d29e cd9bbc    call    $bc9b			; firmware function: cas catalog
d2a1 ca37cc    jp      z,$cc37
d2a4 e1        pop     hl
d2a5 c361f7    jp      $f761

;;=============================================================================
;; OPENOUT

d2a8 cdc7d2    call    $d2c7
d2ab cd25f7    call    $f725
d2ae cd69c4    call    $c469
d2b1 c38cbc    jp      $bc8c			; firmware function: cas out open

;;=============================================================================
;; OPENIN

d2b4 cdbed2    call    $d2be
d2b7 fe16      cp      $16
d2b9 c8        ret     z

d2ba cd45cb    call    $cb45
d2bd 19        add     hl,de
d2be cdc7d2    call    $d2c7
d2c1 cd20f7    call    $f720
d2c4 c377bc    jp      $bc77			; firmware function: cas in open

d2c7 cd2af7    call    $f72a
d2ca cd03cf    call    $cf03
d2cd e3        ex      (sp),hl
d2ce eb        ex      de,hl
d2cf cddbd2    call    $d2db
d2d2 ca37cc    jp      z,$cc37
d2d5 e1        pop     hl
d2d6 d8        ret     c

d2d7 cd45cb    call    $cb45
d2da 1b        dec     de
d2db d5        push    de
d2dc 78        ld      a,b
d2dd b7        or      a
d2de 280a      jr      z,$d2ea          ; (+$0a)
d2e0 7e        ld      a,(hl)
d2e1 fe21      cp      $21				; "!" character?
d2e3 3e00      ld      a,$00
d2e5 2003      jr      nz,$d2ea         ; (+$03)
d2e7 23        inc     hl
d2e8 05        dec     b
d2e9 2f        cpl     
d2ea c36bbc    jp      $bc6b			; firmware function: cas set noisy

;;==========================================================================
;; CLOSEIN

d2ed e5        push    hl
d2ee cd7abc    call    $bc7a			; firmware function: cas in close
d2f1 e1        pop     hl
d2f2 c359f7    jp      $f759

;;==========================================================================
;; CLOSEOUT

d2f5 e5        push    hl
d2f6 cd8fbc    call    $bc8f			; firmware function: cas out close
d2f9 ca37cc    jp      z,$cc37
d2fc e1        pop     hl
d2fd c35df7    jp      $f75d

;;==========================================================================

d300 c5        push    bc
d301 d5        push    de
d302 e5        push    hl
d303 cd7dbc    call    $bc7d			; firmware function: cas in abandon
d306 cd59f7    call    $f759
d309 cd92bc    call    $bc92			; firmware function: cas out abandon
d30c cd5df7    call    $f75d
d30f e1        pop     hl
d310 d1        pop     de
d311 c1        pop     bc
d312 c9        ret     

;;========================================================================
;; SOUND
d313 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
d316 3299ad    ld      ($ad99),a
d319 cd15de    call    $de15 ; check for comma
d31c cd4cd4    call    $d44c
d31f ed539cad  ld      ($ad9c),de
d323 cd41de    call    $de41
d326 111400    ld      de,$0014
d329 dcd8ce    call    c,$ced8 ; get number
d32c ed53a0ad  ld      ($ada0),de
d330 010c10    ld      bc,$100c
d333 cd5fd3    call    $d35f
d336 329fad    ld      ($ad9f),a
d339 0e00      ld      c,$00
d33b cd5fd3    call    $d35f
d33e 329aad    ld      ($ad9a),a
d341 cd5fd3    call    $d35f
d344 329bad    ld      ($ad9b),a
d347 0620      ld      b,$20
d349 cd5fd3    call    $d35f
d34c 329ead    ld      ($ad9e),a
d34f cd37de    call    $de37
d352 e5        push    hl
d353 2199ad    ld      hl,$ad99
d356 cdaabc    call    $bcaa					; firmware function: sound queue
d359 e1        pop     hl
d35a d8        ret     c

d35b f1        pop     af
d35c c35dde    jp      $de5d
d35f cd41de    call    $de41
d362 79        ld      a,c
d363 d0        ret     nc

d364 7e        ld      a,(hl)
d365 fe2c      cp      $2c
d367 79        ld      a,c
d368 c8        ret     z

d369 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
d36c b8        cp      b
d36d d8        ret     c

d36e 182b      jr      $d39b            ; (+$2b)

;;========================================================================
;; RELEASE

d370 0608      ld      b,$08
d372 cd69d3    call    $d369
d375 e5        push    hl
d376 cdb3bc    call    $bcb3			; firmware function: sound release
d379 e1        pop     hl
d37a c9        ret     

;;========================================================
;; SQ

d37b cdb6fe    call    $feb6
d37e 7d        ld      a,l
d37f b7        or      a
d380 1f        rra     
d381 3806      jr      c,$d389          ; (+$06)
d383 1f        rra     
d384 3803      jr      c,$d389          ; (+$03)
d386 1f        rra     
d387 3012      jr      nc,$d39b         ; (+$12)
d389 b4        or      h
d38a 200f      jr      nz,$d39b         ; (+$0f)
d38c 7d        ld      a,l
d38d cdadbc    call    $bcad			; firmware function: sound check
d390 c332ff    jp      $ff32

d393 cdd8ce    call    $ced8 ; get number
d396 7b        ld      a,e
d397 87        add     a,a
d398 9f        sbc     a,a
d399 ba        cp      d
d39a c8        ret     z

d39b c34dcb    jp      $cb4d			; Error: Improper Argument

;;========================================================================
;; ENV

;; get envelope number (must be between 0 and 15)
d39e cdc3ce    call    $cec3
d3a1 fe10      cp      $10				; 16
d3a3 30f6      jr      nc,$d39b         

d3a5 f5        push    af
d3a6 11b7d3    ld      de,$d3b7			; read parameters
d3a9 cd25d4    call    $d425
d3ac f1        pop     af
d3ad e5        push    hl
d3ae 21a2ad    ld      hl,$ada2
d3b1 71        ld      (hl),c			; number of sections

d3b2 cdbcbc    call    $bcbc			; firmware function: sound ampl envelope
d3b5 e1        pop     hl
d3b6 c9        ret     

;;========================================================================

d3b7 7e        ld      a,(hl)
d3b8 feef      cp      $ef				; equals???
d3ba 2011      jr      nz,$d3cd         

d3bc cd2cde    call    $de2c			; get next token skipping space
d3bf 0610      ld      b,$10
d3c1 cd69d3    call    $d369			; get number and check less than 255
d3c4 f680      or      $80
d3c6 4f        ld      c,a
d3c7 cd15de    call    $de15 ; check for comma
d3ca c3f5ce    jp      $cef5

;; ------------------------------?
d3cd 0680      ld      b,$80
d3cf cd69d3    call    $d369			; get number and check less than 255
d3d2 1840      jr      $d414            ; (+$40)

;;========================================================================
;; ENT

d3d4 cd93d3    call    $d393			; get number
d3d7 7a        ld      a,d
d3d8 b7        or      a
d3d9 7b        ld      a,e
d3da 2802      jr      z,$d3de          ; (+$02)

;; negate?
d3dc 2f        cpl     
d3dd 3c        inc     a

d3de 5f        ld      e,a
d3df b7        or      a
d3e0 28b9      jr      z,$d39b          ; (-$47)

d3e2 fe10      cp      $10				; 16
d3e4 30b5      jr      nc,$d39b         

d3e6 d5        push    de
d3e7 11fdd3    ld      de,$d3fd
d3ea cd25d4    call    $d425
d3ed d1        pop     de
d3ee e5        push    hl
d3ef 21a2ad    ld      hl,$ada2
d3f2 7a        ld      a,d
d3f3 e680      and     $80
d3f5 b1        or      c
d3f6 77        ld      (hl),a
d3f7 7b        ld      a,e
d3f8 cdbfbc    call    $bcbf						; firmware function: sound tone envelope
d3fb e1        pop     hl
d3fc c9        ret     

d3fd 7e        ld      a,(hl)
d3fe feef      cp      $ef
d400 200d      jr      nz,$d40f         ; (+$0d)

d402 cd2cde    call    $de2c			; get next token skipping space
d405 cd4cd4    call    $d44c
d408 7a        ld      a,d
d409 c6f0      add     a,$f0
d40b 4f        ld      c,a
d40c 43        ld      b,e
d40d 180d      jr      $d41c            ; (+$0d)

d40f 06f0      ld      b,$f0
d411 cd69d3    call    $d369
d414 4f        ld      c,a
d415 cd15de    call    $de15 ; check for comma
d418 cd93d3    call    $d393
d41b 43        ld      b,e
d41c cd15de    call    $de15 ; check for comma
d41f cdb8ce    call    $ceb8 ; get number and check it's less than 255 
d422 57        ld      d,a
d423 58        ld      e,b
d424 c9        ret     

d425 010005    ld      bc,$0500
d428 cd41de    call    $de41
d42b 301c      jr      nc,$d449         ; (+$1c)
d42d d5        push    de
d42e c5        push    bc
d42f cdfeff    call    $fffe			; JP (DE)
d432 79        ld      a,c
d433 c1        pop     bc
d434 c5        push    bc
d435 e5        push    hl
d436 21a3ad    ld      hl,$ada3
d439 0600      ld      b,$00
d43b 09        add     hl,bc
d43c 09        add     hl,bc
d43d 09        add     hl,bc
d43e 77        ld      (hl),a
d43f 23        inc     hl
d440 73        ld      (hl),e
d441 23        inc     hl
d442 72        ld      (hl),d
d443 e1        pop     hl
d444 c1        pop     bc
d445 0c        inc     c
d446 d1        pop     de
d447 10df      djnz    $d428            ; (-$21)
d449 c337de    jp      $de37
d44c cdd8ce    call    $ced8 ; get number
d44f 7a        ld      a,d
d450 e6f0      and     $f0
d452 c29bd3    jp      nz,$d39b
d455 c9        ret     

;;========================================================
;; INKEY
d456 cdb6fe    call    $feb6
d459 115000    ld      de,$0050
d45c cdd8ff    call    $ffd8 ; HL=DE?
d45f 3022      jr      nc,$d483         ; (+$22)
d461 7d        ld      a,l
d462 cd1ebb    call    $bb1e			; firmware function: km read key
d465 21ffff    ld      hl,$ffff
d468 2803      jr      z,$d46d          ; (+$03)
d46a 69        ld      l,c
d46b 2600      ld      h,$00
d46d c335ff    jp      $ff35

;;========================================================
;; JOY
d470 cd24bb    call    $bb24			; firmware function: km get joystick
d473 eb        ex      de,hl
d474 cdb6fe    call    $feb6
d477 7c        ld      a,h
d478 b5        or      l
d479 2802      jr      z,$d47d          ; (+$02)
d47b 53        ld      d,e
d47c 2b        dec     hl
d47d 7c        ld      a,h
d47e b5        or      l
d47f 7a        ld      a,d
d480 ca32ff    jp      z,$ff32
d483 c34dcb    jp      $cb4d			; Error: Improper Argument

;;========================================================================
;; KEY

d486 fe8d      cp      $8d				; DEF keyword
d488 2816      jr      z,$d4a0          ; 

d48a cdb8ce    call    $ceb8 ; get number and check it's less than 255 
d48d f5        push    af
d48e cd15de    call    $de15 ; check for comma
d491 cd03cf    call    $cf03
d494 48        ld      c,b
d495 f1        pop     af
d496 47        ld      b,a
d497 e5        push    hl
d498 eb        ex      de,hl
d499 cd0fbb    call    $bb0f			; firmware function: KM SET EXPAND
d49c e1        pop     hl
d49d 30e4      jr      nc,$d483         ; (-$1c)
d49f c9        ret     

;;========================================================================
;; KEY DEF
d4a0 cd2cde    call    $de2c			; get next token skipping space
d4a3 0650      ld      b,$50
d4a5 cd69d3    call    $d369
d4a8 4f        ld      c,a
d4a9 cd15de    call    $de15 ; check for comma
d4ac 0602      ld      b,$02
d4ae cd69d3    call    $d369
d4b1 1f        rra     
d4b2 9f        sbc     a,a
d4b3 47        ld      b,a
d4b4 c5        push    bc
d4b5 e5        push    hl
d4b6 79        ld      a,c
d4b7 cd39bb    call    $bb39			; firmware function: KM SET REPEAT
d4ba e1        pop     hl
d4bb c1        pop     bc
d4bc 1127bb    ld      de,$bb27			; KM SET TRANSLATE
d4bf cdcbd4    call    $d4cb
d4c2 112dbb    ld      de,$bb2d			; KM SET SHIFT
d4c5 cdcbd4    call    $d4cb
d4c8 1133bb    ld      de,$bb33			; KM SET CONTROL
d4cb cd41de    call    $de41
d4ce d0        ret     nc

d4cf d5        push    de
d4d0 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
d4d3 47        ld      b,a
d4d4 e3        ex      (sp),hl
d4d5 79        ld      a,c
d4d6 cdfbff    call    $fffb			; JP (HL)
d4d9 e1        pop     hl
d4da c9        ret     

;;========================================================================
;; SPEED WRITE, SPEED KEY, SPEED INK

d4db fed9      cp      $d9				; token for "WRITE"
d4dd 2826      jr      z,$d505          

d4df fea4      cp      $a4				; token for "KEY"
d4e1 013fbb    ld      bc,$bb3f			; firmware function: KM SET DELAY
d4e4 2808      jr      z,$d4ee          ; 
d4e6 fea2      cp      $a2				; token for "INK"
d4e8 013ebc    ld      bc,$bc3e			; firmware function: SCR SET FLASHING
d4eb c249cb    jp      nz,$cb49			; Error: Syntax Error

d4ee c5        push    bc
d4ef cd2cde    call    $de2c			; get next token skipping space
d4f2 cdc3ce    call    $cec3
d4f5 4f        ld      c,a
d4f6 cd15de    call    $de15 ; check for comma
d4f9 cdc3ce    call    $cec3
d4fc 5f        ld      e,a
d4fd 51        ld      d,c
d4fe c1        pop     bc
d4ff eb        ex      de,hl
d500 cdfcff    call    $fffc			; JP (BC)
d503 eb        ex      de,hl
d504 c9        ret     

;;========================================================================
;; SPEED WRITE 0, SPEED WRITE 1

d505 cd2cde    call    $de2c			; get next token skipping space
d508 0602      ld      b,$02
d50a cd69d3    call    $d369
d50d e5        push    hl
d50e 21a700    ld      hl,$00a7
d511 3d        dec     a
d512 3e32      ld      a,$32
d514 2802      jr      z,$d518          ; (+$02)
d516 29        add     hl,hl
d517 0f        rrca    
d518 cd68bc    call    $bc68			; firmware function: cas set speed
d51b e1        pop     hl
d51c c9        ret     

;;========================================================================
;; PI

d51d e5        push    hl
d51e cd41ff    call    $ff41
d521 cd45ff    call    $ff45
d524 cd9abd    call    $bd9a
d527 e1        pop     hl
d528 c9        ret     

;;========================================================================
;; DEG
d529 3eff      ld      a,$ff
d52b 1801      jr      $d52e            ; (+$01)
;;========================================================================
;; RAD

d52d af        xor     a
d52e c397bd    jp      $bd97			; maths: set angle mode

;;========================================================
;; STR

d531 019dbd    ld      bc,$bd9d
d534 1816      jr      $d54c            ; (+$16)

d536 e5        push    hl
d537 c5        push    bc
d538 cd14ff    call    $ff14
d53b eb        ex      de,hl
d53c 21b2ad    ld      hl,$adb2
d53f cd61bd    call    $bd61
d542 c1        pop     bc
d543 e3        ex      (sp),hl
d544 79        ld      a,c
d545 cd6cff    call    $ff6c
d548 d1        pop     de
d549 01a0bd    ld      bc,$bda0
d54c cd59d5    call    $d559
d54f d8        ret     c

d550 cab5cb    jp      z,$cbb5
d553 fabecb    jp      m,$cbbe
d556 c34dcb    jp      $cb4d			; Error: Improper Argument

d559 c5        push    bc
d55a d5        push    de
d55b cd14ff    call    $ff14
d55e d1        pop     de
d55f c9        ret     

;;========================================================
;; EXP
d560 01a9bd    ld      bc,$bda9
d563 18e7      jr      $d54c            ; (-$19)

;;========================================================
;; LOG10

d565 01a6bd    ld      bc,$bda6
d568 18e2      jr      $d54c            ; (-$1e)

;;========================================================
;; LOG
d56a 01a3bd    ld      bc,$bda3
d56d 18dd      jr      $d54c            ; (-$23)

;;========================================================
;; SIN

d56f 01acbd    ld      bc,$bdac
d572 18d8      jr      $d54c            ; (-$28)

;;========================================================
;; COS
d574 01afbd    ld      bc,$bdaf
d577 18d3      jr      $d54c            ; (-$2d)

;;========================================================
;; TAN

d579 01b2bd    ld      bc,$bdb2
d57c 18ce      jr      $d54c            ; (-$32)

;;========================================================
;; ATN
d57e 01b5bd    ld      bc,$bdb5
d581 18c9      jr      $d54c            ; (-$37)

;;========================================================================
d583:
defb "Random number seed? ",0
;;========================================================================
;; RANDOMIZE
d599 2806      jr      z,$d5a1          ; (+$06)
d59b cd62cf    call    $cf62
d59e e5        push    hl
d59f 1818      jr      $d5b9            ; (+$18)
d5a1 e5        push    hl
d5a2 2183d5    ld      hl,$d583			;; "Random number seed?" message
d5a5 cd8bc3    call    $c38b			;; display 0 terminated string
d5a8 cdecca    call    $caec
d5ab cd98c3    call    $c398			;; new text line
d5ae cd6fed    call    $ed6f
d5b1 30ef      jr      nc,$d5a2         ; (-$11)
d5b3 cd4dde    call    $de4d			; skip space, lf or tab
d5b6 b7        or      a
d5b7 20e9      jr      nz,$d5a2         ; (-$17)
d5b9 cd14ff    call    $ff14
d5bc cdbebd    call    $bdbe
d5bf e1        pop     hl
d5c0 c9        ret     

;;========================================================================
;; RND

d5c1 7e        ld      a,(hl)
d5c2 fe28      cp      $28				; '('
d5c4 201b      jr      nz,$d5e1         

d5c6 cd2cde    call    $de2c			; get next token skipping space
d5c9 cd62cf    call    $cf62
d5cc cd1dde    call    $de1d ; check for close bracket
d5cf e5        push    hl
d5d0 cd14ff    call    $ff14
d5d3 cd94bd    call    $bd94
d5d6 2005      jr      nz,$d5dd         ; (+$05)
d5d8 cd8bbd    call    $bd8b
d5db e1        pop     hl
d5dc c9        ret     

d5dd fcbebd    call    m,$bdbe
d5e0 e1        pop     hl
d5e1 e5        push    hl
d5e2 cd3eff    call    $ff3e
d5e5 cd7fbd    call    $bd7f
d5e8 e1        pop     hl
d5e9 c9        ret     

d5ea cdfad5    call    $d5fa
d5ed 2a66ae    ld      hl,($ae66)
d5f0 2268ae    ld      ($ae68),hl
d5f3 226aae    ld      ($ae6a),hl
d5f6 226cae    ld      ($ae6c),hl
d5f9 c9        ret     

d5fa 21b7ad    ld      hl,$adb7
d5fd 3e36      ld      a,$36
d5ff cd07d6    call    $d607
d602 21edad    ld      hl,$aded
d605 3e06      ld      a,$06
d607 3600      ld      (hl),$00
d609 23        inc     hl
d60a 3d        dec     a
d60b 20fa      jr      nz,$d607         ; (-$06)
d60d c9        ret     

d60e 210000    ld      hl,$0000
d611 22ebad    ld      ($adeb),hl
d614 c34dea    jp      $ea4d
d617 3e5b      ld      a,$5b
d619 ed4b68ae  ld      bc,($ae68)
d61d 0b        dec     bc
d61e 87        add     a,a
d61f c635      add     a,$35
d621 6f        ld      l,a
d622 cead      adc     a,$ad
d624 95        sub     l
d625 67        ld      h,a
d626 c9        ret     

d627 ed4b6aae  ld      bc,($ae6a)
d62b 0b        dec     bc
d62c e603      and     $03
d62e 3d        dec     a
d62f 87        add     a,a
d630 c6ed      add     a,$ed
d632 6f        ld      l,a
d633 cead      adc     a,$ad
d635 95        sub     l
d636 67        ld      h,a
d637 c9        ret     

d638 015a41    ld      bc,$415a
d63b 1e05      ld      e,$05
d63d 79        ld      a,c
d63e 90        sub     b
d63f 383d      jr      c,$d67e          ; (+$3d)
d641 e5        push    hl
d642 3c        inc     a
d643 21b2ad    ld      hl,$adb2
d646 0600      ld      b,$00
d648 09        add     hl,bc
d649 73        ld      (hl),e
d64a 2b        dec     hl
d64b 3d        dec     a
d64c 20fb      jr      nz,$d649         ; (-$05)
d64e e1        pop     hl
d64f c9        ret     

;;=============================================================================
;; DEFSTR

d650 1e03      ld      e,$03
d652 1806      jr      $d65a            ; (+$06)

;;=============================================================================
;; DEFINT

d654 1e02      ld      e,$02
d656 1802      jr      $d65a            ; (+$02)

;;=============================================================================
;; DEFREAL
d658 1e05      ld      e,$05
;;-----------------------------------------------------------------------------

d65a 7e        ld      a,(hl)
d65b cd92ff    call    $ff92			; is a alphabetical letter?
d65e 301e      jr      nc,$d67e         ; (+$1e)
d660 4f        ld      c,a
d661 47        ld      b,a
d662 cd2cde    call    $de2c			; get next token skipping space
d665 fe2d      cp      $2d				; '-'
d667 200c      jr      nz,$d675         ; (+$0c)
d669 cd2cde    call    $de2c			; get next token skipping space
d66c cd92ff    call    $ff92			; is a alphabetical letter?
d66f 300d      jr      nc,$d67e         ; (+$0d)
d671 4f        ld      c,a
d672 cd2cde    call    $de2c			; get next token skipping space
d675 cd3dd6    call    $d63d
d678 cd41de    call    $de41
d67b 38dd      jr      c,$d65a          ; (-$23)
d67d c9        ret     

d67e c349cb    jp      $cb49			; Error: Syntax Error
d681 cd45cb    call    $cb45
d684 09        add     hl,bc
d685 cd45cb    call    $cb45
d688 0a        ld      a,(bc)
d689 fef8      cp      $f8				; '|'
d68b ca45f2    jp      z,$f245

;;========================================================================
;; LET

d68e cdbfd6    call    $d6bf
d691 d5        push    de
d692 cd21de    call    $de21
d695 cd62cf    call    $cf62
d698 78        ld      a,b
d699 e3        ex      (sp),hl
d69a cd9fd6    call    $d69f
d69d e1        pop     hl
d69e c9        ret     

d69f 47        ld      b,a
d6a0 cd4bff    call    $ff4b
d6a3 b8        cp      b
d6a4 78        ld      a,b
d6a5 c4fffe    call    nz,$feff
d6a8 cd66ff    call    $ff66
d6ab c283ff    jp      nz,$ff83
d6ae e5        push    hl
d6af cd94fb    call    $fb94
d6b2 d1        pop     de
d6b3 c387ff    jp      $ff87

;;========================================================================
;; DIM

d6b6 cde0d7    call    $d7e0
d6b9 cd41de    call    $de41
d6bc 38f8      jr      c,$d6b6          ; (-$08)
d6be c9        ret     

d6bf cd31d9    call    $d931
d6c2 cd06d8    call    $d806
d6c5 3842      jr      c,$d709          ; (+$42)
d6c7 1828      jr      $d6f1            ; (+$28)
d6c9 cd31d9    call    $d931
d6cc cd06d8    call    $d806
d6cf 3838      jr      c,$d709          ; (+$38)
d6d1 e5        push    hl
d6d2 79        ld      a,c
d6d3 cd19d6    call    $d619
d6d6 cd17d7    call    $d717
d6d9 182d      jr      $d708            ; (+$2d)
d6db cd31d9    call    $d931
d6de 3821      jr      c,$d701          ; (+$21)
d6e0 e5        push    hl
d6e1 cd17d6    call    $d617
d6e4 cd32d7    call    $d732
d6e7 d46fd7    call    nc,$d76f
d6ea 181c      jr      $d708            ; (+$1c)
d6ec cd31d9    call    $d931
d6ef 3810      jr      c,$d701          ; (+$10)
d6f1 e5        push    hl
d6f2 79        ld      a,c
d6f3 cd19d6    call    $d619
d6f6 cd17d7    call    $d717
d6f9 3a9fb0    ld      a,($b09f)
d6fc d47bd7    call    nc,$d77b
d6ff 1807      jr      $d708            ; (+$07)
d701 e5        push    hl
d702 2a68ae    ld      hl,($ae68)
d705 2b        dec     hl
d706 19        add     hl,de
d707 eb        ex      de,hl
d708 e1        pop     hl
d709 3a9fb0    ld      a,($b09f)
d70c 47        ld      b,a
d70d 4f        ld      c,a
d70e c9        ret     

d70f cd31d9    call    $d931
d712 cd7ae9    call    $e97a
d715 18f2      jr      $d709            ; (-$0e)
d717 d5        push    de
d718 e5        push    hl
d719 2a12ae    ld      hl,($ae12)
d71c 7c        ld      a,h
d71d b5        or      l
d71e 2810      jr      z,$d730          ; (+$10)
d720 23        inc     hl
d721 23        inc     hl
d722 c5        push    bc
d723 010000    ld      bc,$0000
d726 cd40d7    call    $d740
d729 c1        pop     bc
d72a 3004      jr      nc,$d730         ; (+$04)
d72c f1        pop     af
d72d f1        pop     af
d72e 37        scf     
d72f c9        ret     

d730 e1        pop     hl
d731 d1        pop     de
d732 d5        push    de
d733 e5        push    hl
d734 cd40d7    call    $d740
d737 e1        pop     hl
d738 3802      jr      c,$d73c          ; (+$02)
d73a d1        pop     de
d73b c9        ret     

d73c e1        pop     hl
d73d c39ed7    jp      $d79e
d740 7e        ld      a,(hl)
d741 23        inc     hl
d742 66        ld      h,(hl)
d743 6f        ld      l,a
d744 b4        or      h
d745 c8        ret     z

d746 09        add     hl,bc
d747 e5        push    hl
d748 23        inc     hl
d749 23        inc     hl
d74a ed5b0eae  ld      de,($ae0e)
d74e 1a        ld      a,(de)
d74f be        cp      (hl)
d750 200d      jr      nz,$d75f         ; (+$0d)
d752 23        inc     hl
d753 13        inc     de
d754 17        rla     
d755 30f7      jr      nc,$d74e         ; (-$09)
d757 3a9fb0    ld      a,($b09f)
d75a 3d        dec     a
d75b ae        xor     (hl)
d75c e607      and     $07
d75e eb        ex      de,hl
d75f e1        pop     hl
d760 20de      jr      nz,$d740         ; (-$22)
d762 13        inc     de
d763 37        scf     
d764 c9        ret     

d765 54        ld      d,h
d766 5d        ld      e,l
d767 23        inc     hl
d768 23        inc     hl
d769 cb7e      bit     7,(hl)
d76b 23        inc     hl
d76c 28fb      jr      z,$d769          ; (-$05)
d76e c9        ret     

d76f 3e02      ld      a,$02
d771 cd7bd7    call    $d77b
d774 1b        dec     de
d775 1a        ld      a,(de)
d776 f640      or      $40
d778 12        ld      (de),a
d779 13        inc     de
d77a c9        ret     

d77b d5        push    de
d77c e5        push    hl
d77d c5        push    bc
d77e f5        push    af
d77f cda8d7    call    $d7a8
d782 f5        push    af
d783 2a6aae    ld      hl,($ae6a)
d786 eb        ex      de,hl
d787 cdb8f6    call    $f6b8
d78a cd1af6    call    $f61a
d78d f1        pop     af
d78e cdb8d7    call    $d7b8
d791 c1        pop     bc
d792 af        xor     a
d793 2b        dec     hl
d794 77        ld      (hl),a
d795 10fc      djnz    $d793            ; (-$04)
d797 c1        pop     bc
d798 e3        ex      (sp),hl
d799 cdd0d7    call    $d7d0
d79c d1        pop     de
d79d e1        pop     hl
d79e 23        inc     hl
d79f 7b        ld      a,e
d7a0 91        sub     c
d7a1 77        ld      (hl),a
d7a2 23        inc     hl
d7a3 7a        ld      a,d
d7a4 98        sbc     a,b
d7a5 77        ld      (hl),a
d7a6 37        scf     
d7a7 c9        ret     

d7a8 c603      add     a,$03
d7aa 4f        ld      c,a
d7ab 2a0eae    ld      hl,($ae0e)
d7ae af        xor     a
d7af 47        ld      b,a
d7b0 03        inc     bc
d7b1 3c        inc     a
d7b2 cb7e      bit     7,(hl)
d7b4 23        inc     hl
d7b5 28f9      jr      z,$d7b0          ; (-$07)
d7b7 c9        ret     

d7b8 62        ld      h,d
d7b9 6b        ld      l,e
d7ba 09        add     hl,bc
d7bb e5        push    hl
d7bc d5        push    de
d7bd 13        inc     de
d7be 13        inc     de
d7bf 2a0eae    ld      hl,($ae0e)
d7c2 cdecff    call    $ffec			;; copy bytes (A=count, HL=source, DE=dest)
d7c5 3a9fb0    ld      a,($b09f)
d7c8 3d        dec     a
d7c9 12        ld      (de),a
d7ca 13        inc     de
d7cb 42        ld      b,d
d7cc 4b        ld      c,e
d7cd d1        pop     de
d7ce e1        pop     hl
d7cf c9        ret     

d7d0 7e        ld      a,(hl)
d7d1 12        ld      (de),a
d7d2 7b        ld      a,e
d7d3 91        sub     c
d7d4 77        ld      (hl),a
d7d5 23        inc     hl
d7d6 7e        ld      a,(hl)
d7d7 f5        push    af
d7d8 7a        ld      a,d
d7d9 98        sbc     a,b
d7da 77        ld      (hl),a
d7db f1        pop     af
d7dc 13        inc     de
d7dd 12        ld      (de),a
d7de 13        inc     de
d7df c9        ret     

d7e0 cd31d9    call    $d931
d7e3 7e        ld      a,(hl)
d7e4 fe28      cp      $28
d7e6 2805      jr      z,$d7ed          ; (+$05)
d7e8 ee5b      xor     $5b
d7ea c249cb    jp      nz,$cb49			; Error: Syntax Error
d7ed cd83d8    call    $d883
d7f0 e5        push    hl
d7f1 c5        push    bc
d7f2 3a9fb0    ld      a,($b09f)
d7f5 cd27d6    call    $d627
d7f8 cd40d7    call    $d740
d7fb da85d6    jp      c,$d685
d7fe c1        pop     bc
d7ff 3eff      ld      a,$ff
d801 cdb3d8    call    $d8b3
d804 e1        pop     hl
d805 c9        ret     

d806 f5        push    af
d807 7e        ld      a,(hl)
d808 fe28      cp      $28
d80a 2810      jr      z,$d81c          ; (+$10)
d80c ee5b      xor     $5b
d80e 280c      jr      z,$d81c          ; (+$0c)
d810 f1        pop     af
d811 d0        ret     nc

d812 e5        push    hl
d813 2a68ae    ld      hl,($ae68)
d816 2b        dec     hl
d817 19        add     hl,de
d818 eb        ex      de,hl
d819 e1        pop     hl
d81a 37        scf     
d81b c9        ret     

d81c cd83d8    call    $d883
d81f f1        pop     af
d820 e5        push    hl
d821 3007      jr      nc,$d82a         ; (+$07)
d823 2a6aae    ld      hl,($ae6a)
d826 2b        dec     hl
d827 19        add     hl,de
d828 1815      jr      $d83f            ; (+$15)
d82a c5        push    bc
d82b d5        push    de
d82c 3a9fb0    ld      a,($b09f)
d82f cd27d6    call    $d627
d832 cd40d7    call    $d740
d835 300f      jr      nc,$d846         ; (+$0f)
d837 13        inc     de
d838 13        inc     de
d839 e1        pop     hl
d83a cd9ed7    call    $d79e
d83d c1        pop     bc
d83e eb        ex      de,hl
d83f 78        ld      a,b
d840 96        sub     (hl)
d841 c281d6    jp      nz,$d681
d844 180a      jr      $d850            ; (+$0a)
d846 e1        pop     hl
d847 c1        pop     bc
d848 af        xor     a
d849 cdb3d8    call    $d8b3
d84c cd9ed7    call    $d79e
d84f eb        ex      de,hl
d850 110000    ld      de,$0000
d853 46        ld      b,(hl)
d854 23        inc     hl
d855 e5        push    hl
d856 d5        push    de
d857 5e        ld      e,(hl)
d858 23        inc     hl
d859 56        ld      d,(hl)
d85a cd27d9    call    $d927
d85d cdd8ff    call    $ffd8 ; HL=DE?
d860 d281d6    jp      nc,$d681
d863 e3        ex      (sp),hl
d864 cd72dd    call    $dd72
d867 d1        pop     de
d868 19        add     hl,de
d869 eb        ex      de,hl
d86a e1        pop     hl
d86b 23        inc     hl
d86c 23        inc     hl
d86d 10e6      djnz    $d855            ; (-$1a)
d86f eb        ex      de,hl
d870 44        ld      b,h
d871 4d        ld      c,l
d872 3a9fb0    ld      a,($b09f)
d875 d603      sub     $03
d877 3804      jr      c,$d87d          ; (+$04)
d879 29        add     hl,hl
d87a 2801      jr      z,$d87d          ; (+$01)
d87c 29        add     hl,hl
d87d 09        add     hl,bc
d87e 19        add     hl,de
d87f eb        ex      de,hl
d880 e1        pop     hl
d881 37        scf     
d882 c9        ret     

d883 d5        push    de
d884 cd2cde    call    $de2c			; get next token skipping space
d887 3a9fb0    ld      a,($b09f)
d88a f5        push    af
d88b 0600      ld      b,$00
d88d cdcece    call    $cece
d890 e5        push    hl
d891 3e02      ld      a,$02
d893 cd72f6    call    $f672
d896 73        ld      (hl),e
d897 23        inc     hl
d898 72        ld      (hl),d
d899 e1        pop     hl
d89a 04        inc     b
d89b cd41de    call    $de41
d89e 38ed      jr      c,$d88d          ; (-$13)
d8a0 7e        ld      a,(hl)
d8a1 fe29      cp      $29
d8a3 2805      jr      z,$d8aa          ; (+$05)
d8a5 fe5d      cp      $5d
d8a7 c249cb    jp      nz,$cb49			; Error: Syntax Error
d8aa cd2cde    call    $de2c			; get next token skipping space
d8ad f1        pop     af
d8ae 329fb0    ld      ($b09f),a
d8b1 d1        pop     de
d8b2 c9        ret     

d8b3 e5        push    hl
d8b4 320dae    ld      ($ae0d),a
d8b7 c5        push    bc
d8b8 78        ld      a,b
d8b9 87        add     a,a
d8ba c603      add     a,$03
d8bc cda8d7    call    $d7a8
d8bf f5        push    af
d8c0 2a6cae    ld      hl,($ae6c)
d8c3 eb        ex      de,hl
d8c4 cdb8f6    call    $f6b8
d8c7 f1        pop     af
d8c8 cdb8d7    call    $d7b8
d8cb 60        ld      h,b
d8cc 69        ld      l,c
d8cd c1        pop     bc
d8ce d5        push    de
d8cf 23        inc     hl
d8d0 23        inc     hl
d8d1 3a9fb0    ld      a,($b09f)
d8d4 5f        ld      e,a
d8d5 1600      ld      d,$00
d8d7 70        ld      (hl),b
d8d8 e5        push    hl
d8d9 23        inc     hl
d8da d5        push    de
d8db 3a0dae    ld      a,($ae0d)
d8de b7        or      a
d8df 110a00    ld      de,$000a
d8e2 eb        ex      de,hl
d8e3 c427d9    call    nz,$d927
d8e6 eb        ex      de,hl
d8e7 13        inc     de
d8e8 73        ld      (hl),e
d8e9 23        inc     hl
d8ea 72        ld      (hl),d
d8eb 23        inc     hl
d8ec e3        ex      (sp),hl
d8ed cd72dd    call    $dd72
d8f0 da81d6    jp      c,$d681
d8f3 eb        ex      de,hl
d8f4 e1        pop     hl
d8f5 10e3      djnz    $d8da            ; (-$1d)
d8f7 42        ld      b,d
d8f8 4b        ld      c,e
d8f9 54        ld      d,h
d8fa 5d        ld      e,l
d8fb cdbbf6    call    $f6bb
d8fe 226cae    ld      ($ae6c),hl
d901 c5        push    bc
d902 2b        dec     hl
d903 3600      ld      (hl),$00
d905 0b        dec     bc
d906 78        ld      a,b
d907 b1        or      c
d908 20f8      jr      nz,$d902         ; (-$08)
d90a c1        pop     bc
d90b e1        pop     hl
d90c 5e        ld      e,(hl)
d90d 57        ld      d,a
d90e eb        ex      de,hl
d90f 29        add     hl,hl
d910 23        inc     hl
d911 09        add     hl,bc
d912 eb        ex      de,hl
d913 2b        dec     hl
d914 2b        dec     hl
d915 73        ld      (hl),e
d916 23        inc     hl
d917 72        ld      (hl),d
d918 23        inc     hl
d919 e3        ex      (sp),hl
d91a eb        ex      de,hl
d91b 3a9fb0    ld      a,($b09f)
d91e cd27d6    call    $d627
d921 cdd0d7    call    $d7d0
d924 d1        pop     de
d925 e1        pop     hl
d926 c9        ret     

d927 3e02      ld      a,$02
d929 cd62f6    call    $f662
d92c 7e        ld      a,(hl)
d92d 23        inc     hl
d92e 66        ld      h,(hl)
d92f 6f        ld      l,a
d930 c9        ret     

d931 cdafd9    call    $d9af
d934 23        inc     hl
d935 5e        ld      e,(hl)
d936 23        inc     hl
d937 56        ld      d,(hl)
d938 7a        ld      a,d
d939 b3        or      e
d93a 280a      jr      z,$d946          ; (+$0a)
d93c 23        inc     hl
d93d 7e        ld      a,(hl)
d93e 17        rla     
d93f 30fb      jr      nc,$d93c         ; (-$05)
d941 cd2cde    call    $de2c			; get next token skipping space
d944 37        scf     
d945 c9        ret     

d946 2b        dec     hl
d947 2b        dec     hl
d948 eb        ex      de,hl
d949 c1        pop     bc
d94a 2a0eae    ld      hl,($ae0e)
d94d e5        push    hl
d94e 215ed9    ld      hl,$d95e
d951 e5        push    hl
d952 c5        push    bc
d953 eb        ex      de,hl
d954 e5        push    hl
d955 cd6cd9    call    $d96c
d958 ed530eae  ld      ($ae0e),de
d95c d1        pop     de
d95d c9        ret     

d95e e5        push    hl
d95f 2a0eae    ld      hl,($ae0e)
d962 cd6ef6    call    $f66e
d965 e1        pop     hl
d966 e3        ex      (sp),hl
d967 220eae    ld      ($ae0e),hl
d96a e1        pop     hl
d96b c9        ret     

d96c e5        push    hl
d96d 7e        ld      a,(hl)
d96e 23        inc     hl
d96f 23        inc     hl
d970 23        inc     hl
d971 4e        ld      c,(hl)
d972 cba9      res     5,c
d974 e3        ex      (sp),hl
d975 fe0b      cp      $0b
d977 3817      jr      c,$d990          ; (+$17)
d979 79        ld      a,c
d97a e61f      and     $1f
d97c c6f2      add     a,$f2
d97e 5f        ld      e,a
d97f cead      adc     a,$ad
d981 93        sub     e
d982 57        ld      d,a
d983 1a        ld      a,(de)
d984 329fb0    ld      ($b09f),a
d987 360d      ld      (hl),$0d
d989 fe05      cp      $05
d98b 2803      jr      z,$d990          ; (+$03)
d98d c609      add     a,$09
d98f 77        ld      (hl),a
d990 d1        pop     de
d991 3e28      ld      a,$28
d993 cd72f6    call    $f672
d996 e5        push    hl
d997 0629      ld      b,$29
d999 05        dec     b
d99a ca49cb    jp      z,$cb49			; Error: Syntax Error
d99d 1a        ld      a,(de)
d99e 13        inc     de
d99f e6df      and     $df
d9a1 77        ld      (hl),a
d9a2 23        inc     hl
d9a3 17        rla     
d9a4 30f3      jr      nc,$d999         ; (-$0d)
d9a6 cd6ef6    call    $f66e
d9a9 eb        ex      de,hl
d9aa 2b        dec     hl
d9ab d1        pop     de
d9ac c32cde    jp      $de2c			; get next token skipping space

d9af 7e        ld      a,(hl)
d9b0 fe0b      cp      $0b
d9b2 3802      jr      c,$d9b6          ; (+$02)
d9b4 c6f7      add     a,$f7
d9b6 fe04      cp      $04
d9b8 2809      jr      z,$d9c3          ; (+$09)
d9ba 3004      jr      nc,$d9c0         ; (+$04)
d9bc fe02      cp      $02
d9be 3005      jr      nc,$d9c5         ; (+$05)
d9c0 c349cb    jp      $cb49			; Error: Syntax Error
d9c3 3e05      ld      a,$05
d9c5 329fb0    ld      ($b09f),a
d9c8 c9        ret     

d9c9 cd02d6    call    $d602
d9cc 2a6cae    ld      hl,($ae6c)
d9cf eb        ex      de,hl
d9d0 2a6aae    ld      hl,($ae6a)
d9d3 cdd8ff    call    $ffd8 ; HL=DE?
d9d6 c8        ret     z

d9d7 d5        push    de
d9d8 cd65d7    call    $d765
d9db 7e        ld      a,(hl)
d9dc 23        inc     hl
d9dd e607      and     $07
d9df 3c        inc     a
d9e0 e5        push    hl
d9e1 cd27d6    call    $d627
d9e4 cdd0d7    call    $d7d0
d9e7 e1        pop     hl
d9e8 5e        ld      e,(hl)
d9e9 23        inc     hl
d9ea 56        ld      d,(hl)
d9eb 23        inc     hl
d9ec 19        add     hl,de
d9ed d1        pop     de
d9ee 18e3      jr      $d9d3            ; (-$1d)

;;========================================================================
;; ERASE

d9f0 cd4dea    call    $ea4d
d9f3 cdfcd9    call    $d9fc
d9f6 cd41de    call    $de41
d9f9 38f8      jr      c,$d9f3          ; (-$08)
d9fb c9        ret     

d9fc cd31d9    call    $d931
d9ff e5        push    hl
da00 3a9fb0    ld      a,($b09f)
da03 cd27d6    call    $d627
da06 cd40d7    call    $d740
da09 d24dcb    jp      nc,$cb4d			; Error: Improper Argument
da0c eb        ex      de,hl
da0d 4e        ld      c,(hl)
da0e 23        inc     hl
da0f 46        ld      b,(hl)
da10 23        inc     hl
da11 09        add     hl,bc
da12 cde4ff    call    $ffe4			; BC = HL-DE
da15 cde5f6    call    $f6e5
da18 cd21f6    call    $f621
da1b cdc9d9    call    $d9c9
da1e e1        pop     hl
da1f c9        ret     

da20 210000    ld      hl,$0000
da23 2212ae    ld      ($ae12),hl
da26 2210ae    ld      ($ae10),hl
da29 c9        ret     

da2a e5        push    hl
da2b 2a10ae    ld      hl,($ae10)
da2e eb        ex      de,hl
da2f 3e06      ld      a,$06
da31 cd72f6    call    $f672
da34 2210ae    ld      ($ae10),hl
da37 73        ld      (hl),e
da38 23        inc     hl
da39 72        ld      (hl),d
da3a 23        inc     hl
da3b af        xor     a
da3c 77        ld      (hl),a
da3d 23        inc     hl
da3e 77        ld      (hl),a
da3f 23        inc     hl
da40 ed5b12ae  ld      de,($ae12)
da44 73        ld      (hl),e
da45 23        inc     hl
da46 72        ld      (hl),d
da47 e1        pop     hl
da48 c9        ret     

da49 e5        push    hl
da4a 2a10ae    ld      hl,($ae10)
da4d 2212ae    ld      ($ae12),hl
da50 e1        pop     hl
da51 c9        ret     

da52 2a10ae    ld      hl,($ae10)
da55 cd6ef6    call    $f66e
da58 5e        ld      e,(hl)
da59 23        inc     hl
da5a 56        ld      d,(hl)
da5b 23        inc     hl
da5c ed5310ae  ld      ($ae10),de
da60 23        inc     hl
da61 23        inc     hl
da62 5e        ld      e,(hl)
da63 23        inc     hl
da64 56        ld      d,(hl)
da65 eb        ex      de,hl
da66 2212ae    ld      ($ae12),hl
da69 c9        ret     

da6a e5        push    hl
da6b 3e02      ld      a,$02
da6d cd72f6    call    $f672
da70 e3        ex      (sp),hl
da71 cdafd9    call    $d9af
da74 cd6cd9    call    $d96c
da77 e3        ex      (sp),hl
da78 eb        ex      de,hl
da79 2a10ae    ld      hl,($ae10)
da7c 23        inc     hl
da7d 23        inc     hl
da7e 010000    ld      bc,$0000
da81 cdd0d7    call    $d7d0
da84 3a9fb0    ld      a,($b09f)
da87 47        ld      b,a
da88 3c        inc     a
da89 cd72f6    call    $f672
da8c 78        ld      a,b
da8d 3d        dec     a
da8e 77        ld      (hl),a
da8f 23        inc     hl
da90 eb        ex      de,hl
da91 e1        pop     hl
da92 c9        ret     

da93 2a10ae    ld      hl,($ae10)
da96 7c        ld      a,h
da97 b5        or      l
da98 280e      jr      z,$daa8          ; (+$0e)
da9a 4e        ld      c,(hl)
da9b 23        inc     hl
da9c 46        ld      b,(hl)
da9d 23        inc     hl
da9e c5        push    bc
da9f 010000    ld      bc,$0000
daa2 cde9da    call    $dae9
daa5 e1        pop     hl
daa6 18ee      jr      $da96            ; (-$12)
daa8 01411a    ld      bc,$1a41
daab c5        push    bc
daac 79        ld      a,c
daad cd19d6    call    $d619
dab0 cde9da    call    $dae9
dab3 c1        pop     bc
dab4 0c        inc     c
dab5 10f4      djnz    $daab            ; (-$0c)
dab7 3e03      ld      a,$03
dab9 cd27d6    call    $d627
dabc e5        push    hl
dabd e1        pop     hl
dabe 4e        ld      c,(hl)
dabf 23        inc     hl
dac0 46        ld      b,(hl)
dac1 78        ld      a,b
dac2 b1        or      c
dac3 c8        ret     z

dac4 2a6aae    ld      hl,($ae6a)
dac7 2b        dec     hl
dac8 09        add     hl,bc
dac9 e5        push    hl
daca d5        push    de
dacb cd65d7    call    $d765
dace d1        pop     de
dacf 23        inc     hl
dad0 4e        ld      c,(hl)
dad1 23        inc     hl
dad2 46        ld      b,(hl)
dad3 23        inc     hl
dad4 e5        push    hl
dad5 09        add     hl,bc
dad6 e3        ex      (sp),hl
dad7 4e        ld      c,(hl)
dad8 23        inc     hl
dad9 0600      ld      b,$00
dadb 09        add     hl,bc
dadc 09        add     hl,bc
dadd c1        pop     bc
dade cddeff    call    $ffde ; HL=BC?
dae1 28da      jr      z,$dabd          ; (-$26)
dae3 cd02db    call    $db02
dae6 23        inc     hl
dae7 18f5      jr      $dade            ; (-$0b)
dae9 7e        ld      a,(hl)
daea 23        inc     hl
daeb 66        ld      h,(hl)
daec 6f        ld      l,a
daed b4        or      h
daee c8        ret     z

daef 09        add     hl,bc
daf0 e5        push    hl
daf1 d5        push    de
daf2 cd65d7    call    $d765
daf5 d1        pop     de
daf6 7e        ld      a,(hl)
daf7 23        inc     hl
daf8 e607      and     $07
dafa fe02      cp      $02
dafc cc02db    call    z,$db02
daff e1        pop     hl
db00 18e7      jr      $dae9            ; (-$19)
db02 c5        push    bc
db03 d5        push    de
db04 7e        ld      a,(hl)
db05 23        inc     hl
db06 4e        ld      c,(hl)
db07 23        inc     hl
db08 46        ld      b,(hl)
db09 e5        push    hl
db0a eb        ex      de,hl
db0b b7        or      a
db0c c4fbff    call    nz,$fffb			; JP (HL)
db0f e1        pop     hl
db10 d1        pop     de
db11 c1        pop     bc
db12 c9        ret     

;;========================================================================
;; LINE

db13 cd25de    call    $de25
defb &a3
db17 cdd4c1    call    $c1d4
db1a cd8bdb    call    $db8b
db1d cdbfd6    call    $d6bf
db20 cd5eff    call    $ff5e
db23 e5        push    hl
db24 d5        push    de
db25 cd31db    call    $db31
db28 cd8af8    call    $f88a
db2b e1        pop     hl
db2c cda8d6    call    $d6a8
db2f e1        pop     hl
db30 c9        ret     

db31 cdc4c1    call    $c1c4
db34 d257dc    jp      nc,$dc57
db37 cdecca    call    $caec
db3a 3a14ae    ld      a,($ae14)
db3d fe3b      cp      $3b
db3f c498c3    call    nz,$c398      ;; new text line
db42 c9        ret     

;;========================================================================
;; INPUT

db43 cdd4c1    call    $c1d4
db46 cd5bdb    call    $db5b
db49 d5        push    de
db4a cdbfd6    call    $d6bf
db4d e3        ex      (sp),hl
db4e af        xor     a
db4f cdbddb    call    $dbbd
db52 23        inc     hl
db53 e3        ex      (sp),hl
db54 cd41de    call    $de41
db57 38f1      jr      c,$db4a          ; (-$0f)
db59 d1        pop     de
db5a c9        ret     

db5b cdc4c1    call    $c1c4
db5e 302b      jr      nc,$db8b         ; (+$2b)
db60 e5        push    hl
db61 cd8bdb    call    $db8b
db64 e5        push    hl
db65 cd37db    call    $db37
db68 eb        ex      de,hl
db69 e1        pop     hl
db6a cdcddb    call    $dbcd
db6d c1        pop     bc
db6e d8        ret     c

db6f c5        push    bc
db70 2179db    ld      hl,$db79			;; "?Redo from start" message
db73 cd8bc3    call    $c38b			;; display 0 terminated string
db76 e1        pop     hl
db77 18e7      jr      $db60            ; (-$19)

db79: "?Redo from start",10,0

db8b 7e        ld      a,(hl)
db8c fe3b      cp      $3b
db8e 3214ae    ld      ($ae14),a
db91 cc2cde    call    z,$de2c			; get next token skipping space
db94 fe22      cp      $22
db96 200b      jr      nz,$dba3         ; (+$0b)
db98 cdb1db    call    $dbb1
db9b cd41de    call    $de41
db9e d8        ret     c

db9f cd25de    call    $de25
defb &3b
dba3 cdc4c1    call    $c1c4
dba6 d0        ret     nc

dba7 3e3f      ld      a,$3f
dba9 cda0c3    call    $c3a0           ;; display text char
dbac 3e20      ld      a,$20
dbae c3a0c3    jp      $c3a0           ;; display text char
dbb1 cd79f8    call    $f879
dbb4 cdc4c1    call    $c1c4
dbb7 d2f5fb    jp      nc,$fbf5
dbba c3d0f8    jp      $f8d0
dbbd d5        push    de
dbbe cdf7db    call    $dbf7
dbc1 3006      jr      nc,$dbc9         ; (+$06)
dbc3 e3        ex      (sp),hl
dbc4 cd9fd6    call    $d69f
dbc7 e1        pop     hl
dbc8 c9        ret     

dbc9 cd45cb    call    $cb45
dbcc 0d        dec     c
dbcd d5        push    de
dbce e5        push    hl
dbcf d5        push    de
dbd0 cd0fd7    call    $d70f
dbd3 e3        ex      (sp),hl
dbd4 af        xor     a
dbd5 cdf7db    call    $dbf7
dbd8 3019      jr      nc,$dbf3         ; (+$19)
dbda fe03      cp      $03
dbdc ccf5fb    call    z,$fbf5
dbdf e3        ex      (sp),hl
dbe0 cd41de    call    $de41
dbe3 e3        ex      (sp),hl
dbe4 7e        ld      a,(hl)
dbe5 3008      jr      nc,$dbef         ; (+$08)
dbe7 ee2c      xor     $2c
dbe9 2008      jr      nz,$dbf3         ; (+$08)
dbeb 23        inc     hl
dbec e3        ex      (sp),hl
dbed 18e1      jr      $dbd0            ; (-$1f)
dbef b7        or      a
dbf0 2001      jr      nz,$dbf3         ; (+$01)
dbf2 37        scf     
dbf3 e1        pop     hl
dbf4 e1        pop     hl
dbf5 d1        pop     de
dbf6 c9        ret     

dbf7 5f        ld      e,a
dbf8 cd66ff    call    $ff66
dbfb f5        push    af
dbfc 2006      jr      nz,$dc04         ; (+$06)
dbfe cd15dc    call    $dc15
dc01 37        scf     
dc02 1809      jr      $dc0d            ; (+$09)
dc04 cdc4c1    call    $c1c4
dc07 d42cdc    call    nc,$dc2c
dc0a cd6fed    call    $ed6f
dc0d f5        push    af
dc0e dc4dde    call    c,$de4d ; skip space, lf or tab
dc11 f1        pop     af
dc12 d1        pop     de
dc13 7a        ld      a,d
dc14 c9        ret     

dc15 cdc4c1    call    $c1c4
dc18 3806      jr      c,$dc20          ; (+$06)
dc1a cd38dc    call    $dc38
dc1d c38af8    jp      $f88a
dc20 cd4dde    call    $de4d ; skip space, lf or tab
dc23 fe22      cp      $22
dc25 ca79f8    jp      z,$f879
dc28 7b        ld      a,e
dc29 c394f8    jp      $f894
dc2c cd8edc    call    $dc8e
dc2f 11b5dc    ld      de,$dcb5
dc32 382b      jr      c,$dc5f          ; (+$2b)
dc34 cd45cb    call    $cb45
dc37 18cd      jr      $dc06            ; (-$33)
dc39 8e        adc     a,(hl)
dc3a dc30f7    call    c,$f730
dc3d fe22      cp      $22
dc3f 2805      jr      z,$dc46          ; (+$05)
dc41 11b9dc    ld      de,$dcb9
dc44 1819      jr      $dc5f            ; (+$19)
dc46 cd99dc    call    $dc99
dc49 1154dc    ld      de,$dc54
dc4c 3811      jr      c,$dc5f          ; (+$11)
dc4e 218aac    ld      hl,$ac8a
dc51 3600      ld      (hl),$00
dc53 c9        ret     

dc54 fe22      cp      $22
dc56 c9        ret     

dc57 cd99dc    call    $dc99
dc5a 30d8      jr      nc,$dc34         ; (-$28)
dc5c 11bcdc    ld      de,$dcbc
dc5f 218aac    ld      hl,$ac8a
dc62 e5        push    hl
dc63 06ff      ld      b,$ff
dc65 cdfeff    call    $fffe			; JP (DE)
dc68 280c      jr      z,$dc76          ; (+$0c)
dc6a 77        ld      (hl),a
dc6b 23        inc     hl
dc6c 05        dec     b
dc6d 2805      jr      z,$dc74          ; (+$05)
dc6f cd99dc    call    $dc99
dc72 38f1      jr      c,$dc65          ; (-$0f)
dc74 f6ff      or      $ff
dc76 3600      ld      (hl),$00
dc78 e1        pop     hl
dc79 c0        ret     nz

dc7a fe0d      cp      $0d
dc7c c8        ret     z

dc7d fe22      cp      $22
dc7f c4bfdc    call    nz,$dcbf
dc82 c0        ret     nz

dc83 cd8edc    call    $dc8e
dc86 d0        ret     nc

dc87 cdb9dc    call    $dcb9
dc8a c486bc    call    nz,$bc86			; firmware function: CAS RETURN
dc8d c9        ret     

dc8e cd99dc    call    $dc99
dc91 d0        ret     nc

dc92 cdbfdc    call    $dcbf
dc95 28f7      jr      z,$dc8e          ; (-$09)
dc97 37        scf     
dc98 c9        ret     

dc99 cd5cc4    call    $c45c ; read byte from cassette or disc
dc9c d0        ret     nc

dc9d f5        push    af
dc9e c5        push    bc
dc9f 010d0a    ld      bc,$0a0d
dca2 b9        cp      c
dca3 2804      jr      z,$dca9          ; (+$04)
dca5 b8        cp      b
dca6 200a      jr      nz,$dcb2         ; (+$0a)
dca8 41        ld      b,c
dca9 cd5cc4    call    $c45c ; read byte from cassette or disc
dcac 3004      jr      nc,$dcb2         ; (+$04)
dcae b8        cp      b
dcaf c486bc    call    nz,$bc86			;; firmware function: cas return
dcb2 c1        pop     bc
dcb3 f1        pop     af
dcb4 c9        ret     

;;========================================================================
;; read comma seperated data??
dcb5 cdbfdc    call    $dcbf
dcb8 c8        ret     z

dcb9 fe2c      cp      $2c		;; ,
dcbb c8        ret     z

dcbc fe0d      cp      $0d		;; lf
dcbe c9        ret     

;;========================================================================

dcbf fe20      cp      $20		;; space
dcc1 c8        ret     z

dcc2 fe09      cp      $09		;; tab
dcc4 c8        ret     z

dcc5 fe0a      cp      $0a		;; cr
dcc7 c9        ret     

;;========================================================================
;; RESTORE
dcc8 280a      jr      z,$dcd4          ; (+$0a)
dcca cd48cf    call    $cf48
dccd e5        push    hl
dcce cd5ce8    call    $e85c
dcd1 2b        dec     hl
dcd2 1831      jr      $dd05            ; (+$31)
dcd4 e5        push    hl
dcd5 2a64ae    ld      hl,($ae64)
dcd8 182b      jr      $dd05            ; (+$2b)

;;========================================================================
;; READ
dcda e5        push    hl
dcdb 2a17ae    ld      hl,($ae17)
dcde cd0add    call    $dd0a
dce1 e3        ex      (sp),hl
dce2 cdbfd6    call    $d6bf
dce5 e3        ex      (sp),hl
dce6 23        inc     hl
dce7 3e01      ld      a,$01
dce9 cdbddb    call    $dbbd
dcec 7e        ld      a,(hl)
dced fe02      cp      $02
dcef 380d      jr      c,$dcfe          ; (+$0d)
dcf1 fe2c      cp      $2c
dcf3 2809      jr      z,$dcfe          ; (+$09)
dcf5 2a15ae    ld      hl,($ae15)
dcf8 cdadde    call    $dead
dcfb c349cb    jp      $cb49			; Error: Syntax Error
dcfe e3        ex      (sp),hl
dcff cd41de    call    $de41
dd02 e3        ex      (sp),hl
dd03 38d9      jr      c,$dcde          ; (-$27)
dd05 2217ae    ld      ($ae17),hl
dd08 e1        pop     hl
dd09 c9        ret     

dd0a 7e        ld      a,(hl)
dd0b fe2c      cp      $2c
dd0d c8        ret     z

dd0e cda3e9    call    $e9a3			;; DATA
dd11 b7        or      a
dd12 200e      jr      nz,$dd22         ; (+$0e)
dd14 23        inc     hl
dd15 7e        ld      a,(hl)
dd16 23        inc     hl
dd17 b6        or      (hl)
dd18 23        inc     hl
dd19 3e04      ld      a,$04
dd1b ca55cb    jp      z,$cb55
dd1e 2215ae    ld      ($ae15),hl
dd21 23        inc     hl
dd22 cd2cde    call    $de2c			; get next token skipping space
dd25 fe8c      cp      $8c
dd27 20e5      jr      nz,$dd0e         ; (-$1b)
dd29 c9        ret     

dd2a 44        ld      b,h
dd2b cdeadd    call    $ddea
dd2e 1802      jr      $dd32            ; (+$02)
dd30 0600      ld      b,$00
dd32 1e00      ld      e,$00
dd34 0e02      ld      c,$02
dd36 c9        ret     

dd37 7c        ld      a,h
dd38 b7        or      a
dd39 fa42dd    jp      m,$dd42
dd3c b0        or      b
dd3d faeddd    jp      m,$dded
dd40 37        scf     
dd41 c9        ret     

;;--------------------------------------------------------------
dd42 ee80      xor     $80
dd44 b5        or      l
dd45 c0        ret     nz

dd46 78        ld      a,b
dd47 37        scf     
dd48 8f        adc     a,a
dd49 c9        ret     

;;--------------------------------------------------------------

dd4a b7        or      a
dd4b ed5a      adc     hl,de
dd4d 37        scf     
dd4e e0        ret     po

dd4f f6ff      or      $ff
dd51 c9        ret     

;;--------------------------------------------------------------

dd52 eb        ex      de,hl
dd53 b7        or      a
dd54 ed52      sbc     hl,de
dd56 37        scf     
dd57 e0        ret     po

dd58 f6ff      or      $ff
dd5a c9        ret     

;;--------------------------------------------------------------

dd5b cd67dd    call    $dd67
dd5e cd72dd    call    $dd72
dd61 d237dd    jp      nc,$dd37
dd64 f6ff      or      $ff
dd66 c9        ret     

dd67 7c        ld      a,h
dd68 aa        xor     d
dd69 47        ld      b,a
dd6a eb        ex      de,hl
dd6b cdeadd    call    $ddea
dd6e eb        ex      de,hl
dd6f c3eadd    jp      $ddea
dd72 7c        ld      a,h
dd73 b7        or      a
dd74 2805      jr      z,$dd7b          ; (+$05)
dd76 7a        ld      a,d
dd77 b7        or      a
dd78 37        scf     
dd79 c0        ret     nz

dd7a eb        ex      de,hl
dd7b b5        or      l
dd7c c8        ret     z

dd7d 7a        ld      a,d
dd7e b3        or      e
dd7f 7d        ld      a,l
dd80 6b        ld      l,e
dd81 62        ld      h,d
dd82 c8        ret     z

dd83 fe03      cp      $03
dd85 3810      jr      c,$dd97          ; (+$10)
dd87 37        scf     
dd88 8f        adc     a,a
dd89 30fd      jr      nc,$dd88         ; (-$03)
dd8b 29        add     hl,hl
dd8c d8        ret     c

dd8d 87        add     a,a
dd8e 3002      jr      nc,$dd92         ; (+$02)
dd90 19        add     hl,de
dd91 d8        ret     c

dd92 fe80      cp      $80
dd94 20f5      jr      nz,$dd8b         ; (-$0b)
dd96 c9        ret     

dd97 fe01      cp      $01
dd99 c8        ret     z

dd9a 29        add     hl,hl
dd9b c9        ret     

dd9c cdabdd    call    $ddab
dd9f da37dd    jp      c,$dd37
dda2 c9        ret     

dda3 4c        ld      c,h
dda4 cdabdd    call    $ddab
dda7 eb        ex      de,hl
dda8 41        ld      b,c
dda9 18f4      jr      $dd9f            ; (-$0c)
ddab cd67dd    call    $dd67
ddae 7a        ld      a,d
ddaf b3        or      e
ddb0 c8        ret     z

ddb1 c5        push    bc
ddb2 eb        ex      de,hl
ddb3 0601      ld      b,$01
ddb5 7c        ld      a,h
ddb6 b7        or      a
ddb7 2009      jr      nz,$ddc2         ; (+$09)
ddb9 7a        ld      a,d
ddba bd        cp      l
ddbb 3805      jr      c,$ddc2          ; (+$05)
ddbd 65        ld      h,l
ddbe 2e00      ld      l,$00
ddc0 0609      ld      b,$09
ddc2 7b        ld      a,e
ddc3 95        sub     l
ddc4 7a        ld      a,d
ddc5 9c        sbc     a,h
ddc6 3805      jr      c,$ddcd          ; (+$05)
ddc8 04        inc     b
ddc9 29        add     hl,hl
ddca 30f6      jr      nc,$ddc2         ; (-$0a)
ddcc 3f        ccf     
ddcd 3f        ccf     
ddce 78        ld      a,b
ddcf 44        ld      b,h
ddd0 4d        ld      c,l
ddd1 210000    ld      hl,$0000
ddd4 180e      jr      $dde4            ; (+$0e)
ddd6 cb18      rr      b
ddd8 cb19      rr      c
ddda eb        ex      de,hl
dddb ed42      sbc     hl,bc
dddd 3001      jr      nc,$dde0         ; (+$01)
dddf 09        add     hl,bc
dde0 eb        ex      de,hl
dde1 3f        ccf     
dde2 ed6a      adc     hl,hl
dde4 3d        dec     a
dde5 20ef      jr      nz,$ddd6         ; (-$11)
dde7 37        scf     
dde8 c1        pop     bc
dde9 c9        ret     

;;--------------------------------------------------------------

ddea 7c        ld      a,h
ddeb b7        or      a
ddec f0        ret     p

dded af        xor     a
ddee 95        sub     l
ddef 6f        ld      l,a
ddf0 9c        sbc     a,h
ddf1 95        sub     l
ddf2 bc        cp      h
ddf3 67        ld      h,a
ddf4 37        scf     
ddf5 c0        ret     nz

ddf6 fe01      cp      $01
ddf8 c9        ret     

;;--------------------------------------------------------------

;; HL = value

;; HL = 0?
ddf9 7c        ld      a,h
ddfa b5        or      l
ddfb c8        ret     z

ddfc 7c        ld      a,h
ddfd 87        add     a,a
ddfe 9f        sbc     a,a
ddff d8        ret     c

de00 3c        inc     a
de01 c9        ret     

;;--------------------------------------------------------------

de02 7c        ld      a,h
de03 aa        xor     d
de04 7c        ld      a,h
de05 f20dde    jp      p,$de0d
de08 87        add     a,a
;;---
de09 9f        sbc     a,a
de0a d8        ret     c

de0b 3c        inc     a
de0c c9        ret     

;;--------------------------------------------------------------

de0d ba        cp      d
de0e 20f9      jr      nz,$de09         ; (-$07)
de10 7d        ld      a,l
de11 93        sub     e
de12 20f5      jr      nz,$de09         ; (-$0b)
de14 c9        ret     

;;----------------------------------------------------------
de15 3e2c      ld      a,$2c			; ','
de17 1810      jr      $de29            ; 
;;----------------------------------------------------------
de19 3e28      ld      a,$28			; '('
de1b 180c      jr      $de29            ; 
;;----------------------------------------------------------
de1d 3e29      ld      a,$29			; ')'
de1f 1808      jr      $de29            
;;----------------------------------------------------------
de21 3eef      ld      a,$ef
de23 1804      jr      $de29            
;;----------------------------------------------------------
de25 e3        ex      (sp),hl			; get HL from top of stack
de26 7e        ld      a,(hl)			; get byte
de27 23        inc     hl				; increment pointer
de28 e3        ex      (sp),hl			; put HL back to stack
;;----------------------------------------------------------

;; A = char to check against
de29 be        cp      (hl)
de2a 200f      jr      nz,$de3b         ; (+$0f)

;; skip spaces
de2c 23        inc     hl
de2d 7e        ld      a,(hl)
de2e fe20      cp      $20				; ' '
de30 28fa      jr      z,$de2c          
 
de32 fe01      cp      $01
de34 d0        ret     nc
de35 b7        or      a
de36 c9        ret     
;;----------------------------------------------------------
de37 7e        ld      a,(hl)
de38 fe02      cp      $02
de3a d8        ret     c

de3b 186a      jr      $dea7            ; (+$6a)

de3d 7e        ld      a,(hl)
de3e fe02      cp      $02
de40 c9        ret     

de41 2b        dec     hl
de42 cd2cde    call    $de2c			; get next token skipping space
de45 ee2c      xor     $2c				; ','
de47 c0        ret     nz

de48 cd2cde    call    $de2c			; get next token skipping space
de4b 37        scf     
de4c c9        ret     

;;=======================================================================
;; skip space, tab or line feed
de4d 7e        ld      a,(hl)
de4e 23        inc     hl
de4f fe20      cp      $20				; ' '
de51 28fa      jr      z,$de4d ; skip space, lf or tab          
de53 fe09      cp      $09				; TAB
de55 28f6      jr      z,$de4d ; skip space, lf or tab          
de57 fe0a      cp      $0a				; LF
de59 28f2      jr      z,$de4d ; skip space, lf or tab          
de5b 2b        dec     hl
de5c c9        ret     
;;=======================================================================

de5d 2a1bae    ld      hl,($ae1b)
de60 221bae    ld      ($ae1b),hl
de63 cd21b9    call    $b921
de66 dcb2c8    call    c,$c8b2
de69 cd2cde    call    $de2c			; get next token skipping space
de6c c48fde    call    nz,$de8f
de6f 7e        ld      a,(hl)
de70 fe01      cp      $01
de72 28ec      jr      z,$de60          ; (-$14)
de74 3031      jr      nc,$dea7         ; (+$31)
de76 23        inc     hl
de77 7e        ld      a,(hl)
de78 23        inc     hl
de79 b6        or      (hl)
de7a 23        inc     hl
de7b 280f      jr      z,$de8c          ; (+$0f)
de7d 221dae    ld      ($ae1d),hl
de80 23        inc     hl
de81 3a1fae    ld      a,($ae1f)
de84 b7        or      a
de85 28d9      jr      z,$de60          ; (-$27)
de87 cdcade    call    $deca
de8a 18d4      jr      $de60            ; (-$2c)
de8c c349cc    jp      $cc49
de8f 87        add     a,a
de90 d289d6    jp      nc,$d689
de93 fec3      cp      $c3
de95 3010      jr      nc,$dea7         ; (+$10)
de97 eb        ex      de,hl
de98 c6e0      add     a,$e0
de9a 6f        ld      l,a
de9b cede      adc     a,$de
de9d 95        sub     l
de9e 67        ld      h,a
de9f 4e        ld      c,(hl)
dea0 23        inc     hl
dea1 46        ld      b,(hl)
dea2 c5        push    bc
dea3 eb        ex      de,hl
dea4 c32cde    jp      $de2c			; get next token skipping space

dea7 c349cb    jp      $cb49			; Error: Syntax Error

;;-----------------------------------------------------------------

deaa 210000    ld      hl,$0000
dead 221dae    ld      ($ae1d),hl
deb0 c9        ret     
;;-----------------------------------------------------------------

deb1 2a1dae    ld      hl,($ae1d)
deb4 c9        ret     
;;-----------------------------------------------------------------

;; address of current line number
deb5 2a1dae    ld      hl,($ae1d)
deb8 7c        ld      a,h
deb9 b5        or      l
deba c8        ret     z			;; direct command mode 

;; get address 
debb 7e        ld      a,(hl)
debc 23        inc     hl
debd 66        ld      h,(hl)
debe 6f        ld      l,a
debf 37        scf     
dec0 c9        ret     

;;========================================================================
;; TRON
dec1 3eff      ld      a,$ff
dec3 1801      jr      $dec6            ; (+$01)

;;========================================================================
;; TROFF
dec5 af        xor     a
dec6 321fae    ld      ($ae1f),a
dec9 c9        ret     

deca 3e5b      ld      a,$5b
decc cda0c3    call    $c3a0           ;; display text char
decf e5        push    hl
ded0 2a1dae    ld      hl,($ae1d)
ded3 7e        ld      a,(hl)
ded4 23        inc     hl
ded5 66        ld      h,(hl)
ded6 6f        ld      l,a
ded7 cd44ef    call    $ef44
deda e1        pop     hl
dedb 3e5d      ld      a,$5d
dedd c3a0c3    jp      $c3a0           ;; display text char

defw ca22		;; AFTER
defw c0ea		;; AUTO
defw c248		;; BORDER
defw f25c		;; CALL
defw d296		;; CAT
defw eafd		;; CHAIN
defw c12f		;; CLEAR
defw c506		;; CLG
defw d2ed		;; CLOSEIN
defw d2f5		;; CLOSEOUT
defw c280		;; CLS 
defw cc93		;; CONT
defw e9a3		;; DATA
defw d171		;; DEF 
defw d654		;; DEFINT
defw d658		;; DEFREAL
defw d650		;; DEFSTR
defw d529		;; DEG
defw e7ee		;; DELETE
defw d6b6		;; DIM
defw c539		;; DRAW
defw c53e		;; DRAWR
defw c046		;; EDIT
defw e9ad		;; ELSE
defw cc31		;; END
defw d3d4		;; ENT
defw d39e		;; ENV
defw d9f0		;; ERASE
defw cb51		;; ERROR
defw ca2a		;; EVERY
defw c5d4		;; FOR
defw c78c		;; GOSUB
defw c786		;; GOTO
defw c767		;; IF
defw c251		;; INK
defw db43		;; INPUT
defw d486		;; KEY
defw d68e		;; LET 
defw db13		;; LINE
defw e1cd		;; LIST
defw eab5		;; LOAD
defw c2ff		;; LOCATE
defw f56b		;; MEMORY
defw eb54		;; MERGE
defw fa07		;; MID$
defw c275		;; MODE
defw c52f		;; MOVE
defw c534		;; MOVER
defw c6a2		;; NEXT
defw c128		;; NEW
defw c882		;; ON 
defw c976		;; ON BREAK
defw ccca		;; ON BREAK GOTO
defw c9f5		;; SQ
defw d2b4		;; OPENIN
defw d2a8		;; OPENOUT
defw c4de		;; ORIGIN
defw f223		;; OUT
defw c239		;; PAPER
defw c224		;; PEN
defw c543		;; PLOT
defw c548		;; PLOTR
defw f20f		;; POKE
defw f2a4		;; PRINT
defw e9a7		;; '
defw d52d		;; RAD
defw d599		;; RANDOMIZE
defw dcda		;; READ
defw d370		;; RELEASE
defw e9a7		;; REM
defw e89e		;; RENUM
defw dcc8		;; RESTORE
defw ccd5		;; RESUME
defw c7b0		;; RETURN
defw ea78		;; RUN
defw ecdc		;; SAVE
defw d313		;; SOUND
defw d4db		;; SPEED
defw cc26		;; STOP
defw f784		;; SYMBOL
defw c343		;; TAG
defw c34a		;; TAGOFF
defw dec5		;; TROFF
defw dec1		;; TRON
defw f229		;; WAIT
defw c81a		;; WEND
defw c7e7		;; WHILE
defw c42a		;; WIDTH 
defw c30e		;; WINDOW
defw f508		;; WRITE
defw f29d		;; ZONE
defw c997		;; DI
defw c99d		;; EI
defw c512		;; FILL
defw c59a		;; GRAPHICS
defw c5c0		;; MASK
defw bd19		;; FRAME
defw c360		;; CURSOR

dfa4 d5ed    jp      $edd5
dfa6 5b        ld      e,e
dfa7 62        ld      h,d
dfa8 ae        xor     (hl)
dfa9 d5        push    de
dfaa cd35e0    call    $e035
dfad 012c01    ld      bc,$012c
dfb0 cdc8df    call    $dfc8
dfb3 7e        ld      a,(hl)
dfb4 b7        or      a
dfb5 20f9      jr      nz,$dfb0         ; (-$07)
dfb7 3e2d      ld      a,$2d			; '-'
dfb9 91        sub     c
dfba 4f        ld      c,a
dfbb 3e01      ld      a,$01
dfbd 98        sbc     a,b
dfbe 47        ld      b,a
dfbf af        xor     a
dfc0 12        ld      (de),a
dfc1 13        inc     de
dfc2 12        ld      (de),a
dfc3 13        inc     de
dfc4 12        ld      (de),a
dfc5 e1        pop     hl
dfc6 d1        pop     de
dfc7 c9        ret     

dfc8 7e        ld      a,(hl)
dfc9 b7        or      a
dfca c8        ret     z

dfcb cd92ff    call    $ff92			; is a alphabetical letter?
dfce 381c      jr      c,$dfec          ; (+$1c)
dfd0 cda0ff    call    $ffa0
dfd3 dae2e0    jp      c,$e0e2
dfd6 fe26      cp      $26
dfd8 ca36e1    jp      z,$e136
dfdb 23        inc     hl
dfdc b7        or      a
dfdd f8        ret     m

dfde fe21      cp      $21
dfe0 d25ce1    jp      nc,$e15c
dfe3 3a00ac    ld      a,($ac00)
dfe6 b7        or      a
dfe7 c0        ret     nz

dfe8 3e20      ld      a,$20
dfea 181c      jr      $e008            ; (+$1c)
dfec cd3ae0    call    $e03a
dfef d8        ret     c

dff0 fec5      cp      $c5
dff2 cac3e1    jp      z,$e1c3
dff5 e5        push    hl
dff6 2112e0    ld      hl,$e012
dff9 cdcaff    call    $ffca			;; check if byte exists in table 
dffc e1        pop     hl
dffd 3818      jr      c,$e017          ; (+$18)
dfff f5        push    af
e000 fe97      cp      $97
e002 3e01      ld      a,$01
e004 cc08e0    call    z,$e008
e007 f1        pop     af
e008 12        ld      (de),a
e009 13        inc     de
e00a 0b        dec     bc
e00b 79        ld      a,c
e00c b0        or      b
e00d c0        ret     nz

e00e cd45cb    call    $cb45
e011 17        rla     

;;------------------------------------------

e012 
defb &8c
defb &8e
defb &90
defb &8f
defb &00

;;------------------------------------------


e017 cd08e0    call    $e008
e01a 7e        ld      a,(hl)
e01b b7        or      a
e01c c8        ret     z

e01d fe3a      cp      $3a
e01f 2814      jr      z,$e035          ; (+$14)
e021 23        inc     hl
e022 b7        or      a
e023 fa1ae0    jp      m,$e01a
e026 fe20      cp      $20				; ' '
e028 3002      jr      nc,$e02c         ; (+$02)
e02a 3e20      ld      a,$20
e02c fe22      cp      $22				; '"'
e02e 20e7      jr      nz,$e017         ; (-$19)
e030 cd95e1    call    $e195
e033 18e5      jr      $e01a            ; (-$1b)
e035 af        xor     a
e036 3220ae    ld      ($ae20),a
e039 c9        ret     

e03a c5        push    bc
e03b d5        push    de
e03c e5        push    hl

e03d 7e        ld      a,(hl)			;; get initial character of BASIC keyword
e03e 23        inc     hl
e03f cdabff    call    $ffab			;; convert character to upper case
e042 cda8e3    call    $e3a8			;; get list of keywords beginning with this letter
e045 cdebe3    call    $e3eb
e048 3026      jr      nc,$e070         ;;

e04a 79        ld      a,c
e04b e67f      and     $7f
e04d cd9cff    call    $ff9c
e050 3009      jr      nc,$e05b         ; (+$09)
e052 1a        ld      a,(de)
e053 fee4      cp      $e4
e055 7e        ld      a,(hl)
e056 c49cff    call    nz,$ff9c
e059 3815      jr      c,$e070          ; (+$15)
e05b f1        pop     af
e05c 1a        ld      a,(de)
e05d b7        or      a
e05e faafe0    jp      m,$e0af
e061 d1        pop     de
e062 c1        pop     bc
e063 f5        push    af
e064 3eff      ld      a,$ff
e066 cd08e0    call    $e008
e069 f1        pop     af
e06a cd08e0    call    $e008
e06d af        xor     a
e06e 183a      jr      $e0aa            ; (+$3a)
e070 e1        pop     hl
e071 d1        pop     de
e072 c1        pop     bc
e073 e5        push    hl
e074 2b        dec     hl
e075 23        inc     hl
e076 7e        ld      a,(hl)
e077 cd9cff    call    $ff9c
e07a 38f9      jr      c,$e075          ; (-$07)
e07c cdd1e0    call    $e0d1
e07f 3804      jr      c,$e085          ; (+$04)
e081 3e0d      ld      a,$0d
e083 1806      jr      $e08b            ; (+$06)
e085 23        inc     hl
e086 fe05      cp      $05
e088 2001      jr      nz,$e08b         ; (+$01)
e08a 3d        dec     a
e08b cd08e0    call    $e008
e08e af        xor     a
e08f cd08e0    call    $e008
e092 af        xor     a
e093 cd08e0    call    $e008
e096 e3        ex      (sp),hl
e097 7e        ld      a,(hl)
e098 cd9cff    call    $ff9c
e09b 3007      jr      nc,$e0a4         ; (+$07)
e09d 7e        ld      a,(hl)
e09e cd08e0    call    $e008
e0a1 23        inc     hl
e0a2 18f3      jr      $e097            ; (-$0d)
e0a4 cdb5e1    call    $e1b5
e0a7 e1        pop     hl
e0a8 3eff      ld      a,$ff
e0aa 3220ae    ld      ($ae20),a
e0ad 37        scf     
e0ae c9        ret     

e0af e5        push    hl
e0b0 4f        ld      c,a
e0b1 21c3e0    ld      hl,$e0c3
e0b4 cdcaff    call    $ffca			;;check if byte exists in table
e0b7 9f        sbc     a,a
e0b8 e601      and     $01
e0ba 3220ae    ld      ($ae20),a
e0bd 79        ld      a,c
e0be e1        pop     hl
e0bf d1        pop     de
e0c0 c1        pop     bc
e0c1 b7        or      a
e0c2 c9        ret     

;;--------------------------------------------------------
e0c3 
defb &c7
defb &81
defb &c6
defb &92
defb &96
defb &c8
defb &e3
defb &97
defb &ca
defb &a7
defb &a0
defb &eb
defb &9f
defb &00
;;--------------------------------------------------------

e0d1 fe21      cp      $21
e0d3 2807      jr      z,$e0dc          ; (+$07)
e0d5 fe26      cp      $26
e0d7 d0        ret     nc

e0d8 fe24      cp      $24
e0da 3f        ccf     
e0db d0        ret     nc

e0dc de1f      sbc     a,$1f
e0de ee07      xor     $07
e0e0 37        scf     
e0e1 c9        ret     

e0e2 3a20ae    ld      a,($ae20)
e0e5 b7        or      a
e0e6 2810      jr      z,$e0f8          ; (+$10)
e0e8 7e        ld      a,(hl)
e0e9 23        inc     hl
e0ea fa08e0    jp      m,$e008
e0ed 2b        dec     hl
e0ee d5        push    de
e0ef cdcfee    call    $eecf
e0f2 3032      jr      nc,$e126         ; (+$32)
e0f4 3e1e      ld      a,$1e          ; 16-bit line number
e0f6 184d      jr      $e145            ; (+$4d)
e0f8 d5        push    de
e0f9 c5        push    bc
e0fa cd8aed    call    $ed8a
e0fd c1        pop     bc
e0fe 3026      jr      nc,$e126         ; (+$26)
e100 cd66ff    call    $ff66
e103 3e1f      ld      a,$1f
e105 303e      jr      nc,$e145         ; (+$3e)
e107 ed5ba0b0  ld      de,($b0a0)
e10b 7a        ld      a,d
e10c b7        or      a
e10d 3e1a      ld      a,$1a
e10f 2034      jr      nz,$e145         ; (+$34)
e111 e3        ex      (sp),hl
e112 eb        ex      de,hl
e113 7d        ld      a,l
e114 fe0a      cp      $0a
e116 3004      jr      nc,$e11c         ; (+$04)
e118 c60e      add     a,$0e
e11a 1806      jr      $e122            ; (+$06)
e11c 3e19      ld      a,$19
e11e cd08e0    call    $e008
e121 7d        ld      a,l
e122 e1        pop     hl
e123 c308e0    jp      $e008
e126 7e        ld      a,(hl)
e127 23        inc     hl
e128 e3        ex      (sp),hl
e129 eb        ex      de,hl
e12a cd08e0    call    $e008
e12d eb        ex      de,hl
e12e e3        ex      (sp),hl
e12f cdd8ff    call    $ffd8 ; HL=DE?
e132 20f2      jr      nz,$e126         ; (-$0e)
e134 d1        pop     de
e135 c9        ret     

e136 d5        push    de
e137 c5        push    bc
e138 cd8aed    call    $ed8a
e13b c1        pop     bc
e13c 30e8      jr      nc,$e126         ; (-$18)
e13e fe02      cp      $02
e140 3e1b      ld      a,$1b
e142 2801      jr      z,$e145          ; (+$01)
e144 3c        inc     a

e145 d1        pop     de
e146 cd08e0    call    $e008
e149 e5        push    hl
e14a 21a0b0    ld      hl,$b0a0
e14d cd4bff    call    $ff4b
e150 f5        push    af
e151 7e        ld      a,(hl)
e152 23        inc     hl
e153 cd08e0    call    $e008
e156 f1        pop     af
e157 3d        dec     a
e158 20f6      jr      nz,$e150         ; (-$0a)
e15a e1        pop     hl
e15b c9        ret     

e15c fe22      cp      $22				; '"'
e15e 2835      jr      z,$e195          ; (+$35)
e160 fe7c      cp      $7c				; '|' 
e162 283f      jr      z,$e1a3          ; (+$3f)
e164 c5        push    bc
e165 d5        push    de
e166 ee3f      xor     $3f
e168 06bf      ld      b,$bf
e16a 2810      jr      z,$e17c          ; (+$10)
e16c 2b        dec     hl
e16d 1136e7    ld      de,$e736
e170 cdebe3    call    $e3eb
e173 1a        ld      a,(de)
e174 3802      jr      c,$e178          ; (+$02)
e176 7e        ld      a,(hl)
e177 23        inc     hl
e178 47        ld      b,a
e179 cd89e1    call    $e189
e17c 3220ae    ld      ($ae20),a
e17f 78        ld      a,b
e180 d1        pop     de
e181 c1        pop     bc
e182 fec0      cp      $c0
e184 2836      jr      z,$e1bc          ; (+$36)
e186 c308e0    jp      $e008
e189 3d        dec     a
e18a c8        ret     z

e18b ee22      xor     $22				; '"'
e18d c8        ret     z

e18e 3a20ae    ld      a,($ae20)
e191 3c        inc     a
e192 c8        ret     z

e193 3d        dec     a
e194 c9        ret     

e195 cd08e0    call    $e008
e198 7e        ld      a,(hl)
e199 b7        or      a
e19a c8        ret     z

e19b 23        inc     hl
e19c fe22      cp      $22				; '"'
e19e 20f5      jr      nz,$e195         ; (-$0b)
e1a0 c308e0    jp      $e008
e1a3 cd08e0    call    $e008
e1a6 af        xor     a
e1a7 3220ae    ld      ($ae20),a
e1aa cd08e0    call    $e008
e1ad 7e        ld      a,(hl)
e1ae 23        inc     hl
e1af cd9cff    call    $ff9c
e1b2 38f6      jr      c,$e1aa          ; (-$0a)
e1b4 2b        dec     hl
e1b5 1b        dec     de
e1b6 1a        ld      a,(de)
e1b7 f680      or      $80
e1b9 12        ld      (de),a
e1ba 13        inc     de
e1bb c9        ret     

e1bc 3e01      ld      a,$01
e1be cd08e0    call    $e008
e1c1 3ec0      ld      a,$c0
e1c3 cd08e0    call    $e008
e1c6 7e        ld      a,(hl)
e1c7 23        inc     hl
e1c8 b7        or      a
e1c9 20f8      jr      nz,$e1c3         ; (-$08)
e1cb 2b        dec     hl
e1cc c9        ret     

;;========================================================================
;; LIST
e1cd cd0fcf    call    $cf0f
e1d0 c5        push    bc
e1d1 d5        push    de
e1d2 cdcac1    call    $c1ca
e1d5 cd37de    call    $de37
e1d8 cdaade    call    $deaa
e1db d1        pop     de
e1dc c1        pop     bc
e1dd cde3e1    call    $e1e3
e1e0 c358c0    jp      $c058
;;========================================================================

e1e3 d5        push    de
e1e4 50        ld      d,b
e1e5 59        ld      e,c
e1e6 cd64e8    call    $e864
e1e9 d1        pop     de
e1ea 4e        ld      c,(hl)
e1eb 23        inc     hl
e1ec 46        ld      b,(hl)
e1ed 2b        dec     hl
e1ee 78        ld      a,b
e1ef b1        or      c
e1f0 c8        ret     z

e1f1 cd72c4    call    $c472			; key
e1f4 e5        push    hl
e1f5 09        add     hl,bc
e1f6 e3        ex      (sp),hl
e1f7 d5        push    de
e1f8 e5        push    hl
e1f9 23        inc     hl
e1fa 23        inc     hl
e1fb 5e        ld      e,(hl)
e1fc 23        inc     hl
e1fd 56        ld      d,(hl)
e1fe e1        pop     hl
e1ff e3        ex      (sp),hl
e200 cdd8ff    call    $ffd8 ; HL=DE?
e203 e3        ex      (sp),hl
e204 3812      jr      c,$e218          ; (+$12)
e206 cd54e2    call    $e254
e209 218aac    ld      hl,$ac8a
e20c cd1de2    call    $e21d
e20f 23        inc     hl
e210 7e        ld      a,(hl)
e211 b7        or      a
e212 20f8      jr      nz,$e20c         ; (-$08)
e214 cd98c3    call    $c398      ;; new text line
e217 b7        or      a
e218 d1        pop     de
e219 e1        pop     hl
e21a 30ce      jr      nc,$e1ea         ; (-$32)
e21c c9        ret     

e21d cdbec1    call    $c1be
e220 7e        ld      a,(hl)
e221 380a      jr      c,$e22d          ; (+$0a)
e223 cdb8c3    call    $c3b8
e226 fe0a      cp      $0a
e228 c0        ret     nz

e229 3e0d      ld      a,$0d
e22b 1808      jr      $e235            ; (+$08)
e22d fe20      cp      $20
e22f 3e01      ld      a,$01
e231 dcb8c3    call    c,$c3b8
e234 7e        ld      a,(hl)
e235 c3b8c3    jp      $c3b8
e238 cd64e8    call    $e864
e23b 3817      jr      c,$e254          ; (+$17)
e23d eb        ex      de,hl
e23e cd4aef    call    $ef4a
e241 110001    ld      de,$0100
e244 018aac    ld      bc,$ac8a
e247 7e        ld      a,(hl)
e248 23        inc     hl
e249 02        ld      (bc),a
e24a 03        inc     bc
e24b 15        dec     d
e24c b7        or      a
e24d 20f8      jr      nz,$e247         ; (-$08)
e24f 02        ld      (bc),a
e250 0b        dec     bc
e251 c3e8e2    jp      $e2e8
e254 e5        push    hl
e255 cd3de2    call    $e23d
e258 e1        pop     hl
e259 23        inc     hl
e25a 23        inc     hl
e25b 23        inc     hl
e25c 23        inc     hl
e25d 7e        ld      a,(hl)
e25e 02        ld      (bc),a
e25f b7        or      a
e260 c8        ret     z

e261 cd66e2    call    $e266
e264 18f7      jr      $e25d            ; (-$09)
e266 faf8e2    jp      m,$e2f8
e269 fe02      cp      $02
e26b 381c      jr      c,$e289          ; (+$1c)
e26d fe05      cp      $05
e26f 3842      jr      c,$e2b3          ; (+$42)
e271 fe0e      cp      $0e
e273 383e      jr      c,$e2b3          ; (+$3e)
e275 fe20      cp      $20				; ' '
e277 3831      jr      c,$e2aa          ; (+$31)
e279 fe7c      cp      $7c				; '|'
e27b 2854      jr      z,$e2d1          ; (+$54)
e27d cdd1e0    call    $e0d1
e280 d49cff    call    nc,$ff9c
e283 dce6e2    call    c,$e2e6
e286 7e        ld      a,(hl)
e287 180d      jr      $e296            ; (+$0d)
e289 23        inc     hl
e28a 7e        ld      a,(hl)
e28b fec0      cp      $c0
e28d 285d      jr      z,$e2ec          ; (+$5d)
e28f fe97      cp      $97
e291 2869      jr      z,$e2fc          ; (+$69)
e293 2b        dec     hl
e294 3e3a      ld      a,$3a
e296 1e00      ld      e,$00
e298 fe22      cp      $22				; '"'
e29a 200b      jr      nz,$e2a7         ; (+$0b)
e29c cdcae2    call    $e2ca
e29f 23        inc     hl
e2a0 7e        ld      a,(hl)
e2a1 b7        or      a
e2a2 c8        ret     z

e2a3 fe22      cp      $22				; '"'
e2a5 20f5      jr      nz,$e29c         ; (-$0b)
e2a7 23        inc     hl
e2a8 1820      jr      $e2ca            ; (+$20)
e2aa cde6e2    call    $e2e6
e2ad cd2fe3    call    $e32f
e2b0 1e01      ld      e,$01
e2b2 c9        ret     

e2b3 cde6e2    call    $e2e6
e2b6 7e        ld      a,(hl)
e2b7 f5        push    af
e2b8 23        inc     hl
e2b9 23        inc     hl
e2ba 23        inc     hl
e2bb cddbe2    call    $e2db
e2be f1        pop     af
e2bf 1e01      ld      e,$01
e2c1 fe0b      cp      $0b
e2c3 d0        ret     nc

e2c4 1e00      ld      e,$00
e2c6 ee27      xor     $27
e2c8 e6fd      and     $fd

e2ca 02        ld      (bc),a
e2cb 03        inc     bc
e2cc 15        dec     d
e2cd c0        ret     nz

e2ce 0b        dec     bc
e2cf 14        inc     d
e2d0 c9        ret     

e2d1 1e01      ld      e,$01
e2d3 cdcae2    call    $e2ca
e2d6 23        inc     hl
e2d7 7e        ld      a,(hl)
e2d8 23        inc     hl
e2d9 b7        or      a
e2da c0        ret     nz

e2db 7e        ld      a,(hl)
e2dc e67f      and     $7f
e2de cdcae2    call    $e2ca
e2e1 be        cp      (hl)
e2e2 23        inc     hl
e2e3 30f6      jr      nc,$e2db         ; (-$0a)
e2e5 c9        ret     

e2e6 1d        dec     e
e2e7 c0        ret     nz

e2e8 3e20      ld      a,$20
e2ea 18de      jr      $e2ca            ; (-$22)

;;---------------------------------------------------------------------------

e2ec cdfce2    call    $e2fc
e2ef 7e        ld      a,(hl)			; get token
e2f0 b7        or      a				; end of line?
e2f1 c8        ret     z
e2f2 cdcae2    call    $e2ca
e2f5 23        inc     hl				; increment pointer for next token
e2f6 18f7      jr      $e2ef

;;---------------------------------------------------------------------------

e2f8 fec5      cp      $c5
e2fa 28f0      jr      z,$e2ec          ; (-$10)
e2fc 23        inc     hl
e2fd feff      cp      $ff
e2ff 2002      jr      nz,$e303         ; (+$02)
e301 7e        ld      a,(hl)
e302 23        inc     hl
e303 f5        push    af
e304 e5        push    hl
e305 cdb8e3    call    $e3b8
e308 b7        or      a
e309 2808      jr      z,$e313          ; (+$08)
e30b f5        push    af
e30c cde6e2    call    $e2e6
e30f f1        pop     af
e310 cdcae2    call    $e2ca
e313 7e        ld      a,(hl)
e314 e67f      and     $7f
e316 fe09      cp      $09
e318 c4cae2    call    nz,$e2ca
e31b be        cp      (hl)
e31c 23        inc     hl
e31d 28f4      jr      z,$e313          ; (-$0c)
e31f cd9cff    call    $ff9c
e322 1e00      ld      e,$00
e324 3002      jr      nc,$e328         ; (+$02)
e326 1e01      ld      e,$01
e328 e1        pop     hl
e329 f1        pop     af
e32a d6e4      sub     $e4
e32c c0        ret     nz

e32d 5f        ld      e,a
e32e c9        ret     

;;----------------------------------------------------
e32f d5        push    de

;; get token
e330 7e        ld      a,(hl)
e331 23        inc     hl
e332 fe1f      cp      $1f				; floating point value
e334 285d      jr      z,$e393          

;; read 16-bit value
e336 5e        ld      e,(hl)
e337 23        inc     hl
e338 56        ld      d,(hl)
e339 23        inc     hl

;; DE = 16-bit value
;; A = token value (indicates type of 16-bit data)

e33a fe1b      cp      $1b				; 16-bit integer binary value
e33c 2832      jr      z,$e370          
e33e fe1c      cp      $1c				; 16-bt integer hexidecimal value
e340 2839      jr      z,$e37b          
e342 fe1e      cp      $1e				; 16-bit integer BASIC line number
e344 2823      jr      z,$e369          
e346 fe1d      cp      $1d				; 16-bit BASIC program line memory address pointer
e348 2816      jr      z,$e360          
e34a fe1a      cp      $1a				; 16-bit integer decimal value
e34c 280b      jr      z,$e359          

;;------------------------
;; 8-bit values

;;--------------------------
;; step back one byte
e34e 2b        dec     hl

;;--------------------------
e34f 1600      ld      d,$00
e351 fe19      cp      $19				; 8-bit integer decimal value
e353 2804      jr      z,$e359          ; (+$04)
e355 2b        dec     hl
e356 d60e      sub     $0e
e358 5f        ld      e,a

e359 e3        ex      (sp),hl
e35a eb        ex      de,hl
e35b cd35ff    call    $ff35
e35e 183a      jr      $e39a            ; (+$3a)

e360 e5        push    hl
e361 eb        ex      de,hl
e362 23        inc     hl
e363 23        inc     hl
e364 23        inc     hl
e365 5e        ld      e,(hl)
e366 23        inc     hl
e367 56        ld      d,(hl)
e368 e1        pop     hl
e369 e3        ex      (sp),hl
e36a eb        ex      de,hl
e36b cd4aef    call    $ef4a
e36e 182d      jr      $e39d            ; (+$2d)

e370 e3        ex      (sp),hl
e371 3e58      ld      a,$58
e373 37        scf     
e374 f5        push    af
e375 c5        push    bc
e376 010101    ld      bc,$0101
e379 1807      jr      $e382            ; (+$07)

e37b e3        ex      (sp),hl
e37c b7        or      a
e37d f5        push    af
e37e c5        push    bc
e37f 010f04    ld      bc,$040f

e382 eb        ex      de,hl
e383 af        xor     a
e384 cddff1    call    $f1df
e387 c1        pop     bc
e388 3e26      ld      a,$26
e38a cdcae2    call    $e2ca
e38d f1        pop     af
e38e dccae2    call    c,$e2ca
e391 180a      jr      $e39d            ; (+$0a)

;;------------------------------------------------
;; floating point

e393 3e05      ld      a,$05
e395 cd6cff    call    $ff6c
e398 e3        ex      (sp),hl
e399 eb        ex      de,hl

;;------------------------------------------------
e39a cd5aef    call    $ef5a
e39d 7e        ld      a,(hl)
e39e 23        inc     hl
e39f cdcae2    call    $e2ca
e3a2 7e        ld      a,(hl)
e3a3 b7        or      a
e3a4 20f7      jr      nz,$e39d         ; (-$09)
e3a6 e1        pop     hl
e3a7 c9        ret     

;;=======================================================================
;; A = initial letter of BASIC keyword
e3a8 e5        push    hl
e3a9 d641      sub     $41				; initial letter - 'A'
										; number in range 0->27
e3ab 87        add     a,a				; x2 (two bytes per table entry)
										; A = offset into table

e3ac c618      add     a,$18			; table starts at &e418
e3ae 6f        ld      l,a
e3af cee4      adc     a,$e4
e3b1 95        sub     l
e3b2 67        ld      h,a

e3b3 5e        ld      e,(hl)			; get address of keyword list from table
e3b4 23        inc     hl
e3b5 56        ld      d,(hl)
e3b6 e1        pop     hl
e3b7 c9        ret     
;;========================================================================

e3b8 c5        push    bc
e3b9 4f        ld      c,a
e3ba 061a      ld      b,$1a
e3bc 214ce4    ld      hl,$e44c
e3bf cdd7e3    call    $e3d7
e3c2 380e      jr      c,$e3d2          ; (+$0e)
e3c4 23        inc     hl
e3c5 10f8      djnz    $e3bf            ; (-$08)
e3c7 2136e7    ld      hl,$e736
e3ca cdd7e3    call    $e3d7
e3cd d249cb    jp      nc,$cb49			; Error: Syntax Error
e3d0 06c0      ld      b,$c0
e3d2 78        ld      a,b
e3d3 c640      add     a,$40
e3d5 c1        pop     bc
e3d6 c9        ret     

e3d7 7e        ld      a,(hl)
e3d8 b7        or      a
e3d9 c8        ret     z

e3da e5        push    hl
e3db 7e        ld      a,(hl)
e3dc 23        inc     hl
e3dd 17        rla     
e3de 30fb      jr      nc,$e3db         ; (-$05)
e3e0 7e        ld      a,(hl)
e3e1 23        inc     hl
e3e2 b9        cp      c
e3e3 2803      jr      z,$e3e8          ; (+$03)
e3e5 f1        pop     af
e3e6 18ef      jr      $e3d7            ; (-$11)
e3e8 e1        pop     hl
e3e9 37        scf     
e3ea c9        ret     

e3eb 1a        ld      a,(de)
e3ec b7        or      a
e3ed c8        ret     z

e3ee e5        push    hl
e3ef 1a        ld      a,(de)
e3f0 13        inc     de
e3f1 fe09      cp      $09
e3f3 2804      jr      z,$e3f9          ; (+$04)
e3f5 fe20      cp      $20
e3f7 2005      jr      nz,$e3fe         ; (+$05)
e3f9 cd4dde    call    $de4d ; skip space, lf or tab
e3fc 18f1      jr      $e3ef            ; (-$0f)

;;-----------------------------------------------------

e3fe 4f        ld      c,a
e3ff 7e        ld      a,(hl)
e400 23        inc     hl
e401 cdabff    call    $ffab			;; convert character to upper case
e404 a9        xor     c				;; character the same?
e405 28e8      jr      z,$e3ef          ;
;; character not the same?
e407 e67f      and     $7f
e409 280a      jr      z,$e415          ; (+$0a)
e40b 1b        dec     de
e40c 1a        ld      a,(de)
e40d 13        inc     de
e40e 17        rla     
e40f 30fb      jr      nc,$e40c         ; (-$05)
e411 13        inc     de
e412 e1        pop     hl
e413 18d6      jr      $e3eb            ; (-$2a)
e415 f1        pop     af
e416 37        scf     
e417 c9        ret     

;; list of keywords sorted into alphabetical order
e418:
defw e720		;; AUTO, ATN, ASC, AND, AFTER, ABS
defw e715		;; BORDER, BIN$
defw e6cc		;; CURSOR, CREAL, COS, COPYCHR$, CONT, CLS, CLOSEOUT, CLOSEIN, CLG, CLEAR, CINT, CHR$, CHAIN, CAT, CALL
defw e692		;; DRAWR, DRAW, DIM, DI, DERR, DELETE, DEG, DEFSTR, DEFREAL, DEFINT, DEF, DEC$, DATA
defw e663		;; EXP, EVERY, ERROR, ERR, ERL, ERASE, EOF, ENV, ENT, END, ELSE, EI, EDIT
defw e64e		;; FRE, FRAME, FOR, FN, FIX, FILL
defw e63a		;; GRAPHICS, GOTO, GOSUB
defw e630		;; HIMEM, HEX$
defw e60f		;; INT,INSTR, INPUT, INP, INKEY$, INKEY, INK, IF
defw e60b		;; JOY
defw e607		;; KEY
defw e5db		;; LOWER$, LOG10, LOG, LOCATE, LOAD, LIST, LINE, LET, LEN, LEFT$
defw e5b1		;; MOVER, MOVE, MODE, MOD, MIN, MID$, MERGE, MEMORY, MAX, MASK
defw e5a6		;; NOT, NEW, NEXT
defw e56e		;; OUT, ORIGIN, OR, OPENOUT, OPENIN, ON SQ, ON ERROR GOTO, ON BREAK, ON
defw e54a		;; PRINT, POS, POKE PLOTR, PLOT, PI, PEN, PEEK, PAPER
defw e549		;; (no keywords defined)
defw e4ff		;; RUN, ROUND, RND, RIGHT$, RETURN, RESUME, RESTORE, RENUM, REMAIN, REM, RELEASE, READ, RANDOMIZE, RAD
defw e4bf		;; SYMBOL, SWAP, STRING$, STR$, STOP, STEP, SQR, SQ, SPEED, SPC, SPACE$, SOUND, SIN, SGN, SAVE
defw e493		;; TRON, TROFF, TO, TIME, THEN, TESTR, TEST, TAN, TAGOFF, TAG, TAB
defw e484		;; USING, UPPER$, UNT
defw e47c		;; VPOS, VAL
defw e45e		;; WRITE, WINDOW, WIDTH, WHILE, WEND, WAIT
defw e456		;; XPOS, XOR
defw e451		;; YPOS
defw e44c		;; ZONE


;; list of keyword as text followed by keyword byte.
;; end of list signalled with a 0 byte 
;;
;; - BASIC keyword stored excluding initial letter
;; e.g. "ZONE" is stored as "ONE"
;; - BASIC keyword stored with bit 7 of last letter of keyword set.
;; e.g. "ON","E"+&80 for ZONE
;; - keyword followed by keyword byte


e44c:
defb "ON","E"+&80,&da		;; ZONE
defb 0

e451:
defb "PO","S"+&80,&48		;; YPOS
defb 0

e456:
defb "PO","S"+&80,&47		;; XPOS
defb "O","R"+&80,&fd		;; XOR
defb 0

e45e:
defb "RIT","E"+&80,&d9		;; WRITE
defb "INDO","W"+&80,&d8		;; WINDOW
defb "IDT","H"+&80,&d7		;; WIDTH
defb "HIL","E"+&80,&d6		;; WHILE
defb "EN","D"+&80,&d5		;; WEND 
defb "AI","T"+&80,&d4		;; WAIT
defb 0

e47c:
defb "PO","S"+&80,&7f		;; VPOS
defb "A","L"+&80,&1d		;; VAL
defb 0

e484:
defb "SIN","G"+&80,&ed		;; USING
defb "PPER","$"+&80,&1c		;; UPPER$
defb "N","T"+&80,&1b		;; UNT
defb 0

e493:
defb "RO","N"+&80,&d3		;; TRON
defb "ROF","F"+&80,&d2		;; TROFF
defb "O"+&80,&ec			;; TO
defb "IM","E"+&80,&46		;; TIME
defb "HE","N"+&80,&eb		;; THEN
defb "EST","R"+&80,&7d		;; TESTR
defb "ES","T"+&80,&7c		;; TEST 
defb "A","N"+&80,&1a		;; TAN
defb "AGOF","F"+&80,&d1		;; TAFOFF
defb "A","G"+&80,&d0		;; TAG
defb "A","B"+&80,&ea		;; TAB
defb 0

e4bf:
defb "YMBO","L"+&80,&cf		;; SYMBOL
defb "WA","P"+&80,&e7		;; SWAP
defb "TRING","$"+&80,&7b	;; STRING$
defb "TR","$"+&80,&19		;; STR$
defb "TO","P"+&80,&ce		;; STOP
defb "TE","P"+&80,&e6		;; STEP
defb "Q","R"+&80,&18		;; SQR
defb "Q"+&80,&17			;; SQ
defb "PEE","D"+&80,&cd		;; SPEED
defb "P","C"+&80,&e5		;; SPC
defb "PACE","$"+&80,&16		;; SPACE$
defb "OUN","D"+&80,&cc		;; SOUND
defb "I","N"+&80,&15		;; SIN
defb "G","N"+&80,&14		;; SGN
defb "AV","E"+&80,&cb		;; SAVE
defb 0

e4ff:
defb "U","N"+&80,&ca		;; RUN
defb "OUN","D"+&80,&7a		;; ROUND
defb "N","D"+&80,&45		;; RND
defb "IGHT","$"+&80,&79		;; RIGHT$
defb "ETUR","N"+&80,&c9		;; RETURN
defb "ESUM","E"+&80,&c8		;; RESUME
defb "ESTOR","E"+&80,&c7	;; RESTORE
defb "ENU","M"+&80,&c6		;; RENUM
defb "EMAI","N"+&80,&13		;; REMAIN
defb "E","M"+&80,&c5		;; REM
defb "ELEAS","E"+&80,&c4	;; RELEASE
defb "EA","D"+&80,&c3		;; READ
defb "ANDOMIZ","E"+&80,&c2	;; RANDOMIZE
defb "A","D"+&80,&c1		;; RAD
defb 0

e549:
defb 0						

e54a:
defb "RIN","T"+&80,&bf		;; PRINT
defb "O","S"+&80,&78		;; POS
defb "OK","E"+&80,&be		;; POKE
defb "LOT","R"+&80,&bd		;; PLOTR
defb "LO","T"+&80,&bc		;; PLOT
defb "I"+&80,&44			;; PI
defb "E","N"+&80,&bb		;; PEN 
defb "EE","K"+&80,&12		;; PEEK
defb "APE","R"+&80,&ba		;; PAPER
defb 0

e56e:
defb "U","T"+&80,&b9		;; OUT
defb "RIGI","N"+&80,&b8		;; ORIGIN
defb "R"+&80,&fc			;; OR
defb "PENOU","T"+&80,&b7	;; OPENOUT
defb "PENI","N"+&80,&b6		;; OPENIN
defb "N S","Q"+&80,&b5		;; ON SQ
defb "N ERROR GO",&09,"TO ","0"+&80,&b4		;; ON ERROR GOTO, ON ERROR GO TO
defb "N BREA","K"+&80,&b3		;; ON BREAK
defb "N"+&80,&b2			;; ON
defb 0

e5a6:
defb "O","T"+&80,&fe		;; NOT
defb "E","W"+&80,&b1		;; NEW
defb "EX","T"+&80,&b0		;; NEXT
defb 0

e5b1:
defb "OVE","R"+&80,&af		;; MOVER
defb "OV","E"+&80,&ae		;; MOVE
defb "OD","E"+&80,&ad		;; MODE
defb "O","D"+&80,&fb		;; MOD
defb "I","N"+&80,&77		;; MIN
defb "ID","$"+&80,&ac		;; MID$
defb "ERG","E"+&80,&ab		;; MERGE
defb "EMOR","Y"+&80,&aa		;; MEMORY
defb "A","X"+&80,&76		;; MAX
defb "AS","K"+&80,&df		;; MASK
defb 0

e5db:
defb "OWER","$"+&80,&11		;; LOWER$
defb "OG1","0"+&80,&10		;; LOG10
defb "O","G"+&80,&0f		;; LOG
defb "OCAT","E"+&80,&a9		;; LOCATE
defb "OA","D"+&80,&a8		;; LOAD
defb "IS","T"+&80,&a7		;; LIST
defb "IN","E"+&80,&a6		;; LINE
defb "E","T"+&80,&a5		;; LET
defb "E","N"+&80,&0e		;; LEN 
defb "EFT","$"+&80,&75		;; LEFT$
defb 0

e607:
defb "E","Y"+&80,&a4		;; KEY
defb 0

e60b:
defb "O","Y"+&80,&0d		;; JOY
defb 0

e60f:
defb "N","T"+&80,&0c		;; INT
defb "NST","R"+&80,&74		;; INSTR
defb "NPU","T"+&80,&a3		;; INPUT
defb "N","P"+&80,&0b		;; INP
defb "NKEY","$"+&80,&43		;; INKEY$
defb "NKE","Y"+&80,&0a		;; INKEY
defb "N","K"+&80,&a2		;; INK
defb "F"+&80,&a1			;; IF
defb 0

e630:
defb "IME","M"+&80,&42		;; HIMEM
defb "EX","$"+&80,&73		;; HEX$
defb 0

e63a:
defb "RAPHIC","S"+&80,&de	;; GRAPHICS
defb "O",&09,"T","O"+&80,&a0	;;GO TO, GOTO
defb "O",&09,"SU","B"+&80,&9f	;;GO SUB, GOSUB
defb 0

e64e:
defb "R","E"+&80,&09		;; FRE
defb "RAM","E"+&80,&e0		;; FRAME
defb "O","R"+&80,&9e		;; FOR
defb "N"+&80,&e4			;; FN
defb "I","X"+&80,&08		;; FIX
defb "IL","L"+&80,&dd		;; FILL
defb 0

e663:
defb "X","P"+&80,&07		;; EXP
defb "VER","Y"+&80,&9d		;; EVERY
defb "RRO","R"+&80,&9c		;; ERROR
defb "R","R"+&80,&41		;; ERR
defb "R","L"+&80,&e3		;; ERL
defb "RAS","E"+&80,&9b		;; ERASE
defb "O","F"+&80,&40		;; EOF
defb "N","V"+&80,&9a		;; ENV
defb "N","T"+&80,&99		;; ENT
defb "N","D"+&80,&98		;; END
defb "LS","E"+&80,&97		;; ELSE
defb "I"+&80,&dc			;; EI
defb "DI","T"+&80,&96		;; EDIT
defb 0

e692:
defb "RAW","R"+&80,&95		;; DRAWR
defb "RA","W"+&80,&94		;; DRAW
defb "I","M"+&80,&93		;; DIM
defb "I"+&80,&db			;; DI
defb "ER","R"+&80,&49		;; DERR
defb "ELET","E"+&80,&92		;; DELETE
defb "E","G"+&80,&91		;; DEG
defb "EFST","R"+&80,&90		;; DEFSTR
defb "EFREA","L"+&80,&8f	;; DEFREAL
defb "EFIN","T"+&80,&8e		;; DEFINT
defb "E","F"+&80,&8d		;; DEF
defb "EC","$"+&80,&72		;; DEC$
defb "AT","A"+&80,&8c		;; DATA
defb 0

e6cc:
defb "URSO","R"+&80,&e1		;; CURSOR
defb "REA","L"+&80,&06		;; CREAL
defb "O","S"+&80,&05		;; COS
defb "OPYCHR","$"+&80,&7e	;; COPYCHR$
defb "ON","T"+&80,&8b		;; CONT
defb "L","S"+&80,&8a		;; CLS
defb "LOSEOU","T"+&80,&89	;; CLOSEOUT
defb "LOSEI","N"+&80,&88	;; CLOSEIN
defb "L","G"+&80,&87		;; CLG
defb "LEA","R"+&80,&86		;; CLEAR
defb "IN","T"+&80,&04		;; CINT
defb "HR","$"+&80,&03		;; CHR$
defb "HAI","N"+&80,&85		;; CHAIN
defb "A","T"+&80,&84		;; CAT
defb "AL","L"+&80,&83		;; CALL
defb 0

e715:
defb "ORDE","R"+&80,&82		;; BORDER
defb "IN","$"+&80,&71		;; BIN$
defb 0

e720:
defb "UT","O"+&80,&81		;; AUTO
defb "T","N"+&80,&02		;; ATN
defb "S","C"+&80,&01		;; ASC
defb "N","D"+&80,&fa		;; AND
defb "FTE","R"+&80,&80		;; AFTER
defb "B","S"+&80,&00		;; ABS
defb 0

e735:
defb 0

e736:
defb "^"+&80,&f8		;;
defb "\"+&80,&f9		;;
defb ">",&09"="+&80,&f0		;;
defb "= ",">"+&80,&f0		;;
defb ">"+&80,&ee		;;
defb "<",&09">"+&80,&f2		;;
defb "<",&09"="+&80,&f3		;;
defb "= ","<"+&80,&f3		;;
defb "="+&80,&ef		;;
defb "<"+&80,&f1		;;
defb "/"+&80,&f7		;;
defb ":"+&80,&01		;;
defb "*"+&80,&f6		;;
defb "-"+&80,&f5		;;
defb "+"+&80,&f4		;;
defb "'"+&80,&c0		;;
defb 0


e761 af        xor     a
e762 2a64ae    ld      hl,($ae64)
e765 77        ld      (hl),a
e766 23        inc     hl
e767 77        ld      (hl),a
e768 23        inc     hl
e769 77        ld      (hl),a
e76a 23        inc     hl
e76b 2266ae    ld      ($ae66),hl
e76e 1811      jr      $e781            ; (+$11)


e770 3a21ae    ld      a,($ae21)
e773 b7        or      a
e774 c8        ret     z

e775 c5        push    bc
e776 d5        push    de
e777 e5        push    hl
e778 0186e7    ld      bc,$e786       ; convert line address to line number
e77b cdb9e9    call    $e9b9
e77e e1        pop     hl
e77f d1        pop     de
e780 c1        pop     bc
e781 af        xor     a
e782 3221ae    ld      ($ae21),a
e785 c9        ret     

;;-----------------------------------------------------------------------
;; convert line address to line number

e786 cdfde9    call    $e9fd
e789 fe02      cp      $02
e78b d8        ret     c

e78c fe1d      cp      $1d          ; 16-bit line address pointer
e78e 20f6      jr      nz,$e786        

e790 56        ld      d,(hl)       ; get address
e791 2b        dec     hl
e792 5e        ld      e,(hl)
e793 2b        dec     hl
e794 e5        push    hl
e795 eb        ex      de,hl
e796 23        inc     hl
e797 23        inc     hl
e798 23        inc     hl
e799 5e        ld      e,(hl)       ; line number
e79a 23        inc     hl
e79b 56        ld      d,(hl)
e79c e1        pop     hl
e79d 361e      ld      (hl),$1e     ; 16-bit line number
e79f 23        inc     hl
e7a0 73        ld      (hl),e
e7a1 23        inc     hl
e7a2 72        ld      (hl),d
e7a3 18e1      jr      $e786

;;-----------------------------------------------------------------
e7a5 7e        ld      a,(hl)
e7a6 fe20      cp      $20
e7a8 2001      jr      nz,$e7ab         ; (+$01)
e7aa 23        inc     hl
e7ab cd70e7    call    $e770        ; line address to line number
e7ae cda4df    call    $dfa4
e7b1 e5        push    hl
e7b2 cd4dde    call    $de4d ; skip space, lf or tab
e7b5 b7        or      a
e7b6 2828      jr      z,$e7e0          ; (+$28)
e7b8 c5        push    bc
e7b9 d5        push    de
e7ba 210400    ld      hl,$0004
e7bd 09        add     hl,bc
e7be e5        push    hl
e7bf e5        push    hl
e7c0 cd64e8    call    $e864
e7c3 e5        push    hl
e7c4 dce4e7    call    c,$e7e4
e7c7 d1        pop     de
e7c8 c1        pop     bc
e7c9 cdb8f6    call    $f6b8
e7cc cd07f6    call    $f607
e7cf eb        ex      de,hl
e7d0 d1        pop     de
e7d1 73        ld      (hl),e
e7d2 23        inc     hl
e7d3 72        ld      (hl),d
e7d4 23        inc     hl
e7d5 d1        pop     de
e7d6 73        ld      (hl),e
e7d7 23        inc     hl
e7d8 72        ld      (hl),d
e7d9 23        inc     hl
e7da c1        pop     bc
e7db eb        ex      de,hl
e7dc e1        pop     hl
e7dd edb0      ldir    
e7df c9        ret     

e7e0 e1        pop     hl
e7e1 cd5ce8    call    $e85c
e7e4 78        ld      a,b
e7e5 b1        or      c
e7e6 c8        ret     z

e7e7 eb        ex      de,hl
e7e8 cde5f6    call    $f6e5
e7eb c307f6    jp      $f607

;;========================================================================
;; DELETE

e7ee cd00e8    call    $e800
e7f1 cd37de    call    $de37
e7f4 cd4dfb    call    $fb4d
e7f7 cd1ae8    call    $e81a
e7fa cd8fc1    call    $c18f
e7fd c358c0    jp      $c058
e800 cd0fcf    call    $cf0f
e803 e5        push    hl
e804 c5        push    bc
e805 cd82e8    call    $e882
e808 d1        pop     de
e809 e5        push    hl
e80a cd64e8    call    $e864
e80d 2222ae    ld      ($ae22),hl
e810 eb        ex      de,hl
e811 e1        pop     hl
e812 b7        or      a
e813 ed52      sbc     hl,de
e815 2224ae    ld      ($ae24),hl
e818 e1        pop     hl
e819 c9        ret     

e81a cd70e7    call    $e770        ; line address to line number
e81d ed4b24ae  ld      bc,($ae24)
e821 2a22ae    ld      hl,($ae22)
e824 c3e4e7    jp      $e7e4
e827 23        inc     hl
e828 5e        ld      e,(hl)
e829 23        inc     hl
e82a 56        ld      d,(hl)
e82b fe1d      cp      $1d            ; 16-bit line address pointer
e82d 282a      jr      z,$e859          ; (+$2a)
e82f fe1e      cp      $1e            ; 16-bit line number
e831 c249cb    jp      nz,$cb49			; Error: Syntax Error
e834 e5        push    hl
e835 cdb5de    call    $deb5
e838 dcd8ff    call    c,$ffd8 ; HL=DE?
e83b 300a      jr      nc,$e847         ; (+$0a)
e83d e1        pop     hl
e83e e5        push    hl
e83f 23        inc     hl
e840 cdade9    call    $e9ad			;; ELSE
e843 23        inc     hl
e844 cd68e8    call    $e868
e847 d45ce8    call    nc,$e85c
e84a 2b        dec     hl
e84b eb        ex      de,hl
e84c e1        pop     hl
e84d 2b        dec     hl
e84e 2b        dec     hl
e84f 3e1d      ld      a,$1d        ; 16-bit line address pointer
e851 3221ae    ld      ($ae21),a
e854 77        ld      (hl),a
e855 23        inc     hl
e856 73        ld      (hl),e
e857 23        inc     hl
e858 72        ld      (hl),d
e859 c32cde    jp      $de2c			; get next token skipping space
e85c cd64e8    call    $e864
e85f d8        ret     c

e860 cd45cb    call    $cb45
e863 08        ex      af,af'

;; find address of line
e864 2a64ae    ld      hl,($ae64)
e867 23        inc     hl
e868 4e        ld      c,(hl)
e869 23        inc     hl
e86a 46        ld      b,(hl)
e86b 2b        dec     hl
e86c 78        ld      a,b
e86d b1        or      c
e86e c8        ret     z

e86f e5        push    hl
e870 23        inc     hl
e871 23        inc     hl
e872 7e        ld      a,(hl)
e873 23        inc     hl
e874 66        ld      h,(hl)
e875 6f        ld      l,a
e876 eb        ex      de,hl
e877 cdd8ff    call    $ffd8 ; HL=DE?
e87a eb        ex      de,hl
e87b e1        pop     hl
e87c 3f        ccf     
e87d d0        ret     nc

e87e c8        ret     z

e87f 09        add     hl,bc
e880 18e6      jr      $e868            ; (-$1a)
e882 2a64ae    ld      hl,($ae64)
e885 23        inc     hl
e886 e5        push    hl
e887 4e        ld      c,(hl)
e888 23        inc     hl
e889 46        ld      b,(hl)
e88a 23        inc     hl
e88b 78        ld      a,b
e88c b1        or      c
e88d 37        scf     
e88e 2809      jr      z,$e899          ; (+$09)
e890 7e        ld      a,(hl)
e891 23        inc     hl
e892 66        ld      h,(hl)
e893 6f        ld      l,a
e894 eb        ex      de,hl
e895 cdd8ff    call    $ffd8 ; HL=DE?
e898 eb        ex      de,hl
e899 e1        pop     hl
e89a d8        ret     c

e89b 09        add     hl,bc
e89c 18e8      jr      $e886            ; (-$18)

;;========================================================================
;; RENUM

e89e 110a00    ld      de,$000a
e8a1 c41ae9    call    nz,$e91a
e8a4 d5        push    de
e8a5 110000    ld      de,$0000
e8a8 cd41de    call    $de41
e8ab dc1ae9    call    c,$e91a
e8ae d5        push    de
e8af 110a00    ld      de,$000a
e8b2 cd41de    call    $de41
e8b5 dc48cf    call    c,$cf48
e8b8 cd37de    call    $de37
e8bb e1        pop     hl
e8bc eb        ex      de,hl
e8bd e3        ex      (sp),hl
e8be eb        ex      de,hl
e8bf d5        push    de
e8c0 e5        push    hl
e8c1 cd64e8    call    $e864          ; find address of line
e8c4 d1        pop     de
e8c5 e5        push    hl
e8c6 cd64e8    call    $e864          ; find address of line
e8c9 eb        ex      de,hl
e8ca e1        pop     hl
e8cb cdd8ff    call    $ffd8 ; HL=DE?
e8ce 381d      jr      c,$e8ed          ; (+$1d)
e8d0 eb        ex      de,hl
e8d1 d1        pop     de
e8d2 c1        pop     bc
e8d3 d5        push    de
e8d4 e5        push    hl
e8d5 c5        push    bc
e8d6 4e        ld      c,(hl)
e8d7 23        inc     hl
e8d8 46        ld      b,(hl)
e8d9 78        ld      a,b
e8da b1        or      c
e8db 2813      jr      z,$e8f0          ; (+$13)
e8dd 2b        dec     hl
e8de 09        add     hl,bc
e8df 7e        ld      a,(hl)
e8e0 23        inc     hl
e8e1 b6        or      (hl)
e8e2 280c      jr      z,$e8f0          ; (+$0c)
e8e4 2b        dec     hl
e8e5 c1        pop     bc
e8e6 e5        push    hl
e8e7 eb        ex      de,hl
e8e8 09        add     hl,bc
e8e9 eb        ex      de,hl
e8ea e1        pop     hl
e8eb 30e8      jr      nc,$e8d5         ; (-$18)
e8ed c34dcb    jp      $cb4d			; Error: Improper Argument
e8f0 0120e9    ld      bc,$e920     ; line number to line address
e8f3 cdb9e9    call    $e9b9
e8f6 c1        pop     bc
e8f7 e1        pop     hl
e8f8 d1        pop     de
e8f9 c5        push    bc
e8fa e5        push    hl
e8fb 4e        ld      c,(hl)
e8fc 23        inc     hl
e8fd 46        ld      b,(hl)
e8fe 23        inc     hl
e8ff 78        ld      a,b
e900 b1        or      c
e901 280c      jr      z,$e90f          ; (+$0c)
e903 73        ld      (hl),e
e904 23        inc     hl
e905 72        ld      (hl),d
e906 23        inc     hl
e907 e1        pop     hl
e908 09        add     hl,bc
e909 c1        pop     bc
e90a eb        ex      de,hl
e90b 09        add     hl,bc
e90c eb        ex      de,hl
e90d 18ea      jr      $e8f9            ; (-$16)
e90f e1        pop     hl
e910 e1        pop     hl
e911 0144e9    ld      bc,$e944
e914 cdb9e9    call    $e9b9
e917 c358c0    jp      $c058
e91a fe2c      cp      $2c
e91c c448cf    call    nz,$cf48
e91f c9        ret     

;;----------------------------------------------------------

e920 cdfde9    call    $e9fd
e923 fe02      cp      $02
e925 d8        ret     c

;; convert line number to line address

e926 fe1e      cp      $1e            ; 16-bit line number
e928 20f6      jr      nz,$e920

;; 16-bit line number
e92a e5        push    hl
e92b 56        ld      d,(hl)
e92c 2b        dec     hl
e92d 5e        ld      e,(hl)
e92e cd64e8    call    $e864          ; find address of line
e931 300e      jr      nc,$e941         
e933 2b        dec     hl
e934 eb        ex      de,hl
e935 e1        pop     hl
e936 e5        push    hl

;; store 16-bit line address in reverse order
e937 72        ld      (hl),d
e938 2b        dec     hl
e939 73        ld      (hl),e
e93a 2b        dec     hl
;; store 16-bit line address marker
e93b 3e1d      ld      a,$1d          ; 16 bit line address pointer
e93d 77        ld      (hl),a

e93e 3221ae    ld      ($ae21),a

e941 e1        pop     hl
e942 18dc      jr      $e920            

;;-------------------------------------------------------
e944 cdfde9    call    $e9fd
e947 fe02      cp      $02
e949 d8        ret     c

;; 16-bit line number?
e94a fe1e      cp      $1e
e94c 20f6      jr      nz,$e944         ; (-$0a)

e94e e5        push    hl
e94f 56        ld      d,(hl)
e950 2b        dec     hl
e951 5e        ld      e,(hl)
e952 cdb5de    call    $deb5
e955 cde6cb    call    $cbe6
e958 e1        pop     hl
e959 18e9      jr      $e944            ; (-$17)


e95b 0600      ld      b,$00
e95d 2b        dec     hl
e95e 04        inc     b
e95f cdfde9    call    $e9fd
e962 fea1      cp      $a1
e964 28f8      jr      z,$e95e          ; (-$08)
e966 fe02      cp      $02
e968 30f5      jr      nc,$e95f         ; (-$0b)
e96a b7        or      a
e96b c8        ret     z

e96c cdfde9    call    $e9fd
e96f fe97      cp      $97
e971 20ef      jr      nz,$e962         ; (-$11)
e973 10ea      djnz    $e95f            ; (-$16)
e975 cd2cde    call    $de2c			; get next token skipping space
e978 04        inc     b
e979 c9        ret     

e97a 7e        ld      a,(hl)
e97b fe5b      cp      $5b
e97d 2803      jr      z,$e982          ; (+$03)
e97f fe28      cp      $28
e981 c0        ret     nz

e982 0600      ld      b,$00
e984 04        inc     b
e985 cdfde9    call    $e9fd
e988 fe5b      cp      $5b
e98a 28f8      jr      z,$e984          ; (-$08)
e98c fe28      cp      $28
e98e 28f4      jr      z,$e984          ; (-$0c)
e990 fe5d      cp      $5d
e992 280b      jr      z,$e99f          ; (+$0b)
e994 fe29      cp      $29
e996 2807      jr      z,$e99f          ; (+$07)
e998 fe02      cp      $02
e99a 30e9      jr      nc,$e985         ; (-$17)
e99c c349cb    jp      $cb49			; Error: Syntax Error
e99f 10e4      djnz    $e985            ; (-$1c)
e9a1 23        inc     hl
e9a2 c9        ret     

;;=============================================================================
;; DATA
e9a3 0601      ld      b,$01
e9a5 1808      jr      $e9af            ; (+$08)

;;========================================================================
;; ' or REM
e9a7 7e        ld      a,(hl)
e9a8 b7        or      a
e9a9 c8        ret     z
e9aa 23        inc     hl
e9ab 18fa      jr      $e9a7            ; (-$06)
;;========================================================================
;; ELSE

e9ad 0600      ld      b,$00
e9af 2b        dec     hl
e9b0 cdfde9    call    $e9fd
e9b3 b7        or      a
e9b4 c8        ret     z

e9b5 b8        cp      b
e9b6 20f8      jr      nz,$e9b0         ; (-$08)
e9b8 c9        ret     

e9b9 cdb1de    call    $deb1
e9bc e5        push    hl
e9bd 2a64ae    ld      hl,($ae64)
e9c0 23        inc     hl
e9c1 7e        ld      a,(hl)
e9c2 23        inc     hl
e9c3 b6        or      (hl)
e9c4 2813      jr      z,$e9d9          ; (+$13)
e9c6 23        inc     hl
e9c7 cdadde    call    $dead
e9ca 23        inc     hl
e9cb c5        push    bc
e9cc cdfcff    call    $fffc			; JP (BC)
e9cf c1        pop     bc
e9d0 2b        dec     hl
e9d1 cdefe9    call    $e9ef
e9d4 b7        or      a
e9d5 20f4      jr      nz,$e9cb         ; (-$0c)
e9d7 18e7      jr      $e9c0            ; (-$19)
e9d9 e1        pop     hl
e9da c3adde    jp      $dead
e9dd cdefe9    call    $e9ef
e9e0 b7        or      a
e9e1 c0        ret     nz

e9e2 23        inc     hl
e9e3 7e        ld      a,(hl)
e9e4 23        inc     hl
e9e5 b6        or      (hl)
e9e6 79        ld      a,c
e9e7 ca55cb    jp      z,$cb55
e9ea 23        inc     hl
e9eb 54        ld      d,h
e9ec 5d        ld      e,l
e9ed 23        inc     hl
e9ee c9        ret     

e9ef cdfde9    call    $e9fd
e9f2 fe02      cp      $02
e9f4 d8        ret     c

e9f5 fe97      cp      $97
e9f7 c8        ret     z

e9f8 feeb      cp      $eb
e9fa 20f3      jr      nz,$e9ef         ; (-$0d)
e9fc c9        ret     

e9fd cd2cde    call    $de2c			; get next token skipping space
ea00 c8        ret     z

ea01 fe0e      cp      $0e
ea03 3825      jr      c,$ea2a          ; (+$25)
ea05 fe20      cp      $20				; space
ea07 382b      jr      c,$ea34          ; 
ea09 fe22      cp      $22				; double quote
ea0b 2811      jr      z,$ea1e          ; 
ea0d fe7c      cp      $7c
ea0f 281b      jr      z,$ea2c          ; (+$1b)
ea11 fec0      cp      $c0
ea13 2830      jr      z,$ea45          ; (+$30)
ea15 fec5      cp      $c5
ea17 282c      jr      z,$ea45          ; (+$2c)
ea19 feff      cp      $ff
ea1b c0        ret     nz

ea1c 23        inc     hl
ea1d c9        ret     

;;----------------------------------------------
;; find last quote

ea1e 23        inc     hl
ea1f 7e        ld      a,(hl)
ea20 fe22      cp      $22
ea22 c8        ret     z
ea23 b7        or      a
ea24 20f8      jr      nz,$ea1e         ; (-$08)

ea26 2b        dec     hl
ea27 3e22      ld      a,$22
ea29 c9        ret     

;;----------------------------------------------

ea2a 23        inc     hl
ea2b 23        inc     hl
ea2c f5        push    af
ea2d 23        inc     hl
ea2e 7e        ld      a,(hl)
ea2f 17        rla     
ea30 30fb      jr      nc,$ea2d         ; (-$05)
ea32 f1        pop     af
ea33 c9        ret     

;;--------------------------------------------------

ea34 fe18      cp      $18
ea36 d8        ret     c

ea37 fe19      cp      $19				; 8-bit integer decimal value
ea39 2808      jr      z,$ea43          
ea3b fe1f      cp      $1f				; floating point value
ea3d 3803      jr      c,$ea42          

;; skip 5 bytes (length of floating point value representation)
ea3f 23        inc     hl
ea40 23        inc     hl
ea41 23        inc     hl

;;--------------------------------
;; skip 2 bytes (length of 16-bit values)
;; - 16 bit integer decimal value
;; - 16 bit integer binary value
;; - 16 bit integer hexidecimal value
ea42 23        inc     hl
;;--------------------------------
;; skip 1 byte (length of 8-bit values)
ea43 23        inc     hl
ea44 c9        ret     
;;--------------------------------

ea45 f5        push    af
ea46 23        inc     hl
ea47 cda7e9    call    $e9a7			; ' or REM
ea4a f1        pop     af
ea4b 2b        dec     hl
ea4c c9        ret     

ea4d c5        push    bc
ea4e d5        push    de
ea4f e5        push    hl
ea50 015aea    ld      bc,$ea5a
ea53 cdb9e9    call    $e9b9
ea56 e1        pop     hl
ea57 d1        pop     de
ea58 c1        pop     bc
ea59 c9        ret     

ea5a e5        push    hl
ea5b cdfde9    call    $e9fd
ea5e d1        pop     de
ea5f fe02      cp      $02
ea61 d8        ret     c

ea62 fe0e      cp      $0e
ea64 30f4      jr      nc,$ea5a         ; (-$0c)
ea66 eb        ex      de,hl
ea67 cd2cde    call    $de2c			; get next token skipping space
ea6a fe0d      cp      $0d
ea6c 3802      jr      c,$ea70          ; (+$02)
ea6e 360d      ld      (hl),$0d
ea70 23        inc     hl
ea71 af        xor     a
ea72 77        ld      (hl),a
ea73 23        inc     hl
ea74 77        ld      (hl),a
ea75 eb        ex      de,hl
ea76 18e2      jr      $ea5a            ; (-$1e)

;;==========================================================================
;; RUN

ea78 cd3dde    call    $de3d
ea7b ed5b64ae  ld      de,($ae64)
ea7f 381d      jr      c,$ea9e          ; (+$1d)
ea81 fe1e      cp      $1e            ; 16-bit line number
ea83 2815      jr      z,$ea9a          ; (+$15)
ea85 fe1d      cp      $1d
ea87 2811      jr      z,$ea9a          ; (+$11)
ea89 cdd1ea    call    $ead1
ea8c 21f1ea    ld      hl,$eaf1
ea8f d213bd    jp      nc,$bd13			; firmware function: mc boot program

ea92 cd6dec    call    $ec6d
ea95 2a64ae    ld      hl,($ae64)
ea98 1812      jr      $eaac            ; (+$12)


ea9a cd27e8    call    $e827
ea9d c0        ret     nz
ea9e d5        push    de
ea9f cd00d3    call    $d300			; close input and output streams
eaa2 cd78c1    call    $c178
eaa5 cd8fc1    call    $c18f
eaa8 cd62c1    call    $c162
eaab e1        pop     hl
eaac e3        ex      (sp),hl
eaad cd43bd    call    $bd43
eab0 e1        pop     hl
eab1 23        inc     hl
eab2 c377de    jp      $de77

;;========================================================================
;; LOAD

eab5 cdd1ea    call    $ead1
eab8 3006      jr      nc,$eac0         ; (+$06)
eaba cd6dec    call    $ec6d
eabd c358c0    jp      $c058
eac0 e5        push    hl
eac1 cdabf5    call    $f5ab
eac4 2a26ae    ld      hl,($ae26)
eac7 cd83bc    call    $bc83			; firmware function: cas in direct
eaca ca37cc    jp      z,$cc37
eacd e1        pop     hl
eace c3edd2    jp      $d2ed			; CLOSEIN

ead1 cd54ec    call    $ec54
ead4 e60e      and     $0e
ead6 ee02      xor     $02
ead8 2808      jr      z,$eae2          ; (+$08)
eada cd37de    call    $de37
eadd cd6fc1    call    $c16f
eae0 37        scf     
eae1 c9        ret     

eae2 cd41de    call    $de41
eae5 dcf5ce    call    c,$cef5
eae8 ed5326ae  ld      ($ae26),de
eaec cd37de    call    $de37
eaef b7        or      a
eaf0 c9        ret     

;;==========================================================================
;; RUN a program

eaf1 2a26ae    ld      hl,($ae26)		; load address
eaf4 cd83bc    call    $bc83			; firmware function: cas in direct
eaf7 e5        push    hl				; execution address
eaf8 dc7abc    call    c,$bc7a			; firmware function: cas in close
eafb e1        pop     hl				; execution address passed into firmare function "mc boot program"
eafc c9        ret     
;;==========================================================================
;; CHAIN
eafd eeab      xor     $ab
eaff 3228ae    ld      ($ae28),a
eb02 cc2cde    call    z,$de2c			; get next token skipping space
eb05 cd54ec    call    $ec54
eb08 110000    ld      de,$0000
eb0b cd41de    call    $de41
eb0e 3006      jr      nc,$eb16         ; (+$06)
eb10 7e        ld      a,(hl)
eb11 fe2c      cp      $2c
eb13 c4f5ce    call    nz,$cef5
eb16 d5        push    de
eb17 cd41de    call    $de41
eb1a 3008      jr      nc,$eb24         ; (+$08)
eb1c cd25de    call    $de25
defb &92
eb20 cd00e8    call    $e800
eb23 37        scf     
eb24 f5        push    af
eb25 cd37de    call    $de37
eb28 cd4dfb    call    $fb4d
eb2b cd64fc    call    $fc64
eb2e cd0ed6    call    $d60e
eb31 f1        pop     af
eb32 dc1ae8    call    c,$e81a
eb35 cd47eb    call    $eb47
eb38 d1        pop     de
eb39 2a64ae    ld      hl,($ae64)
eb3c 7a        ld      a,d
eb3d b3        or      e
eb3e c8        ret     z

eb3f cdaade    call    $deaa
eb42 cd5ce8    call    $e85c
eb45 2b        dec     hl
eb46 c9        ret     

eb47 3a28ae    ld      a,($ae28)
eb4a b7        or      a
eb4b ca62ec    jp      z,$ec62
eb4e cd89c1    call    $c189
eb51 c36dec    jp      $ec6d

;;========================================================================
;; MERGE

eb54 cd54ec    call    $ec54
eb57 cd37de    call    $de37
eb5a cd78c1    call    $c178
eb5d cd62ec    call    $ec62
eb60 c358c0    jp      $c058

;;========================================================================

eb63 cd8fc1    call    $c18f
eb66 cd70e7    call    $e770        ; line address to line number
eb69 cd29f6    call    $f629
eb6c 2a66ae    ld      hl,($ae66)
eb6f eb        ex      de,hl
eb70 2a64ae    ld      hl,($ae64)
eb73 23        inc     hl
eb74 2266ae    ld      ($ae66),hl
eb77 eb        ex      de,hl
eb78 cde4ff    call    $ffe4			; BC = HL-DE
eb7b eb        ex      de,hl
eb7c cd07f7    call    $f707
eb7f eb        ex      de,hl
eb80 2b        dec     hl
eb81 edb8      lddr    
eb83 13        inc     de
eb84 eb        ex      de,hl
eb85 cd4bec    call    $ec4b
eb88 304a      jr      nc,$ebd4         ; (+$4a)
eb8a b3        or      e
eb8b 284c      jr      z,$ebd9          ; (+$4c)
eb8d d5        push    de
eb8e cd4bec    call    $ec4b
eb91 3041      jr      nc,$ebd4         ; (+$41)
eb93 7e        ld      a,(hl)
eb94 23        inc     hl
eb95 b6        or      (hl)
eb96 2b        dec     hl
eb97 281b      jr      z,$ebb4          ; (+$1b)
eb99 e5        push    hl
eb9a 23        inc     hl
eb9b 23        inc     hl
eb9c 7e        ld      a,(hl)
eb9d 23        inc     hl
eb9e 66        ld      h,(hl)
eb9f 6f        ld      l,a
eba0 cdd8ff    call    $ffd8 ; HL=DE?
eba3 e1        pop     hl
eba4 2807      jr      z,$ebad          ; (+$07)
eba6 300c      jr      nc,$ebb4         ; (+$0c)
eba8 cd19ec    call    $ec19
ebab 18e6      jr      $eb93            ; (-$1a)
ebad d5        push    de
ebae 5e        ld      e,(hl)
ebaf 23        inc     hl
ebb0 56        ld      d,(hl)
ebb1 2b        dec     hl
ebb2 19        add     hl,de
ebb3 d1        pop     de
ebb4 e5        push    hl
ebb5 2a66ae    ld      hl,($ae66)
ebb8 23        inc     hl
ebb9 23        inc     hl
ebba 73        ld      (hl),e
ebbb 23        inc     hl
ebbc 72        ld      (hl),d
ebbd 111d00    ld      de,$001d
ebc0 19        add     hl,de
ebc1 eb        ex      de,hl
ebc2 e1        pop     hl
ebc3 e3        ex      (sp),hl
ebc4 eb        ex      de,hl
ebc5 19        add     hl,de
ebc6 eb        ex      de,hl
ebc7 e3        ex      (sp),hl
ebc8 cdd8ff    call    $ffd8 ; HL=DE?
ebcb 3825      jr      c,$ebf2          ; (+$25)
ebcd e3        ex      (sp),hl
ebce cd2cec    call    $ec2c
ebd1 e1        pop     hl
ebd2 38b1      jr      c,$eb85          ; (-$4f)
ebd4 cdd9eb    call    $ebd9
ebd7 1836      jr      $ec0f            ; (+$36)
ebd9 7e        ld      a,(hl)
ebda 23        inc     hl
ebdb b6        or      (hl)
ebdc 2b        dec     hl
ebdd 2805      jr      z,$ebe4          ; (+$05)
ebdf cd19ec    call    $ec19
ebe2 18f5      jr      $ebd9            ; (-$0b)
ebe4 2a66ae    ld      hl,($ae66)
ebe7 af        xor     a
ebe8 77        ld      (hl),a
ebe9 23        inc     hl
ebea 77        ld      (hl),a
ebeb 23        inc     hl
ebec 2266ae    ld      ($ae66),hl
ebef c3b0ec    jp      $ecb0
ebf2 cdd9eb    call    $ebd9
ebf5 cdaade    call    $deaa
ebf8 3e07      ld      a,$07
ebfa 1815      jr      $ec11            ; (+$15)

ebfc cd80bc    call    $bc80			; firmware function: cas in char
ebff d8        ret     c

ec00 fe1a      cp      $1a
ec02 37        scf     
ec03 c8        ret     z

ec04 3291ad    ld      ($ad91),a
ec07 3f        ccf     
ec08 c9        ret     

ec09 3291ad    ld      ($ad91),a
ec0c cd6fc1    call    $c16f
ec0f 3e18      ld      a,$18
ec11 f5        push    af
ec12 cd00d3    call    $d300					; close input and output streams
ec15 f1        pop     af
ec16 c355cb    jp      $cb55
ec19 c5        push    bc
ec1a d5        push    de
ec1b 4e        ld      c,(hl)
ec1c 23        inc     hl
ec1d 46        ld      b,(hl)
ec1e 2b        dec     hl
ec1f ed5b66ae  ld      de,($ae66)
ec23 edb0      ldir    
ec25 ed5366ae  ld      ($ae66),de
ec29 d1        pop     de
ec2a c1        pop     bc
ec2b c9        ret     

ec2c eb        ex      de,hl
ec2d 2a66ae    ld      hl,($ae66)
ec30 73        ld      (hl),e
ec31 23        inc     hl
ec32 72        ld      (hl),d
ec33 23        inc     hl
ec34 23        inc     hl
ec35 23        inc     hl
ec36 1b        dec     de
ec37 1b        dec     de
ec38 1b        dec     de
ec39 1b        dec     de
ec3a 7a        ld      a,d
ec3b b3        or      e
ec3c 2808      jr      z,$ec46          ; (+$08)
ec3e cdfceb    call    $ebfc
ec41 77        ld      (hl),a
ec42 23        inc     hl
ec43 38f4      jr      c,$ec39          ; (-$0c)
ec45 c9        ret     

ec46 2266ae    ld      ($ae66),hl
ec49 37        scf     
ec4a c9        ret     

ec4b cdfceb    call    $ebfc
ec4e 5f        ld      e,a
ec4f dcfceb    call    c,$ebfc
ec52 57        ld      d,a
ec53 c9        ret     

ec54 cd00d3    call    $d300			; close input and output streams
ec57 cdbed2    call    $d2be
ec5a 3229ae    ld      ($ae29),a
ec5d ed432aae  ld      ($ae2a),bc
ec61 c9        ret     

ec62 3a29ae    ld      a,($ae29)
ec65 b7        or      a
ec66 ca63eb    jp      z,$eb63
ec69 fe16      cp      $16
ec6b 200b      jr      nz,$ec78         ; (+$0b)
ec6d 3a29ae    ld      a,($ae29)
ec70 fe16      cp      $16
ec72 2842      jr      z,$ecb6          ; (+$42)
ec74 e6fe      and     $fe
ec76 2804      jr      z,$ec7c          ; (+$04)
ec78 cd45cb    call    $cb45
ec7b 19        add     hl,de
ec7c cd8fc1    call    $c18f
ec7f cd29f6    call    $f629
ec82 ed4b64ae  ld      bc,($ae64)
ec86 03        inc     bc
ec87 cd07f7    call    $f707
ec8a 1180ff    ld      de,$ff80
ec8d 19        add     hl,de
ec8e b7        or      a
ec8f ed42      sbc     hl,bc
ec91 ed5b2aae  ld      de,($ae2a)
ec95 d4d8ff    call    nc,$ffd8 ; HL=DE?
ec98 daf5eb    jp      c,$ebf5
ec9b eb        ex      de,hl
ec9c 09        add     hl,bc
ec9d 2266ae    ld      ($ae66),hl
eca0 3a29ae    ld      a,($ae29)
eca3 1f        rra     
eca4 9f        sbc     a,a
eca5 322cae    ld      ($ae2c),a
eca8 60        ld      h,b
eca9 69        ld      l,c
ecaa cd83bc    call    $bc83			; firmware function: CAS IN DIRECT
ecad ca09ec    jp      z,$ec09
ecb0 cd3cf6    call    $f63c
ecb3 c3edd2    jp      $d2ed			; CLOSEIN

ecb6 cd8fc1    call    $c18f
ecb9 cdaade    call    $deaa
ecbc cd29f6    call    $f629
ecbf cd0acb    call    $cb0a
ecc2 30ec      jr      nc,$ecb0         ; (-$14)
ecc4 cd4dde    call    $de4d ; skip space, lf or tab
ecc7 b7        or      a
ecc8 c4cdec    call    nz,$eccd
eccb 18f2      jr      $ecbf            ; (-$0e)
eccd cdcfee    call    $eecf
ecd0 daa5e7    jp      c,$e7a5
ecd3 3e15      ld      a,$15
ecd5 2802      jr      z,$ecd9          ; (+$02)
ecd7 3e06      ld      a,$06
ecd9 c355cb    jp      $cb55

;;========================================================================
;; SAVE

ecdc cd00d3    call    $d300			;; close input and output streams
ecdf cda8d2    call    $d2a8			;; OPENOUT
ece2 0600      ld      b,$00
ece4 cd41de    call    $de41
ece7 3025      jr      nc,$ed0e         ; (+$25)
ece9 cd25de    call    $de25			; read string
defb &0d
eced 23        inc     hl
ecee 23        inc     hl
ecef 7e        ld      a,(hl)			; parameter (,A ,B ,P)
ecf0 e6df      and     $df
ecf2 f249cb    jp      p,$cb49			; Error: Syntax Error
ecf5 e5        push    hl
ecf6 2100ed    ld      hl,$ed00
ecf9 cdb4ff    call    $ffb4
ecfc e3        ex      (sp),hl
ecfd c32cde    jp      $de2c			; get next token skipping space

ed00 defb &03
defw &cb49								; Error: Syntax Error

defb &c1					;; ,A
defw &ed53
defb &c2					;; ,B
defw &ed2b
defb &d0					;; ,P
defw &ed0c

;;---------------------------------------------------
;; SAVE ,P
;; Protected BASIC save
ed0c 0601      ld      b,$01
ed0e cd37de	   call    $de37
ed11 e5        push hl
ed12 c5        push    bc
ed13 cd70e7    call    $$e770        ; line address to line number
ed16 cd4dea    call    $ea4d
;; save basic?
ed19 2a64ae    ld      hl,($ae64)
ed1c 23        inc     hl
ed1d eb        ex      de,hl
ed1e 2a66ae    ld      hl,($ae66)
ed21 b7        or      a
ed22 ed52      sbc     hl,de
ed24 eb        ex      de,hl
ed25 f1        pop     af
ed26 010000    ld      bc,$0000
ed29 1820      jr      $ed4b            ; (+$20)

;; SAVE ,B
;; Binary save
ed2b cd15de    call    $de15 ; check for comma			; start
ed2e cdf5ce    call    $cef5
ed31 d5        push    de
ed32 cd15de    call    $de15 ; check for comma			; length
ed35 cdf5ce    call    $cef5
ed38 d5        push    de
ed39 cd41de    call    $de41			; execution
ed3c 110000    ld      de,$0000
ed3f dcf5ce    call    c,$cef5
ed42 d5        push    de
ed43 cd37de    call    $de37
ed46 3e02      ld      a,$02			;; binary
ed48 c1        pop     bc
ed49 d1        pop     de
ed4a e3        ex      (sp),hl
ed4b cd98bc    call    $bc98			;; firmware function: cas out direct
ed4e d237cc    jp      nc,$cc37
ed51 1817      jr      $ed6a            ; (+$17)

;; SAVE ,A
;; ASCII save
ed53 cd37de    call    $de37
ed56 e5        push    hl
ed57 3e09      ld      a,$09
ed59 cda6c1    call    $c1a6
ed5c f5        push    af
ed5d 010100    ld      bc,$0001
ed60 11ffff    ld      de,$ffff
ed63 cde3e1    call    $e1e3		
ed66 f1        pop     af
ed67 cda6c1    call    $c1a6
ed6a cdf5d2    call    $d2f5			; CLOSEOUT
ed6d e1        pop     hl
ed6e c9        ret     

ed6f cd0fee    call    $ee0f
ed72 2005      jr      nz,$ed79         ; (+$05)
ed74 cd4dde    call    $de4d ; skip space, lf or tab
ed77 182f      jr      $eda8            ; (+$2f)
ed79 fe26      cp      $26
ed7b 281c      jr      z,$ed99          ; (+$1c)
ed7d cda0ff    call    $ffa0
ed80 3826      jr      c,$eda8          ; (+$26)
ed82 cd38ff    call    $ff38
ed85 cd1bff    call    $ff1b
ed88 37        scf     
ed89 c9        ret     

ed8a e5        push    hl
ed8b cd92ed    call    $ed92
ed8e d1        pop     de
ed8f d8        ret     c

ed90 eb        ex      de,hl
ed91 c9        ret     

ed92 1600      ld      d,$00
ed94 7e        ld      a,(hl)
ed95 fe26      cp      $26
ed97 200f      jr      nz,$eda8         ; (+$0f)
ed99 cde7ee    call    $eee7
ed9c eb        ex      de,hl
ed9d f5        push    af
ed9e cd35ff    call    $ff35
eda1 f1        pop     af
eda2 eb        ex      de,hl
eda3 d8        ret     c

eda4 c8        ret     z

eda5 c3becb    jp      $cbbe
eda8 e5        push    hl
eda9 7e        ld      a,(hl)
edaa 23        inc     hl
edab fe2e      cp      $2e
edad cc4dde    call    z,$de4d ; skip space, lf or tab
edb0 cda4ff    call    $ffa4			;; test if ASCII character represents a decimal number digit
edb3 e1        pop     hl
edb4 3806      jr      c,$edbc          ; (+$06)
edb6 7e        ld      a,(hl)
edb7 ee2e      xor     $2e
edb9 c0        ret     nz

edba 23        inc     hl
edbb c9        ret     

edbc cd38ff    call    $ff38
edbf d5        push    de
edc0 010000    ld      bc,$0000
edc3 112dae    ld      de,$ae2d
edc6 cd1eee    call    $ee1e
edc9 fe2e      cp      $2e
edcb 200b      jr      nz,$edd8         ; (+$0b)
edcd cd94ee    call    $ee94
edd0 cd41ff    call    $ff41
edd3 0c        inc     c
edd4 cd1eee    call    $ee1e
edd7 0d        dec     c
edd8 eb        ex      de,hl
edd9 36ff      ld      (hl),$ff
eddb eb        ex      de,hl
eddc cd42ee    call    $ee42
eddf d1        pop     de
ede0 5f        ld      e,a
ede1 e5        push    hl
ede2 d5        push    de
ede3 212dae    ld      hl,$ae2d
ede6 cd99ee    call    $ee99
ede9 d1        pop     de
edea cd66ff    call    $ff66
eded 3008      jr      nc,$edf7         ; (+$08)
edef e5        push    hl
edf0 42        ld      b,d
edf1 cd2cfe    call    $fe2c
edf4 e1        pop     hl
edf5 3811      jr      c,$ee08          ; (+$11)
edf7 7a        ld      a,d
edf8 4e        ld      c,(hl)
edf9 23        inc     hl
edfa cdb8bd    call    $bdb8
edfd 7b        ld      a,e
edfe cd79bd    call    $bd79
ee01 eb        ex      de,hl
ee02 cd3eff    call    $ff3e
ee05 dc61bd    call    c,$bd61
ee08 3e0a      ld      a,$0a
ee0a e1        pop     hl
ee0b d8        ret     c

ee0c c3becb    jp      $cbbe
ee0f cd4dde    call    $de4d ; skip space, lf or tab
ee12 23        inc     hl
ee13 16ff      ld      d,$ff
ee15 fe2d      cp      $2d
ee17 c8        ret     z

ee18 14        inc     d
ee19 fe2b      cp      $2b
ee1b c8        ret     z

ee1c 2b        dec     hl
ee1d c9        ret     

ee1e e5        push    hl
ee1f cd4dde    call    $de4d ; skip space, lf or tab
ee22 23        inc     hl
ee23 cda4ff    call    $ffa4			;; test if ASCII character represents a decimal number digit
ee26 3804      jr      c,$ee2c          ; (+$04)
ee28 e1        pop     hl
ee29 c3abff    jp      $ffab			;; convert character to upper case

ee2c e3        ex      (sp),hl
ee2d e1        pop     hl
ee2e d630      sub     $30
ee30 12        ld      (de),a
ee31 b0        or      b
ee32 2807      jr      z,$ee3b          ; (+$07)
ee34 78        ld      a,b
ee35 04        inc     b
ee36 fe0c      cp      $0c
ee38 3001      jr      nc,$ee3b         ; (+$01)
ee3a 13        inc     de
ee3b 79        ld      a,c
ee3c b7        or      a
ee3d 28df      jr      z,$ee1e          ; (-$21)
ee3f 0c        inc     c
ee40 18dc      jr      $ee1e            
ee42 fe45      cp      $45				;; 'E'
ee44 2010      jr      nz,$ee56
         
ee46 e5        push    hl
ee47 cd94ee    call    $ee94
ee4a cd0fee    call    $ee0f
ee4d cc4dde    call    z,$de4d ; skip space, lf or tab
ee50 cda4ff    call    $ffa4			;; test if ASCII character represents a decimal number digit
ee53 3804      jr      c,$ee59          ; (+$04)
ee55 e1        pop     hl

ee56 af        xor     a
ee57 181e      jr      $ee77            ; (+$1e)

ee59 e3        ex      (sp),hl
ee5a e1        pop     hl
ee5b cd41ff    call    $ff41
ee5e d5        push    de
ee5f c5        push    bc
ee60 cd00ef    call    $ef00
ee63 3009      jr      nc,$ee6e         ; (+$09)
ee65 7b        ld      a,e
ee66 d664      sub     $64
ee68 7a        ld      a,d
ee69 de00      sbc     a,$00
ee6b 7b        ld      a,e
ee6c 3802      jr      c,$ee70          ; (+$02)
ee6e 3e7f      ld      a,$7f
ee70 c1        pop     bc
ee71 d1        pop     de
ee72 14        inc     d
ee73 2002      jr      nz,$ee77         ; (+$02)
ee75 2f        cpl     
ee76 3c        inc     a

ee77 c680      add     a,$80
ee79 5f        ld      e,a
ee7a 78        ld      a,b
ee7b d60c      sub     $0c
ee7d 3001      jr      nc,$ee80         ; (+$01)
ee7f af        xor     a
ee80 91        sub     c
ee81 3009      jr      nc,$ee8c         ; (+$09)
ee83 83        add     a,e
ee84 3801      jr      c,$ee87          ; (+$01)
ee86 af        xor     a
ee87 fe01      cp      $01
ee89 ce80      adc     a,$80
ee8b c9        ret     

ee8c 83        add     a,e
ee8d 3002      jr      nc,$ee91         ; (+$02)
ee8f 3eff      ld      a,$ff
ee91 d680      sub     $80
ee93 c9        ret     

ee94 cd4dde    call    $de4d ; skip space, lf or tab
ee97 23        inc     hl
ee98 c9        ret     

ee99 eb        ex      de,hl
ee9a 213fae    ld      hl,$ae3f
ee9d 010105    ld      bc,$0501
eea0 2b        dec     hl
eea1 3600      ld      (hl),$00
eea3 10fb      djnz    $eea0            ; (-$05)
eea5 1a        ld      a,(de)
eea6 feff      cp      $ff
eea8 c8        ret     z

eea9 77        ld      (hl),a
eeaa 213aae    ld      hl,$ae3a
eead 13        inc     de
eeae 1a        ld      a,(de)
eeaf feff      cp      $ff
eeb1 c8        ret     z

eeb2 d5        push    de
eeb3 41        ld      b,c
eeb4 1600      ld      d,$00
eeb6 e5        push    hl
eeb7 5e        ld      e,(hl)
eeb8 62        ld      h,d
eeb9 6b        ld      l,e
eeba 29        add     hl,hl
eebb 29        add     hl,hl
eebc 19        add     hl,de
eebd 29        add     hl,hl
eebe 5f        ld      e,a
eebf 19        add     hl,de
eec0 5d        ld      e,l
eec1 7c        ld      a,h
eec2 e1        pop     hl
eec3 73        ld      (hl),e
eec4 23        inc     hl
eec5 10ef      djnz    $eeb6            ; (-$11)
eec7 d1        pop     de
eec8 b7        or      a
eec9 28df      jr      z,$eeaa          ; (-$21)
eecb 77        ld      (hl),a
eecc 0c        inc     c
eecd 18db      jr      $eeaa            ; (-$25)

;;=======================================================================

eecf c5        push    bc
eed0 e5        push    hl
eed1 cd00ef    call    $ef00
eed4 eb        ex      de,hl
eed5 cd35ff    call    $ff35
eed8 eb        ex      de,hl
eed9 c1        pop     bc
eeda 3006      jr      nc,$eee2         ; (+$06)
eedc 7a        ld      a,d
eedd b3        or      e
eede c6ff      add     a,$ff
eee0 3803      jr      c,$eee5          ; (+$03)
eee2 50        ld      d,b
eee3 59        ld      e,c
eee4 eb        ex      de,hl
eee5 c1        pop     bc
eee6 c9        ret     


;;=======================================================================
eee7 23        inc     hl
eee8 cd4dde    call    $de4d 			; skip space, lf or tab
eeeb cdabff    call    $ffab			;; convert character to upper case

eeee 0602      ld      b,$02			;; base 2
eef0 fe58      cp      $58				;; X
eef2 2806      jr      z,$eefa          

eef4 0610      ld      b,$10			;; base 16
eef6 fe48      cp      $48				;; H
eef8 2004      jr      nz,$eefe          

eefa 23        inc     hl
eefb cd4dde    call    $de4d 			; skip space, lf or tab
eefe 1802      jr      $ef02            ; (+$02)

;;=======================================================================

ef00 060a      ld      b,$0a			;; base 10

;; A = base: 2 for binary, 16 for hexadecimal, 10 for decimal
;; convert number in base defined
ef02 eb        ex      de,hl
ef03 cd2cef    call    $ef2c
ef06 2600      ld      h,$00
ef08 6f        ld      l,a
ef09 301e      jr      nc,$ef29         ; (+$1e)
ef0b 0e00      ld      c,$00
ef0d cd2cef    call    $ef2c
ef10 3014      jr      nc,$ef26         ; (+$14)
ef12 d5        push    de
ef13 1600      ld      d,$00
ef15 5f        ld      e,a
ef16 d5        push    de
ef17 58        ld      e,b
ef18 cd72dd    call    $dd72
ef1b d1        pop     de
ef1c 3803      jr      c,$ef21          ; (+$03)
ef1e 19        add     hl,de
ef1f 3002      jr      nc,$ef23         ; (+$02)
ef21 0eff      ld      c,$ff
ef23 d1        pop     de
ef24 18e7      jr      $ef0d            ; (-$19)
ef26 79        ld      a,c
ef27 fe01      cp      $01
ef29 eb        ex      de,hl
ef2a 78        ld      a,b
ef2b c9        ret     

ef2c 1a        ld      a,(de)
ef2d 13        inc     de
ef2e cda4ff    call    $ffa4			;; test if ASCII character represents a decimal number digit
ef31 380a      jr      c,$ef3d          ; (+$0a)
ef33 cdabff    call    $ffab			;; convert character to upper case
ef36 fe41      cp      $41
ef38 3f        ccf     
ef39 3005      jr      nc,$ef40         ; (+$05)
ef3b d607      sub     $07
ef3d d630      sub     $30
ef3f b8        cp      b
ef40 d8        ret     c

ef41 1b        dec     de
ef42 af        xor     a
ef43 c9        ret     

ef44 cd4aef    call    $ef4a
ef47 c38bc3    jp      $c38b		;; display 0 terminated string

ef4a d5        push    de
ef4b c5        push    bc
ef4c cd35ff    call    $ff35
ef4f cd03fd    call    $fd03
ef52 af        xor     a
ef53 cd72ef    call    $ef72
ef56 23        inc     hl
ef57 c1        pop     bc
ef58 d1        pop     de
ef59 c9        ret     

ef5a d5        push    de
ef5b c5        push    bc
ef5c af        xor     a
ef5d cd6aef    call    $ef6a
ef60 c1        pop     bc
ef61 d1        pop     de
ef62 7e        ld      a,(hl)
ef63 fe20      cp      $20				;; ' '
ef65 c0        ret     nz

ef66 23        inc     hl
ef67 c9        ret     

ef68 3e40      ld      a,$40
ef6a 2252ae    ld      ($ae52),hl
ef6d f5        push    af
ef6e cdf3fc    call    $fcf3
ef71 f1        pop     af
ef72 c5        push    bc
ef73 57        ld      d,a
ef74 d5        push    de
ef75 cd8af1    call    $f18a
ef78 d1        pop     de
ef79 cd96ef    call    $ef96
ef7c cd1af1    call    $f11a
ef7f f1        pop     af
ef80 5f        ld      e,a
ef81 78        ld      a,b
ef82 b7        or      a
ef83 cc2cf1    call    z,$f12c
ef86 cd45f1    call    $f145
ef89 cd4ff1    call    $f14f
ef8c cd6ff1    call    $f16f
ef8f 7a        ld      a,d
ef90 1f        rra     
ef91 d0        ret     nc

ef92 2b        dec     hl
ef93 3625      ld      (hl),$25
ef95 c9        ret     

ef96 7a        ld      a,d
ef97 87        add     a,a
ef98 302d      jr      nc,$efc7         ; (+$2d)
ef9a faedef    jp      m,$efed
ef9d 7b        ld      a,e
ef9e 81        add     a,c
ef9f d615      sub     $15
efa1 fa56f0    jp      m,$f056
efa4 7a        ld      a,d
efa5 f641      or      $41				; 'A'
efa7 57        ld      d,a
efa8 1843      jr      $efed            ; (+$43)
efaa 41        ld      b,c
efab 79        ld      a,c
efac b7        or      a
efad 2815      jr      z,$efc4          ; (+$15)
efaf 83        add     a,e
efb0 3d        dec     a
efb1 5f        ld      e,a
efb2 cddef0    call    $f0de
efb5 0601      ld      b,$01
efb7 79        ld      a,c
efb8 fe07      cp      $07
efba 3804      jr      c,$efc0          ; (+$04)
efbc cb72      bit     6,d
efbe 2026      jr      nz,$efe6         ; (+$26)
efc0 b8        cp      b
efc1 c474f0    call    nz,$f074
efc4 c332f0    jp      $f032
efc7 7b        ld      a,e
efc8 b7        or      a
efc9 fad0ef    jp      m,$efd0
efcc 20dc      jr      nz,$efaa         ; (-$24)
efce 41        ld      b,c
efcf c9        ret     

efd0 43        ld      b,e
efd1 cddef0    call    $f0de
efd4 78        ld      a,b
efd5 b7        or      a
efd6 28f6      jr      z,$efce          ; (-$0a)
efd8 93        sub     e
efd9 58        ld      e,b
efda 47        ld      b,a
efdb 81        add     a,c
efdc 83        add     a,e
efdd faaaef    jp      m,$efaa
efe0 cd87f0    call    $f087
efe3 c374f0    jp      $f074
efe6 3e06      ld      a,$06
efe8 3252ae    ld      ($ae52),a
efeb 182e      jr      $f01b            ; (+$2e)
efed cdfbf0    call    $f0fb
eff0 3003      jr      nc,$eff5         ; (+$03)
eff2 cbc2      set     0,d
eff4 af        xor     a
eff5 47        ld      b,a
eff6 cc13f1    call    z,$f113
eff9 200e      jr      nz,$f009         ; (+$0e)
effb cbc2      set     0,d
effd 04        inc     b
effe 3a52ae    ld      a,($ae52)
f001 b7        or      a
f002 2805      jr      z,$f009          ; (+$05)
f004 05        dec     b
f005 3c        inc     a
f006 3252ae    ld      ($ae52),a
f009 cb4a      bit     1,d
f00b 2807      jr      z,$f014          ; (+$07)
f00d 78        ld      a,b
f00e 04        inc     b
f00f 05        dec     b
f010 d604      sub     $04
f012 30fb      jr      nc,$f00f         ; (-$05)
f014 79        ld      a,c
f015 b7        or      a
f016 2804      jr      z,$f01c          ; (+$04)
f018 83        add     a,e
f019 90        sub     b
f01a 5f        ld      e,a
f01b 78        ld      a,b
f01c f5        push    af
f01d 47        ld      b,a
f01e cd59f0    call    $f059
f021 f1        pop     af
f022 b8        cp      b
f023 280d      jr      z,$f032          ; (+$0d)
f025 1c        inc     e
f026 23        inc     hl
f027 05        dec     b
f028 e5        push    hl
f029 7e        ld      a,(hl)
f02a fe2e      cp      $2e
f02c 2001      jr      nz,$f02f         ; (+$01)
f02e 23        inc     hl
f02f 3631      ld      (hl),$31
f031 e1        pop     hl
f032 3e04      ld      a,$04
f034 cdc2f0    call    $f0c2
f037 e5        push    hl
f038 21452b    ld      hl,$2b45
f03b 7b        ld      a,e
f03c b7        or      a
f03d f244f0    jp      p,$f044
f040 af        xor     a
f041 93        sub     e
f042 262d      ld      h,$2d			; '-'
f044 224cae    ld      ($ae4c),hl
f047 2e2f      ld      l,$2f
f049 2c        inc     l
f04a d60a      sub     $0a
f04c 30fb      jr      nc,$f049         ; (-$05)
f04e c63a      add     a,$3a
f050 67        ld      h,a
f051 224eae    ld      ($ae4e),hl
f054 e1        pop     hl
f055 c9        ret     

f056 cd87f0    call    $f087
f059 cd13f1    call    $f113
f05c 80        add     a,b
f05d b9        cp      c
f05e 3005      jr      nc,$f065         ; (+$05)
f060 cd9af0    call    $f09a
f063 180a      jr      $f06f            ; (+$0a)
f065 fe15      cp      $15
f067 3802      jr      c,$f06b          ; (+$02)
f069 3e14      ld      a,$14
f06b 91        sub     c
f06c c4c2f0    call    nz,$f0c2
f06f 3a52ae    ld      a,($ae52)
f072 b7        or      a
f073 c8        ret     z

f074 0e2e      ld      c,$2e
f076 78        ld      a,b
f077 c5        push    bc
f078 47        ld      b,a
f079 04        inc     b
f07a 85        add     a,l
f07b 6f        ld      l,a
f07c 8c        adc     a,h
f07d 95        sub     l
f07e 67        ld      h,a
f07f 2b        dec     hl
f080 79        ld      a,c
f081 4e        ld      c,(hl)
f082 77        ld      (hl),a
f083 10fa      djnz    $f07f            ; (-$06)
f085 c1        pop     bc
f086 c9        ret     

f087 7b        ld      a,e
f088 81        add     a,c
f089 47        ld      b,a
f08a f0        ret     p

f08b 2f        cpl     
f08c 3c        inc     a
f08d 0614      ld      b,$14
f08f b8        cp      b
f090 3001      jr      nc,$f093         ; (+$01)
f092 47        ld      b,a
f093 2b        dec     hl
f094 3630      ld      (hl),$30
f096 0c        inc     c
f097 10fa      djnz    $f093            ; (-$06)
f099 c9        ret     

f09a 4f        ld      c,a
f09b 85        add     a,l
f09c 6f        ld      l,a
f09d 8c        adc     a,h
f09e 95        sub     l
f09f 67        ld      h,a
f0a0 e5        push    hl
f0a1 c5        push    bc
f0a2 7e        ld      a,(hl)
f0a3 fe35      cp      $35
f0a5 d4b4f0    call    nc,$f0b4
f0a8 c1        pop     bc
f0a9 3805      jr      c,$f0b0          ; (+$05)
f0ab 2b        dec     hl
f0ac 3631      ld      (hl),$31
f0ae 04        inc     b
f0af 0c        inc     c
f0b0 e1        pop     hl
f0b1 2b        dec     hl
f0b2 1838      jr      $f0ec            ; (+$38)
f0b4 79        ld      a,c
f0b5 b7        or      a
f0b6 c8        ret     z

f0b7 2b        dec     hl
f0b8 0d        dec     c
f0b9 7e        ld      a,(hl)
f0ba 34        inc     (hl)
f0bb fe39      cp      $39
f0bd d8        ret     c

f0be 3630      ld      (hl),$30
f0c0 18f2      jr      $f0b4            ; (-$0e)
f0c2 d5        push    de
f0c3 c5        push    bc
f0c4 eb        ex      de,hl
f0c5 47        ld      b,a
f0c6 7b        ld      a,e
f0c7 90        sub     b
f0c8 6f        ld      l,a
f0c9 9f        sbc     a,a
f0ca 82        add     a,d
f0cb 67        ld      h,a
f0cc e5        push    hl
f0cd 1a        ld      a,(de)
f0ce 13        inc     de
f0cf 77        ld      (hl),a
f0d0 23        inc     hl
f0d1 b7        or      a
f0d2 20f9      jr      nz,$f0cd         ; (-$07)
f0d4 2b        dec     hl
f0d5 3630      ld      (hl),$30
f0d7 23        inc     hl
f0d8 10fb      djnz    $f0d5            ; (-$05)
f0da e1        pop     hl
f0db c1        pop     bc
f0dc d1        pop     de
f0dd c9        ret     

f0de 2150ae    ld      hl,$ae50
f0e1 2b        dec     hl
f0e2 7e        ld      a,(hl)
f0e3 fe30      cp      $30
f0e5 2005      jr      nz,$f0ec         ; (+$05)
f0e7 0d        dec     c
f0e8 04        inc     b
f0e9 20f6      jr      nz,$f0e1         ; (-$0a)
f0eb 2b        dec     hl
f0ec d5        push    de
f0ed c5        push    bc
f0ee 114fae    ld      de,$ae4f
f0f1 0600      ld      b,$00
f0f3 cdf5ff    call    $fff5 ; copy bytes LDDR (BC = count)
f0f6 eb        ex      de,hl
f0f7 23        inc     hl
f0f8 c1        pop     bc
f0f9 d1        pop     de
f0fa c9        ret     

f0fb c5        push    bc
f0fc 7a        ld      a,d
f0fd e604      and     $04
f0ff 1f        rra     
f100 1f        rra     
f101 47        ld      b,a
f102 cb62      bit     4,d
f104 2007      jr      nz,$f10d         ; (+$07)
f106 7a        ld      a,d
f107 87        add     a,a
f108 b3        or      e
f109 f20df1    jp      p,$f10d
f10c 04        inc     b
f10d 3a53ae    ld      a,($ae53)
f110 90        sub     b
f111 c1        pop     bc
f112 c9        ret     

f113 3a52ae    ld      a,($ae52)
f116 b7        or      a
f117 c8        ret     z

f118 3d        dec     a
f119 c9        ret     

f11a cb4a      bit     1,d
f11c c8        ret     z

f11d 78        ld      a,b
f11e d603      sub     $03
f120 d8        ret     c

f121 c8        ret     z

f122 f5        push    af
f123 0e2c      ld      c,$2c			; ','
f125 cd77f0    call    $f077
f128 04        inc     b
f129 f1        pop     af
f12a 18f2      jr      $f11e            ; (-$0e)
f12c e5        push    hl
f12d 7e        ld      a,(hl)
f12e 23        inc     hl
f12f 3d        dec     a
f130 fe30      cp      $30
f132 38f9      jr      c,$f12d          ; (-$07)
f134 3c        inc     a
f135 2001      jr      nz,$f138         ; (+$01)
f137 5f        ld      e,a
f138 e1        pop     hl
f139 7a        ld      a,d
f13a ee80      xor     $80
f13c f4fbf0    call    p,$f0fb
f13f d8        ret     c

f140 c8        ret     z

f141 3e30      ld      a,$30			; '0'
f143 1806      jr      $f14b            

f145 cb52      bit     2,d
f147 c8        ret     z

f148 3a54ae    ld      a,($ae54)
f14b 04        inc     b
f14c 2b        dec     hl
f14d 77        ld      (hl),a
f14e c9        ret     

f14f 7b        ld      a,e
f150 87        add     a,a
f151 3e2d      ld      a,$2d			; '-'
f153 380e      jr      c,$f163          ; 
f155 7a        ld      a,d
f156 e698      and     $98
f158 ee80      xor     $80
f15a c8        ret     z

f15b e608      and     $08
f15d 3e2b      ld      a,$2b			; '+'
f15f 2002      jr      nz,$f163         ; 
f161 3e20      ld      a,$20			; ' '
f163 cb62      bit     4,d
f165 28e4      jr      z,$f14b          ; (-$1c)
f167 3250ae    ld      ($ae50),a
f16a af        xor     a
f16b 3251ae    ld      ($ae51),a
f16e c9        ret     

f16f 7a        ld      a,d
f170 b7        or      a
f171 f0        ret     p

f172 3a53ae    ld      a,($ae53)
f175 90        sub     b
f176 c8        ret     z

f177 380e      jr      c,$f187          ; (+$0e)
f179 47        ld      b,a
f17a cb6a      bit     5,d
f17c 3e2a      ld      a,$2a
f17e 2002      jr      nz,$f182         ; (+$02)
f180 3e20      ld      a,$20
f182 2b        dec     hl
f183 77        ld      (hl),a
f184 10fc      djnz    $f182            ; (-$04)
f186 c9        ret     

f187 cbc2      set     0,d
f189 c9        ret     

f18a 112dae    ld      de,$ae2d
f18d af        xor     a
f18e 47        ld      b,a
f18f b6        or      (hl)
f190 2b        dec     hl
f191 2005      jr      nz,$f198         ; (+$05)
f193 0d        dec     c
f194 20f9      jr      nz,$f18f         ; (-$07)
f196 1828      jr      $f1c0            ; (+$28)
f198 37        scf     
f199 8f        adc     a,a
f19a 30fd      jr      nc,$f199         ; (-$03)
f19c eb        ex      de,hl
f19d d5        push    de
f19e 57        ld      d,a
f19f 1811      jr      $f1b2            ; (+$11)
f1a1 1a        ld      a,(de)
f1a2 1b        dec     de
f1a3 d5        push    de
f1a4 37        scf     
f1a5 8f        adc     a,a
f1a6 57        ld      d,a
f1a7 58        ld      e,b
f1a8 7e        ld      a,(hl)
f1a9 8f        adc     a,a
f1aa 27        daa     
f1ab 77        ld      (hl),a
f1ac 23        inc     hl
f1ad 1d        dec     e
f1ae 20f8      jr      nz,$f1a8         ; (-$08)
f1b0 3003      jr      nc,$f1b5         ; (+$03)
f1b2 04        inc     b
f1b3 3601      ld      (hl),$01
f1b5 212dae    ld      hl,$ae2d
f1b8 7a        ld      a,d
f1b9 87        add     a,a
f1ba 20ea      jr      nz,$f1a6         ; (-$16)
f1bc d1        pop     de
f1bd 0d        dec     c
f1be 20e1      jr      nz,$f1a1         ; (-$1f)
f1c0 eb        ex      de,hl
f1c1 2150ae    ld      hl,$ae50
f1c4 3600      ld      (hl),$00
f1c6 78        ld      a,b
f1c7 87        add     a,a
f1c8 4f        ld      c,a
f1c9 c8        ret     z

f1ca 3e30      ld      a,$30			;; '0'
f1cc eb        ex      de,hl
f1cd ed67      rrd     
f1cf 1b        dec     de
f1d0 12        ld      (de),a
f1d1 ed67      rrd     
f1d3 1b        dec     de
f1d4 12        ld      (de),a
f1d5 23        inc     hl
f1d6 10f5      djnz    $f1cd            ; (-$0b)
f1d8 eb        ex      de,hl
f1d9 fe30      cp      $30
f1db c0        ret     nz

f1dc 0d        dec     c
f1dd 23        inc     hl
f1de c9        ret     

f1df d5        push    de
f1e0 eb        ex      de,hl
f1e1 213eae    ld      hl,$ae3e
f1e4 3600      ld      (hl),$00
f1e6 3d        dec     a
f1e7 f5        push    af
f1e8 7b        ld      a,e
f1e9 a1        and     c
f1ea f6f0      or      $f0
f1ec 27        daa     
f1ed c6a0      add     a,$a0
f1ef ce40      adc     a,$40			;; 'A'-1
f1f1 2b        dec     hl
f1f2 77        ld      (hl),a
f1f3 78        ld      a,b
f1f4 cb3a      srl     d
f1f6 cb1b      rr      e
f1f8 10fa      djnz    $f1f4            ; (-$06)
f1fa 47        ld      b,a
f1fb f1        pop     af
f1fc 3d        dec     a
f1fd f2e7f1    jp      p,$f1e7
f200 7a        ld      a,d
f201 b3        or      e
f202 3e00      ld      a,$00
f204 20e1      jr      nz,$f1e7         ; (-$1f)
f206 d1        pop     de
f207 c9        ret     

;;========================================================
;; PEEK

f208 cdebfe    call    $feeb
f20b e7        rst     $20
f20c c332ff    jp      $ff32

;;========================================================================
;; POKE

f20f cdf5ce    call    $cef5
f212 d5        push    de
f213 cd3ff2    call    $f23f
f216 d1        pop     de
f217 12        ld      (de),a
f218 c9        ret     

;;========================================================================
;; INP
f219 cdb6fe    call    $feb6
f21c 44        ld      b,h
f21d 4d        ld      c,l
f21e ed78      in      a,(c)
f220 c332ff    jp      $ff32

;;========================================================================
;; OUT

f223 cd3af2    call    $f23a
f226 ed79      out     (c),a
f228 c9        ret     
;;========================================================================
;; WAIT
f229 cd3af2    call    $f23a
f22c 57        ld      d,a
f22d 3e00      ld      a,$00
f22f c43ff2    call    nz,$f23f
f232 5f        ld      e,a
f233 ed78      in      a,(c)
f235 ab        xor     e
f236 a2        and     d
f237 28fa      jr      z,$f233          ; (-$06)
f239 c9        ret     
;;========================================================================

f23a cdf5ce    call    $cef5
f23d 42        ld      b,d
f23e 4b        ld      c,e
f23f cd15de    call    $de15 ; check for comma
f242 c3b8ce    jp      $ceb8 ; get number and check it's less than 255 

;;-----------------------------------------------------------------------------------

;; | command

;; skip | symbol
f245 23        inc     hl
;; this is the name with last char with bit 7 set
f246 7e        ld      a,(hl)
f247 b7        or      a
f248 23        inc     hl
f249 e5        push    hl
f24a ccd4bc    call    z,$bcd4			; firmware function: KL FIND COMMAND
f24d eb        ex      de,hl
f24e e1        pop     hl
f24f 3007      jr      nc,$f258         ; command not found...?
;; skip name
f251 7e        ld      a,(hl)
f252 23        inc     hl
f253 17        rla     
f254 30fb      jr      nc,$f251         ; (-$05)
f256 1809      jr      $f261            ; (+$09)
f258 cd45cb    call    $cb45
f25b 1c        inc     e

;;==================================================================
;; CALL
f25c cdf5ce    call    $cef5			; get address
f25f 0eff      ld      c,$ff
;; store address of function
f261 ed5355ae  ld      ($ae55),de
;; store rom select
f265 79        ld      a,c
f266 3257ae    ld      ($ae57),a
f269 ed735aae  ld      ($ae5a),sp
f26d 0620      ld      b,$20			; max 32 parameters
f26f cd41de    call    $de41
f272 3008      jr      nc,$f27c         ; (+$08)
f274 c5        push    bc
f275 cde3ce    call    $cee3
f278 c1        pop     bc
f279 d5        push    de				; push parameter onto stack
f27a 10f3      djnz    $f26f            ; (-$0d)
f27c cd37de    call    $de37
f27f 2258ae    ld      ($ae58),hl
f282 3e20      ld      a,$20			; max 32 parameters
;; B = $20-number of parameters specified
f284 90        sub     b
;; A = number of parameters
f285 dd210000  ld      ix,$0000
f289 dd39      add     ix,sp			; IX points to parameters on stack

;; IX = points to parameters
;; A = number of parameters
;; execute function
f28b df        rst     $18
defw &ae55
f28e ed7b5aae  ld      sp,($ae5a)
f292 cdccfb    call    $fbcc
f295 2a58ae    ld      hl,($ae58)
f298 c9        ret     

f299 3e0d      ld      a,$0d
f29b 1803      jr      $f2a0            ; (+$03)

;;========================================================================
;; ZONE

f29d cdc3ce    call    $cec3
f2a0 325cae    ld      ($ae5c),a
f2a3 c9        ret     

;;========================================================================
;; PRINT

f2a4 cdcfc1    call    $c1cf
f2a7 cd3dde    call    $de3d
f2aa da98c3    jp      c,$c398      ;; new text line
f2ad feed      cp      $ed
f2af ca7ef3    jp      z,$f37e
f2b2 eb        ex      de,hl
f2b3 21c3f2    ld      hl,$f2c3
f2b6 cdb4ff    call    $ffb4
f2b9 eb        ex      de,hl
f2ba cdfeff    call    $fffe			; JP (DE)
f2bd cd3dde    call    $de3d
f2c0 30eb      jr      nc,$f2ad         ; (-$15)
f2c2 c9        ret     

f2c3 defb &04
defw &f2d2

defb &2c
defw &f319
defb &e5
defw &f334
defb &ea
defw &f33d
defb &3b
defw &de2c

f2d2 cd62cf    call    $cf62
f2d5 f5        push    af
f2d6 e5        push    hl
f2d7 cd66ff    call    $ff66
f2da 280f      jr      z,$f2eb          ; (+$0f)
f2dc cd68ef    call    $ef68
f2df cd8af8    call    $f88a
f2e2 3620      ld      (hl),$20
f2e4 2aa0b0    ld      hl,($b0a0)
f2e7 34        inc     (hl)
f2e8 7e        ld      a,(hl)
f2e9 181f      jr      $f30a            ; (+$1f)
f2eb 2aa0b0    ld      hl,($b0a0)
f2ee 46        ld      b,(hl)
f2ef 0e00      ld      c,$00
f2f1 23        inc     hl
f2f2 7e        ld      a,(hl)
f2f3 23        inc     hl
f2f4 66        ld      h,(hl)
f2f5 6f        ld      l,a
f2f6 04        inc     b
f2f7 180e      jr      $f307            ; (+$0e)
f2f9 7e        ld      a,(hl)
f2fa fe20      cp      $20
f2fc 23        inc     hl
f2fd 3007      jr      nc,$f306         ; (+$07)
f2ff 3d        dec     a
f300 2007      jr      nz,$f309         ; (+$07)
f302 05        dec     b
f303 2804      jr      z,$f309          ; (+$04)
f305 23        inc     hl
f306 0c        inc     c
f307 10f0      djnz    $f2f9            ; (-$10)
f309 79        ld      a,c
f30a cde7c2    call    $c2e7
f30d d498c3    call    nc,$c398      ;; new text line
f310 cdd0f8    call    $f8d0
f313 e1        pop     hl
f314 f1        pop     af
f315 cc98c3    call    z,$c398      ;; new text line
f318 c9        ret     

f319 cd2cde    call    $de2c			; get next token skipping space
f31c 3a5cae    ld      a,($ae5c)
f31f 4f        ld      c,a
f320 cdb9c2    call    $c2b9
f323 3d        dec     a
f324 91        sub     c
f325 30fd      jr      nc,$f324         ; (-$03)
f327 2f        cpl     
f328 3c        inc     a
f329 47        ld      b,a
f32a 81        add     a,c
f32b cde7c2    call    $c2e7
f32e d298c3    jp      nc,$c398      ;; new text line
f331 78        ld      a,b
f332 181e      jr      $f352            ; (+$1e)
f334 cd5df3    call    $f35d
f337 cd69f3    call    $f369
f33a 7b        ld      a,e
f33b 1815      jr      $f352            ; (+$15)
f33d cd5df3    call    $f35d
f340 1b        dec     de
f341 cd69f3    call    $f369
f344 cdb9c2    call    $c2b9
f347 2f        cpl     
f348 3c        inc     a
f349 1c        inc     e
f34a 83        add     a,e
f34b 3805      jr      c,$f352          ; (+$05)
f34d cd98c3    call    $c398      ;; new text line
f350 1d        dec     e
f351 7b        ld      a,e
f352 47        ld      b,a
f353 04        inc     b
f354 05        dec     b
f355 c8        ret     z

f356 3e20      ld      a,$20			; ' '
f358 cda0c3    call    $c3a0           ;; display text char
f35b 18f7      jr      $f354            ; (-$09)


f35d cd2cde    call    $de2c			; get next token skipping space
f360 cd19de    call    $de19 ; check for open bracket
f363 cdd8ce    call    $ced8 ; get number
f366 c31dde    jp      $de1d ; check for close bracket


f369 7a        ld      a,d
f36a 17        rla     
f36b 3003      jr      nc,$f370         ; (+$03)
f36d 110000    ld      de,$0000
f370 cdcfc2    call    $c2cf
f373 d0        ret     nc

f374 e5        push    hl
f375 eb        ex      de,hl
f376 5f        ld      e,a
f377 1600      ld      d,$00
f379 cdaedd    call    $ddae
f37c e1        pop     hl
f37d c9        ret     

f37e cd2cde    call    $de2c			; get next token skipping space
f381 cd09cf    call    $cf09
f384 cd25de    call    $de25
defb &3b
f388 e5        push    hl
f389 2aa0b0    ld      hl,($b0a0)
f38c e3        ex      (sp),hl
f38d cd62cf    call    $cf62
f390 af        xor     a
f391 325dae    ld      ($ae5d),a
f394 d1        pop     de
f395 d5        push    de
f396 eb        ex      de,hl
f397 46        ld      b,(hl)
f398 23        inc     hl
f399 7e        ld      a,(hl)
f39a 23        inc     hl
f39b 66        ld      h,(hl)
f39c 6f        ld      l,a
f39d eb        ex      de,hl
f39e cdcdf3    call    $f3cd
f3a1 d2abf4    jp      nc,$f4ab
f3a4 cd3dde    call    $de3d
f3a7 3811      jr      c,$f3ba          ; (+$11)
f3a9 cdeff3    call    $f3ef
f3ac 280c      jr      z,$f3ba          ; (+$0c)
f3ae d5        push    de
f3af cd62cf    call    $cf62
f3b2 d1        pop     de
f3b3 cdcdf3    call    $f3cd
f3b6 30dc      jr      nc,$f394         ; (-$24)
f3b8 18ea      jr      $f3a4            ; (-$16)
f3ba f5        push    af
f3bb 3eff      ld      a,$ff
f3bd 325dae    ld      ($ae5d),a
f3c0 cdcdf3    call    $f3cd
f3c3 f1        pop     af
f3c4 dc98c3    call    c,$c398      ;; new text line
f3c7 e3        ex      (sp),hl
f3c8 cd03fc    call    $fc03
f3cb e1        pop     hl
f3cc c9        ret     

f3cd 78        ld      a,b
f3ce b7        or      a
f3cf c8        ret     z

f3d0 e5        push    hl
f3d1 1a        ld      a,(de)
f3d2 fe5f      cp      $5f
f3d4 2007      jr      nz,$f3dd         ; (+$07)
f3d6 13        inc     de
f3d7 100c      djnz    $f3e5            ; (+$0c)
f3d9 04        inc     b
f3da 1b        dec     de
f3db 1808      jr      $f3e5            ; (+$08)
f3dd cdf7f3    call    $f3f7
f3e0 d431f4    call    nc,$f431
f3e3 3808      jr      c,$f3ed          ; (+$08)
f3e5 1a        ld      a,(de)
f3e6 cda0c3    call    $c3a0           ;; display text char
f3e9 13        inc     de
f3ea 10e5      djnz    $f3d1            ; (-$1b)
f3ec b7        or      a
f3ed e1        pop     hl
f3ee c9        ret     

f3ef fe3b      cp      $3b
f3f1 ca2cde    jp      z,$de2c			; get next token skipping space
f3f4 c315de    jp      $de15 ; check for comma
f3f7 1a        ld      a,(de)
f3f8 0e00      ld      c,$00
f3fa fe26      cp      $26
f3fc 281e      jr      z,$f41c          ; (+$1e)
f3fe 0c        inc     c
f3ff fe21      cp      $21
f401 2819      jr      z,$f41c          ; (+$19)
f403 ee5c      xor     $5c
f405 c0        ret     nz

f406 c5        push    bc
f407 d5        push    de
f408 13        inc     de
f409 05        dec     b
f40a 280a      jr      z,$f416          ; (+$0a)
f40c 0c        inc     c
f40d 1a        ld      a,(de)
f40e fe5c      cp      $5c
f410 2808      jr      z,$f41a          ; (+$08)
f412 fe20      cp      $20
f414 28f2      jr      z,$f408          ; (-$0e)
f416 d1        pop     de
f417 c1        pop     bc
f418 b7        or      a
f419 c9        ret     

f41a f1        pop     af
f41b f1        pop     af
f41c 13        inc     de
f41d 05        dec     b
f41e c5        push    bc
f41f d5        push    de
f420 3a5dae    ld      a,($ae5d)
f423 b7        or      a
f424 2007      jr      nz,$f42d         ; (+$07)
f426 cddcf8    call    $f8dc
f429 79        ld      a,c
f42a cd52f3    call    $f352
f42d d1        pop     de
f42e c1        pop     bc
f42f 37        scf     
f430 c9        ret     

f431 cd48f4    call    $f448
f434 d0        ret     nc

f435 3a5dae    ld      a,($ae5d)
f438 b7        or      a
f439 200b      jr      nz,$f446         ; (+$0b)
f43b c5        push    bc
f43c d5        push    de
f43d 79        ld      a,c
f43e cd6aef    call    $ef6a
f441 cd8bc3    call    $c38b		;; display 0 terminated string
f444 d1        pop     de
f445 c1        pop     bc
f446 37        scf     
f447 c9        ret     

f448 c5        push    bc
f449 d5        push    de
f44a 0e80      ld      c,$80
f44c 2600      ld      h,$00
f44e 1a        ld      a,(de)
f44f fe2b      cp      $2b				; '+'
f451 2007      jr      nz,$f45a         
f453 13        inc     de
f454 05        dec     b
f455 2824      jr      z,$f47b          ; (+$24)
f457 24        inc     h
f458 0e88      ld      c,$88
f45a 1a        ld      a,(de)
f45b fe2e      cp      $2e				; '.'
f45d 2820      jr      z,$f47f          
f45f fe23      cp      $23				; '#'
f461 283e      jr      z,$f4a1          
f463 13        inc     de
f464 05        dec     b
f465 2814      jr      z,$f47b          ; (+$14)
f467 eb        ex      de,hl
f468 be        cp      (hl)
f469 eb        ex      de,hl
f46a 200f      jr      nz,$f47b         ; (+$0f)
f46c 24        inc     h
f46d 24        inc     h
f46e 2e04      ld      l,$04
f470 cd02f5    call    $f502
f473 2824      jr      z,$f499          ; (+$24)
f475 2e20      ld      l,$20
f477 fe2a      cp      $2a
f479 2811      jr      z,$f48c          ; (+$11)
f47b d1        pop     de
f47c c1        pop     bc
f47d b7        or      a
f47e c9        ret     

f47f 13        inc     de
f480 05        dec     b
f481 28f8      jr      z,$f47b          ; (-$08)
f483 1a        ld      a,(de)
f484 fe23      cp      $23				; '#'
f486 20f3      jr      nz,$f47b         ; (-$0d)
f488 1b        dec     de
f489 04        inc     b
f48a 1815      jr      $f4a1            ; (+$15)
f48c 13        inc     de
f48d 05        dec     b
f48e 280e      jr      z,$f49e          ; (+$0e)
f490 1a        ld      a,(de)
f491 cd02f5    call    $f502
f494 2008      jr      nz,$f49e         ; (+$08)
f496 24        inc     h
f497 2e24      ld      l,$24
f499 3254ae    ld      ($ae54),a
f49c 13        inc     de
f49d 05        dec     b
f49e 79        ld      a,c
f49f b5        or      l
f4a0 4f        ld      c,a
f4a1 f1        pop     af
f4a2 f1        pop     af
f4a3 cdaef4    call    $f4ae
f4a6 7c        ld      a,h
f4a7 85        add     a,l
f4a8 fe15      cp      $15
f4aa d8        ret     c

f4ab c34dcb    jp      $cb4d			; Error: Improper Argument
f4ae af        xor     a
f4af 6f        ld      l,a
f4b0 b0        or      b
f4b1 c8        ret     z

f4b2 1a        ld      a,(de)
f4b3 fe2e      cp      $2e				; '.'
f4b5 280f      jr      z,$f4c6          ; (+$0f)
f4b7 fe23      cp      $23				; '#'
f4b9 2806      jr      z,$f4c1          ; (+$06)
f4bb fe2c      cp      $2c
f4bd 2010      jr      nz,$f4cf         ; (+$10)
f4bf cbc9      set     1,c
f4c1 24        inc     h
f4c2 13        inc     de
f4c3 10ed      djnz    $f4b2            ; (-$13)
f4c5 c9        ret     

f4c6 2c        inc     l
f4c7 13        inc     de
f4c8 05        dec     b
f4c9 c8        ret     z

f4ca 1a        ld      a,(de)
f4cb fe23      cp      $23				; '#'
f4cd 28f7      jr      z,$f4c6          ; (-$09)
f4cf eb        ex      de,hl
f4d0 e5        push    hl
f4d1 fe5e      cp      $5e
f4d3 2016      jr      nz,$f4eb         ; (+$16)
f4d5 23        inc     hl
f4d6 be        cp      (hl)
f4d7 2012      jr      nz,$f4eb         ; (+$12)
f4d9 23        inc     hl
f4da be        cp      (hl)
f4db 200e      jr      nz,$f4eb         ; (+$0e)
f4dd 23        inc     hl
f4de be        cp      (hl)
f4df 200a      jr      nz,$f4eb         ; (+$0a)
f4e1 23        inc     hl
f4e2 78        ld      a,b
f4e3 d604      sub     $04
f4e5 3804      jr      c,$f4eb          ; (+$04)
f4e7 47        ld      b,a
f4e8 e3        ex      (sp),hl
f4e9 cbf1      set     6,c
f4eb e1        pop     hl
f4ec eb        ex      de,hl
f4ed 04        inc     b
f4ee 05        dec     b
f4ef c8        ret     z

f4f0 cb59      bit     3,c
f4f2 c0        ret     nz

f4f3 1a        ld      a,(de)
f4f4 fe2d      cp      $2d				; '-'
f4f6 2805      jr      z,$f4fd          ; 
f4f8 fe2b      cp      $2b				; '+'
f4fa c0        ret     nz

f4fb cbd9      set     3,c
f4fd cbe1      set     4,c
f4ff 13        inc     de
f500 05        dec     b
f501 c9        ret     

f502 fe24      cp      $24				; '$'
f504 c8        ret     z

f505 fea3      cp      $a3				; '£' 
f507 c9        ret     
;;========================================================================
;; WRITE
f508 cdcfc1    call    $c1cf
f50b cd3dde    call    $de3d
f50e da98c3    jp      c,$c398      ;; new text line
f511 cd62cf    call    $cf62
f514 f5        push    af
f515 e5        push    hl
f516 cd66ff    call    $ff66
f519 2808      jr      z,$f523          ; (+$08)
f51b cd5aef    call    $ef5a
f51e cd8bc3    call    $c38b		;; display 0 terminated string
f521 180d      jr      $f530            ; (+$0d)
f523 3e22      ld      a,$22
f525 cda0c3    call    $c3a0           ;; display text char
f528 cdd0f8    call    $f8d0
f52b 3e22      ld      a,$22
f52d cda0c3    call    $c3a0           ;; display text char
f530 e1        pop     hl
f531 f1        pop     af
f532 ca98c3    jp      z,$c398      ;; new text line
f535 cdeff3    call    $f3ef
f538 3e2c      ld      a,$2c
f53a cda0c3    call    $c3a0           ;; display text char
f53d 18d2      jr      $f511            ; (-$2e)

;;--------------------------------------------------------------------

f53f 0100ac    ld      bc,$ac00
f542 cddeff    call    $ffde ; HL=BC?
f545 d0        ret     nc

f546 225eae    ld      ($ae5e),hl ; HIMEM
f549 2273b0    ld      ($b073),hl
f54c 2260ae    ld      ($ae60),hl
f54f eb        ex      de,hl
f550 2262ae    ld      ($ae62),hl
f553 012f01    ld      bc,$012f
f556 09        add     hl,bc
f557 d8        ret     c

f558 2264ae    ld      ($ae64),hl
f55b eb        ex      de,hl
f55c 23        inc     hl
f55d ed52      sbc     hl,de
f55f d8        ret     c

f560 7c        ld      a,h
f561 fe04      cp      $04
f563 d8        ret     c

f564 cd7ff7    call    $f77f
f567 326eae    ld      ($ae6e),a
f56a c9        ret     

;;========================================================================
;; MEMORY

f56b cdf5ce    call    $cef5
f56e e5        push    hl
f56f 2a60ae    ld      hl,($ae60)
f572 cdd8ff    call    $ffd8 ; HL=DE?
f575 3831      jr      c,$f5a8          ; (+$31)
f577 13        inc     de
f578 cdecf5    call    $f5ec ; compare DE with HIMEM
f57b dc8af5    call    c,$f58a
f57e eb        ex      de,hl
f57f cd08f8    call    $f808
f582 2a76b0    ld      hl,($b076)
f585 2278b0    ld      ($b078),hl
f588 e1        pop     hl
f589 c9        ret     

f58a cdaebb    call    $bbae			; firmware function: TXT GET M TABLE
f58d ed4b5eae  ld      bc,($ae5e) ; HIMEM
f591 dce0f5    call    c,$f5e0
f594 3812      jr      c,$f5a8          ; (+$12)
f596 2a76b0    ld      hl,($b076)
f599 2b        dec     hl
f59a cde0f5    call    $f5e0
f59d d0        ret     nc

f59e 3a75b0    ld      a,($b075)
f5a1 b7        or      a
f5a2 c8        ret     z

f5a3 fe04      cp      $04
f5a5 ca7ff7    jp      z,$f77f
f5a8 c375f8    jp      $f875
f5ab d5        push    de
f5ac eb        ex      de,hl
f5ad 09        add     hl,bc
f5ae 2b        dec     hl
f5af ed4b62ae  ld      bc,($ae62)
f5b3 e3        ex      (sp),hl
f5b4 eb        ex      de,hl
f5b5 2a5eae    ld      hl,($ae5e) ; HIMEM
f5b8 cde0f5    call    $f5e0
f5bb eb        ex      de,hl
f5bc e3        ex      (sp),hl
f5bd eb        ex      de,hl
f5be dce0f5    call    c,$f5e0
f5c1 30e5      jr      nc,$f5a8         ; (-$1b)
f5c3 ed4b76b0  ld      bc,($b076)
f5c7 21ff0f    ld      hl,$0fff
f5ca 09        add     hl,bc
f5cb cde0f5    call    $f5e0
f5ce d1        pop     de
f5cf dce0f5    call    c,$f5e0
f5d2 d8        ret     c

f5d3 eb        ex      de,hl
f5d4 50        ld      d,b
f5d5 59        ld      e,c
f5d6 cdecf5    call    $f5ec ; compare DE with HIMEM
f5d9 c27ff7    jp      nz,$f77f
f5dc 2278b0    ld      ($b078),hl
f5df c9        ret     

f5e0 d5        push    de
f5e1 e5        push    hl
f5e2 b7        or      a
f5e3 ed42      sbc     hl,bc
f5e5 eb        ex      de,hl
f5e6 b7        or      a
f5e7 ed42      sbc     hl,bc
f5e9 eb        ex      de,hl
f5ea 1806      jr      $f5f2            ; (+$06)

;; compare DE to HIMEM
f5ec d5        push    de
f5ed e5        push    hl
f5ee 2a5eae    ld      hl,($ae5e) ; HIMEM
f5f1 23        inc     hl
f5f2 cdd8ff    call    $ffd8 ; HL=DE?
f5f5 e1        pop     hl
f5f6 d1        pop     de
f5f7 c9        ret     

f5f8 d5        push    de
f5f9 e5        push    hl
f5fa 2a71b0    ld      hl,($b071)
f5fd eb        ex      de,hl
f5fe 2a73b0    ld      hl,($b073)
f601 cde4ff    call    $ffe4			; BC = HL-DE
f604 e1        pop     hl
f605 d1        pop     de
f606 c9        ret     

f607 2a66ae    ld      hl,($ae66)
f60a 09        add     hl,bc
f60b 2266ae    ld      ($ae66),hl
f60e 3a6eae    ld      a,($ae6e)
f611 b7        or      a
f612 c0        ret     nz

f613 2a68ae    ld      hl,($ae68)
f616 09        add     hl,bc
f617 2268ae    ld      ($ae68),hl
f61a 2a6aae    ld      hl,($ae6a)
f61d 09        add     hl,bc
f61e 226aae    ld      ($ae6a),hl
f621 2a6cae    ld      hl,($ae6c)
f624 09        add     hl,bc
f625 226cae    ld      ($ae6c),hl
f628 c9        ret     

f629 cdfcf6    call    $f6fc
f62c 44        ld      b,h
f62d 4d        ld      c,l
f62e 2a66ae    ld      hl,($ae66)
f631 eb        ex      de,hl
f632 cdb8f6    call    $f6b8
f635 3eff      ld      a,$ff
f637 326eae    ld      ($ae6e),a
f63a 18d7      jr      $f613            ; (-$29)
f63c af        xor     a
f63d 326eae    ld      ($ae6e),a
f640 2a66ae    ld      hl,($ae66)
f643 eb        ex      de,hl
f644 2a68ae    ld      hl,($ae68)
f647 cde4ff    call    $ffe4			; BC = HL-DE
f64a cde5f6    call    $f6e5
f64d 18c4      jr      $f613            ; (-$3c)
f64f 216fae    ld      hl,$ae6f
f652 226fb0    ld      ($b06f),hl
f655 3e01      ld      a,$01
f657 cd72f6    call    $f672
f65a 3600      ld      (hl),$00
f65c 23        inc     hl
f65d 2219ae    ld      ($ae19),hl
f660 180c      jr      $f66e            ; (+$0c)
f662 2a6fb0    ld      hl,($b06f)
f665 2f        cpl     
f666 3c        inc     a
f667 c8        ret     z

f668 85        add     a,l
f669 6f        ld      l,a
f66a 3eff      ld      a,$ff
f66c 8c        adc     a,h
f66d 67        ld      h,a
f66e 226fb0    ld      ($b06f),hl
f671 c9        ret     

f672 2a6fb0    ld      hl,($b06f)
f675 e5        push    hl
f676 85        add     a,l
f677 6f        ld      l,a
f678 8c        adc     a,h
f679 95        sub     l
f67a 67        ld      h,a
f67b 226fb0    ld      ($b06f),hl
f67e 3e94      ld      a,$94
f680 85        add     a,l
f681 3e4f      ld      a,$4f
f683 8c        adc     a,h
f684 e1        pop     hl
f685 d0        ret     nc

f686 cd4ff6    call    $f64f
f689 c375f8    jp      $f875
f68c 2a73b0    ld      hl,($b073)
f68f 2271b0    ld      ($b071),hl
f692 c9        ret     

f693 0600      ld      b,$00
f695 2a6cae    ld      hl,($ae6c)
f698 eb        ex      de,hl
f699 2a71b0    ld      hl,($b071)
f69c b7        or      a
f69d ed42      sbc     hl,bc
f69f 2b        dec     hl
f6a0 2b        dec     hl
f6a1 cdd8ff    call    $ffd8 ; HL=DE?
f6a4 3009      jr      nc,$f6af         ; (+$09)
f6a6 cd64fc    call    $fc64
f6a9 38ea      jr      c,$f695          ; (-$16)
f6ab cd45cb    call    $cb45
f6ae 0e22      ld      c,$22
f6b0 71        ld      (hl),c
f6b1 b0        or      b
f6b2 23        inc     hl
f6b3 71        ld      (hl),c
f6b4 23        inc     hl
f6b5 70        ld      (hl),b
f6b6 23        inc     hl
f6b7 c9        ret     

f6b8 cd14f7    call    $f714
f6bb c5        push    bc
f6bc d5        push    de
f6bd d5        push    de
f6be e5        push    hl
f6bf 09        add     hl,bc
f6c0 380e      jr      c,$f6d0          ; (+$0e)
f6c2 eb        ex      de,hl
f6c3 cd07f7    call    $f707
f6c6 cdd8ff    call    $ffd8 ; HL=DE?
f6c9 3008      jr      nc,$f6d3         ; (+$08)
f6cb cd64fc    call    $fc64
f6ce 38f3      jr      c,$f6c3          ; (-$0d)
f6d0 c375f8    jp      $f875
f6d3 e1        pop     hl
f6d4 c1        pop     bc
f6d5 d5        push    de
f6d6 7d        ld      a,l
f6d7 91        sub     c
f6d8 4f        ld      c,a
f6d9 7c        ld      a,h
f6da 98        sbc     a,b
f6db 47        ld      b,a
f6dc 2b        dec     hl
f6dd 1b        dec     de
f6de cdf5ff    call    $fff5 ; copy bytes LDDR (BC = count)
f6e1 e1        pop     hl
f6e2 d1        pop     de
f6e3 c1        pop     bc
f6e4 c9        ret     

f6e5 c5        push    bc
f6e6 d5        push    de
f6e7 eb        ex      de,hl
f6e8 09        add     hl,bc
f6e9 eb        ex      de,hl
f6ea cd14f7    call    $f714
f6ed cde4ff    call    $ffe4			; BC = HL-DE
f6f0 eb        ex      de,hl
f6f1 d1        pop     de
f6f2 cdefff    call    $ffef ; copy bytes LDIR (BC = count)
f6f5 d1        pop     de
f6f6 210000    ld      hl,$0000
f6f9 c3e4ff    jp      $ffe4			; BC = HL-DE
f6fc 2a6cae    ld      hl,($ae6c)
f6ff eb        ex      de,hl
f700 2a71b0    ld      hl,($b071)
f703 b7        or      a
f704 ed52      sbc     hl,de
f706 c9        ret     

f707 3a6eae    ld      a,($ae6e)
f70a b7        or      a
f70b 2a71b0    ld      hl,($b071)
f70e c8        ret     z

f70f 2a68ae    ld      hl,($ae68)
f712 2b        dec     hl
f713 c9        ret     

f714 3a6eae    ld      a,($ae6e)
f717 b7        or      a
f718 2a6cae    ld      hl,($ae6c)
f71b c8        ret     z

f71c 2a66ae    ld      hl,($ae66)
f71f c9        ret     

f720 110100    ld      de,$0001
f723 1808      jr      $f72d            ; (+$08)
f725 110208    ld      de,$0802
f728 1803      jr      $f72d            ; (+$03)
f72a 110008    ld      de,$0800
f72d c5        push    bc
f72e e5        push    hl
f72f 3a75b0    ld      a,($b075)
f732 b7        or      a
f733 2018      jr      nz,$f74d         ; (+$18)
f735 d5        push    de
f736 2a5eae    ld      hl,($ae5e) ; HIMEM
f739 23        inc     hl
f73a 2278b0    ld      ($b078),hl
f73d 1100f0    ld      de,$f000
f740 19        add     hl,de
f741 d275f8    jp      nc,$f875
f744 cd08f8    call    $f808
f747 2276b0    ld      ($b076),hl
f74a d1        pop     de
f74b 3e04      ld      a,$04
f74d b3        or      e
f74e 2a76b0    ld      hl,($b076)
f751 1e00      ld      e,$00
f753 19        add     hl,de
f754 eb        ex      de,hl
f755 e1        pop     hl
f756 c1        pop     bc
f757 1827      jr      $f780            ; (+$27)
f759 3efe      ld      a,$fe
f75b 1806      jr      $f763            ; (+$06)
f75d 3efd      ld      a,$fd
f75f 1802      jr      $f763            ; (+$02)
f761 3eff      ld      a,$ff
f763 e5        push    hl
f764 2175b0    ld      hl,$b075
f767 a6        and     (hl)
f768 77        ld      (hl),a
f769 fe04      cp      $04
f76b 2009      jr      nz,$f776         ; (+$09)
f76d 2a76b0    ld      hl,($b076)
f770 eb        ex      de,hl
f771 cdecf5    call    $f5ec ; compare DE with HIMEM
f774 2802      jr      z,$f778          ; (+$02)
f776 e1        pop     hl
f777 c9        ret     

f778 2a78b0    ld      hl,($b078)
f77b cd08f8    call    $f808
f77e e1        pop     hl
f77f af        xor     a
f780 3275b0    ld      ($b075),a
f783 c9        ret     

;;========================================================================
;; SYMBOL
f784 fe80      cp      $80				; AFTER
f786 2829      jr      z,$f7b1          ; (+$29)
f788 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
f78b 4f        ld      c,a
f78c cd15de    call    $de15 ; check for comma
f78f 0608      ld      b,$08
f791 37        scf     
f792 d441de    call    nc,$de41
f795 9f        sbc     a,a
f796 dcb8ce    call    c,$ceb8 ; get number and check it's less than 255 
f799 f5        push    af
f79a b7        or      a
f79b 10f5      djnz    $f792            ; (-$0b)
f79d eb        ex      de,hl
f79e 79        ld      a,c
f79f cda5bb    call    $bba5			; firmware function: TXT GET MATRIX		
f7a2 d24dcb    jp      nc,$cb4d			; Error: Improper Argument
f7a5 010800    ld      bc,$0008
f7a8 09        add     hl,bc
f7a9 f1        pop     af
f7aa 2b        dec     hl
f7ab 77        ld      (hl),a
f7ac 0d        dec     c
f7ad 20fa      jr      nz,$f7a9         ; (-$06)
f7af eb        ex      de,hl
f7b0 c9        ret     

f7b1 cd2cde    call    $de2c			; get next token skipping space
f7b4 cdd8ce    call    $ced8 ; get number
f7b7 e5        push    hl
f7b8 210001    ld      hl,$0100
f7bb cdd8ff    call    $ffd8 ; HL=DE?
f7be da4dcb    jp      c,$cb4d			; Error: Improper Argument
f7c1 d5        push    de
f7c2 cdaebb    call    $bbae			; firmware function: TXT GET M TABLE
f7c5 eb        ex      de,hl
f7c6 301b      jr      nc,$f7e3         ; (+$1b)
;; A = first character
;; HL = address of table
f7c8 2f        cpl     
f7c9 6f        ld      l,a
f7ca 2600      ld      h,$00
f7cc 23        inc     hl
f7cd 29        add     hl,hl			; x2
f7ce 29        add     hl,hl			; x4
f7cf 29        add     hl,hl			; x8
f7d0 cdecf5    call    $f5ec ; compare DE with HIMEM
f7d3 c24dcb    jp      nz,$cb4d			; Error: Improper Argument
f7d6 19        add     hl,de
f7d7 cd08f8    call    $f808
f7da cd61f7    call    $f761
										; HL = Address of table
f7dd 110001    ld      de,$0100			; first character in table
f7e0 cdabbb    call    $bbab			; firmware function: TXT SET M TABLE
f7e3 d1        pop     de
f7e4 cde9f7    call    $f7e9			; no defined table
f7e7 e1        pop     hl
f7e8 c9        ret     

;; SYMBOL AFTER
;; A = number
f7e9 210001    ld      hl,$0100
f7ec b7        or      a
f7ed ed52      sbc     hl,de
f7ef c8        ret     z

f7f0 d5        push    de
f7f1 29        add     hl,hl
f7f2 29        add     hl,hl
f7f3 29        add     hl,hl
f7f4 eb        ex      de,hl
f7f5 2a5eae    ld      hl,($ae5e) ; HIMEM
f7f8 ed52      sbc     hl,de
f7fa 7c        ld      a,h
f7fb fe40      cp      $40
f7fd da75f8    jp      c,$f875
f800 23        inc     hl
f801 cd08f8    call    $f808
f804 d1        pop     de
f805 c3abbb    jp      $bbab				; firmware function: TXT SET M TABLE


f808 e5        push    hl
f809 cd64fc    call    $fc64
f80c eb        ex      de,hl
f80d cdf8f5    call    $f5f8
f810 2a6cae    ld      hl,($ae6c)
f813 09        add     hl,bc
f814 3f        ccf     
f815 dcd8ff    call    c,$ffd8 ; HL=DE?
f818 305b      jr      nc,$f875         ; (+$5b)
f81a 2a5eae    ld      hl,($ae5e) ; HIMEM
f81d eb        ex      de,hl
f81e 37        scf     
f81f ed52      sbc     hl,de
f821 227ab0    ld      ($b07a),hl
f824 e5        push    hl
f825 1165f8    ld      de,$f865
f828 cd93da    call    $da93
f82b c1        pop     bc
f82c 78        ld      a,b
f82d 07        rlca    
f82e 3814      jr      c,$f844          ; (+$14)
f830 b1        or      c
f831 282b      jr      z,$f85e          ; (+$2b)
f833 2a73b0    ld      hl,($b073)
f836 54        ld      d,h
f837 5d        ld      e,l
f838 09        add     hl,bc
f839 e5        push    hl
f83a cdf8f5    call    $f5f8
f83d eb        ex      de,hl
f83e cdf5ff    call    $fff5 ; copy bytes LDDR (BC = count)
f841 e1        pop     hl
f842 1813      jr      $f857            ; (+$13)
f844 2a71b0    ld      hl,($b071)
f847 54        ld      d,h
f848 5d        ld      e,l
f849 09        add     hl,bc
f84a e5        push    hl
f84b cdf8f5    call    $f5f8
f84e eb        ex      de,hl
f84f 23        inc     hl
f850 13        inc     de
f851 cdefff    call    $ffef ; copy bytes LDIR (BC = count)
f854 eb        ex      de,hl
f855 2b        dec     hl
f856 d1        pop     de
f857 2273b0    ld      ($b073),hl
f85a eb        ex      de,hl
f85b 2271b0    ld      ($b071),hl
f85e e1        pop     hl
f85f 2b        dec     hl
f860 225eae    ld      ($ae5e),hl ; HIMEM
f863 23        inc     hl
f864 c9        ret     

f865 2a66ae    ld      hl,($ae66)
f868 cddeff    call    $ffde ; HL=BC?
f86b d0        ret     nc

f86c 2a7ab0    ld      hl,($b07a)
f86f 09        add     hl,bc
f870 eb        ex      de,hl
f871 72        ld      (hl),d
f872 2b        dec     hl
f873 73        ld      (hl),e
f874 c9        ret     

f875 cd45cb    call    $cb45
f878 07        rlca    
;;---------------------------------------------------------------------------
;; get quoted string
f879 23        inc     hl
f87a cda7f8    call    $f8a7
f87d 7e        ld      a,(hl)			; read character
f87e fe22      cp      $22				; double quote?
f880 ca2cde    jp      z,$de2c			; get next token skipping space
f883 b7        or      a				; end of line marker
f884 2831      jr      z,$f8b7          
f886 04        inc     b				; increment number of characters
f887 23        inc     hl				; increment pointer
f888 18f3      jr      $f87d            ; 
;;---------------------------------------------------------------------------

f88a cda7f8    call    $f8a7
f88d 7e        ld      a,(hl)
f88e b7        or      a
f88f c8        ret     z

f890 23        inc     hl
f891 04        inc     b
f892 18f9      jr      $f88d            ; (-$07)
f894 cda7f8    call    $f8a7
f897 4f        ld      c,a
f898 7e        ld      a,(hl)
f899 b7        or      a
f89a 281b      jr      z,$f8b7          ; (+$1b)
f89c b9        cp      c
f89d 2818      jr      z,$f8b7          ; (+$18)
f89f fe2c      cp      $2c
f8a1 2814      jr      z,$f8b7          ; (+$14)
f8a3 23        inc     hl
f8a4 04        inc     b
f8a5 18f1      jr      $f898            ; (-$0f)
f8a7 229db0    ld      ($b09d),hl
f8aa d1        pop     de
f8ab 0600      ld      b,$00
f8ad cdfeff    call    $fffe			; JP (DE)
f8b0 78        ld      a,b
f8b1 329cb0    ld      ($b09c),a
f8b4 c3d6fb    jp      $fbd6
f8b7 e5        push    hl
f8b8 04        inc     b
f8b9 05        dec     b
f8ba 2812      jr      z,$f8ce          ; (+$12)
f8bc 2b        dec     hl
f8bd 7e        ld      a,(hl)
f8be fe20      cp      $20
f8c0 28f7      jr      z,$f8b9          ; (-$09)
f8c2 fe09      cp      $09
f8c4 28f3      jr      z,$f8b9          ; (-$0d)
f8c6 fe0d      cp      $0d
f8c8 28ef      jr      z,$f8b9          ; (-$11)
f8ca fe0a      cp      $0a
f8cc 28eb      jr      z,$f8b9          ; (-$15)
f8ce e1        pop     hl
f8cf c9        ret     

f8d0 cdf5fb    call    $fbf5
f8d3 c8        ret     z

f8d4 1a        ld      a,(de)
f8d5 13        inc     de
f8d6 cdb8c3    call    $c3b8
f8d9 10f9      djnz    $f8d4            ; (-$07)
f8db c9        ret     

f8dc cdf5fb    call    $fbf5
f8df c8        ret     z

f8e0 79        ld      a,c
f8e1 90        sub     b
f8e2 3005      jr      nc,$f8e9         ; (+$05)
f8e4 80        add     a,b
f8e5 2802      jr      z,$f8e9          ; (+$02)
f8e7 47        ld      b,a
f8e8 af        xor     a
f8e9 4f        ld      c,a
f8ea 18e8      jr      $f8d4            ; (-$18)

;;========================================================
;; LOWER$
f8ec 01f1f8    ld      bc,$f8f1
f8ef 180c      jr      $f8fd            ; (+$0c)
f8f1 fe41      cp      $41
f8f3 d8        ret     c

f8f4 fe5b      cp      $5b
f8f6 d0        ret     nc

f8f7 c620      add     a,$20
f8f9 c9        ret     

;;========================================================
;; UPPER$

f8fa 01abff    ld      bc,$ffab
f8fd c5        push    bc
f8fe 2aa0b0    ld      hl,($b0a0)
f901 cdf5fb    call    $fbf5
f904 cd41fc    call    $fc41
f907 23        inc     hl
f908 4e        ld      c,(hl)
f909 23        inc     hl
f90a 66        ld      h,(hl)
f90b 69        ld      l,c
f90c c1        pop     bc
f90d 3c        inc     a
f90e 3d        dec     a
f90f cad6fb    jp      z,$fbd6
f912 f5        push    af
f913 7e        ld      a,(hl)
f914 23        inc     hl
f915 cdfcff    call    $fffc			; JP (BC)
f918 12        ld      (de),a
f919 13        inc     de
f91a f1        pop     af
f91b 18f1      jr      $f90e            ; (-$0f)
f91d ed5ba0b0  ld      de,($b0a0)
f921 1a        ld      a,(de)
f922 86        add     a,(hl)
f923 3004      jr      nc,$f929         ; (+$04)
f925 cd45cb    call    $cb45
f928 0f        rrca    
f929 cd41fc    call    $fc41
f92c cd59f9    call    $f959
f92f d5        push    de
f930 c5        push    bc
f931 48        ld      c,b
f932 cdd6fb    call    $fbd6
f935 79        ld      a,c
f936 cdecff    call    $ffec			;; copy bytes (A=count, HL=source, DE=dest)
f939 c1        pop     bc
f93a e1        pop     hl
f93b 79        ld      a,c
f93c c3ecff    jp      $ffec			;; copy bytes (A=count, HL=source, DE=dest)
f93f cd59f9    call    $f959
f942 af        xor     a
f943 b9        cp      c
f944 280f      jr      z,$f955          ; (+$0f)
f946 b8        cp      b
f947 280a      jr      z,$f953          ; (+$0a)
f949 05        dec     b
f94a 0d        dec     c
f94b 1a        ld      a,(de)
f94c 13        inc     de
f94d 96        sub     (hl)
f94e 23        inc     hl
f94f 28f2      jr      z,$f943          ; (-$0e)
f951 9f        sbc     a,a
f952 c0        ret     nz

f953 3c        inc     a
f954 c9        ret     

f955 b8        cp      b
f956 c8        ret     z

f957 9f        sbc     a,a
f958 c9        ret     

f959 cdf5fb    call    $fbf5
f95c 48        ld      c,b
f95d d5        push    de
f95e cd03fc    call    $fc03
f961 eb        ex      de,hl
f962 d1        pop     de
f963 c9        ret     
;;========================================================================
;; BIN$
f964 010101    ld      bc,$0101
f967 1803      jr      $f96c            ; (+$03)
;;========================================================================
;; HEX$
f969 010f04    ld      bc,$040f
f96c c5        push    bc
f96d cd62cf    call    $cf62
f970 e5        push    hl
f971 cdebfe    call    $feeb
f974 e3        ex      (sp),hl
f975 cd41de    call    $de41
f978 9f        sbc     a,a
f979 dcb8ce    call    c,$ceb8 ; get number and check it's less than 255 
f97c fe11      cp      $11
f97e d24dcb    jp      nc,$cb4d			; Error: Improper Argument
f981 47        ld      b,a
f982 cd1dde    call    $de1d ; check for close bracket
f985 78        ld      a,b
f986 eb        ex      de,hl
f987 e1        pop     hl
f988 c1        pop     bc
f989 d5        push    de
f98a cddff1    call    $f1df
f98d 1831      jr      $f9c0            ; (+$31)
;;========================================================================
;; DEC$
f98f cd62cf    call    $cf62
f992 cd15de    call    $de15 ; check for comma
f995 cd74ff    call    $ff74
f998 cd03cf    call    $cf03
f99b cd1dde    call    $de1d ; check for close bracket
f99e e5        push    hl
f99f 79        ld      a,c
f9a0 cd62f6    call    $f662
f9a3 d5        push    de
f9a4 79        ld      a,c
f9a5 cd6cff    call    $ff6c
f9a8 d1        pop     de
f9a9 78        ld      a,b
f9aa b7        or      a
f9ab c448f4    call    nz,$f448
f9ae d24dcb    jp      nc,$cb4d			; Error: Improper Argument
f9b1 78        ld      a,b
f9b2 b7        or      a
f9b3 c24dcb    jp      nz,$cb4d			; Error: Improper Argument
f9b6 79        ld      a,c
f9b7 cd6aef    call    $ef6a
f9ba 1804      jr      $f9c0            ; (+$04)

;;========================================================
;; STR$

f9bc e5        push    hl
f9bd cd68ef    call    $ef68
f9c0 e5        push    hl
f9c1 0eff      ld      c,$ff
f9c3 af        xor     a
f9c4 0c        inc     c
f9c5 be        cp      (hl)
f9c6 23        inc     hl
f9c7 20fb      jr      nz,$f9c4         ; (-$05)
f9c9 e1        pop     hl
f9ca 79        ld      a,c
f9cb cdd3fb    call    $fbd3
f9ce cdecff    call    $ffec			;; copy bytes (A=count, HL=source, DE=dest)
f9d1 e1        pop     hl
f9d2 c9        ret     

;;========================================================================
;; LEFT$
f9d3 cd43fa    call    $fa43
f9d6 1818      jr      $f9f0            ; (+$18)

;;========================================================================
;; RIGHT$
f9d8 cd43fa    call    $fa43
f9db 1a        ld      a,(de)
f9dc 90        sub     b
f9dd 3811      jr      c,$f9f0          ; (+$11)
f9df 4f        ld      c,a
f9e0 180e      jr      $f9f0            ; (+$0e)
;;=======================================================================
;; MID$
f9e2 cd19de    call    $de19 ; check for open bracket
f9e5 cd43fa    call    $fa43
f9e8 ca4dcb    jp      z,$cb4d			; Error: Improper Argument
f9eb 05        dec     b
f9ec 48        ld      c,b
f9ed cd4ffa    call    $fa4f
;;------------------------------------------------------------------------
f9f0 cd1dde    call    $de1d ; check for close bracket
f9f3 e5        push    hl
f9f4 eb        ex      de,hl
f9f5 cd60fa    call    $fa60
f9f8 cd41fc    call    $fc41
f9fb cd03fc    call    $fc03
f9fe eb        ex      de,hl
f9ff cdd6fb    call    $fbd6
fa02 0600      ld      b,$00
fa04 09        add     hl,bc
fa05 1837      jr      $fa3e            ; (+$37)

;;========================================================================
;; MID$

fa07 cd19de    call    $de19 ; check for open bracket
fa0a cdbfd6    call    $d6bf
fa0d cd5eff    call    $ff5e
fa10 e5        push    hl
fa11 eb        ex      de,hl
fa12 cd58fb    call    $fb58
fa15 e3        ex      (sp),hl
fa16 cd55fa    call    $fa55
fa19 ca4dcb    jp      z,$cb4d			; Error: Improper Argument
fa1c 3d        dec     a
fa1d 4f        ld      c,a
fa1e cd4ffa    call    $fa4f
fa21 cd1dde    call    $de1d ; check for close bracket
fa24 cd21de    call    $de21
fa27 c5        push    bc
fa28 cd03cf    call    $cf03
fa2b 78        ld      a,b
fa2c c1        pop     bc
fa2d e3        ex      (sp),hl
fa2e b8        cp      b
fa2f 3001      jr      nc,$fa32         ; (+$01)
fa31 47        ld      b,a
fa32 cd60fa    call    $fa60
fa35 23        inc     hl
fa36 46        ld      b,(hl)
fa37 23        inc     hl
fa38 66        ld      h,(hl)
fa39 68        ld      l,b
fa3a 0600      ld      b,$00
fa3c 09        add     hl,bc
fa3d eb        ex      de,hl
fa3e cdecff    call    $ffec			;; copy bytes (A=count, HL=source, DE=dest)
fa41 e1        pop     hl
fa42 c9        ret     

fa43 cd09cf    call    $cf09
fa46 eb        ex      de,hl
fa47 2aa0b0    ld      hl,($b0a0)
fa4a eb        ex      de,hl
fa4b 0e00      ld      c,$00
fa4d 1806      jr      $fa55            ; (+$06)
fa4f 06ff      ld      b,$ff
fa51 7e        ld      a,(hl)
fa52 fe29      cp      $29
fa54 c8        ret     z

fa55 d5        push    de
fa56 cd15de    call    $de15 ; check for comma
fa59 cdb8ce    call    $ceb8 ; get number and check it's less than 255 
fa5c 47        ld      b,a
fa5d d1        pop     de
fa5e b7        or      a
fa5f c9        ret     

fa60 7e        ld      a,(hl)
fa61 91        sub     c
fa62 3001      jr      nc,$fa65         ; (+$01)
fa64 af        xor     a
fa65 b8        cp      b
fa66 d8        ret     c

fa67 78        ld      a,b
fa68 c9        ret     

;;========================================================
;; LEN

fa69 cdf5fb    call    $fbf5
fa6c 1803      jr      $fa71            ; (+$03)

;;========================================================
;; ASC

fa6e cda6fa    call    $faa6
fa71 c332ff    jp      $ff32

;; CHR$
;;========================================================

fa74 cdd9fa    call    $fad9
fa77 37        scf     

fa78 4f        ld      c,a
fa79 9f        sbc     a,a
fa7a e601      and     $01
fa7c 1834      jr      $fab2            ; (+$34)

;;----------------------------------------------
;; INKEY$

fa7e cd6fc4    call    $c46f			; call to firmware function: km read key			
fa81 30f5      jr      nc,$fa78         ; 
fa83 fefc      cp      $fc				
fa85 28f1      jr      z,$fa78          
fa87 feef      cp      $ef
fa89 28ed      jr      z,$fa78          ; (-$13)
fa8b 18ea      jr      $fa77            ; (-$16)

;;========================================================================
;; STRING$

fa8d cdb8ce    call    $ceb8 ; get number and check it's less than 255 
fa90 f5        push    af
fa91 cd15de    call    $de15 ; check for comma
fa94 cd62cf    call    $cf62
fa97 cd1dde    call    $de1d ; check for close bracket
fa9a cda1fa    call    $faa1
fa9d 4f        ld      c,a
fa9e f1        pop     af
fa9f 1811      jr      $fab2            ; (+$11)
faa1 cd66ff    call    $ff66
faa4 2033      jr      nz,$fad9         ; (+$33)
faa6 cdf5fb    call    $fbf5
faa9 2837      jr      z,$fae2          ; (+$37)
faab 1a        ld      a,(de)
faac c9        ret     

;;========================================================
;; SPACE$

faad cdd9fa    call    $fad9
fab0 0e20      ld      c,$20
fab2 47        ld      b,a
fab3 cdd3fb    call    $fbd3
fab6 79        ld      a,c
fab7 04        inc     b
fab8 05        dec     b
fab9 c8        ret     z

faba 12        ld      (de),a
fabb 13        inc     de
fabc 18fa      jr      $fab8            ; (-$06)

;;========================================================
;; VAL

fabe cdf5fb    call    $fbf5
fac1 ca32ff    jp      z,$ff32
fac4 eb        ex      de,hl
fac5 e5        push    hl
fac6 5f        ld      e,a
fac7 1600      ld      d,$00
fac9 19        add     hl,de
faca 5e        ld      e,(hl)
facb 72        ld      (hl),d
facc e3        ex      (sp),hl
facd d5        push    de
face cd6fed    call    $ed6f
fad1 d1        pop     de
fad2 e1        pop     hl
fad3 73        ld      (hl),e
fad4 d8        ret     c

fad5 cd45cb    call    $cb45
fad8 0d        dec     c
fad9 e5        push    hl
fada cdb6fe    call    $feb6
fadd 7c        ld      a,h
fade b7        or      a
fadf 7d        ld      a,l
fae0 e1        pop     hl
fae1 c8        ret     z

fae2 c34dcb    jp      $cb4d			; Error: Improper Argument
;;========================================================================
;; INSTR$
fae5 cd62cf    call    $cf62
fae8 cd66ff    call    $ff66
faeb 0e01      ld      c,$01
faed 280e      jr      z,$fafd          ; (+$0e)
faef cdd9fa    call    $fad9
faf2 b7        or      a
faf3 ca4dcb    jp      z,$cb4d			; Error: Improper Argument
faf6 4f        ld      c,a
faf7 cd15de    call    $de15 ; check for comma
fafa cd09cf    call    $cf09
fafd cd15de    call    $de15 ; check for comma
fb00 e5        push    hl
fb01 2aa0b0    ld      hl,($b0a0)
fb04 e3        ex      (sp),hl
fb05 cd03cf    call    $cf03
fb08 cd1dde    call    $de1d ; check for close bracket
fb0b e3        ex      (sp),hl
fb0c 79        ld      a,c
fb0d 48        ld      c,b
fb0e d5        push    de
fb0f f5        push    af
fb10 cd03fc    call    $fc03
fb13 eb        ex      de,hl
fb14 f1        pop     af
fb15 5f        ld      e,a
fb16 1600      ld      d,$00
fb18 19        add     hl,de
fb19 2b        dec     hl
fb1a 78        ld      a,b
fb1b 93        sub     e
fb1c 3c        inc     a
fb1d 47        ld      b,a
fb1e 7b        ld      a,e
fb1f d1        pop     de
fb20 3825      jr      c,$fb47          ; (+$25)
fb22 0c        inc     c
fb23 0d        dec     c
fb24 2822      jr      z,$fb48          ; (+$22)
fb26 f5        push    af
fb27 78        ld      a,b
fb28 b9        cp      c
fb29 381b      jr      c,$fb46          ; (+$1b)
fb2b e5        push    hl
fb2c d5        push    de
fb2d c5        push    bc
fb2e 1a        ld      a,(de)
fb2f be        cp      (hl)
fb30 200b      jr      nz,$fb3d         ; (+$0b)
fb32 23        inc     hl
fb33 13        inc     de
fb34 0d        dec     c
fb35 20f7      jr      nz,$fb2e         ; (-$09)
fb37 c1        pop     bc
fb38 d1        pop     de
fb39 e1        pop     hl
fb3a f1        pop     af
fb3b 180b      jr      $fb48            ; (+$0b)
fb3d c1        pop     bc
fb3e d1        pop     de
fb3f e1        pop     hl
fb40 f1        pop     af
fb41 3c        inc     a
fb42 23        inc     hl
fb43 05        dec     b
fb44 18e0      jr      $fb26            ; (-$20)
fb46 f1        pop     af
fb47 af        xor     a
fb48 cd32ff    call    $ff32
fb4b e1        pop     hl
fb4c c9        ret     

fb4d d5        push    de
fb4e e5        push    hl
fb4f 1165fb    ld      de,$fb65
fb52 cd93da    call    $da93
fb55 e1        pop     hl
fb56 d1        pop     de
fb57 c9        ret     

fb58 e5        push    hl
fb59 7e        ld      a,(hl)
fb5a 23        inc     hl
fb5b 4e        ld      c,(hl)
fb5c 23        inc     hl
fb5d 46        ld      b,(hl)
fb5e eb        ex      de,hl
fb5f b7        or      a
fb60 c465fb    call    nz,$fb65
fb63 e1        pop     hl
fb64 c9        ret     

fb65 2a71b0    ld      hl,($b071)
fb68 cddeff    call    $ffde ; HL=BC?
fb6b 3007      jr      nc,$fb74         ; (+$07)
fb6d 2a73b0    ld      hl,($b073)
fb70 cddeff    call    $ffde ; HL=BC?
fb73 d0        ret     nc

fb74 eb        ex      de,hl
fb75 2b        dec     hl
fb76 2b        dec     hl
fb77 e5        push    hl
fb78 cdb9fb    call    $fbb9
fb7b e1        pop     hl
fb7c 3a9cb0    ld      a,($b09c)
fb7f 77        ld      (hl),a
fb80 23        inc     hl
fb81 ed5b9db0  ld      de,($b09d)
fb85 73        ld      (hl),e
fb86 23        inc     hl
fb87 72        ld      (hl),d
fb88 23        inc     hl
fb89 c9        ret     

fb8a cd37fc    call    $fc37
fb8d d8        ret     c

fb8e cdb9fb    call    $fbb9
fb91 c3d6fb    jp      $fbd6
fb94 2aa0b0    ld      hl,($b0a0)
fb97 cd1ffc    call    $fc1f
fb9a 78        ld      a,b
fb9b b7        or      a
fb9c c8        ret     z

fb9d e5        push    hl
fb9e 2a64ae    ld      hl,($ae64)
fba1 cdd8ff    call    $ffd8 ; HL=DE?
fba4 2a73b0    ld      hl,($b073)
fba7 eb        ex      de,hl
fba8 dcd8ff    call    c,$ffd8 ; HL=DE?
fbab 300a      jr      nc,$fbb7         ; (+$0a)
fbad ed5b66ae  ld      de,($ae66)
fbb1 cdd8ff    call    $ffd8 ; HL=DE?
fbb4 d437fc    call    nc,$fc37
fbb7 e1        pop     hl
fbb8 d8        ret     c

fbb9 7e        ld      a,(hl)
fbba cd41fc    call    $fc41
fbbd d5        push    de
fbbe 7e        ld      a,(hl)
fbbf 23        inc     hl
fbc0 4e        ld      c,(hl)
fbc1 23        inc     hl
fbc2 66        ld      h,(hl)
fbc3 69        ld      l,c
fbc4 cdecff    call    $ffec			;; copy bytes (A=count, HL=source, DE=dest)
fbc7 d1        pop     de
fbc8 219cb0    ld      hl,$b09c
fbcb c9        ret     

fbcc 217eb0    ld      hl,$b07e
fbcf 227cb0    ld      ($b07c),hl
fbd2 c9        ret     

fbd3 cd41fc    call    $fc41
fbd6 e5        push    hl
fbd7 3e03      ld      a,$03
fbd9 329fb0    ld      ($b09f),a
fbdc 2a7cb0    ld      hl,($b07c)
fbdf 22a0b0    ld      ($b0a0),hl
fbe2 119cb0    ld      de,$b09c
fbe5 cdd8ff    call    $ffd8 ; HL=DE?
fbe8 3e10      ld      a,$10
fbea ca55cb    jp      z,$cb55
fbed cd7cfb    call    $fb7c
fbf0 227cb0    ld      ($b07c),hl
fbf3 e1        pop     hl
fbf4 c9        ret     

fbf5 e5        push    hl
fbf6 cd5eff    call    $ff5e
fbf9 2aa0b0    ld      hl,($b0a0)
fbfc cd03fc    call    $fc03
fbff e1        pop     hl
fc00 78        ld      a,b
fc01 b7        or      a
fc02 c9        ret     

fc03 cd1ffc    call    $fc1f
fc06 c0        ret     nz

fc07 78        ld      a,b
fc08 b7        or      a
fc09 c8        ret     z

fc0a 2a71b0    ld      hl,($b071)
fc0d 23        inc     hl
fc0e 23        inc     hl
fc0f 23        inc     hl
fc10 cdd8ff    call    $ffd8 ; HL=DE?
fc13 c0        ret     nz

fc14 2b        dec     hl
fc15 2b        dec     hl
fc16 6e        ld      l,(hl)
fc17 2600      ld      h,$00
fc19 19        add     hl,de
fc1a 2b        dec     hl
fc1b 2271b0    ld      ($b071),hl
fc1e c9        ret     

fc1f e5        push    hl
fc20 ed5b7cb0  ld      de,($b07c)
fc24 1b        dec     de
fc25 1b        dec     de
fc26 1b        dec     de
fc27 cdd8ff    call    $ffd8 ; HL=DE?
fc2a 2004      jr      nz,$fc30         ; (+$04)
fc2c ed537cb0  ld      ($b07c),de
fc30 46        ld      b,(hl)
fc31 23        inc     hl
fc32 5e        ld      e,(hl)
fc33 23        inc     hl
fc34 56        ld      d,(hl)
fc35 e1        pop     hl
fc36 c9        ret     

fc37 2aa0b0    ld      hl,($b0a0)
fc3a 3e7d      ld      a,$7d
fc3c 95        sub     l
fc3d 3eb0      ld      a,$b0
fc3f 9c        sbc     a,h
fc40 c9        ret     

fc41 e5        push    hl
fc42 c5        push    bc
fc43 4f        ld      c,a
fc44 b7        or      a
fc45 c493f6    call    nz,$f693
fc48 79        ld      a,c
fc49 329cb0    ld      ($b09c),a
fc4c 229db0    ld      ($b09d),hl
fc4f eb        ex      de,hl
fc50 c1        pop     bc
fc51 e1        pop     hl
fc52 c9        ret     

;;========================================================
;; FRE
fc53 cd66ff    call    $ff66
fc56 2006      jr      nz,$fc5e         ; (+$06)
fc58 cdf5fb    call    $fbf5
fc5b cd64fc    call    $fc64
fc5e cdfcf6    call    $f6fc
fc61 c389fe    jp      $fe89
fc64 e5        push    hl
fc65 d5        push    de
fc66 c5        push    bc
fc67 217eb0    ld      hl,$b07e
fc6a 180c      jr      $fc78            ; (+$0c)
fc6c 7e        ld      a,(hl)
fc6d 23        inc     hl
fc6e 4e        ld      c,(hl)
fc6f 23        inc     hl
fc70 46        ld      b,(hl)
fc71 eb        ex      de,hl
fc72 b7        or      a
fc73 c4e3fc    call    nz,$fce3
fc76 eb        ex      de,hl
fc77 23        inc     hl
fc78 ed5b7cb0  ld      de,($b07c)
fc7c cdd8ff    call    $ffd8 ; HL=DE?
fc7f 20eb      jr      nz,$fc6c         ; (-$15)
fc81 11e3fc    ld      de,$fce3
fc84 cd93da    call    $da93
fc87 2a73b0    ld      hl,($b073)
fc8a e5        push    hl
fc8b 2a71b0    ld      hl,($b071)
fc8e 23        inc     hl
fc8f 5d        ld      e,l
fc90 54        ld      d,h
fc91 1814      jr      $fca7            ; (+$14)
fc93 4e        ld      c,(hl)
fc94 23        inc     hl
fc95 46        ld      b,(hl)
fc96 04        inc     b
fc97 05        dec     b
fc98 280b      jr      z,$fca5          ; (+$0b)
fc9a 2b        dec     hl
fc9b 0a        ld      a,(bc)
fc9c 4f        ld      c,a
fc9d 0600      ld      b,$00
fc9f 03        inc     bc
fca0 03        inc     bc
fca1 edb0      ldir    
fca3 1802      jr      $fca7            ; (+$02)
fca5 23        inc     hl
fca6 09        add     hl,bc
fca7 c1        pop     bc
fca8 c5        push    bc
fca9 cddeff    call    $ffde ; HL=BC?
fcac 38e5      jr      c,$fc93          ; (-$1b)
fcae 1b        dec     de
fcaf 2a71b0    ld      hl,($b071)
fcb2 eb        ex      de,hl
fcb3 cde4ff    call    $ffe4			; BC = HL-DE
fcb6 d1        pop     de
fcb7 cdd8ff    call    $ffd8 ; HL=DE?
fcba f5        push    af
fcbb d5        push    de
fcbc cdf5ff    call    $fff5 ; copy bytes LDDR (BC = count)
fcbf eb        ex      de,hl
fcc0 2271b0    ld      ($b071),hl
fcc3 c1        pop     bc
fcc4 23        inc     hl
fcc5 1812      jr      $fcd9            ; (+$12)
fcc7 5e        ld      e,(hl)
fcc8 23        inc     hl
fcc9 56        ld      d,(hl)
fcca 2b        dec     hl
fccb 1a        ld      a,(de)
fccc 77        ld      (hl),a
fccd 23        inc     hl
fcce 3600      ld      (hl),$00
fcd0 23        inc     hl
fcd1 eb        ex      de,hl
fcd2 72        ld      (hl),d
fcd3 2b        dec     hl
fcd4 73        ld      (hl),e
fcd5 6f        ld      l,a
fcd6 2600      ld      h,$00
fcd8 19        add     hl,de
fcd9 cddeff    call    $ffde ; HL=BC?
fcdc 38e9      jr      c,$fcc7          ; (-$17)
fcde f1        pop     af
fcdf c1        pop     bc
fce0 d1        pop     de
fce1 e1        pop     hl
fce2 c9        ret     

fce3 2a6cae    ld      hl,($ae6c)
fce6 cddeff    call    $ffde ; HL=BC?
fce9 d0        ret     nc

fcea 0b        dec     bc
fceb 7a        ld      a,d
fcec 02        ld      (bc),a
fced 0b        dec     bc
fcee 0a        ld      a,(bc)
fcef 12        ld      (de),a
fcf0 7b        ld      a,e
fcf1 02        ld      (bc),a
fcf2 c9        ret     

fcf3 cd4fff    call    $ff4f
fcf6 d276bd    jp      nc,$bd76
fcf9 cd2add    call    $dd2a
fcfc 22a0b0    ld      ($b0a0),hl
fcff 21a1b0    ld      hl,$b0a1
fd02 c9        ret     

fd03 cdebfe    call    $feeb
fd06 21a1b0    ld      hl,$b0a1
fd09 c330dd    jp      $dd30
fd0c cd3bfe    call    $fe3b
fd0f 3009      jr      nc,$fd1a         ; (+$09)
fd11 cd4add    call    $dd4a
fd14 da35ff    jp      c,$ff35
fd17 cd78fe    call    $fe78
fd1a cd7cbd    call    $bd7c
fd1d d8        ret     c

fd1e c3becb    jp      $cbbe
fd21 cd3bfe    call    $fe3b
fd24 3009      jr      nc,$fd2f         ; (+$09)
fd26 cd52dd    call    $dd52
fd29 da35ff    jp      c,$ff35
fd2c cd78fe    call    $fe78
fd2f cd82bd    call    $bd82
fd32 d8        ret     c

fd33 18e9      jr      $fd1e            ; (-$17)
fd35 cd3bfe    call    $fe3b
fd38 3009      jr      nc,$fd43         ; (+$09)
fd3a cd5bdd    call    $dd5b
fd3d da35ff    jp      c,$ff35
fd40 cd78fe    call    $fe78
fd43 cd85bd    call    $bd85
fd46 d8        ret     c

fd47 18d5      jr      $fd1e            ; (-$2b)
fd49 cd3bfe    call    $fe3b
fd4c da02de    jp      c,$de02
fd4f c38ebd    jp      $bd8e
fd52 cd70fe    call    $fe70
fd55 eb        ex      de,hl
fd56 d5        push    de
fd57 cd88bd    call    $bd88
fd5a d1        pop     de
fd5b 010500    ld      bc,$0005
fd5e edb0      ldir    
fd60 d8        ret     c

fd61 cab5cb    jp      z,$cbb5
fd64 c3becb    jp      $cbbe
fd67 cdc3fe    call    $fec3
fd6a eb        ex      de,hl
fd6b cd9cdd    call    $dd9c
fd6e da35ff    jp      c,$ff35
fd71 2810      jr      z,$fd83          ; (+$10)
fd73 210080    ld      hl,$8000
fd76 c389fe    jp      $fe89
fd79 cdc3fe    call    $fec3
fd7c eb        ex      de,hl
fd7d cda3dd    call    $dda3
fd80 da35ff    jp      c,$ff35
fd83 cd45cb    call    $cb45
fd86 0b        dec     bc
fd87 cdc3fe    call    $fec3
fd8a 7b        ld      a,e
fd8b a5        and     l
fd8c 6f        ld      l,a
fd8d 7c        ld      a,h
fd8e a2        and     d
fd8f c334ff    jp      $ff34
fd92 cdc3fe    call    $fec3
fd95 7b        ld      a,e
fd96 b5        or      l
fd97 6f        ld      l,a
fd98 7a        ld      a,d
fd99 b4        or      h
fd9a 18f3      jr      $fd8f            ; (-$0d)
fd9c cdc3fe    call    $fec3
fd9f 7b        ld      a,e
fda0 ad        xor     l
fda1 6f        ld      l,a
fda2 7c        ld      a,h
fda3 aa        xor     d
fda4 18e9      jr      $fd8f            ; (-$17)
fda6 cdb6fe    call    $feb6
fda9 7d        ld      a,l
fdaa 2f        cpl     
fdab 6f        ld      l,a
fdac 7c        ld      a,h
fdad 2f        cpl     
fdae 18df      jr      $fd8f            ; (-$21)

;;========================================================
;; ABS
fdb0 cdc4fd    call    $fdc4
fdb3 f0        ret     p

fdb4 cd4fff    call    $ff4f
fdb7 d291bd    jp      nc,$bd91
fdba cdeddd    call    $dded
fdbd 22a0b0    ld      ($b0a0),hl
fdc0 d489fe    call    nc,$fe89
fdc3 c9        ret     

fdc4 c5        push    bc
fdc5 e5        push    hl
fdc6 cdccfd    call    $fdcc
fdc9 e1        pop     hl
fdca c1        pop     bc
fdcb c9        ret     

fdcc cd4fff    call    $ff4f
fdcf daf9dd    jp      c,$ddf9
fdd2 c394bd    jp      $bd94
fdd5 e5        push    hl
fdd6 79        ld      a,c
fdd7 cd6cff    call    $ff6c
fdda d1        pop     de
fddb cd4fff    call    $ff4f
fdde 78        ld      a,b
fddf 300b      jr      nc,$fdec         ; (+$0b)
fde1 b7        or      a
fde2 f0        ret     p

fde3 cd93fe    call    $fe93
fde6 cdf4fd    call    $fdf4
fde9 c3b6fe    jp      $feb6
fdec b7        or      a
fded 2005      jr      nz,$fdf4         ; (+$05)
fdef 116dbd    ld      de,$bd6d
fdf2 1826      jr      $fe1a            ; (+$26)
fdf4 d5        push    de
fdf5 c5        push    bc
fdf6 78        ld      a,b
fdf7 cd79bd    call    $bd79
fdfa dc6dbd    call    c,$bd6d
fdfd 78        ld      a,b
fdfe c1        pop     bc
fdff d1        pop     de
fe00 3008      jr      nc,$fe0a         ; (+$08)
fe02 cd67bd    call    $bd67
fe05 af        xor     a
fe06 90        sub     b
fe07 c379bd    jp      $bd79
fe0a eb        ex      de,hl
fe0b c36fff    jp      $ff6f

;;========================================================
;; FIX
fe0e 1170bd    ld      de,$bd70
fe11 1803      jr      $fe16            ; (+$03)

;;========================================================
;; INT
fe13 1173bd    ld      de,$bd73
fe16 cd4fff    call    $ff4f
fe19 d8        ret     c

fe1a cdfeff    call    $fffe			; JP (DE)
fe1d d0        ret     nc

fe1e 3a9fb0    ld      a,($b09f)
fe21 cd2cfe    call    $fe2c
fe24 d8        ret     c

fe25 cd45ff    call    $ff45
fe28 78        ld      a,b
fe29 c367bd    jp      $bd67
fe2c 79        ld      a,c
fe2d fe03      cp      $03
fe2f d0        ret     nc

fe30 7e        ld      a,(hl)
fe31 23        inc     hl
fe32 66        ld      h,(hl)
fe33 6f        ld      l,a
fe34 cd37dd    call    $dd37
fe37 d0        ret     nc

fe38 c335ff    jp      $ff35
fe3b 79        ld      a,c
fe3c fe03      cp      $03
fe3e 282d      jr      z,$fe6d          ; (+$2d)
fe40 3a9fb0    ld      a,($b09f)
fe43 fe03      cp      $03
fe45 2826      jr      z,$fe6d          ; (+$26)
fe47 b9        cp      c
fe48 2817      jr      z,$fe61          ; (+$17)
fe4a 300c      jr      nc,$fe58         ; (+$0c)
fe4c e5        push    hl
fe4d 219fb0    ld      hl,$b09f
fe50 71        ld      (hl),c
fe51 23        inc     hl
fe52 cd8cfe    call    $fe8c
fe55 d1        pop     de
fe56 b7        or      a
fe57 c9        ret     

fe58 cd8cfe    call    $fe8c
fe5b b7        or      a
fe5c eb        ex      de,hl
fe5d 21a0b0    ld      hl,$b0a0
fe60 c9        ret     

fe61 ee02      xor     $02
fe63 20f7      jr      nz,$fe5c         ; (-$09)
fe65 5e        ld      e,(hl)
fe66 23        inc     hl
fe67 56        ld      d,(hl)
fe68 2aa0b0    ld      hl,($b0a0)
fe6b 37        scf     
fe6c c9        ret     

fe6d c362ff    jp      $ff62
fe70 3a9fb0    ld      a,($b09f)
fe73 b1        or      c
fe74 fe02      cp      $02
fe76 20c3      jr      nz,$fe3b         ; (-$3d)
fe78 2aa0b0    ld      hl,($b0a0)
fe7b cd93fe    call    $fe93
fe7e 2a6fb0    ld      hl,($b06f)
fe81 cd8cfe    call    $fe8c
fe84 eb        ex      de,hl
fe85 21a0b0    ld      hl,$b0a0
fe88 c9        ret     

fe89 af        xor     a
fe8a 1808      jr      $fe94            ; (+$08)
fe8c 5e        ld      e,(hl)
fe8d 23        inc     hl
fe8e 56        ld      d,(hl)
fe8f 2b        dec     hl
fe90 7a        ld      a,d
fe91 1808      jr      $fe9b            ; (+$08)
fe93 7c        ld      a,h
fe94 eb        ex      de,hl
fe95 219fb0    ld      hl,$b09f
fe98 3605      ld      (hl),$05
fe9a 23        inc     hl
fe9b eb        ex      de,hl
fe9c f5        push    af
fe9d b7        or      a
fe9e fceddd    call    m,$dded
fea1 f1        pop     af
fea2 c364bd    jp      $bd64
fea5 22a0b0    ld      ($b0a0),hl
fea8 eb        ex      de,hl
fea9 22a2b0    ld      ($b0a2),hl
feac 219fb0    ld      hl,$b09f
feaf 3605      ld      (hl),$05
feb1 23        inc     hl
feb2 af        xor     a
feb3 c367bd    jp      $bd67

;;========================================================
;; CINT
feb6 cdbcfe    call    $febc
feb9 d8        ret     c

feba 183f      jr      $fefb            ; (+$3f)
febc cdcefe    call    $fece
febf 22a0b0    ld      ($b0a0),hl
fec2 c9        ret     

fec3 79        ld      a,c
fec4 cdd5fe    call    $fed5
fec7 eb        ex      de,hl
fec8 dccefe    call    c,$fece
fecb d8        ret     c

fecc 182d      jr      $fefb            ; (+$2d)
fece 219fb0    ld      hl,$b09f
fed1 7e        ld      a,(hl)
fed2 3602      ld      (hl),$02
fed4 23        inc     hl
fed5 fe03      cp      $03
fed7 380d      jr      c,$fee6          ; (+$0d)
fed9 ca62ff    jp      z,$ff62
fedc c5        push    bc
fedd cd6abd    call    $bd6a
fee0 47        ld      b,a
fee1 dc37dd    call    c,$dd37
fee4 c1        pop     bc
fee5 c9        ret     

fee6 7e        ld      a,(hl)
fee7 23        inc     hl
fee8 66        ld      h,(hl)
fee9 6f        ld      l,a
feea c9        ret     

;;========================================================
;; UNT

feeb cd4fff    call    $ff4f
feee d8        ret     c

feef cd6abd    call    $bd6a
fef2 3007      jr      nc,$fefb         ; (+$07)
fef4 47        ld      b,a
fef5 fc37dd    call    m,$dd37
fef8 da35ff    jp      c,$ff35
fefb cd45cb    call    $cb45
fefe 06e5      ld      b,$e5
ff00 d5        push    de
ff01 c5        push    bc
ff02 219fb0    ld      hl,$b09f
ff05 be        cp      (hl)
ff06 c40dff    call    nz,$ff0d
ff09 c1        pop     bc
ff0a d1        pop     de
ff0b e1        pop     hl
ff0c c9        ret     

ff0d d603      sub     $03
ff0f 38a5      jr      c,$feb6          ; (-$5b)
ff11 ca5eff    jp      z,$ff5e

;;========================================================
;; CREAL
ff14 cd4fff    call    $ff4f
ff17 da93fe    jp      c,$fe93
ff1a c9        ret     

ff1b e5        push    hl
ff1c 210000    ld      hl,$0000
ff1f 22a0b0    ld      ($b0a0),hl
ff22 22a2b0    ld      ($b0a2),hl
ff25 22a3b0    ld      ($b0a3),hl
ff28 e1        pop     hl
ff29 c9        ret     

;;========================================================
;; SGN
ff2a cdc4fd    call    $fdc4
ff2d 6f        ld      l,a
ff2e 87        add     a,a
ff2f 9f        sbc     a,a
ff30 1802      jr      $ff34            ; (+$02)
ff32 6f        ld      l,a
ff33 af        xor     a
ff34 67        ld      h,a

ff35 22a0b0    ld      ($b0a0),hl
ff38 3e02      ld      a,$02
ff3a 329fb0    ld      ($b09f),a
ff3d c9        ret     

ff3e 21a0b0    ld      hl,$b0a0
ff41 3e05      ld      a,$05
ff43 18f5      jr      $ff3a            ; (-$0b)
ff45 219fb0    ld      hl,$b09f
ff48 4e        ld      c,(hl)
ff49 23        inc     hl
ff4a c9        ret     

ff4b 3a9fb0    ld      a,($b09f)
ff4e c9        ret     

ff4f 3a9fb0    ld      a,($b09f)
ff52 fe03      cp      $03
ff54 280c      jr      z,$ff62          ; (+$0c)
ff56 2aa0b0    ld      hl,($b0a0)
ff59 d8        ret     c

ff5a 21a0b0    ld      hl,$b0a0
ff5d c9        ret     

ff5e cd66ff    call    $ff66
ff61 c8        ret     z

ff62 cd45cb    call    $cb45
ff65 0d        dec     c
ff66 3a9fb0    ld      a,($b09f)
ff69 fe03      cp      $03
ff6b c9        ret     

ff6c 329fb0    ld      ($b09f),a
ff6f 11a0b0    ld      de,$b0a0
ff72 1813      jr      $ff87            ; (+$13)

ff74 d5        push    de
ff75 e5        push    hl
ff76 3a9fb0    ld      a,($b09f)
ff79 4f        ld      c,a
ff7a cd72f6    call    $f672
ff7d cd83ff    call    $ff83
ff80 e1        pop     hl
ff81 d1        pop     de
ff82 c9        ret     

ff83 eb        ex      de,hl
ff84 21a0b0    ld      hl,$b0a0

ff87 c5        push    bc
ff88 3a9fb0    ld      a,($b09f)
ff8b 4f        ld      c,a
ff8c 0600      ld      b,$00
ff8e edb0      ldir    
ff90 c1        pop     bc
ff91 c9        ret     

;;--------------------------------------------------------
;; test if character is a alphabetical symbol

ff92 cdabff    call    $ffab			;; convert character to upper case

ff95 fe41      cp      $41				;; 'A'
ff97 3f        ccf     
ff98 d0        ret     nc
ff99 fe5b      cp      $5b				;; 'Z'+1
ff9b c9        ret     

;;--------------------------------------------------------

ff9c cd92ff    call    $ff92			; is a alphabetical letter?
ff9f d8        ret     c

ffa0 fe2e      cp      $2e				; '.'
ffa2 37        scf     
ffa3 c8        ret     z

;;--------------------------------------------------------
;; test if ASCII character represents a decimal number digit
;;
;; entry:
;; A = character
;; exit:
;; carry clear = not a digit
;; carry set = is a digit

ffa4 fe30      cp      $30			; '0'
ffa6 3f        ccf     
ffa7 d0        ret     nc
ffa8 fe3a      cp      $3a			; '9'+1
ffaa c9        ret     

;;========================================================
;; convert character to upper case

ffab fe61      cp      $61
ffad d8        ret     c

ffae fe7b      cp      $7b
ffb0 d0        ret     nc

ffb1 d620      sub     $20
ffb3 c9        ret     

;;=========================================================
;; HL = address of table
;; A = code to find in table
;;
;; table header:
;; 0: count
;; 1,2: address

;; each entry in table:
;; offset 0: code
;; offset 1,2: address

ffb4 f5        push    af
ffb5 c5        push    bc
;;-----------------------------------------------
ffb6 46        ld      b,(hl)			; count in table
ffb7 23        inc     hl


ffb8 e5        push    hl


ffb9 23        inc     hl				
ffba 23        inc     hl
ffbb be        cp      (hl)				; code = comparison
ffbc 23        inc     hl
ffbd 2803      jr      z,$ffc2          ; code found?

ffbf 10f8      djnz    $ffb9            ; 

;;-----------------------------------------------
;; code not found
;;
;; get address from start of table; putting address of end of table onto stack
ffc1 e3        ex      (sp),hl
;;-----------------------------------------------
;; code found or not found

ffc2 f1        pop     af

;; get address from table
ffc3 7e        ld      a,(hl)
ffc4 23        inc     hl
ffc5 66        ld      h,(hl)
ffc6 6f        ld      l,a
;;-----------------------------------------------
ffc7 c1        pop     bc
ffc8 f1        pop     af
ffc9 c9        ret     

;;--------------------------------------------------------------
;; check if byte exists in table 
;;
;; HL = base address of table (table terminated with 0)
;; A = value
;;
;; carry set = byte exists in table
;; carry clear = byte doesn't exist
;; All other registers preserved

ffca c5        push    bc
ffcb 4f        ld      c,a				;; C = byte to compare against

ffcc 7e        ld      a,(hl)			;; get byte from table
;; table terminator?
ffcd b7        or      a
ffce 2805      jr      z,$ffd5          
ffd0 23        inc     hl
;; same as byte we want
ffd1 b9        cp      c
ffd2 20f8      jr      nz,$ffcc         ; (-$08)
;; byte found in table
ffd4 37        scf    
;; byte found or not found 
ffd5 79        ld      a,c
ffd6 c1        pop     bc
ffd7 c9        ret     

;;--------------------------------------------------------------
;; HL=DE
ffd8 7c        ld      a,h
ffd9 92        sub     d
ffda c0        ret     nz
ffdb 7d        ld      a,l
ffdc 93        sub     e
ffdd c9        ret     
;;--------------------------------------------------------------
;; HL=BC
ffde 7c        ld      a,h
ffdf 90        sub     b
ffe0 c0        ret     nz
ffe1 7d        ld      a,l
ffe2 91        sub     c
ffe3 c9        ret     
;;--------------------------------------------------------------
;; BC = HL-DE
;;
;; HL,DE preserved
;; flags corrupt

ffe4 e5        push    hl				;; store HL
ffe5 b7        or      a
ffe6 ed52      sbc     hl,de			;; HL = HL - DE
ffe8 44        ld      b,h				;; BC = HL - DE
ffe9 4d        ld      c,l
ffea e1        pop     hl				;; restore HL
ffeb c9        ret     

;;--------------------------------------------------------------
;; copy bytes LDIR  (A=count, HL=source, DE=dest)
;;
;; HL = source
;; DE = destination
;; A = count

ffec 4f        ld      c,a
ffed 0600      ld      b,$00
;; BC = count

;;--------------------------------------------------------------
;; copy bytes LDIR (BC=count, HL=source, DE=dest)
;; BC=0?
ffef 78        ld      a,b
fff0 b1        or      c
fff1 c8        ret     z

;; copy if BC<>0
fff2 edb0      ldir    
fff4 c9        ret     
;;--------------------------------------------------------------

;;--------------------------------------------------------------
;; copy bytes (A=count, HL=source, DE=dest)
;; BC=0?
fff5 78        ld      a,b
fff6 b1        or      c
fff7 c8        ret     z
;; copy if BC<>0
fff8 edb8      lddr    
fffa c9        ret     
;;--------------------------------------------------------------
;; JP (HL)
fffb e9        jp      (hl)
;;--------------------------------------------------------------
;; JP (BC)
fffc c5        push    bc
fffd c9        ret     
;;--------------------------------------------------------------
;; JP (DE)
fffe d5        push    de
ffff c9        ret     
;;--------------------------------------------------------------

