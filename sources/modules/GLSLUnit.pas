unit GLSLUnit;

interface

uses
  OpenGL, DotWindow, DotUtils, DotMath, GL, GLu, GLext, DotShaders, Windows;
type
  TGLSL = class
  private
    shaders : array of Cardinal;
  public
    po      : Cardinal;  
    constructor Create;
    procedure LoadShader(f:String;const stype:Cardinal);
    function Compile:boolean;
    procedure Start;
    procedure Finish;
    function GetUniform(name:String):Cardinal;
    function GetAttrib(name:String):Cardinal;
    procedure SetUniform(uniform:Cardinal;value0:Integer);overload;
    procedure SetUniform(uniform:Cardinal;value0:Single);overload;
    procedure SetUniform(uniform:Cardinal;value0:Single;value1:Single);overload;
    procedure SetUniform(uniform:Cardinal;value0:Single;value1:Single;value2:Single);overload; 
    procedure SetUniform(uniform:Cardinal;value0:Single;value1:Single;value2:Single;value3:Sin gle);overload;

    procedure SetUniform(name:String;value0:Integer);overload;
    procedure SetUniform(name:String;value0:Single);overload;
    procedure SetUniform(name:String;value0:Single;value1:Single);overload;
    procedure SetUniform(name:String;value0:Single;value1:Single;value2:Single);overload;
    procedure SetUniform(name:String;value0:Single;value1:Single;value2:Single;value3:Single); overload;

    procedure SetAttrib(attrib:Cardinal;value0:Single);overload;
    procedure SetAttrib(attrib:Cardinal;value0:Single;value1:Single);overload;
    procedure SetAttrib(attrib:Cardinal;value0:Single;value1:Single;value2:Single);overload;
    procedure SetAttrib(attrib:Cardinal;value0:Single;value1:Single;value2:Single;value3:Singl e);overload;
    procedure Free;
  end;

implementation

{ TGLSL }
Const
 WND_GLSL = 'GLSL 1.00 :';

function TGLSL.Compile: boolean;
var
  i,status : Integer;
  log      : String;
begin
 po:=glCreateProgramObjectARB;
 for i:=Low(shaders) to High(shaders) do
  glAttachObjectARB(po, shaders[i]);
 glLinkProgramARB(po);
 glGetObjectParameterivARB(po, GL_OBJECT_LINK_STATUS_ARB, @status);
 log:=dotGLSLGetInfoLog(po);
 Result:=true;

 if status <> 1 then
 begin
   Result:=false;
   glDeleteObjectARB(po);
   MessageBox(0, PChar('Error while compiling'#13+log), WND_GLSL, MB_OK or MB_ICONERROR);
   exit;
 end;
end;

procedure TGLSL.Finish;
begin
 glUseProgramObjectARB(0);
end;

function TGLSL.GetUniform(name: String): Cardinal;
begin
 Result:=glGetUniformLocationARB(po,PGLcharARB(name));
end;

function TGLSL.GetAttrib(name: String): Cardinal;
begin
 Result:=glGetAttribLocationARB(po,PGLcharARB(name));
end;

procedure TGLSL.LoadShader(f: String; const stype: Cardinal);
begin
 SetLength(shaders,Length(shaders)+1);
 shaders[High(shaders)]:=dotGLSLLoadShaderFromFile(f,stype);
end;

procedure TGLSL.Start;
begin
 glUseProgramObjectARB(po);
end;

procedure TGLSL.SetUniform(uniform: Cardinal; value0: Single);
begin
 glUniform1fARB(uniform, value0);
end;

procedure TGLSL.SetUniform(uniform: Cardinal; value0: Integer);
begin
 glUniform1iARB(uniform, value0);
end;

procedure TGLSL.SetUniform(uniform: Cardinal; value0, value1: Single);
begin
 glUniform2fARB(uniform, value0,value1);
end;

procedure TGLSL.SetUniform(uniform: Cardinal; value0, value1, value2,
  value3: Single);
begin
 glUniform4fARB(uniform, value0,value1,value2,value3);
end;

procedure TGLSL.SetUniform(uniform: Cardinal; value0, value1,
  value2: Single);
begin
 glUniform3fARB(uniform, value0,value1,value2);
end;

procedure TGLSL.Free;
begin
 glDeleteObjectARB(po);
end;

procedure TGLSL.SetAttrib(attrib: Cardinal; value0: Single);
begin
 glVertexAttrib1fARB(attrib, value0);
end;

procedure TGLSL.SetAttrib(attrib: Cardinal; value0, value1: Single);
begin
 glVertexAttrib2fARB(attrib, value0,value1);
end;

procedure TGLSL.SetAttrib(attrib: Cardinal; value0, value1, value2,
  value3: Single);
begin
 glVertexAttrib4fARB(attrib, value0,value1,value2,value3);
end;

procedure TGLSL.SetAttrib(attrib: Cardinal; value0, value1,
  value2: Single);
begin
 glVertexAttrib3fARB(attrib, value0,value1,value2);
end;

constructor TGLSL.Create;
begin
 inherited;
end;

procedure TGLSL.SetUniform(name: String; value0: Single);
begin
 SetUniform(GetUniform(name),value0);
end;

procedure TGLSL.SetUniform(name: String; value0: Integer);
begin
 SetUniform(GetUniform(name),value0);
end;

procedure TGLSL.SetUniform(name: String; value0, value1: Single);
begin
 SetUniform(GetUniform(name),value0,value1);
end;

procedure TGLSL.SetUniform(name: String; value0, value1, value2,
  value3: Single);
begin
 SetUniform(GetUniform(name),value0,value1,value2,value3);
end;

procedure TGLSL.SetUniform(name: String; value0, value1, value2: Single);
begin
 SetUniform(GetUniform(name),value0,value1,value2);
end;

end.