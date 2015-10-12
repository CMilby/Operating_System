
[bits 16]

CODE_SEGMENT equ _gdt_code - _gdt_start
DATA_SEGMENT equ _gdt_data - _gdt_start

_gdt_start:

_gdt_null:
	dd 0x0
	dd 0x0

_gdt_code:
	dw 0xffff 
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

_gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

_gdt_end:

_gdt_descriptor:
	dw _gdt_end - _gdt_start - 1
	dd _gdt_start

