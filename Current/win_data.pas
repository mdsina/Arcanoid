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

unit win_data;

interface
{$MODE DELPHI}

uses
  windows;

// eng: Returns the time in ticks.
// rus: Получение времени в тиках
function GetTick: cardinal;

// eng: Returns the path to the Temp folder.
// rus: Получить путь к временной папке
function GetPathToTemp: AnsiString;

// eng: Returns the path to the folder with textures.
// rus: Получить путь к папке с текстурами
// rus: Эта папка textures в текущей папке
function GetPathToTexture: AnsiString;

// eng: Returns first or next file in the current folder.
// rus: Перебор ptc-файлов в текущей папке
function GetFirstFile: AnsiString;
function GetNextFile: AnsiString;

var
  fd: WIN32_FIND_DATA;
  hFindFile: THANDLE;

implementation

function GetTick: cardinal;
begin
  result := GetTickCount;
end;

function CreatePath(path: AnsiString): boolean;
var
  k_dirs, j, i, t, create: integer;
  m_dirs: array [0 .. 49] of AnsiString;
  dir: AnsiString;
  net, ok: boolean;
  old_path: array [1 .. MAX_PATH] of PAnsiChar;
begin
  k_dirs := 0;
  net := false;
  j := 1;

  if length(path) > 1 then
    if ((path[1] = '\') or (path[1] = '/')) and
      ((path[2] = '\') or (path[2] = '/')) then
    begin
      dir := '\\';
      j := 3;
      net := true;
    end;

  for i := j to length(path) do
    if (path[i] = '\') or (path[i] = '/') then
    begin
      dir := dir + path[i];
      if net then
        net := false
      else
      begin
        m_dirs[k_dirs] := dir;
        inc(k_dirs);
        dir := '';
      end;
    end
    else
    begin
      dir := dir + path[i];
    end;

  if dir <> '' then
  begin
    m_dirs[k_dirs] := dir;
    inc(k_dirs);
  end;

  GetCurrentDirectoryA(MAX_PATH, @old_path);

  create := 10000;
  t := -1;
  ok := false;
  for i := 0 to k_dirs - 1 do
  begin
    dir := m_dirs[i];
    ok := SetCurrentDirectoryA(PAnsiChar(dir));
    if not ok then
    begin
      ok := CreateDirectoryA(PAnsiChar(dir), nil);
      if ok then
        SetCurrentDirectoryA(PAnsiChar(dir));

      if not ok then
        // rus: произошла ошибка
        break
      else if create = 10000 then
        create := i;
    end;
    t := i;
  end;

  if not ok then
  begin
    // rus: необходимо удалить созданный путь
    for i := t downto create do
    begin
      dir := m_dirs[i];
      if SetCurrentDirectoryA('..') then
      begin
        if not RemoveDirectoryA(PAnsiChar(dir)) then
          break;
      end
      else
        break;
    end;
  end;

  SetCurrentDirectoryA(@old_path);
  result := ok;
end;

// eng: Returns the path to the Temp Folder
// rus: Получить путь к временной папке
function GetPathToTemp: AnsiString;
var
  szPath: array [1 .. MAX_PATH] of AnsiChar;
  h_Key: HKEY;
  dwSize: cardinal;
  i: integer;
begin
  if RegOpenKeyExA(HKEY_LOCAL_MACHINE,
    'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', 0,
    KEY_QUERY_VALUE, h_Key) = ERROR_SUCCESS then
  begin
    dwSize := MAX_PATH;
    RegQueryValueExA(h_Key, 'Common AppData', nil, nil, @szPath, @dwSize);
    RegCloseKey(h_Key);
  end;

  result := PAnsiChar(@szPath);

  if length(result) = 0 then
  begin
    // rus: Версия Windows не поддерживает Application Data
    // rus: Можно записывать в собственный Temp
    GetWindowsDirectoryA(@szPath, MAX_PATH);
    result := PAnsiChar(@szPath);
    if result[length(result)] <> '\' then
      result := result + '\';
    result := result + 'Application Data';
  end;

  if result[length(result)] <> '\' then
    result := result + '\';
  result := result + 'Particles\API';

  CreatePath(result);

  result := result + '\';

  for i := 1 to length(result) do
    if result[i] = '\' then
      result[i] := '/';
end;

// eng: Returns the path to the folder with textures.
// rus: Получить путь к папке с текстурами. Это папка textures в текущей папке
function GetPathToTexture: AnsiString;
var
  szFileName: array [1 .. MAX_PATH + 1] of AnsiChar;
  i: integer;
begin
  GetCurrentDirectoryA(sizeof(szFileName), @szFileName);
  result := PAnsiChar(@szFileName);
  result := result + '\textures\';

  for i := 1 to length(result) do
    if result[i] = '\' then
      result[i] := '/';
end;

// eng: Returns first or next file in the current folder
// rus: Перебор ptc-файлов в текущей папке
function GetFirstFile: AnsiString;
begin
  hFindFile := FindFirstFile('*.ptc', fd);
  if hFindFile <> INVALID_HANDLE_VALUE then
  begin
    result := fd.cFileName;
    exit;
  end;
  FindClose(hFindFile);
  result := '';
end;

function GetNextFile: AnsiString;
begin
  if FindNextFile(hFindFile, fd) then
  begin
    result := fd.cFileName;
    exit;
  end;
  FindClose(hFindFile);
  result := '';
end;

end.
