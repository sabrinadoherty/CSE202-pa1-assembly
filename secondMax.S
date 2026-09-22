.global secondMax

# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx
# signed 16-bit values
# result in %ax

secondMax:
    # first = v1
    # second = v2
    movswl %di, %eax
    movswl %si, %r8d

    # if (v1 >= v2)
    cmpl %r8d, %eax
    jge .first_v1

    # v2 > v1
    # first = v2
    # second = v1
    movl %r8d, %eax
    movswl %di, %r8d
    jmp .check_v3

.first_v1:
    # first = v1
    # second = v2
    # already in eax and r8d

.check_v3:
    # v3 -> r9d
    movswl %dx, %r9d

    # if (v3 > first)
    cmpl %eax, %r9d
    jg .v3_new_first

    # else if (v3 > second)
    cmpl %r8d, %r9d
    jg .v3_new_second

    jmp .check_v4

.v3_new_first:
    # second = first
    movl %eax, %r8d

    # first = v3
    movl %r9d, %eax
    jmp .check_v4

.v3_new_second:
    movl %r9d, %r8d

.check_v4:
    # v4 -> r9d
    movswl %cx, %r9d

    # if (v4 > first)
    cmpl %eax, %r9d
    jg .v4_new_first

    # else if (v4 > second)
    cmpl %r8d, %r9d
    jg .v4_new_second

    jmp .done

.v4_new_first:
    # second = first
    movl %eax, %r8d

    # first = v4
    movl %r9d, %eax
    jmp .done

.v4_new_second:
    movl %r9d, %r8d

.done:
    # return second as a short
    movw %r8w, %ax
    retq
