program Lat2Maz;

{Mazovia}

const
  Mazovia: array[1..18] of Byte =
    ( 134,141,145,146,164,162,158,166,167,
      143,149,144,156,165,163,152,160,161 );

{Latin}

  Latin: array[1..18] of Byte =
    ( 165,134,169,136,228,162,152,171,190,
      164,143,168,157,227,224,151,141,189 );

var
  Dst, Src: file;
  Buffer: array[1..10000] of Byte;
  I, J, Reading, Writing: Word;

begin
  Assign(Src, ParamStr(1));
  Assign(Dst, ParamStr(2));
  Reset(Src, 1);
  Rewrite(Dst, 1);
  repeat
    BlockRead(Src, Buffer, 10000, Reading);
    for I := 1 to 10000 do
      for J := 1 to 18 do
        if Buffer[I] = Latin[J]
          then begin
                 Buffer[I] := Mazovia[J];
                 J := 18;
               end;
    BlockWrite(Dst, Buffer, Reading, Writing);
  until (Reading <> 10000) or (Writing <> Reading);
  Close(Src);
  Close(Dst);
  if Writing <> Reading
    then WriteLn('Blad zapisu...');
end.