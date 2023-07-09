{********************************************}
{*                                          *}
{*   Moduí zawierajÜcy pomoce do programu   *}
{*               TM Graph 1.0               *}
{*                                          *}
{*      (c) 1994  Terebecki Mariusz         *}
{*                                          *}
{********************************************}
unit Help;

interface

{ ***** Wykorzystywane moduíy ***** }

uses Crt,
     MainProcedures;

{ ***** Wykorzystywane staíe ***** }

{ Staía okreûlajÜca nazwë pliku z tekstami pomocy }
const HelpFileName: string = 'TMGRAPH.HLP';

{ ***** Wykorzystywane procedury ***** }

{ Tylko jedna procedura jest wywoíywana z zewnÜtrz }
procedure ShowHelp(Group, Number: Byte);

implementation

{ Wykorzystywane moduíy }

uses Graph,  { Standardowy                           }
     Vga256, { Wíasny obsíugujÜcy tryb graficzny ... }
     MMouse; { ... oraz mysz                         }

{ Zmienna tablicowa pomocnicza }

var Helps: array[1..16] of string[55];

{ Wczytanie tekstu pomocy }
function LoadHelp(Group, Number: Byte): Boolean;
var HelpFile: Text;
    A, B: Word;
begin
  {$I-}
  Assign(HelpFile, StandardDir + '\' + HelpFileName);
  Reset(HelpFile);
  for A := 1 to Pred(Group) * 8 + Pred(Number) do
    for B := 1 to 16 do ReadLn(HelpFile);
  for A := 1 to 16 do
    ReadLn(HelpFile, Helps[A]);
  Close(HelpFile);
  LoadHelp := ( IOResult = 0 );
  {$I+}
end{LoadHelp};

{ Wyûwietlenie tekstu pomocy }
procedure WriteHelp;
var Nu: Byte;
begin
  SetTextStyle(BigFont, HorizDir, 1);
  SetTextJustify(CenterText, CenterText);
  SetColor(2);
  OutTextXY(160, 15, Helps[1]);
  SetTextStyle(SmallFont, HorizDir, 4);
  SetTextJustify(LeftText, CenterText);
  SetColor(1);
  for Nu := 2 to 20 do
    OutTextXY(0, Nu * 10 + 25, Helps[Nu]);
end{WriteHelp};

{ Wyûwietlenie komunikatu o bíëdzie }
procedure WriteError;
begin
  SetColor(6);
  SetTextStyle(BigFont, HorizDir, 2);
  SetTextJustify(CenterText, CenterText);
  OutTextXY(160, 100, 'Error in help file !!!');
end{WriteError};

{ Wíaûciwa procedura wyûwietlajÜca pomoc }
{ do wybranej przez ußytkownika opcji    }
procedure ShowHelp;

{ Procedurka pomocnicza }
procedure Contour(X1, Y1, X2, Y2: Integer);
begin
  SetColor(235);
  Line(X1, Y1, X2, Y1);
  Line(X1, Y1, X1, Y2);
  SetColor(245);
  Line(X1, Y2, X2, Y2);
  Line(X2, Y2, X2, Y1);
end{ShowHelp.Contour};

{ Ustawienia graficzne nie mogÜ byç zmienione po  }
{ wyûwietleniu helpu, wiëc trzeba je przedtem ... }
var OldTextSettings: TextSettingsType;
    OldFillSettings: FillSettingsType;
    OldColor: Byte;

{ ... zapamiëtaç, a nastëpnie ... }
procedure HelpInit;
begin
  GetTextSettings(OldTextSettings);
  GetFillSettings(OldFillSettings);
  OldColor := GetColor;
end{ShowHelp.HelpInit};

{ ... odtworzyç }
procedure HelpDone;
begin
  SetTextStyle(OldTextSettings.Font,
               OldtextSettings.Direction,
               OldTextSettings.CharSize);
  SetTextJustify(OldTextSettings.Horiz,
                 OldTextSettings.Vert);
  SetFillStyle(OldFillSettings.Pattern,
               OldFillSettings.Color);
  SetColor(OldColor);
end{ShowHelp.HelpDone};

{ I treûç wíaûciwa procedury }
begin
  if not ( ( Group in [1..4] ) and ( Number in [1..8] ) ) then Exit;
  while KeyPressed do ReadKey;
  HelpInit;
  ClearDevice;
  if LoadHelp(Group, Number) then
    WriteHelp else
    WriteError;
  MMShow;
  Vga256.UpPalette256(MenuPalette);
  while ( MouseButton = 000 ) and ( not KeyPressed ) do;
  while MouseButton <> 000 do;
  Vga256.DownPalette256;
  HelpDone;
end{ShowHelp};

end{Help}.