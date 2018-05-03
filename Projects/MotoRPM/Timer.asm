#ifndefine PinLayout.inc
#include PinLayout.inc
#else
#define PinLayout.inc
#include PinLayout.inc
#endif

start_  EQU	$1000

DELTA_EDGE:
	RMW     1
EDGE1:
        RMW     1
EDGE2:
        RMW     1
        
        org     start_
main:
        JSR     ledInital
        JSR     timerSetUp
mainLoop:
        JSR     timerFunctionEdge
        JMP     mainLoop
        
ledInital:
        BSET    DDRB,$FF
        BSET    DDRP,$FF
        BSET    PTP,$FF
        BCLR    PTJ,$02
        BSET    PORTB,$80

        RTS
        
timerSetUp:
	movb	#$90,TSCR1
	MOVB	#$07,TSCR2
	BCLR	TIOS,$04
	MOVB	#$10,TCTL4
	CLR	DELTA_EDGE
	CLR	EDGE1
	CLR	EDGE2
        RTS
        
timerFunctionEdge:
        LDD     TC2
IS_SIGNAL1:
        BRCLR   TFLG1,$04,IS_SIGNAL1
        MOVW    TC2,EDGE1
IS_SIGNAL2:
        BRCLR   TFLG1,$04,IS_SIGNAL2
        LDD     TC2
        STD     EDGE2
        CPD     EDGE1
        BLO     EDGE_COM
        SUBD    EDGE1
        STD     DELTA_EDGE
        LDAA    PORTB
        CMPA    #$80
        BEQ     IS2_L1
        BCLR    PORTB,$80
        RTS
IS2_L1:
	BSET    PORTB,$80
        RTS
        
EDGE_COM:
        COM     EDGE2
        LDD     EDGE2
        ADDD    EDGE1
        STD     DELTA_EDGE
	LDAA    PORTB
        CMPA    #$80
        BEQ     IS2_L2
        BCLR    PORTB,$80
        RTS
IS2_L2:
	BSET    PORTB,$80
        RTS