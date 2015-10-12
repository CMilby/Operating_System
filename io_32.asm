
[bits 32]

VIDEO_MEMORY equ 0xB8000
; SCREEN_COLOR equ 0x0a
SCREEN_COLOR equ 0x5b

_print_32:
	pusha 
	mov edx, VIDEO_MEMORY

_print_32_loop:
	mov al, [ebx]
	mov ah, SCREEN_COLOR

	cmp al, 0
	je _print_32_done

	mov [edx], ax
	add ebx, 1
	add edx, 2

	jmp _print_32_loop

_print_32_done:
	popa
	ret 

_clear_screen_32:
	mov cx, 2000
	mov edx, VIDEO_MEMORY

_clear:
	mov ax, ' '
	mov ah, SCREEN_COLOR
	mov [edx], ax
	dec cx
	add edx, 2
	cmp cx, 0
	jnz _clear
	ret 