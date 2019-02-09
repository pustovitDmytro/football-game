Unit  Menu;

interface

USES crt,graph;

type mat = array [1..8] of byte;

CONST
  nx = 3;
  ny = 3;
  cb = 0;
  c0 = 5;
  Al:mat =(3,1,2,8,6,7,5,4);
  Au:mat =(7,6,5,3,4,2,8,1);
  Ad:mat =(8,6,4,5,3,2,1,7);
  Ar:mat =(2,3,1,8,7,5,6,4);

procedure printtext(s:string; x,y: integer; c2: word);
procedure NDraw(lx,ly,i: integer);
procedure createbox (s: string; x1,y1,x2,y2: integer; c1,c2: word; now: boolean);

implementation

procedure printtext;
begin
  setcolor(c2);
  settextstyle(3,0,1);
  settextjustify(1,1);
  outtextxy(x,y,s);
end;

procedure createbox;
  const
    k1=50;
    k2=40;
    k3=45;
    k4=35;
  var
    x,y: integer;
  begin
    setcolor(c1);
    rectangle(x1+k2,y1+k2,x2-k2,y2-k2);
    setfillstyle(1,c1);
    bar(x1+k1,y1+k1,x2-k1,y2-k1);
    if now then
    begin
      setcolor(c0);
      rectangle(x1+k3,y1+k3,x2-k3,y2-k3);
      rectangle(x1+k4,y1+k4,x2-k4,y2-k4);
      SetUserCharSize(10,1,2,1);
    end
    else
    begin
      setcolor(cb);
      rectangle(x1+k3,y1+k3,x2-k3,y2-k3);
      rectangle(x1+k4,y1+k4,x2-k4,y2-k4);
    end;
    x:= (x1+x2) div 2;
    y:= (y1+y2) div 2;
    printtext(s,x,y,c2);
  end;

 procedure NDraw;
  begin
    createbox('1 Player',1,1,lx,ly,3,4, 1=i );
    createbox('2 Players',lx,1,2*lx,ly,1,3, 2=i);
    createbox('Tournament',2*lx,1,3*lx,ly,2,4, 3 = i);
    createbox('Training',1,ly,lx,2*ly,1,2, 8=i);
    createbox('Help',2*lx,ly,3*lx,2*ly,3,4, 4 =i);
    createbox('Settings',1,2*ly,lx,3*ly,3,2, 7 = i );
    createbox('About',lx,2*ly,2*lx,3*ly,4,1, 6 = i);
    createbox('Exit',2*lx,2*ly,3*lx,3*ly,4,3, 5 = i);
  end;
                             {
  Procedure IMg(x1,y1,x2,y2);
  const k:=10;
  var
  
  begin
    inc(x1,k); dec(x2,k);
    inc(y1,k); dec(y2,k);
  end;                        }
  

END.