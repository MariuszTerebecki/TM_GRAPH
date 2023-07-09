{******************************************************}
{*                                                    *}
{*         Chyba najprostsza " wyžwietlarka "         *}
{*       do plik¢w graficznych BMP 320x200x256        *}
{*                                                    *}
{*      (c) 1993  TM Studio  Terebecki Mariusz        *}
{*                                                    *}
{*            wersja pe’na z driverem                 *}
{*                                                    *}
{******************************************************}

program ShowBMP_320x200x256;

{ Wykorzystywane modu’y }
uses Dos, Vga256NF, BMP;

{ Wykorzystywane typy }
type PProgram = ^TProgram;
     TProgram = object(TBMP)
                  SR: SearchRec;
                  Vga: TVga;
                  Ok: Boolean;
                  constructor Init;
                  destructor Done;
                  procedure Run;
                  procedure Help;
                end{TProgram};

function Rozn(Name: string): Byte;
var
  R: Byte;
  F: file;
  Reading, I: Word;
  B: array[1..10000] of Byte;
begin
  R := 0;
  Assign(F, Name);
  {$I-}
  Reset(F, 1);
  repeat
    BlockRead(F, B, 10000, Reading);
    for I := 1 to Reading do
      R := R xor B[I];
  until Reading <> 10000;
  Close(F);
  {$I+}
  Rozn := R;
end;

procedure PrgError(S: string; Hlt: Boolean);
begin
  WriteLn(S + ' !'#7'!'#7);
  if Hlt then Halt(1);
end{PrgError};

constructor TProgram.Init;
var Parameter: string;
begin
  Ok := True;
  if ParamCount <> 1 then
    begin
      Ok := False;
      Help;
      Exit;
    end;
  Parameter := ParamStr(1);
  if Pos('.', Parameter) = 0 then
    Parameter := Parameter + '.bmp';
  FindFirst(Parameter, 255, SR);
  if DosError <> 0 then
    begin
      Ok := False;
      PrgError('Nie ma takiego pliku', False);
    end;
  if ( Copy(Parameter, Length(Parameter) - 3, 4) <> '.bmp' ) or
     ( SR.Size <> 65078 ) then
    begin
      Ok := False;
      PrgError('Z’y plik ' + Parameter, False);
    end;
  if not Ok then Exit;
  Delete(Parameter, Length(Parameter) - 3, 4);
  Vga.Init;
  inherited Init(Parameter);
end{TProgram.Init};

destructor TProgram.Done;
begin
  if not Ok then Exit;
  inherited Done(False);
  Vga.Done;
end{TProgram.Done};

procedure TProgram.Run;
begin
  if not Ok then Exit;
  Show(0, 0, True);
  asm
    mov ax, 0c08h
    int 21h
  end;
end{TProgram.Run};

procedure TProgram.Help;
var A: Byte;
begin
  for A := 1 to 25 do WriteLn;
  WriteLn('View BMP 320x200x256 v1.0 for TM Graph v1.0'#10#10#13 +
          '(c)1994 TM Studio - Terebecki Mariusz'#10#10#13 +
          'Sk’adnia wywo’ania : VBMP.EXE plik_z_rysunkiem<.BMP>');
end{TProgram.Help};

{ Zmienna pomocnicza }
var MyProgram: PProgram;
const R: Byte = 114;

begin
  if Boolean(R) then;
  if Rozn('VBMP.EXE')<>0
    then Exit;
  New(MyProgram, Init);
  MyProgram^.Run;
  Dispose(MyProgram, Done);
end{VBMP}.