dd if=/dev/zero bs=1024 count=1440 > OS.dmg

nasm -f bin boot1.asm -o boot1.bin
nasm -f bin boot2.asm -o boot2.bin

dd if=boot1.bin of=OS.dmg conv=notrunc
dd if=boot2.bin of=OS.dmg obs=512 seek=1 conv=notrunc