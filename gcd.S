.global gcd

# a in %edi, b in %esi; result in %eax
gcd:
    testl %esi, %esi
    je .done

    movl %edi, %eax
    cltd
    idivl %esi

    movl %esi, %edi
    movl %edx, %esi

    call gcd
    retq

.done:
    movl %edi, %eax
    retq
