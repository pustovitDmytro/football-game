{KeyBoard;    }

Uses settings;
                                                                    {ka,ks,kw,kd,up,dw,rt,lf}
Type
  KB: array[controls] of char;

Procedure InitKeyboard(KB: KeyBoard, f:files);
  var
    p: ckey;
    t: controls;
  begin    {
    seek(f)  }
    for t: ka to lf do
    begin
      read(f,p);
      KB[t]:=p.sym;
    end;
  end;
  
Function transf(KB: Keyboard): controls;
  var
    c: char;
    t: controls
  begin
    repeat until keypressed;
    c: readkey;
    for t:=ka to lf do
    if KB[t] = c then transf = t;
  end;
  
end.
  