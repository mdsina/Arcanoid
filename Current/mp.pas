﻿{ ******************************************************* }
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

unit mp;

interface
{$MODE DELPHI}

uses
  SysUtils,
  magic, win_data;

const
  // eng: Interpolation mode is taken from emitter settings
  // rus: ????? ???????????? ??????? ?? ????????
  MAGIC_INTERPOLATION_DEFAULT = 0;
  // eng: Interpolation is always enabled
  // rus: ?????? ???????????? ????????????
  MAGIC_INTERPOLATION_ENABLE = 1;
  // eng: Interpolation is always disabled
  // rus: ?????? ????????? ????????????
  MAGIC_INTERPOLATION_DISABLE = 2;

  // eng: Preserve particle positions when changing emitter position or direction
  // rus: ??? ????????? ??????? ??? ??????????? ???????? ??????? ???????? ?? ??????? ?????
  MAGIC_CHANGE_EMITTER_ONLY = FALSE;
  // eng: Move all the special effect when changing emitter position or direction
  // rus: ??? ????????? ??????? ??? ??????????? ???????? ???? ?????????? ???????????? ???????
  MAGIC_CHANGE_EMITTER_AND_PARTICLES = TRUE;

  // eng: Emitter is not working
  // rus: ??????? ?? ????????
  MAGIC_STATE_STOP = 0;
  // eng: Emitter is updated and rendered
  // rus: ??????? ??????????? ? ????????
  MAGIC_STATE_UPDATE = 1;
  // eng: Emitter interrupts, i.e. is working while there are "alive" particles
  // rus: ??????? ??????????? ? ???????? ?? ??????? ??????????? ???? ????????? ??????, ????? ??????? ?????? ?? ?????????
  MAGIC_STATE_INTERRUPT = 2;
  // eng: Emitter is only rendered
  // rus: ??????? ?????? ????????
  MAGIC_STATE_VISIBLE = 3;

type
  TMP_POSITION = record
    x, y, z: single;

    procedure from; overload;
    procedure from(ax, ay: single); overload;
    procedure from(ax, ay, az: single); overload;

    class operator Add(const Left, Right: TMP_POSITION): TMP_POSITION;
  end;

  PMP_POSITION = ^TMP_POSITION;

  TMP_Emitter = class;
  TMP_FrameList = class;
  TMP_Atlas = class;
  TMP_Frame = class;

  // eng: This class is used to store all the loaded emitters
  // rus: ?????, ??????? ???????? ?????????? ????????? Magic Particles
  TMP_Manager = class
  protected
    // eng: The list of loaded emitters
    // rus: ?????? ??????????? ?????????
    m_emitter: array of TMP_Emitter;
    // eng: The list of loaded frame-lists
    // rus: ?????? ??????????? ??????? ????-??????
    m_framelist: array of TMP_FrameList;
    // eng: The list of loaded atlases
    // rus: ?????? ??????????? ???????
    m_atlas: array of TMP_Atlas;

    // eng: The settings for default initialization of emitters
    // rus: ????????? ??? ????????????? ????????? ?? ?????????

    // eng: Interpolation mode, that will be assigned to all loaded emitters.
    // rus: ?????? ?????????? ???????????? ? ??????????? ?????????
    interpolation: integer;
    // eng: Mode of the emitter behaviour after the end of animation
    // rus: ????? ???????????? ?????????
    loop: integer;
    // eng: Emitter coordinates mode.
    // rus: ????? ????????? ??????? ???????
    position_mode: boolean;
    // eng: Path to the folder that will be used to store textures.
    // rus: ????? ? ?????????? ?? ?????????
    texture_folder: AnsiString;
    // eng: Path to the folder that will be used to store temporary data.
    // rus:  ????? ??? ????????? ?????? ?? ?????????
    temp_folder: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
  public
    // eng: Initialization.
    // rus: ?????????????
    procedure Init(ainterpolation: integer; aloop: integer;
      aposition_mode: boolean; atemp_folder: AnsiString = '');

    // eng: Returns the number of emitters.
    // rus: ???????? ?????????? ?????????
    function GetEmitterCount: integer;
    // eng: Returns the emitter by its index.
    // rus: ???????? ???????
    function GetEmitter(index: integer): TMP_Emitter;

    // eng: Returns the emitter by name.
    // rus: ???????? ??????? ?? ?????
    function GetEmitterByName(name: AnsiString): TMP_Emitter;

    // eng: Returns the count of frame-lists
    // rus: ???????? ?????????? ??????? ??????
    function GetFrameListCount: integer;
    // eng: Returns the frame-list by its index.
    // rus: ???????? ?????? ??????
    function GetFrameList(index: integer): TMP_FrameList;
    // eng: Adds the new frame-list.
    // rus: ?????????? ?????? ?????? ??????
    function AddFrameList: TMP_FrameList;

    // eng: Loading all the emitters and animated folders from the file specified.
    // rus: ???????? ???? ????????? ? ????????????? ?????? ?? ?????????? ?????
    function LoadEmittersFromFile(file_name: AnsiString): integer;

    // eng: Closing files.
    // rus: ???????? ???? ??????
    procedure CloseFiles;

    // eng: Loading textures for the existing emitters.
    // rus: ???????? ???????
    procedure LoadTextures(atexture_folder: AnsiString; atlas_width,
      atlas_height: integer; frame_step: integer = 0; scale_step: single = 0.1);

    // eng: Duplicating specified emitter.
    // rus: ???????????? ????????
    function DuplicateEmitter(from: TMP_Emitter): integer;

    // eng: Emitters update.
    // rus: ?????????? ?????????
    procedure Update(time: double);

    // eng: Stopping all the emitters.
    // rus: ????????? ?????????
    procedure Stop;

    // eng: Loads folder
    // rus: ???????? ?????
    procedure LoadFolder(hmfile: HM_FILE; path: AnsiString);

    // eng: Loads specified emitter.
    // rus: ???????? ??????????? ????????
    procedure LoadEmitter(hmfile: HM_FILE; path: AnsiString);

    // eng: Returns temp folder
    // rus: ???????? ????????? ?????
    function GetTempFolder: AnsiString;

    // eng: Returns texture's folder
    // rus: ???????? ?????????? ?????
    function GetTextureFolder: AnsiString;

    // eng: Adds frame to the atlas
    // rus: ????????? ????-???? ? ??????
    function AddFrameToAtlas(index: integer; magic_texture: PMAGIC_TEXTURE)
      : TMP_Atlas;

    // eng: Returns texture atlas
    // rus: ?????????? ?????????? ?????
    function GetAtlas(index: integer): TMP_Atlas;

  protected
    // eng: Adds new emitter
    // rus: ?????????? ?????? ???????? ? ??????
    procedure AddEmitter(emitter: TMP_Emitter);
  end;

  // rus: ?????, ??????? ?????? ??????????? ????????
  // eng: Class for work with the emitters
  TMP_Emitter = class
  protected
    // eng: Emitter's state.
    // rus: ????????? ????????
    state: integer;
    // eng: Manager
    // rus: ????????? ?? ????????
    owner: TMP_Manager;
    // eng: Emitter's descriptor
    // rus: ?????????? ????????
    emitter: HM_EMITTER;
    // eng: Z-coordinate of the emitter
    // rus: ?????????? z ????????
    z: single;

    // eng: Is it first restart?
    // rus: ??????? ????, ??? ??????? ??? ?? ??????????? ?? ????????? ??????? ????????
    first_restart: boolean;

    // eng: The file with copy
    // rus: ???? ? ??????
    copy_file: String;

    // eng: The count of saved copyes
    // rus: ??????? ??????????? ????? ?????????? ???????????? ??????
    dimension_count: integer;

  public
    // eng: Returns the descriptor of the emitter to work with API.
    // rus: ???????? ???????
    function GetEmitter: HM_EMITTER;

    // eng: Returns the name of the emitter.
    // rus: ???????? ??? ????????
    function GetEmitterName: AnsiString;

    // eng: Operator "="
    // rus: ???????? ??????????
    procedure Assign(const from: TMP_Emitter);

    // eng: Restarts the emitter
    // rus: ????????? ???????? ?? ????????? ???????
    procedure Restart;

    // eng: Returns and sets the emitter position.
    // rus: ??????? ????????
    procedure GetPosition(var position: TMP_POSITION);
    procedure SetPosition(var position: TMP_POSITION);

    // eng: Moving the emitter to the position specified allowing restart.
    // rus: ??????????? ???????? ? ????????? ??????? ? ???????????? ???????????
    procedure Move(var position: TMP_POSITION; aRestart: boolean = FALSE);

    // eng: Offsetting the current emitter position by the value specified.
    // rus: ???????? ??????? ??????? ???????? ?? ????????? ????????
    procedure Offset(var Offset: TMP_POSITION);

    // eng: Returns and sets emitter's emission direction.
    // rus: ??????????? ????????
    procedure SetDirection(angle: single);
    function GetDirection: single;

    // eng: Setting the emitter direction to the specified value with the restart ability.
    // rus: ??????? ???????? ? ????????? ??????????? ? ???????????? ???????????
    procedure Direct(angle: single; aRestart: boolean = FALSE);

    // eng: Rotation of the emitter by the specified value.
    // rus: ???????? ???????? ?? ????????? ????????
    procedure Rotate(Offset: single);

    // eng: Returns and sets the scale of the emitter.
    // rus: ????????????? ??????? ??????
    procedure SetScale(ascale: single);
    function GetScale: single;

    // eng: Returns and sets the state of the emitter.
    // rus: ??????
    function GetState: integer;
    procedure SetState(astate: integer);

    // eng: Emitter update.
    // rus: ?????????? ????????
    procedure Update(time: double);

    // eng: Emitter visualization. Returns the count of rendered particles
    // rus: ????????? ????????. ???????????? ?????????? ???????????? ??????
    function Render: integer;

    // eng: Loads textures for emitter
    // rus: ???????? ??????? ??? ????????
    procedure LoadTextures;

    constructor Create(aemitter: HM_EMITTER; aowner: TMP_Manager);
    destructor Destroy; override;
  end;

  // ?????, ??????? ?????? ?????????? ????-????? ??? ?????? ???? ??????
  TMP_FrameList = class
  protected
    owner: TMP_Manager;

    m_frame: array of TMP_Frame;

    texture_id: cardinal;
  public

    // eng: Returns owner
    // rus: ?????????? ???????????? ??????
    function GetOwner: TMP_Manager;

    // eng: Returns the count of frames in the texture
    // rus: ???????? ?????????? ?????? ? ????????
    function GetFrameCount: integer;

    // eng: Returns the frame by its index.
    // rus: ???????? ????
    function GetFrame(index: integer): TMP_Frame;

    // eng: Adds the frame
    // rus: ???????? ????
    procedure AddFrame(frame: TMP_Frame);

    // eng: Sets texture's ID.
    // rus: ?????????? ????????????? ????????
    procedure SetTextureID(id: cardinal);

    // eng: Returns texture's ID.
    // rus: ???????? ????????????? ????????
    function GetTextureID: cardinal;

    constructor Create(aowner: TMP_Manager);
    destructor Destroy; override;
  end;

  // eng: This class stores texture atlas. This class is abstract
  // rus: ?????, ??????? ?????? ?????????? ?????. ???? ????? ????? ???????????
  TMP_Atlas = class
  protected
    atlas_width, atlas_height: integer;

  public
    // eng: Loads texture frame
    // rus: ???????? ??????????? ?????
    procedure LoadFrame(var magic_texture: PMAGIC_TEXTURE;
      texture_folder: AnsiString); virtual;

    constructor Create(width, height: integer);
  end;

  // eng: This class stores texture frame-file. This class is abstract
  // rus: ?????, ??????? ?????? ?????????? ????-????. ???? ????? ????? ???????????
  TMP_Frame = class
  protected
    owner: TMP_FrameList;

    magic_texture: TMAGIC_TEXTURE;
  public
    // eng: Returns owner
    // rus: ?????????? ???????????? ??????
    function GetOwner: TMP_FrameList;

    // eng: Initialization of texture frame
    // rus: ????????????? ??????????? ?????
    function InitFrame(var amagic_texture: TMAGIC_TEXTURE): TMP_Atlas; virtual;

    // eng: The beginning of the particle's type drawing
    // rus: ?????? ????????? ???? ??????
    procedure BeginDraw; virtual;

    // eng: The end of the particle's type drawing
    // rus: ????? ????????? ???? ??????
    procedure EndDraw; virtual;

    // eng: Drawing the particle
    // rus: ????????? ???????
    procedure Draw(var magic_particle: TMAGIC_PARTICLE); virtual;

    // eng: Sets the intensity
    // rus: ?????????? ?????????????
    procedure SetIntense(intense: boolean); virtual;

    constructor Create(aowner: TMP_FrameList);
  end;

procedure SetEndOfPath(path: AnsiString);

implementation

uses
  mp_wrap;

// eng: Adds the symbol "/" at the end of the path
// rus: ??????????? ? ????? ???? ??????? "/"
procedure SetEndOfPath(path: AnsiString);
begin
  if length(path) > 0 then
    if (path[length(path)] <> '/') and (path[length(path)] <> '\') then
      path := path + '/';
end;

{ TMP_Manager }

procedure TMP_Manager.AddEmitter(emitter: TMP_Emitter);
// eng: Adds new emitter
// rus: ?????????? ?????? ???????? ? ??????
begin
  setlength(m_emitter, length(m_emitter) + 1);
  m_emitter[length(m_emitter) - 1] := emitter;
end;

function TMP_Manager.AddFrameList: TMP_FrameList;
begin
  // eng: Adds the new frame-list.
  // rus: ?????????? ?????? ?????? ??????
  setlength(m_framelist, length(m_framelist) + 1);
  m_framelist[length(m_framelist) - 1] := TMP_FrameList.Create(self);
  result := m_framelist[length(m_framelist) - 1];
end;

function TMP_Manager.AddFrameToAtlas(index: integer;
  magic_texture: PMAGIC_TEXTURE): TMP_Atlas;
var
  i, old_len: integer;
begin
  // eng: Adds frame to the atlas
  // rus: ????????? ????-???? ? ??????
  if index >= length(m_atlas) then
  begin
    old_len := length(m_atlas);
    setlength(m_atlas, index + 1);
    for i := old_len to index do
      m_atlas[i] := nil;
  end;

  if m_atlas[index] = nil then
    m_atlas[index] := TMP_Atlas_WRAP.Create(magic_texture.texture_width,
      magic_texture.texture_height);

  if (magic_texture^.data <> nil) or (magic_texture^.file_name <> nil) then
    m_atlas[index].LoadFrame(magic_texture, texture_folder);
  result := m_atlas[index];
end;

procedure TMP_Manager.CloseFiles;
begin
  // eng: Closing files.
  // rus: ???????? ???? ??????
  Magic_CloseAllFiles;
end;

constructor TMP_Manager.Create;
begin
  // eng: The settings for default initialization of emitters
  // rus: ????????? ??? ????????????? ????????? ?? ?????????

  interpolation := MAGIC_INTERPOLATION_ENABLE;
  loop := MAGIC_LOOP;
  position_mode := MAGIC_CHANGE_EMITTER_ONLY;
end;

destructor TMP_Manager.Destroy;
var
  i: integer;
begin
  for i := 0 to length(m_emitter) - 1 do
    if m_emitter[i] <> nil then
      m_emitter[i].Free;
  m_emitter := nil;

  for i := 0 to length(m_framelist) - 1 do
    if m_framelist[i] <> nil then
      m_framelist[i].Free;
  m_framelist := nil;

  for i := 0 to length(m_atlas) - 1 do
    if m_atlas[i] <> nil then
      m_atlas[i].Free;
  m_atlas := nil;

  inherited;
end;

function TMP_Manager.DuplicateEmitter(from: TMP_Emitter): integer;
var
  emitter: TMP_Emitter;
begin
  // ???????????? ????????
  emitter := TMP_Emitter.Create(0, self);
  emitter.Assign(from);
  AddEmitter(emitter);
  result := length(m_emitter) - 1;
end;

function TMP_Manager.GetAtlas(index: integer): TMP_Atlas;
begin
  result := m_atlas[index];
end;

function TMP_Manager.GetEmitter(index: integer): TMP_Emitter;
begin
  // ???????? ???????
  if (index >= 0) and (index < length(m_emitter)) then
    result := m_emitter[index]
  else
    result := nil;
end;

function TMP_Manager.GetEmitterByName(name: AnsiString): TMP_Emitter;
var
  i: integer;
  emitter_name: AnsiString;
begin
  // eng: Returns the emitter by name.
  // rus: ???????? ??????? ?? ?????
  result := nil;
  for i := 0 to length(m_emitter) - 1 do
  begin
    emitter_name := m_emitter[i].GetEmitterName;
    if emitter_name = name then
    begin
      result := m_emitter[i];
      exit;
    end;
  end;
end;

function TMP_Manager.GetEmitterCount: integer;
begin
  result := length(m_emitter);
end;

function TMP_Manager.GetFrameList(index: integer): TMP_FrameList;
begin
  // eng: Returns the frame-list by its index.
  // rus: ???????? ?????? ??????
  if (index >= 0) and (index < length(m_framelist)) then
    result := m_framelist[index]
  else
    result := nil;
end;

function TMP_Manager.GetFrameListCount: integer;
begin
  result := length(m_framelist);
end;

function TMP_Manager.GetTempFolder: AnsiString;
begin
  result := temp_folder;
end;

function TMP_Manager.GetTextureFolder: AnsiString;
begin
  result := texture_folder;
end;

procedure TMP_Manager.Init(ainterpolation, aloop: integer;
  aposition_mode: boolean; atemp_folder: AnsiString);
begin
  interpolation := ainterpolation;
  loop := aloop;
  position_mode := aposition_mode;

  if atemp_folder <> '' then
  begin
    temp_folder := atemp_folder;
    SetEndOfPath(temp_folder);
  end;
end;

procedure TMP_Manager.LoadEmitter(hmfile: HM_FILE; path: AnsiString);
var
  emitter: HM_EMITTER;
  em: TMP_Emitter;
  _interpolation: boolean;
begin
  // eng: Loads specified emitter.
  // rus: ???????? ??????????? ????????
  // eng: It needs to extract the emitter from the file
  // rus: ????? ??????? ??????? ?? ?????
  if Magic_LoadEmitter(hmfile, pansichar(path), emitter) = MAGIC_SUCCESS then
  begin
    em := TMP_Emitter.Create(emitter, self);
    AddEmitter(em);
    // eng: Default initialization
    // rus: ????????????? ???????? ?????????? ?? ?????????
    if interpolation <> MAGIC_INTERPOLATION_DEFAULT then
    begin
      _interpolation := FALSE;
      if interpolation = MAGIC_INTERPOLATION_ENABLE then
        _interpolation := TRUE;
      Magic_SetInterpolationMode(emitter, _interpolation);
    end;
    Magic_SetLoopMode(emitter, loop);
    Magic_SetEmitterPositionMode(emitter, position_mode);
    Magic_SetEmitterDirectionMode(emitter, position_mode);
  end;
end;

function TMP_Manager.LoadEmittersFromFile(file_name: AnsiString): integer;
var
  mf: HM_FILE;
begin
  // eng: Loading all the emitters and animated folders from the file specified.
  // rus: ???????? ???? ????????? ? ????????????? ?????? ?? ?????????? ?????
  if Magic_OpenFile(pansichar(file_name), mf) = MAGIC_SUCCESS then
  begin
    // ???? ??????? ??????
    LoadFolder(mf, '');
    result := MAGIC_SUCCESS;
  end
  else
    result := MAGIC_ERROR;
end;

procedure TMP_Manager.LoadFolder(hmfile: HM_FILE; path: AnsiString);
var
  find: TMAGIC_FIND_DATA;
  name: pansichar;
begin
  // eng: Loads folder
  // rus: ???????? ?????
  Magic_SetCurrentFolder(hmfile, pansichar(path));
  name := Magic_FindFirst(hmfile, find, MAGIC_FOLDER or MAGIC_EMITTER);
  while name <> nil do
  begin
    if find.animate > 0 then
      LoadEmitter(hmfile, name)
    else
      LoadFolder(hmfile, name);

    name := Magic_FindNext(hmfile, find);
  end; // while
  Magic_SetCurrentFolder(hmfile, '..');
end;

procedure TMP_Manager.LoadTextures(atexture_folder: AnsiString;
  atlas_width, atlas_height, frame_step: integer; scale_step: single);
var
  i: integer;
begin
  // eng: Loading textures for the existing emitters.
  // rus: ???????? ???????
  texture_folder := '';
  if atexture_folder <> '' then
  begin
    texture_folder := atexture_folder;
    SetEndOfPath(texture_folder);
  end;

  Magic_CreateAtlases(atlas_width, atlas_height, frame_step, scale_step);

  for i := 0 to length(m_emitter) - 1 do
    m_emitter[i].LoadTextures;
end;

procedure TMP_Manager.Stop;
var
  i, k_emitter: integer;
begin
  // eng: Stopping all the emitters.
  // rus: ????????? ?????????
  k_emitter := GetEmitterCount;
  for i := 0 to k_emitter - 1 do
    GetEmitter(i).SetState(MAGIC_STATE_STOP);
end;

procedure TMP_Manager.Update(time: double);
var
  i: integer;
  astate: integer;
begin
  // eng: Stopping all the emitters.
  // rus: ????????? ?????????
  for i := 0 to length(m_emitter) - 1 do
  begin
    astate := m_emitter[i].GetState;
    if (astate = MAGIC_STATE_UPDATE) or (astate = MAGIC_STATE_INTERRUPT) then
      m_emitter[i].Update(time);
  end;
end;

{ TMP_POSITION }

class operator TMP_POSITION.Add(const Left, Right: TMP_POSITION): TMP_POSITION;
begin
  result.x := Left.x + Right.x;
  result.y := Left.y + Right.y;
  result.z := Left.z + Right.z;
end;

procedure TMP_POSITION.from(ax, ay, az: single);
begin
  x := ax;
  y := ay;
  z := az;
end;

procedure TMP_POSITION.from;
begin
  x := 0;
  y := 0;
  z := 0;
end;

procedure TMP_POSITION.from(ax, ay: single);
begin
  x := ax;
  y := ay;
  z := 0;
end;

{ TMP_Emitter }

procedure TMP_Emitter.Assign(const from: TMP_Emitter);
begin
  state := from.state;
  z := from.z;
  copy_file := from.copy_file;
  Magic_DuplicateEmitter(from.emitter, emitter);
end;

constructor TMP_Emitter.Create(aemitter: HM_EMITTER; aowner: TMP_Manager);
begin
  emitter := aemitter;
  owner := aowner;
  z := 0;
  first_restart := TRUE;

  // eng: The file with copy
  // rus: ???? ? ??????
  copy_file := '';

  // eng: Emitter is updated and rendered
  // rus: ??????? ????? ?????????????? ? ????????????
  state := MAGIC_STATE_UPDATE;
end;

destructor TMP_Emitter.Destroy;
begin
  Magic_UnloadEmitter(emitter);
  inherited;
end;

procedure TMP_Emitter.Direct(angle: single; aRestart: boolean);
var
  mode: boolean;
begin
  // eng: Setting the emitter direction to the specified value with the restart ability.
  // rus: ??????? ???????? ? ????????? ??????????? ? ???????????? ???????????
  // ???? ??????????? ? ????????
  if aRestart then
  begin
    Restart;
    SetDirection(angle);
  end
  else
  begin
    mode := Magic_GetEmitterDirectionMode(emitter);
    if mode = MAGIC_CHANGE_EMITTER_ONLY then
      // eng: Temporary sets the MAGIC_CHANGE_EMITTER_AND_PARTICLES mode
      // rus: ???????? ????????????? ????? ??????????? ?????? ? ?????????
      Magic_SetEmitterDirectionMode(emitter,
        MAGIC_CHANGE_EMITTER_AND_PARTICLES);

    SetDirection(angle);

    if mode = MAGIC_CHANGE_EMITTER_ONLY then
      // eng: Returns old mode
      // rus: ?????????? ?? ????? ?????? ????? ???????????
      Magic_SetEmitterDirectionMode(emitter, MAGIC_CHANGE_EMITTER_ONLY);
  end;
end;

function TMP_Emitter.GetDirection: single;
begin
  Magic_GetEmitterDirection(emitter, result);
end;

function TMP_Emitter.GetEmitter: HM_EMITTER;
begin
  result := emitter;
end;

function TMP_Emitter.GetEmitterName: AnsiString;
begin
  // eng: Returns the name of the emitter.
  // rus: ???????? ??? ????????
  result := Magic_GetEmitterName(emitter);
end;

procedure TMP_Emitter.GetPosition(var position: TMP_POSITION);
begin
  Magic_GetEmitterPosition(emitter, position.x, position.y);
  position.z := z;
end;

function TMP_Emitter.GetScale: single;
begin
  result := Magic_GetScale(emitter);
end;

function TMP_Emitter.GetState: integer;
begin
  result := state;
end;

procedure TMP_Emitter.LoadTextures;
var
  k_emitter_in_folder, k_particles, k_framelist, k_frame: integer;
  i, j, n: integer;
  emitter_in_folder: HM_EMITTER;
  framelist: TMP_FrameList;
  texture_id: cardinal;
  magic_texture: PMAGIC_TEXTURE;
  frame: TMP_Frame;
begin
  // eng: Loading textures for the emitter.
  // rus: ???????? ??????? ??? ????????
  k_emitter_in_folder := Magic_GetEmitterCount(emitter);
  for i := 0 to k_emitter_in_folder - 1 do
  begin
    emitter_in_folder := Magic_GetEmitter(emitter, i);
    k_particles := Magic_GetParticlesTypeCount(emitter_in_folder);

    for j := 0 to k_particles - 1 do
    begin
      Magic_LockParticlesType(emitter_in_folder, j);
      framelist := owner.AddFrameList;
      texture_id := Magic_GetTextureID;
      framelist.SetTextureID(texture_id);
      k_framelist := owner.GetFrameListCount;
      // eng: Saving index of the new texture for the fast access
      // rus: ????????? ?????? ????????? ???????? ??? ???????? ???????
      Magic_SetTextureID(k_framelist - 1);

      k_frame := Magic_GetTextureCount;
      for n := 0 to k_frame - 1 do
      begin
        magic_texture := Magic_GetTexture(n);

        frame := TMP_Frame_WRAP.Create(framelist);
        framelist.AddFrame(frame);
        frame.InitFrame(magic_texture^);
      end;
      Magic_UnlockParticlesType;
    end; // for j
  end; // for i

end;

procedure TMP_Emitter.Move(var position: TMP_POSITION; aRestart: boolean);
var
  mode: boolean;
begin
  // eng: Moving the emitter to the position specified allowing restart.
  // rus: ??????????? ???????? ? ????????? ??????? ? ???????????? ???????????
  if aRestart then
  begin
    Restart;
    SetPosition(position);
  end
  else
  begin
    mode := Magic_GetEmitterPositionMode(emitter);

    if mode = MAGIC_CHANGE_EMITTER_ONLY then
      // eng: Temporary sets the MAGIC_CHANGE_EMITTER_AND_PARTICLES mode
      // rus: ???????? ????????????? ????? ??????????? ?????? ? ?????????
      Magic_SetEmitterPositionMode(emitter, MAGIC_CHANGE_EMITTER_AND_PARTICLES);

    SetPosition(position);

    if mode = MAGIC_CHANGE_EMITTER_ONLY then
      // eng: Returns old mode
      // rus: ?????????? ?? ????? ?????? ????? ???????????
      Magic_SetEmitterPositionMode(emitter, MAGIC_CHANGE_EMITTER_ONLY);
  end;
end;

procedure TMP_Emitter.Offset(var Offset: TMP_POSITION);
var
  pos: TMP_POSITION;
begin
  // eng: Offsetting the current emitter position by the value specified.
  // rus: ???????? ??????? ??????? ???????? ?? ????????? ????????
  GetPosition(pos);
  pos := pos + Offset;
  SetPosition(pos);
end;

function TMP_Emitter.Render: integer;
var
  framelist_index, count, i, j, k, k_frame: integer;
  k_emitter_in_folder, k_particles: integer;
  emitter_in_folder: HM_EMITTER;
  framelist: TMP_FrameList;
  first_frame: TMP_Frame;
  intense: boolean;
  particle: PMAGIC_PARTICLE;
  frame: TMP_Frame;
begin
  // eng: Emitter visualization. Returns the count of rendered particles
  // rus: ????????? ????????. ???????????? ?????????? ???????????? ??????
  count := 0;
  if state <> MAGIC_STATE_STOP then
  begin
    k_emitter_in_folder := Magic_GetEmitterCount(emitter);
    // eng: enumerate all the emitters within the emitter (for the animated folders)
    // rus: ??????????? ??? ???????? ?????? ???????? (??? ????????????? ?????)
    for i := k_emitter_in_folder - 1 downto 0 do
    begin
      emitter_in_folder := Magic_GetEmitter(emitter, i);
      if Magic_InInterval(emitter_in_folder) then
      begin
        k_particles := Magic_GetParticlesTypeCount(emitter_in_folder);
        // eng: enumerate all particles types within the emitter
        // rus: ??????????? ??? ???? ?????? ?????? ????????
        for j := k_particles - 1 downto 0 do
        begin
          Magic_LockParticlesType(emitter_in_folder, j);
          framelist_index := Magic_GetTextureID;
          framelist := owner.GetFrameList(framelist_index);

          if framelist.GetFrameCount > 0 then
          begin
            // eng: Instead of the first frame, you can get any other. It is need only for BeginDraw/EndDraw call
            // rus: ?????? ??????? ?????, ????? ????? ?????, ??? ????????? ?????? ??? ?????? BeginDraw/EndDraw
            first_frame := framelist.GetFrame(0);
            first_frame.BeginDraw;

            // eng: It needs to set intensivity
            // rus: ?????????? ?????????? ?????????????
            intense := Magic_IsIntensive;
            k_frame := framelist.GetFrameCount;
            for k := 0 to k_frame - 1 do
              framelist.GetFrame(k).SetIntense(intense);

            // eng: Drawing particles
            // rus: ????????? ??????
            while (TRUE) do
            begin
              particle := Magic_GetNextParticle;

              if (particle = nil) then
                break;

              frame := framelist.GetFrame(particle.frame);
              frame.Draw(particle^);
              inc(count);
            end; // while

            first_frame.EndDraw;

            if intense then
              for k := 0 to k_frame - 1 do
                framelist.GetFrame(k).SetIntense(FALSE);
          end; // if
          Magic_UnlockParticlesType;
        end; // for j
      end; // if
    end; // for i
  end; // if
  result := count;
end;

procedure TMP_Emitter.Restart;
var
  temp_folder: AnsiString;
  temp_file: pansichar;
begin
  // eng: Restarts the emitter
  // rus: ????????? ???????? ?? ????????? ???????
  copy_file := '';

  if Magic_IsInterval1(emitter) then
  begin
    // ???????? ?????????? ?? ? ??????
    temp_folder := owner.GetTempFolder;
    if temp_folder <> '' then
    begin
      copy_file := temp_folder + 'mp';
      copy_file := copy_file + inttostr(dimension_count);
      inc(dimension_count);
      if first_restart then
        copy_file := '';
    end;

    temp_file := nil;
    if copy_file <> '' then
      temp_file := pansichar(copy_file);

    Magic_EmitterToInterval1(emitter, temp_file);
  end
  else
  begin
    Magic_Restart(emitter);
  end;
  first_restart := FALSE;
end;

procedure TMP_Emitter.Rotate(Offset: single);
var
  angle: single;
begin
  // eng: Rotation of the emitter by the specified value.
  // rus: ???????? ???????? ?? ????????? ????????
  angle := GetDirection;
  angle := angle + Offset;
  SetDirection(angle);
end;

procedure TMP_Emitter.SetDirection(angle: single);
begin
  // ??????????? ????????
  Magic_SetEmitterDirection(emitter, angle);
end;

procedure TMP_Emitter.SetPosition(var position: TMP_POSITION);
begin
  Magic_SetEmitterPosition(emitter, position.x, position.y);
  z := position.z;
end;

procedure TMP_Emitter.SetScale(ascale: single);
begin
  // eng: Returns and sets the scale of the emitter.
  // rus: ????????????? ??????? ??????
  Magic_SetScale(emitter, ascale);
end;

procedure TMP_Emitter.SetState(astate: integer);
var
  temp_file: pansichar;
begin
  // eng: Returns and sets the state of the emitter.
  // rus: ??????
  if state <> astate then
  begin
    if (astate = MAGIC_STATE_UPDATE) and (Magic_IsInterrupt(emitter)) then
      // eng: We need to stop the interrupt of the emitter
      // rus: ?????????? ????????? ?????????? ?????? ????????
      Magic_SetInterrupt(emitter, FALSE);

    if (astate = MAGIC_STATE_STOP) and (state <> MAGIC_STATE_INTERRUPT) then
      // eng: Stops the emitter
      // rus: ????????? ???????????? ?????? ?? ??????
      Magic_Stop(emitter)
    else if (astate = MAGIC_STATE_UPDATE) or (astate = MAGIC_STATE_INTERRUPT) then
    begin
      if not first_restart then
        if (state = MAGIC_STATE_STOP) or (not Magic_InInterval(emitter)) then
        begin
          // eng: The position of emitter's animation do not includes in the visibility interval
          // eng: It is need to set it at begin
          // rus: ??????? ???????? ???????? ?? ?????? ? ???????? ?????????
          // rus: ?????????? ??????????? ????????? ?? ??????
          temp_file := nil;
          if copy_file <> '' then
            temp_file := pansichar(copy_file);
          Magic_EmitterToInterval1(emitter, temp_file);
        end;

      if astate = MAGIC_STATE_INTERRUPT then
        Magic_SetInterrupt(emitter, TRUE);
    end;
    state := astate;
  end;
end;

procedure TMP_Emitter.Update(time: double);
begin
  // eng: Emitter update.
  // rus: ?????????? ????????
  if (state = MAGIC_STATE_UPDATE) or (state = MAGIC_STATE_INTERRUPT) then
  begin
    if first_restart then
      Restart;

    if not(Magic_IsInterpolationMode(emitter)) then
      // It is possible only fixed step without interpolation
      // ??? ???????????? ???????? ?????? ????????????? ???
      time := Magic_GetUpdateTime(emitter);

    if not Magic_Update(emitter, time) then
      // The emitter is stopped
      // ?????????? ???????? ?????????
      SetState(MAGIC_STATE_STOP);
  end;
end;

{ TMP_FrameList }

procedure TMP_FrameList.AddFrame(frame: TMP_Frame);
begin
  setlength(m_frame, length(m_frame) + 1);
  m_frame[length(m_frame) - 1] := frame;
end;

constructor TMP_FrameList.Create(aowner: TMP_Manager);
begin
  owner := aowner;
  m_frame := nil;
  texture_id := high(cardinal);
end;

destructor TMP_FrameList.Destroy;
var
  i: integer;
begin
  for i := 0 to length(m_frame) - 1 do
    if m_frame[i] <> nil then
    begin
      m_frame[i].Free;
      m_frame[i] := nil;
    end;
  m_frame := nil;
  inherited;
end;

function TMP_FrameList.GetFrame(index: integer): TMP_Frame;
begin
  if (index >= 0) and (index < length(m_frame)) then
    result := m_frame[index]
  else
    result := nil;
end;

function TMP_FrameList.GetFrameCount: integer;
begin
  result := length(m_frame);
end;

function TMP_FrameList.GetOwner: TMP_Manager;
begin
  result := owner;
end;

function TMP_FrameList.GetTextureID: cardinal;
begin
  result := texture_id;
end;

procedure TMP_FrameList.SetTextureID(id: cardinal);
begin
  texture_id := id;
end;

{ TMP_Atlas }

constructor TMP_Atlas.Create(width, height: integer);
begin
  atlas_width := width;
  atlas_height := height;
end;

procedure TMP_Atlas.LoadFrame(var magic_texture: PMAGIC_TEXTURE;
  texture_folder: AnsiString);
begin
end;

{ TMP_Frame }

procedure TMP_Frame.BeginDraw;
begin
end;

constructor TMP_Frame.Create(aowner: TMP_FrameList);
begin
  owner := aowner;
end;

procedure TMP_Frame.Draw(var magic_particle: TMAGIC_PARTICLE);
begin
end;

procedure TMP_Frame.EndDraw;
begin
end;

function TMP_Frame.GetOwner: TMP_FrameList;
begin
  result := owner;
end;

function TMP_Frame.InitFrame(var amagic_texture: TMAGIC_TEXTURE): TMP_Atlas;
var
  texture_id: cardinal;
  manager: TMP_Manager;
begin
  magic_texture := amagic_texture;
  manager := owner.GetOwner;
  texture_id := owner.GetTextureID;
  result := manager.AddFrameToAtlas(texture_id, @magic_texture);
end;

procedure TMP_Frame.SetIntense(intense: boolean);
begin
end;

end.
