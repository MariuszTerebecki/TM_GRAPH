{********************************************}
{*                                          *}
{*  Modu’ wyžwietlaj†cy informacje wstepne  *}
{*      o programie ( tutaj TMGraph )       *}
{*                                          *}
{*      (c) 1994  Terebecki Mariusz         *}
{*                                          *}
{********************************************}

unit Intro;

interface

{ ***** Wykorzystywane modu’y ***** }

uses Crt, Graph, { Modu’y standardowe i moje:               }
     VGA256,     { - inicjuj†cy i zamykaj†cy tryb graficzny }
     MMouse,     { - obs’uguj†cy myszk‘                     }
     Exploder;   { - oraz pakuj†cy ( obrazek z intro )      }

{ ***** Wykorzystywane typy ***** }

{ Z tych typ¢w mo§na korzysta na zewn†trz }
type PToPack = ^TToPack;
     TToPack = record
                 DLen: Word;
                 Data: array[1..32767] of Byte;
               end;

     PPack = ^TPack;
     TPack = record
               PLen: Word;
               DLen: Word;
               Data: array[1..15000] of Byte;
             end;

{ Intro jest jednym obiektem }
     PIntro = ^TIntro;
     TIntro = object
                constructor Init;
                destructor Done;
                procedure Run;
                private
                SPal: APalette256;
                P: PPack;
                TP: PToPack;
                IntroText: Text;
              end{TIntro};

implementation

{ Rysunek wyžwietlany i jego paleta kolor¢w }
var
  MB: Boolean;

{ Inicjacja intra }
constructor TIntro.Init;
var IntroFile: file;
    A, B: Byte;
    Index: Word;
begin
  MMShow; MMHide;
  New(P);
  New(TP);
  Assign(IntroFile, 'INTRO.CGF');
  Reset(IntroFile, 1);
  FillChar(SPal, 768, 0);
  SetPalette(SPal);
  Seek(IntroFile, 26);
  for A := 1 to 2 do
    begin
      BlockRead(IntroFile, P^, 4);
      BlockRead(IntroFile, TPack(P^).Data, TPack(P^).PLen);
      Explode(P, TP);
      case A of
        1: Index := 1;
        2: Index := 32768;
      end;
     
      Move(TP^.Data, Ptr(SegA000, Pred(Index))^, TP^.DLen);
    end;
  Move(Mem[SegA000:50880], SPal, 768);
{  SetPalette256(Mem[SegA000:50880], 0, 256);}
  SetFillStyle(0, 0);
  Bar(0, 159, 319, 199);
  UpPalette256(SPal);
  Close(IntroFile);
  Assign(IntroText, 'intro.txt');
  Reset(IntroText);
  Dispose(P);
  Dispose(TP);
end{TIntro.Init};

{ Koniec intra }
destructor TIntro.Done;
var
  A: Byte;
  Index: Word;
begin
  Close(IntroText);
  SetFillStyle(0, 0);
  Bar(0, 160, 319, 199);
  DownPalette256;
  MonitorOff;
  MMHide;
  ClearDevice;
  MMShow;
  MonitorOn;
end{TIntro.Done};

{ Wykonanie intra }
procedure TIntro.Run;
var X, Y: ShortInt;
    Txt: string;
    Color: Byte;

function Bit(Nr: Byte): Byte;
begin
  Bit := Color shr (Nr - 1) mod 2;
end{TIntro.Run.Bit};

begin
  MMShow; MMHide;
  while KeyPressed do ReadKey;
  SetTextStyle(BigFont, HorizDir, 1);
  SetTextJustify(CenterText, CenterText);
  SetRGBPalette(1, 0, 0, 0);
  SetColor(1);
  SetFillStyle(0, 0);
  MMShow;
  MB := False;
  repeat
    ReadLn(IntroText, Color, Txt);
    if MouseY > 140 then
    MMHide;
    Bar(0, 160, 319, 199);
    OutTextXY(160, 172, Txt);
    MMShow;
    for X := -63 to 63 do
      begin
        Y := 63 - Abs(X);
        SetRGBPalette(1, Bit(1) * Y, Bit(2) * Y, Bit(3) * Y);
        Delay(10 + Byte(X = 0) * 3000);
        MB := MB or ( MouseButton <> 000 ) or KeyPressed;
      end;
  until MB or EoF(IntroText);
  while KeyPressed do ReadKey;
end{TIntro.Run};

end{Intro}.