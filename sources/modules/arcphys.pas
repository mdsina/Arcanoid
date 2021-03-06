unit arcphys;

interface

uses arctypes;
function CollideRectangle(r1, r2: Rectangle):Boolean;
function CollideRight(r:Rectangle;player: rectangle; player_old_x:real):Boolean;
function CollideLeft(r:Rectangle;player: rectangle; player_old_x:real):Boolean;
function CollideBottom(r:Rectangle;player: rectangle; player_old_y:real):Boolean;
function CollideTop(r:Rectangle; player: rectangle; player_old_y:real):Boolean;

function CollideRectangle_p(r1, r2: Rectangle; width,height:integer):Boolean;
function CollideRight_p(r:Rectangle; player: rectangle; player_old_x:real; width:integer):Boolean;
function CollideLeft_p(r:Rectangle; player: rectangle; player_old_x:real; width:integer ):Boolean;
function CollideBottom_p(r:Rectangle; player: rectangle; player_old_y:real; height:integer):Boolean;
function CollideTop_p(r:Rectangle; player: rectangle; player_old_y:real; height:integer):Boolean;
function collide_scn_left(var tLeft: Rectangle; width: integer):boolean;
function collide_scn_right(var tRight: Rectangle; width: integer):boolean;
function collide_scn_up(var tup: Rectangle; height: integer):boolean;
function collide_scn_down(var tdown: Rectangle; height:integer):boolean;
implementation

//*********************
//*   ������������    *
//*********************

//������� �������� ����������� 2 ���������������
function CollideRectangle(r1, r2: Rectangle):Boolean;
begin
  CollideRectangle:= not(
  (r1.x > (r2.x + r2.width)) or
  (r2.x > (r1.x + r1.width)) or
  (r1.y > (r2.y + r2.height)) or
  (r2.y > (r1.y + r1.height)));
end;

function CollideRight(r:Rectangle;player: rectangle; player_old_x:real):Boolean;
begin
  CollideRight:=
  (player_old_x > (r.x + r.width)) and
  (player.x <= (r.x + r.width));
end;

function CollideLeft(r:Rectangle;player: rectangle; player_old_x:real):Boolean;
begin
  CollideLeft:=
  ((player_old_x + player.width) < r.x) and
  ((player.x + player.width) >= r.x);
end;

function CollideBottom(r:Rectangle;player: rectangle; player_old_y:real):Boolean;
begin
  CollideBottom:=
  (player_old_y > (r.y + r.height)) and
  (player.y <= (r.y + r.height));
end;

function CollideTop(r:Rectangle;player: rectangle; player_old_y:real):Boolean;
begin
  CollideTop:=
  ((player_old_y + player.height) < r.y) and
  ((player.y + player.height) >= r.y);
end;

function CollideRectangle_p(r1, r2: Rectangle; width,height:integer):Boolean;
begin
  CollideRectangle_p:= not(
  (r1.x > (r2.x*width + r2.width))   or
  (r2.x*width > (r1.x + r1.width))   or
  (r1.y > (r2.y*height + r2.height)) or
  (r2.y*height > (r1.y + r1.height)));
end;

function CollideRight_p(r:Rectangle;player: rectangle; player_old_x:real; width:integer):Boolean;
begin
  CollideRight_p:=
  (player_old_x > (r.x*width + r.width)) and
  (player.x <= (r.x*width + r.width));
end;

function CollideLeft_p(r:Rectangle;player: rectangle; player_old_x:real; width:integer ):Boolean;
begin
  CollideLeft_p:=
  ((player_old_x + player.width) < r.x*width) and
  ((player.x + player.width) >= r.x*width);
end;

function CollideBottom_p(r:Rectangle; player: rectangle;player_old_y:real; height:integer):Boolean;
begin
  CollideBottom_p:=
  (player_old_y > (r.y*height + r.height)) and
  (player.y <= (r.y*height + r.height));
end;

function CollideTop_p(r:Rectangle;player: rectangle; player_old_y:real; height:integer):Boolean;
begin
  CollideTop_p:=
  ((player_old_y + player.height) < r.y*height) and
  ((player.y + player.height) >= r.y*height);
end;

//��������� �� ������������ � ����� �������� ����
function collide_scn_left(var tLeft: Rectangle; width: integer):boolean;
begin
  if tLeft.x<=0.037*width
    then
      begin
        collide_scn_left:=true;
      end
    else
      begin
        collide_scn_left:=false;
      end;
end;

//��������� �� ������������ � ������ �������� ����
function collide_scn_right(var tRight: Rectangle; width: integer):boolean;
begin
   if (tRight.x + tRight.width) >= 0.72*width
    then
      begin
        collide_scn_right:=true;
      end
    else
      begin
        collide_scn_right:=false;
      end;
end;

//��������� �� ������������ � ������ �������� ����
function collide_scn_up(var tup: Rectangle; height: integer):boolean;
begin
   if tup.y<=0.042*height
    then
      begin
        collide_scn_up:=true;
      end
    else
      begin
        collide_scn_up:=false;
      end;
end;

//��������� �� ������������ � ������ �������� ����
function collide_scn_down(var tdown: Rectangle; height:integer):boolean;
begin
   if (tdown.y+tdown.height)>=0.95*height
    then
      begin
        collide_scn_down:=true;
      end
    else
      begin
        collide_scn_down:=false;
      end;
end;
end.
