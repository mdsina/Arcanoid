unit arcwin;

interface

uses windows, arcvariables, arcconst, arcsystem, dglopengl, sysutils, arctypes;

var  
  dcWindow    :   hDc;  
  rcWindow    :   HGLRC;  
  ThWindow     :   HWnd; 
  
procedure ThrowError(pcErrorMessage : pChar);
function WindowRegister(var Proc: ArcBoolFuncType; iApplicationWidth, iApplicationHeight : longint; var windowRect:RECT): Boolean;
function WindowCreate(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean; windowRect:RECT): HWnd;
function WindowInit(hParent : HWnd): Boolean;
function CreateOGLWindow(var proc: ArcBoolFuncType; pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean):Boolean;
procedure KillOGLWindow();
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
  ReleaseDC( ThWindow, dcWindow ); 
  DestroyWindow( ThWindow );
end;

function WindowRegister(var Proc: ArcBoolFuncType; iApplicationWidth, iApplicationHeight : longint; var windowRect:RECT): Boolean;
var
  WindowClass: WndClass;
begin
  WindowClass.Style := cs_hRedraw or cs_vRedraw;
  WindowClass.lpfnWndProc := WndProc(Proc);
  WindowClass.cbClsExtra := 0;
  WindowClass.cbWndExtra := 0;
  WindowClass.hInstance := system.MainInstance;
  WindowClass.hIcon := LoadImage(0, 'ico.ico', IMAGE_ICON, 0, 0, LR_DEFAULTSIZE or LR_LOADFROMFILE);
  //WindowClass.hIconSm := LoadImage(0, 'ico.ico', IMAGE_ICON, 0, 0, LR_DEFAULTSIZE or LR_LOADFROMFILE);
  WindowClass.hCursor := LoadCursor(0, idc_Arrow);
  WindowClass.hbrBackground := GetStockObject(BLACK_BRUSH);
  WindowClass.lpszMenuName := nil;
  WindowClass.lpszClassName := 'GLWindow';

  WindowRegister := RegisterClass(WindowClass) <> 0;

  windowRect.top:=0;
  windowRect.left:=0;
  windowRect.bottom:=windowRect.top + iApplicationHeight;
  windowRect.right:=windowRect.left + iApplicationWidth;

  AdjustWindowRect(@windowRect, WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN, false);
end;

function WindowCreate(pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean; windowRect:RECT): HWnd;
var
  hWindow: HWnd;
  dmScreenSettings : DEVMODE; 
begin

 if bApplicationFullscreen = false
  then hWindow := CreateWindow('GLWindow', pcApplicationName, WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
       cw_UseDefault, cw_UseDefault, windowRect.right - windowRect.left, windowRect.bottom - windowRect.top, 0, 0, system.MainInstance, nil)
  else begin
      dmScreenSettings.dmSize := sizeof(dmScreenSettings);
      dmScreenSettings.dmPelsWidth := iApplicationWidth;    
      dmScreenSettings.dmPelsHeight := iApplicationHeight;
      dmScreenSettings.dmBitsPerPel := iApplicationBits;
      dmScreenSettings.dmFields := DM_BITSPERPEL OR DM_PELSWIDTH OR DM_PELSHEIGHT;

   if ChangeDisplaySettings(@dmScreenSettings,CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL  then  begin
        ThrowError('Your video card not supported');
        WindowCreate := 0;
        Exit;
   end;

    hWindow := CreateWindowEx(WS_EX_APPWINDOW,  'GLWindow',   pcApplicationName,  WS_POPUP OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
                  0, 0,   iApplicationWidth,   iApplicationHeight,   0, 0,   system.MainInstance, nil );
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
  RCWindow:= CreateRenderingContext( DCWindow, [opDoubleBuffered], 32, 24, 0, 0, 0, 0);
  ActivateRenderingContext(DCWindow , RCWindow);

  if FunctionError = 0 then WindowInit := true
             else WindowInit := false;
end;

function CreateOGLWindow(var proc: ArcBoolFuncType; pcApplicationName : pChar; iApplicationWidth, iApplicationHeight, iApplicationBits : longint; bApplicationFullscreen : boolean):Boolean;
var windowRect  :   RECT;
    

begin

  if not WindowRegister(Proc, iApplicationWidth, iApplicationHeight,  windowRect) then begin
    ThrowError('Could not register the Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

  ThWindow := WindowCreate(pcApplicationName, iApplicationWidth, iApplicationHeight, iApplicationBits ,bApplicationFullscreen, windowRect);
  if longint(ThWindow) = 0 then begin
    ThrowError('Could not create Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

 if not WindowInit(ThWindow) then begin
    ThrowError('Could not initialise Application Window!');
    CreateOGLWindow := false;
    Exit;
  end;

 CreateOGLWindow := true;
end;

end.