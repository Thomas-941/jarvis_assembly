; external functions from X11 library
extern printf
extern XOpenDisplay
extern XDisplayName
extern XCloseDisplay
extern XCreateSimpleWindow
extern XMapWindow
extern XRootWindow
extern XSelectInput
extern XFlush
extern XCreateGC
extern XSetForeground
extern XDrawLine
extern XDrawPoint
extern XFillArc
extern XNextEvent

; external functions from stdio library (ld-linux-x86-64.so.2)    
extern printf
extern exit

%define	StructureNotifyMask	131072
%define KeyPressMask		1
%define ButtonPressMask		4
%define MapNotify		19
%define KeyPress		2
%define ButtonPress		4
%define Expose			12
%define ConfigureNotify		22
%define CreateNotify 16
%define QWORD	8
%define DWORD	4
%define WORD	2
%define BYTE	1
%define POINT_NUMBER 20

global main

section .bss
display_name:	resq	1
screen:			resd	1
depth:         	resd	1
connection:    	resd	1
width:         	resd	1
height:        	resd	1
window:		resq	1
gc:		resq	1
randomNum: resw 1

xredpoint: resw 1
yredpoint: resw 1

xcoord: resw POINT_NUMBER
ycoord: resw POINT_NUMBER

p: resw 1
q: resw 1
temp: resd 1
temp2: resq 1
temp3: resq 1



section .data

;xcoord: dw 43,156,24,354,123,78
;ycoord: dw 84,190,223,370,20,45

result: db "(%d:%d)",10,0
l: dw 0

event:		times	24 dq 0
showX: db "Value : %d",10,0
i: db 0
divide: dw 360

hullpos: dw 0
xhull: times POINT_NUMBER+1 dw 0
yhull: times POINT_NUMBER+1 dw 0

x1:	dd	0
x2:	dd	0
y1:	dd	0
y2:	dd	0

section .text
	
;##################################################
;########### PROGRAMME PRINCIPAL ##################
;##################################################

main:
xor     rdi,rdi
call    XOpenDisplay	; Création de display
mov     qword[display_name],rax	; rax=nom du display

; display_name structure
; screen = DefaultScreen(display_name);
mov     rax,qword[display_name]
mov     eax,dword[rax+0xe0]
mov     dword[screen],eax

mov rdi,qword[display_name]
mov esi,dword[screen]
call XRootWindow
mov rbx,rax

mov rdi,qword[display_name]
mov rsi,rbx
mov rdx,10
mov rcx,10
mov r8,400	; largeur
mov r9,400	; hauteur
push 0xFFFFFF	; background  0xRRGGBB
push 0x00FF00
push 1
call XCreateSimpleWindow
mov qword[window],rax

mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,131077 ;131072
call XSelectInput

mov rdi,qword[display_name]
mov rsi,qword[window]
call XMapWindow

mov rsi,qword[window]
mov rdx,0
mov rcx,0
call XCreateGC
mov qword[gc],rax

mov rdi,qword[display_name]
mov rsi,qword[gc]
mov rdx,0x000000	; Couleur du crayon
call XSetForeground

call random_coordinates
mov byte[i],0


    

call jarvis
mov byte[i],0



boucle: ; boucle de gestion des évènements
mov rdi,qword[display_name]
mov rsi,event
call XNextEvent

cmp dword[event],ConfigureNotify	; à l'apparition de la fenêtre
je dessin							; on saute au label 'dessin'

cmp dword[event],KeyPress			; Si on appuie sur une touche
je closeDisplay						; on saute au label 'closeDisplay' qui ferme la fenêtre
jmp boucle

;#########################################
;#		DEBUT DE LA ZONE DE DESSIN		 #
;#########################################
dessin:



drawPoints:

mov rdi,showX

;couleur du point 1
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0x000000	; Couleur du crayon ; rouge
call XSetForeground

; Dessin d'un point rouge sous forme d'un petit rond : coordonnées (100,200)
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]

push rbx
mov rbx,rbx
movzx rbx,byte[i]

movzx rcx,word[xcoord+rbx*WORD]		; coordonnée en x du point
sub ecx,3
movzx r8,word[ycoord+rbx*WORD] 		; coordonnée en y du point

pop rbx


sub r8,3
mov r9,6
mov rax,23040
push rax
push 0
push r9
call XFillArc

inc byte[i]
cmp byte[i], POINT_NUMBER-1
jbe drawPoints

mov byte[i],0


drawJarvis:

;couleur de la ligne 2
mov rdi,qword[display_name]
mov rsi,qword[gc]
mov edx,0xFFAA00    ; Couleur du crayon ; orange
call XSetForeground
; coordonnées de la ligne 1 (noire)


push rax
push rbx
push rcx

movzx ecx,byte[i]

movzx eax,word[xhull+ecx*WORD]
movzx ebx,word[yhull+ecx*WORD]

mov dword[x1],eax
mov dword[y1],ebx

inc ecx

movzx eax,word[xhull+ecx*WORD]
movzx ebx,word[yhull+ecx*WORD]

cmp eax,0
je finjarvis

mov dword[x2],eax
mov dword[y2],ebx

pop rcx
pop rax
pop rbx

; dessin de la ligne 1
mov rdi,qword[display_name]
mov rsi,qword[window]
mov rdx,qword[gc]
mov ecx,dword[x1]   ; coordonnée source en x
mov r8d,dword[y1]   ; coordonnée source en y
mov r9d,dword[x2]   ; coordonnée destination en x
push qword[y2]      ; coordonnée destination en y
call XDrawLine

cmp byte[i],POINT_NUMBER-1
inc byte[i]
jb drawJarvis

finjarvis:

    

    ;couleur du point 1
    mov rdi,qword[display_name]
    mov rsi,qword[gc]
    mov edx,0xFF0000	; Couleur du crayon ; rouge
    call XSetForeground
    
    ; Dessin d'un point rouge sous forme d'un petit rond : coordonnées (100,200)
    mov rdi,qword[display_name]
    mov rsi,qword[window]
    mov rdx,qword[gc]
    movzx rcx,word[xredpoint]		; coordonnée en x du point
    sub ecx,3
    movzx r8,word[yredpoint] 		; coordonnée en y du point
    sub r8,3
    mov r9,6
    mov rax,23040
    push rax
    push 0
    push r9
    call XFillArc
    


; ############################
; # FIN DE LA ZONE DE DESSIN #
; ############################
jmp flush

flush:
mov rdi,qword[display_name]
call XFlush
jmp boucle
mov rax,34
syscall

closeDisplay:
    mov     rax,qword[display_name]
    mov     rdi,rax
    call    XCloseDisplay
    xor	    rdi,rdi
    call    exit
    
global random_coordinates:

random_coordinates:
    push rbp
    mov ecx,ecx
    movzx ecx,byte[i]
    boucle1:
        bad:
            rdrand ax
            jnc bad

            xor dx,dx
            div word[divide]
            add dx,20
            mov word[xcoord+ecx*WORD],dx
            
        

        bad1:
            rdrand ax
            jnc bad1

            xor dx,dx
            div word[divide]
            add dx,20
            mov word[ycoord+ecx*WORD],dx
            
        
        inc byte[i]
        movzx ecx,byte[i]
        cmp byte[i], POINT_NUMBER
        jb boucle1
    
        
        bad2:
        rdrand ax
        jnc bad2

        xor dx,dx
        div word[divide]
        add dx,20
        mov word[xredpoint],dx
        
        bad3:
        rdrand ax
        jnc bad3

        xor dx,dx
        div word[divide]
        add dx,20
        mov word[yredpoint],dx
    
    
    pop rbp
    ret
	
	
	global jarvis:
    jarvis:
    
    
        push rbp
        
        searchP:
    inc byte[i]
    mov ecx,ecx
    movzx ecx,byte[i]
    
    mov edx,edx,
    movzx edx,word[l]
    
    mov ax,word[xcoord+edx*WORD]
    
    cmp word[xcoord+ecx*WORD],ax
    
    
    jb isbelow
    jmp isabove

    isbelow:
    mov word[l],cx
    isabove:
	
	cmp byte[i],POINT_NUMBER-1
	jb searchP
	
	
	mov ax,word[l]
	mov word[p],ax
	
	movzx ebx,word[p]
	mov ax,word[xcoord+ebx*WORD]
	mov cx,word[ycoord+ebx*WORD]
	
	movzx ebx,word[hullpos]    
	mov word[xhull+ebx*WORD],ax
	mov word[yhull+ebx*WORD],cx

    
	searchq:
	mov ax,word[p]
	mov bx,POINT_NUMBER
	inc ax
	xor dx,dx
	div bx
	mov word[q],dx
        
        mov byte[i],0
        
        findi:
            movzx ecx,word[q]
            movzx ebx,byte[i]
            movzx r8d,word[p]
            
           
            movzx eax,word[xcoord+ecx*WORD]
            movzx edx,word[xcoord+ebx*WORD]
            sub eax,edx
            mov dword[temp],eax
            
            movzx eax,word[ycoord+ebx*WORD]
            movzx edx,word[ycoord+r8d*WORD]
            sub eax,edx
            
            imul dword[temp]
        
            push rbx
            
            mov rbx,temp3 ; adresse de 'resultat1' dans ebx
            mov [rbx],eax ; on copie ax dans les 2 octets de poids faible de ebx
            mov [rbx+QWORD],edx
            
            mov rax,qword[temp3]
            
            mov qword[temp2],rax
            
            pop rbx
            
            movzx eax,word[ycoord+ecx*WORD]
            movzx edx,word[ycoord+ebx*WORD]
            sub eax,edx
            mov dword[temp],eax
            
            movzx eax,word[xcoord+ebx*WORD]
            movzx edx,word[xcoord+r8d*WORD]
            sub eax,edx
            
            imul dword[temp]
            
            push rbx
            
            mov rbx,temp3 ; adresse de 'resultat1' dans ebx
            mov [rbx],eax ; on copie ax dans les 2 octets de poids faible de ebx
            mov [rbx+QWORD],edx
                        
            pop rbx
            
            mov rax,qword[temp3]
            sub qword[temp2],rax
            
            cmp dword[temp2],0
            jle notBetter
            
            

            
            movzx bx,byte[i]
            mov word[q],bx
            
            notBetter:
            
            inc byte[i]
            cmp byte[i],POINT_NUMBER
            
            jb findi
            
            
            
        mov ax,word[q]
        mov word[p],ax
        inc word[hullpos]
        
        movzx eax,word[p]
        
        mov bx,word[xcoord+eax*WORD]
        mov dx,word[ycoord+eax*WORD]
        
        
        movzx ecx,word[hullpos]
        
        mov word[xhull+ecx*WORD],bx
        mov word[yhull+ecx*WORD],dx
        
        
        mov ax,word[l]
        cmp word[p],ax
        jne searchq
        
    
        
        mov byte[i],0
        
        
        
        pop rbp
    ret

