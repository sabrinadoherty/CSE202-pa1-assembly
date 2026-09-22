.global sum

# pointer to list head in %rdi; result in %rax
# struct ll { char *name; long value; struct ll *next; }
#   offset 0  : name
#   offset 8  : value
#   offset 16 : next
sum:
    movq $0, %rax              # total = 0
    movq %rdi, %rcx            # ptr = list

.loop:
    cmpq $0, %rcx              # is ptr NULL?
    je .done

    addq 8(%rcx), %rax         # total += ptr->value
    movq 16(%rcx), %rcx        # ptr = ptr->next

    jmp .loop

.done:
    retq


# sum of the elements of a linkedlist in C
# long sum(struct ll *list){
#    long total = 0;
#    struct ll *ptr = list;
#    while(ptr){
#        total += ptr->value;
#        ptr = ptr->next;
#    }
#    return total;
# }
