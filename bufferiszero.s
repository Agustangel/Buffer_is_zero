	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB5320:
	.cfi_startproc
	endbr64
	xorl	%edx, %edx
	pxor	%xmm2, %xmm2
	jmp	.L2
	.p2align 4,,10
	.p2align 3
.L4:
	movdqu	-64(%rdi,%rdx), %xmm0
	movdqu	-48(%rdi,%rdx), %xmm1
	por	-32(%rdi,%rdx), %xmm0
	por	-16(%rdi,%rdx), %xmm1
	por	%xmm1, %xmm0
	pcmpeqb	%xmm2, %xmm0
	pmovmskb	%xmm0, %eax
	cmpl	$65535, %eax
	jne	.L7
.L2:
	addq	$64, %rdx
	cmpq	%rsi, %rdx
	jbe	.L4
	movq	%rsi, %rax
	andq	$-64, %rax
	addq	%rdi, %rax
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
.LFE5320:
	.size	buffer_is_zero, .-buffer_is_zero
	.p2align 4
	.globl	buffer_is_zero_fast
	.type	buffer_is_zero_fast, @function
buffer_is_zero_fast:
.LFB5321:
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
.LFE5321:
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
