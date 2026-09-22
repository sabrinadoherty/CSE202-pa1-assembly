.global reverse

# list in %rdi (array of char*), n in %esi
reverse:
    movl $0, %ecx              # i = 0

.loop:
    movl %esi, %eax            # eax = n
    shrl $1, %eax              # eax = n / 2
    cmpl %eax, %ecx            # compare i with n/2
    jae .done                  # if i >= n/2, finish

    movl %esi, %eax            # eax = n
    subl %ecx, %eax            # eax = n - i
    subl $1, %eax              # eax = n - i - 1

    movq (%rdi,%rcx,8), %rdx   # temp = list[i]
    movq (%rdi,%rax,8), %r8    # r8 = list[n-i-1]

    movq %r8, (%rdi,%rcx,8)    # list[i] = list[n-i-1]
    movq %rdx, (%rdi,%rax,8)   # list[n-i-1] = temp

    incl %ecx                  # i++
    jmp .loop

.done:
    retq


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
