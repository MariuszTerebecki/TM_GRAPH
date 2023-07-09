{********************************************}
{*                                          *}
{*  Modu’ rozpakowuj†cy dane skompresowane  *}
{*       przy pomocy modu’u Imploder.       *}
{*                                          *}
{********************************************}

unit Exploder;

interface

{ ***** Wykorzystywane procedury ***** }

{ W’ažciwa i jedyna procedura w module }
procedure Explode(InBuf, OutBuf: Pointer);

implementation

procedure Explode(InBuf, OutBuf: Pointer); assembler;
var InSeg, OutSeg, InOfs, OutOfs, ToUnPack: Word;
asm
	PUSH	DS
	CLD
	LES	AX	,InBuf
	MOV	BX	,ES
	MOV	DX	,AX
	AND	AX	,000fh
	MOV	InOfs	,AX
	MOV	CL	,4
	SHR	DX	,CL
	ADD	BX	,DX
	MOV	InSeg	,BX
	LES	AX	,OutBuf
	MOV	BX	,ES
	MOV	DX	,AX
	AND	AX	,000fh
	MOV	OutOfs	,AX
	MOV	CL	,4
	SHR	DX	,CL
	ADD	BX	,DX
	MOV	OutSeg	,BX
	MOV	DS	,InSeg
	MOV	SI	,InOfs
	MOV	ES	,OutSeg
	MOV	DI	,OutOfs
	LODSW
	LODSW
	STOSW
	MOV	ToUnPack	,AX
	LODSW
	MOV	DX	,AX
	MOV	AH	,16
@@HereWego:
	CMP	ToUnPack	,0
	JLE	@@UnPacked
	CALL	@@GetBit
	JC	@@Here1
	MOVSB
	DEC	ToUnPack
	JMP	@@HereWego
@@Here1:
	XOR	CX	,CX
	CALL	@@GetBit
	RCL	CX	,1
	CALL	@@GetBit
	RCL	CX	,1
	CALL	@@GetBit
	RCL	CX	,1
	ADD	CX	,2
	LODSB
	MOV	BL	,AL
	MOV	BH	,0ffh
@@LoopLoc1:
	MOV	AL	,ES:[DI+BX]
	STOSB
	DEC	ToUnPack
	LOOP	@@LoopLoc1
	JMP	@@HereWego
@@GetBit:
	RCL	DX,	1
	PUSHF
	DEC	AH
	JNZ	@@Exit
	MOV	DX	,[SI]
	ADD	SI	,2
	MOV	AH	,16
@@Exit:
	POPF
	RETN
@@UnPacked:
	POP	DS
end{Explode};

end{Exploder}.