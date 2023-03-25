	.file	"bufferiszero.c"
	.text
	.p2align 4
	.globl	buffer_is_zero
	.type	buffer_is_zero, @function
buffer_is_zero:
.LFB5320:
	.cfi_startproc
	endbr64
	xorl	%eax, %eax
	jmp	.L2
	.p2align 4,,10
	.p2align 3
.L4:
	vpxor	%xmm0, %xmm0, %xmm0
	vpcmpeqd	-64(%rdi,%rax), %zmm0, %k0
	kmovw	%k0, %edx
	cmpw	$-1, %dx
	jne	.L7
.L2:
	addq	$64, %rax
	cmpq	%rsi, %rax
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
	incq	%rax
	orb	-1(%rax), %dl
	cmpq	%rax, %rdi
	jne	.L6
	xorl	%eax, %eax
	testb	%dl, %dl
	sete	%al
.L10:
	vzeroupper
	ret
	.p2align 4,,10
	.p2align 3
.L7:
	xorl	%eax, %eax
	vzeroupper
	ret
.L8:
	movl	$1, %eax
	jmp	.L10
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
.L26:
	addq	$16, %rbx
	cmpq	%rbx, %rbp
	jbe	.L14
.L16:
	movq	%rbx, %rdi
	call	nonzero_chunk@PLT
	testq	%rax, %rax
	je	.L26
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
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
	popq	%rbx
	.cfi_def_cfa_offset 16
	movzbl	%al, %eax
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
	incq	%rdi
	orb	-1(%rdi), %al
	cmpq	%rdi, %rsi
	ja	.L17
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
