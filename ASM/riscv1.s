.global __start

.data
  array: .word 0,0
  
.text
__start:
  li x21, 8
  la x19, array
  lw x20, 0(x19)

Loop:  
  beq x21, x0, Exit 
  srli x21, x21, 1
  addi x20, x20, 1
  j Loop
Exit:
  tail Exit