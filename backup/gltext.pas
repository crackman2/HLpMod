unit glText;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, gl, glu;

type
  TColor = array[0..2] of char;

  TVec3 = record
    x: single;
    y: single;
    z: single;
  end;

  { TglText }

  TglText = class
  public
    bBuilt: boolean;
    base: cardinal;
    objHDC: HDC;
    Height: integer;
    Width: integer;

    constructor Create;
    procedure Build(cHeight: integer); stdcall;
    procedure Print(x: single; y: single; Text: PChar); stdcall;
    function centerText(x: single; y: single; cWidth: single;
      cHeight: single; textwidth: single; textheight: single): TVec3; stdcall;
    function centerText(x: single; cWidth: single; textwidth: single): single; stdcall;



  end;

implementation

constructor TglText.Create;
begin
  bBuilt := False;
  objHDC := HANDLE(nil);
end;

procedure TglText.Build(cHeight: integer); stdcall;
var
  Font: HFONT;
  OldFont: HFONT;
begin
  objHDC := wglGetCurrentDC();
  base := glGenLists(96);
  Font := CreateFontA(-cHeight, 0, 0, 0, FW_MEDIUM, 0, 0, 0, ANSI_CHARSET,
    OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, FF_DONTCARE or
    DEFAULT_PITCH, 'Consolas');
  OldFont := HFONT(SelectObject(objhdc, Font));
  wglUseFontBitmaps(objhdc, 32, 96, base);
  SelectObject(objhdc, OldFont);
  DeleteObject(Font);

  bBuilt := True;

end;

procedure TglText.Print(x: single; y: single; Text: PChar); stdcall;
begin
  glColor3ub($FF, 0, 0);
  glRasterPos2f(x, y);

  glPushAttrib(GL_LIST_BIT);
  glListBase(base - 32);
  glCallLists(Length(Text), GL_UNSIGNED_BYTE, Text);
  glPopAttrib();

end;

function TglText.centerText(x: single; y: single; cWidth: single;
  cHeight: single; textwidth: single; textheight: single): TVec3; stdcall;
var
  txt: TVec3;
begin
  txt.x := x + (cWidth - textwidth) / 2;
  txt.y := y + textheight;
  Result := txt;
end;

function TglText.centerText(x: single; cWidth: single; textwidth: single): single;
  stdcall;
begin
  Result := 0;
  if (cWidth > textwidth) then
    Result := x + ((cWidth - textwidth) / 2)
  else
    Result := x - ((textwidth - cwidth) / 2);
end;


end.
