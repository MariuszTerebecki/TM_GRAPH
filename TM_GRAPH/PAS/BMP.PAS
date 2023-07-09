{********************************************}
{*                                          *}
{*  Modu’ operuj†cy na plikach graficznych  *}
{*  BMP 320x200x256 przystosowany do pracy  *}
{*    w trybie 13h karty graficznej VGA.    *}
{*                                          *}
{*      (c) 1993  Terebecki Mariusz         *}
{*                                          *}
{********************************************}
unit BMP;

interface

{ ***** Modu’y wykorzystywane w module ***** }

uses Dos,    { Modu’ standardowy              }
     VGA256; { Inicjacja i zamkni‘cie grafiki }

{ ***** Typy wykorzystywane w module ***** }

     { Nag’¢wek pliku }
type BMPFileHdr = record
                    FType      : Word;
                    FSize      : LongInt;
                    FReserved1 : Word;
                    FReserved2 : Word;
                    FOffBits   : LongInt;
                  end{BMPFileHdr};

     { Nag’¢wek rysunku }
     BMPInfoHdr = record
                    ISize          : LongInt;
                    IWidth         : LongInt;
                    IHeight        : LongInt;
                    IPlanes        : Word;
                    IBitCount      : Word;
                    ICompression   : LongInt;
                    ISizeImage     : LongInt;
                    IXPelsPerMeter : LongInt;
                    IYPelsPerMeter : LongInt;
                    IClrUsed       : LongInt;
                    IClrImportant  : LongInt;
                  end{BMPInfoHdr};

     { Rekord sk’adowych koloru }
     BMPRGBQuad = record
                    Blue  : Byte;    {  W pliku sk’adowe kolor¢w s†     }
                    Green : Byte;    {  ustawione " od ty’u " + puste   }
                    Red   : Byte;    {  miejsce dla u’atwienia operacji }
                    null  : Byte;    {  na procesorach 32 - bitowych.   }
                  end{BMPRGBQuad};

     { Paleta kolor¢w }
     TBMPAllPalette = array[0..255] of BMPRGBQuad;

     { Jedna linia rysunku }
     TLine = array[1..320] of Byte;

     { Ca’y rysunek }
     TBMPImage = array[1..200] of TLine;

     { Ca’y plik }
     PBMPAll = ^TBMPAll;
     TBMPAll = record
                 BMPFile    : BMPFileHdr;
                 BMPInfo    : BMPInfoHdr;
                 BMPPalette : TBMPAllPalette;
                 BMPImage   : TBMPImage;
               end{TBMPAll};

     { Obiekt operuj†cy na plikach *.BMP - deklaracja }
     PBMP = ^TBMP;
     TBMP = object
              BMPAll  : TBMPAll;  { Rysunek             }
              BMPFile : file;     { Plik z rysunkiem    }
              constructor Init(FName: string);
              destructor Done(Save: Boolean);
              procedure Show(SetPal: Boolean);
              procedure Store(X, Y: Word);
              procedure SetPalette;
              procedure SaveImage(var Error: Integer);
              procedure SavePalette(var Error: Integer);
              procedure LoadImage(var Error: Integer);
              procedure LoadPalette(var Error: Integer);
            end{TBMP};

{ ***** Zmienne modu’u udost‘pnione na zewn†trz ***** }

var Palette: APalette256; { Paleta kolor¢w jako zmienna globalna }
    FileName: string;     { Stara nazwa rysunku ...              }
    DirName: string;      { ... i jego katalog                   }

implementation

uses
  Graph, MMouse;

{ ***** Definicje metod obiektu TBMP ***** }

{ Konstruktor wczytuj†cy rysunek z bie§†cego katalogu }
constructor TBMP.Init;
var E: Integer;
begin
  GetDir(0, DirName);
  FileName := FName;
  LoadImage(E);
end{TMBP.Init};

{ Destruktor w razie potrzeby zapisuj†cy rysunek pod }
{ star† nazw†                                        }
destructor TBMP.Done;
var E: Integer;
begin
  if Save
    then SaveImage(E);
end{TBMP.Done};

{ Wyžwietlenie rysunku na ekranie }
procedure TBMP.Show;
var
  LI: LongInt;
  X: Integer;
begin
  MMHide;
  if SetPal then
    begin
      ClearDevice;
      Vga256.SetPalette(Mem[SegA000:$0000]);
    end;
  with BMPAll do
    for X := BMPInfo.IHeight downto 1 do
      begin
        Move(BMPAll.BMPImage[X],
        Mem[$0a000:$00 + ( BMPInfo.IHeight - X ) * BMPInfo.IWidth],
        BMPInfo.IWidth);
      end;
  MMShow;
  if SetPal then
    begin
      SetPalette;
      Vga256.UpPalette256(Palette);
    end;
end{TBMP.Show};

{ Skopiowanie rysunku z ekranu }
procedure TBMP.Store;
var LI: LongInt;
begin
  MMHide;
  with BMPAll do
    for X := BMPInfo.IHeight downto 1 do
      begin
        Move(Mem[$0a000:$00 + ( BMPInfo.IHeight - X ) * BMPInfo.IWidth],
        BMPAll.BMPImage[X], BMPInfo.IWidth);
      end;
  MMShow;
end{TBMP.Store};

{ Przepisanie poprawnie palety do zmiennej globalnej }
procedure TBMP.SetPalette;
var Color: Byte;
begin
  for Color := 0 to 255 do
    begin
      TPalette256(Palette)[Color][0] := BMPAll.BMPPalette[Color].Red   shr 2;
      TPalette256(Palette)[Color][1] := BMPAll.BMPPalette[Color].Green shr 2;
      TPalette256(Palette)[Color][2] := BMPAll.BMPPalette[Color].Blue  shr 2;
    end;
end{TBMP.SetPalette};

{ Zapisanie rysunku }
procedure TBMP.SaveImage;
begin
  {$I-}
  ChDir(DirName);
  Assign(BMPFile, FileName + '.bmp');
  Rewrite(BMPFile, 1);
  BlockWrite(BMPFile, BMPAll, SizeOf(TBMPAll));
  Close(BMPFile);
  Error := IOResult;
  if Error = 101 then Erase(BMPFile);
  {$I+}
end{TBMP.SaveImage};

{ Zapisanie palety kolor¢w }
procedure TBMP.SavePalette;
begin
  {$I-}
  ChDir(DirName);
  SetPalette;
  Assign(BMPFile, FileName + '.pal');
  Rewrite(BMPFile, 1);
  BlockWrite(BMPFile, Palette, 768);
  Close(BMPFile);
  Error := IOResult;
  if Error = 101 then Erase(BMPFile);
  {$I+}
end{TBMP.SavePalette};

{ Odczytanie rysunku }
procedure TBMP.LoadImage;
begin
  {$I-}
  ChDir(DirName);
  Assign(BMPFile, FileName + '.bmp');
  Reset(BMPFile, 1);
  BlockRead(BMPFile, BMPAll, SizeOf(TBMPAll));
  Close(BMPFile);
  Error := IOResult;
  {$I+}
end{TBMP.LoadImage};

{ Odczytanie rysunku }
procedure TBMP.LoadPalette;

procedure StorePalette;
var Color: Byte;
begin
  for Color := 0 to 255 do
    begin
      BMPAll.BMPPalette[Color].Red := TPalette256(Palette)[Color][0]   shl 2;
      BMPAll.BMPPalette[Color].Green := TPalette256(Palette)[Color][1] shl 2;
      BMPAll.BMPPalette[Color].Blue := TPalette256(Palette)[Color][2]  shl 2;
    end;
end{TBMP.LoadPalette.StorePalette};

begin
  {$I-}
  ChDir(DirName);
  Assign(BMPFile, FileName + '.pal');
  Reset(BMPFile, 1);
  BlockRead(BMPFile, Palette, 768);
  Close(BMPFile);
  Error := IOResult;
  if Error = 0 then StorePalette;
  {$I+}
end{TBMP.LoadPalette};

end{BMP}.