.global commonPrefix

# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
    movl $0, %eax              # n = 0

.loop:
    movb (%rdi,%rax,1), %cl    # cl = a[n]
    cmpb $0, %cl               # is a[n] == '\0'?
    je .done

    cmpb (%rsi,%rax,1), %cl    # compare a[n] with b[n]
    jne .done

    incl %eax                  # n++
    jmp .loop

.done:
    retq


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
