unit arcdraw;
interface
uses gl, glu, arctypes;
procedure draw_quad(_x, _y, _width, _height :real);
procedure draw_quad_p(_x, _y, _width, _height :real; width, height: integer);
procedure draw_quad(r: Rectangle);
procedure draw_quad_p(r: Rectangle; width, height: integer);
procedure draw_quad_c(_x, _y, _width, _height :real);
procedure draw_quad_c(r: Rectangle);
procedure draw_quad_cp(_x, _y, _width, _height :real; width, height: integer);
procedure draw_quad_cp(r: Rectangle; width, height: integer);

implementation
//������ ��� ����. 0:0 - ������� ����� ����//
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

//������ ��� ����. 0:0 - ������� ����� ����//
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

//������ ��� ����. 0:0 - ����� �����//
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