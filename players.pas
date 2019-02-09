{ Unit football;
INTERFACE }

const
  c1 = 2;
  c2 = 2;
  c3 = 7;
  cs = 10;

type
  teams = (left, right);
  amplua = (fw, mr, ml, mo, dl, dr, gk);
  coord =array[0..c1] of integer;
  str = string[cs];
  cmas = array [0..c3] of integer;

  ball = object
    c: coord;
    vec: coord;
    cc: coord;
    b: boolean;
  end;
 
  plr = object
    name: str;
    num: byte;
    vec: coordinate;
    c: coord;
    cc: coord;
    team: teams;
    amp: amplua;
    now: boolean;
    constructor init(t0: teams; a0:amplua {s0:str; n0: byte});
    procedure draw;
    procedure mc;
  end;
  
  procedure mc;
  begin
    for i:=1 to 2 do inc(c[i],vec[i]);
  end;
  
  procedure chteam(var t: team);
  begin
    if t=right then t:=left
    else t:=right;
  end;
  
  procedure formMas(x1,x2: integer): cmas;
  var
    x4: integer;
  begin
    x4:=trunc( (x2-x1) div 4);
    for i:=1 to c3 m[i]:= x1+(i-1)*x4;
  end;
  
function flvC(x,y: integer): coord;
begin
  flvc[1]:=x;
  flvc[2]:=y;
end;

  function choosecoord(a,m,n);
    const k:=10;
    begin
      case a of
        fw: choosecoord:=flvc(m[3]-k,n[3]);
        mr: choosecoord:=flvc(trunc((m[2]+m[3]) div 2),trunc((n[1]+n[2]) div 2));
        ml: choosecoord:=flvc(trunc((m[2]+m[3]) div 2),trunc((n[3]+n[4]) div 2));
        mo: choosecoord:=flvc(m[2]+2*k,n[2]);
        dl: choosecoord:=flvc(m[2],n[2]);
        dr: choosecoord:=flvc(m[4],n[4]);
        gk: choosecoord:=flvc(m[1]+k,n[2]);
    end;

  constructor plr.init;
  var m,n : cmas;
  begin
    team:=t0;
    amp:=a0;
    name:=s0;
    num:=n0;
    now:=false;
    for i:=1 to 2 do vec[i]:=0;
    m:=formMas(cx1,cx2);
    n:=formMas(cy1,cy2);
    c:=chosecoord(amp,m,n);
    if team = right then c[1]:=2*m[2]-c[1];
  end;
  
  procedure plr.draw;
  var
  begin
    putimage(x-r,y-r,p^,xorput);
  end;
  

{IMPLAMANTATION }


function length(c1,c2: coord): real;
begin
  length:=sqrt (sqr(c1[1] - c2[1])+sqr(c1[2] - c2[2]))
end;

function outsgn2(t: integer):integer;
begin
  if abs(t)>1 then outsign:=0 else outsign:=t;
end;
function ceil2(t: integer): integer;
begin
  if abs(t)>1 then ceil2:=trunc(t div abs(t)) else ceil2:=t;
end;

procedure GAME;
const cp:=7;
type players = array[teams,amplua] of plr;
var
  pl: players;
  
procedure field(x01,x02,y01,y02);
const
x1:=10;
x2:=630;
y1:=30;
y2:=450;
var
begin
  setvievport(x1,y1,x2,y2,false);
  rectangle(0,0,620,420);
  x01:=x1; x02:=x2; y01:=y1; y02:=y2;
end;


  
function lgpas;
begin

end;


function ballconnect(const c1,c2: coord; var h: amplua; t: teams): boolean;
begin
  ballconect:=true;
  for i:=fw to gk do
    if (pl[t,i].c[1]>c1[1) then if (pl[t,i].c[1]<c2[1]) then if (pl[t,i].c[2]>c1[2]) then if (pl[t,i].c[2]<c2[2])
    then if dis(c1,c2,pl[t,i].c)<5 then
    begin
      t:=i
      ballconect:=false;
      exit;
    end;
end;
{ function dis(c1,c2,c0: coord): real;
var a,b,c,t: real;
begin
  a:=1/(c2[1]-c1[1]);
  b:=1/(c1[2]-c2[2]);
  c:=c1[1]*a-c1[2]*b;
  t:=1/sqrt(sqr(a)+sqr(b));
  dis:=abs(a*t*c0[1]+b*t*c0[2]+c*t);
end;}

function pas(var h: amplua): boolean;
begin
  c0[1]:=pl[k,h].c[1]+5*vec[2];
  c0[2]:=pl[k,h].c[2]+5*vec[2];
  for i:= fw to gk do
  begin
    s0:=900;
    if s0>length(plrl[h].c,plrl[i].c) then
    begin
      k:=i;
      s0:=length(plrl[h].c,plrl[i].c
    end;
  end;
  for i:=1 to 2 do plrl[h].vec[i]:=0;
  p:=ballconnect();
  if p then
  begin
    ball.c:=plrl[k].c;
    ball.vec:=flvC(plr[k].c[1]-plr[h].c[1],plr[k].c[2]-plr[h].c[2]);
    h:=k;
  end
  else
  begin
  
  
  end;
end;

function rpas;
begin

end;

function kick;
begin



end;                         {

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
end;
   {
    procedure findpl(var t: teams, h: amplua);
    var
      s0: real;
      i: amplua;
    begin
      s0:=900;
    for t:=left to right
    for h:=fw to gk do
    if s0 < length(pl[t,h].c,ball.c) then
    begin
      h:=i;
      s0:= length(pl[t,h].c,ball.c);
      if s0 < 10 then
      begin
        ball.cn:=pl[t,h].c;
        pl[t,h].vec:=flv(0,0);
        exit;
      end
      else
      begin
        pl[t,h].cn:=ball.c;
        ball.vec:=0;
      end;
    end;


    function eqcoord(c1,c2: coord): boolean
    begin
      eqcoord:=false;
      if (c1[1]=c2[1]) and (c1[2]=c2[2]) then eqcoord:=true;
    end;
       }

   procedure drawField(x1,y1,x2,y2: integer; var m,n: cmas);
begin
  k:=20;

  setviewport(x1,y1,x1+x2,y1+y2,false);
  setfillstyle(1,2);
  formmas(0,x2,m);
  formmas(0,y2,n);
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
  setviewport(0,y1,getmaxx,getmaxy,true);
  setfillstyle(7,7);
  inc(n[3],10); dec(n[5],10);
  bar(0,n[3],x1,n[5]);
  rectangle(0,n[3],x1,n[5]);
end;
BEGIN
  {field}
   drawField(10,30,620,420,m,n);
  for k:=left to right do
  for i:=fw to gk do
  begin
    pl[k,i].init(k,i);
    pl[k,i].draw;
  end;
  
  while true do
  begin
  
    findpl(t,h);
       
    if t=left then
      d:=transf(KB)
    else d:=kiborg

        case d of
        ka: h:=lgpas
        ks: h:=pas;
        kw: h:=rpas;
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


           for k:=left to rigth
           for a:=fw to gk do
           if (k=t) and (a=h) then continue
           else if (k=t) then atk(pl[k,a])
                         else dtk(pl[k,a]);

           
          for k:=left to right do
          for i:=fw to gk do
            if eqcoord(pl[k,i]cn,pl[k,i].c) then pl[k,i].cn:=flv(pl[k,i].c[1]+pl[k,i].vec[1],pl[k,i].c[2]+pl[k,i].vec[2]);
           
          for i:=1 to 25 do
          begin
            for k:=left to right do
            for i:=fw to gk do pl[k,i].draw(c[1]+trunc(cn[1]*i/25),c[2]+trunc(cn[2]*3*i));
            ball.draw(c[2]+trunc(cn[2]*i/25),c[2]+trunc(cn[2]*i/25));
            delay(110);
            for k:=left to right do
            for i:=fw to gk do pl[k,i].draw(c[1]+trunc(cn[1]*i/25),c[2]+trunc(cn[2]*3*i));
            ball.draw(c[2]+trunc(cn[2]*i/25),c[2]+trunc(cn[2]*i/25));
          end;
    end;
    
    
    
  {if goal then break}
  
  end;
  {score goal}
end;