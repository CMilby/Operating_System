
[bits 16] 						; Define Bits 
[org 0x7C00] 					; Starting address in memory 

_start: 			
	jmp _main

%include "io_16.asm" 			; 16-bit I/O
 
prepare_boot1_msg: 
	db "Loading Bootloader Stage 1...", 13, 10, 0

_main:
	mov si, prepare_boot1_msg 	; Move message 
	call _print_16 				; Print 

	mov ax, cs 					; Setup registers
	mov ds, ax 					; Point to sector
	mov es, ax 
	mov fs, ax
	mov gs, ax				

_reset:
	mov ax, 0 					; Setup floppy
	mov dl, 0 					; Drive 0
	int 13h 					; Invoke BIOS 	
	jc _reset					; Can't find, reset 

_read:
	mov ax, 0 					; Memory address 
	mov es, ax 					; 0x0:0x500
	mov bx, 0x500 				; Lower section

	mov ah, 2 					; BIOS read sector 
	mov al, 1 					; Read one sector
	mov ch, 0 					; Track 0
	mov cl, 2 					; Sector 2
	mov dh, 0 					; Head 0
	mov dl, 0 					; Drive 0
	int 13h 					; Invoke BIOS

	jc _read 					; Can't find, loop

_enter_stage_2:
	jmp 0x500 					; Jump to boot2

times 510 - ($ - $$) db 0 		; 512 bytes
dw 0xAA55 						; Boot signature









