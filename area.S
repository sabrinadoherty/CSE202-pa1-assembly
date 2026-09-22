
.global area

# a in %edi, b in %esi, c in %edx
# result in %eax
area:
    # p = (a + b + c) / 2
    movl %edi, %eax
    addl %esi, %eax
    addl %edx, %eax
    sarl $1, %eax

    # Calculate:
    # p * (p-a) * (p-b) * (p-c)

    movl %eax, %r8d          # r8d = p

    movl %r8d, %eax
    subl %edi, %eax          # p-a
    imull %r8d, %eax         # p * (p-a)

    movl %r8d, %ecx
    subl %esi, %ecx          # p-b
    imull %ecx, %eax

    movl %r8d, %ecx
    subl %edx, %ecx          # p-c
    imull %ecx, %eax

    # eax = p * (p-a) * (p-b) * (p-c)
    # Calculate integer square root
    movl %eax, %edi
    call r_sqrt

    retq


# int r_sqrt(int x)
#
# if (x < 0)
#     return -1;
# if (x < 2)
#     return x;
#
# small_cand = r_sqrt(x >> 2) << 1;
# large_cand = small_cand + 1;
#
# if (large_cand * large_cand > x)
#     return small_cand;
# else
#     return large_cand;

r_sqrt:
    # if (x < 0)
    cmpl $0, %edi
    jl .negative

    # if (x < 2)
    cmpl $2, %edi
    jl .base

    # Save original x
    pushq %rdi

    # r_sqrt(x >> 2)
    sarl $2, %edi
    call r_sqrt

    # small_cand = result << 1
    sall $1, %eax
    movl %eax, %ecx          # ecx = small_cand

    # large_cand = small_cand + 1
    movl %ecx, %edx          # edx = large_cand
    addl $1, %edx

    # large_cand * large_cand
    movl %edx, %r9d
    imull %edx, %r9d         # r9d = large_cand^2

    # Restore original x
    popq %rdi

    # if (large_cand^2 > x)
    cmpl %edi, %r9d
    jg .use_small

    # return large_cand
    movl %edx, %eax
    retq

.use_small:
    # return small_cand
    movl %ecx, %eax
    retq

.negative:
    movl $-1, %eax
    retq

.base:
    movl %edi, %eax
    retq
