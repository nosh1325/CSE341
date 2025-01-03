ORG 100H          ;location 0700:0100

.DATA
arr DB 20 DUP(?)        
neg_flag DB 0
len DW ?
min_idx DW ?
len_1 DW ? 
sum Db ?  
first DB ?
second DB ?
newline_prompt DB 0Dh, 0Ah, '$'
prompt1 DB "Enter the numbers separated by space: $"
msg1 DB "Smallest sum: $"
msg2 DB "Two pairs which have the smallest sum= $"
msg3 DB " and $"          

.CODE
MAIN PROC
    ; Initialize DS
    MOV AX,@DATA
    MOV DS,AX
    
    LEA DX,prompt1
    MOV AH,9
    INT 21H 
    
    CALL stor_arr
    CALL sort 
    CALL smallest_sum

    ; Exit to DOS
    MOV AX,4C00H
    INT 21H
MAIN ENDP

stor_arr PROC
    
    
    
    LEA SI,arr         
    MOV SI,0          

input_loop:
    MOV AH,1
    INT 21H
    CMP AL,' '         
    JE input_loop

    CMP AL,'-'         
    JE neg_handle      

    CMP AL,0DH         
    JE end_input

    
    SUB AL,30H         
    
    CMP neg_flag,1     
    JNE store_num      

    NEG AL             
    MOV neg_flag,0     

store_num:
    MOV arr[SI],AL    
    INC SI            

    JMP input_loop         

neg_handle:
    
    MOV neg_flag,1     
    JMP input_loop

end_input:
    MOV CX,SI          
    MOV len,CX 
    SUB CX,1
    MOV len_1,CX
    MOV CX,0

    RET
stor_arr ENDP

sort PROC
    MOV SI,0
    MOV CX,len ;give array length
    MOV BP,0

Loop1: 
    MOV min_idx,SI
    MOV AX,SI
    INC SI
    MOV DI,SI 

loop2: 
    CMP BP,len_1 ;array_length -1
    JGE break

    MOV BX,min_idx
    MOV DL,arr[BX]
    MOV DH,arr[DI]

    CMP DL,DH
    JG update
    INC DI
    INC BP 
    JMP loop2

update:
    MOV min_idx,DI
    INC DI
    INC BP 
    JMP loop2

break:
    MOV SI,AX 
    MOV BX,0 ;clearing
    MOV DX,0
    MOV BX,min_idx 
    MOV DL,arr[BX]
    MOV DH,arr[SI]
    MOV arr[SI],DL
    MOV arr[BX],DH
    INC SI
    MOV BP,SI

    LOOP Loop1

RET 
sort ENDP


;RET
 

smallest_sum PROC

MOV BX,len
SUB BX,1
MOV len_1,BX
MOV BX,0   

MOV AL,arr[0]
MOV AH,arr[1]

ADD AL,AH

CMP AL,0
JL fi_neg

MOV sum,AL 

fi_neg:
NEG AL
MOV sum,AL


MOV DI,-1
outer:
INC DI
CMP DI,len_1
JGE exit

MOV BX,len_1
SUB BX,DI

MOV CX,BX
MOV DX,DI
ADD DX,1
MOV SI,DX
inner:

MOV AL,arr[DI]
MOV AH,arr[SI]

ADD AL,AH
INC SI

CMP AL,0
JL abs
 
CMP AL,sum
JL update_sum
JMP break_in

abs:
NEG AL  

CMP AL,sum
JL update_sum
JMP break_in 

update_sum:
MOV sum,AL
MOV DH,arr[DI]
MOV DL,arr[SI-1]
MOV first,DH
MOV second,DL

break_in:

LOOP inner
 
JMP outer


exit:

LEA DX,newline_prompt
MOV AH,9
INT 21H

LEA DX,msg1
MOV AH,9
INT 21H

MOV AH,2
MOV DL,sum
ADD DL,30H
INT 21H

LEA DX,newline_prompt
MOV AH,9
INT 21H

LEA DX,msg2
MOV AH,9
INT 21H

MOV BH,first
CMP BH,0
JL print_neg_1

MOV AH,2
MOV DL,BH
ADD DL,30H
INT 21H

print:

LEA DX,msg3
MOV AH,9
INT 21H 


MOV BH,second
CMP BH,0
JL print_neg_2

MOV AH,2
MOV DL,BH
ADD DL,30H
INT 21H 

JMP end

print_neg_1:
NEG BH

MOV DL,'-'         ; Print negative sign
MOV AH,2
INT 21H

MOV DL,BH
ADD DL,30H
INT 21H

JMP print 

print_neg_2: 

NEG BH

MOV DL,'-'         ; Print negative sign
MOV AH,2
INT 21H

MOV DL,BH
ADD DL,30H
INT 21H

end:

RET
smallest_sum ENDP
 

;exit to DOS



END MAIN
