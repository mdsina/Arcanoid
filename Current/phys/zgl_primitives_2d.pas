{
 *  Copyright (c) 2012 Andrey Kemka
 *
 *  This software is provided 'as-is', without any express or
 *  implied warranty. In no event will the authors be held
 *  liable for any damages arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute
 *  it freely, subject to the following restrictions:
 *
 *  1. The origin of this software must not be misrepresented;
 *     you must not claim that you wrote the original software.
 *     If you use this software in a product, an acknowledgment
 *     in the product documentation would be appreciated but
 *     is not required.
 *
 *  2. Altered source versions must be plainly marked as such,
 *     and must not be misrepresented as being the original software.
 *
 *  3. This notice may not be removed or altered from any
 *     source distribution.
}
unit zgl_primitives_2d;

{$I zgl_config.cfg}

interface

const
  PR2D_FILL   = $010000;
  PR2D_SMOOTH = $020000;

procedure pr2d_Pixel( X, Y : Single; Color : LongWord; Alpha : Byte = 255 );
procedure pr2d_Line( X1, Y1, X2, Y2 : Single; Color : LongWord; Alpha : Byte = 255; FX : LongWord = 0 );
procedure pr2d_Rect( X, Y, W, H : Single; Color : LongWord; Alpha : Byte = 255; FX : LongWord = 0 );
procedure pr2d_Circle( X, Y, Radius : Single; Color : LongWord; Alpha : Byte = 255; Quality : Word = 32; FX : LongWord = 0 );

implementation
uses
  dglOpenGL;

procedure pr2d_Pixel( X, Y : Single; Color : LongWord; Alpha : Byte = 255 );
begin

      glEnable( GL_BLEND );
      glBegin( GL_POINTS );


  glColor4ub( ( Color and $FF0000 ) shr 16, ( Color and $FF00 ) shr 8, Color and $FF, Alpha );
  glVertex2f( X + 0.5, Y + 0.5 );

      glEnd();
      glDisable( GL_BLEND );

end;

procedure pr2d_Line( X1, Y1, X2, Y2 : Single; Color : LongWord; Alpha : Byte = 255; FX : LongWord = 0 );
begin

      glEnable( GL_BLEND );

      glBegin( GL_LINES );

        glColor4ub( ( Color and $FF0000 ) shr 16, ( Color and $FF00 ) shr 8, Color and $FF, Alpha );
        glVertex2f( X1 + 0.5, Y1 + 0.5 );
        glVertex2f( X2 + 0.5, Y2 + 0.5 );


      glEnd();
      glDisable( GL_BLEND );
end;

procedure pr2d_Rect( X, Y, W, H : Single; Color : LongWord; Alpha : Byte = 255; FX : LongWord = 0 );
begin

      X := X + 0.5;
      Y := Y + 0.5;
      W := W - 1;
      H := H - 1;


          glEnable( GL_BLEND );
          glBegin( GL_LINES );

            glColor4ub( ( Color and $FF0000 ) shr 16, ( Color and $FF00 ) shr 8, Color and $FF, Alpha );
            glVertex2f( X,     Y );
            glVertex2f( X + W, Y );

            glVertex2f( X + W, Y );
            glVertex2f( X + W, Y + H );

            glVertex2f( X + W, Y + H );
            glVertex2f( X,     Y + H );

            glVertex2f( X,     Y + H );
            glVertex2f( X,     Y );

          glEnd();
          glDisable( GL_BLEND );
end;

procedure pr2d_Circle( X, Y, Radius : Single; Color : LongWord; Alpha : Byte = 255; Quality : Word = 32; FX : LongWord = 0 );
  var
    i : Integer;
    k : Single;
begin
  if Quality > 360 Then
    k := 360
  else
    k := 360 / Quality;

            glEnable( GL_BLEND );

            glBegin( GL_TRIANGLES );

        glColor4ub( ( Color and $FF0000 ) shr 16, ( Color and $FF00 ) shr 8, Color and $FF, Alpha );
        for i := 0 to Quality - 1 do
          begin
            glVertex2f( X, Y );
            glVertex2f( X + round( (Radius * cos(i * k)) ) , Y + round( (Radius * sin(i * k)) ) );
            glVertex2f( X + round( (Radius * cos((i+1)*k) )), Y + round( (Radius * sin((i+1)*k) )) );
          end;

            glEnd();
            glDisable( GL_BLEND );
end;

end.
