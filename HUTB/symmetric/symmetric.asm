;============================================================
; 听说有人喜欢挑战自己
; 看看下面的加解密算法吧
; flag是 EAC547B408C19905BD2B227F5D901DB0A14A54BAFA1AF2BF
;============================================================

.386
.model flat, stdcall
option casemap :none

.data
strKey db 13h,34h,57h,79h,9Bh,0BCh,0DFh,0F1h      ;64位Key
SubKey dq 16 dup(0)                               ;16个48位子Key，每个子Key占用8字节空间
lResult dd 0                                      ;保留（用于VB6.0内嵌汇编编程）
;
DataIn db 01h,23h,45h,67h,89h,0ABh,0CDh,0EFh      ;64位输入数据（明文）
;DataIn db 85h,0E8h,13h,54h,0Fh,0Ah,0B4h,05h      ;64位输入数据（密文）
DataOut db 8 dup(0)                               ;64位输出数据
WorkMode db 0                                     ;工作模式 0：加密，非0：解密
;WorkMode db 8

.code
main:
        lea eax,lResult                                ;保留
        push eax
        lea eax,SubKey                                 ;子密钥数组首地址
        push eax
        lea eax,strKey                                 ;密钥地址
        push eax
        push 0                                         ;保留
        call KEYPROC

        lea eax,lResult                                ;保留
        push eax
        lea eax,DataIn                                 ;64位输入数据地址
        push eax
        lea eax,DataOut                                ;64位输出数据地址
        push eax
        lea eax,SubKey                                 ;子密钥数组首地址
        push eax
        lea eax,WorkMode                               ;工作模式变量地址
        push eax
        push 0                                         ;保留
        call PROC

        ;说明：上述调用步骤是VB6.0调用类函数时的标准方法，本人用于VB6.0内嵌汇编编程，保留的参数忽略即可。

        ret
;************************************
;************************************
;**                                **
;**      计算16组子密钥代码        **
;**                                **
;************************************
;************************************
KEYPROC:
        mov ebp,esp
        pushad
        call NEXT1

        ;  PC-1置换表:
        db 57,49,41,33,25,17,09,01
        db 58,50,42,34,26,18,10,02
        db 59,51,43,35,27,19,11,03
        db 60,52,44,36,63,55,47,39
        db 31,23,15,07,62,54,46,38
        db 30,22,14,06,61,53,45,37
        db 29,21,13,05,28,20,12,04

        ;  PC-2置换表:
        db 14,17,11,24,01,05,03,28
        db 15,06,21,10,23,19,12,04
        db 26,08,16,07,27,20,13,02
        db 41,52,31,37,47,55,30,40
        db 51,45,33,48,44,49,39,56
        db 34,53,46,42,50,36,29,32

        db 16 dup(90h)

NEXT1:
        pop ebx                  ;EBX的值为PC-1的首地址

        ;取出64位strKey的首地址，交换高低位后放入EDX:EAX
        mov ecx,[ebp+8]
        mov dh,byte ptr[ecx]
        mov dl,byte ptr[ecx+1]
        shl edx,16
        mov dh,byte ptr[ecx+2]
        mov dl,byte ptr[ecx+3]
        mov ah,byte ptr[ecx+4]
        mov al,byte ptr[ecx+5]
        shl eax,16
        mov ah,byte ptr[ecx+6]
        mov al,byte ptr[ecx+7]

        ;=====================================================

        ;PC-1置换
        xor esi,esi              ;EDI、ESI清零
        xor edi,edi              ;转换后的结果放在：EDI:ESI
        mov ch,1                 ;计数器置1
CHG_PC1_1:                  ;由于没有第32位、64位的移位操作，无须特殊处理。（移动次数为0或寄存器长度的整数倍时，均为移动0次，对标志位无影响）
        mov cl,byte ptr[ebx]
        cmp cl,32                ;位数大于32，对EAX操作
        ja PC1_A32_1
        push edx                 ;否则对EDX操作
        rol edx,cl
        pop edx
        jmp PC1_EDI
PC1_A32_1:
        push eax
        rol eax,cl
        pop eax
PC1_EDI:
        rcl edi,1                ;前28位数据（高位）放在EDI
        inc ebx
        inc ch
        cmp ch,28
        jbe CHG_PC1_1

CHG_PC1_2:
        mov cl,byte ptr[ebx]
        cmp cl,32                ;位数大于32，对EAX操作
        ja PC1_A32_2
        push edx                 ;否则对EDX操作
        rol edx,cl
        pop edx
        jmp PC1_ESI
PC1_A32_2:
        push eax
        rol eax,cl
        pop eax
PC1_ESI:
        rcl esi,1                ;后28位数据（低位）放在ESI
        inc ebx
        inc ch
        cmp ch,56
        jbe CHG_PC1_2
        mov edx,edi              ;转换后结果重新放入EDX:EAX，EBX的值为PC-2置换表首地址
        mov eax,esi

        ;=====================================================

        ;16轮循环计算SubKey(1)-SubKey(16)
        xor ecx,ecx              ;ECX计数器初值0，终值15
FOR_ECX:
        cmp ecx,0                ;判断循环轮数，0表示第1轮，依次类推
        jz  SHL_1
        cmp ecx,1
        jz  SHL_1
        cmp ecx,8
        jz  SHL_1
        cmp ecx,15
        jz  SHL_1            ;第1、2、9、16轮左移1位，其它左移2位
        shl edx,4            ;循环左移1位（除第1、2、9、16轮之外）
        sar edx,4
        rol edx,1
        shl eax,4
        sar eax,4
        rol eax,1
SHL_1:
        shl edx,4            ;循环左移1位（所有16轮）
        sar edx,4
        rol edx,1
        shl eax,4
        sar eax,4
        rol eax,1            ;完成Cn、Dn循环左移
        push eax             ;保护高、低各28位的EDX:EAX，下一轮继续移位
        push edx             ;保护EBX，每轮都要进行PC-2置换
        push ebx
        push ecx
        shl edx,4            ;合并EDX:EAX：高28位:低28位 ——>高32位:低24位(EAX高24位,EAX低8位AL置0)
        shl eax,4            ;EAX先左移4位，低4位补0
        rol eax,4            ;再循环左移4位，将28位有效数据的高4位移到低4位
        add dl,al            ;有效数据追加到EDX低4位
        xor al,al            ;EAX低8位清零


        xor esi,esi
        xor edi,edi
        mov ch,1              ;PC-2置换，ch计数器初值1，终值48
CHG_PC2_1:
        mov cl,byte ptr[ebx]
        cmp cl,32             ;位数大于32，对EAX操作
        ja PC2_A32_1          ;否则对EDX操作
        push edx
        rol edx,cl
        pop edx
        jmp PC2_EDI
PC2_A32_1:
        push eax
        rol eax,cl
        pop eax
PC2_EDI:
        rcl edi,1             ;前32位数据（高位）放在EDI
        inc ebx
        inc ch
        cmp ch,32
        jbe CHG_PC2_1

CHG_PC2_2:
        mov cl,byte ptr[ebx]
        cmp cl,32             ;位数大于32，对EAX操作
        ja PC2_A32_2          ;否则对EDX操作
        je PC2_E32
        push edx
        rol edx,cl
        pop edx
        jmp PC2_ESI
PC2_E32:                        ;当移动次数是寄存器长度倍数时（32、64……），相当于不移动（次数为0），对标志位无影响
        push edx              ;解决办法是：拆分成两次移动，两次移动总和为32
        rol edx,1             ;例如：先移动1位，再移动31位
        dec cl
        rol edx,cl
        pop edx
        jmp PC2_ESI
PC2_A32_2:
        push eax
        rol eax,cl
        pop eax
PC2_ESI:
        rcl esi,1            ;后16位数据（低位）放在ESI
        inc ebx              ;SubKey放在EDI:ESI中，格式为：高32位:低16位（ESI高16位为有效数据，低16位置0）
        inc ch
        cmp ch,48
        jbe CHG_PC2_2
        shl esi,16

        ;=====================================================

        pop ecx               ;恢复16轮计数器
        mov ebx,[ebp+12]      ;SubKey首地址
        mov [ebx+8*ecx],esi   ;计算SubKey(n)地址，ESI放在低4字节
        mov [ebx+8*ecx+4],edi ;EDI放在高4字节
        pop ebx               ;恢复PC-2表首地址
        pop edx               ;恢复Cn、Dn到EDX:EAX，进入下一轮移位
        pop eax
        inc ecx               ;计数器加1
        cmp ecx,16            ;从0到15，循环16次
        jnz FOR_ECX

        popad
        ret 10h
PROC:
        mov ebp,esp
        pushad
        call NEXT2

        ;初始变换置换表 IP:
        db 58,50,42,34,26,18,10,02
        db 60,52,44,36,28,20,12,04
        db 62,54,46,38,30,22,14,06
        db 64,56,48,40,32,24,16,08
        db 57,49,41,33,25,17,09,01
        db 59,51,43,35,27,19,11,03
        db 61,53,45,37,29,21,13,05
        db 63,55,47,39,31,23,15,07

        ;扩展置换表 E:
        db 32,01,02,03,04,05
        db 04,05,06,07,08,09
        db 08,09,10,11,12,13
        db 12,13,14,15,16,17
        db 16,17,18,19,20,21
        db 20,21,22,23,24,25
        db 24,25,26,27,28,29
        db 28,29,30,31,32,01

        ;S盒1:
        db 14,4,13,1,2,15,11,8,3,10,6,12,5,9,0,7
        db 0,15,7,4,14,2,13,1,10,6,12,11,9,5,3,8
        db 4,1,14,8,13,6,2,11,15,12,9,7,3,10,5,0
        db 15,12,8,2,4,9,1,7,5,11,3,14,10,0,6,13

        ;S盒2:
        db 15,1,8,14,6,11,3,4,9,7,2,13,12,0,5,10
        db 3,13,4,7,15,2,8,14,12,0,1,10,6,9,11,5
        db 0,14,7,11,10,4,13,1,5,8,12,6,9,3,2,15
        db 13,8,10,1,3,15,4,2,11,6,7,12,0,5,14,9

        ;S盒3:
        db 10,0,9,14,6,3,15,5,1,13,12,7,11,4,2,8
        db 13,7,0,9,3,4,6,10,2,8,5,14,12,11,15,1
        db 13,6,4,9,8,15,3,0,11,1,2,12,5,10,14,7
        db 1,10,13,0,6,9,8,7,4,15,14,3,11,5,2,12

        ;S盒4:
        db 7,13,14,3,0,6,9,10,1,2,8,5,11,12,4,15
        db 13,8,11,5,6,15,0,3,4,7,2,12,1,10,14,9
        db 10,6,9,0,12,11,7,13,15,1,3,14,5,2,8,4
        db 3,15,0,6,10,1,13,8,9,4,5,11,12,7,2,14

        ;S盒5:
        db 2,12,4,1,7,10,11,6,8,5,3,15,13,0,14,9
        db 14,11,2,12,4,7,13,1,5,0,15,10,3,9,8,6
        db 4,2,1,11,10,13,7,8,15,9,12,5,6,3,0,14
        db 11,8,12,7,1,14,2,13,6,15,0,9,10,4,5,3

        ;S盒6:
        db 12,1,10,15,9,2,6,8,0,13,3,4,14,7,5,11
        db 10,15,4,2,7,12,9,5,6,1,13,14,0,11,3,8
        db 9,14,15,5,2,8,12,3,7,0,4,10,1,13,11,6
        db 4,3,2,12,9,5,15,10,11,14,1,7,6,0,8,13

        ;S盒7:
        db 4,11,2,14,15,0,8,13,3,12,9,7,5,10,6,1
        db 13,0,11,7,4,9,1,10,14,3,5,12,2,15,8,6
        db 1,4,11,13,12,3,7,14,10,15,6,8,0,5,9,2
        db 6,11,13,8,1,4,10,7,9,5,0,15,14,2,3,12

        ;S盒8:
        db 13,2,8,4,6,15,11,1,10,9,3,14,5,0,12,7
        db 1,15,13,8,10,3,7,4,12,5,6,11,0,14,9,2
        db 7,11,4,1,9,12,14,2,0,6,10,13,15,3,5,8
        db 2,1,14,7,4,10,8,13,15,12,9,0,3,5,6,11

        ;P盒置换表:
        db 16,07,20,21,29,12,28,17,01,15,23,26,05,18,31,10
        db 02,08,24,14,32,27,03,09,19,13,30,06,22,11,04,25

        ;逆置换表IP_1:
        db 40,08,48,16,56,24,64,32,39,07,47,15,55,23,63,31
        db 38,06,46,14,54,22,62,30,37,05,45,13,53,21,61,29
        db 36,04,44,12,52,20,60,28,35,03,43,11,51,19,59,27
        db 34,02,42,10,50,18,58,26,33,01,41,09,49,17,57,25

        db 16 dup(90h)

NEXT2:
        pop ebx                  ;EBX的值为初始变换IP的首地址

        ;取出64位DataIn数据的首地址，交换高低位后放入EDX:EAX
        mov ecx,[ebp+20]
        mov dh,byte ptr[ecx]
        mov dl,byte ptr[ecx+1]
        shl edx,16
        mov dh,byte ptr[ecx+2]
        mov dl,byte ptr[ecx+3]
        mov ah,byte ptr[ecx+4]
        mov al,byte ptr[ecx+5]
        shl eax,16
        mov ah,byte ptr[ecx+6]
        mov al,byte ptr[ecx+7]

        ;=====================================================

        ;初始IP变换
        push edx               ;EDX:EAX做为入口参数入栈，利用堆栈做为临时变量
        push eax
        xor esi,esi            ;EDI:ESI清零，保存IP变换后的结果
        xor edi,edi
        xor eax,eax
        mov ecx,32
IP_L32:
        mov al,byte ptr[ebx]
        cmp al,32
        ja IP_A32L
        neg al
        add al,32               ;AL=32-AL，将算法的位顺序转换成CPU默认的位顺序
        bt [esp+4],eax
        jmp IP_EDI
IP_A32L:
        neg al
        add al,64               ;AL=64-AL，将算法的位顺序转换成CPU默认的位顺序
        bt [esp],eax
IP_EDI:
        rcl edi,1
        inc ebx
        loop IP_L32

        mov ecx,32
IP_R32:
        mov al,BYTE ptr[ebx]
        cmp al,32
        ja IP_A32R
        neg al
        add al,32
        bt [esp+4],eax
        jmp IP_ESI
IP_A32R:
        neg al
        add al,64
        bt [esp],eax
IP_ESI:
        rcl esi,1
        inc ebx
        loop IP_R32

        add esp,8

        ;=====================================================

        ;开始16轮迭代运算
        ;入口参数Ln、Rn为EDI:ESI
        xor ecx,ecx             ;循环次数初值0

Func_16:
        ;扩展置换E:
        push ebx             ;保护扩展置换E首地址
        push ecx
        push edi               ;Ln入栈
        push esi               ;Rn入栈
        xor edi,edi            ;EDI、ESI清零，用于保存E置换后的48位值
        xor esi,esi            ;格式为：EDI:ESI（高32位:高16位，ESI低16位置0）
        xor eax,eax

        mov ecx,32
E_32:
        mov al,byte ptr[ebx]
        neg al
        add al,32
        bt [esp],eax
        rcl edi,1
        inc ebx
        loop E_32

        mov ecx,16
E_16:
        mov al,byte ptr[ebx]
        neg al
        add al,32
        bt [esp],eax
        rcl esi,1
        inc ebx
        loop E_16
        shl esi,16

        ;=====================================================

        ;与子密钥进行XOR运算
        mov ecx,[esp+8]       ;取出循环次数
        mov eax,[ebp+8]       ;取出WorkMode地址
        cmp BYTE ptr[eax],0           ;0:加密，非0:解密
        jz ENCODE
        neg ecx
        add ecx,15            ;ECX=15-ECX，解密时子密钥顺序相反
ENCODE:
        mov eax,[ebp+12]      ;取出SubKey首地址
        push [eax+ecx*8+4]    ;SubKey(n)高4字节入栈
        push [eax+ecx*8]      ;SubKey(n)低4字节入栈
XOR_SUBKEY:
        xor edi,[esp+4]       ;与子密钥进行XOR运算
        xor esi,[esp]         ;结果保存在：EDI:ESI（高32位:高16位，ESI低16位置0）
        add esp,8

        mov eax,edi
        shl eax,24
        shr esi,8
        add esi,eax          ;结果转换为：EDI:ESI（高24位:高24位，EDI、ESI低8位无意义）


        ;=====================================================

        ;S盒置换：
        xor edx,edx          ;EDX清零，用于保存S盒转换后的结果
        mov ecx,0            ;S盒计数
S0_S7:
        shl edx,4            ;EDX左移4位，准备追加下一组数据
        cmp ecx,4            ;
        jNE S_N4
        mov edi,esi          ;转换后4组数据
S_N4:
        rol edi,6            ;高6位循环左移至低6位
        mov eax,edi          ;保存在AL低6位
        mov ah,al            ;再保存一份到AH
        ror ah,1
        sar ah,4
        rol ah,1
        and ah,3             ;计算AH，AH=S盒的行数
        shr al,1
        and al,0fh           ;计算AL，AL=S盒的列数
        shl ah,4             ;AH=AH*16
        add al,ah            ;AL=AH+AL
        and eax,0FFh         ;EAX高24位清零
        add dl,BYTE ptr[ebx+eax]    ;查找S盒数据，追加到EDX低4位
        add ebx,64           ;下一个S盒首地址
        inc ecx
        cmp ecx,8
        jb S0_S7

        ;=====================================================

        ;P盒置换:
        xor esi,esi          ;ESI清零，用于保存P盒置换后的结果
        mov ecx,32
P_32:
        mov al,byte ptr[ebx]
        neg al
        add al,32
        bt edx,eax
        rcl esi,1
        inc ebx
        loop P_32

        ;=====================================================

        xor esi,[esp+4]       ;P盒结果与L(n-1)异或，得到ESI=Rn
        pop edi               ;Ln=R(n-1),保存到EDI=Ln
        add esp,4             ;恢复堆栈
        pop ecx               ;恢复16轮迭代计数器
        pop ebx               ;恢复扩展置换E首地址
        inc ecx
        cmp ecx,16
        jb Func_16
        xchg edi,esi          ;交换L16和R16
        add ebx,592           ;EBX指向逆置换表IP_1首地址

        ;=====================================================

        ;逆置换IP_1:
        push edi               ;EDI:ESI做为入口参数入栈，利用堆栈做为临时变量
        push esi
        xor esi,esi            ;EDI:ESI清零，保存IP_1变换后的结果
        xor edi,edi
        xor eax,eax            ;实现代码与初始置换IP完全相同。
        mov ecx,32
IP_1_L32:
        mov al,byte ptr[ebx]
        cmp al,32
        ja IP_1_A32L
        neg al
        add al,32               ;AL=32-AL，将算法的位顺序转换成CPU默认的位顺序
        bt [esp+4],eax
        jmp IP_1_EDI
IP_1_A32L:
        neg al
        add al,64               ;AL=64-AL，将算法的位顺序转换成CPU默认的位顺序
        bt [esp],eax
IP_1_EDI:
        rcl edi,1
        inc ebx
        loop IP_1_L32

        mov ecx,32
IP_1_R32:
        mov al,BYTE ptr[ebx]
        cmp al,32
        ja IP_1_A32R
        neg al
        add al,32
        bt [esp+4],eax
        jmp IP_1_ESI
IP_1_A32R:
        neg al
        add al,64
        bt [esp],eax
IP_1_ESI:
        rcl esi,1
        inc ebx
        loop IP_1_R32

        add esp,8

        ;=====================================================
        mov ecx,[ebp+16]        ;交换高低位，结果存放在DataOut变量中
        mov eax,edi             ;后期的Intel CPU 有一个MOVBE指令，可以快速实现换位，但AMD的CPU不支持
        mov [ecx+3],al
        mov [ecx+2],ah
        shr eax,16
        mov [ecx+1],al
        mov [ecx],ah
        mov eax,esi
        mov [ecx+7],al
        mov [ecx+6],ah
        shr eax,16
        mov [ecx+5],al
        mov [ecx+4],ah

        popad
        ret 18h

        end main
