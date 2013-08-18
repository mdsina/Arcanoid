{*******************************************************}
{                                                       }
{       Header file for Magic Particles DLL (1.72)      }
{       www.astralax.com                                }
{                                                       }
{       ark.su (C) www.ark.su 09.11.2009                }
{                                                       }
{       Checked on Delphi versions:                     }
{       2007, 2009, 2010, FPC 2.6.2                     }
{                                                       }
{*******************************************************}

unit magic;
{$MODE DELPHI}

interface

{$IFNDEF MAGIC_PARTICLES_LIBRARY}
  {$DEFINE MAGIC_PARTICLES_LIBRARY}
{$ENDIF}

type
  HM_FILE                   = integer;
  HM_EMITTER                = integer;
  HM_IMPORT                 = integer;

const
  MAGIC_SUCCESS	            = -1;
  MAGIC_ERROR		            = -2;
  MAGIC_UNKNOWN	            = -3;

  MAGIC_FOLDER	            = 1;
  MAGIC_EMITTER	            = 2;

  MAGIC_NOLOOP	            = 0;
  MAGIC_LOOP		            = 1;
  MAGIC_FOREVER	            = 2;

  MAGIC_COLOR_STANDARD	    = 0;
  MAGIC_COLOR_TINT		      = 1;
  MAGIC_COLOR_USER		      = 2;

  MAGIC_EMITTER_POINT		    = 0;
  MAGIC_EMITTER_LINE		    = 1;
  MAGIC_EMITTER_CIRCLE	    = 2;
  MAGIC_EMITTER_ELLIPSE	    = 3;
  MAGIC_EMITTER_SQUARE	    = 4;
  MAGIC_EMITTER_RECTANGLE	  = 5;
  MAGIC_EMITTER_IMAGE		    = 6;
  MAGIC_EMITTER_TEXT		    = 7;

  MAGIC_DIAGRAM_LIFE				= 0;
  MAGIC_DIAGRAM_NUMBER			= 1;
  MAGIC_DIAGRAM_SIZE				= 2;
  MAGIC_DIAGRAM_VELOCITY		= 3;
  MAGIC_DIAGRAM_WEIGHT			= 4;
  MAGIC_DIAGRAM_SPIN				= 5;
  MAGIC_DIAGRAM_ANGULAR_VELOCITY	= 6;
  MAGIC_DIAGRAM_MOTION_RAND	= 7;
  MAGIC_DIAGRAM_VISIBILITY	= 8;
  MAGIC_DIAGRAM_DIRECTION		= 9;

  MAGIC_PI = 3.1415926535897932384626433832795028841971693993751058209;

type
// eng: MAGIC_PARTICLE - particle structure, containing all of its properties used for visualization
// rus: Cтруктура частицы для визуализации
  TMAGIC_PARTICLE = record
  	x,y     : single;
	  size    : single;
  	angle   : single;
	  color   : cardinal;
  	frame   : cardinal;
  end;
  PMAGIC_PARTICLE = ^TMAGIC_PARTICLE;

// eng: MAGIC_TEXTURE - structure, containing texture frame-file information
// rus: Структура, хранящая информацию о текстуре
  TMAGIC_TEXTURE = record
  	length    : cardinal;	// eng: The length of the file (in byth) // rus: количество байт в файле
	  data      : pointer;		// eng: The image of the file // rus: образ файла
  	crc       : integer;	// eng: CRC of the file // rus: контрольная сумма образа файла
	  file_name : pAnsiChar;		// eng: The file's name // rus: имя файла
  	path      : pAnsiChar;

  	left,top,right,bottom : single;

	  frame_width     : integer;
  	frame_height    : integer;

	  texture_width   : integer;
  	texture_height  : integer;

	  pivot_x         : single;
  	pivot_y         : single;

	  scale           : single;
  end;
  PMAGIC_TEXTURE = ^TMAGIC_TEXTURE;

// eng: MAGIC_ATLAS - structure, containing information on frame file locations within the textural atlas
// rus: Структура, хранящая информацию о текстурном атласе
  TMAGIC_ATLAS = record
  	width     : integer;
  	height    : integer;
  	count     : integer;
    textures  : ^PMAGIC_TEXTURE;
  end;
  PMAGIC_ATLAS = ^TMAGIC_ATLAS;

// eng: MAGIC_FIND_DATA - is a structure that is used in searching emitters and directories
// rus: Структура для перебора папок и эмиттеров в текущей папке
  TMAGIC_FIND_DATA = record
	// eng: result
	// rus: результат
	  atype   : integer;
  	name    : pAnsiChar;
	  animate : integer;

  	mode    : integer;

	  // eng: additional data
	// rus: дополнительные данные
  	folder  : pointer;
	  index   : integer;
  end;
  PMAGIC_FIND_DATA = ^TMAGIC_FIND_DATA;

// eng: MAGIC_VERTEX_RECTANGLE - structure, storing the coordinates of the particle rectangle vertice
// rus: Структура для получения координат вершин частицы
  TMAGIC_VERTEX_RECTANGLE = record
  	x1,y1 : single;
  	x2,y2 : single;
  	x3,y3 : single;
	  x4,y4 : single;
  end;
  PMAGIC_VERTEX_RECTANGLE = ^TMAGIC_VERTEX_RECTANGLE;

// eng: MAGIC_TRAJECTORY - structure, containing additional particle trajectory information
// rus: Структура для хранения информации о траектории одной частицы
  TMAGIC_TRAJECTORY = record
  	start     : integer;
  	duration  : integer;
	  atype     : integer;
  end;
  PMAGIC_TRAJECTORY = ^TMAGIC_TRAJECTORY;

// eng: MAGIC_IMPORT_PARTICLES_TYPE - structure for information about exported particles type
// rus: Структура для получения информации об экспортированных типах частиц
  TMAGIC_IMPORT_PARTICLES_TYPE = record
  	name      : pAnsiChar;
  	parent    : integer;
	  attached  : boolean;
  	emitter   : integer;
	  is_3d     : boolean;
  end;
  PMAGIC_IMPORT_PARTICLES_TYPE = ^TMAGIC_IMPORT_PARTICLES_TYPE;

// eng: MAGIC_IMPORT_EMITTER - structure for information about exported emitters
// rus: Структура для получения информации об экспортированных эмиттерах
  TMAGIC_IMPORT_EMITTER = record
  	name : pAnsiChar;
	  x, y : integer;
  end;
  PMAGIC_IMPORT_EMITTER = ^TMAGIC_IMPORT_EMITTER;

// eng: MAGIC_IMPORT_PARTICLE_ID - structure of identification information about particle
// rus: Структура идентификационной информации о частице
  TMAGIC_IMPORT_PARTICLE_ID = record
  	id              : cardinal;
	  parent_id       : cardinal;
  	attached_state  : byte;
  end;
  PMAGIC_IMPORT_PARTICLE_ID = ^TMAGIC_IMPORT_PARTICLE_ID;

const
  magicdll = 'magic.dll';

// eng: Loads the ptc-file from the path specified
// rus: Открытие ptc-файла
function Magic_OpenFile(const file_name : pAnsiChar; var hmFile : HM_FILE) : integer; cdecl; external magicdll;

// eng: Loads the ptc-file image from the memory
// rus: Открытие образа ptc-файла из памяти
function Magic_OpenFileInMemory(const buffer : pointer; var hmFile : HM_FILE) : integer; cdecl; external magicdll;

// eng: Closes the file, opened earlier by use of Magic_OpenFile or Magic_OpenFileInMemory
// rus: Закрытие файла
function Magic_CloseFile(hmFile : HM_FILE) : integer; cdecl; external magicdll;

// eng: Closing all the opened files
// rus: Закрытие всех файлов
procedure Magic_CloseAllFiles; cdecl; external magicdll;

// eng: Returns the current folder path
// rus: Возвращает полный путь к текущей папке
function Magic_GetCurrentFolder(hmFile : HM_FILE) : pAnsiChar; cdecl; external magicdll;

// eng: Sets the new current folder
// rus: Установить новый путь к текущей папке
function Magic_SetCurrentFolder(hmFile : HM_FILE; const path : pAnsiChar = nil) : integer; cdecl; external magicdll;

// eng: Searches for the first folder or emitter within the current folder and returns the type of the object found
// rus: Ищет первую папку или первый эмиттер в текущей папке и возвращает имя и тип найденного объекта
function Magic_FindFirst(hmFile : HM_FILE; var data : TMAGIC_FIND_DATA; mode : integer) : pAnsiChar; cdecl; external magicdll;

// eng: Searches for the next folder or emitter within the current folder and returns the type of the object found
// rus: Ищет очередную папку или очередной эмиттер в текущей папке и возвращает имя и тип найденного объекта
function Magic_FindNext(hmFile : HM_FILE; var data : TMAGIC_FIND_DATA) : pAnsiChar; cdecl; external magicdll;

// eng: Returns the name of the file that was opened through the Magic_OpenFile
// rus: Возвращает имя файла, открытого через Magic_OpenFile
function Magic_GetFileName(hmFile : HM_FILE) : pAnsiChar; cdecl; external magicdll;

// eng: Creates the emitter object and loads its data
// rus: Создает эмиттер и загружает в него данные
function Magic_LoadEmitter(hmFile : HM_FILE; const name : pAnsiChar; var hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Unloads the emitter data and destroys it
// rus: Выгрузка эмиттера
function Magic_UnloadEmitter(hmEitter : HM_EMITTER) : integer; cdecl; external magicdll;

// --------------------------------------------------------------------------------

// eng: Gets the copy of the emitter
// rus: Дублирует эмиттер
function Magic_DuplicateEmitter(hmEmitterFrom : HM_EMITTER; var hmEmitterTo : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Processes the emitter. Creates, displaces and removes the particles
// rus: Осуществляет обработку эмиттера: создает, перемещает и уничтожает частицы
function Magic_Update(hmEmitter : HM_EMITTER; time : double) : boolean; cdecl; external magicdll;

// eng: Stops the emitter
// rus: Останавливает работу эмиттера
function Magic_Stop(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Interrupts/Starts emitter work
// rus: Прерывает или запускает работу эмиттера
// rus: В режиме прерывания новые частицы больше не создаются,
// rus: а после уничтожения существующих частиц считается, что эмиттер завершил работу
// rus: Позиция анимации во время прерывания не изменяется
function Magic_SetInterrupt( hmEmitter : HM_EMITTER; interrupt : boolean) : integer; cdecl; external magicdll;

// eng: Returns the flag showing that emitter is in interrupted mode
// rus: Возврашает признак того, что эмиттер прерывается
function Magic_IsInterrupt(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Returns current animation position
// rus: Возвращает текущую позицию анимации
function Magic_GetPosition(hmEmitter : HM_EMITTER) : double; cdecl; external magicdll;

// eng: Sets the current animation position
// rus: Устанавливает текущую позицию анимации
function Magic_SetPosition(hmEmitter : HM_EMITTER; position : double): integer; cdecl; external magicdll;

// eng: Returns animation duration
// rus: Получить продолжительность анимации
function Magic_GetDuration(hmEmitter : HM_EMITTER) : double; cdecl; external magicdll;

// eng: Restarts the emitter from the beginning
// rus: Перезапускает анимацию
function Magic_Restart(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Returns the Magic Particles (Dev) time increment, used for the animation
// rus: Возвращает заданное в Magic Particles приращение времени, используемое для анимации эмиттера
function Magic_GetUpdateTime(hmEmitter : HM_EMITTER) : double; cdecl; external magicdll;

// eng: Returns the emitter behaviour mode at the end of the animation
// rus: Возвращает режим поведения эмиттера после окончания анимации
function Magic_GetLoopMode(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Sets the emitter behaviour mode at the end of the animation
// rus: Устанавливает режим поведения эмиттера после окончания анимации
function Magic_SetLoopMode(hmEmitter : HM_EMITTER; mode : integer) : integer; cdecl; external magicdll;

// eng: Returns the color management mode
// rus: Возвращает режим управления цветом частиц
function Magic_GetColorMode(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Sets the color management mode
// rus: Устанавливает режим управления цветом частиц
function Magic_SetColorMode(hmEmitter : HM_EMITTER; mode : integer) : integer; cdecl; external magicdll;

// eng: Returns the user defined tint
// rus: Возвращает оттенок пользователя
function Magic_GetTint(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Sets the user defined tint
// rus: Устанавливает оттенок пользователя
function Magic_SetTint(hmEmitter : HM_EMITTER; tint : integer) : integer; cdecl; external magicdll;

// eng: Returns the user defined tint strength
// rus: Возвращает силу оттенка пользователя
function Magic_GetTintStrength(hmEmitter : HM_EMITTER) : single; cdecl; external magicdll;

// eng: Sets the user defined tint strength
// rus: Устанавливает силу оттенка пользователя
function Magic_SetTintStrength(hmEmitter : HM_EMITTER; tint_strength : single) : integer; cdecl; external magicdll;

// eng: Returns coordinates of the emitter
// rus: Возвращает координаты эмиттера
function Magic_GetEmitterPosition(hmEmitter : HM_EMITTER; var x : single; var y : single) : integer; cdecl; external magicdll;

// eng: Sets the coordinates of the emitter
// rus: Устанавливает координаты эмиттера
function Magic_SetEmitterPosition(hmEmitter : HM_EMITTER; x : single; y : single) : integer; cdecl; external magicdll;

// eng: Returns the mode of the emitter coordinates
// rus: Возвращает режим координат эмиттера
function Magic_GetEmitterPositionMode(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Sets the mode of the emitter coordinates
// rus: Устанавливает режим координат эмиттера
function Magic_SetEmitterPositionMode(hmEmitter : HM_EMITTER; mode : boolean) : integer; cdecl; external magicdll;

// eng: Returns emitter direction
// rus: Возвращает направление эмиттера
function Magic_GetEmitterDirection(hmEmitter : HM_EMITTER; var angle : single) : integer; cdecl; external magicdll;

// eng: Sets the direction of the emitter
// rus: Устанавливает направление эмиттера
function Magic_SetEmitterDirection(hmEmitter : HM_EMITTER; angle : single) : integer; cdecl; external magicdll;

// eng: Gets the emitter's direction mode
// rus: Возвращает режим вращения эмиттера
function Magic_GetEmitterDirectionMode(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Sets emitter's rotation mode
// rus: Устанавливает режим вращения эмиттера
function Magic_SetEmitterDirectionMode(hmEmitter : HM_EMITTER; mode : boolean) : integer; cdecl; external magicdll;

// eng: Moves particles
// rus: Перемещает частицы
function Magic_MoveEmitterParticles(hmEmitter : HM_EMITTER; offset_x : single; offset_y : single) : integer; cdecl; external magicdll;

// eng: Rotates particles
// rus: Вращает частицы
function Magic_RotateEmitterParticles(hmEmitter : HM_EMITTER; offset : single) : integer; cdecl; external magicdll;

// eng: Returns the shape of the emitter itself or the shape of the emitter for the specified particles type
// rus: Возвращает форму эмиттера или форму эмиттера для указанного типа частиц
function Magic_GetEmitterType(hmEmitter : HM_EMITTER; index : integer) : integer; cdecl; external magicdll;

// eng: Returns the Intensity flag
// rus: Возвращает признак Интентивность
function Magic_IsIntensive : boolean; cdecl; external magicdll;

// eng: Returns the left position of the visibility range
// rus: Возвращает левую позицию интервала видимости
function Magic_GetInterval1(hmEmitter : HM_EMITTER) : double; cdecl; external magicdll;

// eng: Sets the left position of the visibility range
// rus: Устанавливает левую позицию интервала видимости
function Magic_SetInterval1(hmEmitter : HM_EMITTER; position : double) : integer; cdecl; external magicdll;

// eng: Returns the right position of the visibility range
// rus: Возвращает правую позицию интервала видимости
function Magic_GetInterval2(hmEmitter : HM_EMITTER) : double; cdecl; external magicdll;

// eng: Sets the right position of the visibility range
// rus: Устанавливает правую позицию интервала видимости
function Magic_SetInterval2(hmEmitter : HM_EMITTER; position : double) : integer; cdecl; external magicdll;

// eng: Figures out if the current animation position is within the visibility range
// Определяет, попадает ли текущая позиция анимации в интервал видимости
function Magic_InInterval(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Returns the number particles type contained in emitter
// rus: Возвращает количество типов частиц внутри эмиттера
function Magic_GetParticlesTypeCount(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Returns the emitter scale
// rus: Возвращает масштаб эмиттера
function Magic_GetScale(hmEmitter : HM_EMITTER) : single; cdecl; external magicdll;

// eng: Sets the emitter scale
// rus: Устанавливает масштаб эмиттера
function Magic_SetScale(hmEmitter : HM_EMITTER; scale : single) : integer; cdecl; external magicdll;

// eng: Returns the particle positions interpolation usage flag
// rus: Возвращает признак режима интерполяции эмиттера
function Magic_IsInterpolationMode(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Sets/resets the particle positions interpolation usage flag
// rus: Устанавливает режим интерполяции эмиттера
function Magic_SetInterpolationMode(hmEmitter : HM_EMITTER; mode : boolean) : integer; cdecl; external magicdll;

// eng: Returns the flag of stability/randomness of the emitter behaviour
// rus: Возвращает признак стабильности/случайности поведения эмиттера
function Magic_IsRandomMode(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Sets the flag of stability/randomness of the emitter behaviour
// rus: Устанавливает признак стабильности/случайности поведения эмиттера
function Magic_SetRandomMode(hmEmitter : HM_EMITTER; mode : boolean) : integer; cdecl; external magicdll;

// eng: Copying the particles array into emitter from the file
// rus: Замена пространства частиц эмиттера ранее созданной копией из файла
function Magic_LoadArrayFromFile(hmEmitter : HM_EMITTER; file_name : pAnsiChar) : integer; cdecl; external magicdll;

// eng: Copying the particles array from the emitter into the file
// rus: Копирование пространства частиц эмиттера в файл
function Magic_SaveArrayToFile(hmEmitter : HM_EMITTER; file_name : pAnsiChar) : integer; cdecl; external magicdll;

// eng: Sets the user data
// rus: Устанавливает пользовательские данные
function Magic_SetData(hmEmitter : HM_EMITTER; data : integer) : integer; cdecl; external magicdll;

// eng: Returns the user data
// rus: Возвращает пользовательские данные
function Magic_GetData(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Returns the name of the emitter
// rus: Возвращает имя эмиттера
function Magic_GetEmitterName(hmEmitter : HM_EMITTER) : pAnsiChar; cdecl; external magicdll;

// eng: Returns the name of the particles type
// rus: Возвращает имя типа частиц
function Magic_GetParticlesTypeName(hmEmitter : HM_EMITTER; index : integer) : pAnsiChar; cdecl; external magicdll;

// eng: Returns the animate folder flag
// rus: Возвращает признак анимированной папки
function Magic_IsFolder(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// eng: Returns the number of emitters contained in animate folder. 1 is returned for emitter
// rus: Возвращает количество эмиттеров внутри эмиттера
function Magic_GetEmitterCount(hmEmitter : HM_EMITTER) : integer; cdecl; external magicdll;

// eng: Returns the specified emitter from animate folder. Returns itself for emitter
// rus: Возвращает дескриптор эмиттера внутри эмиттера
function Magic_GetEmitter(hmEmitter : HM_EMITTER; index : integer) : HM_EMITTER; cdecl; external magicdll;

// eng: Sets the animation position at the left position of visibility range
// rus: Устанавливает эмиттер на первую границу интервала видимости
function Magic_EmitterToInterval1(hmEmitter : HM_EMITTER; file_name : pAnsiChar) : integer; cdecl; external magicdll;

// eng: Returns the flag of the animation of emitter that begins from 0 position
// rus: Возвращает признак того, что анимация эмиттера начинается не с начала
function Magic_IsInterval1(hmEmitter : HM_EMITTER) : boolean; cdecl; external magicdll;

// --------------------------------------------------------------------------

// eng: Locks the specified particles type for the further processing
// rus: Активизирует указанный тип частиц
function Magic_LockParticlesType(hmEmitter : HM_EMITTER; index : integer) : integer; cdecl; external magicdll;

// eng: Releases previously locked particles type
// rus: Деактивизирует тип частиц
function Magic_UnlockParticlesType : integer; cdecl; external magicdll;

// eng: Returns the number used as a user resources texture identificator
// rus: Возвращает число, которое предназанчено для идентификации текстуры в ресурсах пользователя
function Magic_GetTextureID : cardinal; cdecl; external magicdll;

// eng: Sets the number used as a user resources texture identificator
// rus: Устанавливает число, которое предназанчено для идентификации текстуры в ресурсах пользователя
function Magic_SetTextureID(id : cardinal) : integer; cdecl; external magicdll;

// eng: Returns the number of textural frame-files in locked particles type
// rus: Возвращает количество кадров текстуры, используемой для выбранного типа частиц
function Magic_GetTextureCount : integer; cdecl; external magicdll;

// eng: Returns MAGIC_TEXTURE structure containing the specified frame-file information
// rus: Возвращает информацию о текстуре
function Magic_GetTexture(index : integer) : PMAGIC_TEXTURE; cdecl; external magicdll;

// eng: Returns the pointer to the next particle. Is used to go through all the existing particles during the visualization process
// rus: Возвращает указатель на очередную частицу. Используется для перебора всех существующих частиц в процессе визуализации
function Magic_GetNextParticle : PMAGIC_PARTICLE; cdecl; external magicdll;

// eng: Returns the pointer to the MAGIC_VERTEX_RECTANGLE structure, containing the coordinates of the visualization rectangle vertice
// rus: Возвращает структуру с координатами вершин прямоугольника частицы
function Magic_GetParticleRectangle(var particle : TMAGIC_PARTICLE; var texture : TMAGIC_TEXTURE) : PMAGIC_VERTEX_RECTANGLE; cdecl; external magicdll;

// eng: Changes the position of the particle that is got by Magic_GetNextParticle
// rus: Перемещает очередную частицу
procedure Magic_MoveParticle(x : single; y : single); cdecl; external magicdll;

// eng: Rotates the particle that was obtained by Magic_GetNextParticle around the emitter
// rus: Вращает очередную частицу
procedure Magic_RotateParticle(angle : single); cdecl; external magicdll;

// eng: Creates textural atlases
// rus: Создает атласы
function Magic_CreateAtlases(width : integer; height : integer; step : integer; scale_step : single) : single; cdecl; external magicdll;

// eng: Returns the number of textural atlases
// rus: Возвращает количество атласов
function Magic_GetAtlasCount : integer; cdecl; external magicdll;

// eng: Returns the textural atlas specified
// rus: Возвращает атлас
function Magic_GetAtlas(index : integer) : PMAGIC_ATLAS; cdecl; external magicdll;

// eng: Returns the specified diagram factor
// rus: Возвращает коэффициент графика у типа частиц
function Magic_GetDiagramFactor(hmEmitter : HM_EMITTER; type_index : integer; diagram_index : integer) : single; cdecl; external magicdll;

// eng: Sets the specified diagram factor
// rus: Устанавливает коэффициент графика у типа частиц
function Magic_SetDiagramFactor(hmEmitter : HM_EMITTER; type_index : integer; diagram_index : integer; factor : single) : integer; cdecl; external magicdll;

// eng: Returns the offset for the specified diagram
// rus: Возвращает смещение графика у типа частиц
function Magic_GetDiagramAddition(hmEmitter : HM_EMITTER; type_index : integer; diagram_index : integer) : single; cdecl; external magicdll;

// eng: Sets the offset for the specified diagram
// rus: Устанавливает смещение графика у типа частиц
function Magic_SetDiagramAddition(hmEmitter : HM_EMITTER; type_index : integer; diagram_index : integer; addition : single) : integer; cdecl; external magicdll;

// eng: Figures out if the diagram is managable
// rus: Проверяет существование указанного графика у типа частиц
function Magic_IsDiagramEnabled(hmEmitter : HM_EMITTER; type_index : integer; diagram_index : integer) : boolean; cdecl; external magicdll;

// --------------------------------------------------------------------------------------

// eng: Loads the ptf-file from the path specified
// rus: Открытие ptf-файла
function Import_OpenFile(const file_name : pAnsiChar; var hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Loads the ptf-file image from RAM
// rus: Открытие образа ptf-файла из памяти
function Import_OpenFileInMemory(const buffer : pointer; var hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Closes the file, opened earlier by Import_OpenFile or Import_OpenFileInMemory
// rus: Закрытие файла
function Import_CloseFile(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Returns the frame rate
// rus: Получить частоту кадров
function Import_GetRate(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Returns the frame size
// rus: Получить размер кадра
function Import_GetSize(hmImport : HM_IMPORT; var width : integer; var height : integer) : integer; cdecl; external magicdll;

// eng: Returns the flag of presence the identification information for every particle
// rus: Получить признак присутствия идентификаторов для частиц
function Import_IsID(hmImport : HM_IMPORT) : boolean; cdecl; external magicdll;

// eng: Returns the number of animation frames
// rus: Получить количество кадров
function Import_GetFrameCount(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Returns the current frame
// rus: Получить текущий кадр
function Import_GetFrame(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Sets the new current frame
// rus: Установить текущий кадр
function Import_SetFrame(hmImport : HM_IMPORT; frame : integer) : integer; cdecl; external magicdll;

// eng: Increases the value of the current frame by 1
// rus: Перейти к следующему кадру
function Import_NextFrame(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Decreases the value of the current frame by 1
// rus: Перейти к предыдущему кадру
function Import_PreviousFrame(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Returns the file name, that was opened using Import_OpenFile
// rus: Возвращает имя файла, открытого через Import_OpenFile
function Import_GetFileName(hmImport : HM_IMPORT) : pAnsiChar; cdecl; external magicdll;

// eng: Returns the numbers of exported emitters
// rus: Возвращает количество экспортированных эмиттеров
function Import_GetEmitterCount(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Returns the information about exported emitter
// rus: Возвращает информацию об экспортированном эмиттере
function Import_GetEmitter(hmImport : HM_IMPORT; index : integer; var info : TMAGIC_IMPORT_EMITTER) : integer; cdecl; external magicdll;

// eng: Returns the number particles type contained in import file
// rus: Получить количество типов частиц
function Import_GetParticlesTypeCount(hmImport : HM_IMPORT) : integer; cdecl; external magicdll;

// eng: Returns the information about particles type
// rus: Возвращает информацию о типе частиц
function Import_GetParticlesType(hmImport : HM_IMPORT; index : integer; var info : TMAGIC_IMPORT_PARTICLES_TYPE) : integer; cdecl; external magicdll;

// eng: Locks the specified particles type for the further processing
// rus: Активизирует указанный тип частиц
function Import_LockParticlesType(hmImport : HM_IMPORT; index : integer) : integer; cdecl; external magicdll;

// eng: Releases previously locked particles type
// rus: Деактивизирует тип частиц
function Import_UnlockParticlesType: integer; cdecl; external magicdll;

// eng: Returns the number of textural frame-files in locked particles type
// rus: Возвращает количество кадров текстуры, используемой для выбранного типа частиц
function Import_GetTextureCount: integer; cdecl; external magicdll;

// eng: Fills the MAGIC_TEXTURE structure with the specified texture frame-file information
// rus: Возвращает информацию о текстуре
function Import_GetTexture(index : integer; var texture : TMAGIC_TEXTURE) : integer; cdecl; external magicdll;

// eng: Returns the number used as a user resources texture identificator
// rus: Возвращает идентификатор текстуры
function Import_GetTextureID : cardinal; cdecl; external magicdll;

// eng: Sets the number used as a user resources texture identificator
// rus: Устанавливает идентификатор текстуры
function Import_SetTextureID(id : cardinal) : integer; cdecl; external magicdll;

// eng: Returns the Intensity flag
// rus: Возвращает признак интенсивности
function Import_IsIntensive : boolean; cdecl; external magicdll;

// eng: Returns the pointer to the next particle. Is used to go through all the existing particles during the visualization process
// rus: Возвращает указатель на очередную частицу. Используется для перебора всех существующих частиц в процессе визуализации
function Import_GetNextParticle : TMAGIC_PARTICLE; cdecl; external magicdll;

// eng: Returns the pointer to the struct MAGIC_IMPORT_PARTICLE_ID for the last particle
// rus: Возвращает указатель на структуру MAGIC_IMPORT_PARTICLE_ID для последней полученной частицы
function Import_GetParticleID : TMAGIC_IMPORT_PARTICLE_ID; cdecl; external magicdll;

// eng: Returns the number of the particles of locked type
// rus: Получить количество частиц
function Import_GetParticleCount : integer; cdecl; external magicdll;

// eng: Returns emitter coordinates
// rus: Возвращает позицию эмиттера
function Import_GetEmitterPosition(var x : integer; var y : integer) : integer; cdecl; external magicdll;

// ----------------------------------------------------------------------------------------

// eng: Creates the particle trajectories for the loaded import file
// rus: Создает траектории частиц
function Trajectory_Create(hmImport : HM_IMPORT ) : integer; cdecl; external magicdll;

// eng: Destroyes trajectories of the particles that were previously created by Trajectory_Create
// rus: Уничтожает траектории частиц
function Trajectory_Destroy : integer; cdecl; external magicdll;

// eng: Returns the number of particles, for which trajectories were created using Trajectory_Create
// rus: Возвращает количество частиц, для которых были созданы траектории
function Trajectory_GetParticleCount : integer; cdecl; external magicdll;

// eng: Locks the specified particle for the trajectory extraction
// rus: Захватывает частицу для получения ее траектории
function Trajectory_LockParticle(index : cardinal) : integer; cdecl; external magicdll;

// eng: Unlocks earlier locked particle
// rus: Освобождает частицу после получения ее траектории
function Trajectory_UnlockParticle : integer; cdecl; external magicdll;

// eng: Returns the pointer to the MAGIC_TRAJECTORY structure that contains the information on the particle locked
// rus: Возвращает структуру с информацией о захваченной частице
function Trajectory_GetParticleInfo : PMAGIC_TRAJECTORY; cdecl; external magicdll;

// eng: Returns the pointer to the next position of the locked particle. Used to exract the whole trajectory of the particle
// rus: Возвращает очередную позицию в траектории захваченной частицы
function Trajectory_GetNextPosition : PMAGIC_PARTICLE; cdecl; external magicdll;

// eng: Returns the pointer to the struct MAGIC_IMPORT_PARTICLE_ID for the last particle
// rus: Возвращает указатель на структуру MAGIC_IMPORT_PARTICLE_ID для последнего полученного положения частицы
function Trajectory_GetParticleID : PMAGIC_IMPORT_PARTICLE_ID; cdecl; external magicdll;

// eng: Returns the coordinates of parent particle for the last particle
// rus: Возвращает позицию родительской частицы
function Trajectory_GetParentPosition(var x : single; var y : single) : integer; cdecl; external magicdll;

implementation

end.
