USES
  menu, settings, graph, crt;

const

  c1 = 2;
  c2 = 2;
  c3 = 7;
  cs = 10;

VAR f: files;
    KB: keyboard;

procedure newpoly(const n,r: word; f0: real; s0: string;var  p: pointer);
  const
    x0=0;
    y0=0;
  var
    size,k,x1,x2,y1,y2: integer;
  begin
    if n>0 then
    begin
      for k:=1 to n do
      begin
       x1 := Trunc(x0+r +r*Cos(f0+2*pi*(k)/n));
       y1 := Trunc(y0+r +r*Sin(f0+2*pi*(k)/n));
       x2 := Trunc(x0+r +r*Cos(f0+2*pi*(k+1)/n));
       y2 := Trunc(y0+r +r*Sin(f0+2*pi*(k+1)/n));
       line(x1,y1,x2,y2);
      end;
    end
    else circle(x0+r,y0+r,r);
    settextjustify(1,1);
    outtextxy(x0+r,y0+r,s0);
    size:=imagesize(x0,y0,x0+2*r,y0+2*r);
    getmem(p,size);
    getimage(x0,y0,x0+2*r,y0+2*r,p^);
    putimage(x0,y0,p^,xorput);
  end;

type
  teams = (left, right);
  amplua = (fw, mr, ml, mo, dl, dr, gk);
  coord =array[1..c1] of integer;
  str = string[cs];
  cmas = array [1..c3] of integer;

  bal = object
    c: coord;
    vec: coord;
    cn: coord;
    b: boolean;
    p: pointer;
    constructor init(x,y: integer);
    procedure draw(x,y: integer);
  end;

  plr = object
    name: str;
    num: byte;
    vec: coord;
    c: coord;
    cn: coord;
    team: teams;
    amp: amplua;
    now: boolean;
    p: pointer;
    constructor init(t0: teams; a0:amplua; m,n : cmas {s0:str; n0: byte});
    procedure draw(x,y: integer);
    procedure mc;
  end;

  procedure chteam(var t: teams);
  begin
    if t=right then t:=left
    else t:=right;
  end;

  procedure formMas(x1,x2: integer; var m: cmas);
  var
    x4,i: integer;
  begin
    x4:=trunc( (x2-x1) div (c3-1));
    for i:=1 to c3 do m[i]:= x1+(i-1)*x4;
  end;

  procedure flvC(x,y: integer; var c: coord);
  begin
    c[1]:=x;
    c[2]:=y;
  end;

  procedure choosecoord(a: amplua; m,n: cmas; var c: coord);
  const k=20;
  begin
    case a of
      fw: flvc(m[4]-k,n[4],c);
      mr: flvc(trunc((m[3]+m[4]) div 2),trunc((n[6]+n[7]) div 2),c);
      ml: flvc(trunc((m[3]+m[4]) div 2),trunc((n[1]+n[2]) div 2),c);
      mo: flvc(m[2]+2*k,n[4],c);
      dl: flvc(m[2],n[2],c);
      dr: flvc(m[2],n[6],c);
      gk: flvc(m[1]+k,n[4],c);
    end;
  end;

constructor bal.init;
begin
  c[1]:=x;
  c[2]:=y;
  newpoly(0,5,0,'o',p);
end;

procedure bal.draw;
begin
  putimage(x-5,y-5,p^,xorput);
end;

constructor plr.init;
var q,size: integer;
begin
  team:=t0;
  amp:=a0;  {
    name:=s0;
    num:=n0;   }
  now:=false;
  flvc(0,0,vec);
  choosecoord(amp,m,n,c);
  if team = right then c[1]:=m[7]-c[1];
  newpoly(0,10,0,'p',p);
end;

procedure plr.draw;
begin
  putimage(x-10,y-10,p^,xorput);
end;

procedure plr.mc;
var i: integer;
begin
  for i:=1 to 2 do inc(c[i],vec[i]);
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

procedure play;

function length(c1,c2: coord): real;
var s1,s2,s3,l: real;
begin
  s1:=c1[1]-c2[1];
  s1:=sqr(s1);
  s2:=c1[2]-c2[2];
  s2:=sqr(s2);
  s3:=s1+s2;
  l:=sqrt(s3)  ;
  if l<0.1 then l:=1000;
  length:=l;
end;

function outsgn2(t: integer):integer;
begin
  if abs(t)>1 then outsgn2:=0 else outsgn2:=t;
end;
function ceil2(t: integer): integer;
begin
  if abs(t)>1 then ceil2:=trunc(t div abs(t)) else ceil2:=t;
end;

{-----------------------------------------------------------------------------------------------------------}


procedure GAME;
const cp=7;
tact = 5;
dt = 100;

type players = array[teams,amplua] of plr;

var
  pl: players;
  k,t: teams;
  i,h,a: amplua;
  q,w: integer;
  ball: bal;
  m,n: cmas;
  d: controls;
  s: string;
{===================================================================================================================}

function lgpas: amplua;
begin
  writeln('longpas');
end;

function dis(c1,c2,c0: coord): real;
var a,b,c,t: real;
begin
  a:=1/(c2[1]-c1[1]);
  b:=1/(c1[2]-c2[2]);
  c:=c1[1]*a-c1[2]*b;
  t:=1/sqrt(sqr(a)+sqr(b));
  dis:=abs(a*t*c0[1]+b*t*c0[2]+c*t);
end;

function ballconnect(const c1,c2: coord; var h: amplua; t: teams): boolean;
var i: amplua;
begin
  ballconnect:=true;
  for i:=fw to gk do
    if (pl[t,i].c[1]>c1[1]) then if (pl[t,i].c[1]<c2[1]) then if (pl[t,i].c[2]>c1[2]) then if (pl[t,i].c[2]<c2[2])
    then if dis(c1,c2,pl[t,i].c)<5 then
    begin
      h:=i;
      ballconnect:=false;
      exit;
    end;
end;

procedure pas;
var
  c0: coord;
  am,i: amplua;
  t0: teams;
  m: integer;
  s0: real;
  p: boolean;
begin
  c0[1]:=pl[t,h].c[1]+5*pl[t,h].vec[2];
  c0[2]:=pl[t,h].c[2]+5*pl[t,h].vec[2];
  s0:=900;
  for i:= fw to gk do
  begin
    if s0>length(pl[t,h].c,pl[t,i].c) then
    begin
      am:=i;
      s0:=length(pl[t,h].c,pl[t,i].c);
    end;
  end;
  for m:=1 to 2 do pl[t,h].vec[m]:=0;
  t0:=t; chteam(t0);
  p:=ballconnect(pl[t,h].c,pl[t,i].c,i,t0);
  if p then
  begin
    ball.cn:=pl[t,am].c;
    h:=am;
  end
  else
  begin
    t:=t0;
    ball.cn:=pl[t,i].c
  end;
end;

procedure rpas;
begin
  writeln('pras');
end;

procedure kick;
begin
  writeln('kick');
end;

procedure atk(var p: plr);
begin
    case p.amp of
      fw: inc(p.vec[1]);
      mr: inc(p.vec[1]);
      ml: inc(p.vec[1]);
      mo: inc(p.vec[1]);
      dl: inc(p.vec[1]);
      dr: inc(p.vec[1]);
      gk: p.vec:=p.vec;
    end;
end;

procedure dtk(var p: plr);
begin
  case p.amp of
    fw: dec(p.vec[1]);
    mr: dec(p.vec[1]);
    ml: dec(p.vec[1]);
    mo: dec(p.vec[1]);
    dl: dec(p.vec[1]);
    dr: dec(p.vec[1]);
    gk: p.vec:=p.vec;
  end;
end;

procedure kiborg(var d: controls);
begin
  d:=up;
end;

function plav(c1,c2: coord; j,i,o: integer): integer;
var k: integer;
begin
  k:=c1[j]+trunc((c2[j]-c1[j])*i/o);
  plav:=k;
end;

procedure findpl(var tt: teams; var hh: amplua);
const tact =5;
dt = 80;
var
  s0: real;
  i: amplua;
  t: teams;
  h: amplua;
  q:integer;
begin
  s0:=1900;
  for t:=left to right do
    for h:=fw to gk do
    if s0>length(pl[t,h].c,ball.c) then
    begin
      tt:=t;
      hh:=h;
      s0:=length(pl[t,h].c,ball.c);
    END;
  T:=TT;
  h:=hh;
  if s0 < 10 then
  begin
    ball.cn:=pl[t,h].c;
    flvc(0,0,pl[t,h].vec);
    for q:=1 to tact do
    begin
      ball.draw(plav(ball.c,ball.cn,1,q,tact),plav(ball.c,ball.cn,2,q,tact));
      delay(dt);
      ball.draw(plav(ball.c,ball.cn,1,q,10),plav(ball.c,ball.cn,2,q,10));
    end;
  ball.c:=ball.cn;
  end
  else
  begin
    pl[t,h].cn:=ball.c;
    pl[t,h].draw(pl[t,h].c[1],pl[t,h].c[2]);
    for q:=1 to tact do
    begin
      pl[t,h].draw(plav(pl[t,h].c,pl[t,h].cn,1,q,tact),plav(pl[t,h].c,pl[t,h].cn,2,q,tact));
      delay(dt);
      pl[t,h].draw(plav(pl[t,h].c,pl[t,h].cn,1,q,tact),plav(pl[t,h].c,pl[t,h].cn,2,q,tact));
    end;
    flvc(0,0,ball.vec);
    pl[t,h].c:=pl[t,h].cn;
    pl[t,h].draw(pl[t,h].c[1],pl[t,h].c[2]);
  end;
end;

function eqcoord(c1,c2: coord): boolean;
begin
  eqcoord:=false;
  if (c1[1]=c2[1]) and (c1[2]=c2[2]) then eqcoord:=true;
end;

procedure drawField(x1,y1,x2,y2: integer; var m,n: cmas);
const k =20; dx=7; dy2=20;
begin
  formmas(0,x2,m);
  formmas(0,y2,n);
  {gates}
  setviewport(0,0,getmaxx,getmaxy,true);
  setfillstyle(7,7);
  setlinestyle(0,1,3);
  bar(x1-dx,n[2]-dy2,x1,n[2]+dy2);
  rectangle(x1-dx,n[2]-dy2,x1,n[2]+dy2);
  bar(x1+m[7],n[2]-dy2,x1+m[7]+dx,n[2]+dy2);
  rectangle(x1+m[7],n[2]-dy2,x1+m[7]+dx,n[2]+dy2);
  {field}
  setviewport(x1,y1,x1+m[7],y1+n[7],false);
  setfillstyle(1,2);
  bar(m[1],n[1],m[7],n[7]);
  setlinestyle(0,1,3);
  rectangle(m[1],n[1],m[7],n[7]);
  setlinestyle(0,1,3);
  line(m[4],n[1],m[4],n[7]);
  circle(m[4],n[4],60);
  rectangle(m[1],n[2],m[2],n[6]);
  rectangle(m[6],n[2],m[7],n[6]);
  arc(m[2],n[4],270,90,60);
  arc(m[6],n[4],90,270,60);
  rectangle(m[1],trunc((n[2]+n[3])/2),trunc(m[1]+m[2]/3),trunc((n[5]+n[6])/2));
  rectangle(trunc(m[6]+(m[7]-m[6])/3*2),trunc((n[2]+n[3])/2),m[7],trunc((n[5]+n[6])/2));
  circle(trunc(m[1]+(m[2]-m[1])/3*2),n[4],2);
  circle(trunc(m[6]+(m[7]-m[6])/3),n[4],2);
end;

BEGIN
  drawField(10,30,620,420,m,n);
  ball.init(m[4],n[4]);
  ball.draw(ball.c[1],ball.c[2]);
  for k:=left to right do
    for i:=fw to gk do
    begin
      pl[k,i].init(k,i,m,n);
      pl[k,i].draw(pl[k,i].c[1],pl[k,i].c[2]);
    end;

  while true do
  begin
    findpl(t,h);
    if t=left then transf(KB,d) else kiborg(d);
    case d of
      ka: lgpas;
      ks: pas;
      kw: rpas;
      kd: kick;
      up:begin
           pl[t,h].vec[1]:=ceil2(pl[t,h].vec[1]+1);
           pl[t,h].vec[2]:=outsgn2(pl[t,h].vec[1]);
         end;
      dw:begin
           pl[t,h].vec[1]:=ceil2(pl[t,h].vec[1]-1);
           pl[t,h].vec[2]:=outsgn2(pl[t,h].vec[1]);
         end;
      rt:begin
           pl[t,h].vec[2]:=ceil2(pl[t,h].vec[1]+1);
           pl[t,h].vec[1]:=outsgn2(pl[t,h].vec[1]);
         end;
      lf:begin
           pl[t,h].vec[2]:=ceil2(pl[t,h].vec[1]-1);
           pl[t,h].vec[1]:=outsgn2(pl[t,h].vec[1]);
         end;
    end;


    for k:=left to right do
      for a:=fw to gk do
        if (k=t) and (a=h) then continue
        else if (k=t) then atk(pl[k,a])
             else dtk(pl[k,a]);


    for k:=left to right do
      for i:=fw to gk do
        if eqcoord(pl[k,i].cn,pl[k,i].c) then flvc(pl[k,i].c[1]+pl[k,i].vec[1],pl[k,i].c[2]+pl[k,i].vec[2],pl[k,i].cn);

    for k:=left to right do
      for i:=fw to gk do pl[k,i].draw(pl[k,i].c[1],pl[k,i].c[2]);
    ball.draw(ball.c[1],ball.c[2]);

    for q:=1 to 25 do
          begin
            for k:=left to right do
            for i:=fw to gk do pl[k,i].draw(plav(pl[k,i].c,pl[k,i].cn,1,q,25),plav(pl[k,i].c,pl[k,i].cn,2,q,25));
            ball.draw(plav(ball.c,ball.cn,1,q,25),plav(ball.c,ball.cn,2,q,25));
            delay(100);
            for k:=left to right do
            for i:=fw to gk do pl[k,i].draw(plav(pl[k,i].c,pl[k,i].cn,1,q,25),plav(pl[k,i].c,pl[k,i].cn,2,q,25));
            ball.draw(plav(ball.c,ball.cn,1,q,25),plav(ball.c,ball.cn,2,q,25));
          end;

          for k:=left to right do
            for i:=fw to gk do pl[k,i].draw(pl[k,i].c[1],pl[k,i].c[2]);
            ball.draw(ball.cn[1],ball.cn[2]);

    bar(200,200,400,400);
    readln(s);
    if s='l' then break;
  {if goal then break}

  end;
  {score goal}
  closegraph;
END;


var gd,gm: integer;

BEGIN
  gd:=detect;
  initgraph(gd,gm,'');
  initkeyboard(KB,f);
  game;
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

procedure phelp(var f: files);
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
  writeln('y/n');
  readln(c);
  if Upcase(c)='Y' then halt;
END;



BEGIN
  while true do
  case pmenu of
   1:  play;     {
   2:  2pl
   3:  tour           }
   4:  phelp(f);
   5:  pexit;
   6:  pabout;
   7:  psettings(f);      {
   8:  ptraining;     }
  end;
end.