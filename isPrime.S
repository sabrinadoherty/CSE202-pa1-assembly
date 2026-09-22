.global isPrime

# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
    cmpl $2, %edi              # if n < 2
    jl .not_prime

    cmpl $2, %edi              # if n == 2
    je .prime

    testl $1, %edi             # check if n is even
    je .not_prime              # even numbers > 2 are not prime

    movl $3, %ecx              # i = 3

.loop:
    movl %ecx, %eax            # eax = i
    imull %ecx, %eax           # eax = i * i
    cmpl %edi, %eax             # compare i*i with n
    jg .prime                  # if i*i > n, n is prime

    movl %edi, %eax            # eax = n
    cltd                       # sign-extend eax into edx:eax
    idivl %ecx                 # n / i, remainder in edx

    cmpl $0, %edx              # is remainder 0?
    je .not_prime

    addl $2, %ecx              # i += 2
    jmp .loop

.prime:
    movl $1, %eax
    ret

.not_prime:
    movl $0, %eax
    ret


# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
