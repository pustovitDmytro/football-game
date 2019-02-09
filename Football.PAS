Program football;
USES
  menu, settings, graph, crt,graphics,mgame;
const
  ctm= 150;
  cxscr=115;
  cf='fifa.teams';
  cl='leag.teams';


VAR f: files;
    KB: keyboard;

procedure fineread(var a: byte;b,c: byte);
begin
{$I-}
  readln(a);
{$I+}
  if ioresult<>0 then
    begin
      writeln('Incorrect type');
      repeat until readkey=#27;
      fineread(a,b,c);
    end
    else
    if (a<b) or (a>c) then
    begin
      writeln('should be between ',b,' and ',c);
      writeln('try again');
      fineread(a,b,c);
    end;
end;

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
  drawball(100,maxx div 2, maxy div 2);
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

function play(sl,sr: string; col1,col2,cn: word): boolean;

procedure drawscrp(x1,y1,c1,c2: integer; s1,s2: string);
const k=20;
begin
  drawball(x1+r1,y1-2*r2+r1,r1);
  drawplr(x1+3*r2,y1-r2,r2,c1);
  drawplr(x1+5*r2+2*cxscr+2*ctm,y1-r2,r2,c2);
  setcolor(15 xor 2);
  drawball(x1+r1,y1+r1,r1);
  drawplr(x1+r2,y1+3*r2,r2,c1 xor 2);
  drawplr(x1+r2,y1+5*r2,r2,c2 xor 2);
  setcolor(c1);
  setTExtJustify(0,0);
  outtextxy(x1+4*r2+k,y1-r2,s1);
  settextjustify(2,0);
  setcolor(c2);
  outtextxy(4*r2+2*ctm+2*cxscr-k,y1-r2,s2);
  settextjustify(1,2);
  setcolor(white);
  outtextxy(kx1+4*r2+ctm+cxscr,y1-r2,'us');
end;

procedure  showgoal(s: string);
var i: byte;
begin
  setfillstyle(0,2);
  bar(0,ky1,getmaxx,getmaxy);
  randomize;
  for i:=1 to 20 do
  begin
    setcolor(2+random(17));
    drawball(50+random(300)-random(100)+random(200),150+random(200)-random(80)+random(50),20+random(17));
  end;
  while keypressed do readkey;
  delay(20);
  bar(0,ky1,getmaxx,getmaxy);
  settextstyle(7,0,5);
  settextjustify(1,1);
  setcolor(white);
  outtextxy(200,100,'THE GOAL ');
  outtextxy(300,200,' Was scored by: ') ;
  outtextxy(300,350,s);
  readkey;
end;

var gd,gm: integer;
    pb,pl,pr: pointer;
    tm: teams;
    am: amplua;
    c1,c2: byte;
    way1,way2: string;
    f1,f2: text;

function score(t:teams; h: amplua): boolean;
const k=5;
var s: string;
i: amplua;
begin
 score:=false;
 setviewport(0,0,getmaxX,getmaxy,false);
 if t=left then
 begin
   drawball(kx1+5*r2+ctm+k*(c1+1)+c1*2*r2,ky1-r2,r2);
   inc(c1);
   reset(f1);
   for i:=h to gk do readln(f1,s);
   close(f1);
   music(true);
   if c1=cn then score:=true;
 end
 else
 begin
   drawball(kx1+3*r2+ctm+2*cxscr-k*(1+c2)-c2*2*r2,ky1-r2,r2);
   inc(c2);
   reset(f2);
   for i:=h to gk do readln(f2,s);
   close(f2);
   if c2=cn then score:=true;
   music(false);
 end;
 showgoal(s);
end;

procedure winscr(t: teams);
var s: string;
i: byte;
begin
  randomize;
  if t=left then s:=sl
  else s:=sr;
  setfillstyle(1,1);
  bar(0,0,getmaxx,getmaxy);
  setcolor(14);
  drawball(60,300,100);
  drawball(500,50,120);
  for i:= 1 to 10 do drawball(100+random(300)+random(150)-random(60),50+random(100)+random(225)-random(50),15+random(50));
  delay(10);
  cleardevice;
  settextstyle(4,0,5);
  setcolor(4);
  outtextxy(200,50,'Congradulations');
  drawball(60,300,100);
  drawball(500,50,120);
  outtextxy(200,100,'The team');
  outtextxy(200,300,'Was won ');
  outtextxy(200,400,'A Game!!!');
  setcolor(14);
  outtextxy(200,200,s);
  settextstyle(1,1,10);
  setcolor(2);
  outtextxy(500,240,'WINNER');
  repeat until readkey=#27;
end;

function editname(s: string): string;
begin
  if ord(s[0])<9 then s:=s else
  begin
    if s='manchester united' then s:='manche~2'
    else s:=s[1]+s[2]+s[3]+s[4]+s[5]+s[6]+'~'+'1';
  end;
  editname:='teams\'+s+'.txt';
end;

BEGIN
  gd:=detect;
  initgraph(gd,gm,'');
  initkeyboard(KB,f);
  way1:=editname(sl);
  way2:=editname(sr);
  assign(f1,way1);
  assign(f2,way2);
  drawscrp(kx1,ky1,col1,col2,sl,sr);
  getmem(pb,imagesize(kx1,ky1,kx1+2*r1,ky1+2*r1));
  getimage(kx1,ky1,kx1+2*r1,ky1+2*r1,pb^);
  getmem(pl,imagesize(kx1,ky1+2*r2,kx1+2*r2,ky1+4*r2));
  getimage(kx1,ky1+2*r2,kx1+2*r2,ky1+4*r2,pl^);
  getmem(pr,imagesize(kx1,ky1+4*r2,kx1+2*r2,ky1+6*r2));
  getimage(kx1,ky1+4*r2,kx1+2*r2,ky1+6*r2,pr^);
  c1:=0; c2:=0;
  repeat
    game(tm,am,pb,pl,pr,kb);
  until score(tm,am);
  winscr(tm);
  freemem(pl,imagesize(kx1+2*r2,ky1,kx1+2*r2+2*r1,ky1+2*r2));
  freemem(pr,imagesize(kx1+2*r2,ky1,kx1+2*r2+2*r1,ky1+2*r2));
  closegraph;
  play:= ( tm=left );
END;

procedure psettings(var f: files);
begin
  clrscr;
  writeln('Settings: ');
  assign(f,way);
{$I-} reset(f); {$I+}
  if ioresult<>0 then fcreat(f)
  else chang(f);
  initkeyboard(KB,f);
end;

procedure showteams;
type
tm = record
    s: string;
    c: word;
  end;

var
  t: tm;
  ft: file of tm;
  n,c,i: byte;
  way: string;
begin
  writeln('Input name: ');
  writeln('1. ',cf);
  writeln('2. ',cl);
  fineread(n,1,2);
  case n of
    1: way:=cf;
    2: way:=cl;
  end;
  assign(ft,way);
  reset(ft);
  for i:=1 to 16 do
  begin
    read(ft,t);
    write(i,'. ',t.s,', color - ',t.c);
    writeln;
  end;
  readln;
  close(ft);
end;

procedure newtorfile;
type
tm = record
    s: string;
    c: word;
  end;
var
  t: tm;
  ft: file of tm;
  n,c,i: byte;
  s,way: string;
begin
  writeln('Input name: ');
  writeln('1. ',cf);
  writeln('2. ',cl);
  fineread(n,1,2);
  case n of
    1: way:=cf;
    2: way:=cl;
  end;
  assign(ft,way);
  rewrite(ft);
  for i:=1 to 16 do
  begin
    writeln('input team name');
    readln(s);
    writeln('input team color');
    fineread(c,0,15);
    t.s:=s;
    t.c:=c;
    write(ft,t);
  end;
  close(ft);
end;

procedure phelp(var f: files);
var n: byte;
begin
  writeln('input number of action: ');
  writeln('1.  create temlist');
  writeln('2.  show teamlist ');
  writeln('3.  watch settings' );
  writeln('4.  watch rules');
  fineread(n,1,4);
  case n of
  4: watchrules;
  3: begin
       assign(f,way);
       helpset(f);
     end;
  2: showteams;
  1: newtorfile;
  end;
end;

Procedure pabout;
begin
  clrscr;
  writeln('(c) The program was created by Dima');
  writeln;
  writeln('Football Game:');
  writeln('This Game -  it is');
  writeln('* 3 game modes');
  writeln('* user settings and keyboard');
  writeln('* There are 2 original football tournaments ');
  writeln('* 32 teams participated in');
  writeln('* original names and team squad');
  writeln('* national teams');
  writeln('* original fifa music accomodation');
  writeln('* new football reality');
  writeln('* new goalscoring system');
  writeln('* without rasism');
  repeat until readkey=#27;
end;

procedure pexit;
var c: char;
begin
  clrscr;
  writeln('Are you sure? ');
  writeln('y/n');
  readln(c);
  if Upcase(c)='Y' then halt;
END;

procedure tournament(way: string);
type
   tm = record
    s: string;
    c: word;
  end;

var
  ft: file of tm;
  dop: set of byte;
  t,tn: tm;
  i,k,n: byte;
  s: string;
begin
  dop:=[1..16];
  randomize;
  assign(ft,way);
  writeln('This teams participate in the tourmament: ');
  reset(ft);
  for i:=1 to 16 do
  begin
    read(ft,t);
    writeln('#',i,' ',t.s);
  end;
  writeln('Input number of choosen team: ');
  fineread(n,1,16);
  exclude(dop,n);
  seek(ft,n-1);
  read(ft,tn);
  for i:=4 downto 1 do
  begin
    case i of
    4: s:='1/8 final';
    3: s:='quartetfinal';
    2: s:='semifinal';
    1: s:='final';
    end;
    repeat
    k:=1+random(16);
    until k in dop;
    exclude(dop,k);
    seek(ft,k-1);
    read(ft,t);
    if tn.c=t.c then t.c:=7;
    writeln('Your next oponent is ',t.s);
    readln;
    if not play(tn.s,t.s,tn.c,t.c,3) then break;
    writeln('Congradulations!, you have won ',s,' match');
    writeln(tn.s,' Was better then ',t.s,' this time');
    readln;
  end;
    if i<>1 then
    begin
      writeln('You lost ',s,' game, ');
      writeln('so the team ',tn.s,'was eliminated from the tournament');
      writeln('the winer of the tounament - ',t.s);
      readln;
    end
    else
    writeln;
    Writeln('Congradulations!');
    writeln('You have won the tornament!');
   close(ft);
end;

BEGIN
  while true do
  case pmenu of
   1:  play('Liverpool','Vorskla',4,15,5);
   2:  tournament('fifa.teams');
   3:  tournament('leag.teams');
   4:  phelp(f);
   5:  pexit;
   6:  pabout;
   7:  psettings(f);
   8:  play('Team1','Team2',14,1,1);
  end;
end.