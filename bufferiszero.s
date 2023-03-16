	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB52:
	.cfi_startproc
	endbr64
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movq	%rsi, %rdx
	movq	%fs:40, %rax
	movq	%rax, 8(%rsp)
	xorl	%eax, %eax
	movq	$0, (%rsp)
	cmpq	$7, %rsi
	jbe	.L16
	movq	(%rdi), %r8
	movq	%r8, (%rsp)
	testq	%r8, %r8
	jne	.L7
	cmpq	$71, %rsi
	jbe	.L5
	movl	$64, %r11d
	leaq	8(%rdi), %rax
	xorl	%esi, %esi
	xorl	%r9d, %r9d
	xorl	%r10d, %r10d
	subq	%rdi, %r11
	.p2align 4,,10
	.p2align 3
.L6:
	movq	(%rax), %rcx
	orq	8(%rax), %rcx
	addq	$64, %rax
	orq	%rcx, %r8
	movq	-48(%rax), %rcx
	orq	-40(%rax), %rcx
	orq	%rcx, %r10
	movq	-32(%rax), %rcx
	orq	-24(%rax), %rcx
	orq	%rcx, %r9
	movq	-16(%rax), %rcx
	orq	-8(%rax), %rcx
	orq	%rcx, %rsi
	leaq	(%r11,%rax), %rcx
	cmpq	%rcx, %rdx
	jnb	.L6
	movq	%r8, (%rsp)
	orq	%r10, %r8
	orq	%r8, %r9
	orq	%rsi, %r9
	jne	.L7
.L5:
	leaq	-8(%rdx), %rax
	movq	%rdx, %rsi
	addq	%rdi, %rdx
	andl	$63, %eax
	subq	%rax, %rsi
	movq	%rsi, %rax
	addq	%rdi, %rax
	cmpq	%rdx, %rax
	jnb	.L11
	xorl	%ecx, %ecx
	.p2align 4,,10
	.p2align 3
.L9:
	addq	$1, %rax
	orb	-1(%rax), %cl
	cmpq	%rax, %rdx
	jne	.L9
	xorl	%eax, %eax
	testb	%cl, %cl
	sete	%al
.L1:
	movq	8(%rsp), %rdi
	xorq	%fs:40, %rdi
	jne	.L17
	addq	$24, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	.cfi_restore_state
	xorl	%eax, %eax
	jmp	.L1
	.p2align 4,,10
	.p2align 3
.L16:
	movq	%rsp, %r8
	movq	%rdi, %rsi
	movl	$8, %ecx
	movq	%r8, %rdi
	call	__memcpy_chk@PLT
	xorl	%eax, %eax
	cmpq	$0, (%rsp)
	sete	%al
	jmp	.L1
.L11:
	movl	$1, %eax
	jmp	.L1
.L17:
	call	__stack_chk_fail@PLT
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
