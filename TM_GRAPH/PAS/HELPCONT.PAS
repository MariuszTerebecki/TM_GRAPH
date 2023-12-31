{********************************************}
{*                                          *}
{*   Modu� zawieraj�cy pomoce kontekstowe   *}
{*        do programu TM Graph 1.0          *}
{*                                          *}
{*      (c) 1994  Terebecki Mariusz         *}
{*                                          *}
{********************************************}

unit HelpContext;

interface

{ ***** Wykorzystywane procedury ***** }

{ Tylko jedna procedura jest wywo�ywana z zewn�trz }
procedure ShowHelpContext(Group, Number: Byte);

implementation

{ Wykorzystywany modu� standardowy }
uses Graph, Vga256;

{ Sta�a tablicowa z tekstami pomocy kontekstowych }
const Helps: array[1..4] of array[1..8] of string[36] =
        ( ( 'punkt', 'linia', 'prostok�t, s�upek', 'okr�g, ko�o', 'elipsa',
            'wype�nianie obszar�w', 'rysowanie o��wkiem', 'pisanie tekst�w' ),
          ( 'powtarzanie rysowania', 'grubo�� linii, wype�nianie, czcionka',
            'losowy kolor rysowania', 'losowy kolor wype�niania',
            'nast�pny kolor rysowania', 'poprzedni kolor rysowania',
            'nast�pny kolor wype�niania', 'poprzedni kolor wype�niania' ),
          ( 'do schowka', 'ze schowka', 'ogl�danie obrazka', 'kolor rysowania',
            'kolor wype�niania', 'zakres kolor�w rysowania',
            'zakres kolor�w wype�niania', 'czyszczenie ekranu' ),
          ( 'zapisanie palety kolor�w', 'wczytanie palety kolor�w',
            'zapisanie wzorka wype�niania', 'odczytanie wzorka wype�niania',
            'zapisanie rysunku', 'odczytanie rysunku',
            'informacja o programie', 'opuszczenie programu' ) );

{ Sta�e pomocnicze }
const OGroup: Byte = 0;
      ONumber: Byte = 0;

{ W�a�ciwa procedura wy�wietlaj�ca pomoc }
{ do wybranej przez u�ytkownika opcji    }
procedure ShowHelpContext;
begin
  if not ( ( Group in [1..4] ) and ( Number in [1..8] ) )
    then Exit;
  SetTextStyle(SmallFont, HorizDir, 5);
  SetTextJustify(CenterText, CenterText);
  SetColor(0);
  if ( OGroup in [1..4] ) and ( ONumber in [1..8] ) then
    OutTextXY(160, 20, Helps[OGroup][ONumber]);
  SetColor(1);
  OutTextXY(160, 20, Helps[Group][Number]);
  OGroup := Group;
  ONumber := Number;
end{ShowHelp};

end{HelpContext}.