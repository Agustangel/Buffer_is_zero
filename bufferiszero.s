	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB52:
	.cfi_startproc
	endbr64
	cmpq	$7, %rsi
	jbe	.L6
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	.L4
	.p2align 4,,10
	.p2align 3
.L14:
	addl	$8, %edx
	movslq	%edx, %rcx
	leaq	8(%rcx), %r8
	cmpq	%rsi, %r8
	ja	.L13
	movq	%rcx, %rax
.L4:
	cmpb	$0, (%rdi,%rax)
	je	.L14
.L10:
	xorl	%eax, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L13:
	movslq	%eax, %rdx
	cltq
.L2:
	cmpq	%rax, %rsi
	jbe	.L9
	addq	$1, %rdx
	jmp	.L5
	.p2align 4,,10
	.p2align 3
.L15:
	leaq	1(%rdx), %rcx
	movq	%rdx, %rax
	cmpq	%rsi, %rdx
	jnb	.L9
	movq	%rcx, %rdx
.L5:
	cmpb	$0, (%rdi,%rax)
	je	.L15
	jmp	.L10
	.p2align 4,,10
	.p2align 3
.L9:
	movl	$1, %eax
	ret
.L6:
	xorl	%eax, %eax
	xorl	%edx, %edx
	jmp	.L2
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
	jbe	.L17
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
	ja	.L20
	jmp	.L18
	.p2align 4,,10
	.p2align 3
.L29:
	addq	$16, %rbx
	cmpq	%rbx, %rbp
	jbe	.L18
.L20:
	movq	%rbx, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L29
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
.L18:
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
.L17:
	.cfi_restore 3
	.cfi_restore 6
	addq	%rdi, %rsi
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L21:
	addq	$1, %rdi
	orb	-1(%rdi), %al
	cmpq	%rdi, %rsi
	ja	.L21
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
