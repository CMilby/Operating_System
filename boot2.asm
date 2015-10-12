  		
[bits 16]	 						; 16 bits	
[org 0x500]  						; Memory address

_start: 							; Start 
	jmp _main_16 					; Go to main 

%include "A20.asm"
%include "gdt.asm" 					; Include external files 
%include "io_16.asm"

KERNEL_OFFSET equ 0x1000

loaded_32_msg:
	db "Loaded 32-Bit Protected Mode", 0
loaded_boot2_msg:
	db "Loaded Bootloader Stage 2", 13, 10, 0

_main_16: 							
	mov bp, 0x9000  				; Setup base pointer
	mov sp, bp  					; Setup stack pointer

	mov si, loaded_boot2_msg 		; Prepare message 
	call _print_16 					; Print message 
 
	; LOAD KERNEL HERE 
	; mov bx, KERNEL_OFFSET
	; mov dh, 15
	; mov dl, 0

	; push dx 
	; mov ah, 0x02
	; mov al, dh 
	; mov ch, 0x00
	; mov dh, 0x00 
	; mov cl, 0x02 
	; int 0x13 

	; pop dx 
	; cmp dh, al 
	; End loading Kernel 

 	call _check_A20 				; Check if A20 line is enabled 
 	cmp ax, 0 						; 0 disabled, 1 enabled  
 	je _enable_20 					; If 0, enable 

	cli 							; Disable interrupts 
	lgdt [_gdt_descriptor] 			; Load GDT 

	mov eax, cr0 					; Prepare Protected Mode 
	or eax, 1 						; Set flag 
	mov cr0, eax 					; Protected mode 

	jmp CODE_SEGMENT:_init_32 		; Jump to protected mode 

_enable_20:
	call _enable_A20_BIOS 			; Enable A20 line
	ret  							; Return 

[bits 32] 							; 32-bit mode now 

%include "io_32.asm" 				; Include external file 

_init_32: 							
	mov ax, DATA_SEGMENT 			; Clear registers
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax 

	mov ebp, 0x90000 		  		; Base pointer		
	mov esp, ebp 					; Stack pointer

_main_32:	
	call _clear_screen_32 			; Clear screen 

	mov ebx, loaded_32_msg 			; Prepare message 
	call _print_32 					; Print message 

	; call KERNEL_OFFSET
	jmp $ 							; Hang




