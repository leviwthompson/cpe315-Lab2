	.arch armv6
	.fpu vfp
	.text

@ print function is complete, no modifications needed
    .global	print
print:
	stmfd	sp!, {r3, lr}
	mov	r3, r0
	mov	r2, r1
	ldr	r0, startstring
	mov	r1, r3
	bl	printf
	ldmfd	sp!, {r3, pc}

startstring:
	.word	string0

    .global	towers
towers:
   /* Save callee-saved registers to stack */
    push {r5, r6, r7, lr} /* r5 - steps, r6 - peg, r7 - temp */
    
    push {r0, r1, r2} /* r0 - numDisks, r1 - start, r2 - goal */

if:
   /* Compare numDisks with 2 or (numDisks - 2)*/
    cmp r0, #2
   /* Check if less than, else branch to else */
    bge else
   /* set print function's start to incoming start */
    push {r0, r1}
    mov r0, r1
   /* set print function's end to goal */
    mov r1, r2
   /* call print function */
    bl print
    pop {r0, r1}
   /* Set return register to 1 */
    mov r0, #1
   /* branch to endif */
    bl endif
else:
   /* Use a callee-saved varable for temp and set it to 6 */
    mov r7, #6
    /* Subtract start from temp and store to itself */
    sub r7, r7, r1
   /* Subtract goal from temp and store to itself (temp = 6 - start - goal)*/
    sub r7, r7, r2
   /* subtract 1 from original numDisks and store it to numDisks parameter */
    sub r0, r0, #1
   /* Set end parameter as temp */
    push {r1, r2, r5, r6, r7}
    mov r2, r7
   /* Call towers function */
    bl towers
    pop {r1, r2, r5, r6, r7}
   /* Save result to callee-saved register for total steps */
    mov r5, r0
   /* Set numDiscs parameter to 1 */
    mov r0, #1
   /* Call towers function */
    push {r1, r2, r5, r6, r7}
    bl towers
    pop {r1, r2, r5, r6, r7}
    add r5, r5, r0
   /* Add result to total steps so far */
   /* Set numDisks parameter to original numDisks - 1 */
    ldr r0, [sp]
    add r0, r0, #-1
   /* set start parameter to temp */
    mov r1, r7
   /* set goal parameter to original goal */
    ldr r2, [sp, #8]
   /* Call towers function */
    push {r1, r2, r5, r6, r7}
    bl towers
    pop {r1, r2, r5, r6, r7}
   /* Add result to total steps so far and save it to return register */
    add r0, r5, r0
endif:
   /* Restore Registers */
    add sp, sp, #+4
    pop {r1, r2}
    pop {r5, r6, r7, lr}
    mov pc, lr

@ Function main is complete, no modifications needed
    .global	main
main:
    str lr, [sp, #-4]!
    sub sp, sp, #20
    ldr r0, printdata
    bl  printf
    ldr r0, printdata+4
    add r1, sp, #12
    bl  scanf
    ldr r0, [sp, #12]
    mov r1, #1
    mov r2, #3
    bl  towers
    str r0, [sp]
    ldr r0, printdata+8
    ldr r1, [sp, #12]
    mov r2, #1
    mov r3, #3
    bl  printf
    mov r0, #0
    add sp, sp, #20
    ldr pc, [sp], #4
end:

printdata:
    .word   string1
    .word   string2
    .word   string3

string0:
    .asciz  "Move from peg %d to peg %d\n"
string1:
    .asciz  "Enter number of discs to be moved: "
string2:
    .asciz  "%d"
    .space  1
string3:
    .ascii  "\n%d discs moved from peg %d to peg %d in %d steps."
    .ascii  "\012\000"

