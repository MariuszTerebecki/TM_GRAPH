{********************************************}
{*                                          *}
{*   Moduí zawierajÜcy pomoce kontekstowe   *}
{*        do programu TM Graph 1.0          *}
{*                                          *}
{*      (c) 1994  Terebecki Mariusz         *}
{*                                          *}
{********************************************}

unit HelpContext;

interface

{ ***** Wykorzystywane procedury ***** }

{ Tylko jedna procedura jest wywoíywana z zewnÜtrz }
procedure ShowHelpContext(Group, Number: Byte);

implementation

{ Wykorzystywany moduí standardowy }
uses Graph, Vga256;

{ Staía tablicowa z tekstami pomocy kontekstowych }
const Helps: array[1..4] of array[1..8] of string[36] =
        ( ( 'punkt', 'linia', 'prostokÜt, síupek', 'okrÜg, koío', 'elipsa',
            'wypeínianie obszar¢w', 'rysowanie oí¢wkiem', 'pisanie tekst¢w' ),
          ( 'powtarzanie rysowania', 'gruboûç linii, wypeínianie, czcionka',
            'losowy kolor rysowania', 'losowy kolor wypeíniania',
            'nastëpny kolor rysowania', 'poprzedni kolor rysowania',
            'nastëpny kolor wypeíniania', 'poprzedni kolor wypeíniania' ),
          ( 'do schowka', 'ze schowka', 'oglÜdanie obrazka', 'kolor rysowania',
            'kolor wypeíniania', 'zakres kolor¢w rysowania',
            'zakres kolor¢w wypeíniania', 'czyszczenie ekranu' ),
          ( 'zapisanie palety kolor¢w', 'wczytanie palety kolor¢w',
            'zapisanie wzorka wypeíniania', 'odczytanie wzorka wypeíniania',
            'zapisanie rysunku', 'odczytanie rysunku',
            'informacja o programie', 'opuszczenie programu' ) );

{ Staíe pomocnicze }
const OGroup: Byte = 0;
      ONumber: Byte = 0;

{ Wíaûciwa procedura wyûwietlajÜca pomoc }
{ do wybranej przez ußytkownika opcji    }
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