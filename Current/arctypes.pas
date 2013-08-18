unit arctypes;

interface

uses gl, glu, windows;

Type
  ArcStringFuncType = function : string;
  ArcBoolFuncType = function (Window: HWnd; AMessage, WParam, LParam: Longint): Longint; stdcall;

  DynArrayType = array of word;

  ArcTextureType = record
    Texture : GLUInt;
    TextureName : WideString;
  end;

  DynArrayTextureType = array of ArcTextureType;

  BMGlyph = record
    id, x, y, width, height,  xadvance : word;
    xoffset, yoffset : integer;
    fisrt_kerning_id : word;
    end_kerning_id : word;
  end;

  BMKerningPairs = record
    first, second: word;
    amount : Shortint;
  end;

  float3 = record
	x,y,z: real;
  end;
  float2 = record
	x,y: real;
  end;
  AnimationType = record
  	texture: glUint; frames, width, height, FrameTime: integer;	a_name: string; stopped:boolean;
  end;
  SymbolTType = record
	  x,y,width,height : real;
  end;
  FileRecord = record
	filetype: integer;	filename_with_path: string;	bool: boolean;
  end;
  fsqVertex = record
	 position: float3;	 texcoord: float2;
  end;

  Rectangle   = record
	  x,y,width,height : real;
  end;

  pTex 		  = record
	  bkg		: array[1..6] of  gluint;
	  wLive		: array[1..3] of  gluint;
	  wAlive	: array[1..3] of  gluint;	
	  TBonus	: array[1..7] of  gluint;
	  tpSymbol	: array[1..10] of glUint;
	  gMenu		: array[1..3] of  glUint;
	  gEdit		: array[1..2] of  glUint;
	  MenuItemsf: array[1..5] of  glUint;
	  MenuItemsi: array[1..5] of  gluint;
	  mHelp 	: array[1..3] of  glUint;
	  wf		: array[1..2] of  glUint;
	  mhelph	: array[1..3] of  glUint;
	  gHelp		: array[1..2] of  gluint;
	  back		: array[1..2] of  glUint;
	
	  CheckBox, CheckBoxd, Next, home, kMenu,  return, trepeat, mBkg, tbkg, pSymbol, Poll,  Ball, Magic, iLive :  glUint;
 end;

  bgr 		= record
	  x, x1, x2	: real;
  end;

  Brick 	= record
	  box 	: Rectangle; lives,  typei, Ttype, Bonus : real;	  TBool : Boolean;
  end;
  implementation
end.
