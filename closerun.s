_LVOOldOpenLibrary	equ	-$198
_LVOCloseLibrary	equ	-$19E
_LVOForbid	equ	-$84
_LVOCreateProc	equ	-$8A
_LVOLoadSeg	equ	-150
_LVOUnLoadSeg	equ	-156
_LVODelay	equ	-$C6
_LVOCloseWorkBench	equ	-$4E
_LVOClose	equ	-$24
_LVOExit	equ	-$90
cli_StandardInput	equ	$1C
cli_CurrentInput	equ	$20
cli_Background	equ	$2C
fh_Pos	equ	$10
fh_End	equ	$14
pr_CLI	equ	$AC
ThisTask	equ	$114
****************************************************************************

	SECTION	Close_Run,CODE

start	moveq	#'"',d1
	moveq	#0,d2
	lea	$300.w,a1
	move.l	a1,d5
	lea	$1F(a1),a2
.k1 subq.w	#1,d0
	move.b	d2,(a2)+
.k2	subq.w	#1,d0
	bmi.b	.je
	cmp.b	(a0)+,d1
	bne.b	.k2
	move.l	a2,(a1)+
.ic	move.b	(a0)+,d3
	cmp.b	d3,d1
	beq.b	.k1
	move.b	d3,(a2)+
	subq.w	#1,d0
	bpl.b	.ic
	subq.l	#4,a1
.je	move.l	d2,(a1)+

	lea	(a1),a2
	movea.l	(4).w,a6
	move.l	156(a6),a0	;gfxbase
	moveq	#-2,d0
	move.l	#$01800000,(a2)+
	move.l	#$01000200,(a2)+
	move.l	d0,(a2)
	move.l	a1,50(a0)	;LOFlist

	movea.l	ThisTask(a6),a2
	lea	(a6),a4
	lea	(int.lib,pc),a1
	jsr	(_LVOOldOpenLibrary,a6)
	movea.l	d0,a5
	lea	(dos.lib,pc),a1
	jsr	(_LVOOldOpenLibrary,a6)
	movea.l	d0,a6
	moveq	#$10,d4
	lsl.w	#8,d4
	lea	start-4(pc),a0
	move.l	(a0),d3
;	moveq	#0,d2
	move.l	d2,(a0)
	moveq	#(heap-close_run-8+4+3)>>2,d1
	add.l	d3,d1
	lsl.l	#2,d1
	move.l	d1,a3
	movem.l	d3/d5/a4-a6,-(a3)
	jsr	(_LVOCreateProc,a6)
	move.l	(pr_CLI,a2),a2
	adda.l	a2,a2
	lea	(cli_StandardInput,a2,a2.l),a2
	move.l	(a2)+,d3	;d3=sfh=mycli->cli_StandardInput;
	move.l	(a2),d1		;d1=cfh=mycli->cli_CurrentInput;
	movea.l	d3,a0
	adda.l	a0,a0		;a0=mfh=BADDR(sfh);
	lea	(fh_End,a0,a0.l),a0
	move.l	(a0),-4(a0)	;mfh->fh_Pos=mfh->fh_End;
	move.l	d2,(a0)		;mfh->fh_End=0;
	cmp.l	d3,d1		;if(sfh!=cfh)
	beq.b	.dp
	move.l	d3,(a2)		;mycli->cli_CurrentInput=sfh;
	jsr	(_LVOClose,a6)	;Close(cfh);
.dp	moveq	#-1,d0		;mycli->cli_Background=-1;
	move.l	d0,(cli_Background-cli_CurrentInput,a2)
	moveq	#0,d1		;Exit(0);
	jmp	(_LVOExit,a6)
;	rts

dos.lib		dc.b	'dos.library',0
int.lib		dc.b	'intuition.library',0


	SECTION	Close_Run_detach,CODE

close_run
	movem.l	(heap-8-5*4,pc),d2/a2-a5

.ll	lea	(a5),a6
	moveq	#5,d1
	jsr	(_LVODelay,a6)
	lea	(a4),a6
	jsr	(_LVOCloseWorkBench,a6)
	tst.l	d0
	beq.b	.ll
	lea	(a5),a6

.lo	move.l	(a2)+,d1
	beq.b	.dd
	jsr	(_LVOLoadSeg,a6)
	move.l	d0,d1
	beq.b	.lo
	movem.l	d1-d2/a2-a6,-(sp)
	add.l	d0,d0
	movea.l	d0,a0
	jsr	(4,a0,d0.l)	;run
	movem.l	(sp)+,d1-d2/a2-a6
	jsr	(_LVOUnLoadSeg,a6)
	bra.b	.lo

.dd	lea	(a3),a6
	jsr	(_LVOForbid,a6)
	move.l	d2,d1
	lea	(a5),a6
	jsr	(_LVOUnLoadSeg,a6)
	lea	(a3),a6
	lea	(a4),a1
	jsr	(_LVOCloseLibrary,a6)
	lea	(a5),a1
	jsr	(_LVOCloseLibrary,a6)
	moveq	#0,d0
	rts

;	cnop	0,4
	;		0, 12345678901234567890123456789012345678  9
	dc.b	0,'$VER: Close&Run 1.1 (2.5.2019) by ross',0
;	cnop	0,4
heap

	end
	