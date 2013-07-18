 {$define debug}
{$ifdef debug}
	{$APPTYPE CONSOLE}
{$else}
	{$APPTYPE CONSOLE}
{$endif}

{$COPERATORS ON}

uses  windows, dglopengl, sysutils, shlobj, sdl, sdl_mixer, png, arcimage, arcconst, arctextures,
  libcurl, crt, arctypes, arcread, arcphys, arcdraw, commdlg, arcvariables, arcsystem, arcgui, LConvEncoding ;

Procedure TPrintText(text2:integer; t1, t2,TLength: real; twidth,theight:real);
var k:integer; text:string;
begin
  mSymbol[1].x:=t1;
  mSymbol[1].y:=t2;
  Str(text2, text);
  k:=length(text);
  for i:=1 to k do begin
    Tex.pSymbol:=Tex.tpSymbol[StrToInt(text[i])+1];
    mSymbol[i].width:=twidth;
    mSymbol[i].height:=theight;

    if i>1 then begin
      mSymbol[i].x:=mSymbol[i-1].x+mSymbol[i-1].width+TLength;
      mSymbol[i].y:=mSymbol[i-1].y;
    end;
    glBindTexture(GL_TEXTURE_2D, Tex.pSymbol);
    draw_quad( mSymbol[i].x, mSymbol[i].y, mSymbol[i].width, mSymbol[i].height );
  end;
end;

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

procedure OnMouseDown(x, y:integer);
begin
	if (x>kx) and (x<kx+30) and (y>ky) and (y<ky+30)
		then checked[st]:= not checked[st];
		
	OnMenu;
	OnGame;
	OnManual;
	OnEditor(x,y);
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
	      if wParam = VK_ESCAPE then pexit:=not pexit;//SendMessage(hWindow,wm_destroy,0,0);
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

procedure handle_input;
var
	dir_x, dir_y:real;
	i:integer;
begin
	if Getfocus()=hWindow then
	begin

		poll.x:=mouse_x-poll.width/2;
		if poll.x<=0.037*width	then poll.x:=0.037*width;
		if (poll.x+poll.width)>=0.72*width	then poll.x:=0.72*width-poll.width;
		
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
			if bricks[i].lives>0 then
			begin
				if CollideRectangle_p(player, bricks[i].box, width, height)
				then begin
					score:=score+10;
					
					if CollideTop_p(bricks[i].box, player, player_old_y, height)
					then if collision=true then hy:=-3;

					if  CollideBottom_p(bricks[i].box, player, player_old_y, height)
					then if collision=true then hy:=3;

					if CollideLeft_p(bricks[i].box, player, player_old_x, width) or
					CollideRight_p(bricks[i].box, player, player_old_x, width)
					then if collision=true then hx:=-hx;
					
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

		player_old_x:=player.x;
		player_old_y:=player.y;
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
	
	{bkg_scrolling;

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
	draw_quad_p(x05, y05, _width, _height,width, height);}

	//DrawText(baseFont, 'Hello http://www.gamedev.ru/', 28, width div 3, height div 2 + 100, true, true, 500, 600);
	DrawText(tnrFont, 'Съешь еще этих мягких французских яблок да выпей йаду!'#13'Съешь еще этих мягких французских яблок да выпей йаду!Съешь еще этих мягких французских яблок да выпей йаду!', 40, width div 3, height div 4 -50, true, true, 500, 600);;
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
	i : integer;
begin
	bkg_scrolling;
	if game=true then
	begin
		glBindTexture(GL_TEXTURE_2D, Tex.tbkg);
		draw_quad(0,0,width,height);
		glBindTexture(GL_TEXTURE_2D, Tex.Ball);
		draw_quad(player.x, player.y, player.width, player.height);
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
				then 	glBindTexture(GL_TEXTURE_2D, Tex.wAlive[round(bricks[i].Ttype)])
				else if (bricks[i].lives = 1) and  (bricks[i].typei=1)
					then begin
						Animations[i].Update(dt);
						Animations[i].Draw_p(bricks[i].box, width, height);
					end	else if bricks[i].lives = 2
						then  glBindTexture(GL_TEXTURE_2D, Tex.wLive[round(bricks[i].Ttype)]);

			if bricks[i].typei=3 then glBindTexture(GL_TEXTURE_2D, Tex.Magic);
			//draw_quad_p(bricks[i].box,width, height);
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

	if game=true then
	begin
		win(bricks_count);
		fail(counter);
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
  l:=3;  lp:=4;  hx:=l;  hy:=l;  spacecon:=false;
  _x1:=0;  _x2:=1;  _x3:=1;  _x4:=0;

  _x01:=0;  _x02:=1;  _x03:=1;  _x04:=0;
  player.width:=20;  player.height:=20;
  player.x:=(width - player.width) / 2;  player.y:=(height / 2)-player.height+9;
  bk:=true;  bk2:=true;
  player_old_x:=player.x;  player_old_y:=player.y;
  snapStepx:=54;  snapStepy:=30;
  poll.width:=100;  poll.height:=20;
  poll.x:=(width-poll.width) /2;  poll.y:=((height+poll.height)/2)+(height /3);
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


procedure renderscene;
var F:Text; filebool: FileRecord; Fb: file of Brick;
begin
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

							if bricks[pi].lives>0 then begin
								Animations[pi]:=PAnimation.Create(30, random(1000)+30);
								Animations[pi].AddFrame(animtexture, 61, 3294, 30);
								Animations[pi].Start();
								bricks_count:=bricks_count+1;
							end;

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
				filebool:=MySaveFileDialog();
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
var texture_id, fbo_id: gluint;
	ProgramObject        : GLhandle;
	VertexShaderObject   : GLhandle;
	FragmentShaderObject : GLhandle;
	fs2, vs2: pchar;


procedure FBORender;
begin
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, fbo_Id);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glEnable(GL_MULTISAMPLE);

  renderscene;

  glDisable(GL_MULTISAMPLE);
  glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0);

  glUseProgram(ProgramObject);
  glBindTexture(GL_TEXTURE_2D, texture_Id);
  glGenerateMipmapEXT(GL_TEXTURE_2D);
  draw_quad(0,0,width,height);
  glUseProgram(0);
end;


begin
	Randomize;

	SDL_Init(SDL_INIT_TIMER and SDL_INIT_AUDIO);

	if MIX_OPENAUDIO(AUDIO_FREQUENCY, AUDIO_FORMAT, AUDIO_CHANNELS,	AUDIO_CHUNKSIZE)<>0
		then HALT;
		
	music:=MIX_LOADMUS('\Data\Levels\main.mp3');
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
	
	InitFBO(width, height, fbo_Id, texture_Id);
	//////////////////////////////////////////////////////////////////////////////////
	ProgramObject        := glCreateProgram();
	VertexShaderObject   := glCreateShader(GL_VERTEX_SHADER);
	FragmentShaderObject := glCreateShader(GL_FRAGMENT_SHADER);	

	fs2:=textfileread('Data\Shaders\Bloom\g.fs');
	vs2:=textfileread('Data\Shaders\Bloom\g.vs');

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
	animtexture:=LoadBMP('Data\Images\sprite.bmp');

	QueryPerformanceFrequency(TimerFreq);
  	TimerFreq:=TimerFreq div 1000;
  	QueryPerformanceCounter(TimerCount);
  	LastTime:=TimerCount div TimerFreq;

  	baseFont := BMFont.Create('Data\Fonts\neon.fnt');
  	ilLoadFile( TGA_FILE, 'Data\Fonts\neon_0.tga', font_texture );
  	baseFont.SetTexturePointer( font_texture );

  	baseFont2 := BMFont.Create('Data\Fonts\harlow.fnt');
  	ilLoadFile( TGA_FILE, 'Data\Fonts\harlow_0.tga', font_texture_ubfg );
  	baseFont2.SetTexturePointer( font_texture_ubfg );

  	tnrFont := BMFont.Create('Data\Fonts\tnr.fnt');
  	ilLoadFile( TGA_FILE, 'Data\Fonts\tnr_0.tga', font_texture_tnr );
  	tnrFont.SetTexturePointer( font_texture_tnr );

	repeat
		QueryPerformanceCounter(TimerCount);
    	dt:=(TimerCount div TimerFreq)-LastTime;
    	LastTime:=TimerCount div TimerFreq;

		frame_time:=(TimerCount/perf_freq-perf_last/perf_freq);
		perf_last:=TimerCount;
		fps:= 1/frame_time;
		//writeln(fps:5:5);
		FBORender;
		//writeln(k_name);	
		SwapBuffers( dcWindow );
	Until active = false;
	
	MIX_HALTMUSIC;
	MIX_HALTCHANNEL(soundchannel);
	MIX_FREEMUSIC(music);
	MIX_FREECHUNK(sound);

	Mix_CloseAudio;
	FindClose(Fs);
	KilloglWindow();
	// Mix_CloseAudio();

	FreeFBO(texture_Id, fbo_Id);
	SDL_Quit();
end.
