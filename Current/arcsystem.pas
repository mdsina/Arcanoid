unit arcsystem;

interface

uses windows, commdlg, arcread, arctypes, regexpr;

function MySaveFileDialog():FileRecord;
function FindExtention(var s:string): string;
procedure RemoveInvalid(what:string; var where: string);
function FindExtention2(s:string): string;
procedure qSortKernings(var ar: array of BMKerningPairs; low, high: longint);
function GetFilenameFromPath(s:string): string;

implementation

procedure qSortKernings(var ar: array of BMKerningPairs; low, high: longint);
var i, j: longint;
    m, wsp, wsp2: word; wsp3: Shortint;
begin
  i:=low;
  j:=high;
  m:=ar[(i+j) div 2].first;
  repeat
    while ar[i].first < m do Inc(i);
    while ar[j].first > m do Dec(j);
    if i<=j then begin  //здесь можно юзать любой swap-метод, метод xor-ом кстати ничуть не быстрее
      wsp := ar[i].first;
      wsp2 := ar[i].second;
      wsp3 := ar[i].amount;

      ar[i].first := ar[j].first;
      ar[i].second := ar[j].second;
      ar[i].amount := ar[j].amount;

      ar[j].first := wsp;
      ar[j].second := wsp2;
      ar[j].amount := wsp3;
      Inc(i); Dec(j);
    end;
  until i>j;
  if low<j then qSortKernings(ar, low, j);
  if i<high then qSortKernings(ar, i, high);
end;

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
	r.Expression := '(\.[^/\\]*$)';
	if r.Exec(1) then begin
		result1:=r.Match[1];
		if result1 <> '' then begin
            RemoveInvalid(result1, s);
            FindExtention:= result1;
        end else FindExtention:= '';
	end;

    writeln(result1);
end;

function GetFilenameFromPath(s:string): string;
var r: TRegExpr; result1 : string;
begin
  r := TRegExpr.Create;
  r.InputString := s;
  r.Expression := '([^/\\]*$)';
  if r.Exec then begin
    result1:=r.Match[1];
    if result1 <> '' then begin
            RemoveInvalid(FindExtention2(result1), result1);
            GetFilenameFromPath:= result1;
        end else GetFilenameFromPath:= '';
  end;

    writeln(result1);
end;

function FindExtention2(s:string): string;
var r: TRegExpr; result1 : string;
begin
    r := TRegExpr.Create;
    r.InputString := s;
    r.Expression := '(\.[^/\\]*$)';
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

