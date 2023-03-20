	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB52:
	.cfi_startproc
	endbr64
	leaq	0(,%rsi,8), %rdx
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	shrq	$2, %rdx
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movabsq	$2951479051793528259, %r12
	movq	%rdx, %rax
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	movq	%rdi, %rbp
	mulq	%r12
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rsi, %rbx
	shrq	$2, %rdx
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	andq	$-8, %rdx
	movq	%rdx, %r12
	cmpq	$15, %rsi
	jbe	.L2
	xorl	%r13d, %r13d
	cmpq	$0, (%rdi)
	jne	.L1
	leaq	8(%rdi), %rsi
	call	memcmp@PLT
	testl	%eax, %eax
	jne	.L1
.L2:
	movl	$64, %edx
	leaq	0(%rbp,%r12), %rsi
	subq	%rbp, %rdx
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L5:
	movq	%rsi, %rcx
	addq	$64, %rsi
	movq	(%rcx), %rax
	orq	8(%rcx), %rax
	orq	16(%rcx), %rax
	orq	24(%rcx), %rax
	orq	32(%rcx), %rax
	orq	40(%rcx), %rax
	orq	48(%rcx), %rax
	orq	56(%rcx), %rax
	jne	.L17
.L4:
	leaq	(%rdx,%rsi), %rax
	cmpq	%rbx, %rax
	jbe	.L5
	movq	%rbx, %rax
	movq	%rbx, %rdi
	addq	%rbp, %rbx
	subq	%r12, %rax
	andl	$63, %eax
	subq	%rax, %rdi
	movq	%rdi, %rax
	addq	%rbp, %rax
	cmpq	%rbx, %rax
	jnb	.L10
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L7:
	addq	$1, %rax
	orb	-1(%rax), %dl
	cmpq	%rax, %rbx
	jne	.L7
	xorl	%r13d, %r13d
	testb	%dl, %dl
	sete	%r13b
.L1:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	movl	%r13d, %eax
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L17:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	xorl	%r13d, %r13d
	popq	%rbx
	.cfi_def_cfa_offset 32
	movl	%r13d, %eax
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	movl	$1, %r13d
	jmp	.L1
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
	jbe	.L19
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
	ja	.L22
	jmp	.L20
	.p2align 4,,10
	.p2align 3
.L31:
	addq	$16, %rbx
	cmpq	%rbx, %rbp
	jbe	.L20
.L22:
	movq	%rbx, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L31
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
.L20:
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
.L19:
	.cfi_restore 3
	.cfi_restore 6
	addq	%rdi, %rsi
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L23:
	addq	$1, %rdi
	orb	-1(%rdi), %al
	cmpq	%rdi, %rsi
	ja	.L23
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
