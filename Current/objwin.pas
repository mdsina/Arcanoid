
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
  WindowClass.hIcon := LoadIcon(0, idi_Application);
  WindowClass.hCursor := LoadCursor(0, idc_Arrow);
  WindowClass.hbrBackground := GetStockObject(WHITE_BRUSH);
  WindowClass.lpszMenuName := nil;
  WindowClass.lpszClassName := 'GLWindow';

  WindowRegister := RegisterClass(WindowClass) <> 0;

  windowRect.top:=0;
  windowRect.left:=0;
  windowRect.bottom:=windowRect.top + height;
  windowRect.right:=windowRect.left + width;

  AdjustWindowRect(@windowRect, WS_CAPTION OR
                           WS_POPUPWINDOW OR WS_VISIBLE
                           OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN, false);

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
  pfd : PIXELFORMATDESCRIPTOR;
  iFormat : integer;

begin
 FunctionError := 0;
  dcWindow := GetDC( hParent );
  FillChar(pfd, sizeof(pfd), 0);
  pfd.nSize         := sizeof(pfd);
  pfd.nVersion      := 1;
  pfd.dwFlags       := PFD_SUPPORT_OPENGL OR PFD_DRAW_TO_WINDOW OR PFD_DOUBLEBUFFER;
  pfd.iPixelType    := PFD_TYPE_RGBA;
  pfd.cColorBits    := bits;
  pfd.cDepthBits    := 16;
  pfd.iLayerType    := PFD_MAIN_PLANE;

  iFormat := ChoosePixelFormat( dcWindow, @pfd );

  if (iFormat = 0) then FunctionError := 1;

  SetPixelFormat( dcWindow, iFormat, @pfd );
  rcWindow := wglCreateContext( dcWindow );		// єёЄрэютър ёт чш тшэфютюую юъэр ш +уы

  if (rcWindow = 0) then FunctionError := 2;

  wglMakeCurrent( dcWindow, rcWindow );         //засовываем наш OGL в окошечко

 if FunctionError = 0 then WindowInit := true else WindowInit := false;

end;

//основная функция создания форточки//
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

//создаем нашу текстуру//
function Texture_Init(path:pchar):GLuint;

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
 glTexImage2D(GL_TEXTURE_2D, 0, sbitmap.bmBitsPixel div 8, sbitmap.bmWidth, sbitmap.bmHeight,
               0, format, GL_UNSIGNED_BYTE, sbitmap.bmBits);
  glBindTexture(GL_TEXTURE_2D, TextureID);
  Texture_Init:=TextureID;
end;