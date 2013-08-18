 {$define debug}
{$ifdef debug}
	{$APPTYPE CONSOLE}
{$else}
	{$APPTYPE CONSOLE}
{$endif}

{$COPERATORS ON}

{$MODE DELPHI}


uses  windows, dglopengl, sysutils, sdl, arcdraw, arcvariables, UPhysics2D, UPhysics2DTypes,  UPhysics2DHelper, math;

var world : Tb2World; poll_points : array of TVector2;


const M2P = 20.0;
P2M = 1.0/M2P;

function addCircle( x,y ,r: PhysicsFloat; dyn : boolean = true): Tb2Body;
var
  bodydef : Tb2BodyDef;
  body : Tb2Body;
  shape : Tb2CircleShape;
  fixturedef : Tb2fixtureDef;
begin
  bodydef := Tb2BodyDef.Create;
  shape := Tb2CircleShape.Create;
  fixturedef := Tb2FixtureDef.Create;

  bodydef.position.SetValue( x, y );
  if (dyn) then begin
    bodydef.bodyType := b2_dynamicBody;
  end;
  body := world.CreateBody(bodydef);
  shape.m_radius := r;
  shape.m_p.SetValue(0,0);
  fixturedef.shape := shape;
  fixturedef.friction := 0.5;
  fixturedef.restitution := 0;
  fixturedef.density := random(20)+8;
  body.CreateFixture(fixturedef);

  addCircle:= body;
end;

function addRect( x,y ,w,h: PhysicsFloat; dyn : boolean = true): Tb2Body;
var
  bodydef : Tb2BodyDef;
  body : Tb2Body;
  shape : Tb2PolygonShape;
  fixturedef : Tb2fixtureDef;
begin
  bodydef := Tb2BodyDef.Create;
  shape := Tb2PolygonShape.Create;
  fixturedef := Tb2FixtureDef.Create;


  bodydef.position.SetValue( x, y );
  if (dyn) then begin
    bodydef.bodyType := b2_dynamicBody;
  end;

  body := world.CreateBody(bodydef);

  shape.SetAsBox( w/2, h/2 );

  fixturedef.shape := shape;
  fixturedef.friction := 0.5;
  fixturedef.restitution := 0;
  fixturedef.density := 2;
  body.CreateFixture(fixturedef);

  addRect:= body;
end;

function addPolyBody( x,y : PhysicsFloat; vertexes : array of TVector2): Tb2Body;
var x1,y1,x2,y2 : real;
  bodydef : Tb2BodyDef;
  body : Tb2Body;
  shape : Tb2EdgeShape;
begin
  bodydef := Tb2BodyDef.Create;

  bodydef.position.SetValue( x, y );

  body := world.CreateBody(bodydef);

  x1 := vertexes[0].x;
  y1 := vertexes[0].y;
  shape := Tb2EdgeShape.Create;
  for i := 1 to High(vertexes) do
  begin
     x2 := vertexes[i].x;
     y2 := vertexes[i].y;

     shape.SetVertices(MakeVector(x1, y1), MakeVector(x2, y2));
     body.CreateFixture(shape, 2, False);

     x1 := x2;
     y1 := y2;
  end;

  addPolyBody:= body;
end;


procedure Drawcircle( center:TVector2; radius: real; angle : real);
var
  k_segments : integer = 16;
  k_increment : real;
  theta: real;
  i : integer;
  v, v2 : TVector2;
begin
  theta := 0;
  k_increment := 2 * 3.1415/ k_segments;

  {glPushMatrix();
  glTranslatef(center.x,center.y,0);
  glRotatef(angle*180.0/3.1415,0,0,1);}
  glBegin(GL_TRIANGLE_FAN);
  glVertex2f(center.x,center.y);
  for i := 0 to k_segments-1 do begin
    v2.SetValue(cos(theta), sin(theta) );
    v := center + radius * v2;

    glVertex2f(v.x, v.y);
    theta := theta + k_increment;
  end;
  v2.SetValue(cos(0), sin(0) );
  v := center + radius * v2;

  glVertex2f(v.x, v.y);
  glEnd();
  //glPopMatrix();
end;

procedure DrawLINESTRIP( points: array of TVector2; x,y: real);
  var i : integer;
begin
  if ( High(points)>=0 ) then begin
    glBegin(GL_TRIANGLE_STRIP);
    for i := 0 to High(points)+1 do
       glVertex2f(points[i].X + x, points[i].Y + y);

    //glVertex2f(mouse_x, mouse_y);
    glEnd;
  end;
end;

procedure drawSquare(points: array of TVector2; center: TVector2; angle : real);
  var i : integer;
begin
  glColor3f(1,1,1);
  glPushMatrix();
  glTranslatef(center.x,center.y,0);
  glRotatef(angle*180.0/3.1415,0,0,1);
  glBegin(GL_QUADS);
  for i := 0 to 3 do begin
    glVertex2f(points[i].x,points[i].y);
  end;
  glEnd();
  glPopMatrix();
end;

procedure drawPolyLine( points:array of TVector2; x,y: real);
var i: integer;
begin
  glBegin(GL_LINE_LOOP);
  for i := 0 to High(points) do
     glVertex2f(points[i].X + x, points[i].Y+y);
  glEnd;
end;

procedure  OnMouseUp(x, y:integer);
begin
end;
procedure  OnMouseRDown(x, y:integer);
begin
  addCircle(x,y, random(30)+10, true);
end;
procedure OnCreate(act: boolean);
begin
	active:=true;
end;
procedure OnDestroy(act: boolean);
begin
	active:=false;
end;

procedure OnMouseDown(x, y:integer);
begin
  //addRect(x,y,random(50)+10,random(50)+10,true);
  //SetLength(poll_points, High(poll_points)+2 );
  //poll_points[High(poll_points)].SetValue(x,y);
  addPolyBody(x,y,poll_points);
end;

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
var f23:text; i: integer;
begin
  GLWndProc := 0;

  case AMessage of
    wm_create: begin
	      active := true;
	      Exit;
      end;
    wm_paint: begin
         exit;
      end;

    wm_keydown: begin
	   if wParam = VK_ESCAPE then begin //pexit:=not pexit;//SendMessage(hWindow,wm_destroy,0,0);
        Assign(f23, 'outpoints.txt');
        Rewrite(f23);
        for i := 0 to High(poll_points) do begin
          writeln(f23, 'X = ',poll_points[i].X);
          writeln(f23, 'Y = ',poll_points[i].Y);
        end;
        Close(f23); end;
	       Exit;
      end;

    wm_destroy: begin
         active := false;
         PostQuitMessage(0);
         Exit;
      end;
    wm_lbuttonup: begin
         OnMouseUp(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
         WndMouseUp:=true;
      end;
    wm_lbuttondown: begin
        OnMouseDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
         WndMouseUp:=false;
      end;
    wm_rbuttondown: begin
         OnMouseRDown(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
         WndRMouseUp:=false;
      end;
    wm_rbuttonup: begin
         WndRMouseUp:=true;
      end;
    wm_mbuttondown: begin
		useSnap:=not UseSnap;
      end;
    wm_mousemove: begin
         OnMouseMove(GET_X_LPARAM(LParam), GET_Y_LPARAM(LParam));
      end;

    wm_syscommand: begin
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
  then hWindow := CreateWindow('GLWindow', pcApplicationName, WS_CAPTION OR WS_POPUPWINDOW OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
			 cw_UseDefault, cw_UseDefault, windowRect.right - windowRect.left, windowRect.bottom - windowRect.top, 0, 0, system.MainInstance, nil)
  else begin
      dmScreenSettings.dmSize := sizeof(dmScreenSettings);
      dmScreenSettings.dmPelsWidth := width;		
      dmScreenSettings.dmPelsHeight := height;
      dmScreenSettings.dmBitsPerPel := bits;
      dmScreenSettings.dmFields := DM_BITSPERPEL OR DM_PELSWIDTH OR DM_PELSHEIGHT;

	 if ChangeDisplaySettings(@dmScreenSettings,CDS_FULLSCREEN) <> DISP_CHANGE_SUCCESSFUL  then  begin
	      ThrowError('Your video card not supported');
	      WindowCreate := 0;
	      Exit;
	 end;

  	hWindow := CreateWindowEx(WS_EX_APPWINDOW,  'GLWindow',   pcApplicationName,  WS_POPUP OR WS_VISIBLE OR WS_CLIPSIBLINGS OR WS_CLIPCHILDREN,
  							  0, 0,   width,   height,   0, 0,   system.MainInstance, nil );
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

procedure KillOGLWindow();
begin
  wglMakeCurrent( dcWindow, 0 );
  wglDeleteContext( rcWindow );
  ReleaseDC( hWindow, dcWindow );
  DestroyWindow( hWindow );
end;

procedure OpenGL_Init();
begin
  glClearColor( 0.0, 0.0, 0.0, 1 );
  glViewport( 0, 0, width, height );

  glmatrixmode(GL_PROJECTION);
  glloadidentity();
  glortho(0, width, height, 0, 0, 1);
  glmatrixmode(GL_MODELVIEW);
  glloadidentity();
  gltranslatef(0.375, 0.375, 0);

  glDisable(GL_DEPTH_TEST);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_BLEND);
  glDisable(GL_COLOR_MATERIAL);

  {glShadeModel(GL_SMOOTH);

  glHint(GL_POLYGON_SMOOTH_HINT, GL_FASTEST);
  //glEnable(GL_POLYGON_SMOOTH);
  glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
  glEnable(GL_POINT_SMOOTH);
  glHint(GL_LINE_SMOOTH_HINT, GL_FASTEST);
  glEnable(GL_LINE_SMOOTH);}
end;

 type TPlate = record
      X: Integer;
      Y: Integer;
      Width: Integer;
      DrawPoints: TPointsF;
      DrawPointCount: Integer;
   end;

var
   i: Integer;
   bd: TVector2;
   tmp : Tb2Body;
   points : array[0..3] of TVector2;
   c : Tb2CircleShape;
   bEdge : Tb2edgeShape;
   bEdgePoints : array of TVector2;
   tempFixture : Tb2Fixture;
const
   DefaultPlateWidth = 70;
   DefaultPlateHeight = 15;

begin
  bEdge := Tb2edgeShape.Create;
  //tempFixture := Tb2Shape.Create;
  SetLength(poll_points, 17);
  poll_points[0].SetValue(0,35);
  poll_points[1].SetValue(13,17);
  poll_points[2].SetValue(33,6);
  poll_points[3].SetValue(52,0);
  poll_points[4].SetValue(100,0);
  poll_points[5].SetValue(119,6);
  poll_points[6].SetValue(139,17);
  poll_points[7].SetValue(152,35);
  poll_points[8].SetValue(134,47);
  poll_points[9].SetValue(126,35);
  poll_points[10].SetValue(100,30);
  poll_points[11].SetValue(86,50);
  poll_points[12].SetValue(66,50);
  poll_points[13].SetValue(52,30);
  poll_points[14].SetValue(26,35);
  poll_points[15].SetValue(18,47);
  poll_points[16] := poll_points[0];


	Randomize;

	SDL_Init(SDL_INIT_TIMER);
	fullscreen := false;

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
	
	CreateOGLWindow('Physic', w_width, w_height, 32,fullscreen);
	
	OpenGL_Init();
	InitOpenGL;
	

    bd.SetValue(0, 98.1 );

world := Tb2World.Create( bd);
addRect(w_width div 2,w_height-50+25,w_width,30,false);
addRect(w_width/5,w_height-200,w_width/5,30,false);
tmp := world.GetBodyList;

  addRect(w_width+15,w_height div 2,30,w_height,false);
  addRect(-15,w_height div 2,30,w_height,false);

	repeat
		if PeekMessage(@msg,0,0,0,0) = true then begin
			GetMessage(@msg,0,0,0);
			TranslateMessage(msg);
			DispatchMessage(msg);
		end;

    glClear(GL_COLOR_BUFFER_BIT);
    glLoadIdentity();


    world.Step(1/60, 10, 10);
    while (tmp <> NIL) do begin
      if (tmp.GetFixtureList.GetShape.GetType = Tb2ShapeType.e_polygonShape) then begin
        for i := 0 to 3 do begin
          points[i]:= Tb2PolygonShape(tmp.GetFixtureList.GetShape).m_vertices[i];
        end;
        drawSquare( points, tmp.GetWorldCenter, tmp.GetAngle);
      end;

      if (tmp.GetFixtureList.GetShape.GetType = Tb2ShapeType.e_circleShape) then begin
        c := Tb2CircleShape(tmp.GetFixtureList.GetShape);
        Drawcircle(tmp.GetWorldCenter, c.m_radius, tmp.GetAngle)
      end;
      if (tmp.GetFixtureList.GetShape.GetType = Tb2ShapeType.e_edgeShape) then begin
        tempFixture := tmp.GetFixtureList;
        while ( tempFixture <> NIL) do begin
          bEdge := Tb2edgeShape(tempFixture.GetShape);
          SetLength(bEdgePoints, Length(bEdgePoints)+1);
          bEdgePoints[High(bEdgePoints)] := bEdge.m_vertex1;
          tempFixture := tempFixture.Getnext;
        end;
        tmp.SetTransform(MakeVector(mouse_x,mouse_y), 0);
        
        drawPolyLine(bEdgePoints, mouse_x, mouse_y )
      end;

      tmp := tmp.Getnext;
    end;

   //drawPolyLine(Plate.DrawPoints, mouse_x, mouse_y);

    tmp := world.GetBodyList;
    //DrawLINESTRIP(poll_points, mouse_x, mouse_y);

		//draw_quad(0,0, 100, 100);

		SwapBuffers( dcWindow );
	Until active = false;
	
	SDL_Quit();
end.
