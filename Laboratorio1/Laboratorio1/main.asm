/*
* Laboratorio1.asm
*
* Creado: 03/02/2026
* Autor : Juan Rodrigo Donis Alvizures
* Descripción: 
*/
/****************************************/
.include "M328PDEF.inc"

.def contador  = r16
.def aux       = r17
.def aux2      = r18
.def contadorr2 = r19

.dseg
.org SRAM_START

.cseg
.org 0x0000
    rjmp RESET

/****************************************/
RESET:
    LDI     R16, LOW(RAMEND)
    OUT     SPL, R16
    LDI     R16, HIGH(RAMEND)
    OUT     SPH, R16

SETUP:
    clr r1
    clr contador
    clr contadorr2

    ldi aux, 0b00111100
    out DDRD, aux

    sbi DDRB, 0
    sbi DDRB, 1
    sbi DDRB, 2
    sbi DDRB, 3

    cbi DDRC, 0
    cbi DDRC, 1
    cbi DDRC, 3
    cbi DDRC, 4

    sbi PORTC, 0
    sbi PORTC, 1
    sbi PORTC, 3
    sbi PORTC, 4

    rcall Mostrar
    rcall Mostrar2

/****************************************/
MAIN_LOOP:
    call Contador1
    call Contador2
    rjmp MAIN_LOOP

/****************************************/
Contador1:
    sbis PINC, 0
    rjmp Mas

    sbis PINC, 1
    rjmp Menos

    ret

Mas:
    rcall Delay20
    sbis PINC, 0
    rjmp MasOK
    ret

MasOK:
    inc contador
    andi contador, 0x0F
    rcall Mostrar

SoltarMas:
    sbis PINC, 0
    rjmp SoltarMas
    rcall Delay20
    ret

Menos:
    rcall Delay20
    sbis PINC, 1
    rjmp MenosOK
    ret

MenosOK:
    dec contador
    andi contador, 0x0F
    rcall Mostrar

SoltarMenos:
    sbis PINC, 1
    rjmp SoltarMenos
    rcall Delay20
    ret

/****************************************/
Contador2:
    sbis PINC, 3
    rjmp Mas2

    sbis PINC, 4
    rjmp Menos2

    ret

Mas2:
    rcall Delay20
    sbis PINC, 3
    rjmp MasOK2
    ret

MasOK2:
    inc contadorr2
    andi contadorr2, 0x0F
    rcall Mostrar2

SoltarMas2:
    sbis PINC, 3
    rjmp SoltarMas2
    rcall Delay20
    ret

Menos2:
    rcall Delay20
    sbis PINC, 4
    rjmp MenosOK2
    ret

MenosOK2:
    dec contadorr2
    andi contadorr2, 0x0F
    rcall Mostrar2

SoltarMenos2:
    sbis PINC, 4
    rjmp SoltarMenos2
    rcall Delay20
    ret

/****************************************/
Mostrar:
    mov aux, contador
    andi aux, 0x0F
    lsl aux
    lsl aux

    in  aux2, PORTD
    andi aux2, 0xC3
    or  aux2, aux
    out PORTD, aux2
    ret

Mostrar2:
    in  aux, PORTB
    andi aux, 0xF0
    mov aux2, contadorr2
    andi aux2, 0x0F
    or  aux, aux2
    out PORTB, aux
    ret

Delay20:
    push r20
    push r21
    push r22

    ldi r20, 9
D_O:
    ldi r21, 50
D_M:
    ldi r22, 255
D_I:
    dec r22
    brne D_I
    dec r21
    brne D_M
    dec r20
    brne D_O

    pop r22
    pop r21
    pop r20
    ret