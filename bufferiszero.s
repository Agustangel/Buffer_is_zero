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
	movl	$64, %r11d
	movq	%rdi, %rax
	xorl	%r10d, %r10d
	xorl	%ecx, %ecx
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	subq	%rdi, %r11
	.p2align 4,,10
	.p2align 3
.L3:
	movq	(%rax), %rdx
	orq	8(%rax), %rdx
	addq	$64, %rax
	orq	%rdx, %r8
	movq	-48(%rax), %rdx
	orq	-40(%rax), %rdx
	orq	%rdx, %r9
	movq	-32(%rax), %rdx
	orq	-24(%rax), %rdx
	orq	%rdx, %rcx
	movq	-16(%rax), %rdx
	orq	-8(%rax), %rdx
	orq	%rdx, %r10
	leaq	(%r11,%rax), %rdx
	cmpq	%rdx, %rsi
	jnb	.L3
	orq	%r10, %rcx
	xorl	%eax, %eax
	orq	%rcx, %r9
	orq	%r8, %r9
	jne	.L1
.L2:
	movq	%rsi, %rax
	addq	%rdi, %rsi
	andq	$-64, %rax
	addq	%rdi, %rax
	cmpq	%rsi, %rax
	jnb	.L8
	xorl	%edx, %edx
	.p2align 4,,10
	.p2align 3
.L6:
	addq	$1, %rax
	orb	-1(%rax), %dl
	cmpq	%rax, %rsi
	jne	.L6
	xorl	%eax, %eax
	testb	%dl, %dl
	sete	%al
	ret
.L8:
	movl	$1, %eax
.L1:
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
	jbe	.L13
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
	ja	.L16
	jmp	.L14
	.p2align 4,,10
	.p2align 3
.L25:
	addq	$16, %rbx
	cmpq	%rbx, %rbp
	jbe	.L14
.L16:
	movq	%rbx, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L25
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
.L14:
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
.L13:
	.cfi_restore 3
	.cfi_restore 6
	addq	%rdi, %rsi
	xorl	%eax, %eax
	.p2align 4,,10
	.p2align 3
.L17:
	addq	$1, %rdi
	orb	-1(%rdi), %al
	cmpq	%rdi, %rsi
	ja	.L17
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
