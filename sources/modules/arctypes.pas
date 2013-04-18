unit arctypes;

interface

uses gl, glu;

Type
  float3 = record
	x: real;
	y: real;
	z: real;
  end;
  float2 = record
	x: real;
	y: real;
  end;
  SymbolTType = record
	  x		 : real;
	  y		 : real;
	  width	 : real;
	  height : real;
  end;
  
  fsqVertex = record
	 position: float3;
	 texcoord: float2;
  end;

  Rectangle   = record
	  x		 : real;
	  y		 : real;
	  width  : real;
	  height : real;
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
	  
	  CheckBox, CheckBoxd  	   :  gluint;
	  Next, home, kMenu    	   :  glUint;
	  return, trepeat, mBkg	   :  glUint;
	  tbkg, pSymbol, Poll      :  glUint;
	  Ball, Magic, iLive       :  glUint;
 end;

  bgr 		= record
	  x		: real;
	  x1	: real;
	  x2	: real;
  end;

  Brick 	= record
	  box 	: Rectangle;
	  lives : real;
	  typei : real;
	  Ttype : real;
	  Bonus : real;
	  TBool : Boolean;
  end;
  implementation
end.