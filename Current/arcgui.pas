unit arcgui;

interface

{$MODE objfpc}

uses dglOpenGL, Classes, arctypes, sysutils, arcdraw, XMLRead, DOM, arcsystem, LConvEncoding;

type UBFG = class
protected
  kernings : array of BMKerningPairs;
  lineHeight : Shortint;
  ScaleW, ScaleH : Word;
  Glyphs : array of BMGlyph;
  fontTexture : Tgluint;
public
  Constructor Create ( filepath : string );

  function GetGlyph(c : char): BMGlyph;
  function GetLineHeight() : word;
  function GetKerning( kerning_id : word ) : BMKerningPairs;
  procedure SetTexturePointer( var texture: glUint );
  function GetTexture() : glUint;
  function GetWidth() : word;
  function GetHeight() : word;
end;

type BMFont = class
protected
  kernings : array of BMKerningPairs;
  lineHeight : Shortint;
  ScaleW, ScaleH, base : Word;
  Glyphs : array of BMGlyph;
  fontTexture : Tgluint;
public
  Constructor Create ( filepath : string );

  function GetGlyph(c : char): BMGlyph;
  function GetLineHeight() : word;
  function GetKerning( kerning_id : word ) : BMKerningPairs;
  procedure SetTexturePointer( var texture: glUint );
  function GetTexture() : glUint;
  function GetWidth() : word;
  function GetHeight() : word;
end;

procedure DrawText(var font:BMFont; text: WideString; size: real; positionX, positionY: integer; is_kerning, is_multilined:boolean; width, height: word);
procedure DrawText(var font:UBFG; text: String; size: real; positionX, positionY: integer; is_kerning:boolean );

implementation

procedure UBFG.SetTexturePointer( var texture: glUint );
begin
  fontTexture := texture;
end;

function UBFG.GetKerning( kerning_id : word ) : BMKerningPairs;
begin
  GetKerning := kernings[ kerning_id ];
end;

function UBFG.GetTexture() : glUint;
begin
  GetTexture := fontTexture;
end;

function UBFG.GetWidth() : word;
begin
  GetWidth := ScaleW;
end;

function UBFG.GetHeight() : word;
begin
  GetHeight := ScaleH;
end;

function UBFG.GetGlyph(c : char): BMGlyph;
var i : word;
begin
  for i := 0 to Length(Glyphs) - 1 do
    if ( Ord( c ) = Glyphs[i].id ) then begin
      GetGlyph := Glyphs[i];
      exit();
    end;
end;

function UBFG.GetLineHeight() : word;
begin
  GetLineHeight := lineHeight;
end;

Constructor UBFG.Create( filepath : string );
var
  Doc   : TXMLDocument;
  Child : TDOMNode;
  I, j : word;
  k,l, m: word;
begin
  ReadXMLFile( Doc, filepath );

  //считываем основные параметры шрифта
  Child      := Doc.DocumentElement.FindNode('font');
  lineHeight := StrToInt( TDOMElement( Child ).GetAttribute('size') );
  ScaleW     := StrToInt( TDOMElement( Child ).GetAttribute('scaleW')     );
  ScaleH     := StrToInt( TDOMElement( Child ).GetAttribute('scaleH')     );

  //считываем кёрнинги

  with ( Child.ChildNodes ) do begin
    k := 0;

    while ( item[k].NodeName = 'char' ) do
      k := k+1;

    m := 0;

    for i := k to ( Count - 1 ) do begin
      if ( item[i].NodeName = 'kerning') then begin
        m := m+1;
        SetLength( kernings, System.Length(kernings) + 1 );
        kernings[m-1].first  := StrToInt( TDOMElement( item[i] ).GetAttribute('first')  );
        kernings[m-1].second := StrToInt( TDOMElement( item[i] ).GetAttribute('second') );
        kernings[m-1].amount := StrToInt( TDOMElement( item[i] ).GetAttribute('value') );
      end;
    end;
    k := High(kernings);
    qSortKernings( kernings, 0, k );
  end;

  m:=0;

  with ( Child.ChildNodes ) do begin
    for i := 0 to ( Count - 1 ) do begin
      if ( item[i].NodeName = 'char' ) then begin
        m := m+1;

        SetLength(Glyphs, m);

        Glyphs[m-1].id := StrToInt( TDOMElement( item[i] ).GetAttribute('id') );
        Glyphs[m-1].x  := StrToInt( TDOMElement( item[i] ).GetAttribute('x')  );
        Glyphs[m-1].y  := StrToInt( TDOMElement( item[i] ).GetAttribute('y')  );
        Glyphs[m-1].width  := StrToInt( TDOMElement( item[i] ).GetAttribute('width')  );
        Glyphs[m-1].height := StrToInt( TDOMElement( item[i] ).GetAttribute('height') );
        Glyphs[m-1].xadvance := StrToInt( TDOMElement( item[i] ).GetAttribute('OrigWidth') ) - StrToInt( TDOMElement( item[i] ).GetAttribute('width')  );
        Glyphs[m-1].xoffset  := StrToInt( TDOMElement( item[i] ).GetAttribute('Xoffset')  );
        Glyphs[m-1].yoffset  := StrToInt( TDOMElement( item[i] ).GetAttribute('Yoffset')  );

        for j := 0 to k do
          if ( kernings[j].first = Glyphs[m-1].id ) then begin
            Glyphs[m-1].fisrt_kerning_id := j;
            l := j; break;
          end;

        for j := l to ( k - 1 ) do begin
          if ( kernings[j].first <> kernings[j+1].first ) then begin
            Glyphs[m-1].end_kerning_id := j;
            l := j;  break;
          end;

          if ( j = ( k -1 )) then begin
            Glyphs[m-1].end_kerning_id := j+1;
            break;
          end;
        end;
      end;

    end;
  end;

  for i := 0 to k do begin
    writeln(kernings[i].amount);
  end;

end;

procedure DrawText(var font:UBFG; text: String; size: real; positionX, positionY: integer; is_kerning:boolean );
  var i,j: word; curr, _curr: BMGlyph; k: real; kerning : BMKerningPairs; propkoeff : real; temp: String;
begin
  k:=positionX;
  temp := (text);
  writeln(temp);
  for i := 1 to length(temp) do begin

  //writeln(Ord(temp[i]));

    glBindTexture(GL_TEXTURE_2D, font.GetTexture);
    glBegin(GL_QUADS);
    with (font) do begin
      curr := GetGlyph( temp[i] );

      if ( size = GetLineHeight() ) then propkoeff := 1
          else propkoeff := size / GetLineHeight();

      if (i>1) then begin
        _curr := GetGlyph( temp[i-1] );

        if ( _curr.fisrt_kerning_id <> 0 ) and ( is_kerning = true ) then
          for j := _curr.fisrt_kerning_id to _curr.end_kerning_id do begin
            kerning := GetKerning( j );
            if ( curr.id = kerning.second ) then begin
              k := k + kerning.amount * propkoeff;
              break;
            end;
          end;

        k := k + _curr.xadvance * propkoeff;
      end;

      glTexCoord2f(  curr.x / font.GetWidth, ( curr.y + curr.height ) / font.GetHeight );
      glVertex2d( k + curr.xoffset, positionY + ( curr.height + curr.yoffset ) * propkoeff );

      glTexCoord2f( (curr.x + curr.width) / font.GetWidth,( curr.y + curr.height ) / font.GetHeight);
      glVertex2d( k + curr.width * propkoeff + curr.xoffset, positionY + ( curr.height + curr.yoffset ) * propkoeff );

      glTexCoord2f( (curr.x + curr.width) / font.GetWidth, curr.y / font.GetHeight );
      glVertex2d( k + curr.width * propkoeff + curr.xoffset, positionY + curr.yoffset * propkoeff);

      glTexCoord2f( curr.x / font.GetWidth, curr.y / font.GetHeight );
      glVertex2d( k + curr.xoffset, positionY + curr.yoffset * propkoeff );

    end;
    glEnd();
  end;
end;


/////////////////////////////////////////////////////////////
///// BMFONT ////////////////////////////
/////////////////////////////////////////////////////////////

procedure BMFont.SetTexturePointer( var texture: glUint );
begin
  fontTexture := texture;
end;

function BMFont.GetKerning( kerning_id : word ) : BMKerningPairs;
begin
  GetKerning := kernings[ kerning_id ];
end;

function BMFont.GetTexture() : glUint;
begin
  GetTexture := fontTexture;
end;

function BMFont.GetWidth() : word;
begin
  GetWidth := ScaleW;
end;

function BMFont.GetHeight() : word;
begin
  GetHeight := ScaleH;
end;

function BMFont.GetGlyph(c : char): BMGlyph;
var i : word;
begin
  for i := 0 to Length(Glyphs) - 1 do
    if ( Ord( c ) = Glyphs[i].id ) then begin
      GetGlyph := Glyphs[i];
      exit();
    end;
end;

function BMFont.GetLineHeight() : word;
begin
  GetLineHeight := lineHeight;
end;

Constructor BMFont.Create( filepath : string );
var
  Doc   : TXMLDocument;
  Child, child2 : TDOMNode;
  I, j : word;
  k,l: word;
begin
  ReadXMLFile( Doc, filepath );

  //считываем основные параметры шрифта
  Child      := Doc.DocumentElement.FindNode('common');
  lineHeight := StrToInt( TDOMElement( Child ).GetAttribute('lineHeight') );
  ScaleW     := StrToInt( TDOMElement( Child ).GetAttribute('scaleW')     );
  ScaleH     := StrToInt( TDOMElement( Child ).GetAttribute('scaleH')     );
  base       := StrToInt( TDOMElement( Child ).GetAttribute('base')       );

  //считываем кёрнинги
  Child2      := Doc.DocumentElement.FindNode('kernings');

  if Assigned(Child2) then begin
    SetLength( kernings, Child2.ChildNodes.Count );

    with ( Child2.ChildNodes ) do begin
      k := Count - 1;
      if k > 0 then begin
        for i := 0 to k do begin
          kernings[i].first  := StrToInt( TDOMElement( item[i] ).GetAttribute('first')  );
          kernings[i].second := StrToInt( TDOMElement( item[i] ).GetAttribute('second') );
          kernings[i].amount := StrToInt( TDOMElement( item[i] ).GetAttribute('amount') );
        end;
        qSortKernings( kernings, 0, k );
      end;
    end;
  end;

  //считываем символы
  Child      := Doc.DocumentElement.FindNode('chars');
  SetLength( Glyphs, StrToInt( TDOMElement(Child).GetAttribute('count') ) );

  with ( Child.ChildNodes ) do begin
    for i := 0 to ( Count - 1 ) do begin
      Glyphs[i].id := StrToInt( TDOMElement( item[i] ).GetAttribute('id') );
      Glyphs[i].x  := StrToInt( TDOMElement( item[i] ).GetAttribute('x')  );
      Glyphs[i].y  := StrToInt( TDOMElement( item[i] ).GetAttribute('y')  );
      Glyphs[i].width  := StrToInt( TDOMElement( item[i] ).GetAttribute('width')  );
      Glyphs[i].height := StrToInt( TDOMElement( item[i] ).GetAttribute('height') );
      Glyphs[i].xadvance := StrToInt( TDOMElement( item[i] ).GetAttribute('xadvance') );
      Glyphs[i].xoffset  := StrToInt( TDOMElement( item[i] ).GetAttribute('xoffset')  );
      Glyphs[i].yoffset  := StrToInt( TDOMElement( item[i] ).GetAttribute('yoffset')  );

      if Assigned(Child2) then begin
        if ( k > 0 ) then begin
          for j := 0 to k do
            if ( kernings[j].first = Glyphs[i].id ) then begin
              Glyphs[i].fisrt_kerning_id := j;
              l := j; break;
            end;

          for j := l to ( k - 1 ) do begin
            if ( kernings[j].first <> kernings[j+1].first ) then begin
              Glyphs[i].end_kerning_id := j;
              l := j;  break;
            end;

            if ( j = ( k -1 )) then begin
              Glyphs[i].end_kerning_id := j+1;
              break;
            end;
          end;
        end;
      end;
    end;
  end;

  Doc.Free;
end;

procedure DrawText(var font:BMFont; text: WideString; size: real; positionX, positionY: integer; is_kerning, is_multilined:boolean; width, height: word);
  var i, j, l: word; curr, _curr: BMGlyph; k, z: real; kerning : BMKerningPairs; propkoeff : real;
      _k: real; breaking : boolean;
begin
  k := positionX; z := positionY; breaking := false;
  for i := 1 to length(text) do begin
    with (font) do begin

      if ( Ord( text[i] ) <> 13 ) and ( Ord( text[i] ) <> 10 ) then begin
        curr := GetGlyph( text[i] );
      end;

      if ( size = GetLineHeight() ) then propkoeff := 1
          else propkoeff := size / GetLineHeight();

      if ( breaking = true ) then begin
        breaking := false;
      end;

      if ( Ord( text[i] ) = 13 ) or ( Ord( text[i] ) = 10 ) then begin
        k := positionX;
        z := z + GetLineHeight() * propkoeff;
      end;

      if (i>1) then begin

        if ( Ord( text[i - 1] ) <> 13 ) and ( Ord( text[i - 1] ) <> 10 ) and 
           ( Ord( text[i] ) <> 13 ) and ( Ord( text[i] ) <> 10 )  then begin

          _curr := GetGlyph( text[i-1] );

          if ( breaking = false ) then begin
            if ( _curr.fisrt_kerning_id <> 0 ) and ( is_kerning = true ) then
              for j := _curr.fisrt_kerning_id to _curr.end_kerning_id do begin
                kerning := GetKerning( j );
                if ( curr.id = kerning.second ) then begin
                  k := k + kerning.amount * propkoeff;
                  break;
                end;
              end;

            k := k + _curr.xadvance * propkoeff;
          end;
        end;

        if ( Ord( text[i - 1] ) = 32 ) and ( Ord( text[i] ) <> 32 ) then begin
          _k := k;
          for l := i to length(text) do begin

            if ( _curr.fisrt_kerning_id <> 0 ) and ( is_kerning = true ) then
              for j := _curr.fisrt_kerning_id to _curr.end_kerning_id do begin
                kerning := GetKerning( j );

                if ( curr.id = kerning.second ) then begin
                  _k := _k + kerning.amount * propkoeff;
                  break;
                end;
              end;

              _k := _k + _curr.xadvance * propkoeff;

              if ( Ord( text[l] ) = 32 ) then begin
                break;
              end;

              if ( _k - positionX > width ) then begin
                k := positionX;
                breaking := true;
                z := z + GetLineHeight() * propkoeff;
                break;
              end;
          end;
        end;

      end;

      if ( Ord( text[i] ) <> 13 ) and ( Ord( text[i] ) <> 10 ) then begin
        glBindTexture(GL_TEXTURE_2D, font.GetTexture);
        glBegin(GL_QUADS);
          glTexCoord2f(  curr.x / font.GetWidth, ( curr.y + curr.height ) / font.GetHeight );
          glVertex2d( k + curr.xoffset, z + ( curr.height + curr.yoffset ) * propkoeff );

          glTexCoord2f( (curr.x + curr.width) / font.GetWidth,( curr.y + curr.height ) / font.GetHeight);
          glVertex2d( k + curr.width * propkoeff + curr.xoffset, z + ( curr.height + curr.yoffset ) * propkoeff );

          glTexCoord2f( (curr.x + curr.width) / font.GetWidth, curr.y / font.GetHeight );
          glVertex2d( k + curr.width * propkoeff + curr.xoffset, z + curr.yoffset * propkoeff);

          glTexCoord2f( curr.x / font.GetWidth, curr.y / font.GetHeight );
          glVertex2d( k + curr.xoffset, z + curr.yoffset * propkoeff );
        glEnd();
      end;
    end;
    
  end;
end;

end.
