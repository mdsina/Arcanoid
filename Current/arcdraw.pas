unit arcdraw;
interface

{$mode objfpc}
uses gl, glu, arctypes, Classes;
procedure draw_quad(_x, _y, _width, _height :real);
procedure draw_quad_p(_x, _y, _width, _height :real; width, height: integer);
procedure draw_quad(r: Rectangle);
procedure draw_quad_p(r: Rectangle; width, height: integer);
procedure draw_quad_c(_x, _y, _width, _height :real);
procedure draw_quad_c(r: Rectangle);
procedure draw_quad_cp(_x, _y, _width, _height :real; width, height: integer);
procedure draw_quad_cp(r: Rectangle; width, height: integer);
procedure draw_quad_with_shift(_x, _y, _width, _height, shift :real; Fframes:integer);
procedure draw_quad_with_shift_p(r: Rectangle; width, height: integer; shift :real; Fframes:integer);
function GL_Y_FIX ( f : integer ): real;
function GL_Y_FIX ( f : real ): real;

type PAnimation = class
protected
  FPicture:GlUint;
  FFrameTime:integer;
  FCurrentTime:integer;
  FStoped:boolean;
  FFrames: integer;
  _r : Rectangle;
public
  Constructor Create(FrameTime:integer; rand: integer);

  Procedure   AddFrame(Picture:glUint; fCount, width, height: integer);
  Procedure   Start();
  Procedure   Stop();
  Procedure   Update(dt:integer);
  Procedure   Draw(x,y: integer);
  Procedure   Draw_p(r: Rectangle; width , height: integer);
end;

implementation

Constructor PAnimation.Create(FrameTime:integer; rand: integer);
begin
  FFrameTime:=FrameTime;
  FCurrentTime:=rand;
  FStoped:=true;
end;

function GL_Y_FIX ( f : integer ): real;
begin
    GL_Y_FIX := 1 - f;
end;  

function GL_Y_FIX ( f : real ): real;
begin
    GL_Y_FIX := 1 - f;
end;  

Procedure   PAnimation.AddFrame(Picture:glUint; fCount, width, height: integer);
begin
  FPicture:=Picture;
  FFrames := fCount;
  _r.width  := width; _r.height := height;
end;

Procedure   PAnimation.Start();
begin
  FStoped:=false;
end;

Procedure   PAnimation.Stop();
begin
  FStoped:=true;
end;

Procedure   PAnimation.Update(dt:integer);
begin
  if FStoped then
    Exit;

  FCurrentTime+=dt;
  if FCurrentTime>=FFrames*FFrameTime then
    FCurrentTime:=0;
end;

Procedure   PAnimation.Draw(x,y: integer);
var
  Frame:integer; shift: real;
begin
  Frame:=FCurrentTime div FFrameTime;
  shift:= (((Frame * (_r.width/FFrames)) * 100 ) / _r.width) / 100;

  glBindTexture(GL_TEXTURE_2D, FPicture);
  draw_quad_with_shift(x,y, _r.width/FFrames, _r.height, shift, FFrames);
end;

Procedure   PAnimation.Draw_p(r: Rectangle;  width , height: integer);
var
  Frame:integer; shift: real;
begin
  Frame:=FCurrentTime div FFrameTime;
  shift:= (((Frame * (_r.width/FFrames)) * 100 ) / _r.width) / 100;

  glBindTexture(GL_TEXTURE_2D, FPicture);
  draw_quad_with_shift_p(r, width, height, shift, FFrames);
end;


procedure draw_quad_with_shift(_x, _y, _width, _height, shift :real; Fframes:integer);
var _x01,_x02 : real;
begin

  _x01 := shift; _x02 := shift + (1 / Fframes);

  glBegin( GL_QUADS );
    glTexCoord2f(_x01, 0.0);   glVertex2f(_x, _y + _height);
    glTexCoord2f(_x02, 0.0);   glVertex2f(_x + _width, _y + _height);
    glTexCoord2f(_x02, 1.0);   glVertex2f(_x + _width, _y);
    glTexCoord2f(_x01, 1.0);   glVertex2f(_x, _y);
  glEnd();

end;

procedure draw_quad_with_shift_p(r: Rectangle; width, height: integer; shift :real; Fframes:integer);
var _x01,_x02, _x, _y : real;
begin

  _x01 := shift; _x02 := shift + (1 / Fframes);
  _x := r.x * width; _y := r.y * height;
  glBegin( GL_QUADS );
    glTexCoord2f(_x01, 0.0);   glVertex2f(_x, _y + r.height);
    glTexCoord2f(_x02, 0.0);   glVertex2f(_x + r.width, _y + r.height);
    glTexCoord2f(_x02, 1.0);   glVertex2f(_x + r.width, _y);
    glTexCoord2f(_x01, 1.0);   glVertex2f(_x, _y);
  glEnd();

end;

//ðèñóåì íàø êâàä. 0:0 - âåðõíèé ëåâûé óãîë//
procedure draw_quad(_x, _y, _width, _height :real);
begin

  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_x, _y + _height);
    glTexCoord2f(1.0, 0.0); glVertex2f(_x + _width, _y + _height);
    glTexCoord2f(1.0, 1.0); glVertex2f(_x + _width, _y);
    glTexCoord2f(0.0, 1.0); glVertex2f(_x, _y);
  glEnd();
end;

procedure draw_quad_p(_x, _y, _width, _height :real; width, height: integer);
var _bx,_by:real;
begin
  _bx:=width*_x;
  _by:=height*_y;
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_bx, _by + _height);
    glTexCoord2f(1.0, 0.0); glVertex2f(_bx + _width, _by + _height);
    glTexCoord2f(1.0, 1.0); glVertex2f(_bx + _width, _by);
    glTexCoord2f(0.0, 1.0); glVertex2f(_bx, _by);
  glEnd();
end;

//ðèñóåì íàø êâàä. 0:0 - âåðõíèé ëåâûé óãîë//
procedure draw_quad(r: Rectangle);
begin

  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(r.x, r.y + r.height);
    glTexCoord2f(1.0, 0.0); glVertex2f(r.x + r.width, r.y + r.height);
    glTexCoord2f(1.0, 1.0); glVertex2f(r.x + r.width, r.y);
    glTexCoord2f(0.0, 1.0); glVertex2f(r.x, r.y);
  glEnd();
end;

procedure draw_quad_p(r: Rectangle; width, height: integer);
var _bx,_by:real;
begin
  _bx:=width*r.x;
  _by:=height*r.y;
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_bx, _by + r.height);
    glTexCoord2f(1.0, 0.0); glVertex2f(_bx + r.width, _by + r.height);
    glTexCoord2f(1.0, 1.0); glVertex2f(_bx + r.width, _by);
    glTexCoord2f(0.0, 1.0); glVertex2f(_bx, _by);
  glEnd();
end;

//ðèñóåì íàø êâàä. 0:0 - öåíòð êâàäà//
procedure draw_quad_c(_x, _y, _width, _height :real);

begin

  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_x - (_width / 2), _y + (_height / 2));
    glTexCoord2f(1.0, 0.0); glVertex2f(_x + (_width / 2), _y + (_height / 2));
    glTexCoord2f(1.0, 1.0); glVertex2f(_x + (_width / 2), _y - (_height / 2));
    glTexCoord2f(0.0, 1.0); glVertex2f(_x - (_width / 2), _y - (_height / 2));
  glEnd();
end;

procedure draw_quad_c(r: Rectangle);

begin
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(r.x - (r.width / 2), r.y + (r.height / 2));
    glTexCoord2f(1.0, 0.0); glVertex2f(r.x + (r.width / 2), r.y + (r.height / 2));
    glTexCoord2f(1.0, 1.0); glVertex2f(r.x + (r.width / 2), r.y - (r.height / 2));
    glTexCoord2f(0.0, 1.0); glVertex2f(r.x - (r.width / 2), r.y - (r.height / 2));
  glEnd();
end;

procedure draw_quad_cp(_x, _y, _width, _height :real; width, height: integer);
var _bx,_by:real;
begin
  _bx:=width*_x;
  _by:=height*_y;
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_bx - (_width / 2), _by + (_height / 2));
    glTexCoord2f(1.0, 0.0); glVertex2f(_bx + (_width / 2), _by + (_height / 2));
    glTexCoord2f(1.0, 1.0); glVertex2f(_bx + (_width / 2), _by - (_height / 2));
    glTexCoord2f(0.0, 1.0); glVertex2f(_bx - (_width / 2), _by - (_height / 2));
  glEnd();
end;

procedure draw_quad_cp(r: Rectangle; width, height: integer);
var _bx,_by:real;
begin
  _bx:=width*r.x;
  _by:=height*r.y;
  glBegin( GL_QUADS );
    glTexCoord2f(0.0, 0.0); glVertex2f(_bx - (r.width / 2), _by + (r.height / 2));
    glTexCoord2f(1.0, 0.0); glVertex2f(_bx + (r.width / 2), _by + (r.height / 2));
    glTexCoord2f(1.0, 1.0); glVertex2f(_bx + (r.width / 2), _by - (r.height / 2));
    glTexCoord2f(0.0, 1.0); glVertex2f(_bx - (r.width / 2), _by - (r.height / 2));
  glEnd();
end;
end.
