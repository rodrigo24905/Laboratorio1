/*
* Laboratorio1.asm
*
* Creado: 03/02/2026
* Autor : Juan Rodrigo Donis Alvizures
* Descripción: 
*/
/****************************************/
.include "M328PDEF.inc"

.def contador     = r16
.def aux          = r17
.def aux2         = r18
.def contadorr2   = r19
.def resultado    = r20

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

    ldi aux, 0b11111100
    out DDRD, aux

    sbi DDRB, 0
    sbi DDRB, 1
    sbi DDRB, 2
    sbi DDRB, 3
    sbi DDRB, 4
    sbi DDRB, 5

    cbi DDRC, 0
    cbi DDRC, 1
    cbi DDRC, 2
    cbi DDRC, 3
    cbi DDRC, 4

    sbi PORTC, 0
    sbi PORTC, 1
    sbi PORTC, 2
    sbi PORTC, 3
    sbi PORTC, 4

    sbi DDRC, 5
    cbi PORTC, 5

    rcall Mostrar
    rcall Mostrar2
    rcall LimpiarSuma

/****************************************/
MAIN_LOOP:
    call Contador1'090
    call Contador2
    call BotonResultado
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
BotonResultado:
    sbis PINC, 2
    rjmp Sumar
    ret

Sumar:
    rcall Delay20
    sbis PINC, 2
    rjmp SumarOK
    ret

SumarOK:
    rcall CalcularSuma
    rcall MostrarSuma

SoltarRes:
    sbis PINC, 2
    rjmp SoltarRes
    rcall Delay20
    ret

/****************************************/
CalcularSuma:
    mov aux, contador
    add aux, contadorr2

    sbrc aux, 4
    rjmp CarryOn

CarryOff:
    cbi PORTC, 5
    rjmp GuardarRes

CarryOn:
    sbi PORTC, 5

GuardarRes:
    mov resultado, aux
    andi resultado, 0x0F
    ret


MostrarSuma:
    in  aux, PORTB
    andi aux, 0xCF
    mov aux2, resultado
    andi aux2, 0x03
    lsl aux2
    lsl aux2
    lsl aux2
    lsl aux2
    or  aux, aux2
    out PORTB, aux

    in  aux, PORTD
    andi aux, 0x3F
    mov aux2, resultado
    andi aux2, 0x0C
    lsl aux2
    lsl aux2
    lsl aux2
    lsl aux2
    or  aux, aux2
    out PORTD, aux
    ret

LimpiarSuma:
    cbi PORTC, 5

    in  aux, PORTB
    andi aux, 0xCF
    out PORTB, aux

    in  aux, PORTD
    andi aux, 0x3F
    out PORTD, aux
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

    ldi r20, 1
D_O:
    ldi r21, 26
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
