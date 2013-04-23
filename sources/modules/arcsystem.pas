unit arcsystem;

interface

uses windows, commdlg, arcread, arctypes, regexpr;

function MySaveFileDialog():FileRecord;
function FindExtention(var s:string): string;
procedure RemoveInvalid(what:string; var where: string);
function FindExtention2(s:string): string;

implementation
procedure RemoveInvalid(what:string; var where: string);
var
  tstr: string;
begin
  tstr:=where;
  while pos(what, tstr)>0 do
    tstr:=copy(tstr,1,pos(what,tstr)-1) + copy(tstr,pos(what,tstr)+length(tstr),length(tstr));
  where:=tstr;
end;

function FindExtention(var s:string): string;
var r: TRegExpr; result1 : string;
begin
	r := TRegExpr.Create;
	r.InputString := s;
	r.Expression := '(\.\.*.*)';
	if r.Exec(1) then begin
		result1:=r.Match[1];
		if result1 <> '' then begin
            RemoveInvalid(result1, s);
            FindExtention:= result1;
        end else FindExtention:= '';
	end;

    writeln(result1);
end;

function FindExtention2(s:string): string;
var r: TRegExpr; result1 : string;
begin
    r := TRegExpr.Create;
    r.InputString := s;
    r.Expression := '(\.\.*.*)';
    if r.Exec(1) then begin
        result1:=r.Match[1];
        if result1 <> '' then begin
            FindExtention2:= result1;
        end else FindExtention2:= '';
    end;

    writeln(result1);
end;

function MySaveFileDialog():FileRecord;
var s: string;
    fn: array [1..256] of char;
    ofn: tagOFN;
begin
 s := ParamStr (1);
 if s = '' then
  begin
   ZMem (ofn, sizeof (ofn)); // fill zerro
   ofn.lStructSize := sizeof (ofn);
   ofn.hInstance := hInstance;
   ofn.lpstrFilter := 'Binary File(*.lvl)'#0'*.lvl'#0'Text File(*.txt)'#0'*.txt'#0'All files(*.*)'#0'*.*#0#0';
   ofn.lpstrInitialDir := PChar ('Data\Levels');
   ofn.lpstrTitle := 'Save file level';
   ofn.Flags := OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST;
   ofn.lpstrFile := @fn;
   ofn.nMaxFile := 256;
   if GetSaveFileName (@ofn)=true then  begin
		MySaveFileDialog.bool:=true;
		MySaveFileDialog.filename_with_path:=ofn.lpstrFile;
		MySaveFileDialog.filetype:=ofn.nFilterIndex;
		
		FindExtention( MySaveFileDialog.filename_with_path );
		
		case ofn.nFilterIndex of
			1: MySaveFileDialog.filename_with_path+='.lvl';
			2: MySaveFileDialog.filename_with_path+='.txt';
		end;
   end;

   s := ofn.lpstrFile;

  end;
end;
end.

