unit arcimage;

interface
{$MODE DELPHI}

uses
  Windows, dglOpenGL, SysUtils, arcconst;

function LoadTextureTGA(Filename: pansichar; var Texture: GLuint): Boolean;
function LoadBmp(path : pansichar) : uint32;
function ilLoadFile(filetype: integer; Filename: pansichar; var Texture : GLuint): GLuint;
procedure FreeFBO(var TextureID: gluint; var fboId: gluint);
procedure InitFBO( Width:integer; Height: integer; var fboId: gluint; var TextureID: gluint);
function createTextureRGBA8( Width:integer; Height: integer): GLUInt;

implementation

function createTextureRGBA8( Width:integer; Height: integer): GLUInt;
var id_texture: GLUInt;
begin
        glGenTextures(1, @id_texture);
        glBindTexture(GL_TEXTURE_2D, id_texture);

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

        glTexImage2D(GL_TEXTURE_2D,0, GL_RGBA8, width, height,0,GL_RGBA,GL_UNSIGNED_BYTE, NIL);

        createTextureRGBA8 := id_texture;
end;

procedure InitFBO( Width:integer; Height: integer; var fboId: gluint; var TextureID: gluint);
var Status: GLUInt;
begin
  textureId:=CreateTextureRGBA8(Width, Height);

  glGenFramebuffersEXT(1, @fboId);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboId);

  glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, textureId, 0);

  Status:=glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT);
  assert(status=GL_FRAMEBUFFER_COMPLETE_EXT, 'FBOError '+inttostr(Status));

  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
end;

procedure FreeFBO(var TextureID: gluint; var fboId: gluint);
begin
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);
  glBindTexture(GL_TEXTURE_2D, 0);
  glDeleteTextures(1, @TextureId);
  glDeleteFramebuffersEXT ( 1, @fboId );
end;

function CreateTexture(Width, Height, Format : Word; pData : Pointer) : Integer;
var
  Texture : GLuint;
begin
  glGenTextures(1, @Texture);
  glBindTexture(GL_TEXTURE_2D, Texture);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);


  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

  if Format = GL_RGBA then
    gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, Width, Height, GL_RGBA, GL_UNSIGNED_BYTE, pData)
  else
    gluBuild2DMipmaps(GL_TEXTURE_2D, 3, Width, Height, GL_RGB, GL_UNSIGNED_BYTE, pData);

  CreateTexture :=Texture;
end;

procedure CopySwapPixel(const Source, Destination : Pointer);
asm
  push ebx
  mov bl,[eax+0]
  mov bh,[eax+1]
  mov [edx+2],bl
  mov [edx+1],bh
  mov bl,[eax+2]
  mov bh,[eax+3]
  mov [edx+0],bl
  mov [edx+3],bh
  pop ebx
end;

function LoadTextureTGA(Filename: pansichar; var Texture : GLuint): Boolean;
var
  TGAHeader : packed record
    FileType     : Byte;
    ColorMapType : Byte;
    ImageType    : Byte;
    ColorMapSpec : Array[0..4] of Byte;
    OrigX  : Array [0..1] of Byte;
    OrigY  : Array [0..1] of Byte;
    Width  : Array [0..1] of Byte;
    Height : Array [0..1] of Byte;
    BPP    : Byte;
    ImageInfo : Byte;
  end;
  TGAFile   : File;
  bytesRead : Integer;
  image     : Pointer;
  CompImage : Pointer;
  Width, Height : Integer;
  ColorDepth    : Integer;
  ImageSize     : Integer;
  BufferIndex : Integer;
  currentByte : Integer;
  CurrentPixel : Integer;
  I : Integer;
  Front: ^Byte;
  Back: ^Byte;
  Temp: Byte;
begin
  LoadTextureTGA :=FALSE;
  if FileExists(Filename) then
  begin
    AssignFile(TGAFile, Filename);
    Reset(TGAFile, 1);

    BlockRead(TGAFile, TGAHeader, SizeOf(TGAHeader));
    LoadTextureTGA :=TRUE;
  end
  else
  begin
    MessageBox(0, PChar('File not found  - ' + Filename), PChar('TGA Texture'), MB_OK);
    Exit;
  end;

  if result = TRUE then
  begin
    LoadTextureTGA :=FALSE;

    if (TGAHeader.ImageType <> 2) AND
       (TGAHeader.ImageType <> 10) then
    begin
      LoadTextureTGA := False;
      CloseFile(tgaFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Only 24 and 32bit TGA supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    if TGAHeader.ColorMapType <> 0 then
    begin
      LoadTextureTGA := False;
      CloseFile(TGAFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Colormapped TGA files not supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    // Get the width, height, and color depth
    Width  := TGAHeader.Width[0]  + TGAHeader.Width[1]  * 256;
    Height := TGAHeader.Height[0] + TGAHeader.Height[1] * 256;
    ColorDepth := TGAHeader.BPP;
    ImageSize  := Width*Height*(ColorDepth div 8);

    if ColorDepth < 24 then
    begin
      LoadTextureTGA := False;
      CloseFile(TGAFile);
      MessageBox(0, PChar('Couldn''t load "'+ Filename +'". Only 24 and 32 bit TGA files supported.'), PChar('TGA File Error'), MB_OK);
      Exit;
    end;

    GetMem(Image, ImageSize);

    if TGAHeader.ImageType = 2 then
    begin
      BlockRead(TGAFile, image^, ImageSize, bytesRead);
      if bytesRead <> ImageSize then
      begin
        LoadTextureTGA := False;
        CloseFile(TGAFile);
        MessageBox(0, PChar('Couldn''t read file "'+ Filename +'".'), PChar('TGA File Error'), MB_OK);
        Exit;
      end;

      if TGAHeader.BPP = 24 then
      begin
        for I :=0 to Width * Height - 1 do
        begin
          Front := Pointer(Integer(Image) + I*3);
          Back := Pointer(Integer(Image) + I*3 + 2);
          Temp := Front^;
          Front^ := Back^;
          Back^ := Temp;
        end;
        Texture :=CreateTexture(Width, Height, GL_RGB, Image);
      end
      else
      begin
        for I :=0 to Width * Height - 1 do
        begin
          Front := Pointer(Integer(Image) + I*4);
          Back := Pointer(Integer(Image) + I*4 + 2);
          Temp := Front^;
          Front^ := Back^;
          Back^ := Temp;
        end;
        Texture :=CreateTexture(Width, Height, GL_RGBA, Image);
      end;
    end;

    if TGAHeader.ImageType = 10 then
    begin
      ColorDepth :=ColorDepth DIV 8;
      CurrentByte :=0;
      CurrentPixel :=0;
      BufferIndex :=0;

      GetMem(CompImage, FileSize(TGAFile)-sizeOf(TGAHeader));
      BlockRead(TGAFile, CompImage^, FileSize(TGAFile)-sizeOf(TGAHeader), BytesRead);
      if bytesRead <> FileSize(TGAFile)-sizeOf(TGAHeader) then
      begin
        LoadTextureTGA := False;
        CloseFile(TGAFile);
        MessageBox(0, PChar('Couldn''t read file "'+ Filename +'".'), PChar('TGA File Error'), MB_OK);
        Exit;
      end;

      repeat
        Front := Pointer(Integer(CompImage) + BufferIndex);
        Inc(BufferIndex);
        if Front^ < 128 then
        begin
          For I := 0 to Front^ do
          begin
            CopySwapPixel(Pointer(Integer(CompImage)+BufferIndex+I*ColorDepth), Pointer(Integer(image)+CurrentByte));
            CurrentByte := CurrentByte + ColorDepth;
            inc(CurrentPixel);
          end;
          BufferIndex :=BufferIndex + (Front^+1)*ColorDepth
        end
        else
        begin
          For I := 0 to Front^ -128 do
          begin
            CopySwapPixel(Pointer(Integer(CompImage)+BufferIndex), Pointer(Integer(image)+CurrentByte));
            CurrentByte := CurrentByte + ColorDepth;
            inc(CurrentPixel);
          end;
          BufferIndex :=BufferIndex + ColorDepth
        end;
      until CurrentPixel >= Width*Height;

      if ColorDepth = 3 then
        Texture :=CreateTexture(Width, Height, GL_RGB, Image)
      else
        Texture :=CreateTexture(Width, Height, GL_RGBA, Image);
    end;

    LoadTextureTGA :=TRUE;
    FreeMem(Image);
  end;
end;

function ilLoadFile(filetype: integer; Filename: pansichar; var Texture : GLuint): GLuint;
begin
  case filetype of
    TGA_FILE: LoadTextureTGA(Filename, Texture);
    BMP_FILE: Texture:=LoadBMP(filename);
  end;

  ilLoadFile := Texture;
end;

function LoadBmp(path : pansichar) : uint32;
var
  i:longint;
  gBitmap:hBitmap;
  sBitmap:Bitmap;
  TextureID : GLuint;
  format: GLuint;
begin
  writeln(path);
  gbitmap:=LoadImage(GetModuleHandle(NIL), path, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION or LR_LOADFROMFILE);
  GetObject(gbitmap, sizeof(sbitmap), @sbitmap);
  glEnable(GL_TEXTURE_2D);
  glGenTextures(1,@TextureID);
  glBindTexture(GL_TEXTURE_2D,TextureID);
  glPixelStorei(GL_UNPACK_ALIGNMENT,4);
  glPixelStorei(GL_UNPACK_ROW_LENGTH,0);
  glPixelStorei(GL_UNPACK_SKIP_ROWS,0);
  glPixelStorei(GL_UNPACK_SKIP_PIXELS,0);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
  if sbitmap.bmBitsPixel / 8 = 4 then begin
     format:=32993;
  end else begin
     format:=32992;
  end;
 glTexImage2D(GL_TEXTURE_2D, 0, sbitmap.bmBitsPixel div 8, sbitmap.bmWidth, sbitmap.bmHeight,0, format, GL_UNSIGNED_BYTE, sbitmap.bmBits);
  glBindTexture(GL_TEXTURE_2D, TextureID);
  LoadBmp:=TextureID;
end;

end.
