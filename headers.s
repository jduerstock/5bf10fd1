
	.equ	HEADERS,1

	.cpu	68040

	.macro	slotentry a b
		.long (( (\a) << 24 ) + ( (\b) & 0xffffff ))
	.endm

	.macro	slotaddr a b
		.long (( (\a) << 24 ) + ( (\b-.) & 0xffffff ))
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

	.macro	CallSVector base vector
		.short	0x487a,0x000c	/* pea %pc@(.+0x0c) */
		JmpVector \base \vector
	.endm

	.macro	JmpVector base vector
		.short	0x2f30,0x81e2
		.short	\base
		.short	(\vector) << 2
		rts
	.endm

	.macro	JmpVectorA1 base vector
		moveal	\base,%a1
		moveal	%a1@(\vector << 2),%a1
		jmp	%a1@
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

	.macro	bsr6 addr
		lea	1f,%fp
		bral	\addr
		1:
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

	.macro	_PBControlSync
		.short	0xa004
	.endm

	.macro	_PBStatusSync
		.short	0xa005
	.endm

	.macro	_PBGetFInfoSync
		.short	0xa00c
	.endm

	.macro	_PBMountVol
		.short	0xa00f
	.endm

	.macro	_PBGetEOFSync
		.short	0xa011
	.endm

	.macro	_SetVol
		.short	0xa015
	.endm

	.macro	_PBEject
		.short	0xa017
	.endm

	.macro	_SetZone
		.short	0xa01b
	.endm

	.macro	_DisposePtr p1
		.ifnb \p1
			moveal \p1,%a0
		.endif
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

	.macro	_EmptyHandle
		.short	0xa02b
	.endm

	.macro	_InitApplZone
		.short	0xa02c
	.endm

	.macro	_SetApplLimit
		.short	0xa02d
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

	.macro	_VRemove
		.short	0xa034
	.endm

	.macro	_Delay
		.short	0xa03b
	.endm

	.macro	_Cmpstring
		.short	0xa03c
	.endm

	.macro	_SetTrapAddress
		.short	0xa047
	.endm

	.macro	_HPurge
		.short	0xa049
	.endm

	.macro	_HNoPurge
		.short	0xa04a
	.endm

	.macro	_CompactMem
		.short	0xa04c
	.endm

	.macro	_ReadXPRAM
		.short	0xa051
	.endm

	.macro	_WriteXPRAM
		.short	0xa052
	.endm

	.macro	_StripAddress p1
		.ifnb \p1
			movel \p1,%d0
		.endif
		.short	0xa055
	.endm

	.macro	_RemoveTimeTask
		.short	0xa059
	.endm

	.equ	MemoryDispatch, 0xa05c

	.macro	_MemoryDispatch p1
		.ifnb \p1
			moveq #\p1,%d0
		.endif
		.short	MemoryDispatch
	.endm

	.macro	_VMFinishInstall
		moveq	#-1,%d0
		.short	0xa05c
	.endm

	.macro	_UnlockMemory
		moveq	#3,%d0
		.short	0xa05c
	.endm

	.macro	_LockMemoryContiguous
		moveq	#4,%d0
		.short	0xa05c
	.endm

	.macro	_GetPhysical
		moveq	#5,%d0
		.short	0xa05c
	.endm

	.equ	SwapMMUMode, 0xa05d
	.macro	_SwapMMUMode p1
		.ifnb \p1
			moveq #\p1,%d0
		.endif
		.short	SwapMMUMode
	.endm

	.macro	_NMInstall
		.short	0xa05e
	.endm

	.macro	_NMRemove
		.short	0xa05f
	.endm

	.macro	_FSDispatch
		.short	0xa060
	.endm

	.macro	_MoveHHi
		.short	0xa064
	.endm

	.macro	_HGetState p1
		.ifnb \p1
			moveal \p1,%a0
		.endif
		.short	0xa069
	.endm

	.macro	_HSetState
		.short	0xa06a
	.endm

	.macro	_InitFS
		.short	0xa06c
	.endm

	.macro	_SlotManager p1
		.ifnb \p1
			moveq #\p1,%d0
		.endif
		.short	0xa06e
	.endm

	.macro	_SReadWord
		_SlotManager 1
	.endm

	.macro	_SReadLong
		moveq	#2,%d0
		_SlotManager
	.endm

	.macro	_SGetBlock
		moveq	#5,%d0
		_SlotManager
	.endm

	.macro	_SFindStruct
		moveq	#6,%d0
		_SlotManager
	.endm

	.macro	_SReadStruct
		_SlotManager 7
	.endm

	.macro	_SVersion
		_SlotManager 8
	.endm

	.macro	_SetSRsrcState
		_SlotManager 9
	.endm

	.macro	_InsertSRTRec
		_SlotManager 10
	.endm

	.macro	_SGetSRsrc
		_SlotManager 11
	.endm

	.macro	_SGetTypeSRsrc
		_SlotManager 12
	.endm

	.macro	_SReadPRAMRec
		_SlotManager 17
	.endm

	.macro	_SPutPRAMRec
		_SlotManager 18
	.endm

	.macro	_SReadFHeader
		_SlotManager 19
	.endm

	.macro	_SNextSRsrc
		_SlotManager 20
	.endm

	.macro	_SNextTypeSRsrc
		_SlotManager 21
	.endm

	.macro	_SRsrcInfo
		_SlotManager 22
	.endm

	.macro	_SDisposePtr
		moveq	#23,%d0
		_SlotManager
	.endm

	.macro	_SReadDrvrName
		moveq	#25,%d0
		_SlotManager
	.endm

	.macro	_SFindDevBase
		moveq	#27,%d0
		_SlotManager
	.endm

	.macro	_SGetSRsrcPtr
		moveq	#29,%d0
		_SlotManager
	.endm

	.macro	_SExec
		moveq	#35,%d0
		_SlotManager
	.endm

	.macro	_SOffsetData
		moveq	#36,%d0
		_SlotManager
	.endm

	.macro	_SReadPBSize
		moveq	#38,%d0
		_SlotManager
	.endm

	.macro	_SCalcStep
		moveq	#40,%d0
		_SlotManager
	.endm

	.macro	_SUpdateSRT
		_SlotManager 43
	.endm

	.macro	_SCalcSPointer
		_SlotManager 44
	.endm

	.macro	_SGetDriver
		_SlotManager 45
	.endm

	.macro	_SFindSInfoRecPtr
		moveq	#47,%d0
		_SlotManager
	.endm

	.macro	_SFindSRsrcPtr
		moveq	#48,%d0
		_SlotManager
	.endm

	.macro	_SDeleteSRTRec
		_SlotManager 49
	.endm

	.macro	_SSecondaryInit
		moveq	#50,%d0
		_SlotManager
	.endm

	.macro	_SInitSlotPRAM
		_SlotManager 51
	.endm

	.macro	_SIntInstall
		.short	0xa075
	.endm

	.macro	_SIntRemove
		.short	0xa076
	.endm

	.macro	_GetVideoDefault
		.short	0xa080
	.endm

	.macro	_DTInstall
		.short	0xa082
	.endm

	.macro	_GetOSDefault
		.short	0xa084
	.endm

	.macro	_IOPMsgRequest
		.short	0xa087
	.endm

	.macro	_BTreeDispatch
		.short	0xa08e
	.endm

	.macro	_BTreeInit
		moveq	#1,%d0
		.short	0xa08e
	.endm

	.macro	_BTreeCleanUp
		moveq	#11,%d0
		.short	0xa08e
	.endm

	.macro	_BTreeUpdate
		moveq	#15,%d0
		.short	0xa08e
	.endm

	.macro	_DeferUserFn
		.short	0xa08f
	.endm

	.macro	_SysEnvirons
		.short	0xa090
	.endm

	.macro	_Translate24To32
		.short	0xa091
	.endm

	.macro	_EgretDispatch
		.short	0xa092
	.endm

	.macro	_ServerDispatch
		.short	0xa094
	.endm

	.macro	_GetZone
		.short	0xa11a
	.endm

	.macro	_NewPtr
		.short	0xa11e
	.endm

	.macro	_NewHandle s1
		.ifnb \s1
			moveq #\s1,%d0
		.endif
		.short	0xa122
	.endm

	.macro	_RecoverHandle
		.short	0xa128
	.endm

	.macro	_HWPriv
		.short	0xa198
	.endm

	.macro	_Gestalt s1
		.ifnb \s1
			movel #\s1,%d0
		.endif
		.short	0xa1ad
	.endm

	.macro	_PBControlImmed
		.short	0xa204
	.endm

	.macro	_PBHDeleteSync
		.short	0xa209
	.endm

	.macro	_SetOSTrapAddress
		.short	0xa247
	.endm

	.macro	_HFSDispatch
		.short	0xa260
	.endm

	.macro	__PBOpenWDSync
		moveq	#1,%d0
		.short	0xa260
	.endm

	.macro	__PBCloseWDSync
		moveq	#2,%d0
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

	.macro	_GetOSTrapAddress
		.short	0xa346
	.endm

	.macro	_NewGestalt
		.short	0xa3ad
	.endm

	.macro	_PBCloseAsync
		.short	0xa401
	.endm

	.macro	_PBReadAsync
		.short	0xa402
	.endm

	.macro	_PBControlAsync
		.short	0xa404
	.endm

	.macro	_DisposeHandleSys
		.short	0xa423
	.endm

	.macro	_DriverInstallReserveMem
		.short	0xa43d
	.endm

	.macro	_ReserveMemSys
		.short	0xa440
	.endm

	.macro	_BTreeDispatchAsync
		.short	0xa48e
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

	.macro	_NewEmptyHandleSys
		.short	0xa566
	.endm

	.macro	_PBHDeleteAsync
		.short	0xa609
	.endm

	.macro	_SetToolboxTrapAddress
		.short	0xa647
	.endm

	.macro	_SerialPower
		.short	0xa685
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

	.macro	_SoundDispatch
		.short	0xa800
	.endm

	.macro	_SndDisposeChannel
		.short	0xa801
	.endm

	.macro	_SndAddModifier
		.short	0xa802
	.endm

	.macro	_SndDoCommand
		.short	0xa803
	.endm

	.macro	_SndDoImmediate
		.short	0xa804
	.endm

	.macro	_SndPlay
		.short	0xa805
	.endm

	.macro	_SndControl
		.short	0xa806
	.endm

	.macro	_SndNewChannel
		.short	0xa807
	.endm

	.macro	_TEPinScroll
		.short	0xa812
	.endm

	.macro	_SCSIDispatch
		.short	0xa815
	.endm

	.macro	_Pack8
		.short	0xa816
	.endm

	.macro	_AEGetParamPtr
		movew	#0xe11,%d0
		_Pack8
	.endm

	.macro	_ResourceDispatch p1
		.ifnb \p1
			moveq #\p1,%d0
		.endif
		.short	0xa822
	.endm

	.macro	_AliasDispatch
		.short	0xa823
	.endm

	.macro	_ComponentDispatch
		.short	0xa82a
	.endm

	.macro	_CallComponentFunction
		moveq	#-1,%d0
		.short	0xa82a
	.endm

	.macro	_HMBalloonBulk
		movew	#252,%d0
		.short	0xa830
	.endm

	.macro	_Long2Fix
		.short	0xa83f
	.endm

	.macro	_Fix2Long
		.short	0xa840
	.endm

	.macro	_UserDelay
		.short	0xa84c
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

	.macro	_FixRound
		.short	0xa86c
	.endm

	.macro	_InitGraf
		.short	0xa86e
	.endm

	.macro	_OpenPort
		.short	0xa86f
	.endm

	.macro	_LocalToGlobal
		.short	0xa870
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

	.macro	_SetClip
		.short	0xa879
	.endm

	.macro	_GetClip
		.short	0xa87a
	.endm

	.macro	_AddPt
		.short	0xa87e
	.endm

	.macro	_SubPt
		.short	0xa87f
	.endm

	.macro	_DrawChar
		.short	0xa883
	.endm

	.macro	_TextFont
		.short	0xa887
	.endm

	.macro	_OSDispatch
		.short	0xa88f
	.endm

	.macro	_GetCurrentProcess
		movew	#55,%sp@-
		.short	0xa88f
	.endm

	.macro	_MoveTo
		.short	0xa893
	.endm

	.macro	_ShutDown
		.short	0xa895
	.endm

	.macro	_ShutDwnPower
		movew	#1,%sp@-
		_ShutDown
	.endm

	.macro	_ShutDwnStart
		movew	#2,%sp@-
		_ShutDown
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

	.macro	_PenNormal
		.short	0xa89e
	.endm

	.macro	_FrameRect
		.short	0xa8a1
	.endm

	.macro	_EraseRect
		.short	0xa8a3
	.endm

	.macro	_OffsetRect
		.short	0xa8a8
	.endm

	.macro	_InsetRect
		.short	0xa8a9
	.endm

	.macro	_UnionRect
		.short	0xa8ab
	.endm

	.macro	_PtInRect
		.short	0xa8ad
	.endm

	.macro	_FrameRoundRect
		.short	0xa8b0
	.endm

	.macro	_ScriptUtil p1
		.ifnb \p1
			movel #\p1,%sp@-
		.endif
		.short	0xa8b5
	.endm

	.macro	_KeyScript
		_ScriptUtil 0x80020004
	.endm

	.macro	_FontScript
		_ScriptUtil 0x82000000
	.endm

	.macro	_CharByte
		_ScriptUtil 0x82060010
	.endm

	.macro	_CharType
		_ScriptUtil 0x82060012
	.endm

	.macro	_Char2Pixel
		_ScriptUtil 0x820c0016
	.endm

	.macro	_NewRgn
		.short	0xa8d8
	.endm

	.macro	_DisposeRgn
		.short	0xa8d9
	.endm

	.macro	_CopyRgn
		.short	0xa8dc
	.endm

	.macro	_OffsetRgn
		.short	0xa8e0
	.endm

	.macro	_SectRgn
		.short	0xa8e4
	.endm

	.macro	_UnionRgn
		.short	0xa8e5
	.endm

	.macro	_DiffRgn
		.short	0xa8e6
	.endm

	.macro	_ScrollRect
		.short	0xa8ef
	.endm

	.macro	_PrDrvrOpen
		movel	#0x80000000,%sp@-
		.short	0xa8fd
	.endm

	.macro	_GetFName
		.short	0xa8ff
	.endm

	.macro	_PaintOne
		.short	0xa90c
	.endm

	.macro	_NewWindow
		.short	0xa913
	.endm

	.macro	_ShowWindow
		.short	0xa915
	.endm

	.macro	_FrontWindow
		.short	0xa924
	.endm

	.macro	_NewMenu
		.short	0xa931
	.endm

	.macro	_InsertMenu
		.short	0xa935
	.endm

	.macro	_HiliteMenu
		.short	0xa938
	.endm

	.macro	_GetMenuBar
		.short	0xa93b
	.endm

	.macro	_SetMenuBar
		.short	0xa93c
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

	.macro	_GetMouse
		.short	0xa972
	.endm

	.macro	_StillDown
		.short	0xa973
	.endm

	.macro	_Button
		.short	0xa974
	.endm

	.macro	_TickCount
		.short	0xa975
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

	.macro	_GetDialogItemText
		.short	0xa990
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

	.macro	_CountResources
		.short	0xa99c
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

	.macro	_GetString
		.short	0xa9ba
	.endm

	.macro	_SysBeep
		.short	0xa9c8
	.endm

	.macro	_SysError p1
		.ifnb \p1
			moveq #\p1,%d0
		.endif
		.short	0xa9c9
	.endm

	.macro	_Munger
		.short	0xa9e0
	.endm

	.macro	_InitPack
		.short	0xa9e5
	.endm

	.macro	_Pack0
		.short	0xa9e7
	.endm

	.macro	_FP68K
		.short	0xa9eb
	.endm

	.macro	_Debugger
		.short	0xa9ff
	.endm

	.macro	_NewPixMap
		.short	0xaa03
	.endm

	.macro	_CopyPixMap
		.short	0xaa05
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

	.macro	_SetGDevice
		.short	0xaa31
	.endm

	.macro	_GetGDevice
		.short	0xaa32
	.endm

	.macro	_QDError
		.short	0xaa40
	.endm

	.macro	_HighLevelFSDispatch
		.short	0xaa52
	.endm

	.macro	_FSpOpenResFile
		moveq	#13,%d0
		.short	0xaa52
	.endm

	.macro	_DockingDispatch
		.short	0xaa57
	.endm

	.macro	_SetMCInfo
		.short	0xaa62
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

	.macro	_QuickTimeDispatch
		.short	0xaaaa
	.endm

	.macro	_AlphaDispatch
		.short	0xabc0
	.endm

	.macro	_DeviceLoop
		.short	0xabca
	.endm

	.macro	_DSPDispatch s1
		.ifnb \s1
			movew #\s1,%d0
		.endif
		.short	0xabf5
	.endm

	.macro	_DSPSetTaskInactive
		_DSPDispatch 29
	.endm

	.macro	_DSPNewAddress
		_DSPDispatch 31
	.endm

	.macro	_DSPDisposeAddress
		_DSPDIspatch 32
	.endm

	.macro	_DSPFIFOClearInterrupt
		_DSPDispatch 61
	.endm

	.macro	_DSPFIFOSetMessageMode
		movew	#65,%d0
		.short	0xabf5
	.endm

	.macro	_DSPFIFOReset
		movew	#66,%d0
		.short	0xabf5
	.endm

	.macro	_DSPGetOwnerClient
		movew	#71,%d0
		.short	0xabf5
	.endm

	.macro	_DSPGetTaskStatus
		movew	#92,%d0
		.short	0xabf5
	.endm

	.macro	_DSPFIFOGetMessageDispatch
		movew	#94,%d0
		.short	0xabf5
	.endm

	.macro	_DSPClientRefNumToDSPClientPtr
		movew	#117,%d0
		.short	0xabf5
	.endm

	.macro	_DSPGetCPUDeviceGivenIndex
		movew	#121,%d0
		.short	0xabf5
	.endm

	.macro	_DSPGetTaskGivenSectionTable
		movew	#124,%d0
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

	.macro	_DebugStr
		.short	0xabff
	.endm

	.equ	__FCL_1_2A_, 0x312e3241		/* "1.2A" */
	.equ	__FCL_CRSR_, 0x43525352		/* "CRSR" */
	.equ	__FCL_CURS_, 0x43555253		/* "CURS" */
	.equ	__FCL_DITL_, 0x4449544c		/* "DITL" */
	.equ	__FCL_DSAT_, 0x44534154		/* "DSAT" */
	.equ	__FCL_PAT__, 0x50415420		/* "PAT " */
	.equ	__FCL_STR__, 0x53545220		/* "STR " */
	.equ	__FCL_atkv_, 0x61746b76		/* "atkv" */
	.equ	__FCL_atlk_, 0x61746c6b		/* "atlk" */
	.equ	__FCL_clos_, 0x636c6f73		/* "clos" */
	.equ	__FCL_easy_, 0x65617379		/* "easy" */
	.equ	__FCL_ecfg_, 0x65636667		/* "ecfg" */
	.equ	__FCL_flag_, 0x666c6167		/* "flag" */
	.equ	__FCL_hdwr_, 0x68647772		/* "hdwr" */
	.equ	__FCL_mach_, 0x6d616368		/* "mach" */
	.equ	__FCL_misc_, 0x6d697363		/* "misc" */
	.equ	__FCL_os___, 0x6f732020		/* "os  " */
	.equ	__FCL_pgsz_, 0x7067737a		/* "pgsz" */
	.equ	__FCL_powr_, 0x706f7772		/* "powr" */
	.equ	__FCL_ppc__, 0x70706320		/* "ppc " */
	.equ	__FCL_pref_, 0x70726566		/* "pref" */
	.equ	__FCL_proc_, 0x70726f63		/* "proc" */
	.equ	__FCL_qd___, 0x71642020		/* "qd  " */
	.equ	__FCL_rom__, 0x726f6d20		/* "rom " */
	.equ	__FCL_rovm_, 0x726f766d		/* "rovm" */
	.equ	__FCL_snd__, 0x736e6420		/* "snd " */
	.equ	__FCL_snhw_, 0x736e6877		/* "snhw" */
	.equ	__FCL_sysv_, 0x73797376		/* "sysv" */
	.equ	__FCL_vm___, 0x766d2020		/* "vm  " */

	.equ	UTableBase, 0x11c
	.equ	CPUFlag, 0x12f
	.equ	UnitNtryCnt, 0x1d2
	.equ	ExpandMem, 0x2b6
	.equ	TopMapHndl, 0xa50
	.equ	SysMap, 0xa58
	.equ	CurMap, 0xa5a
	.equ	ResLoad, 0xa5e
	.equ	TaskLock, 0xa62
	.equ	HWCWFlags, 0xb22
	.equ	RomMapInsert, 0xb9e
	.equ	HSCHandle, 0x0b84
	.equ	ResOneDeep, 0x0b9a
	.equ	JVBLTask, 0x0d28
	.equ	JSwapMMU, 0x0dbc
	.equ	LaunchFlag, 0x0902
	.equ	SInfoPtr, 0x0cbc
	.equ	MMFlags, 0x1efc
	.equ	vMMRHPrologue, 0x1fe0
	.equ	DockingGlobals, 0x1ff8
