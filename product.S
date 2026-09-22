.global product

# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    movl $0, %eax              # i = 0

.loop:
    cmpl %ecx, %eax             # compare i with size
    jae .done                   # if i >= size, finish

    movss (%rdi,%rax,4), %xmm0  # xmm0 = a[i]
    mulss (%rsi,%rax,4), %xmm0  # xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx,%rax,4)  # c[i] = result

    incl %eax                   # i++
    jmp .loop

.done:
    ret

