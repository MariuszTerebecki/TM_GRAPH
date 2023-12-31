{********************************************}
{*                                          *}
{*  Modu� inicjuj�cy i zamykaj�cy grafik�.  *}
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

     { Tryb graficzny jest sterowany przez obiekt, kt�ry      }
     { po zainicjowaniu w��cza go, a po deinicjacji wy��cza   }
     { Wszelkie b��dy inicjacji b�d� rejestracji sterownika   }
     { powoduj� zako�czenie programu wykorzystuj�cego obiekt. }
     { Z tego wzgl�du zalecane jest inicjowanie obiektu przed }
     { rozpocz�ciem pracy programu, lub dziedziczenie w       }
     { g��wnym obiekcie programu.                             }
type PVGA = ^TVGA;
     TVGA = object
              constructor Init;
              destructor Done;
            end;

     { Paleta jest 256-kolorowa ... }
     TPalette256 = array[0..255] of array[0..2] of Byte;
     APalette256 = array[0..767] of Byte;

{ ***** Wykorzystywane procedury ***** }

{ ... a ustawi� j� mo�na niezale�nie od trybu }
procedure SetPalette(var PalBuf);

procedure UpPalette256(PalBuf: APalette256);
procedure DownPalette256;

{ Programowo mo�na nawet wy��czy� monitor }
procedure MonitorOn;
procedure MonitorOff;

{ ***** Wykorzystywane zmienne ***** }

{ Na zewn�trz s� r�wnie� udost�pniane zmienne ustalane }
{ przy inicjacji grafiki, oznaczaj�ce wykorzystywane w }
{ module czcionki firmy Borland International.         }

var BigFont, SmallFont: Integer;

implementation

uses Graph, Crt; { Standardowy modu� obs�uguj�cy grafik� ...    }

var
  Palette: APalette256;

{ Wy�wietlenie komunikatu i opuszczenie programu }
procedure ErrorMessage;
begin
  WriteLn('VGA driver error : ', GraphErrorMsg(GraphResult));
  Halt(1);
end;

{$F+}

{ Sterownik b�dzie rezydowa� w pami�ci ...    }
function VGA256Detect: Integer;
begin
  VGA256Detect := 1;
end;

{ ... a jego kod b�dzie do��czony do programu }
{ podczas kompilacji                          }
procedure VGA256DriverProc; external;
{$L VGA256}

{ To samo z fontami, kt�re u�ywam najcz��ciej }
procedure BoldFontProc; external;
{$L BOPL}

procedure SmallFontProc; external;
{$L LIPL}

{$F-}

{ Konstruktor inicjuj�cy grafik� ... }
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

{ ... oraz destruktor zamykaj�cy     }
destructor TVGA.Done;
begin
  CloseGraph;
end{TVGA.Done};

{ Ustawienie palety kolor�w 256 - elementowej }
procedure SetPalette; assembler;
asm
	MOV	AX,	1012H
	XOR	BX,	BX
	MOV	CX,	256
	LES	DX,	PalBuf
	INT	10H
end;{SetPalette256}

{ /\ W tym przypadku musia�em �rednik umie�ci� }
{ przed komentarzem, poniewa� edytor TP 7.0 w  }
{ innym przypadku nie identyfikuje s�owa "end" }
{ jako ko�ca definicji cz��ci asemblerowej.    }

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

{ Programowe przy��czenie monitora ... }
procedure MonitorOn;
begin
  Port[$3c4] := 1;
  Port[$3c5] := Port[$3c5] and $df;
end{MonitorOn};

{ ... oraz od��czenie                  }
procedure MonitorOff;
begin
  Port[$3c4] := 1;
  Port[$3c5] := Port[$3c5] or $20;
end{MonitorOff};

end{VGA256}.