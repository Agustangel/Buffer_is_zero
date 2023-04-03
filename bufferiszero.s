	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB5321:
	.cfi_startproc
	endbr64
	movq	%rdi, %rax
	andl	$15, %eax
	je	.L9
	movq	%rdi, %rax
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L3:
	addq	$1, %rax
	orb	-1(%rax), %dl
	testb	$15, %al
	jne	.L3
	xorl	%r8d, %r8d
	testb	%dl, %dl
	jne	.L1
	subq	%rdi, %rax
	movq	%rsi, %r8
	subq	%rax, %r8
	leaq	64(%rax), %rdx
.L2:
	cmpq	%rdx, %rsi
	jb	.L5
	movl	$64, %ecx
	addq	%rdi, %rax
	pxor	%xmm2, %xmm2
	subq	%rdi, %rcx
	jmp	.L6
	.p2align 4,,10
	.p2align 3
.L17:
	addq	$64, %rax
	leaq	(%rcx,%rax), %rdx
	cmpq	%rdx, %rsi
	jb	.L5
.L6:
	movdqa	32(%rax), %xmm0
	movdqa	(%rax), %xmm1
	por	48(%rax), %xmm0
	por	16(%rax), %xmm1
	por	%xmm1, %xmm0
	pcmpeqb	%xmm2, %xmm0
	pmovmskb	%xmm0, %edx
	cmpl	$65535, %edx
	je	.L17
	xorl	%r8d, %r8d
.L1:
	movl	%r8d, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L5:
	andl	$63, %r8d
	movq	%rsi, %rax
	subq	%r8, %rax
	addq	%rdi, %rax
	addq	%rsi, %rdi
	cmpq	%rdi, %rax
	jnb	.L12
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L8:
	addq	$1, %rax
	orb	-1(%rax), %dl
	cmpq	%rax, %rdi
	jne	.L8
	xorl	%r8d, %r8d
	testb	%dl, %dl
	sete	%r8b
	movl	%r8d, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L9:
	movq	%rsi, %r8
	movl	$64, %edx
	jmp	.L2
.L12:
	movl	$1, %r8d
	jmp	.L1
	.cfi_endproc
.LFE5321:
	.size	buffer_is_zero, .-buffer_is_zero
	.p2align 4
	.globl	buffer_is_zero_fast
	.type	buffer_is_zero_fast, @function
buffer_is_zero_fast:
.LFB5322:
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
.LFE5322:
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
