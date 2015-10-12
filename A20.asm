
[bits 16]

_check_A20:
	pushf 
	push ds
	push es 
	push di 
	push si 
	
	cli 

	xor ax, ax 
	mov es, ax

	not ax 
	mov ds, ax

	mov di, 0x0500
	mov si, 0x0510

	mov al, byte [es:di]
	push ax 

	mov al, byte [ds:si]
	push ax 

	mov byte [es:di], 0x00 
	mov byte [ds:si], 0xFF

	cmp byte [es:di], 0xFF

	pop ax
	mov byte [ds:si], al

	pop ax
	mov byte [es:di], al

	mov ax, 0
	je _check_A20_done

	mov ax, 1

_check_A20_done:	
	pop si 
	pop di 
	pop es 
	pop ds
	popf
	
	ret 

; Enable A20 through bios 
_enable_A20_BIOS:
	pusha 							; Save registers
	mov ax, 0x2401 					; Mov hex to ax 
	int 0x15 						; BIOS Interrupts
	popa 							; Restore registers
	ret 							; Return 

; Enable A20 through output port
_enable_A20_output: 				
	cli 							; Disable interrupts 
	pusha							; Save registers 

	call _wait_input				; Wait 
	mov al, 0xAD					; Move key to al 
	out 0x64, al 					; Output al 
	call _wait_input 				; Wait 

	mov al, 0xD0 					; Move key to al 
	out 0x64, al					; Out al 
	call _wait_output  				; Wait 

	in al, 0x60 					; Move key to al
	push eax 						; Push eax to stack 
	call _wait_input 				; Wait 

	mov al, 0xD1 					; Mov key to al 
	out 0x64, al 					; Out al 
	call _wait_input 				; Wait 

	pop eax 						; Get eax off stack 
	or al, 2  						; Or al with 2
	out 0x60, al  					; Out al

	call _wait_input 				; Wait 
	mov al, 0xAE					; Move key to al 
	out 0x64, al  					; Out al 

	call _wait_input 				; Wait 
	popa							; Restore registers
	sti 							; Enable interrupts 
	ret  							; Return 

_wait_input: 						; Wait input 
	in al, 0x64 					; Keyboard input 
	test al, 2 						; al is 2?
	jnz _wait_input 				; Wait 
	ret 							; Return 

_wait_output: 						; Wait output 
	in al, 0x64 					; Keyboard input 
	test al, 1 						; al is 1?
	jz _wait_output 				; Wait 
	ret 							; Return 

