{*******************************************}
{*                                         *}
{*         Moduí obsíugujÜcy mysz          *}
{* ( napisany dla programu TM Graph v1.0 ) *}
{*                                         *}
{*    poprawnie dziaía np. z driverem :    *}
{*    Mighty CAT version 3.00  (c) 1989    *}
{*                                         *}
{*      (c) 1993  Terebecki Mariusz        *}
{*                                         *}
{*******************************************}

unit MMouse;

interface

{ ***** Wykorzystywane typy ***** }

type TMMP = record
              Button: Byte;  { 1..3 }
              Column, Row: Word;
            end{TMMP};

{ ***** Wykorzystywane staíe ***** }

const TwoButtons = True;

{ ***** Wykorzystywane procedury i funkcje ***** }

function MMIsInstall(var MMType: Boolean): Boolean;
procedure MMShow;
procedure MMHide;
procedure GetMousePos(var GMP: TMMP);
procedure SetMousePos(X, Y: Integer);
function MouseX: Word;
function MouseY: Word;
function MouseButton: Byte;
procedure SetMouseX(X1, X2: Integer);
procedure SetMouseY(Y1, Y2: Integer);

implementation

{ Funkcja zwraca TRUE, jeûli mysz jest zainstalowana }
{ oraz typ myszy :                                   }
{ 1.) TRUE  - 2 przyciski                            }
{ 2.) FALSE - inna                                   }
function MMIsInstall(var MMType: Boolean): Boolean;
var MT: Boolean;
begin
  asm
    mov ax, 0000h
    int 33h
    mov MT, bl 
    mov @Result, al
  end;
  MMType := MT;
end{MMIsInstall};

{ Wyûwietlenie kursora myszy }
procedure MMShow; assembler;
asm
  mov ax, 0001h
  int 33h
end;{MMShow}

{ /\ W tym przypadku musiaíem ûrednik umieûciç }
{ przed komentarzem, poniewaß edytor TP 7.0 w  }
{ innym przypadku nie identyfikuje síowa "end" }
{ jako ko§ca definicji czëûci asemblerowej.    }

{ Schowanie kursora myszy }
procedure MMHide; assembler;
asm
  mov ax, 0001h
  int 33h
  mov ax, 0002h
  int 33h
end;{MMHide}

{ /\ j.w.                                      }

procedure GetMousePos(var GMP: TMMP);
var C, R: Integer;
    B: Byte;
begin
  asm
    mov ax, 0003h
    int 33h
    mov B, bl
    mov C, cx
    mov R, dx
  end;
  with GMP do
    begin
      case B of
        1: Button := 100;
        2: Button := 001;
        4: Button := 010;
        3: Button := 101;
        else Button := 000;
      end;
      Column := C;
      Row := R;
    end;
end{GetMousePos};

procedure SetMousePos(X, Y: Integer); assembler;
asm
  mov AX, 0004h
  mov CX, X
  mov DX, Y
  int 33h
end;{SetMousePos}

{ /\ j.w.                                      }

{ Zmienna pomocnicza }
var GMP: TMMP;

{ Pozycja X kursora myszy }
function MouseX;
begin
  GetMousePos(GMP);
  MouseX := GMP.Column div 2;
end{MouseX};

{ Pozycja Y kursora myszy }
function MouseY;
begin
  GetMousePos(GMP);
  MouseY := GMP.Row;
end{MouseY};

{ Przycisk myszy }
function MouseButton: Byte;
begin
  GetMousePos(GMP);
  MouseButton := GMP.Button;
end{MouseButton};

{ Zakres poziomy "wybiegu" myszy }
procedure SetMouseX; assembler;
asm
  mov ax, 0007h
  mov cx, X1
  shl cx, 1
  mov dx, X2
  shl dx, 1
  int 33h
end;{SetMouseX}

{ /\ j.w.                                      }

{ Zakres poziomy "wybiegu" myszy }
procedure SetMouseY; assembler;
asm
  mov ax, 0008h
  mov cx, Y1
  mov dx, Y2
  int 33h
end{SetMouseY};

end{MMouse}.