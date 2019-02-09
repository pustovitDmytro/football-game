Unit Graphics;


interface

Uses Graph,CRT;

const
  c1 = 2;
  c3 = 7;
  kx1 = 10;
  ky1 = 30;
  cx1 = 620;
  cx2 = 420;
  ctm = 150;
  cxscr=50;
  r1=5;
  r2=10;

type
  cmas = array [1..c3] of integer;

procedure drawField(x1,y1: integer; m,n: cmas);
procedure drawpoly(const x0,y0,n: word;const  r,f0: real);
procedure drawball(x0,y0,r: integer);
procedure drawplr(const x,y,r,c: integer);
procedure drawscr(x1,y1: integer; c1,c2: word);
procedure  showgoal(s: string);
procedure music(a: boolean);
procedure watchrules;

implementation

procedure drawField;
const k =20; dx=7; dy2=60;
var i,j:integer;
begin
  setviewport(0,0,getmaxx,getmaxy,true);
  setfillstyle(7,7);
  setlinestyle(0,4,3);
  bar(x1-dx,y1+n[4]-dy2,x1,y1+n[4]+dy2);
  rectangle(x1-dx,y1+n[4]-dy2,x1,y1+n[4]+dy2);
  bar(x1+m[7],y1+n[4]-dy2,x1+m[7]+dx,y1+n[4]+dy2);
  rectangle(x1+m[7],y1+n[4]-dy2,x1+m[7]+dx,y1+n[4]+dy2);
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

procedure drawpoly;
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

procedure drawball;
var a,s: real;
m: integer;
 begin
   s:=r*sqrt(3/7)/2;
   a:=r/sqrt(7);
   setlinestyle(0,1,3);
   drawpoly(x0,y0,6,a,0);
   for m:=0 to 5 do drawpoly(trunc(x0+2*s*cos(m*pi/3+pi/6)),trunc(y0+2*s*sin(m*pi/3+pi/6)),6,a,0);
   circle(x0,y0,r);
   setlinestyle(0,1,1);
end;

procedure drawplr;
var c1: word;
 begin
   setcolor(c);
   setfillstyle(1,c);
   pieslice(x,y,0,360,r);
   randomize;
   IF random(2)=0 then c1:= (6 xor 2 )else c1 := 2;
   setfillstyle(1,c1);
   setcolor(c1);
   pieslice(x,y,0,360,4);
 end;
 
procedure  showgoal;
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


procedure drawscr;
begin
  drawball(x1+r1,y1-2*r2+r1,r1);
  drawplr(x1+3*r2,y1-r2,r2,c1);
  drawplr(x1+5*r2+2*cxscr+2*ctm,y1-r2,r2,c2);
end;

procedure music;
type musmas=array[1..3] of word;
const
      m1: musmas= (1000, 900, 1300); {sound}
      m2: musmas= (120,150,80); {sound}
var    i, y, x: integer;
       m: musmas;
 begin
  if a then m:=m1 else m:=m2;
  x:=40;
  y:=200;
  for i:=1 to 3 do
    begin
      sound(m[i]);
      if i=3 then y:=300;
      delay(y);
      nosound;
      delay(x);
    end;
end;

procedure watchrules;
begin
writeln('A player must bounce, solo or touch the ball on the ground once every 10 metres or six step.');
writeln('A maximum of two bounces per possession are allowed,');
writeln('while players can solo the ball as often as they wish on a possession.');
writeln(' Unlike in Gaelic football, the ball may be lifted');
writeln('directly off the ground, without putting a foot underneath it first.');
writeln(' Players however cannot scoop the ball off the ground to a team-mate,');
writeln('nor pick up the ball if they are on their knees or on the ground.');
writeln(' If a foul is committed, a free kick will be awarded, referees');
writeln('can give the fouled player advantage to play on at their discretion.');
 writeln;
writeln('Scoring in International rules football:');
writeln('The game uses two large posts and two small posts,');
writeln('as in Australian rules, and a crossbar and goal net as in Gaelic football.');
writeln;
repeat until readkey=#27;
end;

begin end.