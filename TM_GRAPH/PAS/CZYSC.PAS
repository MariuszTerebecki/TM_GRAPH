program Czysc;

var
  Src, Dst: Text;
  S: string;

begin
  Assign(Src, ParamStr(1));
  Reset(Src);
  Assign(Dst, ParamStr(2));
  Rewrite(Dst);
  repeat
    ReadLn(Src, S);
    while S[Length(S)] = ' ' do
      Delete(S, Length(S), 1);
    WriteLn(Dst, S);
  until EoF(Src);
  Close(Src);
  Close(Dst);
end.