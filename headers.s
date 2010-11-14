

	.equ	HEADERS,1

	.cpu	68040

	.macro	slotentry a b
		.long (( (\a) << 24 ) + ( (\b) & 0xffffff ))
	.endm

	/* this macro bypasses the A trap mechanism and calls the 
	trap directly from the dispatch table */

	.macro	tsjsr	trap
		.iflt \trap-0xa000
			.err
		.endif
		.ifgt \trap-0xabff
			.err
		.endif
		.iflt \trap-0xa800
			.short 0x4eb0,0x81e1
			.short 0x400 + ( \trap & 0xff ) * 4
		.else
			.short 0x4eb0,0x81e1
			.short 0xe00 + ( \trap - 0xa800) * 4
		.endif
	.endm

	.macro	CallVector base vector
		.short	0x2f30,0x81e2
		.short	\base
		.short	(\vector) << 2
	.endm

	.macro	CallVector2 base vector
		moveal	\base,%a1
		.short	0x2269, ((\vector) << 2)
	.endm

	.macro	jsrind addr		/* jsr ([addr]) */
		.short	0x4eb0,0x81e1
		.short	\addr
	.endm

	.macro	jmpind addr		/* jmp ([addr]) */
		.short	0x4ef0,0x81e1
		.short	\addr
	.endm

	.macro	_PBOpenSync
		.short	0xa000
	.endm

	.macro	_PBCloseSync
		.short	0xa001
	.endm

	.macro	_PBReadSync
		.short	0xa002
	.endm

	.macro	_PBStatusSync
		.short	0xa005
	.endm

	.macro	_PBGetFInfoSync
		.short	0xa00c
	.endm

	.macro	_PBGetEOFSync
		.short	0xa011
	.endm

	.macro	_SetVol
		.short	0xa015
	.endm

	.macro	_DisposePtr
		.short	0xa01f
	.endm

	.macro	_DisposeHandle
		.short	0xa023
	.endm

	.macro	_SetHandleSize
		.short	0xa024
	.endm

	.macro	_GetHandleSize
		.short	0xa025
	.endm

	.macro	_HLock
		.short	0xa029
	.endm

	.macro	_HUnlock
		.short	0xa02a
	.endm

	.macro	_BlockMove
		.short	0xa02e
	.endm

	.macro	_PostEvent
		.short	0xa02f
	.endm

	.macro	_OSEventAvail
		.short	0xa030
	.endm

	.macro	_GetOSEvent
		.short	0xa031
	.endm

	.macro	_VInstall
		.short	0xa033
	.endm

	.macro	_Delay
		.short	0xa03b
	.endm

	.macro	_Cmpstring
		.short	0xa03c
	.endm

	.macro	_HPurge
		.short	0xa049
	.endm

	.macro	_StripAddress
		.short	0xa055
	.endm

	.macro	_MemoryDispatch
		.short	0xa05c
	.endm

	.macro	_GetPhysical
		moveq	#5,%d0
		.short	0xa05c
	.endm

	.macro	_NMInstall
		.short	0xa05e
	.endm

	.macro	_NMRemove
		.short	0xa05f
	.endm

	.macro	_HGetState
		.short	0xa069
	.endm

	.macro	_HSetState
		.short	0xa06a
	.endm

	.macro	_SReadWord
		moveq	#1,%d0
		.short	0xa06e
	.endm

	.macro	_SReadLong
		moveq	#2,%d0
		.short	0xa06e
	.endm

	.macro	_SGetBlock
		moveq	#5,%d0
		.short	0xa06e
	.endm

	.macro	_SFindStruct
		moveq	#6,%d0
		.short	0xa06e
	.endm

	.macro	_SReadStruct
		moveq	#7,%d0
		.short	0xa06e
	.endm

	.macro	_SetSRsrcState
		moveq	#9,%d0
		.short	0xa06e
	.endm

	.macro	_SGetTypeSRsrc
		moveq	#12,%d0
		.short	0xa06e
	.endm

	.macro	_SReadPRAMRec
		moveq	#17,%d0
		.short	0xa06e
	.endm

	.macro	_SPutPRAMRec
		moveq	#18,%d0
		.short	0xa06e
	.endm

	.macro	_SNextTypeSRsrc
		moveq	#21,%d0
		.short	0xa06e
	.endm

	.macro	_SRsrcInfo
		moveq	#22,%d0
		.short	0xa06e
	.endm

	.macro	_SDisposePtr
		moveq	#23,%d0
		.short	0xa06e
	.endm

	.macro	_SReadDrvrName
		moveq	#25,%d0
		.short	0xa06e
	.endm

	.macro	_SFindDevBase
		moveq	#27,%d0
		.short	0xa06e
	.endm

	.macro	_SGetSRsrcPtr
		moveq	#29,%d0
		.short	0xa06e
	.endm

	.macro	_SExec
		moveq	#35,%d0
		.short	0xa06e
	.endm

	.macro	_SOffsetData
		moveq	#36,%d0
		.short	0xa06e
	.endm

	.macro	_SReadPBSize
		moveq	#38,%d0
		.short	0xa06e
	.endm

	.macro	_SCalcStep
		moveq	#40,%d0
		.short	0xa06e
	.endm

	.macro	_SUpdateSRT
		moveq	#43,%d0
		.short	0xa06e
	.endm

	.macro	_SFindSInfoRecPtr
		moveq	#47,%d0
		.short	0xa06e
	.endm

	.macro	_SFindSRsrcPtr
		moveq	#48,%d0
		.short	0xa06e
	.endm

	.macro	_SDeleteSRTRec
		moveq	#49,%d0
		.short	0xa06e
	.endm

	.macro	_SSecondaryInit
		moveq	#50,%d0
		.short	0xa06e
	.endm

	.macro	_SInitSlotPRAM
		moveq	#51,%d0
		.short	0xa06e
	.endm

	.macro	_GetOSDefault
		.short	0xa084
	.endm

	.macro	_IOPMsgRequest
		.short	0xa087
	.endm

	.macro	_NewHandle
		.short	0xa122
	.endm

	.macro	_Gestalt
		.short	0xa1ad
	.endm

	.macro	_PBControlImmed
		.short	0xa204
	.endm

	.macro	_SetOSTrapAddress
		.short	0xa247
	.endm

	.macro	__PBOpenWDSync
		moveq	#1,%d0
		.short	0xa260
	.endm

	.macro	_IdleUpdate
		.short	0xa285
	.endm

	.macro	_NewPtrClear
		.short	0xa31e
	.endm

	.macro	_NewHandleClear
		.short	0xa322
	.endm

	.macro	_NewGestalt
		.short	0xa3ad
	.endm

	.macro	_DisposeHandleSys
		.short	0xa423
	.endm

	.macro	_ReserveMemSys
		.short	0xa440
	.endm

	.macro	_NewPtrSys
		.short	0xa51e
	.endm

	.macro	_NewHandleSys
		.short	0xa522
	.endm

	.macro	_RecoverHandleSys
		.short	0xa528
	.endm

	.macro	_SetToolboxTrapAddress
		.short	0xa647
	.endm

	.macro	_NewPtrSysClear
		.short	0xa71e
	.endm

	.macro	_NewHandleSysClear
		.short	0xa722
	.endm

	.macro	_GetToolboxTrapAddress
		.short	0xa746
	.endm

	.macro	_SndPlay
		.short	0xa805
	.endm

	.macro	_Long2Fix
		.short	0xa83f
	.endm

	.macro	_Fix2Long
		.short	0xa840
	.endm

	.macro	_FixDiv
		.short	0xa84d
	.endm

	.macro	_InitCursor
		.short	0xa850
	.endm

	.macro	_ForeColor
		.short	0xa862
	.endm

	.macro	_BackColor
		.short	0xa863
	.endm

	.macro	_FixMul
		.short	0xa868
	.endm

	.macro	_FixRatio
		.short	0xa869
	.endm

	.macro	_GlobalToLocal
		.short	0xa871
	.endm

	.macro	_SetPort
		.short	0xa873
	.endm

	.macro	_GetPort
		.short	0xa874
	.endm

	.macro	_DrawChar
		.short	0xa883
	.endm

	.macro	_OSDispatch
		.short	0xa88f
	.endm

	.macro	_GetCurrentProcess
		movew	#55,%sp@-	/* 3f3c 0037 */
		.short	0xa88f
	.endm

	.macro	_MoveTo
		.short	0xa893
	.endm

	.macro	_ShutDwnPower
		movew	#1,%sp@-
		.short	0xa895
	.endm

	.macro	_GetPenState
		.short	0xa898
	.endm

	.macro	_SetPenState
		.short	0xa899
	.endm

	.macro	_PenSize
		.short	0xa89b
	.endm

	.macro	_PenPat
		.short	0xa89d
	.endm

	.macro	_PtInRect
		.short	0xa8ad
	.endm

	.macro	_FrameRoundRect
		.short	0xa8b0
	.endm

	.macro	_DisposeRgn
		.short	0xa8d9
	.endm

	.macro	_PrDrvrOpen
		movel	#0x80000000,%sp@-
		.short	0xa8fd
	.endm

	.macro	_ShowWindow
		.short	0xa915
	.endm

	.macro	_FrontWindow
		.short	0xa924
	.endm

	.macro	_GetItemMark
		.short	0xa943
	.endm

	.macro	_SetItemMark
		.short	0xa944
	.endm

	.macro	_GetMenuItemText
		.short	0xa946
	.endm

	.macro	_CountMenuItems
		.short	0xa950
	.endm

	.macro	_HiliteControl
		.short	0xa95d
	.endm

	.macro	_Dequeue
		.short	0xa96e
	.endm

	.macro	_Enqueue
		.short	0xa96f
	.endm

	.macro	_GetNextEvent
		.short	0xa970
	.endm

	.macro	_EventAvail
		.short	0xa971
	.endm

	.macro	_StillDown
		.short	0xa973
	.endm

	.macro	_Button
		.short	0xa974
	.endm

	.macro	_GetNewDialog
		.short	0xa97c
	.endm

	.macro	_NewDialog
		.short	0xa97d
	.endm

	.macro	_DisposeDialog
		.short	0xa983
	.endm

	.macro	_GetDialogItem
		.short	0xa98d
	.endm

	.macro	_SetDialogItem
		.short	0xa98e
	.endm

	.macro	_SetDialogItemText
		.short	0xa98f
	.endm

	.macro	_ModalDialog
		.short	0xa991
	.endm

	.macro	_DetachResource
		.short	0xa992
	.endm

	.macro	_CurResFile
		.short	0xa994
	.endm

	.macro	_UseResFile
		.short	0xa998
	.endm

	.macro	_CloseResFile
		.short	0xa99a
	.endm

	.macro	_SetResLoad
		.short	0xa99b
	.endm

	.macro	_GetResource
		.short	0xa9a0
	.endm

	.macro	_ReleaseResource
		.short	0xa9a3
	.endm

	.macro	_GetResInfo
		.short	0xa9a8
	.endm

	.macro	_SysBeep
		.short	0xa9c8
	.endm

	.macro	_SysError
		.short	0xa9c9
	.endm

	.macro	_InitPack
		.short	0xa9e5
	.endm

	.macro	_FP68K
		.short	0xa9eb
	.endm

	.macro	_PlotCIcon
		.short	0xaa1f
	.endm

	.macro	_GetCTSeed
		.short	0xaa28
	.endm

	.macro	_NewGDevice
		.short	0xaa2f
	.endm

	.macro	_SaveFore
		movew	#0x040d,%d0
		.short	0xaaa2
	.endm

	.macro	_SaveBack
		movew	#0x040e,%d0
		.short	0xaaa2
	.endm

	.macro	_RestoreFore
		movew	#0x040f,%d0
		.short	0xaaa2
	.endm

	.macro	_RestoreBack
		movew	#0x0410,%d0
		.short	0xaaa2
	.endm

	.macro	_DeviceLoop
		.short	0xabca
	.endm

	.macro	_DSPDispatch
		.short	0xabf5
	.endm

	.macro	_DSPNewAddress
		movew	#31,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPDisposeAddress
		movew	#32,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPFIFOClearInterrupt
		movew	#61,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPFIFOReset
		movew	#66,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPGetCPUDeviceGivenIndex
		movew	#121,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPPowerManager
		movew	#284,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPDeviceCall
		movew	#290,%d0	
		.short	0xabf5
	.endm

	.macro	_DSPRebootCPUDevice
		movew	#294,%d0	
		.short	0xabf5
	.endm

	.equ	__FCL_1_2A_, 0x312e3241		/* "1.2A" */
	.equ	__FCL_DSAT_, 0x44534154
	.equ	__FCL_mach_, 0x6d616368
	.equ	__FCL_vm___, 0x766d2020

	.equ	ExpandMem, 0x02b6
	.equ	JVBLTask, 0x0d28
	.equ	JSwapMMU, 0x0dbc
	.equ	LaunchFlag, 0x0902
	.equ	SInfoPtr, 0x0cbc
	.equ	DockingGlobals, 0x1ff8
