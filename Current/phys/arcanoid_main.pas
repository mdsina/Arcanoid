unit arcanoid_main;
interface
uses
  windows, dglopengl, sysutils, shlobj, sdl, sdl_mixer, png,
  libcurl, crt, arctypes, arcread, arcphys, arcdraw, commdlg, arcsystem;

Const
	AUDIO_FREQUENCY : Integer = 22050;
	AUDIO_FORMAT 	: Word 	  = AUDIO_S16;
	AUDIO_CHANNELS 	: Integer = 2;
	AUDIO_CHUNKSIZE : Integer = 4096;

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
  MyThread: TMyThread; textureid,fboid: gluint;
  ttex:gluint;
  ProgramObject        : GLhandle;
  VertexShaderObject   : GLhandle;
  FragmentShaderObject : GLhandle;
  fs2, vs2: pchar;

  depthProgram: gluint = 0;
  shadowmapProgram: gluint = 0;
  posteffectProgram: gluint = 0;
  colorTexture: gluint = 0;
  depthTexture: gluint = 0;
  posteffectTexture: gluint = 0;
  posteffectDepthTexture: gluint = 0;
  depthFBO: gluint = 0;
  posteffectFBO: gluint = 0;
  fsqVAO: gluint = 0;
  fsqVBO: gluint = 0;

procedure  OnMouseUp(x, y:integer);
procedure  OnMouseRDown(x, y:integer);
procedure OnCreate(act: boolean);
procedure OnDestroy(act: boolean);
procedure Nulling;
procedure OnMenu;
Procedure OnGame;
procedure onManual;
procedure OnEditor(x,y: integer);
procedure OnMouseDown(x, y:integer);
procedure OnMouseMove(x, y:integer);
procedure ThrowError(pcErrorMessage : pChar);
function GLWndProc(Window: HWnd; AMessage, WParam, LParam: Longint): Longint; stdcall; export;
function WindowRegister: Boolean;
function WindowCreate(pcApplicationName : pChar): HWnd;
function WindowInit(hParent : HWnd): Boolean;
function CreateOGLWindow(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean):Boolean;
procedure KillOGLWindow();
procedure OpenGL_Init();
procedure handle_input;

procedure win(var bcount:integer);
procedure fail(var cnt:integer);
procedure checkbox_draw(lx,ly:integer; lst:integer);
procedure bkg_scrolling;
procedure main_draw;
procedure draw_manual;
procedure options_draw;
procedure ogl_draw;
procedure OnExit;
procedure InitTexture;
procedure Timers;
procedure init_static;
Procedure TPrintText(text2:integer; t1, t2,TLength: real; twidth,theight:real);
procedure renderscene;
procedure FBORender;
procedure maindraw;

implementation

//********************
//*       МЫШЬ       *
//********************
procedure  OnMouseUp(x, y:integer);
begin
end;
procedure  OnMouseRDown(x, y:integer);
begin
end;
procedure OnCreate(act: boolean);
begin
	active:=true;
end;
procedure OnDestroy(act: boolean);
begin
	active:=false;
end;

procedure Nulling;
begin
	for i:=1 to 256 do	begin
		bricks[i].lives:=0;
		bricks[i].box.x:=0;
		bricks[i].box.y:=0;
		bricks[i].box.width:=0;
		bricks[i].box.height:=0;
		bricks[i].typei:=0;
		bricks[i].tType:=0;
		bricks[i].Bonus:=random(7)+1;
		bricks[i].tBool:=false;
	end;
	spacecon:=false;
	counter:=3;
end;

procedure OnMenu;
begin
	if mainmenu = true
	then begin
	
		if (mouse_x>(x04*width)) and (mouse_x<(x04*width+_width))
		and (mouse_y<(y04*height+_height)) and (mouse_y>(y04*height))
		then begin
			mainmenu:=false;
			options:=true;
		end;
		
		if (mouse_x>x01*width) and (mouse_x<(x01*width+_width))
		and (mouse_y<(y01*height+_height)) and (mouse_y>y01*height)
		then begin
			mainmenu:=false;
			game:=true;
		end	else game:=false;
	
		if (mouse_x>x02*width) and (mouse_x<(x02*width+_width))
		and (mouse_y<(y02*height+_height)) and (mouse_y>y02*height)
		then begin
			mainmenu:=false;
			manual:=true;
		end;
		
		if (mouse_x>x05*width) and (mouse_x<(x05*width+_width))
		and (mouse_y<(y05*height+_height)) and (mouse_y>y05*height)
		then begin
			SendMessage(hWindow,wm_destroy,0,0);
			Exit;
		end;
				
		if (mouse_x>x03*width) and (mouse_x<(x03*width+_width))
		and (mouse_y<(y03*height+_height)) and (mouse_y>y03*height)
		then begin
			mainmenu:=false;
			editor:=true;
			FileResult:=true;
		end;
	end;
end;

Procedure OnGame;
begin
	if (game=true) and ((win1=false)and(fail1=false)) and (pexit=true)
		then begin	
			if hx<0 then hx:=hx+3
					else hx:=hx-3;
				
			if hy<0 then hy:=hy+3
					else hy:=hy-3;
				
			if (mouse_x/width>0.036) and (mouse_x/width<0.036+70/width)
			and (mouse_y<0.22*height+69) and (mouse_y/height>0.22)
			then begin
				bricks_count:=0;			
				Nulling;				
				poll.x:=width/2-poll.width/2;
				FileResult:=true;		
				pexit:=false;
				if hx<0 then hx:=abs(hx);
				game:=false;
				mainmenu:=true;
		end;
							
		if (mouse_x/width>0.036) and (mouse_x/width<0.036+70/width)
		and (mouse_y<0.43*height+69) and (mouse_y/height>0.43)
		then begin
			if fail1=true then counter:=3;
			FileResult:=true;
			k_l:=k_l+1;
			
			for pi:=1 to k_l do FindNext(Fs);
			k_name:=GetCurrentDir()+'\Data\Levels\'+Fs.Name;	
			
			Nulling;
			win1:=false; fail1:=false;
						
			FileResult:=true; fail1:=false;
			
			poll.x:=width/2-poll.width/2;
			if hx<0 then hx:=abs(hx);
		end;
							
		if (mouse_x/width>0.036) and (mouse_x/width<0.036+70/width)
		and (mouse_y<0.64*height+69) and (mouse_y/height>0.64)
		then begin
			bricks_count:=0;
			Nulling;
			
			poll.x:=width/2-poll.width/2;
			FileResult:=true;								
			pexit:=false;
			if hx<0 then hx:=abs(hx);
			game:=false;
			mainmenu:=true;
		end;
	end;
		
	if game=true then
	begin
		if (mouse_x>(width/2-70/2)) and (mouse_x<(width/2+70/2))
		and (mouse_y>(height/2-70/2)) and (mouse_y<(height/2+70/2))
		and ((win1=true) or (fail1=true))
		then begin
			if fail1=true then counter:=3;
			FileResult:=true;
			k_l:=k_l+1;
			
			for pi:=1 to k_l do FindNext(Fs);
			k_name:=GetCurrentDir()+'\Data\Levels\'+Fs.Name;
			Nulling;			
			win1:=false; fail1:=false;
			FileResult:=true; fail1:=false;
						
			bricks_count:=0;
			poll.x:=width/2-poll.width/2;
			if hx<0 then hx:=abs(hx);
		end;
					
		if (mouse_x>(width/3-70/2)) and (mouse_x<(width/3+70/2))
		and (mouse_y>(height/2-70/2)) and (mouse_y<(height/2+70/2))
		and ((win1=true) or (fail1=true))
		then begin
			if fail1=true then counter:=3;
			bricks_count:=0;
			Nulling;
								
			poll.x:=width/2-poll.width/2;
			FileResult:=true;
			if hx<0 then hx:=abs(hx);
			win1:=false; fail1:=false;						
		end;
					
		if (mouse_x>(width/3-70/2)) and (mouse_x<(width/3+70/2))
		and (mouse_y>(height/2-70/2)) and (mouse_y<(height/2+70/2))
		and ((win1=true) or (fail1=true))
		then begin
			bricks_count:=0;
			Nulling;
			
			poll.x:=width/2-poll.width/2;
			FileResult:=true;
			if hx<0 then hx:=abs(hx);
			win1:=false; fail1:=false;						
		end;		
	end;
end;

procedure onManual;
begin
	if manual=true	then
		if (mouse_x>0) and (mouse_x<70)	and (mouse_y<70) and (mouse_y>0)
		then begin
			manual:=false;
			mainmenu:=true;
		end;
end;

procedure OnEditor(x,y: integer);
begin
	if (editor = true) then
	begin
		if (mouse_x>0) and (mouse_x<70)	and (mouse_y<70) and (mouse_y>0)
		then begin
			editor:=false;
			counter:=3;
			win1:=false;  fail1:=false;
			FileResult:=true;
			
			for i:=1 to 256 do	begin
				bricks[i].lives:=0;
				bricks[i].box.x:=0;
				bricks[i].box.y:=0;
				bricks[i].box.width:=0;
				bricks[i].box.height:=0;
				bricks[i].typei:=0;
				bricks[i].tType:=0;
				bricks[i].Bonus:=0;
				bricks[i].tBool:=false;
			end;
			
			FindFirst(FileMask,faAnyFile,Fs);
			k_name:=GetCurrentDir()+'\Data\Levels\'+Fs.Name;
			bricks_count:=0;
			mainmenu:=true;
		end;
					
		if ((x>=0.037*width) and (y>=0.042*height) and ((x+54)<=0.72*width)	and ((y+30)<=0.95*height))
		then begin
			bricks_count:=bricks_count + 1;
			bricks[bricks_count].lives:=1;
			if useSnap=false then
			begin
				bricks[bricks_count].box.x:=(mouse_x+bricks[bricks_count].box.width/2)/width;
				bricks[bricks_count].box.y:=(mouse_y+bricks[bricks_count].box.height/2)/height;
			end	else begin
				bricks[bricks_count].box.x:=(round((mouse_x+bricks[bricks_count].box.width/2)/snapStepx)*snapStepx)/width;
				bricks[bricks_count].box.y:=(round((mouse_y+bricks[bricks_count].box.height/2)/snapStepy)*snapStepy)/height;
			end;
								
			bricks[bricks_count].box.width:=54;
			bricks[bricks_count].box.height:=30;
			bricks[bricks_count].typei:=1;

			if (GetKeyState(VK_2) and 128)=128
			then begin
				bricks[bricks_count].lives:=2;
				bricks[bricks_count].typei:=2;
				bricks[bricks_count].Ttype:=random(3)+1;
			end;

			if GetKeyState(VK_3) and 128>=128
			then begin
				bricks[bricks_count].lives:=1;
				bricks[bricks_count].typei:=3;
				pBricks[bricks_count].Typei:=3;
			end;
		end;
	end;
end;

//процедура, вызываемая при нажатии левой кнопки мыши
procedure OnMouseDown(x, y:integer);
begin
	if (x>kx) and (x<kx+30) and (y>ky) and (y<ky+30)
		then checked[st]:= not checked[st];
		
	OnMenu;
	OnGame;
	OnManual;
	OnEditor(x,y);
end;

//процедура, вызываемая при движении курсора
procedure OnMouseMove(x, y:integer);
begin
	mouse_x:=x;
	mouse_y:=y;
end;

procedure ThrowError(pcErrorMessage : pChar);
begin
  MessageBox(0, pcErrorMessage, 'Error', MB_OK);
  Halt(0);
end;

function GLWndProc(Window: HWnd; AMessage, WParam, LParam: Longint): Longint; stdcall; export;
var   Res: LRESULT;
begin
  GLWndProc := 0;

  case AMessage of
    wm_create:

      begin
	      active := true;
	      Exit;
      end;
    wm_paint:
      begin
         exit;
      end;

    wm_keydown:

      begin
	      if wParam = VK_ESCAPE then pexit:=not pexit;//SendMessage(hWindow,wm_destroy,0,0);
	       Exit;
      end;

    wm_destroy:
      begin
         active := false;
         PostQuitMessage(0);
         Exit;
      end;
      wm_lbuttonup:
      begin
         OnMouseUp(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
         WndMouseUp:=true;
      end;
      wm_lbuttondown:
      begin
         OnMouseDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
         WndMouseUp:=false;
      end;
      wm_rbuttondown:
      begin
         OnMouseRDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
         WndRMouseUp:=false;
      end;
      wm_rbuttonup:
      begin
         WndRMouseUp:=true;
      end;
      wm_mbuttondown:
      begin
		useSnap:=not UseSnap;
      end;
      wm_mousemove:
      begin
         OnMouseMove(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
      end;

   wm_syscommand:
      begin
	      case (wParam) of
	        SC_SCREENSAVE :
	          begin
	           GLWndProc := 0;
	          end;

	        SC_MONITORPOWER :
	          begin
	            GLWndProc := 0;
	          end;
      end;
   end;
 end;

  GLWndProc := DefWindowProc(Window, AMessage, WParam, LParam);
end;



function WindowRegister: Boolean;
var
  WindowClass: WndClass;
begin
  WindowClass.Style := cs_hRedraw or cs_vRedraw;
  WindowClass.lpfnWndProc := WndProc(@GLWndProc);
  WindowClass.cbClsExtra := 0;
  WindowClass.cbWndExtra := 0;
  WindowClass.hInstance := system.MainInstance;
  WindowClass.hIcon := LoadImage(0, 'ico.ico', IMAGE_ICON, 0, 0, LR_DEFAULTSIZE or LR_LOADFROMFILE);
  //WindowClass.hIconSm := LoadImage(0, 'ico.ico', IMAGE_ICON, 0, 0, LR_DEFAULTSIZE or LR_LOADFROMFILE);
  WindowClass.hCursor := LoadCursor(0, idc_Arrow);
  WindowClass.hbrBackground := GetStockObject(WHITE_BRUSH);
  WindowClass.lpszMenuName := nil;
  WindowClass.lpszClassName := 'GLWindow';

  WindowRegister := RegisterClass(WindowClass) <> 0;

  windowRect.top:=0;
  windowRect.left:=0;
  windowRect.bottom:=windowRect.top + height;
  windowRect.right:=windowRect.left + width;

  AdjustWindowRect(@windowRect, WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN, false);
end;

function WindowCreate(pcApplicationName : pChar): HWnd;
var
  hWindow: HWnd;
  dmScreenSettings : DEVMODE;	
begin

 if fullscreen = false
  then
    begin
       hWindow := CreateWindow('GLWindow',
			 pcApplicationName,
			 WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
			 cw_UseDefault,
			 cw_UseDefault,
			 windowRect.right - windowRect.left,
			 windowRect.bottom - windowRect.top,
			 0, 0,
			 system.MainInstance,
			 nil);

    end
  else
    begin

      dmScreenSettings.dmSize := sizeof(dmScreenSettings);
      dmScreenSettings.dmPelsWidth := width;		
      dmScreenSettings.dmPelsHeight := height;
      dmScreenSettings.dmBitsPerPel := bits;
    dmScreenSettings.dmFields := DM_BITSPERPEL OR DM_PELSWIDTH OR DM_PELSHEIGHT;

 if ChangeDisplaySettings(@dmScreenSettings,CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL
  then
    begin
      ThrowError('Your video card not supported');
      WindowCreate := 0;
      Exit;
    end;

  hWindow := CreateWindowEx(WS_EX_APPWINDOW,
			    'GLWindow',
			    pcApplicationName,
			    WS_POPUP OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
			    0, 0,
			    width,
			    height,
			    0, 0,
			    system.MainInstance,
			    nil );

  ShowCursor(true);
 end;

  if hWindow <> 0 then begin
    ShowWindow(hWindow, CmdShow);
    UpdateWindow(hWindow);
  end;

  WindowCreate := hWindow;
end;

function WindowInit(hParent : HWnd): Boolean;
var
  FunctionError : integer;
begin
  FunctionError := 0;
  dcWindow := GetDC( hParent );
  RCWindow:= CreateRenderingContext( DCWindow,
                               [opDoubleBuffered],
                               32,
                               24,
                               0,0,0,
                               0);
  ActivateRenderingContext(DCWindow , RCWindow);

  if FunctionError = 0 then WindowInit := true
					   else WindowInit := false;

end;

function CreateOGLWindow(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean):Boolean;
begin
 width := iApplicationWidth;
 height := iApplicationHeight;
 bits := iApplicationBits;
 fullscreen := bApplicationFullscreen;

  if not WindowRegister then begin
    ThrowError('Could not register the Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

  hWindow := WindowCreate(pcApplicationName);
  if longint(hWindow) = 0 then begin
    ThrowError('Could not create Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

 if not WindowInit(hWindow) then begin
    ThrowError('Could not initialise Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

 CreateOGLWindow := true;
end;


//убиваем форточку//
procedure KillOGLWindow();
begin
  wglMakeCurrent( dcWindow, 0 );      //убиваем девайс
  wglDeleteContext( rcWindow );       //убиваем рендер
  ReleaseDC( hWindow, dcWindow );     //Release Window
  DestroyWindow( hWindow );           //убиваем само окно
end;


//Инициализируем OGL //
procedure OpenGL_Init();
begin
  glClearColor( 0.0, 0.0, 0.0, 0.0 ); //задачем цвет экрана очищения
  glViewport( 0, 0, width, height );  //основной вьюпорт

  //установка видовой и проекционной матриц //
  glmatrixmode(GL_PROJECTION);        //работаем в режиме проекционной матрицы
  glloadidentity();                   //замещаем текущую матрицу не единичную
  glortho(0, width, height, 0, 0, 1); //заружаем ортогональную проекционную матрицу
  glmatrixmode(GL_MODELVIEW);         //работаем в режиме объектно-видовой матрицы
  glloadidentity();                   //заменяем текущую матрицу на единичную
  gltranslatef(0.375, 0.375, 0);      //смещаем текущую матрицу (хак, чтобы тексели попадали в пиксели)

  glDisable(GL_DEPTH_TEST);           //отключаем проверку буфера глубины
  glEnable(GL_CULL_FACE);             //включаем отсечение задних граней
  glCullFace(GL_BACK);                //отсекаться будут задние грани (повёрнутые задом к камере)
  glFrontFace(GL_CCW);                //верншины полигонов должны задаваться в порядке "против часовой стрелки"
  glShadeModel(GL_SMOOTH);            //устанавливаем модель шейдинга
end;

//Коллизия и управление//
procedure handle_input;
var
	tmp:real;
	coll:boolean;
	dir_x, dir_y:real;
	i:integer;
begin
	if Getfocus()=hWindow then
	begin
		coll:=false;

		//and 128)=128 используется для проверки состояния 8 бита
		//который и показывает нажата ли клавиша

		poll.x:=mouse_x;
		if poll.x<=0.037*width	then poll.x:=0.037*width;
		if (poll.x+poll.width)>=0.72*width	then poll.x:=0.72*width-poll.width;
		
		//проверяем на столкновения
		if collide_scn_left(player, width) = true then  hx:=-hx;
		if collide_scn_right(player, width) = true then  hx:=-hx;
		if collide_scn_up(player, height) = true then  hy:=-hy;
		if collide_scn_down(player, height) = true then
		begin
			counter:=counter-1;
			spacecon:=false;
			k_bonus[1]:=false;
			collision:=true;
			hx:=0;
			hy:=0;
			for i:=1 to 256 do
				if bricks[i].tBool=true
					then bricks[i].tBool:=false;
        end;

		if spacecon = true then
		begin
			if (hx=0) and (hy=0) then
			begin
				hx:=3;
				hy:=3;
			end;
			player.x:=player.x+hx;
			player.y:=player.y+hy;
		end else begin
			player.x:=poll.x+(poll.width/2)-8;
			player.y:=poll.y-player.height-0.1;
		end;

		for i:=1 to 256 do begin
			//проверяем, касается ли шарик  кирпича
			if bricks[i].lives>0 then
			begin
				if CollideRectangle_p(player, bricks[i].box, width, height)
				then begin
					score:=score+10;
					//изменение направления движения шарика
					if CollideTop_p(bricks[i].box, player, player_old_y, height)
					then if collision=true then hy:=-3;

					if  CollideBottom_p(bricks[i].box, player, player_old_y, height)
					then if collision=true then hy:=3;

					if CollideLeft_p(bricks[i].box, player, player_old_x, width) or
					CollideRight_p(bricks[i].box, player, player_old_x, width)
					then if collision=true then hx:=-hx;
					//отнимание жизни у кирпичика
					if (k_bonus[1]=true)
						then  bricks[i].lives:=bricks[i].lives-2
						else  bricks[i].lives:=bricks[i].lives-1;
				end;
							
				if bricks[i].lives<=0 then bricks_count:=bricks_count-1;
				if (bricks[i].lives<=0) and (bricks[i].typei=3) then bricks[i].tBool:=true;
			end;
			
			if (pbricks[i].box.y+pbricks[i].box.height)=height then bricks[i].tBool:=false;
			if bricks[i].tBool=true	then
			begin
				if CollideRectangle(pBricks[i].box,poll) then
				begin
					score:=score+100;
					level_score:=level_score+100;
					if bricks[i].Bonus=6 then
					begin
						poll.width:=150;
						timer_s[3]:=SDL_GetTicks();
						k_bonus[3]:=true;
					end;
					
					if bricks[i].Bonus=3 then
					begin
						timer_s[1]:=SDL_GetTicks();
						k_bonus[1]:=true;
						collision:=false;
					End;
										
					if bricks[i].Bonus=5 then
					begin
						poll.width:=60;
						k_bonus[2]:=true;
					end;
					
					if bricks[i].Bonus=2 then
					begin
						k_bonus[4]:=true;
						timer_s[4]:=SDL_GetTicks();
					end;
					
					bricks[i].tBool:=false;
				end;
			end;
		end;

		if GetKeyState(32) and 128 = 128 then spacecon:=true;

		//проверяем, есть ли столкновение шарика и ракетки
		if CollideRectangle(player, poll) = true
		then begin
			dir_x:= player_old_x - player.x;
			dir_y:= 0;

			if (CollideTop(poll, player, player_old_y)) = true
			then begin
				hy:=-hy;
				dir_x:=0;
				dir_y:=-l;
				if ((GetKeyState(65) and 128)=128) and (player.x+player.width<(poll.x+poll.width)/ 2)
				then begin
					hy:=-4;
					hx:=-2;
				end;
				
				if (GetKeyState(68) and 128=128) and (player.x>(poll.x+poll.width)/ 2)
				then begin
					hy:=-4;
					hx:=2;
				end;
				
				if k_bonus[4]=true then spacecon:=false;
			end;

			if (CollideBottom(poll, player, player_old_y)) = true
			then begin
				hy:=-hy;
				dir_x:=0;
				dir_y:=l;
			end;

			if CollideLeft(poll, player, player_old_x) = true
			then begin
				hx:=-hx;
				dir_x:=-l;
				dir_y:=0;
			end;

			if CollideRight(poll, player, player_old_x) = true
			then begin
				hx:=-hx;
				dir_x:=l;
				dir_y:=0;
			end;
			
			if (win1=false) and (fail1=false)
			then begin
				if (GetKeyState(65) and 128)=128 then dir_x:=-l;

				if GetKeyState(68) and 128 = 128 then dir_x:=l;
			end;

			while CollideRectangle(player, poll) = true do
			begin
			 writeln('Dir_x=', dir_x);
			 writeln('Dir_y=', dir_y);
			 player.x:= player.x + dir_x;
			 player.y:= player.y + dir_y;
			 player_old_x:=player.x + dir_x;
			 player_old_y:=player.y + dir_x;
			end;
		end;

		//сохраняем предыдущую позицию шарика
		player_old_x:=player.x;
		player_old_y:=player.y;
	end;
end;

procedure FBORender;
begin
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fboId); //Активируем FBO
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);//Очищаем буферы цвета и глубины
  renderscene;
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);//Деактивируем FBO
  //Сгенерируем для полученной текстуры мип-уровни
  glBindTexture(GL_TEXTURE_2D, textureId);
  glGenerateMipmapEXT(GL_TEXTURE_2D);

  if win1=true or fail1=true then glUseProgram(ProgramObject);
  draw_quad(0,0,width,height); //рисуем скринквад с полученной текстурой
	 	// glBindTexture(GL_TEXTURE_2D, 0);//Деактивируем текстуру
  if win1=true or fail1=true then glUseProgram(0);

  if game=true then
	begin
		win(bricks_count);
		fail(counter);
	end;
end;

procedure win(var bcount:integer);
begin
	if bcount<=0 then
	begin
		ShowCursor(true);
		glBindTexture(GL_TEXTURE_2D, Tex.wf[1]);
		draw_quad(0,0,width,height);
		
		glBindTexture(GL_TEXTURE_2D, Tex.Return);
		draw_quad((width/3 -70/2),(height/2 -70/2),70,70);
		
		glBindTexture(GL_TEXTURE_2D, Tex.Next);
		draw_quad((width/2 -70/2),(height/2 -70/2),70,70);
		
		glBindTexture(GL_TEXTURE_2D, Tex.Home);
		draw_quad((width/2 -70/2)+(abs(width/2-width/3)),(height/2 -70/2),70,70);
		
		win1:=true;
		fail1:=false;
	end;
end;

procedure fail(var cnt:integer);
begin
	if cnt<=0 then
	begin
		ShowCursor(true);
		glBindTexture(GL_TEXTURE_2D, Tex.wf[2]);
		draw_quad(0,0,width,height);
		
		glBindTexture(GL_TEXTURE_2D, Tex.Return);
		draw_quad((width/3 -70/2),(height/2 -70/2),70,70);
		
		glBindTexture(GL_TEXTURE_2D, Tex.Next);
		draw_quad((width/2 -70/2),(height/2 -70/2),70,70);
		
		glBindTexture(GL_TEXTURE_2D, Tex.Home);
		draw_quad((width/2 -70/2)+(abs(width/2-width/3)),(height/2 -70/2),70,70);
		fail1:=true;
		win1:=false;
	end;
end;

procedure checkbox_draw(lx,ly:integer; lst:integer);
begin
	kx:=lx; ky:=ly; st:=lst;
	if checked[st]=true
		then glBindTexture(GL_TEXTURE_2D, Tex.CheckBoxd)
		else glBindTexture(GL_TEXTURE_2D, Tex.CheckBox);
	draw_quad(kx,ky,30,30);

end;

procedure bkg_scrolling;
begin

	glBindTexture(GL_TEXTURE_2D, Tex.gMenu[3]);
    glBegin( GL_QUADS );
		glTexCoord2f(_x01, 0.0);   glVertex2f(0, height);
		glTexCoord2f(_x02, 0.0);   glVertex2f(width, height);
		glTexCoord2f(_x03, 1.0);   glVertex2f(width, 0);
		glTexCoord2f(_x04, 1.0);   glVertex2f(0, 0);
	glEnd();
	
	glBindTexture(GL_TEXTURE_2D, Tex.gMenu[1]);
    glBegin( GL_QUADS );
		glTexCoord2f(_x1, 0.0);   glVertex2f(0, height);
		glTexCoord2f(_x2, 0.0);   glVertex2f(width, height);
		glTexCoord2f(_x3, 1.0);   glVertex2f(width, 0);
		glTexCoord2f(_x4, 1.0);   glVertex2f(0, 0);
	glEnd();
	_x1:=_x1+0.001; _x2:=_x2+0.001;
	_x3:=_x3+0.001; _x4:=_x4+0.001;

	if (_x1=1) then _x1:=0; if (_x4=1) then _x4:=0;
	if(_x2=2) then _x2:=1;  if(_x3=2) then _x3:=1;

	_x01:=_x01+0.0001; _x02:=_x02+0.0001;
	_x03:=_x03+0.0001; _x04:=_x04+0.0001;

	if (_x01=1) then _x01:=0; if (_x04=1) then _x04:=0;
	if(_x02=2) then _x02:=1;  if(_x03=2) then _x03:=1;
end;

procedure main_draw;
begin
	_width:=170;
	_height:=99;
	x02:=0.18; y02:=0.2; x05:=0.62; y05:=0.65;
	x01:=0.5-(_width/2)/width; y01:=0.5-(_height/2)/(width-width div 5);
	x03:=0.18; y03:=0.65; x04:=0.62; y04:=0.2;
	
	bkg_scrolling;

	glBindTexture(GL_TEXTURE_2D, Tex.gMenu[2]);
	draw_quad(0,0,width,height);

	if (mouse_x>x01*width) and (mouse_x<(x01*width+_width))
	and (mouse_y<(y01*height+_height)) and (mouse_y>y01*height)
		then glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsi[1])
		else glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsf[1]);
	draw_quad_p(x01, y01, _width, _height,width,height);

	if (mouse_x>(x04*width)) and (mouse_x<(x04*width+_width))
	and (mouse_y<(y04*height+_height)) and (mouse_y>(y04*height))
		then glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsi[5])
		else glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsf[5]);
	draw_quad_p(x04, y04, _width, _height,width, height);

	if (mouse_x>x02*width) and (mouse_x<(x02*width+_width))
	and (mouse_y<(y02*height+_height)) and (mouse_y>y02*height)
		then glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsi[2])
		else glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsf[2]);
	draw_quad_p(x02, y02, _width, _height,width, height);

	if (mouse_x>x03*width) and (mouse_x<(x03*width+_width))
	and (mouse_y<(y03*height+_height)) and (mouse_y>y03*height)
		then glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsi[3])
		else glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsf[3]);
	draw_quad_p(x03, y03, _width, _height,width, height);

	if (mouse_x>x05*width) and (mouse_x<(x05*width+_width))
	and (mouse_y<(y05*height+_height)) and (mouse_y>y05*height)
		then glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsi[4])
		else glBindTexture(GL_TEXTURE_2D, Tex.MenuItemsf[4]);
	draw_quad_p(x05, y05, _width, _height,width, height);
end;

procedure draw_manual;
begin
	_mwidth:=240; _mheight:=200;
	mx02:=654; my02:=240;
	mx01:=352; my01:=240;
	mx03:=(width div 2) ; my03:=360;
	mx04:=630; my04:=156;

	bkg_scrolling;

	glBindTexture(GL_TEXTURE_2D, Tex.gMenu[2]);
	draw_quad(0,0,width,height);

	if (mouse_x>0) and (mouse_x<70) and (mouse_y<70) and (mouse_y>0)
		then glBindTexture(GL_TEXTURE_2D, Tex.back[2])
		else glBindTexture(GL_TEXTURE_2D, Tex.back[1]);
	draw_quad(0, 0, 70, 70);

	if (mouse_x>(mx01-_mwidth/2)) and (mouse_x<mx01+_mwidth/2)
	and (mouse_y<my01+_mheight/2) and (mouse_y>(my01-_mheight/2))
		then glBindTexture(GL_TEXTURE_2D, Tex.mHelph[1])
		else glBindTexture(GL_TEXTURE_2D, Tex.mHelp[1]);
	draw_quad_c(mx01, my01, _mwidth, _mheight);

	if (mouse_x>(mx02-_mwidth/2)) and (mouse_x<mx02+_mwidth/2)
	and (mouse_y<my02+_mheight/2) and (mouse_y>(my02-_mheight/2))
		then glBindTexture(GL_TEXTURE_2D, Tex.mHelph[2])
		else glBindTexture(GL_TEXTURE_2D, Tex.mHelp[2]);
	draw_quad_c(mx02, my02, _mwidth, _mheight);

	if (mouse_x>(mx03-_mwidth/2)) and (mouse_x<mx03+_mwidth/2)
	and (mouse_y<my03+_mheight/2) and (mouse_y>(my03-_mheight/2))
		then glBindTexture(GL_TEXTURE_2D, Tex.mHelph[3])
		else glBindTexture(GL_TEXTURE_2D, Tex.mHelp[3]);
	draw_quad_c(mx03, my03, _mwidth, _mheight);
end;

procedure options_draw;
begin
	glClear(GL_COLOR_BUFFER_BIT);
	glBindTexture(GL_TEXTURE_2D, Tex.mBkg);
	draw_quad(0,0,width,height);
	checkbox_draw(width div 2, height div 2, 1);
end;


procedure ogl_draw;
var
	i,j : integer;
begin
	bkg_scrolling;
	if game=true then
	begin
		glBindTexture(GL_TEXTURE_2D, Tex.tbkg);
		draw_quad(0,0,width,height);
		//рисуем наш "шарик"//
		glBindTexture(GL_TEXTURE_2D, Tex.Ball);
		draw_quad(player.x, player.y, player.width, player.height);
		//рисуем ракетку//
		glBindTexture(GL_TEXTURE_2D, Tex.Poll);
		draw_quad(poll.x,poll.y,poll.width,poll.height);
	end;
	if editor=true
    then begin
		if usesnap=true
			then  glBindTexture(GL_TEXTURE_2D, Tex.gEdit[2])
			else glBindTexture(GL_TEXTURE_2D, Tex.gEdit[1]);
		draw_quad(0,0,width,height);
	end;
	
    for i:=1 to 256 do begin

		if bricks[i].lives>0 then
		begin
			if (bricks[i].lives = 1) and (bricks[i].typei = 2)
				then	glBindTexture(GL_TEXTURE_2D, Tex.wAlive[round(bricks[i].Ttype)])
				else if (bricks[i].lives = 1) and  (bricks[i].typei=1)
					then 	glBindTexture(GL_TEXTURE_2D, Tex.iLive)
					else if bricks[i].lives = 2
						then  glBindTexture(GL_TEXTURE_2D, Tex.wLive[round(bricks[i].Ttype)]);
						
			if bricks[i].typei=3 then glBindTexture(GL_TEXTURE_2D, Tex.Magic);
			draw_quad_p(bricks[i].box,width, height);
		end;
	
		if game=true
			then if (bricks[i].lives<=0 ) and (bricks[i].typei=3) and (bricks[i].tBool=true)
			then begin
				glBindTexture(GL_TEXTURE_2D, Tex.TBonus[round(bricks[i].Bonus)]);
				draw_quad_p(pBricks[i].box,width, height);
				pbricks[i].box.y:=pbricks[i].box.y+1.2;
			end;
	end;

	if (editor=true) then
    begin
        for i:=1 to 256 do
			if  (bricks[i].lives>0) and (WndRMouseUp=false)	then
				if useSnap=true then
					if (bricks[i].box.x=(round(mouse_x/snapStepx)*snapStepx)/width) and
					(bricks[i].box.y=(round(mouse_y/snapStepy)*snapStepy)/height)
						then bricks[i].lives:=0	else
							if (bricks[i].box.x=mouse_x/width) and	(bricks[i].box.y=mouse_y/height)
								then bricks[i].lives:=0;
    end;

	
end;

procedure OnExit;
var tpk: real;
begin
	if pexit=true then
		if (win1=false) and (fail1=false) then
		begin
			hx:=0;
			hy:=0;
			poll.x:=width/2;
			if width=1024 then tpk:=426
						  else tpk:=426/1.28;
			glBindTexture(GL_TEXTURE_2D, Tex.kMenu);
			draw_quad(0,0,tpk ,height);
					
			glBindTexture(GL_TEXTURE_2D, Tex.return);
			draw_quad_p(0.036, 0.22, 70, 69, width, height);
					
			glBindTexture(GL_TEXTURE_2D, Tex.next);
			draw_quad_p(0.036, 0.43, 70, 69,width, height);
					
			glBindTexture(GL_TEXTURE_2D, Tex.home);
			draw_quad_p(0.036, 0.64, 70, 69,width, height);
		end;
end;

procedure InitTexture;
begin
	Tex.wLive[1]:=Texture_Init('Data\Images\wood_bricks\b\b1.bmp');
	Tex.wLive[2]:=Texture_Init('Data\Images\wood_bricks\b\b2.bmp');
	Tex.wLive[3]:=Texture_Init('Data\Images\wood_bricks\b\b3.bmp');

	Tex.wALive[1]:=Texture_Init('Data\Images\wood_bricks\b1.bmp');
	Tex.wALive[2]:=Texture_Init('Data\Images\wood_bricks\b2.bmp');
	Tex.wALive[3]:=Texture_Init('Data\Images\wood_bricks\b3.bmp');

	Tex.bkg[1]:=Texture_Init('Data\Images\bkg\bkg1.bmp');
	Tex.bkg[2]:=Texture_Init('Data\Images\bkg\bkg2.bmp');
	Tex.bkg[3]:=Texture_Init('Data\Images\bkg\bkg3.bmp');
	Tex.bkg[4]:=Texture_Init('Data\Images\bkg\bkg4.bmp');
	Tex.bkg[5]:=Texture_Init('Data\Images\bkg\bkg5.bmp');
	Tex.bkg[6]:=Texture_Init('Data\Images\bkg\bkg6.bmp');

	Tex.home:=Texture_Init('Data\Images\gui\return.bmp');
	Tex.bkg_paused:=Texture_Init('Data\Images\bkg\bkg_paused.bmp');

	Tex.tpSymbol[1]:=Texture_Init('Data\Images\numbers\0.bmp');
	Tex.tpSymbol[2]:=Texture_Init('Data\Images\numbers\1.bmp');
	Tex.tpSymbol[3]:=Texture_Init('Data\Images\numbers\2.bmp');
	Tex.tpSymbol[4]:=Texture_Init('Data\Images\numbers\3.bmp');
	Tex.tpSymbol[5]:=Texture_Init('Data\Images\numbers\4.bmp');
	Tex.tpSymbol[6]:=Texture_Init('Data\Images\numbers\5.bmp');
	Tex.tpSymbol[7]:=Texture_Init('Data\Images\numbers\6.bmp');
	Tex.tpSymbol[8]:=Texture_Init('Data\Images\numbers\7.bmp');
	Tex.tpSymbol[9]:=Texture_Init('Data\Images\numbers\8.bmp');
	Tex.tpSymbol[10]:=Texture_Init('Data\Images\numbers\9.bmp');

	Tex.gMenu[1]:=Texture_Init('Data\Images\gui\background.bmp');
	Tex.gMenu[2]:=Texture_Init('Data\Images\gui\mainlayer.bmp');
	Tex.gMenu[3]:=Texture_Init('Data\Images\gui\background2.bmp');

	Tex.iLive:=Texture_Init('Data\Images\ice_bricks\b1.bmp');
	Tex.Ball:=Texture_Init( 'Data\Images\svi.bmp');
	Tex.Poll:=Texture_Init( 'Data\Images\texture.bmp');
	Tex.Magic:=Texture_Init('Data\Images\other_bricks\b1.bmp');

	Tex.TBonus[1]:=Texture_Init('Data\Images\other_bricks\b2.bmp');
	Tex.TBonus[2]:=Texture_Init('Data\Images\other_bricks\b3.bmp');
	Tex.TBonus[3]:=Texture_Init('Data\Images\other_bricks\b4.bmp');
	Tex.TBonus[4]:=Texture_Init('Data\Images\other_bricks\b5.bmp');
	Tex.TBonus[5]:=Texture_Init('Data\Images\other_bricks\b6.bmp');
	Tex.TBonus[6]:=Texture_Init('Data\Images\other_bricks\b7.bmp');
	Tex.TBonus[7]:=Texture_Init('Data\Images\other_bricks\b8.bmp');

	Tex.Tbkg:=Texture_Init('Data\Images\gui\b1.bmp');

	Tex.wf[1]:=Texture_Init('Data\Images\gui\win.bmp');
	Tex.wf[2]:=Texture_Init('Data\Images\gui\fail.bmp');
	Tex.Next:=Texture_Init('Data\Images\gui\next.bmp');

	Tex.MenuItemsf[1]:=Texture_Init('Data\Images\gui\button1.bmp');
	Tex.MenuItemsf[2]:=Texture_Init('Data\Images\gui\button2.bmp');
	Tex.MenuItemsf[3]:=Texture_Init('Data\Images\gui\button3.bmp');
	Tex.MenuItemsf[4]:=Texture_Init('Data\Images\gui\button4.bmp');
	Tex.MenuItemsf[5]:=Texture_Init('Data\Images\gui\button5.bmp');

	Tex.MenuItemsi[1]:=Texture_Init('Data\Images\gui\btn2\button1.bmp');
	Tex.MenuItemsi[2]:=Texture_Init('Data\Images\gui\btn2\button2.bmp');
	Tex.MenuItemsi[3]:=Texture_Init('Data\Images\gui\btn2\button3.bmp');
	Tex.MenuItemsi[4]:=Texture_Init('Data\Images\gui\btn2\button4.bmp');
	Tex.MenuItemsi[5]:=Texture_Init('Data\Images\gui\btn2\button5.bmp');

	Tex.gHelp[1]:=Texture_Init('Data\Images\gui\manual.bmp');
	Tex.gHelp[2]:=Texture_Init('Data\Images\gui\back.bmp');

	Tex.gEdit[1]:=Texture_Init('Data\Images\gui\b2.bmp');
	Tex.gEdit[2]:=Texture_Init('Data\Images\gui\b2_e.bmp');

	Tex.CheckBox:=Texture_Init('Data\Images\gui\checkbox.bmp');
	Tex.CheckBoxd:=Texture_Init('Data\Images\gui\checkboxd.bmp');

	Tex.mHelp[1]:=Texture_Init('Data\Images\gui\help\editor.bmp');
	Tex.mHelp[2]:=Texture_Init('Data\Images\gui\help\game.bmp');
	Tex.mHelp[3]:=Texture_Init('Data\Images\gui\help\info.bmp');

	Tex.mHelph[1]:=Texture_Init('Data\Images\gui\help\editorh.bmp');
	Tex.mHelph[2]:=Texture_Init('Data\Images\gui\help\gameh.bmp');
	Tex.mHelph[3]:=Texture_Init('Data\Images\gui\help\infoh.bmp');

	Tex.back[1]:=Texture_Init('Data\Images\gui\back.bmp');
	Tex.back[2]:=Texture_Init('Data\Images\gui\backh.bmp');

	Tex.mBkg:=Texture_Init('Data\Images\bkg\mbkg.bmp');
	Tex.return:=Texture_Init('Data\Images\gui\repeat.bmp');
	Tex.kMenu:=Texture_Init('Data\Images\gui\mmenu.bmp');
end;

procedure Timers;
begin
   if  ((SDL_GetTicks()-timer_s[1])>=5000) and (k_bonus[1]=true)
    then begin k_bonus[1]:=false; collision:=true; end;

   if  ((SDL_GetTicks()-timer_s[2])>=30000) and (k_bonus[2]=true)
    then begin k_bonus[2]:=false; poll.width:=100; end;

   if  ((SDL_GetTicks()-timer_s[3])>=30000) and (k_bonus[3]=true)
    then begin k_bonus[3]:=false; poll.width:=100; end;

   if  ((SDL_GetTicks()-timer_s[4])>=20000) and (k_bonus[4]=true) and (spacecon=false)
    then begin k_bonus[4]:=false; end;
end;

procedure init_static;
var
  i : Integer;
begin
  l:=3;
  lp:=4;
  hx:=l;
  hy:=l;
  spacecon:=false;
  _x1:=0;
  _x2:=1;
  _x3:=1;
  _x4:=0;

   _x01:=0;
  _x02:=1;
  _x03:=1;
  _x04:=0;
  player.width:=20;
  player.height:=20;
  player.x:=(width - player.width) / 2;
  player.y:=(height / 2)-player.height+9;
  bk:=true;
  bk2:=true;
  player_old_x:=player.x;
  player_old_y:=player.y;
  snapStepx:=54;
  snapStepy:=30;
  poll.width:=100;
  poll.height:=20;
  poll.x:=(width-poll.width) /2;
  poll.y:=((height+poll.height)/2)+(height /3);
  for i:=1 to 256 do
	begin
		bricks[i].Bonus:=random(7)+1;
		pBricks[i].box.width:=37;
		pBricks[i].box.height:=21;
		pBricks[i].tBool:=false;
	end;
  counter:=3;

  QueryPerformanceFrequency(perf_freq);
  QueryPerformanceCounter(perf_now);
  perf_last:=perf_now;
end;

Procedure TPrintText(text2:integer; t1, t2,TLength: real; twidth,theight:real);
var k:integer; text:string;
begin
	mSymbol[1].x:=t1;
	mSymbol[1].y:=t2;
	Str(text2, text);
	k:=length(text);
	for i:=1 to k do begin
		if text[i]='0' then Tex.pSymbol:=Tex.tpSymbol[1];  if text[i]='1' then Tex.pSymbol:=Tex.tpSymbol[2];
		if text[i]='2' then Tex.pSymbol:=Tex.tpSymbol[3];  if text[i]='3' then Tex.pSymbol:=Tex.tpSymbol[4];
		if text[i]='4' then Tex.pSymbol:=Tex.tpSymbol[5];  if text[i]='5' then Tex.pSymbol:=Tex.tpSymbol[6];
		if text[i]='6' then Tex.pSymbol:=Tex.tpSymbol[7];  if text[i]='7' then Tex.pSymbol:=Tex.tpSymbol[8];
		if text[i]='8' then Tex.pSymbol:=Tex.tpSymbol[9];  if text[i]='9' then Tex.pSymbol:=Tex.tpSymbol[10];

		mSymbol[i].width:=twidth;
		mSymbol[i].height:=theight;
		
		if i>1 then	begin
			mSymbol[i].x:=mSymbol[i-1].x+mSymbol[i-1].width+TLength;
			mSymbol[i].y:=mSymbol[i-1].y;
		end;
		glBindTexture(GL_TEXTURE_2D, Tex.pSymbol);
		draw_quad(mSymbol[i].x,mSymbol[i].y,mSymbol[i].width,mSymbol[i].height);
	end;
end;

procedure renderscene;
var pFileRecord:FileRecord; F:Text; filebool: FileRecord; myfilebool:boolean; Fb: file of Brick;
begin
		{$ifdef debug}
			//Writeln(date);
		{$endif}
		// glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGB4, 0, 0, 1024, 768, 0);
		//Writeln((mouse_x/width):4, (mouse_y/height):4);
		QueryPerformanceCounter(perf_now);
		frame_time:=(perf_now/perf_freq-perf_last/perf_freq);
		perf_last:=perf_now;
		
		if PeekMessage(@msg,0,0,0,0) = true then
		begin
			GetMessage(@msg,0,0,0);
			TranslateMessage(msg);
			DispatchMessage(msg);
		end;
	
		if mainmenu=true then main_draw;
		if manual=true then draw_manual;
		if options=true then options_draw;
		if game=true  then
		begin
			Timers;
				
			if FileResult=true then
			begin
				bricks_count:=0;

				if FindExtention2(k_name) = '.txt' then begin
					Assign(TFile,  k_name);
					Reset(TFile);
					writeln(k_name);
					for pi:=1 to 256 do	begin
							Readln(TFile, bricks[pi].lives,
											bricks[pi].box.x,
											bricks[pi].box.y,
											bricks[pi].box.width,
											bricks[pi].box.height,
											bricks[pi].typei,
											bricks[pi].tType);
												
							if bricks[pi].lives>0 then bricks_count:=bricks_count+1;
								
							pBricks[pi].box.x:=bricks[pi].box.x*width;
							pBricks[pi].box.y:=bricks[pi].box.y*height;

					end;
					Close(TFile);
				end;
				if FindExtention2(k_name) = '.lvl' then begin
					Assign(Fb,  k_name);
					Reset(Fb);
					writeln(k_name);
					for pi:=1 to 256 do	begin
							Read(Fb, bricks[pi]);
												
							if bricks[pi].lives>0 then bricks_count:=bricks_count+1;
								
							pBricks[pi].box.x:=bricks[pi].box.x*width;
							pBricks[pi].box.y:=bricks[pi].box.y*height;

					end;
					Close(Fb);
				end;
				
				FileResult:=false;
			end;
				
			if FileResult=false	then ogl_draw;
				
			{$ifdef debug}
				//Writeln(bricks[1].box.x);
			{$endif}
			fps:=1/frame_time;
				
			{$ifdef debug}
				//Writeln(frame_time:5:5);
			{$endif}
				
			Sleep(10);
			if (win1=false) and (fail1=false) then begin
				//ShowCursor(false);
				Handle_Input;
				TPrintText(bricks_count,390,8,2,15,25);
				TPrintText(counter,0.86*width,0.43*height,0,10,20);
				TPrintText(highs,0.82*width,0.12*height,0,15,25);
			end;
				
			OnExit;
				
		end;
		if editor=true then
		begin
			ogl_draw;
			if FileResult=true then	
			begin
				for i:=1 to 256 do begin
					bricks[i].lives:=0;
					bricks[i].box.x:=0;
					bricks[i].box.y:=0;
					bricks[i].box.width:=0;
					bricks[i].box.height:=0;
					bricks[i].typei:=0;
					bricks[i].tType:=0;
					bricks[i].Bonus:=0;
					bricks[i].tBool:=false;
				end;
				FileResult:=false;
			end;
			
			if (GetKeyState(VK_CONTROL) and 128)>=128	then
			begin
				
				MyThread.Resume;
				filebool:=MyThread.GetMyFileResult;
				if filebool.bool=true then	begin
					if filebool.filetype=1 then begin
						Assign(Fb, filebool.filename_with_path);
						Rewrite(Fb);
						for i:=1 to 256 do
                Write(Fb,  bricks[i]);

						Close(Fb);
					end else begin
						Assign(F, filebool.filename_with_path);
						Rewrite(F);
						for i:=1 to 256 do	begin
							Writeln(F,  bricks[i].lives,
										bricks[i].box.x,
										bricks[i].box.y,
										bricks[i].box.width,
										bricks[i].box.height,
										bricks[i].typei,
										bricks[i].tType);
						end;
						Close(F);	
					end;
					filebool.bool:=false;
				end;
				
			end;
				{if GetKeyState(VK_RETURN) and 128>=128 then begin
									if Assigned(hCurl) then
							begin
							  str(score, str4);
							  str5:='MDS';
							  over:='&name='+str5+'&score='+str4+'&date='+date;
							  curl_easy_setopt(hCurl, CURLOPT_URL, [URL]);
							  curl_easy_setopt(hCurl, CURLOPT_POST, [1]);
							  curl_easy_setopt(hCurl, CURLOPT_POSTFIELDS, [@over]);
							  curl_easy_perform(hCurl);
							  curl_easy_cleanup(hCurl);
							end;
							end;}
					OnExit;
		end;
end;

procedure maindraw;
begin
	Randomize;
	SDL_Init(SDL_INIT_TIMER and SDL_INIT_AUDIO);

	if MIX_OPENAUDIO(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS,	AUDIO_CHUNKSIZE)<>0
		then HALT;

	music:=MIX_LOADMUS('main.mp3');
	MIX_VOLUMEMUSIC(100);
	MIX_PLAYMUSIC(music,1);

	FileMask:=GetCurrentDir()+'\Data\Levels\level*.*';
	FindFirst(FileMask,faAnyFile,Fs);
	k_name:=GetCurrentDir()+'\Data\Levels\'+Fs.Name;
	
	if MessageBox(0,'Fullscreen Mode?', 'Question!',MB_YESNO OR MB_ICONQUESTION) = IDNO
		then fullscreen := false
		else fullscreen := true;

	if (GetSystemMetrics(SM_CYSCREEN)<800)
		then begin
			w_width:=800;
			w_height:=600;
			w_mode:=1;
		end
	else begin
		w_width:=1024;
		w_height:=768;
		w_mode:=2;
	end;
	
	CreateOGLWindow('CollapseBall', w_width, w_height, 32,fullscreen);
	
	OpenGL_Init();
	InitOpenGL;
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	glDisable(GL_COLOR_MATERIAL);

	GetSystemTime(@ftime);
	MyThread:=TMyThread.Create(true);
	//////////////////////////////////////////////////////////////////////////////////
	ProgramObject        := glCreateProgram();
	VertexShaderObject   := glCreateShader(GL_VERTEX_SHADER);
	FragmentShaderObject := glCreateShader(GL_FRAGMENT_SHADER);	

	fs2:=textfileread('Data\Shaders\Gaussin\g.fs');
	vs2:=textfileread('Data\Shaders\Gaussin\g.vs');

	glShaderSource(VertexShaderObject, 1, @vs2, NIL);
	glShaderSource(FragmentShaderObject, 1, @fs2, NIL);

	glCompileShader(VertexShaderObject);
	glCompileShader(FragmentShaderObject);

	glAttachShader(ProgramObject, VertexShaderObject);
	glAttachShader(ProgramObject, FragmentShaderObject);

	glLinkProgram(ProgramObject);
	//////////////////////////////////////////////////////////////////////////////////
	
	Str(ftime.wYear, str1); Str(ftime.wMonth, str2); Str(ftime.wDay, str3);
	date:=str1+'-'+str2+'-'+str3;

	InitTexture;
	hCurl:= curl_easy_init;
	Init_Static;
	InitFBO(textureid, fboid, width, height);
	repeat
		FBORender;			
		writeln(k_name);
			
		SwapBuffers( dcWindow );
	Until active = false;
	
	FreeFBO(textureid, fboid);

	MIX_HALTMUSIC;
	MIX_HALTCHANNEL(soundchannel);
	MIX_FREEMUSIC(music);
	MIX_FREECHUNK(sound);

	Mix_CloseAudio;
	FindClose(Fs);
	KilloglWindow();
	// Mix_CloseAudio();
	SDL_Quit();
end;
end.
