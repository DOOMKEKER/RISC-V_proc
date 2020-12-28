.global __start

.text
__start:
  li x18, 0x10
  lw x21, 0(x18)
  li x20, 0

Loop:  
  beq x21, x0, Exit 
  srli x21, x21, 1
  addi x20, x20, 1
  j Loop
Exit:
  tail Exit