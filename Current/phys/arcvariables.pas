unit arcvariables;
interface

uses windows, dglopengl, sysutils, shlobj, sdl, sdl_mixer, png, arcimage, arcconst,
  libcurl, crt, arctypes, arcread, arcphys, arcdraw, arcgui, commdlg, arcsystem;

var
  checked		:	array[1..5]   of boolean = (false,false,false,false,false);
  k_Bonus		:	array[1..7]   of boolean = (false, false, false, false, false, false, false);
  timer_s		: 	array[1..10]  of int64;
  keys			:	array[1..256] of boolean;
  gmf			:	array[1..256] of GLYPHMETRICSFLOAT;
  mSymbol		: 	array[1..256] of SymbolTType;
  bricks 		: 	array[1..256] of Brick;
  pBricks		: 	array[1..256] of Brick;

  base			:	gluint;
  rot			:	glfloat;

  FileName		:	string;
  TFileName		: 	string;
  FileResult	: 	boolean = true;
  TFile2		:	Text;
  Fs			:	TSearchRec;
  filek			: 	TSearchRec;
  TFile			:	Text;
  FileMask	: string ;

  i,l,lp		:	integer;
  ftime, ttime  : 	SYSTEMTIME;

  spacecon		:	boolean;
  WndMouseUp	:	boolean;
  WndRMouseUp	: 	boolean;

  msg 			: 	TMSG;		
  hWindow 		: 	HWnd;	
  dcWindow 		: 	hDc;	
  rcWindow 		: 	HGLRC;	
  windowRect 	: 	RECT;
  DC, RC		:	HDC;

  perf_now, perf_last, perf_freq	:	int64;
  frame_time,ideal_time				:	real;
  fps			:	real;

  bk,bk2		:	boolean;
  koef, koef2,koef3					:	real;
  bg			:	bgr;
  hx,hy			:	real;

  player_old_x, player_old_y		:	real;

  counter		:	integer;
  win1			:	boolean = false;
  fail1			:	boolean = false;
  mouse_x, mouse_y 					: 	integer;

  player, poll	:	Rectangle;

  url			: 	pChar = 'http://localhost';
  hCurl			: 	pCurl;

  str1, str2,str3, str4, str5,str6 	: 	string;
  ch			:	char;


  width, height, bits 				: 	integer;
  fullscreen, active 				: 	boolean;

  bricks_count	: 	Integer;

  Tex			:	pTex;

  game			:	boolean = false;
  mainmenu		:	boolean = true;
  manual		:   boolean	= false;
  editor		:	boolean = false;
  options		: 	boolean	= false;


  w_width, w_height, w_mode			: 	integer;
  useSnap		: 	boolean = true;
//  sfx: PMix_Chunk;
  snapStepy		:	real;
  snapStepx		: 	real;

  tscore		: 	text;
  score			: 	integer;
  date			: 	string;
  level_score	: 	integer;

  userkey 		: 	char;
  music 		: 	pMIX_MUSIC = NIL;
  sound 		: 	pMIX_CHUNK = NIL;
  soundChannel 	: 	Integer;

  _x1,_x2,_x3,_x4					: 	real;
  kx,ky,st		:   integer;

  collision		: 	boolean = true;
  _x01,_x02,_x03,_x04				:	real;
  k_l			: 	integer;
  k_name		: 	string;

  _width, _height 					: 	integer;
  x01,x02,x03,x04,x05,y01,y02,y03,y04,y05			: 	real;

    _mwidth, _mheight 				: 	integer;
  mx01,mx02,mx03,mx04,my01,my02,my03,my04			: 	real;

  pi			: 	integer;
  highs			: 	integer;
  pexit			: 	boolean = false;

  over			: 	string;

  Animations: array [1..256] of PAnimation;
  TimerFreq:int64;
  TimerCount:int64;
  LastTime:int64;
  dt:integer;
  animtexture: gluint;
  font_texture : glUint;
  font_texture_tnr : glUint;
  font_texture_ubfg : glUint;
  baseFont: BMFont;
  baseFont2: BMFont;
  tnrFont : BMFont;
  SpecGlyphs : widestring = '`~!@"#№$;%^:&?*()-_=+\/|[]{}<>,.'#9#39; 

implementation
end.