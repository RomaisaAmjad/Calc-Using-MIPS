.data
menu:      .asciiz "\n--- MIPS Calculator ---\n1) Add\n2) Subtract\n3) Multiply\n4) Divide\nChoose operation: "
enterA:    .asciiz "Enter first number: "
enterB:    .asciiz "Enter second number: "
resultStr: .asciiz "Result: "
errDiv:    .asciiz "Error: Division by zero!\n"

.text
main:
    # Print menu
    li $v0, 4
    la $a0, menu
    syscall

    # Read choice
    li $v0, 5
    syscall
    move $t0, $v0          # store choice

    # Enter first number
    li $v0, 4
    la $a0, enterA
    syscall

    li $v0, 5
    syscall
    move $t1, $v0          # A

    # Enter second number
    li $v0, 4
    la $a0, enterB
    syscall

    li $v0, 5
    syscall
    move $t2, $v0          # B

    # Check operation
    beq $t0, 1, ADD
    beq $t0, 2, SUB
    beq $t0, 3, MUL
    beq $t0, 4, DIV
    j END                  # if invalid choice

ADD:
    add $t3, $t1, $t2
    j PRINT

SUB:
    sub $t3, $t1, $t2
    j PRINT

MUL:
    mul $t3, $t1, $t2
    j PRINT

DIV:
    beq $t2, $zero, DIVERR   # avoid divide by zero
    div $t1, $t2
    mflo $t3
    j PRINT

DIVERR:
    li $v0, 4
    la $a0, errDiv
    syscall
    j END

PRINT:
    li $v0, 4
    la $a0, resultStr
    syscall

    li $v0, 1
    move $a0, $t3
    syscall

END:
    li $v0, 10
    syscall
