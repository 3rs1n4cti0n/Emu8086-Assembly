; Ersan TZAMPAZ CHATIP (Ersan Cambaz Hatip)
; 152120181094

data segment
    array dw -18, 127, -217, 592, -1000, 398, 862, 0, 28, -358
    
    ; substract arrays first element memory from current memory
    ; this gives us array size * 2
    ; because we are using DW
    size dw $ - array
    
    min dw 0
    max dw 0
    sum dw 0
    avg dw 0
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    
    
; get array first element pointed to bx and dx will be second element
lea bx, array
mov dx,0

; for iteration
mov si, 0

; get array size
mov cx, size
shr cx, 1
dec cx

; set first element of array to min and max since we are comparing them
; and array may not contain 0
mov ax, [bx]
mov max, ax
mov min, ax
; add first element of array to sum
add sum, ax

; main loop start
; check if element is min
check_min:
    ; increment si to check if we are in the last array element
    inc si
    ; increment bx twice since it uses 2 bytes of memory
    inc bx
    inc bx
    
    mov ax, [bx]  
    
    ; if current element is smaller then our current minimum
    cmp ax, min
    jl set_min
    
    ; continue to check for max    
    jmp check_max

; check if element is max
check_max:
    
    ; if current element is greater then our current maximum
    cmp ax, max
    jg set_max
    
    ; continue to calculate average
    jmp set_avg

; calculate average and set it    
set_avg:
    add sum, ax ; sum = sum + current_element
    mov ax, sum ; ax = sum
    cwd         ; converts word to double word
    inc si      ; increase si to calculate current division
    idiv si     ; ax = ax / si (ax is total sum upto now, si is elements upto now)
    dec si      ; decrease si to use if the program ends
    mov avg, ax ; avg = ax
    
    cmp si,cx   ; end program if si = cx
    je end_of_program
    jmp check_min
    
set_max:
    mov max, ax
    jmp set_avg
    
set_min:
    mov min, ax
    jmp set_avg

end_of_program: 
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
