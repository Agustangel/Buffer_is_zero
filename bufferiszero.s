	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB52:
	.cfi_startproc
	endbr64
	movl	$40, %r9d
	movq	%rdi, %rcx
	subq	%rdi, %r9
	jmp	.L2
	.p2align 4,,10
	.p2align 3
.L4:
	movq	%rcx, %rdx
	addq	$40, %rcx
	movsbl	8(%rdx), %r8d
	movsbl	(%rdx), %eax
	addl	%r8d, %eax
	movsbl	16(%rdx), %r8d
	addl	%r8d, %eax
	movsbl	24(%rdx), %r8d
	movsbl	32(%rdx), %edx
	addl	%r8d, %eax
	addl	%edx, %eax
	jne	.L7
.L2:
	leaq	(%r9,%rcx), %rax
	cmpq	%rax, %rsi
	jnb	.L4
	movabsq	$-3689348814741910323, %rdx
	movq	%rsi, %rax
	mulq	%rdx
	shrq	$5, %rdx
	leaq	(%rdx,%rdx,4), %rax
	leaq	(%rdi,%rax,8), %rax
	addq	%rsi, %rdi
	cmpq	%rdi, %rax
	jnb	.L8
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L6:
	addq	$1, %rax
	orb	-1(%rax), %dl
	cmpq	%rax, %rdi
	jne	.L6
	xorl	%eax, %eax
	testb	%dl, %dl
	sete	%al
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	xorl	%eax, %eax
	ret
.L8:
	movl	$1, %eax
	ret
	.cfi_endproc
.LFE52:
	.size	buffer_is_zero, .-buffer_is_zero
	.p2align 4
	.globl	buffer_is_zero_fast
	.type	buffer_is_zero_fast, @function
buffer_is_zero_fast:
.LFB53:
	.cfi_startproc
	endbr64
	cmpq	$15, %rsi
	jbe	.L12
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	leaq	-16(%rdi,%rsi), %rbp
	andq	$-16, %rdi
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	leaq	16(%rdi), %rbx
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	cmpq	%rbx, %rbp
	ja	.L15
	jmp	.L13
	.p2align 4,,10
	.p2align 3
.L24:
	addq	$16, %rbx
	cmpq	%rbx, %rbp
	jbe	.L13
.L15:
	movq	%rbx, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L24
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	xorl	%eax, %eax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	.cfi_restore_state
	movq	%rbp, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	sete	%al
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movzbl	%al, %eax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L12:
	.cfi_restore 3
	.cfi_restore 6
	addq	%rdi, %rsi
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L16:
	addq	$1, %rdi
	orb	-1(%rdi), %al
	cmpq	%rdi, %rsi
	ja	.L16
	testb	%al, %al
	sete	%al
	movzbl	%al, %eax
	ret
	.cfi_endproc
.LFE53:
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
