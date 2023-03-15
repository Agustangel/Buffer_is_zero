	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB52:
	.cfi_startproc
	endbr64
	cmpq	$63, %rsi
	jbe	.L2
	leaq	-64(%rsi), %rcx
	cmpq	$-65, %rsi
	ja	.L3
	cmpq	$959, %rcx
	jbe	.L3
	shrq	$6, %rcx
	pxor	%xmm3, %xmm3
	movq	%rdi, %rax
	xorl	%edx, %edx
	addq	$1, %rcx
	movdqa	%xmm3, %xmm4
	.p2align 4,,10
	.p2align 3
.L4:
	movdqu	48(%rax), %xmm1
	movdqu	(%rax), %xmm7
	addq	$1, %rdx
	addq	$64, %rax
	movdqu	-32(%rax), %xmm5
	movdqu	-48(%rax), %xmm0
	movdqa	%xmm1, %xmm2
	punpcklqdq	%xmm5, %xmm2
	punpckhqdq	%xmm5, %xmm1
	por	%xmm2, %xmm1
	por	%xmm1, %xmm4
	movdqa	%xmm0, %xmm1
	punpckhqdq	%xmm7, %xmm0
	punpcklqdq	%xmm7, %xmm1
	por	%xmm1, %xmm0
	por	%xmm0, %xmm3
	cmpq	%rcx, %rdx
	jb	.L4
	movq	%xmm4, %r8
	movq	%xmm3, %r10
	psrldq	$8, %xmm4
	psrldq	$8, %xmm3
	movq	%xmm4, %rdx
	movq	%xmm3, %rax
.L7:
	orq	%r8, %rdx
	xorl	%r8d, %r8d
	orq	%r10, %rdx
	orq	%rax, %rdx
	jne	.L1
.L2:
	movq	%rsi, %rax
	addq	%rdi, %rsi
	andq	$-64, %rax
	addq	%rdi, %rax
	cmpq	%rsi, %rax
	jnb	.L12
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L10:
	addq	$1, %rax
	orb	-1(%rax), %dl
	cmpq	%rax, %rsi
	jne	.L10
	xorl	%r8d, %r8d
	testb	%dl, %dl
	sete	%r8b
.L1:
	movl	%r8d, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L3:
	movl	$64, %r11d
	movq	%rdi, %rcx
	xorl	%r8d, %r8d
	xorl	%edx, %edx
	xorl	%r10d, %r10d
	xorl	%eax, %eax
	subq	%rdi, %r11
	.p2align 4,,10
	.p2align 3
.L6:
	movq	8(%rcx), %r9
	orq	(%rcx), %r9
	addq	$64, %rcx
	orq	%r9, %rax
	movq	-40(%rcx), %r9
	orq	-48(%rcx), %r9
	orq	%r9, %r10
	movq	-24(%rcx), %r9
	orq	-32(%rcx), %r9
	orq	%r9, %rdx
	movq	-8(%rcx), %r9
	orq	-16(%rcx), %r9
	orq	%r9, %r8
	leaq	(%r11,%rcx), %r9
	cmpq	%rsi, %r9
	jbe	.L6
	jmp	.L7
.L12:
	movl	$1, %r8d
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
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$40, %rsp
	.cfi_def_cfa_offset 64
	cmpq	$15, %rsi
	jbe	.L25
	leaq	-16(%rdi,%rsi), %rbp
	andq	$-16, %rdi
	leaq	16(%rdi), %rbx
	cmpq	%rbx, %rbp
	ja	.L28
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L37:
	addq	$16, %rbx
	cmpq	%rbx, %rbp
	jbe	.L26
.L28:
	movq	%rbx, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L37
	addq	$40, %rsp
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
.L26:
	.cfi_restore_state
	movq	%rbp, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	sete	%al
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movzbl	%al, %eax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L25:
	.cfi_restore_state
	leaq	(%rdi,%rsi), %rcx
	leaq	1(%rdi), %rdx
	movl	$1, %r8d
	movq	%rdi, %rax
	cmpq	%rdx, %rcx
	cmovb	%r8, %rsi
	movq	%rdi, %r8
	notq	%r8
	addq	%rcx, %r8
	cmpq	$14, %r8
	jbe	.L33
	cmpq	%rdx, %rcx
	jb	.L33
	movq	%rsi, %rdx
	pxor	%xmm0, %xmm0
	andq	$-16, %rdx
	addq	%rdi, %rdx
	.p2align 4,,10
	.p2align 3
.L30:
	movdqu	(%rax), %xmm2
	addq	$16, %rax
	por	%xmm2, %xmm0
	cmpq	%rdx, %rax
	jne	.L30
	movdqa	%xmm0, %xmm1
	andq	$-16, %rsi
	psrldq	$8, %xmm1
	addq	%rsi, %rdi
	por	%xmm1, %xmm0
	leaq	1(%rdi), %rdx
	movdqa	%xmm0, %xmm1
	psrldq	$4, %xmm1
	por	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$2, %xmm1
	por	%xmm1, %xmm0
	movdqa	%xmm0, %xmm1
	psrldq	$1, %xmm1
	por	%xmm1, %xmm0
	movaps	%xmm0, (%rsp)
	movzbl	(%rsp), %eax
.L29:
	orb	(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	2(%rdi), %rdx
	orb	1(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	3(%rdi), %rdx
	orb	2(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	4(%rdi), %rdx
	orb	3(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	5(%rdi), %rdx
	orb	4(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	6(%rdi), %rdx
	orb	5(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	7(%rdi), %rdx
	orb	6(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	8(%rdi), %rdx
	orb	7(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	9(%rdi), %rdx
	orb	8(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	10(%rdi), %rdx
	orb	9(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	11(%rdi), %rdx
	orb	10(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	12(%rdi), %rdx
	orb	11(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	13(%rdi), %rdx
	orb	12(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	leaq	14(%rdi), %rdx
	orb	13(%rdi), %al
	cmpq	%rdx, %rcx
	jbe	.L31
	orb	14(%rdi), %al
.L31:
	testb	%al, %al
	sete	%al
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movzbl	%al, %eax
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L33:
	.cfi_restore_state
	xorl	%eax, %eax
	jmp	.L29
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
