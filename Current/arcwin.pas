unit arcwin;

interface

uses windows, arcvariables, arcconst, arcsystem, arcdraw, dglopengl, sysutils;
  
procedure ThrowError(pcErrorMessage : pChar);
function WindowRegister(): Boolean;
function WindowCreate(pcApplicationName : pChar): HWnd;
function WindowInit(hParent : HWnd): Boolean;
function CreateOGLWindow(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean):Boolean;
procedure KillOGLWindow();
procedure OpenGL_Init();
implementation

procedure ThrowError(pcErrorMessage : pChar);
begin
  MessageBox(0, pcErrorMessage, 'Error', MB_OK);
  Halt(0);
end;

procedure KillOGLWindow();
begin
  wglMakeCurrent( dcWindow, 0 ); 
  wglDeleteContext( rcWindow );  
  ReleaseDC( hWindow, dcWindow ); 
  DestroyWindow( hWindow );
end;

procedure OpenGL_Init();
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

  windowRect.top:=  0;
  windowRect.left:= 0;
  windowRect.bottom:=windowRect.top + height;
  windowRect.right:=windowRect.left + width;

  AdjustWindowRect(@windowRect, WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN, false);
end;

function WindowInit(hParent : HWnd): Boolean;
var
  FunctionError : integer;
begin
  FunctionError := 0;
  dcWindow := GetDC( hParent );
  RCWindow:= CreateRenderingContext( DCWindow, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
  ActivateRenderingContext(DCWindow , RCWindow);

  if FunctionError = 0 then WindowInit := true
                       else WindowInit := false;

end;

function WindowCreate(pcApplicationName : pChar): HWnd;
var
  hWindow: HWnd;
  dmScreenSettings : DEVMODE; 
begin

 if fullscreen = false
  then hWindow := CreateWindow( 'GLWindow', pcApplicationName, WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
       cw_UseDefault, cw_UseDefault, windowRect.right - windowRect.left, windowRect.bottom - windowRect.top, 0, 0, system.MainInstance, nil )
  else begin
    dmScreenSettings.dmSize := sizeof(dmScreenSettings);
    dmScreenSettings.dmPelsWidth := width;    
    dmScreenSettings.dmPelsHeight := height;
    dmScreenSettings.dmBitsPerPel := bits;
    dmScreenSettings.dmFields := DM_BITSPERPEL OR DM_PELSWIDTH OR DM_PELSHEIGHT;

   if ChangeDisplaySettings(@dmScreenSettings,CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL then begin
        ThrowError('Your video card not supported');
        WindowCreate := 0;
        Exit;
    end;

    hWindow := CreateWindowEx( WS_EX_APPWINDOW, 'GLWindow', pcApplicationName, WS_POPUP OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
                              0, 0, width, height, 0, 0, system.MainInstance, nil );

    ShowCursor(true);
  end;

  if hWindow <> 0 then begin
    ShowWindow(hWindow, CmdShow);
    UpdateWindow(hWindow);
  end;

  WindowCreate := hWindow;
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

end.