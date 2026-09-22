.global binsearch

# arr in %rdi, n in %esi, target in %edx
binsearch:
    movl $0, %ecx              # lo = 0
    movl %esi, %eax            # eax = n
    subl $1, %eax              # hi = n - 1

.loop:
    cmpl %eax, %ecx            # compare lo with hi
    jg .not_found              # if lo > hi, return -1

    movl %eax, %r8d            # r8d = hi
    subl %ecx, %r8d             # r8d = hi - lo
    shrl $1, %r8d               # r8d = (hi - lo) / 2
    addl %ecx, %r8d             # r8d = mid

    movslq %r8d, %r9            # convert mid to 64-bit
    movl (%rdi,%r9,4), %r10d    # r10d = arr[mid]

    cmpl %edx, %r10d            # arr[mid] vs target
    je .found                  # if equal, return mid
    jl .search_right            # if arr[mid] < target

    leal -1(%r8), %eax          # hi = mid - 1
    jmp .loop

.search_right:
    leal 1(%r8), %ecx           # lo = mid + 1
    jmp .loop

.found:
    movl %r8d, %eax             # return mid
    retq

.not_found:
    movl $-1, %eax              # return -1
    retq


# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
