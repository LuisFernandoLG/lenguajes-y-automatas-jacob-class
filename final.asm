%macro imprimir 2
    mov rax,1
    mov rdi,1
    mov rsi,%1
    mov rdx,%2
    syscall
%endmacro
section .data


var_41 db "Holi" 
len_41 equ $-var_41 



myName db "luis" 
len_myName equ $-myName

section .bss


global main
section .text 
main:

imprimir var_41, len_41
%rep 4 
 	 %assign luis 4 + 2 
%endrep
%assign w 1 * 4
%if 2 < 3 
 
  
 imprimir myName, len_myName 

%else 
 %assign abc 5 + 5 
%endif
salir: 
mov rax,60
mov rdi,0
syscall