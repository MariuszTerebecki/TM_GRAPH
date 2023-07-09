program ViewPaletteForTMGraph_v1_0;

{ Wykorzystywane modu’y }
uses VGA256NF, Graph, Dos;

{ Wykorzystywane zmienne }
var PaletteFile: file;
    Palette: TPalette256;
    GraphMode: TVGA;
    I: Byte;
    X: Word;
    Result: Integer;
    FileLength: LongInt;
    Parameter: string;

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

procedure PrgError(S: string; Err: Integer);
begin
  if Err = 0
    then WriteLn(S + ' !'#7'!'#7)
    else WriteLn(S, ' ', Err, ' !'#7'!'#7);
  Halt(Err);
end{PrgError};

const
  R: Byte = 247;

begin
  if Boolean(R) then;
  if Rozn('VPAL.EXE')<>0
    then Exit;
  Parameter := ParamStr(0);
  while Parameter[Length(Parameter)] <> '\' do
    Delete(Parameter, Length(Parameter), 1);
  if ParamCount <> 1
    then begin
           for I := 1 to 25 do WriteLn;
           WriteLn('View Palette v1.0 for TM Graph v1.0'#10#10#13 +
                   '(c)1994 TM Studio - Terebecki Mariusz'#10#10#13 +
                   'Sk’adnia wywo’ania : VPAL.EXE plik_z_palet†<.PAL>');
           Halt;
         end;
  Parameter := ParamStr(1);
  if Pos('.', Parameter) = 0 then
    Parameter := Parameter + '.PAL';
  Assign(PaletteFile, Parameter);
  {$I-}
  Reset(PaletteFile, 1);
  FileLength := FileSize(PaletteFile);
  BlockRead(PaletteFile, Palette, 768, X);
  Close(PaletteFile);
  Result := IOResult;
  {$I+}
  if FileLength <> 768 then PrgError('Z’y plik ' + Parameter, 0);
  if Result <> 0 then PrgError('B’†d wejžcia/wyjžcia : ', Result);
  GraphMode.Init;
  SetPalette256(Palette, 0, 256);
  for I := 0 to 255 do
    begin
      SetColor(I);
      Line(I + 32, 50, I + 32, 150);
    end;
  asm
    mov ax, 0c08h
    int 21h
  end;
  GraphMode.Done;
end{VPal}.