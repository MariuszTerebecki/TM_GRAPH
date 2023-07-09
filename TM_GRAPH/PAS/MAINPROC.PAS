{********************************************}
{*                                          *}
{* Moduí zawierajÜcy procedury do programu  *}
{*               TM Graph 1.0               *}
{*                                          *}
{*       (c) 1994  Terebecki Mariusz        *}
{*                                          *}
{********************************************}

unit MainProcedures;

interface

{ ***** Wykorzystywane moduíy ***** }

uses Graph,  { Moduí standardowy pascalowy obsíugujÜcy grafikë }
     MMouse, { Oraz moje: obsíugujÜcy mysz i ...               }
     BMP,    { ... pliki graficzne w formacie BitMaP           }
     Intro,
     Vga256,
     Crt, Dos;

{ ***** Wykorzystywane zmienne ***** }

var FSettings: array[1..8] of Boolean; { PrzeíÜczniki ustawie§ figur }
    EndProgram: Boolean;               { Czy zako§czono program ?    }
    StandardName, StandardDir: string; { Standardowy plik i katalog  }
    Pattern: FillPatternType;          { Wzorek wypeíniania          }
    MenuPalette: APalette256;

    Color, FColor, MinColor, MaxColor, MinFColor, MaxFColor: Byte;
    Picture: PBMP;            { Wska¶nik do obrabianego rysunku }
    TxtB, ScrSaver: Boolean;

{ ***** Wykorzystywane procedury ***** }

{ Wykonanie wybranej przez ußytkownika procedury }
procedure Execute(Gr, Nr: Byte; var PPicture: PBMP);

implementation

{***************************************************************************}

{ Nie wiem dlaczego, ale ta funkcja pascalowa }
{ ¶le dziaía w programie                      }
function Abs(L: Integer): Word;
begin
  if L < 0
    then Abs := 0 - L
    else Abs := L;
end{Abs};

{ Pascalowa procedura nie wyûwietla ramki w koío síupka }
procedure Bar(X1, Y1, X2, Y2: Integer);
begin
  Graph.Bar(X1 + 1 - Byte(X1 > X2) * 2, Y1 + 1 - Byte(Y1 > Y2) * 2,
            X2 + 1 - Byte(X2 > X1) * 2, Y2 + 1 - Byte(Y2 > Y1) * 2);
  Rectangle(X1, Y1, X2, Y2);
end{Bar};

{ Rysowanie figur }
procedure Figure(Nr: Byte);

var X, Y, MX, MY, DX, DY, OX, OY: Integer;
    GMP: TMMP;
    OColor, OFColor, P: Byte;
    Txt: string;

procedure Fill(AX, AY: Integer; Uk: Boolean);

procedure Line(X1, X2, Y: Integer); assembler;
asm
	MOV	DX,	SegA000
	MOV	ES,	DX
	MOV	AX,	320
	MOV	DX,	Y
	MUL	DX
	ADD	AX,	X1
	MOV	DI,	AX
	MOV	CX,	X2
	SUB	CX,	X1
	INC	CX
	CLD
	MOV	AL,	255
	REP	STOSB
end;

type
  PLine = ^TLine;
  TLine = record
    X1, X2, X, Y: Integer;
    Up: Boolean;
  end;

  PStack = ^TStack;
  TStack = record
    Previous: PStack;
    Line: TLine;
  end;

var
  Stack: PStack;
  Scr: array[0..199, 0..319] of Byte absolute $0A000:$0000;
  Bk: Byte;

function GetLine(AX, AY: Integer; var GLine: TLine): Boolean;
begin
  if (Scr[AY, AX] <> Bk) then
    GetLine := False else
    with GLine do
      begin
        GetLine := True;
        Y := AY;
        X1 := AX;
        while (X1 > 0) and (Scr[Y, X1-1] = Bk) do Dec(X1);
        X := X1;
        X2 := AX;
        while (X2 < 319) and (Scr[Y, X2+1] = Bk) do Inc(X2);
        Up := True;
        Line(X1, X2, Y);
      end;
end;

function FindLine(var GLine: TLine): Boolean;
var
  I: Integer;
begin
  FindLine := True;
  with Stack^.Line do
    if (Y > 0) and (Y < 199) then
      begin
        X := X - Byte(Uk and (X > 0));
        if Up then
          begin
            while X <= (X2 + Byte(Uk and (X2<319))) do
              begin
                if GetLine(X, Y+1, GLine) then
                  begin
                    X := GLine.X2;
                    Exit;
                  end;
                Inc(X);
              end;
            Up := False;
          end;
        if X > X2 then X := X2;
        X := X + Byte(Uk) * Byte(Uk and (X < 319));
        if not Up then
          while X >= (X1 - Byte(Uk and (X1 > 0))) do
            begin
              if GetLine(X, Y-1, GLine) then
                begin
                  X := GLine.X1;
                  Exit;
                end;
              Dec(X);
            end;
        if X < X1 then X := X1;
        X := X - Byte(Uk and (X > 0));
      end;
  FindLine := False;
end;

procedure Push(GLine: TLine);
var
  Next: PStack;
begin
  New(Next);
  with Next^ do
    begin
      Line := GLine;
      Previous := Stack;
    end;
  Stack := Next;
end;

function Pop: Boolean;
var
  Next: PStack;
begin
  if Stack <> nil then
    begin
      Pop := True;
      with Stack^ do
        Next := Previous;
      Dispose(Stack);
      Stack := Next;
    end else
    Pop := False;
end;

var
  I: Integer;
  GLine: TLine;
  X, Y: Integer;

begin
  SetRGBPalette(255, 30, 30, 30);
  Bk := Scr[AY, AX];
  Stack := nil;
  SetColor(FColor);
  GetLine(AX, AY, GLine);
  Push(GLine);
  repeat
    while FindLine(GLine) do
      begin
        Push(GLine);
        Stack^.Line := GLine;
      end;
  until not Pop;
{  asm
	MOV	ES,	SegA000
	XOR	DI,	DI
	MOV	CX,	64000
	MOV	AL,	255
	MOV	AH,	FColor
	@Loop:
	MOV	DI,	CX
	CMP	ES:[DI],	AL
	JNE	@Next
	MOV	ES:[DI],	AH
	@Next:
	LOOP	@Loop
  end;}
  for Y := 0 to 199 do
  for X := 0 to 319 do
    if Scr[Y][X] = 255 then
      begin
        Scr[Y][X] := FColor * Byte(Pattern[Succ(Y and 7)] and (128 shr (X and 7)) > 0);
        if Scr[Y][X] = 0 then
          Scr[Y][X] := Bk;
      end;
end;

procedure ReadTxt;
var Ch: Char;
label RExit;
begin
  Txt := '';
  SetTextStyle(SmallFont, HorizDir, 6);
  SetTextJustify(CenterText, CenterText);
  SetFillStyle(1, 243);
  repeat
    MMHide;
    Graph.Bar(1, 1, 318, 23);
    SetColor(245);
    OutTextXY(161, 12, Txt);
    SetColor(0);
    OutTextXY(160, 10, Txt + '_');
    SetColor(8);
    SetColor(235);
    Line(0, 0, 319, 0);
    Line(0, 0, 0, 24);
    SetColor(249);
    Line(319, 0, 319, 24);
    Line(0, 24, 319, 24);
    MMShow;
    repeat
      if MouseButton <> 000
        then goto RExit;
    until KeyPressed;
    Ch := ReadKey;
    case Ch of
      #8: Delete(Txt, Length(Txt), 1);
      #32..#255: Insert(Ch, Txt, Succ(Length(Txt)));
    end;
  until ( Ch in [#13, #27] );
  if Ch = #27
    then Txt := '';
  RExit:
end{Figure.ReadTxt};

procedure ShowTxt(X1, Y1, X2, Y2: Integer; Chg: Boolean);
const Pd: array[0..1] of array[1..2] of Byte = ( ( 3, 5 ), ( 12, 30 ) );
begin
  if Chg
    then SetUserCharSize(Abs(X2 - X1), Length(Txt) * Pd[Byte(FSettings[2])][1],
                         Abs(Y2 - Y1), Pd[Byte(Fsettings[2])][2]);
  OutTextXY(X1, Y1, Txt);
end{Figure.ShowTxt};

begin
  SetMouseX(0, 10000);
  SetMouseY(0, 10000);
  while MouseButton <> 0 do;
  Randomize;
  OColor := Color;
  OFColor := FColor;
  if FSettings[3] or FSettings[5] or FSettings[6]
    then Color := MinColor;
  if FSettings[4] or FSettings[7] or FSettings[8]
    then FColor := MinFColor;
  TxtB := False;
  if Nr = 8
    then begin
           ReadTxt;
           if Txt = '' then Exit;
           if FSettings[2]
             then SetTextStyle(BigFont, HorizDir, 10)
             else SetTextStyle(SmallFont, HorizDir, 10);
           SetTextJustify(CenterText, CenterText);
           TxtB := True;
         end;
  Vga256.DownPalette256;
  ClearDevice;
  Picture^.Show(True);
  repeat
    MMShow;
    X := MouseX;
    Y := MouseY;
    if MouseButton in [100, 101]
      then begin
             MX := MouseX;
             MY := MouseY;
             repeat
               OX := MX;
               OY := MY;
               MX := MouseX;
               MY := MouseY;
               MoveTo(OX, OY);
               if MouseButton = 101
                 then begin
                        X := MX + DX;
                        Y := MY + DY;
                      end
                 else
                      begin
                        DX := X - MX;
                        DY := Y - MY;
                      end;
               if ( ( OX <> MX ) or ( OY <> MY ) ) and
                  ( Nr <> 7 ) and not FSettings[1]
                 then with Picture^ do
                        Show(False);
               if FSettings[3]
                 then Color := Random(MaxColor - MinColor) + MinColor;
               if FSettings[4]
                 then FColor := Random(MaxFColor - MinFColor) + MinFColor;
               if FSettings[5]
                 then if Color < MaxColor
                        then Inc(Color)
                        else Color := MinColor;
               if FSettings[6]
                 then if Color > MinColor
                        then Dec(Color)
                        else Color := MaxColor;
               if FSettings[7]
                 then if FColor < MaxFColor
                        then Inc(FColor)
                        else FColor := MinFColor;
               if FSettings[8]
                 then if FColor > MinFColor
                        then Dec(FColor)
                        else FColor := MaxFColor;
               SetColor(Color);
               SetFillPattern(Pattern, FColor);
               if FSettings[1]
                 then Delay(10);
               if ( ( OX <> MX ) or ( OY <> MY ) ) or
                  FSettings[1] or ( Nr = 6 )
                 then begin
                        MMHide;
                        if not FSettings[2]
                          then case Nr of
                                 1: PutPixel(MX, MY, Color);
                                 2: Line(X, Y, MX, MY);
                                 3: Rectangle(X, Y, MX, MY);
                                 4: Circle(MX, MY, Abs(MX - X));
                                 5: Ellipse(MX, MY, 0, 360, Abs(MX - X), Abs(MY - Y));
                                 6: Fill(MX, MY, False);
                                 7: LineTo(MX, MY);
                                 8: ShowTxt(X, Y, MX, MY, ( MouseButton <> 101 ) );
                               end
                          else case Nr of
                                 1: begin
                                      Rectangle(MX - 2, MY - 2, MX + 2, MY + 2);
                                      Rectangle(MX - 1, MY - 1, MX + 1, MY + 1);
                                      PutPixel(MX, MY, Color);
                                    end;
                                 2: begin
                                      SetLineStyle(SolidLn, 0, ThickWidth);
                                      Line(X, Y, MX, MY);
                                      SetLineStyle(SolidLn, 0, NormWidth);
                                    end;
                                 3: Bar(X, Y, MX, MY);
                                 4: FillEllipse(MX, MY, Abs(MX - X), Abs(MX - X));
                                 5: FillEllipse(MX, MY, Abs(MX - X), Abs(MY - Y));
                                 6: Fill(MX, MY, True);
                                 7: begin
                                      SetLineStyle(SolidLn, 0, ThickWidth);
                                      LineTo(MX, MY);
                                      SetLineStyle(SolidLn, 0, NormWidth);
                                    end;
                                 8: ShowTxt(X, Y, MX, MY, ( MouseButton <> 101 ) );
                               end;
                        MMShow;
                      end;
        until MouseButton = 000;
        MMHide;
        Picture^.Store(0, 0);
        MMShow;
      end;
  until MouseButton = 001;
  Color := OColor;
  FColor := OFColor;
end{Figure};

{***************************************************************************}

{ PrzeíÜczniki ustawie§ dotyczÜcych rysowanych figur }
procedure FigureSettings(Nr: Byte);
begin
  FSettings[Nr] := not FSettings[Nr];
end{FigureSettings};

{***************************************************************************}

{ Wyb¢r koloru rysowania i wypeíniania }
{ przez ußytkownika                    }
function ChangeColor(Palette, F: Boolean; OldColor: Byte): Byte;
var X, Color, OM: Byte;
    MX, MY: Word;
label Exit;
begin
  while MouseButton <> 000 do;
  MMHide;
  SetFillStyle(1, OldColor);
  SetColor(1);
  Bar(10, 10, 310, 59);
  SetMouseX(33, 287);
  SetMouseY(21, 41);
  for X := 0 to 254 do
    begin
      SetColor(X);
      Line(X + 32, 20, X + 32, 40);
    end;
  SetFillStyle(1, 0);
  if Palette
    then begin
           Bar(10, 60, 310, 110);
           if F
             then for X := MinFColor to MaxFColor do
                    begin
                      SetColor(X);
                      Line(X + 32, 70, X + 32, 100);
                    end
             else for X := MinColor to MaxColor do
                    begin
                      SetColor(X);
                      Line(X + 32, 70, X + 32, 100);
                    end;
         end;
  MMShow;
  SetFillStyle(1, 0);
  if F
    then OM := MaxFColor
    else OM := MaxColor;
  if Palette
    then begin
           while MouseButton = 000 do
             begin
               SetColor(GetPixel(Pred(MouseX), Pred(MouseY)));
               Rectangle(10, 10, 310, 59);
             end;
           if MouseButton = 001
             then goto Exit;
           if F
             then MinFColor := GetPixel(Pred(MouseX), Pred(MouseY))
             else MinColor := GetPixel(Pred(MouseX), Pred(MouseY));
           if F
             then SetMouseX(32 + MinFColor, 287)
             else SetMouseX(32 + MinColor, 287);
           while MouseButton = 100 do
             begin
               if F
                 then MaxFColor := GetPixel(Pred(MouseX), Pred(MouseY))
                 else MaxColor := GetPixel(Pred(MouseX), Pred(MouseY));
               if ( F and ( OM <> MaxFColor ) ) or
                  ( not F and ( OM <> MaxColor) )
                 then begin
                        Bar(10, 60, 310, 110);
                        if F
                          then for X := MinFColor to MaxFColor do
                                 begin
                                   SetColor(X);
                                   Graph.Line(32 + X, 70, 32 + X, 100);
                                 end
                          else for X := MinColor to MaxColor do
                                 begin
                                   SetColor(X);
                                   Graph.Line(32 + X, 70, 32 + X, 100);
                                 end;
                        if F
                          then OM := MaxFColor
                          else OM := MaxColor;
                      end;
             end;
         end
    else repeat
           Color := GetPixel(Pred(MouseX), Pred(MouseY));
           SetFillStyle(1, Color);
           Bar(60, 70, 260, 100);
         until ( MouseButton <> 000 );
  if ( MouseButton = 100 ) and not Palette
    then ChangeColor := Color
    else ChangeColor := OldColor;
  Exit:
  SetMouseX(0, 320);
  SetMouseY(0, 200);
end{ChangeColor};

{ Operacje na caíym lub fragmentach obrazu }
procedure Images(Nr: Byte);
var E: Integer;
    ON: string;
begin
  if Nr in [3..7]
    then begin
           MMHide;
           Vga256.DownPalette256;
           ClearDevice;
           with Picture^ do
             Show(True);
           MMShow;
         end;
  ON := FileName;
  if Nr in [1..2]
    then FileName := StandardDir + '\$CLIP$';
  case Nr of
    1: Picture^.SaveImage(E);
    2: Picture^.LoadImage(E);
    3: begin
         while MouseButton = 000 do;
         while MouseButton <> 000 do;
       end;
    4: Color := ChangeColor(False, False, Color);
    5: FColor := ChangeColor(False, False, FColor);
    6: ChangeColor(True, False, 0);
    7: ChangeColor(True, True, 0);
    8: begin
         MMHide;
         Vga256.DownPalette256;
         ClearDevice;
         Picture^.Store(0, 0);
         MMShow;
       end;
  end;
  FileName := ON;
end{Images};

{***************************************************************************}

{ Ustawienia graficzne nie mogÜ byç zmienione po   }
{ wykonaniu procedury, wiëc trzeba je przedtem ... }
var OldTextSettings: TextSettingsType;
    OldFillSettings: FillSettingsType;
    OldColor: Byte;

{ ... zapamiëtaç, a nastëpnie ... }
procedure ProcInit;
begin
  GetTextSettings(OldTextSettings);
  GetFillSettings(OldFillSettings);
  OldColor := GetColor;
end{ProcInit};

{ ... odtworzyç }
procedure ProcDone;
begin
  SetTextStyle(OldTextSettings.Font,
               OldtextSettings.Direction,
               OldTextSettings.CharSize);
  SetTextJustify(OldTextSettings.Horiz,
                 OldTextSettings.Vert);
  SetFillStyle(OldFillSettings.Pattern,
               OldFillSettings.Color);
  SetColor(OldColor);
end{ProcDone};

{ Procedurka pomocnicza }
procedure Contour(X1, Y1, X2, Y2: Integer);
begin
  if ( X1 = X2 ) or ( Y1 = Y2 )
    then Exit;
  SetFillStyle(1, 243);
  Graph.Bar(X1, Y1, X2, Y2);
  SetColor(249);
  Line(X1, Y2, X2, Y2);
  Line(X2, Y2, X2, Y1);
  SetColor(236);
  Line(X1, Y1, X2, Y1);
  Line(X1, Y1, X1, Y2);
end{Contour};

function Str(Value: Byte): string;
var S: string;
begin
  System.Str(Value, S);
  Str := S;
end{Str};

{ Procedury dotyczÜce caíego programu }
procedure ProgramProcedures(Nr: Byte);

{ Zatwierdzenie operacji plikowej }
function FilesOk(Extension: string; Load: Boolean): Boolean;

{ Staíe "okienek" }
const Contours: array[1..11] of array[1..2, 1..2] of Integer =
        ( ( (45, 20), (275, 150) ), ( (55, 30), (180, 50) ),
          ( (55, 60), (148, 80) ), ( (195, 30), (265, 50) ),
          ( (195, 60), (265, 80) ), ( (55, 90), (265, 110) ),
          ( (55, 120), (100, 140) ), ( (110, 120), (155, 140) ),
          ( (165, 120), (210, 140) ), ( (220, 120), (265, 140) ),
          ( (0, 0), (0, 0) ) );
      Labels: array[1..10] of string[10] =
        ( '', 'STANDARD', '', 'OK', 'ANULUJ', '',
          'A:', 'B:', 'C:', 'D:');
      Colors: array[1..10] of Byte =
        ( 0, 8, 0, 2, 8, 0, 3, 3, 3, 3 );

var X, Button: Byte;
    SR: SearchRec;
    PDirName, ODirName: string;

{ Naciûniëty przycisk w okienku }
function PressingButton: Byte;
var X, EB, Pr: Byte;
begin
  PressingButton := 0;
  if MouseButton <> 100 then Exit;
  Pr := 11;
  repeat
    EB := 1;
    repeat
      Inc(EB)
    until ( MouseX > Contours[EB][1, 1] ) and
          ( MouseX < Contours[EB][2, 1] ) and
          ( MouseY > Contours[EB][1, 2] ) and
          ( MouseY < Contours[EB][2, 2] ) or
          ( EB > 10 );
    if ( Pr <> EB )
      then begin
             SetTextJustify(CenterText, CenterText);
             MMHide;
             Contour(Contours[EB][2, 1], Contours[EB][2, 2],
                     Contours[EB][1, 1], Contours[EB][1, 2]);
             SetColor(246);
             OutTextXY(Contours[EB][1, 1] + ( Contours[EB][2, 1]
                       - Contours[EB][1, 1] ) div 2 + 2,
                       Contours[EB][1, 2] + ( Contours[EB][2, 2]
                       - Contours[EB][1, 2] ) div 2,
             Labels[EB]);
             SetColor(Colors[EB]);
             OutTextXY(Contours[EB][1, 1] + ( Contours[EB][2, 1]
                       - Contours[EB][1, 1] ) div 2,
                       Contours[EB][1, 2] + ( Contours[EB][2, 2]
                       - Contours[EB][1, 2] ) div 2 - 2,
             Labels[EB]);
             if Pr in [1..10] then
               begin
                 Contour(Contours[Pr][1, 1], Contours[Pr][1, 2],
                         Contours[Pr][2, 1], Contours[Pr][2, 2]);
                 SetColor(Colors[Pr]);
                 OutTextXY(Contours[Pr][1, 1] + ( Contours[Pr][2, 1]
                           - Contours[Pr][1, 1] ) div 2,
                           Contours[Pr][1, 2] + ( Contours[Pr][2, 2]
                           - Contours[Pr][1, 2] ) div 2 - 2,
                 Labels[Pr]);
               end;
             SetTextJustify(LeftText, TopText);
             SetColor(246);
             if EB = 3
               then OutTextXY(62, 62, FileName);
             if EB = 6
               then OutTextXY(62, 92, PDirName + '\');
             SetColor(0);
             OutTextXY(60, 60, FileName);
             OutTextXY(60, 90, PDirName + '\');
             MMShow;
           end;
    Pr := EB;
  until ( MouseButton <> 100 );
  MMHide;
  if Pr in [1..10] then
    begin
      Contour(Contours[Pr][1, 1], Contours[Pr][1, 2],
              Contours[Pr][2, 1], Contours[Pr][2, 2]);
      SetColor(Colors[Pr]);
      SetTextJustify(CenterText, CenterText);
      OutTextXY(Contours[Pr][1, 1] + ( Contours[Pr][2, 1]
                - Contours[Pr][1, 1] ) div 2,
                Contours[Pr][1, 2] + ( Contours[Pr][2, 2]
                - Contours[Pr][1, 2] ) div 2 - 2,
      Labels[Pr]);
    end;
  MMShow;
  PressingButton := EB;
end{ProgramProcedures.FilesOk.PressingButton};

{ Przy zapisie trzeba pobraç nazwë pliku }
procedure ReadName;
var Ch: Char;
    Poz: Byte;
label ReadExit;
begin
  SetTextJustify(LeftText, TopText);
  SetFillStyle(1, 243);
  Poz := Succ(Length(FileName));
  repeat
    MMHide;
    Graph.Bar(56, 61, 147, 79);
    SetColor(246);
    OutTextXY(62, 62, FileName);
    SetColor(0);
    OutTextXY(60, 60, FileName);
    SetColor(8);
    OutTextXY(50 + 10 * Poz, 62, '_');
    MMShow;
    repeat
      if MouseButton <> 000
        then goto ReadExit;
    until KeyPressed;
    Ch := ReadKey;
    case Ch of
      #0: case ReadKey of
            #75: if Poz > 1
                   then Dec(Poz);
            #77: if Poz < Succ(Length(FileName))
                   then Inc(Poz);
            #83: IF FileName <> ''
                   then Delete(FileName, Poz, 1);
            #71: Poz := 1;
            #79: Poz := Succ(Length(FileName));
          end;
      #8: if Poz > 1
            then begin
                   Delete(FileName, Poz - 1, 1);
                   Dec(Poz);
                 end;
      'a'..'z', 'A'..'Z', '0'..'9':
        if Length(FileName) < 8
          then begin
                 Insert(UpCase(Ch), FileName, Poz);
                 Inc(Poz);
               end;
    end;
  until ( Ch = #13 );
  ReadExit:
end{ProgramProcedures.FilesOk.ReadName};

{ Przy zapisie trzeba pobraç nazwë katalogu }
procedure ReadDir;
var Ch: Char;
label ReadExit;
begin
  SetTextJustify(LeftText, TopText);
  if Length(DirName) < 255
    then DirName := DirName + '\';
  SetFillStyle(1, 243);
  repeat
    MMHide;
    Graph.Bar(56, 91, 264, 109);
    SetColor(246);
    OutTextXY(62, 92, Copy(DirName, Length(DirName) - 18, 19));
    SetColor(0);
    OutTextXY(60, 90, Copy(DirName, Length(DirName) - 18, 19));
    SetColor(8);
    OutTextXY(60 + TextWidth(Copy(DirName, Length(DirName) - 18, 19)), 92, '_');
    MMShow;
    repeat
      if MouseButton <> 000
        then goto ReadExit;
    until KeyPressed;
    Ch := ReadKey;
    case Ch of
      #0: ReadKey;
      #8: if Length(DirName) > 3
            then Delete(DirName, Length(DirName), 1);
      'a'..'z', 'A'..'Z', ':', '\', '0'..'9':
         if Length(DirName) < 254
           then DirName := DirName + UpCase(Ch);
    end;
  until ( Ch = #13 );
  ReadExit:
  if ( DirName[Length(DirName)] = '\' ) and ( Length(DirName) > 3 )
    then Delete(DirName, Length(DirName), 1);
end{ProgramProcedures.FilesOk.ReadDir};

var First, Changed, TestButton: Boolean;

label Back;
begin
  ProcInit;
  Vga256.DownPalette256;
  SetMouseX(45, 275);
  SetMouseY(20, 150);
  SetTextStyle(SmallFont, HorizDir, 6);
  SetTextJustify(CenterText, CenterText);
  MMHide;
  for X := 1 to 10 do
    begin
      Contour(Contours[X][1, 1], Contours[X][1, 2],
              Contours[X][2, 1], Contours[X][2, 2]);
      SetColor(Colors[X]);
      OutTextXY(Contours[X][1, 1] + ( Contours[X][2, 1]
                - Contours[X][1, 1] ) div 2,
                Contours[X][1, 2] + ( Contours[X][2, 2]
                - Contours[X][1, 2] ) div 2 - 2,
      Labels[X]);
    end;
  SetColor(0);
  OutTextXY(170, 68, '.' + Extension);
  MMShow;
  Vga256.UpPalette256(MenuPalette);
  First := True;
  Changed := True;
  Button := 3;
  TestButton := False;
  Back:
  repeat
    if Pos('.' + Extension, FileName) > 0
      then Delete(FileName, Length(FileName) - 3, 4);
    if DirName[Length(DirName)] = '\'
      then Delete(DirName, Length(DirName), 1);
    SetTextJustify(LeftText, TopText);
    PDirName := Copy(DirName, Length(DirName) - 18, 19);
    if Changed
      then begin
             MMHide;
             Graph.Bar(56, 61, 147, 79);
             Graph.Bar(56, 91, 264, 109);
             SetColor(0);
             OutTextXY(60, 60, FileName);
             OutTextXY(60, 90, PDirName + '\');
             MMShow;
           end;
    if TestButton
      then Button := PressingButton;
    ODirName := DirName;
    case Button of
      2: begin
           FileName := StandardName;
           DirName := StandardDir;
         end;
      3: begin
           if not Load
             then ReadName
             else begin
                    if First
                      then FindFirst('*.' + Extension, $20, SR)
                      else FindNext(SR);
                    First := ( DosError <> 0 );
                    if ( DosError = 0 ) and
                       ( ( ( SR.Size = 768 ) and
                       ( Extension = 'PAL' ) ) or
                       ( ( SR.Size = 65078 ) and
                       ( Extension = 'BMP' ) ) or
                       ( Extension = 'PAT' ) ) and
                       ( SR.Name <> '$CLIP$.BMP' )
                      then FileName := SR.Name
                      else FileName := '';
                  end;
         end;
      6: ReadDir;
      7..10: GetDir(Button - 6, DirName);
    end;
    {$I-}
    ChDir(DirName);
    if IOResult <> 0
      then DirName := ODirName;
    {$I+}
    ChDir(DirName);
    TestButton := ( DirName = ODirName );
    First := First or ( Button in [6..10] );
    if not TestButton
      then Button := 3;
    Changed := Button in [2..10];
  until ( Button in [4, 5] );
  if ( Button = 4 ) and
     ( ( FileName = '' ) or ( Load and ( FileName = '' ) ) )
    then goto Back;
  FilesOk := ( Button = 4 );
  ProcDone;
  SetMouseX(0, 320);
  SetMouseY(0, 200);
end{ProgramProcedures.FilesOk};

{ BíÜd obsíugi dysk¢w }
procedure ErrorMessage(Error: Word);
var ErrMsg: string;
begin
  if Error = 0
    then Exit;
  MMHide;
  Contour(50, 60, 270, 122);
  SetColor(8);
  SetTextStyle(SmallFont, HorizDir, 6);
  SetTextJustify(CenterText, CenterText);
  OutTextXY(160, 80, 'AWARIA !!!');
  ErrMsg := Str(Error);
  OutTextXY(160, 100, 'Error : ' + ErrMsg);
  MMShow;
  while MouseButton <> 100 do;
end{ProgramProcedures.ErrorMessage};

{ Wzorek wypeíniania }

procedure SavePattern(var Error: Integer);
var F: file of FillPatternType;
begin
  {$I-}
  Assign(F, FileName + '.pat');
  Rewrite(F);
  Write(F, Pattern);
  Close(F);
  Error := IOResult;
  {$I+}
end{ProgramProcedures.SavePattern};

procedure LoadPattern(var Error: Integer);
var F: file of FillPatternType;
begin
  {$I-}
  Assign(F, FileName + '.pat');
  Reset(F);
  Read(F, Pattern);
  Close(F);
  Error := IOResult;
  {$I+}
end{ProgramProcedures.LoadPattern};

function CreatePattern: Boolean;

const Menus: array[0..3] of array[1..2, 1..2] of Word =
        ( ( ( 200, 4 ), ( 314, 194 ) ), ( ( 210, 15 ), ( 304, 70 ) ),
          ( ( 210, 80 ), ( 305, 130 ) ), ( ( 210, 140 ), ( 305, 190 ) ) );

      Texts: array[0..3] of string[10] = ( '', '', 'OK', 'ANULUJ');

      Colors: array [0..3] of Byte = ( 9, 255, 243, 243);

      TextColors: array[0..3] of Byte = ( 0, 0, 3, 2 );

      P: array[1..8] of Byte = (128, 64, 32, 16, 8, 4, 2, 1 );

var OldPattern: FillPatternType;

procedure Contour(X1, Y1, X2, Y2: Integer; Color: Byte);

procedure ReplaceInteger(var L1, L2: Integer);
var L: Integer;
begin
  L := L1;
  L1 := L2;
  L2 := L;
end{ProgramProcedures.CreatePattern.Contour.ReplaceInteger};

begin
  SetColor(235);
  Line(X1, Y1, X2, Y1);
  Line(X1, Y1, X1, Y2);
  SetColor(249);
  Line(X2, Y1, X2, Y2);
  Line(X1, Y2, X2, Y2);
  if X1 > X2
    then ReplaceInteger(X1, X2);
  if Y1 > Y2
    then ReplaceInteger(Y1, Y2);
  SetFillStyle(1, Color);
  if Color <> 255
    then Graph.Bar(X1 + 1, Y1 + 1, X2 - 1, Y2 - 1);
end{ProgramProcedures.CreatePattern.Contour};

procedure DrawPatternMenu;
var A, B, C: Byte;
begin
  if MouseX < 200
    then MMHide;
  for A := 0 to 7 do
  for B := 0 to 7 do
    begin
      Contour(B * 24 + 4, A * 24 + 4, B * 24 + 26, A * 24 + 26,
              Byte(Pattern[Succ(A)] and P[Succ(B)] > 0 ) * -228 + 243);
    end;
  MMShow;
end{ProgramProcedures.CreatePattern.DrawPatternMenu};

procedure DrawFillBar;
begin
  SetFillPattern(Pattern, 14);
  if ( MouseX > 200 ) and ( Mousey < Menus[1][2][2] )
    then MMHide;
  Graph.Bar(Menus[1][1][1] + 1, Menus[1][1][2] + 1,
            Menus[1][2][1] - 1, Menus[1][2][2] - 1);
  MMShow;
end{ProgramProcedures.CreatePattern.DrawFillBar};

procedure RunCreate;
var A, X, Y, C, OX, OY: Byte;
    Size: Word;
begin
  OX := 20;
  SetMouseX(5, 194);
  SetMouseY(5, 194);
  repeat
    X := ( MouseX - 2 ) div 24;
    Y := ( MouseY - 2 ) div 24;
    if ( ( OX <> X ) or ( OY <> Y ) ) and ( X in [0..7] ) and ( Y in [0..7] )
      then begin
             MMHide;
             Contour(OX * 24 + 4, OY * 24 + 4, OX * 24 + 26, OY * 24 + 26, 255);
             Contour(X * 24 + 26, Y * 24 + 26, X * 24 + 4, Y * 24 + 4, 255);
             MMShow;
             OX := X;
             OY := Y;
           end;
  until MouseButton = 000;
  if ( X in [0..7] ) and ( Y in [0..7] )
    then begin
           MMHide;
           Contour(OX * 24 + 4, OY * 24 + 4, OX * 24 + 26, OY * 24 + 26, 255);
           if ( Pattern[Succ(Y)] and P[Succ(X)] = P[Succ(X)] )
              then Pattern[Succ(Y)] := Pattern[Succ(Y)] - P[Succ(X)]
              else Pattern[Succ(Y)] := Pattern[Succ(Y)] + P[Succ(X)];
           Contour(OX * 24 + 4, OY * 24 + 4, OX * 24 + 26, OY * 24 + 26,
                   Byte(Pattern[Succ(OY)] and P[Succ(OX)] > 0 ) * -228 + 243);
           MMShow;
           DrawFillBar;
         end;
  SetMouseX(0, 320);
  SetMouseY(0, 200);
end{ProgramProcedures.CreatePattern.RunCreate};

procedure Run(var Ok: Boolean);

var EndCreate: Boolean;
    A: Byte;

procedure Browse;
var A, B, OB: Byte;
    X, Y: Word;
begin
  A := 0;
  OB := 10;
  repeat
    X := MouseX;
    Y := MouseY;
    B := 0;
    for A := 1 to 3 do
      if ( X > Menus[A][1][1] ) and ( X < Menus[A][2][1] ) and
         ( Y > Menus[A][1][2] ) and ( Y < Menus[A][2][2] )
        then B := A;
    if ( B in [1..3] ) and ( OB <> B )
      then begin
             MMHide;
             Contour(Menus[B][2][1], Menus[B][2][2],
                     Menus[B][1][1], Menus[B][1][2], Colors[B]);
             SetColor(247);
             OutTextXY( ( Menus[B][1][1] + Menus[B][2][1] ) div 2 + 2,
                        ( Menus[B][1][2] + Menus[B][2][2] ) div 2,
                        Texts[B] );
             SetColor(TextColors[B]);
             OutTextXY( ( Menus[B][1][1] + Menus[B][2][1] ) div 2,
                        ( Menus[B][1][2] + Menus[B][2][2] ) div 2 - 2,
                        Texts[B] );
             if B = 1
               then DrawFillBar;
             MMShow;
           end;
    if ( OB <> B )
      then begin
             MMHide;
             if OB in [1..3] then
               begin
                 Contour(Menus[OB][1][1], Menus[OB][1][2],
                         Menus[OB][2][1], Menus[OB][2][2], Colors[OB]);
                 SetColor(TextColors[OB]);
                 OutTextXY( ( Menus[OB][1][1] + Menus[OB][2][1] ) div 2,
                            ( Menus[OB][1][2] + Menus[OB][2][2] ) div 2 - 2,
                            Texts[OB] );
                 if OB = 1
                   then DrawFillBar;
                 OB := B;
                 MMShow;
               end;
           end;
  until MouseButton = 000;
  if ( B in [1..3] )
    then begin
           MMHide;
           Contour(Menus[B][1][1], Menus[B][1][2],
                   Menus[B][2][1], Menus[B][2][2], Colors[B]);
           SetColor(TextColors[B]);
           OutTextXY( ( Menus[B][1][1] + Menus[B][2][1] ) div 2,
                      ( Menus[B][1][2] + Menus[B][2][2] ) div 2 - 2,
                      Texts[B] );
           MMShow;
         end;
  case B of
    1: begin
         Pattern := OldPattern;
         DrawPatternMenu;
       end;
    2: begin
         EndCreate := True;
         Ok := True;
       end;
    3: begin
         EndCreate := True;
         Ok := False;
       end;
  end;
  DrawFillBar;
end{ProgramProcedures.CreatePattern.Run.Browse};

begin
  EndCreate := False;
  Vga256.DownPalette256;
  MMHide;
  for A := 0 to 3 do
    begin
      Contour(Menus[A][1][1], Menus[A][1][2],
              Menus[A][2][1], Menus[A][2][2], Colors[A]);
      SetColor(TextColors[A]);
      OutTextXY( ( Menus[A][2][1] + Menus[A][1][1] ) div 2,
                 ( Menus[A][2][2] + Menus[A][1][2] ) div 2 - 2,
                 Texts[A] );
    end;
  DrawPatternMenu;
  DrawFillBar;
  MMShow;
  Vga256.UpPalette256(MenuPalette);
  repeat
    if MouseButton = 100
      then if MouseX < 200
             then RunCreate
             else Browse;
  until EndCreate;
end{ProgramProcedures.CreatePattern.Run};

var Ok: Boolean;

begin
  OldPattern := Pattern;
  SetTextStyle(SmallFont, HorizDir, 5);
  SetTextJustify(CenterText, CenterText);
  Run(Ok);
  if not Ok
    then Pattern := OldPattern;
  CreatePattern := Ok;
end{ProgramProcedures.CreatePattern};

{*******************}

var Error: Integer;
    OldPattern: FillPatternType;
    MI: PIntro;

label Back;
begin
  ProcInit;
  Back:
  Error := 0;
  case Nr of
    1: if FilesOk('PAL', False)
         then Picture^.SavePalette(Error);
    3: if CreatePattern
         then if FilesOk('PAT', False)
                then SavePattern(Error);
    5: if FilesOk('BMP', False)
         then Picture^.SaveImage(Error);
    2: if FilesOk('PAL', True)
         then Picture^.LoadPalette(Error);
    4: if FilesOk('PAT', True)
         then LoadPattern(Error);
    6: if FilesOk('BMP', True)
         then Picture^.LoadImage(Error);
    7: begin
         ScrSaver := False;
         New(MI, Init);
         MI^.Run;
         Dispose(MI, Done);
         ScrSaver := True;
       end;
    8: EndProgram := True;
  end;
  SetMouseX(0, 320);
  SetMouseY(0, 200);
  if Error <> 0
    then begin
           ErrorMessage(Error);
           goto Back;
         end;
  ProcDone;
end{ProgramProcedures};

{***************************************************************************}

{ Przekazanie starowania do odpowiedniej procedury }
procedure Execute;
begin
  SetColor(Color);
  SetFillStyle(1, FColor);
  if Gr <> 2
    then Picture := PPicture;
  case Gr of
    1: Figure(Nr);
    2: FigureSettings(Nr);
    3: Images(Nr);
    4: ProgramProcedures(Nr);
  end;
end{Execute};

end{MainProc}.