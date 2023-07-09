{$A+,B-,D-,E+,F-,G-,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 16384,0,655360}

unit IMP;

{

Format danych niespakowanych:

record
  DLen: Word; Díugoûç danych do spakowania.
  Data: array[1..DLen] of Byte; Dane do spakowania.
end;

Format danych spakowanych:

record
  PLen: Word; Díugoûç danych po spakowaniu
  DLen: Word; Díugoûç danych przed spakowaniem.
  Data: array[1..DLen] of Byte; Spakowane dane.
end;

}

interface

procedure Implode(InBuff, OutBuff: Pointer);
procedure Explode(InBuff, OutBuff: Pointer);

implementation

procedure Implode; assembler;
var
  SubStract, ToPack: Integer;
  Base, InSeg, OutSeg, InOfs, OutOfs: Integer;
asm
	PUSH	DS
	CLD
	LES	AX	,InBuff
	MOV	BX	,ES
	MOV	DX	,AX
	AND	AX	,000fh
	MOV	InOfs	,AX
	MOV	CL	,4
	SHR	DX	,CL
	ADD	BX	,DX
	MOV	InSeg	,BX
	LES	AX	,OutBuff
	MOV	BX	,ES
	MOV	DX	,AX
	AND	AX	,000fh
	MOV	OutOfs	,AX
	MOV	CL	,4
	SHR	DX	,CL
	ADD	BX	,DX
	MOV	OutSeg	,BX
	MOV	SubStract,	-1
	MOV	DS	,InSeg
	MOV	SI	,InOfs
	MOV	ES	,OutSeg
	MOV	DI	,OutOfs
	LODSW
	STOSW
	STOSW
	MOV	ToPack	,AX
	MOV	Base	,DI
	ADD	DI,	2
	MOV	AH,	16
	LODSB
	JMP	@@Here1
@@HereWego:
	CMP	ToPack	,0
	JLE	@@Packed
	LODSB
	CALL	@@BuffScan
	SUB	CL,	2
	JAE	@@Here2
@@Here1:
	CLC
	CALL	@@InsertBit
	DEC	ToPack
	STOSB
	JMP	@@HereWego
@@Here2:
	MOV	AL,	CH
	XOR	CH,	CH
	ADD	SI,	CX
	ADD	SI,	1
	SUB	ToPack,	CX
	SUB	ToPack,	2
	SHL	CL,	1
	SHL	CL,	1
	SHL	CL,	1
	SHL	CL,	1
	SHL	CL,	1
	STC
	CALL	@@InsertBit
	RCL	CL,	1
	CALL	@@InsertBit
	RCL	CL,	1
	CALL	@@InsertBit
	RCL	CL,	1
	CALL	@@InsertBit
	STOSB
	JMP	@@HereWego
@@Packed:
	CMP	AH,	16
	JZ	@@NoExtra
	MOV	CL,	AH
	SHL	DX,	CL
	PUSH	DI
	MOV	DI,	Base
	MOV	ES:[DI],	DX
	POP	DI
@@NoExtra:
	MOV	AX,	DI
	MOV	DI,	OutOfs
	SUB	AX,	DI
	INC	AX
	MOV	ES:[DI],	AX
	JMP	@@ProcExit
@@BuffScan:
	MOV	BX,	SubStract
	XOR	CX,	CX
@@CMPNext:
	CMP	AL,	[SI+BX-1]
	JNZ	@@NotFound
	PUSH	AX
	PUSH	DX
	PUSH	SI
	MOV	DH,	BL
	MOV	DL,	1
@@SeeNext:
	LODSB
	CMP	AL,	[SI+BX-1]
	JNZ	@@StrEnd
	INC	DL
	CMP	DL,	9
	JNZ	@@SeeNext
@@StrEnd:
	CMP	DL,	CL
	JBE	@@StrExit
	MOV	CX,	DX
@@StrExit:
	POP	SI
	POP	DX
	POP	AX
@@NotFound:
	CMP	BX,	0FFFFH
	JZ	@@ScanEnd
	INC	BX
	JMP	@@CmpNext
@@ScanEnd:
	PUSH	CX
	XOR	CH,	CH
	OR	CL,	CL
	JNZ	@@Jump1
	INC	CL
@@Jump1:
	CMP	SubStract,	0FF00H
	JZ	@@BSExit
	DEC	SubStract
	LOOP	@@Jump1
@@BSExit:
	POP	CX
	RETN
@@InsertBit:
	RCL	DX,	1
	DEC	AH
	JNZ	@@IBExit
	MOV	AH,	16
	PUSH	DI
	MOV	DI,	Base
	MOV	ES:[DI],	DX
	POP	DI
	MOV	Base,	DI
	ADD	DI,	2
@@IBExit:
	RETN
@@ProcExit:
	POP	DS
end {Implode};

procedure Explode; assembler;
var
  InSeg, OutSeg, InOfs, OutOfs, ToUnPack: Word;
asm
	PUSH	DS
	CLD
	LES	AX	,InBuff
	MOV	BX	,ES
	MOV	DX	,AX
	AND	AX	,000fh
	MOV	InOfs	,AX
	MOV	CL	,4
	SHR	DX	,CL
	ADD	BX	,DX
	MOV	InSeg	,BX
	LES	AX	,OutBuff
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
end {Explode};

end{Exploder}.