{********************************************}
{*                                          *}
{*   Program graficzny TMGraph wersja 1.0   *}
{*              praca na WKI                *}
{*                                          *}
{*       (c) 1994  Terebecki Mariusz        *}
{*                                          *}
{********************************************}

program TMGraph;

{ Wykorzystywane moduíy }

uses
  Intro,           { Intro na poczÜtku programu                   }
  Graph, Dos, Crt, { Moduíy standardowe                           }
  VGA256,          { Inicjacja i zamykniëcie grafiki              }
  BMP,             { Operacje na plikach graficznych BitMaP       }
  MMouse,          { Obsíuga myszy                                }
  MainProcedures,  { Wszystkie wykonywane przez program procedury }
  Help,            { Pomoce do programu,                          }
  HelpContext,     { - pomoce kontekstowe do programu,            }
  Exploder;        { - oraz rozpakowujÜcy ( menu )                }

  { Typy : }

{ Menu gí¢wne programu jest obrazkiem }
type
  PMenuImage = ^TMenuImage;
  TMenuImage = array[1..64000] of Byte;

{ Wíasciwy program }
  PProgram = ^TProgram;
  TProgram = object(TVGA)
    { Tylko konstruktor, destruktor i metoda sterujÜca }
    { obiektu mogÜ byç wywoíywane z zewnÜtrz           }
    constructor Init;
    destructor Done;
    procedure Run;
    { Dostep do reszty jest zarezerwowany dla ww metod }
    private
    P: PPack;
    TP: PToPack;
    Menu: PMenuImage;
    Image: PBMP;        { Wskaznik do obrabianego obrazka   }
    NumberOfFile: Byte; { Numer sprawdzanego pliku }
    procedure ShowMenu(Clear: Boolean);
    procedure TMProcedure(MMX, MMY: Word);
    procedure TMHelp(MMX, MMY: Word);
  end;

var
  FirstDir: string;
  AllOk, ParametersOk, MouseOk, SMen, PomocKont,
  IntroJest: Boolean;
  LC: Word;
  NumberOfBadParameter: Byte;

{ Proste wyûwietlenie komunikatu o bíëdzie }
procedure ErrorMessage(T: string);
begin
  WriteLn(T, ' !!!'#7#13#10#13#10, 'Program przerwano ...');
  AllOk := False;
end{ErrorMessage};

{ Konstruktor gí¢wnego obiektu inicjujÜcy grafikë, oraz  }
{ wykorzystywane zmienne, po wykryciu jakiegokolwiek     }
{ bíëdu inicjacja zostanie przerwana                     }
constructor TProgram.Init;
var MenuFile: file;
    PatternFile: file of FillPatternType;
    I: PIntro;
    MType: Boolean;
    A, R: Byte;
    SX: NameStr;
    SY: ExtStr;
    SZ: DirStr;
    L: LongInt;
    Index: Word;
begin
  ScrSaver := True;
  GetDir(0, FirstDir);
  FSplit(ParamStr(0), SZ, SX, SY);
  DirName := SZ;
  StandardName := 'START';
  Delete(DirName, Length(DirName), 1);
  ChDir(DirName);
  StandardDir := DirName;
  PomocKont := False;
  IntroJest := True;
  ParametersOk := True;
  for A := 1 to ParamCount do
    begin
      if ( ParamStr(A) = '-p' ) or ( ParamStr(A) = '-P' )
        then PomocKont := True else
      if ( ParamStr(A) = '-i' ) or ( ParamStr(A) = '-I' )
        then IntroJest := False else
        begin
          NumberOfBadParameter := A;
          ParametersOk := False;
          Exit;
        end;
    end;
  MouseOk := MMIsInstall(MType) and MType;
  if not MouseOk then Exit;
  inherited Init;
  if IntroJest then
    begin
      New(I, Init);
      I^.Run;
      Dispose(I, Done);
    end;
  New(P);
  New(TP);
  New(Menu);
  Assign(MenuFile, 'MENU.CGF');
  Reset(MenuFile, 1);
  BlockRead(MenuFile, P^, 26);
  for A := 1 to 2 do
    begin
      BlockRead(MenuFile, P^, 4);
      BlockRead(MenuFile, P^.Data, P^.PLen);
      Explode(P, TP);
      case A of
        1: Move(TP^.Data, Menu^, TP^.DLen);
        2: Move(TP^.Data, Menu^[32768], TP^.DLen - 768);
      end;
    end;
  Move(TP^.Data[TP^.DLen-767], MenuPalette, 768);
  Close(MenuFile);
  Assign(PatternFile, 'TM.PAT');
  Reset(PatternFile);
  Read(PatternFile, Pattern);
  Close(PatternFile);
  Dispose(TP);
  Dispose(P);
  New(Image, Init('START'));
  Color := 15;
  FColor := 14;
  MinColor := 32;
  MaxColor := 191;
  MinFColor := 32;
  MaxFColor := 191;
end{TProgram.Init};

{ Destruktor gí¢wnego obiektu ko§czÜcy pracë programu }
destructor TProgram.Done;
var F: Text;
label Koniec;
begin
  if not ParametersOk then
    begin
      ErrorMessage('Bíëdny parametr wywoíania : ' +
                   ParamStr(NumberOfBadParameter));
      goto Koniec;
    end;
  if not MouseOk then
    begin
      ErrorMessage('MYSZ NIE ZAINSTALOWANA LUB ZúY TYP MYSZY');
      goto Koniec;
    end;
  ChDir(StandardDir);
  if AllOk then begin
                  DownPalette256;
                  MMHide;
                  if FSearch('$CLIP$.BMP', '') <> '' then
                    begin
                      Assign(F, '$CLIP$.BMP');
                      Erase(F);
                    end;
                  Dispose(Image, Done(False));
                  Dispose(Menu);
                  inherited Done;
                  WriteLn('Do widzenia...');
                  while KeyPressed do ReadKey;
               end;
  ChDir(FirstDir);
  Koniec:
end{TProgram.Done};

{ Ramka na okoío klawisza }
procedure Frame(X1, Y1, X2, Y2: Word);
var OldColor: Byte;
begin
  SMen := False;
  OldColor := GetColor;
  SetColor(249);
  Line(X2, Y1, X2, Y2);
  Line(X1, Y2, X2, Y2);
  SetColor(236);
  Line(X1, Y1, X1, Y2);
  Line(X1, Y1, X2, Y1);
  SetColor(OldColor);
  SMen := True;
end{Frame};

{ Zmienna pomocnicza }
var Ic: array[1..3000] of Byte;

{ Wyûwietlenie menu gí¢wnego programu }
procedure TProgram.ShowMenu;
var
  A, B, C, Index: Word;
begin
  SMen := False;
  SetMouseX(0, 319);
  SetMouseY(41, 199);
  if Clear
    then Vga256.DownPalette256;
  MMHide;
  if Clear
    then ClearDevice;
  Move(Menu^[1], Mem[$0a000:00], 25600);
  Move(Menu^[38401], Mem[$0a000:38400], 25600);
  C := GetColor;
  SetColor(1);
  for A := 1 to 8 do
    if FSettings[A]
      then begin
             Frame(A * 40 - 1, 119, Pred(A) * 40 + 1, 81);
             SMen := False;
             SetColor(243);
             Line(Pred(A) * 40 + 2, 82, Pred(A) * 40 + 2, 118);
             Line(Pred(A) * 40 + 2, 82, A * 40 - 2, 82);
             for B := 1 to 36 do
               Move(Menu^[(81 + B) * 320 + Pred(A) * 40 + 3],
                    Mem[$0a000:(82 + B) * 320 + Pred(A) * 40 + 3], 36);
           end
      else begin
             Frame(Pred(A) * 40 + 1, 81, A * 40 - 1, 119);
             SMen := False;
             for B := 1 to 38 do
               begin
                 asm
			MOV	AX,	B
			ADD	AX,	81
			MOV	BX,	320
			MUL	BX
			MOV	Index,	AX
			MOV	AX,	40
			MOV	BX,	A
			DEC	BX
			MUL	BX
			ADD	AX,	3
			ADD	Index,	AX
                 end;
                 Move(Menu^[Index], Mem[SegA000:Pred(Index)], 37);
               end;
           end;
  SetColor(C);
  SetMouseX(1, 320);
  MMShow;
  if PomocKont then
  ShowHelpContext(MouseY div 40, MouseX div 40 + 1);
  if Clear
    then UpPalette256(MenuPalette);
  SMen := True;
end{TProgram.ShowMenu};

{ Przekazanie sterowania do wybranej przez ußytkownika procedury }
procedure TProgram.TMProcedure;
var Zest, Nr: Byte;
begin
  SMen := False;
  Zest := ( MMY div 40 );
  Nr := ( MMX div 40 + 1 );
  Execute(Zest, Nr, Image);
  while MouseButton <> 000 do;
  SMen := True;
end{TProgram.TMProcedure};

{ Pomoc do wybranej przez ußytkownika procedury }
procedure TProgram.TMHelp;
var Zest, Nr: Byte;
begin
  SMen := False;
  Zest := ( MMY div 40 );
  Nr := ( MMX div 40 + 1 );
  MMHide;
  Vga256.DownPalette256;
  ShowHelp(Zest, Nr);
  MMShow;
  while MouseButton <> 000 do;
  SMen := True;
end{TProgram.TMHelp};

{ Sterowanie przebiegiem programu }
procedure TProgram.Run;
const D: array[1..4, 1..2] of ShortInt =
        ( ( 2, -1 ), ( 1, -1 ), ( 1, -1 ), ( 1, -2 ) );
var X, MMX, MMY: Word;
    MX, MY, OX, OY, MB: Byte;
    Hlp: Boolean;
label 1;
begin
  AllOk := ParametersOk and MouseOk;
  if not AllOk then Exit;
  SetMouseX(0, 319);
  SetMouseY(0, 199);
  EndProgram := False;
  OY := 1; OX := 0;
  repeat
    ShowMenu( ( ( Pred(OY) * 8 + Succ(OX) ) in [1..7, 19..23, 24..32] ) or
              Hlp or ( ( Pred(OY) * 8 + Succ(OX) = 8 ) and TxtB ) );
    Hlp := False;
    OX := 10;
    1:
    MX := 10;
    repeat
      MB := MouseButton;
    until MB <> 000;
    repeat
      MMX := MouseX;
      MMY := MouseY;
      MX := MMX div 40;
      MY := MMY div 40;
      if ( ( OX <> MX ) or ( OY <> MY ) ) and
         ( ( MX in [0..7] ) and ( MY in [0..4] ) )
        then begin
               MMHide;
               if (OY in [1..4]) and (OX in [0..7]) and ( ( OY <> 2 ) or (not FSettings[OX + 1] ) )
                 then begin
                        PutImage(OX * 40 + 2, OY * 40 + 3, Ic, NormalPut);
                        Frame(OX * 40 + 1, OY * 40 + D[OY, 1],
                              ( OX + 1 ) * 40 - 1, ( OY + 1 ) * 40 + D[OY, 2]);
                      end;
               GetImage(MX * 40 + 2, MY * 40 + 3, MX * 40 + 37, MY * 40 + 37, Ic);
               if ( ( MY <> 2 ) or not FSettings[MX + 1] ) and ( MY > 0 )
                 then begin
                        PutImage(MX * 40 + 3, MY * 40 + 4, Ic, NormalPut);
                        Frame((MX + 1 ) * 40 - 1, ( MY + 1 ) * 40 + D[MY, 2],
                              MX * 40 + 1, MY * 40 + D[MY, 1]);
                      end;
               MMShow;
               OX := MX;
               OY := MY;
             end;
    until MouseButton = 000;
    if MY in [1, 3, 4]
      then begin
             MMHide;
             PutImage(MX * 40 + 2, MY * 40 + 3, Ic, NormalPut);
             Frame(MX * 40 + 1, MY * 40 + D[MY, 1],
                   ( MX + 1 ) * 40 - 1, ( MY + 1 ) * 40 + D[MY, 2]);
             MMShow;
             Delay(100);
           end;
    case MB of
      100: TMProcedure(MMX, MMY);
      001: begin
             TMHelp(MMX, MMY);
             Hlp := True;
           end;
    end;
  until EndProgram;
end{TProgram.Run};

{$F+}

procedure Beep; interrupt;
var A, B: Byte;
begin
  for A := 7 downto 0 do
  for B := A downto 0 do
    begin
      Sound(B * 1000);
      Delay(10);
      NoSound;
    end;
end{Beep};

{ Zmienne pomocnicze }
var CMX, CMY, COMX, COMY: Integer;
    CX, CY: Integer;
    Mon, MMon: Boolean;

procedure NC; interrupt;
label Wyjscie, Dalej;
begin
  if not ScrSaver
    then goto Dalej;
  Mon := ( ( CX <> MouseX ) or ( CY <> MouseY ) );
  if Mon and not MMon
    then begin
           MonitorOn;
           MMon := True;
           LC := 0;
         end
    else begin
           if LC < 500
             then LC := LC + 1
             else LC := 0;
           if LC = 0
             then MonitorOff;
           MMon := False;
         end;
  CX := MouseX;
  CY := MouseY;
  Dalej:
  if not PomocKont
    then goto Wyjscie;
  CMX := MouseX div 40;
  CMY := MouseY div 40;
  if ( COMX <> CMX ) or ( COMY <> CMY )
    then if SMen
           then ShowHelpContext(CMY, CMX + 1);
  COMX := CMX;
  COMY := CMY;
  Wyjscie:
end{NC};

{$F-}

const R: Byte = 226;

{ Pamiëç programowi przydzielam dynamicznie }
var MYProgram: PProgram;

  OV1ch, OV05h: Pointer;

  L: LongInt;

{ Pëtla gí¢wna programu }
begin
  AllOk := True;
  LC := 0;
  CheckBreak := False;
  if AllOk
    then begin
           New(MYProgram, Init);
           if ParametersOk and MouseOk
             then begin
                    GetIntVec($1c, OV1ch);
                    SetIntVec($1c, Addr(NC));
                    GetIntVec($05, OV05h);
                    SetIntVec($05, Addr(Beep));
                    SetRGBPalette(1, 0, 0, 0);
                    Smen := True;
                  end;
           MYProgram^.Run;
           if ParametersOk and MouseOk
             then begin
                    SMen := False;
                    SetIntVec($1c, OV1ch);
                  end;
           Dispose(MYProgram, Done);
         end;
  asm
	MOV	AX,	0C00H
	INT	21H
  end;
end{TMGraph}.