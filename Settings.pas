{settings}

Unit settings;

Interface

Uses crt;
const way = 'settings.dat';
      cks = 8;
Type
  str = string[10];
  controls = (ka,ks,kw,kd,up,dw,rt,lf,nill);
  KeyBoard= array[controls] of char;

  ckey= record
    expl: string;
    sym: char;
    cnt: controls;
  end;
  files = file of ckey;


  Procedure helpset(var f: files);
  procedure chose(var p: ckey);
  procedure fcreat(var f: files);
  Procedure chang(var f: files);
  Procedure InitKeyboard(var KB: KeyBoard; var f:files);
  function transf(KB: Keyboard; var t:controls): boolean;
Implementation

procedure chose;
  type
    mS = array [1..cks] of str;
    mT = array [1..cks] of controls;
  const
    cS: mS = ('longpas','shortpas','cutpas','kick','up','down','right','left');
    cT: mT = (ka,ks,kw,kd,up,dw,rt,lf);
  var i: byte;
  begin
    for i:= 1 to cks do
    if p.expl = cs[i] then p.cnt := cT[i];
  end;

procedure fcreat;
  var p: ckey;
      i: byte;
  Begin
    writeln('Settings was not found at the computer ');
    assign(f,way);
    rewrite(f);
    for i:=1 to cks do
    begin
      writeln('name of a key');
      readln(p.expl);
      chose(p);
      writeln('input a key');
      p.sym:=readkey;
      if p.sym=#0 then p.sym:=readkey;
      write(f,p);
    end;
    close(f);
  end;

Procedure chang;
  var
    p: ckey;
    s: str;
    k:integer;
  begin
    clrscr;
    helpset(f);
    writeln('What do you want to change?');
    readln(s);
    assign(f,way);
    reset(f);
    while not eof(f) do
    begin
      read(f,p);
      if p.expl = s then
      begin
        writeln('Enter new meaning: ');
        p.sym := readkey;  if p.sym=#0 then p.sym:=readkey;
         seek(f,filepos(f)-1);
         write(f,p);
        break;
      end;
    end;
    close(F);
  end;

 Procedure InitKeyboard;
  var
    p: ckey;
    t: controls;
  begin
    assign(f,way);
    reset(f);
    for t:= ka to lf do
    begin
      read(f,p);
      KB[p.cnt]:=p.sym;
    end;
    close(f);
  end;

function transf;
  var
    c: char;
    tt: controls;
  begin
    transf:=false;
    t:=nill;
    if keypressed then
    begin
      c:= readkey;
      if c=#27 then transf:=true;
      if c=#0 then c:=readkey;
      while keypressed do readkey;
      for tt:=ka to lf do
      if KB[tt] = c then
      begin
        t:= tt;
        break;
      end;
    end;
  end;

Procedure helpset;
var
  s: str;
  p: ckey;
begin
  writeln('help: ');
  reset(f);
  while not eof(f) do
  begin
    read(f,p);
    writeln(p.expl,' = ',p.sym);
  end;
  readln;
  close(f);
end;

BEGIN END.