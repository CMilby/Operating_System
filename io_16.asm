
[bits 16]

_print_16: 					; 16-Bit Print 
	pusha 					; Save registers

_print_16_loop: 
	lodsb  					; Get char
	or al, al 				; Or al
	jz _print_16_done 		; Empty, done
	mov ah, 0eh 			; Move char to ah
	int 10h 				; Print ah
	jmp _print_16_loop 		; Next char 

_print_16_done:
	popa 					; Restore Registers
	ret 					; Return 
