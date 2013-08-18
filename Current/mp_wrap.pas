{ ******************************************************* }
{                                                         }
{ Magic Particles HGE wrapper for Delphi                  }
{ www.astralax.com                                        }
{                                                         }
{ ark.su (C) www.ark.su 11.11.2009                        }
{                                                         }
{ Checked on Delphi versions:                             }
{ 2007, 2009, 2010                                        }
{                                                         }
{ ******************************************************* }

unit mp_wrap;

interface
{$MODE DELPHI}

uses
  magic, mp;

type
  // eng: This class stores texture frame-file
  // rus: Класс, который хранит текстурный файл-кадр
  TMP_Frame_WRAP = class(TMP_Frame)
  protected
    spr: IHGESprite;
  public
    // eng: Initialization of texture frame
    // rus: Инициализация текстурного кадра
    function InitFrame(var amagic_texture: TMAGIC_TEXTURE): TMP_Atlas; override;

    // eng: Drawing the particle
    // rus: Отрисовка частицы
    procedure Draw(var magic_particle: TMAGIC_PARTICLE); override;

    // eng: Sets the intensity
    // rus: Установить интенсивность
    procedure SetIntense(intense: boolean); override;

    constructor Create(aowner: TMP_FrameList);
    destructor Destroy; override;
  end;

  // eng: This class stores texture atlas
  // rus: Класс, который хранит текстурный атлас
  TMP_Atlas_WRAP = class(TMP_Atlas)
  public
    texture: ITexture;
    // eng: Loads texture frame
    // rus: Загрузка текстурного кадра
    procedure LoadFrame(var magic_texture: PMAGIC_TEXTURE;
      texture_folder: AnsiString); override;

    constructor Create(width, height: integer);
    destructor Destroy; override;
  end;

var
  hge: IHGE;

implementation

{ TMP_Atlas_WRAP }

constructor TMP_Atlas_WRAP.Create(width, height: integer);
begin
  inherited;
  texture := hge.Texture_Create(width, height);
end;

destructor TMP_Atlas_WRAP.Destroy;
begin
  if texture <> nil then
    texture := nil;
  inherited;
end;

procedure TMP_Atlas_WRAP.LoadFrame(var magic_texture: PMAGIC_TEXTURE;
  texture_folder: AnsiString);
var
  texture_from: ITexture;
  texture_from_width, texture_from_height, frame_width, frame_height, x, y,
    pitch_to, pitch_from, i, j, i2, j2: integer;
  scale_x, scale_y, left, top, frame_from_width, frame_from_height: single;
  _to, _from: plongword;
  p1, p2: plongword;
  spr_from: IHGESprite;
begin
  if magic_texture.data <> nil then
    texture_from := hge.Texture_Load(magic_texture.data, magic_texture.length)
  else
    texture_from := hge.Texture_Load(texture_folder + magic_texture.file_name,
      false);

  texture_from_width := hge.Texture_GetWidth(texture_from, true);
  texture_from_height := hge.Texture_GetHeight(texture_from, true);
  spr_from := THGESprite.Create(texture_from, 0, 0, texture_from_width,
    texture_from_height);

  frame_width := magic_texture.frame_width;
  frame_height := magic_texture.frame_height;

  frame_from_width := spr_from.GetWidth;
  frame_from_height := spr_from.GetHeight;

  scale_x := frame_width / frame_from_width;
  scale_y := frame_height / frame_from_height;

  left := magic_texture.left;
  if left > magic_texture.right then
    left := magic_texture.right;
  top := magic_texture.top;
  if top > magic_texture.bottom then
    top := magic_texture.bottom;

  x := trunc(left * atlas_width);
  y := trunc(top * atlas_height);

  pitch_to := hge.Texture_GetWidth(texture);
  pitch_from := hge.Texture_GetWidth(texture_from);

  _from := pointer(hge.Texture_Lock(texture_from, true, 0, 0, trunc
        (frame_from_width), trunc(frame_from_height)));
  _to := pointer(hge.Texture_Lock(texture, false, x, y, frame_width,
      frame_height));

  for i := 0 to frame_width - 1 do
    for j := 0 to frame_height - 1 do
    begin
      i2 := round(i / scale_x);
      j2 := round(j / scale_y);

      p1 := _from;
      p2 := _to;
      inc(p1, j2 * pitch_from + i2);
      inc(p2, j * pitch_to + i);

      p2^ := p1^;
    end;

  hge.Texture_Unlock(texture);
  hge.Texture_Unlock(texture_from);
  texture_from := nil;
  spr_from := nil;
end;

{ TMP_Frame_WRAP }

constructor TMP_Frame_WRAP.Create(aowner: TMP_FrameList);
begin
  inherited;
  spr := nil;
end;

destructor TMP_Frame_WRAP.Destroy;
begin
  spr := nil;
  inherited;
end;

procedure TMP_Frame_WRAP.Draw(var magic_particle: TMAGIC_PARTICLE);
var
  vertex: PMAGIC_VERTEX_RECTANGLE;
begin
  vertex := Magic_GetParticleRectangle(magic_particle, magic_texture);

  spr.SetColor(magic_particle.color, -1);
  spr.Render4V(vertex.x1, vertex.y1, vertex.x2, vertex.y2, vertex.x3,
    vertex.y3, vertex.x4, vertex.y4);
end;

function TMP_Frame_WRAP.InitFrame(var amagic_texture: TMAGIC_TEXTURE)
  : TMP_Atlas;
var
  atlas: TMP_Atlas_WRAP;
  flip_x, flip_y: boolean;
  x, y, left, top: single;
begin
  // Инициализация текстурного кадра
  atlas := ( inherited InitFrame(amagic_texture)) as TMP_Atlas_WRAP;

  flip_x := false;
  left := amagic_texture.left;
  if left > amagic_texture.right then
  begin
    left := amagic_texture.right;
    flip_x := true;
  end;

  flip_y := false;
  top := amagic_texture.top;
  if top > amagic_texture.bottom then
  begin
    top := amagic_texture.bottom;
    flip_y := true;
  end;

  x := left * amagic_texture.texture_width;
  y := top * amagic_texture.texture_height;

  spr := THGESprite.Create(atlas.texture, x, y, amagic_texture.frame_width,
    amagic_texture.frame_height);
  spr.SetFlip(flip_x, flip_y, false);
  result := atlas;
end;

procedure TMP_Frame_WRAP.SetIntense(intense: boolean);
begin
  if intense then
    spr.SetBlendMode(BLEND_ALPHAADD)
  else
    spr.SetBlendMode(BLEND_ALPHABLEND);
end;

end.
