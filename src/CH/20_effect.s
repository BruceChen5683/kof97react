.include	"def.inc"
.globl		EffectRoutine0
.globl		EffectRoutine3
.globl		EffectRoutine6
.globl		EffectRoutine7

EffectRoutine0:                         | 0, hit spark
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), Object.ActCode(a4)
        movea.l Object.ParentObj(a4), a3
        btst    #4, Object.RoleStatusFlags(a3)  | bit4: 1, ������
        beq.w   EffectRoutineContinue
        addq.w  #3, Object.ActCode(a4)
        bra.w   EffectRoutineContinue

EffectRoutine3:                         | 3, blood spark
        subq.w  #3, Object.selfBuf2(a4) 
|        tst.b   A5Seg.BloodColor(a5)    | bit7: 0, show blood effect
|        bmi.s   EffectRoutine0          | 0, hit spark
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), Object.ActCode(a4)
        addi.w  #9, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine6:                         | 6, ice ?
        jsr     GetByteRandVal          
        tst.b   d0
        bpl.w   EffectDestroy
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0x27, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine7:                         | 7, big blood
        jsr     GetByteRandVal          
        tst.b   d0
        bpl.w   EffectDestroy
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4) 
        move.w  #0x28, Object.ActCode(a4)
|        tst.b   A5Seg.BloodColor(a5)    | bit7: 0, show blood effect
|        bmi.w   EffectRoutineContinueEX
        andi.w  #1, d0
        beq.w   EffectRoutineContinueEX
        move.w  #0x2E, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine8:                         | 8, big ice ?
        jsr     GetByteRandVal          
        tst.b   d0
        bpl.w   EffectDestroy
        move.w  #0x10, Object.Z(a4)    
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0x28, Object.ActCode(a4)
|        tst.b   A5Seg.BloodColor(a5)    | bit7: 0, show blood effect
|        bmi.w   EffectRoutineContinueEX
        andi.w  #1, d0
        beq.w   EffectRoutineContinueEX
        move.w  #0x2B, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine9:                         | 9, big hit spark
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #2, Object.ActCode(a4)
        movea.l Object.ParentObj(a4), a3
        btst    #4, Object.RoleStatusFlags(a3) | bit4: 1, ������
        beq.w   EffectRoutineContinue
        move.w  #5, Object.ActCode(a4)
        bra.w   EffectRoutineContinue

EffectRoutineA:                         | a, explode
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), d0
        addi.w  #0xC, d0
        move.w  d0, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutineF:                         | f, small fire
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0x1B, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine10:                        | 10, blow fire
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0x1C, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine11:                        | 11, blow spark
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0xC, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine12:                        | 12, elect
        move.w  #0x10, Object.Z(a4)     

loc_2B4C4:                              
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), d0
        addi.w  #0xB, d0
        move.w  d0, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine17:                        | 17, on ground with sound
        move.w  #0x75, d0               
        jsr     SET_SOUND               
        move.w  #0xFFF0, Object.Z(a4)   
        bra.s   loc_2B4C4

EffectRoutine55:                        | 55, on ground 1
        move.w  #0x20, Object.ChCode(a4) 
        move.w  #0x22, Object.ActCode(a4)
        move.w  #0xFFF0, Object.Z(a4)   
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine56:                        | 56, on ground 2
        move.w  #0x20, Object.ChCode(a4) 
        move.w  #0x23, Object.ActCode(a4)
        move.w  #0x10, Object.Z(a4)     
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine57:                        | 57, on ground 3
        move.w  #0x20, Object.ChCode(a4) 
        move.w  #0x24, Object.ActCode(a4)
        move.w  #0xFFF0, Object.Z(a4)  
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine1a:                        | 1a, dust
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), d0
        addi.w  #0x1C, d0
        move.w  d0, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine1d:                       | 1d, blood explode
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), d0
        addi.w  #0x13, d0
        move.w  d0, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine23:                        | 23, explode with dust
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  Object.selfBuf2(a4), d0
        addi.w  #0x18, d0
        move.w  d0, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine25:                        | 25, flash creen
        move.b  #1, A5Seg.FlashScreenTypeIndex(a5) 
        jmp     FreeObjBlock           

EffectRoutine26:                        | 26, big ice ?
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0x28, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX

EffectRoutine27:                       | 27, blow spark
        move.w  #0x10, Object.Z(a4)     
        move.w  #0x20, Object.ChCode(a4)
        move.w  #0x40, Object.ActCode(a4)
        bra.w   EffectRoutineContinueEX
| ---------------------------------------------------------------------------

EffectRoutine28:                        | 28, shake screen 1
        jsr     InitShakeScreenObj      
        jmp     FreeObjBlock            
| ---------------------------------------------------------------------------

EffectRoutine29:                        | 29, shake screen 2
        jsr     InitShakeScreen2Obj     
        jmp     FreeObjBlock           
| ---------------------------------------------------------------------------

EffectRoutine2A:                        | 2a, shake screen 3
        jsr     InitShakeScreen3Obj     
        jmp     FreeObjBlock          

EffectRoutineContinueEX:                
        movea.l Object.ParentObj(a4), a3

EffectRoutineContinue:                 
        move.w  Object.Z(a3), d0        | bit 0~2: ͬһͼ���е�ϸ�Ƚ�
                                        | bit4����: �� Zbuf �е�����
        add.w   d0, Object.Z(a4)        | bit 0~2: ͬһͼ���е�ϸ�Ƚ�
                                        | bit4����: �� Zbuf �е�����
        move.b  Object.IsFaceToRight(a3), Object.IsFaceToRight(a4) | bit0: Horizontal flip
                                        | bit1: Vertical flip
                                        | bit2: 2bit Auto-anim
                                        | bit3: 3bit Auto-anim
                                        | ʵ������SCB1 tile �ڶ�word �ĵ��ֽ�����
        move.w  Object.OriX(a4), d0     | ��ͼԭ��(ʮ��)�ĺ�����, �����߼�λ��, ���ص�λ
        btst    #0, Object.IsFaceToRight(a3) | bit0: Horizontal flip
                                        | bit1: Vertical flip
                                        | bit2: 2bit Auto-anim
                                        | bit3: 3bit Auto-anim
                                        | ʵ������SCB1 tile �ڶ�word �ĵ��ֽ�����
        beq.s   loc_2B2A6
        neg.w   d0

loc_2B2A6:                              | CODE XREF: EffectRoutine0-A4j
        add.w   Object.OriX(a3), d0     | ��ͼԭ��(ʮ��)�ĺ�����, �����߼�λ��, ���ص�λ
        move.w  d0, Object.OriX(a4)     | ��ͼԭ��(ʮ��)�ĺ�����, �����߼�λ��, ���ص�λ
        move.w  Object.OriY(a3), d0     | ��ͼԭ��(ʮ��)��������, �����߼��߶�, ���ص�λ
        add.w   d0, Object.OriY(a4)     | ��ͼԭ��(ʮ��)��������, �����߼��߶�, ���ص�λ
        move.w  Object.YFromGround(a3), Object.YFromGround(a4) | ����ʱ�������߶�, ���ص�λ
        move.b  #0xFF, Object.PrevActCode(a4)
        move.w  #0xFFFF, Object.RoleShrinkRate(a4) | �����������

SetEffectWait:                         
        move.l  #EffectWait, Object(a4)

EffectWait:                             
        tst.b   Object.HitBoxFlag(a4)   | bit0: 1, have hit box 0
                                        | bit1: 1, have hit box 1
                                        | bit2: 1, have hit box 2
                                        | bit3: 1, have hit box 3
                                        | bit4: 1, ����Ч��, �ƿշ�
                                        | bit5: 1, ���е��ߵķ����1hit
                                        | bit6: 1, ��ײ������������box0(��������һ֡��ļ��)
                                        | bit7: 1, Act end
        bmi.s   EffectDestroy
        jsr     GetNextMov              | ret:
                                        |     d0: 0, done;
                                        |        -1, new graph info loaded
        jmp     InsertIntoObjZBuf       | params:
                                        |     a4: obj
                                        | ret:
                                        |     d6: 0, done; -1: fail
| ---------------------------------------------------------------------------

EffectDestroy:                          | CODE XREF: EffectRoutine0-74j
                                        | ROM:0002B32Cj ...
        jmp     FreeObjBlock            | params:
| END OF FUNCTION CHUNK FOR EffectRoutine0 |     a4: Obj


InitShakeScreenObj:                     
        lea     (ShakeScreenRoutine).l, a0
        move.w  #0x50FF, d0
        jsr     (AllocateObjBlock).l    
        move.l  a4, Object.ParentObj(a1)
        move.w  #0xA, Object.selfBuf1(a1) | ����ʱ��
        move.w  #0xFFFC, Object.selfBuf1+2(a1) | Y��ͷƫ��
        rts


InitShakeScreen2Obj:                    
        lea     (ShakeScreenRoutine).l, a0
        move.w  #0x50FF, d0
        jsr     (AllocateObjBlock).l    
        move.l  a4, Object.ParentObj(a1)
        move.w  #0xF, Object.selfBuf1(a1)
        move.w  #0xFFFA, Object.selfBuf1+2(a1)
        rts


InitShakeScreen3Obj:                    
        lea     (ShakeScreenRoutine).l, a0
        move.w  #0x50FF, d0
        jsr     (AllocateObjBlock).l   
        move.l  a4, Object.ParentObj(a1)
        move.w  #0x14, Object.selfBuf1(a1)
        move.w  #0xFFF8, Object.selfBuf1+2(a1)
        rts

ShakeScreenRoutine:                     
        move.l  #_ShakeScreenRoutine_step2, Object(a4)
|        moveq   #0, d0
|        move.b  A5Seg.BackgroundId(a5), d0 | ��ս����ѡ��0��7
|        add.w   d0, d0
|        add.w   d0, d0
|        lea     off_2AAA6, a0
|        movea.l (a0,d0.w), a0
|        jsr     (a0)

_ShakeScreenRoutine_step2:                                 
        move.w  Object.selfBuf1+2(a4), d1 | Y camera delta
        bchg    #0, Object.selfBuf1+4(a4)
        beq.s   loc_2AA90
        moveq   #0, d1

loc_2AA90:                              
        move.w  d1, A5Seg.GlobalCamaraYDelta(a5) | ȫ�־�ͷ��Yƫ��, �����Ч����, neg ��ʾ��ͷ����
        subq.w  #1, Object.selfBuf1(a4) | time
        beq.s   _ShakeScreenRoutine_destroy
        rts
| ---------------------------------------------------------------------------

_ShakeScreenRoutine_destroy:                               
        clr.w   A5Seg.GlobalCamaraYDelta(a5) | ȫ�־�ͷ��Yƫ��, �����Ч����, neg ��ʾ��ͷ����
        jmp     FreeObjBlock            | params:
| End of function ShakeScreenRoutine    |     a4: Obj
