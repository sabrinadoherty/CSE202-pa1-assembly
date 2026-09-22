.global mult7div8

# a in %dil (signed char)
# overflow pointer in %rsi
# result in %eax

mult7div8:
    # Convert signed char a to int
    movsbl %dil, %eax

    # Calculate 7*a
    movl %eax, %ecx
    sall $3, %eax              # eax = a * 8
    subl %ecx, %eax            # eax = a * 7

    # Check whether 7*a fits in signed char
    cmpl $127, %eax
    jg .overflow

    cmpl $-128, %eax
    jl .overflow

    # No overflow
    movb $0, (%rsi)
    jmp .divide

.overflow:
    movb $1, (%rsi)

    # Keep only the low 8 bits.
    # This gives the signed-char wrapped value.
    movsbl %al, %eax

.divide:
    # Divide by 8, truncating toward zero.
    testl %eax, %eax
    jns .positive

    addl $7, %eax

.positive:
    sarl $3, %eax
    retq
