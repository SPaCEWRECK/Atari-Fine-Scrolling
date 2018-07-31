05 ;
10 ;
20 ;HELLO SCREEN (FINE)
30 ;
40  *=$3000
50  JMP INIT
60 ;
70 TCKPTR=$2000
80 FSCPTR=TCKPTR+1
90 ;
0100 SDMCTL=$022F
0110 ;
0120 SDLSTL=$0230
0130 SDLSTH=$0231
0140 ;
0150 COLOR0=$02C4;OS COLOR  REGISTERS
0160 COLOR1=$02C5
0170 COLOR2=$02C6
0180 COLOR3=$02C7
0190 COLOR4=$02C8
0299 ;
0210 HSCROL=$D404
0220 ;
0230 VVBLKI=$0222; OS INTERRUPT VECTOR
0240 SYSVBV=$E45F; INTERRUPT ENABLE VECOTR
0250 ;
0260 SETVBV=$E45C; SET VERTICAL BLANK INTERRUPT (VBI) VECTOR
0270 XITVBV=$E462; EXIT VBI VECTOR
0280 ;
0290 ; DISPLAY LIST DATA
0300 ;
0310 START
0320 LINE1 .SBYTE "   PRESENTING   "
0330 LINE2 .SBYTE "                "
0340  .SBYTE "  the big program  "
0350  .SBYTE "                   "
0360 LINE3 .SBYTE "            By (You"
0370  .SBYTE "r Name)            "
0380 LINE4 .SBYTE "PLEASE STAND BY  "
0390 ;
0400 ; DISPLAY LIST WITH SCROLLING LINE
0410 ;
0420 HLIST ;('HELLO' LIST)
0430  .BYTE $70, $70, $70
0440  .BYTE $70,$70,$70,$70,$70
0450  .BYTE $46
0460  .WORD LINE1
0470 ;NOTE THAT THE LAST BYTE IN THE
0480 ;NEXT LINE IS $57, NOT $47 AS IT
0490 ;WAS IN THE PRECEDING CHAPTER
0500  .BYTE $70,$70,$70,$70,$57
0509 ;THIS THE LINE WE'LL SCROLL
0510 SCROLN ;(THIS IS THE LINE WE'LL SCROLL)
0520  .WORD $00; A BLANK TO BE FILLD IN LATER
0530  .BYTE $70,$42
0540  .WORD LINE3
0550  .BYTE $70,$70,$70,$70,$46
0560  .WORD LINE4
0570  .BYTE $70,$70,$70,$70,$70
0580  .BYTE $41
0590  .WORD HLIST
0600 ;
0610 ;RUN PROGRAM
0620 ;
0630 INIT ;PREPARE TO RUN PROGRAM
0640  LDA COLOR3; SET COLOR REGISTERS
0650  STA COLOR1;
0660  LDA COLOR4;
0670  STA COLOR2;
0680 ;
0690  LDA #0
0700  STA SDMCTL
0710  LDA #HLIST&255
0720  STA SDLSTL
0730  LDA #HLIST/256
0740  STA SDLSTH
0750  LDA #$22
0760  STA SDMCTL
0770 ;
0780  JSR TCKSET; INITIALIZE TICKER ADDRESS
0790 ;
0800  LDA #40; NUMBER OF CHARACTERS IN SCROLL LINE
0810  STA TCKPTR
0820  LDA #8
0830  STA FSCPTR; NUMBER OF CLOR CLOCKS TO FINE SCROLL
0840 ;
0850 ; ENABLE INTERRUPT
0860 ;
0870  LDY #TCKINT&255
0880  LDX #TCKINT/256
0890  LDA #6
0900  JSR SETVBV
0910 ;
0920 ; TICKER INTERRUPT
0930 ;
0940 TCKINT
0950  LDA #SCROLL&255
0960  STA VVBLKI
0970  LDA #SCROLL/256
0980  STA VVBLKI+1
0990 ;
1000 INFIN
1010  JMP INFIN; INFINITE LOOP
1020 ;
1030 SCROLL
1040  LDX FSCPTR; 8 TO START
1050  DEX
1060  STX HSCROL
1070  BNE CONT
1080  LDX #8
1089 ;CONINUE
1090 CONT
1100  STX FSCPTR
1110  CPX #7
1120  BEQ COARSE
1130  JMP SYSVBV
1140 COARSE
1150  LDY TCKPTR; NUMBER OF CHARACTERS TO SCROLL
1160  DEY
1170  BNE SCORSE; LOOP BACK TILL FULL LINE IS SCROLLED
1180  LDY #40
1190  JSR TCKSET; RESET TICKER LINE
1199 ;DO COARSE SCROLL
1200 SCORSE
1210  STY TCKPTR
1220  INC SCROLN; LOW BYTE OF ADDRESS
1230  BNE RETURN
1240  INC SCROLN+1; HIGH BYTE OF ADDRESS
1250 RETURN
1260  JMP SYSVBV
1270 ;
1280 TCKSET
1290  LDA #LINE2&255
1300  STA SCROLN
1310  LDA #LINE2/256
1320  STA SCROLN+1
1330 ENDIT
1340  RTS