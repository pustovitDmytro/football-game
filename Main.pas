USES
  menu, settings, graph, crt;

function pmenu: byte;
VAR
  gd,i,gm,MaxX,MaxY,lx,ly: integer;
  c: char;
  f: boolean;
  A: mat;
BEGIN
  gd:= detect;
  initgraph(gd,gm,'');
  setbkcolor(cb);
  MaxX:=getmaxX;
  MaxY:=getmaxY;
  lx:= maxX div nx;
  ly:= maxY div ny;
  i:=1;
  NDraw(lx,ly,i);
  repeat
   c:=readkey;
   case c of
     #75: i:=Al[i]; {left}
     #72: i:=Au[i]; {up}
     #80: i:=Ad[i]; {down}
     #77: i:=Ar[i]; {right}
     #27: i:=8;     {esc}
   end;
  NDraw(lx,ly,i);
  until (c=#27) or (c=#13);
  pmenu:=i;
  closegraph;
end;


procedure psettings;
var f: files;
begin
  clrscr;
  writeln('Settings:');
  assign(f,way);
{$I-} reset(f); {$I+}
  if ioresult<>0 then fcreat(f)
  else chang(f);
  close(f);
end;

procedure phelp;
var f: files;
begin
  assign(f,way);
  helpset(f);
end;

Procedure pabout;
begin
clrscr;
  writeln('(c) The program was created by Dima');
  readln;
end;

procedure pexit;
var c: char;
begin
  clrscr;
  writeln('Are you sure? ');
  write('y/n');
  readln(c);
  if Upcase(c)='Y' then halt;
END;


BEGIN
  while true do
  case pmenu of     {
   1:  1pl
   2:  2pl
   3:  tour           }
   4:  phelp;
   5:  pexit;
   6: pabout;
   7: psettings;      {
   8: ptraining;     }
  end;
end.