{********************************************}
{*                                          *}
{*  Moduí inicjujÜcy i zamykajÜcy grafikë.  *}
{*                                          *}
{*  ( wykorzystuje sterownik VGA256.BGI )   *}
{*  (    firmy Borland International    )   *}
{*                                          *}
{*      (c) 1994  Terebecki Mariusz         *}
{*                                          *}
{********************************************}

unit VGA256;

interface

{ ***** Wykorzystywane typy ***** }

     { Tryb graficzny jest sterowany przez obiekt, kt¢ry      }
     { po zainicjowaniu wíÜcza go, a po deinicjacji wyíÜcza   }
     { Wszelkie bíëdy inicjacji bÜd¶ rejestracji sterownika   }
     { powodujÜ zako§czenie programu wykorzystujÜcego obiekt. }
     { Z tego wzglëdu zalecane jest inicjowanie obiektu przed }
     { rozpoczëciem pracy programu, lub dziedziczenie w       }
     { gí¢wnym obiekcie programu.                             }
type PVGA = ^TVGA;
     TVGA = object
              constructor Init;
              destructor Done;
            end;

     { Paleta jest 256-kolorowa ... }
     TPalette256 = array[0..255] of array[0..2] of Byte;
     APalette256 = array[0..767] of Byte;

{ ***** Wykorzystywane procedury ***** }

{ ... a ustawiç jÜ moßna niezaleßnie od trybu }
procedure SetPalette(var PalBuf);

procedure UpPalette256(PalBuf: APalette256);
procedure DownPalette256;

{ Programowo moßna nawet wyíÜczyç monitor }
procedure MonitorOn;
procedure MonitorOff;

{ ***** Wykorzystywane zmienne ***** }

{ Na zewnÜtrz sÜ r¢wnieß udostëpniane zmienne ustalane }
{ przy inicjacji grafiki, oznaczajÜce wykorzystywane w }
{ module czcionki firmy Borland International.         }

var BigFont, SmallFont: Integer;

implementation

uses Graph, Crt; { Standardowy moduí obsíugujÜcy grafikë ...    }

var
  Palette: APalette256;

{ Wyûwietlenie komunikatu i opuszczenie programu }
procedure ErrorMessage;
begin
  WriteLn('VGA driver error : ', GraphErrorMsg(GraphResult));
  Halt(1);
end;

{$F+}

{ Sterownik bëdzie rezydowaí w pamiëci ...    }
function VGA256Detect: Integer;
begin
  VGA256Detect := 1;
end;

{ ... a jego kod bëdzie doíÜczony do programu }
{ podczas kompilacji                          }
procedure VGA256DriverProc; external;
{$L VGA256}

{ To samo z fontami, kt¢re ußywam najczëûciej }
procedure BoldFontProc; external;
{$L BOPL}

procedure SmallFontProc; external;
{$L LIPL}

{$F-}

{ Konstruktor inicjujÜcy grafikë ... }
constructor TVGA.Init;
var GraphDriver, GraphMode, Font: Integer;
begin
  GraphDriver := InstallUserDriver('Vga256', @VGA256Detect);
  if GraphDriver = grError
    then ErrorMessage;
  if RegisterBGIDriver(@VGA256DriverProc) < 0
    then ErrorMessage;
  SmallFont := InstallUserFont('lipl');
  BigFont := InstallUserFont('bopl');
  if ( RegisterBGIFont(@BoldFontProc) < 0 ) or
     ( RegisterBGIFont(@SmallFontProc) < 0 )
    then ErrorMessage;
  GraphMode := 0;
  InitGraph(GraphDriver, GraphMode, '');
  if GraphResult <> grOk
    then ErrorMessage else
    begin
      SetPalette(Mem[SegA000:$0000]);
{      Port[$3C2] := $63 or $80;}
    end;
end{TVGA.Init};

{ ... oraz destruktor zamykajÜcy     }
destructor TVGA.Done;
begin
  CloseGraph;
end{TVGA.Done};

{ Ustawienie palety kolor¢w 256 - elementowej }
procedure SetPalette; assembler;
asm
	MOV	AX,	1012H
	XOR	BX,	BX
	MOV	CX,	256
	LES	DX,	PalBuf
	INT	10H
end;{SetPalette256}

{ /\ W tym przypadku musiaíem ûrednik umieûciç }
{ przed komentarzem, poniewaß edytor TP 7.0 w  }
{ innym przypadku nie identyfikuje síowa "end" }
{ jako ko§ca definicji czëûci asemblerowej.    }

procedure UpPalette256;
var
  Palette: APalette256;
  I, J: Word;
begin
  FillChar(Palette, 768, 0);
  for I := 0 to 63 do
    begin
      for J := 0 to 767 do
        Inc(Palette[J], Byte(PalBuf[J]>Palette[J]));
      SetPalette(Palette);
      Delay(3);
    end;
end;

procedure DownPalette256;
var
  I, J: Word;
  Palette: ^APalette256;
begin
  New(Palette);
  asm
	MOV	AX,	1017H
	XOR	BX,	BX
	MOV	CX,	256
	LES	DX,	Palette
	INT	10H
  end;
  for I := 0 to 63 do
    begin
        asm
		LES	DI,	Palette
		ADD	DI,	768
		MOV	CX,	768
		@Loop:
		CMP	BYTE PTR ES:[DI],	0
		JE	@Next
		DEC	BYTE PTR ES:[DI]
		@Next:
		DEC	DI
		LOOP	@Loop
        end;
      SetPalette(Palette^);
      Delay(3);
    end;
  Dispose(Palette);
end;

{ Programowe przyíÜczenie monitora ... }
procedure MonitorOn;
begin
  Port[$3c4] := 1;
  Port[$3c5] := Port[$3c5] and $df;
end{MonitorOn};

{ ... oraz odíÜczenie                  }
procedure MonitorOff;
begin
  Port[$3c4] := 1;
  Port[$3c5] := Port[$3c5] or $20;
end{MonitorOff};

end{VGA256}.