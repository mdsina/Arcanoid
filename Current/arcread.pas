unit arcread;

interface

uses wincrt;
function textfileread(fn: string): pchar;
procedure ZMem (var obj; sz: dword);

implementation
function textfileread(fn: string): pchar;
var
  f: file;
  r, rd: int64;
  content: pchar;
begin
  textfileread := nil;
  if fn = '' then exit;
  content := nil;
  assign(f, fn); reset(f, 1);
  r := filesize(f);
  if r > 0 then begin
    getmem(content, r+1);
    blockread(f, content^, r, rd);
    if rd = r then (content + r)^ := #0;
  end;
  close(f);
  if rd <> r then
    freemem(content)
  else
    textfileread := content;
end;

procedure   ZMem (var obj; sz: dword);
begin
 fillchar (obj, sz, 0);
end;
end.
