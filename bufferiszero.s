	.file	"bufferiszero.c"
	.text
	.globl	buffer_is_zero_slow
	.type	buffer_is_zero_slow, @function
buffer_is_zero_slow:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp) # size -> -32 rbp
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	$0, -16(%rbp) # i -> -16 rbp, i = 0
	jmp	.L2
.L5:
	movq	-8(%rbp), %rdx
	movq	-16(%rbp), %rax # i -> rax
	addq	%rdx, %rax 
	movzbl	(%rax), %eax # buf[i]
	testb	%al, %al # if (buf[i])
	je	.L3
	movl	$0, %eax # return 0
	jmp	.L4
.L3:
	addq	$1, -16(%rbp) # i + 1
.L2:
	movq	-16(%rbp), %rax # i -> rax
	cmpq	-32(%rbp), %rax # rax (i) < size
	jb	.L5
	movl	$1, %eax # return 1
.L4:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	buffer_is_zero_slow, .-buffer_is_zero_slow
	.globl	buffer_is_zero_fast
	.type	buffer_is_zero_fast, @function
buffer_is_zero_fast:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	$16, -44(%rbp)
	movl	-44(%rbp), %eax
	cmpq	%rax, -64(%rbp)
	setnb	%al
	movzbl	%al, %eax
	testq	%rax, %rax
	je	.L7
	movl	-44(%rbp), %eax
	movq	-64(%rbp), %rdx
	subq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -16(%rbp)
	movq	-56(%rbp), %rax
	movl	-44(%rbp), %ecx
	movl	$0, %edx
	divq	%rcx
	movq	%rdx, -8(%rbp)
	movl	-44(%rbp), %eax
	subq	-8(%rbp), %rax
	movq	%rax, %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -40(%rbp)
	jmp	.L8
.L11:
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L9
	movl	$0, %eax
	jmp	.L10
.L9:
	movl	-44(%rbp), %eax
	addq	%rax, -40(%rbp)
.L8:
	movq	-40(%rbp), %rax
	cmpq	-16(%rbp), %rax
	jb	.L11
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L12
	movl	$0, %eax
	jmp	.L10
.L7:
	movq	-56(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rdx
	movq	-64(%rbp), %rax
	addq	%rdx, %rax
	movq	%rax, -24(%rbp)
	movb	$0, -45(%rbp)
.L13:
	movq	-32(%rbp), %rax
	leaq	1(%rax), %rdx
	movq	%rdx, -32(%rbp)
	movzbl	(%rax), %eax
	orb	%al, -45(%rbp)
	movq	-32(%rbp), %rax
	cmpq	-24(%rbp), %rax
	jb	.L13
	cmpb	$0, -45(%rbp)
	sete	%al
	movzbl	%al, %eax
	jmp	.L10
.L12:
	movl	$1, %eax
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	buffer_is_zero_fast, .-buffer_is_zero_fast
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04.1) 9.4.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
