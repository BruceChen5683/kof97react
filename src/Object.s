.include "def.inc"
.globl      InitObjectPool
.globl		AllocateObjBlock
.globl		FreeObjBlock 
.globl		ZeroObjZbuf
.globl		CallObjRoutine
.globl		InsertIntoObjZBuf

InitObjectPool:          |1f24               
                                        
        lea     (OBJ_LIST_HEAD).l, a0
        move.l  #EmptyRoutine, Object(a0) 
        move.l  #0x100300, d0
        move.w  d0, Object.PNext(a0)
        move.w  #0xFFFF, Object.PPrev(a0)
        move.l  #EmptyRoutine, 0x200(a0) 

        move.w  #0xFFFF, Object.PNext+0x200(a0)
        move.l  #OBJ_LIST_HEAD, d0
        move.w  d0, Object.PPrev+0x200(a0)
        move.w  #0xFFFF, Object.Level+0x200(a0)
        lea     A5Seg.SpritePoolBaseTable(a5), a0
        move.l  #0x107F00, d0
        move.w  #0x3D, d1               | loop time 3e

_obj_dbfLoop:                               | CODE XREF: InitObjectPool+4Ej
        move.w  d0, (a0)+
        subi.w  #0x200, d0
        dbf     d1, _obj_dbfLoop
        move.w  #0x7A, A5Seg.ObjPoolStackIndex(a5)
        |andi.b  #0x80, A5Seg.debugDipFlagCopy(a5) | bit0: 1, debug obj exist
                                        | bit1: 1, show hit box
                                        | bit4: 1, need clear DbgPlayerStatusFlags display
        |clr.b   A5Seg.noUse(a5)
        rts
| End of function InitObjectPool

EmptyRoutine:
		rts

AllocateObjBlock:                       |1f82
        move.w  A5Seg.ObjPoolStackIndex(a5), d7
        bmi.w   _AllocateObjBlock_overflow               | if (curIndex > 0x7F)
                                        |     goto ...overflow
        subq.w  #2, A5Seg.ObjPoolStackIndex(a5) | curIndex -= 2
                                        | ע���ʱ d7 û�б�
        lea     A5Seg.SpritePoolBaseTable(a5), a1 | 10a700
        movea.w (a1,d7.w), a1
        adda.l  #0x100000, a1
        move.l  a0, Object(a1)
        move.w  d0, Object.Level(a1)    | ��ֵԽС, �������Խ�ȱ�ִ�� (���ȼ�Խ��).
                                        | Ҳ�����ж��Ƿ񶳽ử��
        lea     -0x7F00(a5), a0         | 100100 ����ͷ
        move.l  a0, d7

_AllocateObjBlock_findPosition:                          | CODE XREF: AllocateObjBlock+30j
        move.w  Object.PNext(a0), d7
        movea.l d7, a0                  | a0 = 100000 + *(a0+4)
        cmp.w   Object.Level(a0), d0    | ��ֵԽС, �������Խ�ȱ�ִ�� (���ȼ�Խ��).
                                        | Ҳ�����ж��Ƿ񶳽ử��
        bcc.s   _AllocateObjBlock_findPosition           | if(8(a0)<=d0) goto
        move.w  a0, Object.PNext(a1)    | �ҵ���һ�� level �㹻��Ŀ�
                                        | ��ԭ���Ŀ鰴��level˳��������
        move.w  Object.PPrev(a0), Object.PPrev(a1)
        move.w  Object.PPrev(a0), d7
        move.w  a1, Object.PPrev(a0)
        movea.l d7, a0
        move.w  a1, Object.PNext(a0)
        lea     Object.TagString(a1), a0
        move.w  #0x1E, d0
        moveq   #0, d7
_AllocateObjBlock_zeroLoop:                              
        move.l  d7, (a0)+
        move.l  d7, (a0)+
        move.l  d7, (a0)+
        move.l  d7, (a0)+
        dbf     d0, _AllocateObjBlock_zeroLoop           | ���� 0x1f0
        rts
| ---------------------------------------------------------------------------

_AllocateObjBlock_overflow:                              
        lea     (TASK_OVER).l, a0       | task over
        jsr     SetFixlayText           | params:
                                        |     a0: ptr to fixlay output struct

_AllocateObjBlock_deathLoop:                           
        bra.w   _AllocateObjBlock_deathLoop
| End of function AllocateObjBlock


| params:
|     a4: Obj

FreeObjBlock:                          
                                       
        lea     A5Seg.SpritePoolBaseTable(a5), a0
        addq.w  #2, A5Seg.ObjPoolStackIndex(a5)
        moveq   #0, d0
        move.w  A5Seg.ObjPoolStackIndex(a5), d0
        move.w  a4, (a0,d0.w)           | �ͷŵ�ǰ��200_Block
        move.l  #0x100000, d0
        move.w  Object.PPrev(a4), d0    | ����Block�������жϿ�
        movea.l d0, a0
        move.w  Object.PNext(a4), Object.PNext(a0)
        move.w  Object.PNext(a4), d0
        movea.l d0, a0
        move.w  Object.PPrev(a4), Object.PPrev(a0)
        move.w  #0xFFFF, Object.PPrev(a4) | ǰһ���ڵ�Ϊ��, ��ʾ��������������
        rts
| End of function FreeObjBlock


ZeroObjZbuf:                            | CODE XREF: GameLogicMainLoopEntry+F2p
        lea     A5Seg.ObjZBuf(a5), a0   | size: 0x600
        moveq   #0, d0
        moveq   #0x2F, d1               | $30 * $20

_ZeroObjZbuf_dbfLoop:                               | CODE XREF: ZeroObjZbuf+18j
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        move.l  d0, (a0)+
        dbf     d1, _ZeroObjZbuf_dbfLoop
        move.l  #0x108700, A5Seg.pGhostBuf(a5) | Ӱ����Ӱ�ӵ�
                                        | ָ����õ���ʱ���������ڹ���objͷ, ÿ��0x40, �ܴ�С0x2000
        move.l  #0xFFFE, A5Seg.FirstObjIndexInZBuf(a5) | ָʾ��һ������0��Obj��Zbuf�е�ƫ��, -2 ��ʾZbufΪ��
        clr.w   A5Seg.NumInObjZBuf(a5)
        rts
| End of function ZeroObjZbuf


CallObjRoutine:                         
        lea     A5Seg.MainNextRoutine(a5), a4 | a4 = 108500
        movea.l (a4), a0
        jsr     (a0)                    
        |bsr.w   FlashOneMore
        move.l  #OBJ_LIST_HEAD, d7
|        btst    #2, A5Seg.RoleObjMaskFlags(a5) | bit0: 1, lock p1
|                                        | bit1: 1, lock p2
|                                        | bit2: 1, freeze mode, ��ɱ����
|        beq.s   _CallObjRoutine_normalLoop
|
|_CallObjRoutine_freezeLoop:                            | CODE XREF: CallObjRoutine+32j
|        movea.l d7, a4                  | set a4 = next obj
|        move.w  Object.Level(a4), d7    | �����ж��Ƿ񶳽ử��
|        cmp.w   A5Seg.unfreezeLevelNum(a5), d7 | �������level���
|        bne.w   _CallObjRoutine_unfreezeObj
|        movea.l Object(a4), a0
|        jsr     (a0)                    | �����ʱ����Ȼ��ִ��obj��������
|
|_CallObjRoutine_goNextLoop:                            | CODE XREF: CallObjRoutine+3Ej
|                                        | CallObjRoutine+52j
|        move.l  a4, d7
|        move.w  Object.PNext(a4), d7
|        bpl.s   _CallObjRoutine_freezeLoop
|        bra.w   loc_9DF8
|| ---------------------------------------------------------------------------
|
|_CallObjRoutine_unfreezeObj:                           | CODE XREF: CallObjRoutine+24j
|        btst    #5, Object.ExGraphFlags(a4) | bit0: 1, need to update SCB1
|                                        | bit1: 1, do not use extra graph
|                                        | bit2: 1, ʹ�û��Ʋ㱳��
|                                        | bit3: ?
|                                        | bit4: 1, use own Shrinking, do not set InScreenX,Y ��Ӱ��
|                                        | bit5: 1, visible during freeze
|                                        | bit7: 1, use sub SCB3 buf
|        beq.s   _CallObjRoutine_goNextLoop
|        move.b  #1, Object.SpanTimeEx(a4)
|        jsr     (GetNextMov).l          | ret:
|                                        |     d0: 0, done;
|                                        |        -1, new graph info loaded
|        jsr     (InsertIntoObjZBuf).l   | params:
|                                        |     a4: obj
|                                        | ret:
|                                        |     d6: 0, done; -1: fail
|        bra.s   _CallObjRoutine_goNextLoop
|| ---------------------------------------------------------------------------

_CallObjRoutine_normalLoop:            
        movea.l d7, a4
        movea.l Object(a4), a0
        jsr     (a0)
        move.l  a4, d7
        move.w  Object.PNext(a4), d7
        bpl.s   _CallObjRoutine_normalLoop             | ѭ��ִ��ÿ��obj�Ĵ�������

		lea     (0x10B0B2).l, a4      | BackGroundObjLayer0
        move.b  #8, A5Seg.PendingNumOfBackgroundLayerToUpdate(a5)

_CallObjRoutine_layerLoop:                             | CODE XREF: CallObjRoutine+A2j
        tst.b   ScreenObj.Flag(a4)      | bit1: 1, do not show this layer
                                        | bit1: 1, do not scroll X
                                        | bit2: 1, do not scrool Y
                                        | bit5: 1, do not ... ?
                                        | bit6: 1, sticky
                                        | bit7: 0, do not use layer proc
        bpl.s   _CallObjRoutine_nextLayer                | ��Ϸ��ʵ��ֻ����3�㱳��
        movea.l ScreenObj(a4), a0       | ������
        jsr     (a0)

_CallObjRoutine_nextLayer:                               | CODE XREF: CallObjRoutine+94j
        lea     0x100(a4), a4
        subq.b  #1, A5Seg.PendingNumOfBackgroundLayerToUpdate(a5)
        bne.s   _CallObjRoutine_layerLoop
        rts
| End of function CallObjRoutine


| params:
|     a4: obj
| ret:
|     d6: 0, done; -1: fail

InsertIntoObjZBuf:                      | CODE XREF: CallObjRoutine+4Cp
                                        | DbgOBJRoutineInit+7Aj ...
        movea.l a4, a3
        move.w  Object.Z(a4), d5        | bit 0~2: ͬһͼ���е�ϸ�Ƚ�
                                        | bit4����: �� Zbuf �е�����
        bra.s   _InsertIntoObjZBuf_inserIntoZBuf
| ---------------------------------------------------------------------------

InsertIntoObjZBufGhost:                 | CODE XREF: ROM:00014E34p
                                        | ROM:00014E5Ep ...
        move.l  Object.XinScreen(a4), d0
        move.l  Object.OriX(a4), d1     | ��ͼԭ��(ʮ��)�ĺ�����, �����߼�λ��, ���ص�λ
        move.l  Object.OriY(a4), d2     | ��ͼԭ��(ʮ��)��������, �����߼��߶�, ���ص�λ
        move.l  Object.YFromGround(a4), d3 | ����ʱ�������߶�, ���ص�λ
        move.l  Object.RoleShrinkRate(a4), d4 | �����������
        move.w  Object.Z(a4), d5        | bit 0~2: ͬһͼ���е�ϸ�Ƚ�
                                        | bit4����: �� Zbuf �е�����
        move.w  Object.Palette(a4), d6  | obj �Դ� palette, SCB1 �ڶ� word ���ֽ�ʹ��
        move.l  Object.pGraphDataSubmenuBase(a4), d7 | �� Obj �� SCB1 ���ݵ���ʼ��ַ
                                        | (��ɫ��, ��������, ���, �߶�, ����...)
        movea.l Object.pGraphInfoEntry(a4), a1 | ��ָ��4�ֽ�Xoffset,Yoffset
                                        | Ȼ����һ��word�� SCB1 data offset from obj data base
        movea.l A5Seg.pGhostBuf(a5), a3 | Ӱ����Ӱ�ӵ�
                                        | ָ����õ���ʱ���������ڹ���objͷ, ÿ��0x40, �ܴ�С0x200
        cmpa.l  #ObjPoolBaseTable, a3
        ble.s   loc_5CE6
        moveq   #0xFFFFFFFF, d6         | -1: fail
        rts
| ---------------------------------------------------------------------------

loc_5CE6:                               | CODE XREF: InsertIntoObjZBuf+36j
        st      (a3)                    | ���ֽ�д�� FF
        addi.w  #0x40, A5Seg.pGhostBuf+2(a5) | set next bufBlock
        move.l  d0, Object.XinScreen(a3)
        move.l  d1, Object.OriX(a3)     | ��ͼԭ��(ʮ��)�ĺ�����, �����߼�λ��, ���ص�λ
        move.l  d2, Object.OriY(a3)     | ��ͼԭ��(ʮ��)��������, �����߼��߶�, ���ص�λ
        move.l  d3, Object.YFromGround(a3) | ����ʱ�������߶�, ���ص�λ
        move.l  d4, Object.RoleShrinkRate(a3) | �����������
        move.w  d5, Object.Z(a3)        | bit 0~2: ͬһͼ���е�ϸ�Ƚ�
                                        | bit4����: �� Zbuf �е�����
        move.w  d6, Object.Palette(a3)  | obj �Դ� palette, SCB1 �ڶ� word ���ֽ�ʹ��
        move.l  d7, Object.pGraphDataSubmenuBase(a3) | �� Obj �� SCB1 ���ݵ���ʼ��ַ
                                        | (��ɫ��, ��������, ���, �߶�, ����...)
        move.l  a1, Object.pGraphInfoEntry(a3) | ��ָ��4�ֽ�Xoffset,Yoffset
                                        | Ȼ����һ��word�� SCB1 data offset from obj data base

_InsertIntoObjZBuf_inserIntoZBuf:                         | CODE XREF: InsertIntoObjZBuf+6j
        move.w  a3, d1                  | d5: Z
                                        | a3: obj (real or delayShadow)
        lea     A5Seg.ObjZBuf(a5), a0   | size: 0x600
        move.w  d5, d0
        andi.w  #0xFF8, d0              | bit 0~2 ����
        lsr.w   #2, d0                  | ����3λ�õ�����, ��2�õ�ƫ��

_InsertIntoObjZBuf_loop:                                  
        moveq   #0, d2
        move.w  (a0,d0.w), d2
        beq.s   _InsertIntoObjZBuf_emptyEntry             | �ҵ���һ�����е�Zbufλ��
        movea.l #0x100000, a1
        adda.l  d2, a1                  | a1: �Ѿ�ռ�������Zbufλ�õ�Obj
        move.w  Object.Z(a1), d3        | bit 0~2: ͬһͼ���е�ϸ�Ƚ�
                                        | bit4����: �� Zbuf �е�����
        cmp.w   d3, d5
        bhi.s   loc_5D4A
        cmp.w   A5Seg.FirstObjIndexInZBuf+2(a5), d0 | ָʾ��һ������0��Obj��Zbuf�е�ƫ��, -2 ��ʾZbufΪ��
        bhi.s   loc_5D42
        move.w  d0, A5Seg.FirstObjIndexInZBuf+2(a5) | ָʾ��һ������0��Obj��Zbuf�е�ƫ��, -2 ��ʾZbufΪ��

loc_5D42:                               | CODE XREF: InsertIntoObjZBuf+92j
        move.w  d1, (a0,d0.w)           | ��װ���obj, ��ԭ����obj�ó���, ���Ѱ�ҿ�λ��
        move.w  d2, d1
        move.w  d3, d4

loc_5D4A:                               | CODE XREF: InsertIntoObjZBuf+8Cj
        addq.w  #2, d0
        bra.s   _InsertIntoObjZBuf_loop
| ---------------------------------------------------------------------------

_InsertIntoObjZBuf_emptyEntry:                            
        cmp.w   A5Seg.FirstObjIndexInZBuf+2(a5), d0 | �ҵ���һ�����е�Zbufλ��
        bhi.s   loc_5D58
        move.w  d0, A5Seg.FirstObjIndexInZBuf+2(a5) | ָʾ��һ������0��Obj��Zbuf�е�ƫ��, -2 ��ʾZbufΪ��

loc_5D58:                               | CODE XREF: InsertIntoObjZBuf+A8j
        move.w  d1, (a0,d0.w)
        addq.w  #1, A5Seg.NumInObjZBuf(a5)
        clr.w   d6
        rts
| End of function InsertIntoObjZBuf


TASK_OVER:
		.word 0x7191                  
        .byte  0xF
        .ascii "TASK OVER !!"
        .byte 0xFF

