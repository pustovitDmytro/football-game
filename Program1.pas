program try1;
uses graph;
const c3 = 7;
type cmas = array [0..c3] of integer;

var k,x1,y1,x2,y2,gd,gm,i: integer;
    p: pointer;
    m1: array[1..20]of integer;
    m,n: cmas;
procedure formMas(x1,x2: integer; var m: cmas);
  var
    x4: integer;
  begin
    x4:=trunc( (x2-x1) div (c3-1));
    for i:=1 to c3 do m[i]:= x1+(i-1)*x4;
  end;

function newpoly(const n,r,f0: word; s0: string): pointer;
  const
    x0=40;
    y0=40;
  var
    p: pointer;
    size,k,x1,x2,y1,y2: byte;
  begin
    if n>0 then
    begin
      setlinestyle(0,1,1);
      for k:=1 to n do
      begin
       x1 := Trunc(x0+r +r*Cos(f0+2*pi*(k)/n));
       y1 := Trunc(y0+r +r*Sin(f0+2*pi*(k)/n));
       x2 := Trunc(x0+r +r*Cos(f0+2*pi*(k+1)/n));
       y2 := Trunc(y0+r +r*Sin(f0+2*pi*(k+1)/n));
       for k:=0 to r do
       begin
         line(x1,y1,x2,y2);
       end
      end;
    end
    else circle(x0+r,y0+r,r);
    settextjustify(1,1);
    outtextxy(x0+r,y0+r,s0);
    size:=imagesize(x0,y0,x0+2*r,y0+2*r);
    getmem(p,size);
    getimage(x0,y0,x0+2*r,y0+2*r,p^);
    putimage(x0,y0,p^,xorput);
    newpoly:=p;
  end;

begin
  gd:= detect;
  initgraph(gd,gm,'');
  setbkcolor(0);
  for i:=1 to 10 do
  begin
    setcolor(i);
    setfillstyle(i,i);
    setviewport(70,20,100,100,false);
    bar(10,10*i,20,10+10*i);
    setlinestyle(i,7,1);
    line(40,10*i,80,15+10*i);
    line(90,10*i,180,10*i)
  end;
  setviewport(400,30,600,400,false);
  for i:=1 to 15 do
  begin
    settextstyle(i,0,5);
    outtextxy(15,10*i,'Font');
    readln;
    cleardevice;
  end;
  {circle(20,20,3);}
  setviewport(20,20,40,40,false);
  {circle(20,20,8);}
  for i:=1 to 15 do
  begin
    setcolor(i);
    rectangle(1,10*i,10,10+10*i-2);
  end;
  setviewport(200,200,200,400,false);
  new(p);     {
  p:=newpoly(3,50,30,'');
  putimage(0,0,p^,xorput);
               }
  setfillstyle(1,2);
  pieslice(100,100,0,360,20);
  setfillstyle(2,3);
  pieslice(100,100,0,270,5);
  setviewport(0,0,100,100,false);
  rectangle(0,0,600,420);          {
  for i:=1 to 20 do
  m[i]:=imagesize(i,i+10,i+40,i+60);}
  readln;

  bar(0,0,getmaxx,getmaxy);

  x1:=10;
  y1:=30;
  x2:=620;
  y2:=420;
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
  
  
  


  readln;
  closegraph;                               {
  for i:=1 to 20 do
  writeln(m[i]);
  readln;                                    }
end.
