.data
errstr:  .asciiz "ERROR: unknown operator\n"
divstr:  .asciiz "ERROR: division by zero\n"
newline: .asciiz "\n"

.text
.globl main
main:
    li $v0, 5
    syscall
    move $t0, $v0

    li $v0, 5
    syscall
    move $t1, $v0

    li $v0, 12
    syscall
    move $t2, $v0

    li $t4, '+'
    beq $t2, $t4, ADD

    li $t4, '-'
    beq $t2, $t4, SUB

    li $t4, '*'
    beq $t2, $t4, MUL

    li $t4, '/'
    beq $t2, $t4, DIV

    la $a0, errstr
    li $v0, 4
    syscall
    j EXIT

ADD:
    add $t3, $t0, $t1
    j PRINT

SUB:
    sub $t3, $t0, $t1
    j PRINT

MUL:
    mul $t3, $t0, $t1
    j PRINT

DIV:
    beq $t1, $zero, DIV0
    div $t0, $t1
    mflo $t3
    j PRINT

DIV0:
    la $a0, divstr
    li $v0, 4
    syscall
    j EXIT

PRINT:
    move $a0, $t3
    li $v0, 1
    syscall

    la $a0, newline
    li $v0, 4
    syscall
    j EXIT

EXIT:
    li $v0, 10
    syscall
