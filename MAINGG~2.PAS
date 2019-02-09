USES
  menu, settings, graph, crt;
const
  c1 = 2;
  c2 = 2;
  c3 = 7;
  cs = 10;
  kx1= 10;
  ky1= 30;
  cx1= 620;
  cx2= 420;
  ctm = 150;
  cxscr=50;
  r1=5;
  r2=10;

VAR f: files;
    KB: keyboard;
    pl,pr: pointer;
type
  teams = (left, right);
  amplua=(fw, mr, ml, mo, dl, dr, gk);
  coord = array[1..c1] of integer;
  str = string[cs];
  cmas = array [1..c3] of integer;

  bal = object
    c: coord;
    vec: coord;
    cn: coord;
    b: boolean;
    p: pointer;
    constructor init(x,y: integer);
    procedure draw;
  end;

  plr = object
    vec: coord;
    c: coord;
    cn: coord;
    team: teams;
    amp: amplua;

    constructor init(t0: teams; a0:amplua; m,n : cmas {s0:str; n0: byte});
    procedure draw;
    procedure mc;
  end;

  procedure chteam(var t: teams);
  begin
    if t=right then t:=left
    else t:=right;
  end;
  function eqcoord(c1,c2: coord): boolean;
begin
  eqcoord:=false;
  if (c1[1]=c2[1]) and (c1[2]=c2[2]) then eqcoord:=true;
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
  cn:=c;
  getmem(p,imagesize(kx1,ky1-2*r2+2*r1,kx1+2*r1,ky1-2*r2));
  getimage(kx1,ky1-2*r2+2*r1,kx1+2*r1,ky1-2*r2,p^);
end;

procedure drawpoly(const x0,y0,n: word;const  r,f0: real);
var k,x1,x2,y1,y2: integer;
begin
  for k:=1 to n do
  begin
    x1 := x0+Trunc(r*Cos(f0+2*pi*k/n));
    y1 := y0+Trunc(r*Sin(f0+2*pi*k/n));
    x2 := x0+Trunc(r*Cos(f0+2*pi*(k+1)/n));
    y2 := y0+Trunc(r*Sin(f0+2*pi*(k+1)/n));
    line(x1,y1,x2,y2);
  end;
end;

procedure drawball(x0,y0,r: integer);
var a,s: real;
m: integer;
 begin
   s:=r*sqrt(3/7)/2;
   a:=r/sqrt(7);
   setlinestyle(0,1,1);
   drawpoly(x0,y0,6,a,0);
   for m:=0 to 5 do drawpoly(trunc(x0+2*s*cos(m*pi/3+pi/6)),trunc(y0+2*s*sin(m*pi/3+pi/6)),6,a,0);
   circle(x0,y0,r);
end;

procedure bal.draw;
begin
  putimage(c[1]-r1+1,c[2]-r1+1,p^,xorput);
end;

procedure ball.mc;
begin
  if eqcoord(c,cn) then flvc(c[1]+r2*vec[1],c[2]+r*vec[2],cn);
  if cn[1]<r2 then begin cn[1]:=r2  flvc(-vec[1],vec[2],vec); end;
  if cn[1]> (cx1-r2) then begin cn[1]:=cx1-r2;  flvc(-vec[1],vec[2],vec); end;
  if cn[2]<r2 then begin cn[2]:=r2;   flvc(vec[1],-vec[2],vec);  end;
  if cn[2]> (cx2-r2) then begin cn[2]:=cx2-r2;  flvc(vec[1],-vec[2],vec); end;
end;

procedure drawplr(const x,y,r,c: integer);
var k: integer;
 begin
   setfillstyle(1,c);
   pieslice(x,y,0,360,r);
   randomize;
   k:=random(1);
   if k=0 then setfillstyle(7,black)
   else setfillstyle(7,white);
   pieslice(x,y,0,360,r1);
 end;

constructor plr.init;
var q: integer;
begin
  team:=t0;
  amp:=a0;
  flvc(-1,-1,vec);
  choosecoord(amp,m,n,c);
  if team = right then c[1]:=m[7]-c[1];
  cn:=c;
end;

procedure plr.draw;
begin
  if team =left then putimage(c[1]-r2,c[2]-r2,pl^,xorput)
  else putimage(c[1]-r2,c[2]-r2,pr^,xorput);
end;

procedure plr.mc;
begin
  if eqcoord(c,cn) then flvc(c[1]+r2*vec[1],c[2]+r*vec[2],cn);
  if cn[1]<r2 then begin cn[1]:=r2  flvc(-vec[1],vec[2],vec); end;
  if cn[1]> (cx1-r2) then begin cn[1]:=cx1-r2;  flvc(-vec[1],vec[2],vec); end;
  if cn[2]<r2 then begin cn[2]:=r2;   flvc(vec[1],-vec[2],vec);  end;
  if cn[2]> (cx2-r2) then begin cn[2]:=cx2-r2;  flvc(vec[1],-vec[2],vec); end;
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

{------------------------------------------------------}

procedure GAME(var glt: teams ;glh: amplua);
const cp=7;
tact = 4;
dt = 10;

type players = array[teams,amplua] of plr;

var
  pl: players;
  k,t: teams;
  i,h,ha: amplua;
  q: integer;
  ball: bal;
  m,n: cmas;
  d: controls;
  goal,fl: boolean;
  s: string;
{===================================================================================================================}


function dis(c1,c2,c0: coord): real;
var a,b,c,t: real;
begin
  a:=1/(c2[1]-c1[1]);
  b:=1/(c1[2]-c2[2]);
  c:=c1[1]*a-c1[2]*b;
  t:=1/sqrt(sqr(a)+sqr(b));
  dis:=abs(a*t*c0[1]+b*t*c0[2]+c*t);
end;

function ballconnect(const c1,c2: coord; var h: amplua; var t: teams): boolean;
const d =10;
var i: amplua;
begin
  ballconnect:=true;
  chteam(t);
  for i:=fw to gk do
    if (pl[t,i].c[1]>c1[1]) then if (pl[t,i].c[1]<c2[1]) then if (pl[t,i].c[2]>c1[2]) then if (pl[t,i].c[2]<c2[2])
    then if dis(c1,c2,pl[t,i].c)<d then
    begin
      h:=i;
      ballconnect:=false;
      exit;
    end;
    chteam(t);
end;

procedure pas(var h: amplua);
var
  am,i: amplua;
  t0: teams;
  m: integer;
  s0: real;
  p: boolean;
begin
  s0:=900;
  for i:= fw to gk do
  begin
    if s0>length(pl[t,h].c,pl[t,i].c) then
    begin
      am:=i;
      s0:=length(pl[t,h].c,pl[t,i].c);
    end;
  end;
  flvc(0,0,pl[t,am].vec);
  t0:=t; chteam(t0);
  p:=ballconnect(pl[t,h].c,pl[t,am].c,i,t0);
  if p then
  begin
    h:=am;
    ball.cn:=pl[t,h].c;
  end
  else
  begin
    t:=t0; h:=i;
    ball.cn:=pl[t,h].cn;
  end;
end;

procedure rpas(var h: amplua);
var
 am,i: amplua;
  t0: teams;
  m: integer;
  s0: real;
  p: boolean;
begin
  s0:=900;
  for i:= fw to gk do
  begin
    if s0>length(pl[t,h].c,pl[t,i].c) then
    begin
      am:=i;
      s0:=length(pl[t,h].c,pl[t,i].c);
    end;
  end;
  pl[t,h].mc;
  p:=ballconnect(pl[t,h].c,pl[t,i].cn,i,t0);
  if p then
  begin
    h:=am;
    ball.cn:=pl[t,h].cn;
  end
  else
  begin
    h:=i;
    ball.cn:=pl[t,h].c
  end;
end;



procedure perimetr(var pl: plr; const x1,y1,x2,y2: integer);
begin
  if (pl.cn[1]<x2) and (pl.cn[1]>x1) and (pl.cn[2]>y1) and (pl.cn[2]<y2) then
  begin
    if pl.cn[1]< x1+2*r2 then flvc(-pl.vec[1],pl.vec[2],pl.vec);
    if pl.cn[1]> x2-2*r2 then flvc(-pl.vec[1],pl.vec[2],pl.vec);
    if pl.cn[2]< y1+2*r2 then flvc(pl.vec[1],-pl.vec[2],pl.vec);
    if pl.cn[2]> y1-2*r2 then flvc(pl.vec[1],-pl.vec[2],pl.vec);
  end
  else
  begin
    flvc((x1+x2) div 2,(y1+y2) div 2,pl.cn);
    flvc(1,1,pl.vec);
  end;
end;

procedure atk(var p: plr);
begin
    case p.amp of
      fw: perimetr(p,m[1],n[1],m[7],n[7]);
      mr: perimetr(p,m[1],n[1],m[7],n[7]);
      ml: perimetr(p,m[1],n[1],m[7],n[7]);
      mo: perimetr(p,m[1],n[1],m[7],n[7]);
      dl: perimetr(p,m[1],n[1],m[7],n[7]);
      dr: perimetr(p,m[1],n[1],m[7],n[7]);
      gk: perimetr(p,m[1],n[1],m[7],n[7]);
    end;
end;


procedure dtk(var p: plr);
begin
  case p.amp of
    fw: perimetr(p,m[1],n[1],m[7],n[7]);
    mr: perimetr(p,m[1],n[1],m[7],n[7]);
    ml: perimetr(p,m[1],n[1],m[7],n[7]);
    mo: perimetr(p,m[1],n[1],m[7],n[7]);
    dl: perimetr(p,m[1],n[1],m[7],n[7]);
    dr: perimetr(p,m[1],n[1],m[7],n[7]);
    gk: perimetr(p,m[1],n[1],m[7],n[7]);
  end;
end;

procedure kiborg(var h: amplua);
begin

end;



function plav(c1,c2: coord; j,i,o: integer): integer;
var k: integer;
begin
  k:=c1[j]+trunc((c2[j]-c1[j])*i/o);
  plav:=k;
end;

procedure dcoord(var c1: coord; c2: coord; o,i: integer);
var c0: coord;
k: integer;
begin
  for k:=1 to 2 do
  begin
  c0[k]:=(o*c1[k]-i*c2[k]) div (o-i);
  c1[k]:=c1[k]+((c2[k]-c0[k]) div o)
  end;
end;


procedure show(const tact,dt:integer; var h,ha: amplua);
var q: integer;
    k: teams;
    i: amplua;
begin
    for k:=left to right do
      for i:=fw to gk do
      begin
        pl[k,i].mc;
        pl[k,i].draw;
      end;
   if (ball.c[1]=ball.cn[1]) and (ball.c[2]=ball.cn[2]) then
   begin
    if t = left then
    begin
      ball.cn:=pl[t,h].cn;
      if not ballconnect(ball.c,ball.cn,i,t) then
      begin
        chteam(t);
        ha:=i;
      end;
    end
    else
    begin
      ball.cn:=pl[t,ha].cn;
      if not ballconnect(ball.c,ball.cn,i,t) then h:=i;
    end;
    end
    else ball.mc;
    ball.draw;
    for q:=1 to tact do
    begin
      for k:=left to right do
        for i:=fw to gk do
        begin
          dcoord(pl[k,i].c,pl[k,i].cn,tact,q-1);
          pl[k,i].draw;
        end;
        dcoord(ball.c,ball.cn,tact,q-1);
        ball.draw;
        delay(dt);
        for k:=left to right do
          for i:=fw to gk do pl[k,i].draw;
        ball.draw;
    end;
    for k:=left to right do
      for i:=fw to gk do pl[k,i].draw;
    ball.draw;
end;

procedure findpl;
const tact =5;
dt = 80;
var
  s0: real;
  i,ia: amplua;
  ti,t: teams;
  q:integer;
begin
  s0:=1900;
  for ti:=left to right do
    for i:=fw to gk do
    if s0>length(pl[ti,i].c,ball.c) then
    begin
      t:=ti;
      ia:=i;
      s0:=length(pl[t,i].c,ball.c);
    END;
  if s0 < 10 then
  begin
    if t=left then h:=ia else ha:=ia;
    pl[t,ia].cn:=pl[t,ia].c;
    show(tact,dt,h,ha);
  end
  else
  begin
    if t=left then h:=ia else ha:=ia;
    pl[t,ia].cn:=ball.c;
    show(tact,dt,h,ha);
  end;
end;

procedure kick(var h: amplua);
const u=300; dy2=80;
var
  p,ch,k,y: integer;
  cf: coord;
  s0: real;
  t0: teams;
  a: amplua;
begin
randomize;
k:=random(10);
p:=random(2);
p:=p-1;
if t= left  then
  begin
    flvc(m[7],n[4],cf);
    s0:=length(ball.c,cf);
    ch:=trunc(k*s0/U);
    y:=n[4]+p*(dy2-ch);
    flvc(m[7],y,ball.cn);
  end
  else
  begin
    flvc(m[7],n[4],cf);
    s0:=length(ball.c,cf);
    ch:= trunc(k*s0/U);
    y:=n[4]+p*(dy2-ch);
    flvc(m[7],y,ball.cn);
  end;
  goal:= (not ballconnect(ball.c,ball.cn,a,t)) and (y<dy2);
  if goal then begin glt:=t; glh:=h; end
  else findpl end;
end;

procedure lgpas(var h: amplua);
const d=200;
begin
  flvc(pl[t,h].c[1]+d*pl[t,h].vec[1],pl[t,h].c[2]+d*pl[t,h].vec[2],ball.cn);
  findpl;
end;

function eqcoord(c1,c2: coord): boolean;
begin
  eqcoord:=false;
  if (c1[1]=c2[1]) and (c1[2]=c2[2]) then eqcoord:=true;
end;

procedure drawField(x1,y1: integer);
const k =20; dx=7; dy2=80;
begin
  {gates}
  setviewport(0,0,getmaxx,getmaxy,true);
  setfillstyle(7,7);
  setlinestyle(0,4,3);
  bar(x1-dx,y1+n[4]-dy2,x1,y1+n[4]+dy2);
  rectangle(x1-dx,y1+n[4]-dy2,x1,y1+n[4]+dy2);
  bar(x1+m[7],y1+n[4]-dy2,x1+m[7]+dx,y1+n[4]+dy2);
  rectangle(x1+m[7],y1+n[4]-dy2,x1+m[7]+dx,y1+n[4]+dy2);
  {field}
  setviewport(x1,y1,x1+m[7],y1+n[7],false);
  setfillstyle(1,2);
  bar(m[1],n[1],m[7],n[7]);
  line(m[4],n[1],m[4],n[7]);
  rectangle(m[1],n[1],m[7],n[7]);
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

  procedure search(var h: amplua; t: teams);
    var i: amplua;
    s0: real ;
    begin
      chteam(t);
      s0:=1900;
        for i:=fw to gk do
        if s0>length(pl[t,i].c,ball.c) then
        begin
          h:=i;
          s0:=length(pl[t,i].c,ball.c);
        end;
    end;

  procedure nab(ha: amplua);
    begin
      if pl[right,ha].c[1]< ball.c[1] then flvc(1,pl[right,ha].vec[2],pl[right,ha].vec)
      else flvc(-1,pl[right,ha].vec[2],pl[right,ha].vec);
      if pl[right,ha].c[2]< ball.c[2] then flvc(pl[right,ha].vec[1],1,pl[right,ha].vec)
      else flvc(pl[right,ha].vec[2],-1,pl[right,ha].vec);
    end;

procedure editc(var c: coord; j,k,j0: integer);
       begin
         c[j]:=c[j]+k;
         if abs(c[j])>1 then
         begin
           c[j0]:=0;
           c[j]:=c[j]-k;
         end;
       end;
{..............................................................}
BEGIN
  formmas(0,620,m);
  formmas(0,420,n);
  for k:=left to right do
    for i:=fw to gk do pl[k,i].init(k,i,m,n);
  ball.init(m[4],n[4]);
  drawField(10,30);
  ball.draw;
  for k:=left to right do
    for i:=fw to gk do pl[k,i].draw;

  findpl;
  goal:=false;
  while true do
  begin
    if transf(KB,d) then halt;
    if t=left then
    case d of
      ka: lgpas(h);
      ks: pas(h);
      kw: rpas(h);
      kd: kick(h);
      up: editc(pl[left,h].vec,2,-1,1);
      dw: editc(pl[left,h].vec,2,1,1);
      rt: editc(pl[left,h].vec,1,1,2);
      lf: editc(pl[left,h].vec,1,-1,2);
    end
    else case d of
      up: editc(pl[left,h].vec,2,-1,1);
      dw: editc(pl[left,h].vec,2,1,1);
      rt: editc(pl[left,h].vec,1,1,2);
      lf: editc(pl[left,h].vec,1,-1,2);
    end;

    if t=right then search(h,t) else search(ha,t);

      if t=left then
      for i:=fw to gk do
      begin
        if i=h then h:=i else atk(pl[left,i]);
        if i=ha then nab(ha) else dtk(pl[right,i]);
      end
      else
        for i:= fw to gk do
      begin
        if i=h then h:=i else dtk(pl[left,i]);
        if i=ha then kiborg(ha) else atk(pl[right,i]);
      end;
    show(tact,dt,h,ha);


    if goal then break;
  end;
  closegraph;
END;

 {.....................................................................}
var gd,gm: integer;
tm: teams;
am: amplua;
procedure drawscr(x1,y1: integer; c1,c2: word);
begin
  drawball(x1+r1,y1-2*r2+r1,r1);
  drawplr(x1+3*r2,y1-r2,r2,c1);
  drawplr(x1+5*r2+2*cxscr+2*ctm,y1-r2,r2,c2);
end;

BEGIN
  gd:=detect;
  initgraph(gd,gm,'');
  initkeyboard(KB,f);
  drawscr(kx1,ky1,3,2);
  getmem(pl,imagesize(kx1+2*r2,ky1,kx1+4*r2,ky1-2*r2));
  getimage(kx1+2*r2,ky1,kx1+4*r2,ky1-2*r2,pl^);
  getmem(pr,imagesize(kx1+4*r2+2*cxscr+2*ctm,ky1,kx1+6*r2+2*cxscr+2*ctm,ky1-2*r2));
  getimage(kx1+4*r2+2*cxscr+2*ctm,ky1,kx1+6*r2+2*cxscr+2*ctm,ky1-2*r2,pr^);
  game(tm,am);
  freemem(pl,imagesize(kx1+2*r2,ky1,kx1+2*r2+2*r1,ky1+2*r2));
  freemem(pr,imagesize(kx1+2*r2,ky1,kx1+2*r2+2*r1,ky1+2*r2));
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