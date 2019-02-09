Unit MGame;

Interface

USES
  settings, graph, crt, graphics;

type
  teams = (left, right);
  amplua=(fw, mr, ml, mo, dl, dr, gk);
  coord = array[1..c1] of integer;

  bal = object
    c: coord;
    vec: coord;
    cn: coord;
    constructor init(x,y: integer);
    procedure draw(pb: pointer);
    procedure mc;
  end;

  plr = object
    vec: coord;
    c: coord;
    cn: coord;
    team: teams;
    amp: amplua;
    constructor init(t0: teams; a0:amplua; m,n : cmas);
    procedure draw(p1,p2:pointer);
    procedure mc;
  end;

procedure chteam(var t: teams);
function eqcoord(c1,c2: coord): boolean;
procedure formMas(x1,x2: integer; var m: cmas);
procedure flvC(x,y: integer; var c: coord);
procedure choosecoord(a: amplua; m,n: cmas; var c: coord);
function length(c1,c2: coord): real;
Function square(a: coord; b: coord; c: coord): real;
function dis(c1,c2,c0: coord): real;
procedure dcoord(var c1: coord; c2: coord; o,i: integer);
function inrec(const d: integer; c1,c2,c0: coord): boolean;
procedure GAME(var glt: teams ;var glh: amplua; pb,pcl,pcr:pointer; kb:keyboard);

implementation

  procedure chteam;
  begin
    if t=right then t:=left
    else t:=right;
  end;

  function eqcoord;
  begin
  eqcoord:=false;
  if (c1[1]=c2[1]) and (c1[2]=c2[2]) then eqcoord:=true;
  end;

  procedure formMas;
  var
    x4,i: integer;
  begin
    x4:=trunc( (x2-x1) div (c3-1));
    for i:=1 to c3 do m[i]:= x1+(i-1)*x4;
  end;

  procedure flvC;
  begin
    c[1]:=x;
    c[2]:=y;
  end;

  procedure choosecoord;
  const k=40;
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
  flvc(0,0,vec);
end;

procedure bal.mc;
begin
  if eqcoord(c,cn) then flvc(c[1]+r2*vec[1],c[2]+r1*vec[2],cn);
  if cn[1]<r2 then begin cn[1]:=r2;  flvc(-vec[1],vec[2],vec); end;
  if cn[1]> (cx1-r2) then begin cn[1]:=cx1-r2;  flvc(-vec[1],vec[2],vec); end;
  if cn[2]<r2 then begin cn[2]:=r2;   flvc(vec[1],-vec[2],vec);  end;
  if cn[2]> (cx2-r2) then begin cn[2]:=cx2-r2;  flvc(vec[1],-vec[2],vec); end;
end;

procedure bal.draw;
begin
  putimage(c[1]-r1+1,c[2]-r1+1,pb^,xorput);
end;

constructor plr.init;
var q: integer;
begin
  team:=t0;
  amp:=a0;
  flvc(-1,-1,vec);
  choosecoord(amp,m,n,c);
  if team = right then begin c[1]:=m[7]-c[1]; c[2]:=n[7]-c[2]; end;
  cn:=c;
end;

procedure plr.mc;
begin
  if eqcoord(c,cn) then flvc(c[1]+r2*vec[1],c[2]+r2*vec[2],cn);
  if cn[1]<r2 then begin cn[1]:=r2;  flvc(-vec[1],vec[2],vec); end;
  if cn[1]> (cx1-r2) then begin cn[1]:=cx1-r2;  flvc(-vec[1],vec[2],vec); end;
  if cn[2]<r2 then begin cn[2]:=r2;   flvc(vec[1],-vec[2],vec);  end;
  if cn[2]> (cx2-r2) then begin cn[2]:=cx2-r2;  flvc(vec[1],-vec[2],vec); end;
end;

procedure plr.draw;
begin
  if team =left then putimage(c[1]-r2,c[2]-r2,p1^,xorput)
  else putimage(c[1]-r2,c[2]-r2,p2^,xorput);
end;


function length;
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

Function square;
var
  ab,ac: coord;
  i: integer;
begin
  for i:=1 to 2 do
  begin
    ab[i]:=(b[i]-a[i]) div 10;
    ac[i]:=(c[i]-a[i]) div 10;
  end;
  square:= abs(ab[1]*ac[2] - ab[2]*ac[1])/2;
end;


function dis;
var d,s,l: real;
begin
  s:=square(c1,c2,c0);
  l:=length(c1,c2);
  if s=0 then begin dis:=0; exit; end;
  if l=0 then begin dis:=length(c1,c0); exit; end;
  d:=200*s/l;
  dis:=d;
end;

procedure dcoord;
var c0: coord;
k: integer;
begin
  for k:=1 to 2 do
  begin
  c0[k]:=(o*c1[k]-i*c2[k]) div (o-i);
  c1[k]:=c1[k]+((c2[k]-c0[k]) div o)
  end;
end;

function inrec;

  function znack(a,b: integer): integer;
  begin
    znack:=-1;
    if a=b then exit
    else
    znack:= (a-b) div abs(a-b)
  end;

var i1,i2:longint;
i:boolean;
begin
  if c1[1]>c2[1] then
  begin
    inc(c1[1],d);
    dec(c2[1],d);
  end
  else
  begin
    inc(c2[1],d);
    dec(c1[1],d);
  end;
  if c1[2]>c2[2] then
  begin
    inc(c1[2],d);
    dec(c2[2],d);
  end
  else
  begin
    inc(c2[2],d);
    dec(c1[2],d);
  end;
  i:=false;
  i1:=znack(c1[1],c0[1])*znack(c2[1],c0[1]);
  i2:=znack(c1[2],c0[2])*znack(c2[2],c0[2]);
  inrec:=(i1<0) and (i2<0);
end;

{-------------       ---------------------       --------------------}

procedure GAME;

const cp=7;
tact = 4;
dt = 10;

type players= array[teams,amplua] of plr;

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


function ballconnect(const c1,c2: coord; var h: amplua; var t: teams): boolean;
const d1 =15; d2=25;
var i: amplua;
begin
  ballconnect:=true;
  chteam(t);
  for i:=fw to gk do
  if inrec(d1,c1,c2,pl[t,i].c) and (dis(c1,c2,pl[t,i].c)<d2) then
    begin
      h:=i;
      ballconnect:=false;
      ball.cn:=pl[t,h].c;
      exit;
    end;
    chteam(t);
end;

procedure pas(var h: amplua; var ha: amplua);
const lg=400; d=90;
var
  am,i: amplua;
  t0: teams;
  m: integer;
  s0: real;
  p: boolean;
  c0: coord;
begin
  s0:=1900;
  flvc(pl[t,h].c[1]+lg*pl[t,h].vec[1],pl[t,h].c[2]+lg*pl[t,h].vec[2],c0);
  for i:= fw to gk do
    if inrec(d,pl[t,h].c,c0,pl[t,i].c) then
    if (s0>length(pl[t,h].c,pl[t,i].c)) then
    begin
      am:=i;
      s0:=length(pl[t,h].c,pl[t,i].c);
    end;
    if am=h then exit;
  flvc(0,0,pl[t,am].vec);
  if ballconnect(pl[t,h].c,pl[t,am].c,h,t) then
  begin
    h:=am;
    ball.cn:=pl[t,h].c;
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
  if ballconnect(pl[t,h].c,pl[t,i].cn,h,t) then
  begin
    h:=am;
    ball.cn:=pl[t,h].cn;
  end;
end;

procedure perimetr(var pl: plr;const  a1,b1,a2,b2: integer; k: teams);
const speed=4;
var x1,x2,y1,y2: integer;
c0: coord;
begin
  if k=right then
  begin
    x1:=m[7]-a2;
    x2:=m[7]-a1;
  end
  else
  begin
    x1:=a1;
    x2:=a2;
  end;
  y1:=b1;
  y2:=b2;
  if (pl.cn[1]<x2) and (pl.cn[1]>x1) and (pl.cn[2]>y1) and (pl.cn[2]<y2) then
  begin
    if pl.cn[1]< x1+r2 then flvc(-pl.vec[1],pl.vec[2],pl.vec);
    if pl.cn[1]> x2-r2 then flvc(-pl.vec[1],pl.vec[2],pl.vec);
    if pl.cn[2]< y1+r2 then flvc(pl.vec[1],-pl.vec[2],pl.vec);
    if pl.cn[2]> y2-r2 then flvc(pl.vec[1],-pl.vec[2],pl.vec);
  end
  else
  begin
    flvc((x1+x2) div 2,(y1+y2) div 2,c0);
    dcoord(pl.cn,c0,speed,1);
    flvc(1,1,pl.vec);
  end;
end;


procedure atk(var p: plr);
begin
    case p.amp of
      fw: perimetr(p,m[4],n[3],m[7],n[5],p.team);
      mr: perimetr(p,m[4],n[5],m[6],n[7],p.team);
      ml: perimetr(p,m[4],n[1],m[6],n[3],p.team);
      mo: perimetr(p,m[1],n[1],m[7],n[7],p.team);
      dl: perimetr(p,m[2],n[1],m[4],n[3],p.team);
      dr: perimetr(p,m[2],n[5],m[4],n[7],p.team);
      gk: perimetr(p,m[1],n[2],m[2],n[6],p.team);
    end;
end;

procedure dtk(var p: plr);
const k=40;
begin
  case p.amp of
    fw: perimetr(p,m[2],n[2],m[4],n[5],p.team);
    mr: perimetr(p,m[2],n[5],m[4],n[7],p.team);
    ml: perimetr(p,m[2],n[1],m[4],n[3],p.team);
    mo: perimetr(p,m[2],n[2],m[3],n[6],p.team);
    dl: perimetr(p,m[1],n[1],m[2],n[3],p.team);
    dr: perimetr(p,m[1],n[5],m[2],n[7],p.team);
    gk: perimetr(p,m[1],n[4]-k,m[1]+k,n[4]+k,p.team);
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
      end;
   if eqcoord(ball.c,ball.cn) then
   begin
    if t = left then
    begin
      if ballconnect(ball.c,ball.cn,ha,t) then ball.cn:=pl[t,h].cn;
    end
    else
    begin
      if ballconnect(ball.c,ball.cn,h,t) then ball.cn:=pl[t,ha].cn;
    end;
   end
   else ball.mc;
   for q:=1 to tact do
   begin
      for k:=left to right do
        for i:=fw to gk do
        begin
          dcoord(pl[k,i].c,pl[k,i].cn,tact,q-1);
          pl[k,i].draw(pcl,pcr);
        end;
        dcoord(ball.c,ball.cn,tact,q-1);
        ball.draw(pb);
        delay(dt);
        for k:=left to right do
          for i:=fw to gk do pl[k,i].draw(pcl,pcr);
        ball.draw(pb);
   end;
end;

procedure findpl;
var
  s0: real;
  i,ia: amplua;
  ti: teams;
  q:integer;
begin
  s0:=1900;
  for ti:=left to right do
    for i:=fw to gk do
    if s0>length(pl[ti,i].c,ball.cn) then
    begin
      t:=ti;
      ia:=i;
      s0:=length(pl[t,i].c,ball.cn);
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
    pl[t,ia].cn:=ball.cn;
    show(tact,dt,h,ha);
  end;
end;

procedure kick(var h: amplua; var ha: amplua);

function kickch(x: real; max,dy2: integer): integer;
var k,kr,y,L: integer;
begin
  randomize;
  k:=random(18); k:=k+5;
  kr:=10;
  write('| k= ',k,' ');
  if k mod 7 = 0 then l:= 70
  else l:=-trunc(dy2*k*x/(max*kr));
  k:=k mod 2;
  if k=0 then k:=-1;
  kickch:=n[4]+k*(dy2+l);
end;

const max =250; dy2=60;
var
  p,ch,k,y: integer;
  cf: coord;
  s0: real;
  t0: teams;
  a: amplua;
begin
  if t= left  then p:=7 else p:=1;
  flvc(m[p],n[4],cf);
  s0:=length(ball.c,cf);
  y:=kickch(s0,max,dy2);
  flvc(m[p],y,ball.cn);
 if ballconnect(ball.c,ball.cn,ha,t) then
  begin
    goal:=((y<n[4]+dy2) and (y>n[4]-dy2));
    if goal then begin glt:=t; glh:=h; end
    else begin show(tact,dt,h,ha); findpl; end;
  end
  else ball.cn:=pl[t,ha].c;
end;

procedure lgpas(var h: amplua);
const d=200;
begin
  flvc(pl[t,h].c[1]+d*pl[t,h].vec[1],pl[t,h].c[2]+d*pl[t,h].vec[2],ball.cn);
  show(tact,dt,h,ha);
  findpl;
end;

function eqcoord(c1,c2: coord): boolean;
begin
  eqcoord:=false;
  if (c1[1]=c2[1]) and (c1[2]=c2[2]) then eqcoord:=true;
end;

procedure kiborg(var h: amplua; var ha: amplua);
const
 a1=250;
 a2=350;
var c: coord;
l: real;
begin
  randomize;
  flvc(-1,random(3)-1,pl[t,h].vec);
  flvc(m[1],n[4],c);
  l:=length(pl[t,h].c,c);
  if l<a1 then kick(h,ha)
  else if l<a2 then flvc(-1,-pl[t,h].vec[2],pl[t,h].vec)
       else
       begin
         pas(h,ha);
         if eqcoord(ball.cn,ball.cn) then flvc(-1,-pl[t,h].vec[2],pl[t,h].vec);
       end;
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
  formmas(0,cx1,m);
  formmas(0,cx2,n);
  for k:=left to right do
    for i:=fw to gk do pl[k,i].init(k,i,m,n);
  ball.init(m[4],n[4]);
  drawField(kx1,ky1,m,n);
  findpl;
  goal:=false;
  while true do
  begin
    if transf(KB,d) then halt;
    if t=left then
    case d of
      ka: lgpas(h);
      ks: pas(h,ha);
      kw: rpas(h);
      kd: kick(h,ha);
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
        if i=ha then kiborg(ha,h) else atk(pl[right,i]);
      end;
    show(tact,dt,h,ha);
    if goal then begin readln; break; end;
  end;
END;

begin end.