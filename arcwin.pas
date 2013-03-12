unit arcwin;

interface

uses windows, gl, glu, arcinput;
var
  msg 			: 	TMSG;		
  hWindow 		: 	HWnd;	
  dcWindow 		: 	hDc;	
  rcWindow 		: 	HGLRC;	
  windowRect 	: 	RECT;
  
procedure ThrowError(pcErrorMessage : pChar);
function GLWndProc(Window: HWnd; AMessage, WParam, LParam: Longint): Longint; stdcall; export;
function WindowRegister(width,height:integer): Boolean;
function WindowCreate(pcApplicationName : pChar; fullscreen: boolean; width,height,bits:integer): HWnd;
function WindowInit(hParent : HWnd; bits:integer): Boolean;
function CreateOGLWindow(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean; 

							 width:integer;
							 height: integer;
							 bits: integer;
							 fullscreen: boolean):Boolean;
procedure KillOGLWindow();
procedure OpenGL_Init(width,height: integer);
  
implementation

procedure ThrowError(pcErrorMessage : pChar);
begin
  MessageBox(0, pcErrorMessage, 'Error', MB_OK);
  Halt(0);
end;

function GLWndProc(Window: HWnd; AMessage, WParam, LParam: Longint ): Longint; stdcall; export;
var   Res: LRESULT; pex: boolean; act:boolean;
begin
  GLWndProc := 0;

  case AMessage of
    wm_create:

      begin
	      act := true;
		  OnCreate(act);
	      Exit;
      end;
    wm_paint:
      begin
         exit;
      end;

    wm_keydown:

      begin
	      if wParam = VK_ESCAPE then OnKeyDown(pex);
		  //SendMessage(hWindow,wm_destroy,0,0);
	       Exit;
      end;

    wm_destroy:
      begin
         act := false;
		 OnCreate(act);
         PostQuitMessage(0);
         Exit;
      end;
      wm_lbuttonup:
      begin
         OnMouseUp(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
      end;
      wm_lbuttondown:
      begin
         OnMouseDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
      end;
      wm_rbuttondown:
      begin
         OnMouseRDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
      end;
      wm_rbuttonup:
      begin
         OnMouseRUp(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
      end;
      wm_mbuttondown:
      begin
		OnMouseMDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
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

function WindowRegister(width,height:integer): Boolean;
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

function WindowCreate(pcApplicationName : pChar; fullscreen: boolean; width,height,bits:integer): HWnd;
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

function WindowInit(hParent : HWnd; bits:integer): Boolean;
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
  rcWindow := wglCreateContext( dcWindow );		

  if (rcWindow = 0) then FunctionError := 2;

  wglMakeCurrent( dcWindow, rcWindow );     

 if FunctionError = 0 then WindowInit := true else WindowInit := false;

end;

function CreateOGLWindow(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean; 

							 width:integer;
							 height: integer;
							 bits: integer;
							 fullscreen: boolean):Boolean;
begin
 width := iApplicationWidth;
 height := iApplicationHeight;
 bits := iApplicationBits;
 fullscreen := bApplicationFullscreen;

  if not WindowRegister(width, height) then begin
    ThrowError('Could not register the Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

  hWindow := WindowCreate(pcApplicationName, fullscreen, width, height, bits);
  if longint(hWindow) = 0 then begin
    ThrowError('Could not create Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

 if not WindowInit(hWindow, bits) then begin
    ThrowError('Could not initialise Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

 CreateOGLWindow := true;
end;

procedure KillOGLWindow();
begin
  wglMakeCurrent( dcWindow, 0 );    
  wglDeleteContext( rcWindow );       
  ReleaseDC( hWindow, dcWindow );     
  DestroyWindow( hWindow );         
end;

procedure OpenGL_Init(width,height: integer);
begin
  glClearColor( 0.0, 0.0, 0.0, 0.0 ); 
  glViewport( 0, 0, width, height ); 
  
  glmatrixmode(GL_PROJECTION);        
  glloadidentity();                   
  glortho(0, width, height, 0, 0, 1);
  glmatrixmode(GL_MODELVIEW);         
  glloadidentity();                   
  gltranslatef(0.375, 0.375, 0);     

  glDisable(GL_DEPTH_TEST);          
  glEnable(GL_CULL_FACE);            
  glCullFace(GL_BACK);             
  glFrontFace(GL_CCW);               
  glShadeModel(GL_SMOOTH);   
end;

end.