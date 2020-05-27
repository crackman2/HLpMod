unit Main;

{$mode objfpc}{$H+}
{$asmMode intel}

interface


uses
  Classes, SysUtils, GL, glu, Windows, glDrawCmds, glxTextRender;

type
  MVPmatrix = array[0..15] of single;
  PMVPmatrix = ^MVPmatrix;
  TMsg = function (PMessage:PChar):Cardinal;cdecl;
  PTMsg = ^TMsg;
  RVec2 = record
    x: single;
    y: single;
    z: single;
  end;

  RVec3 = record
    x: single;
    y: single;
    z: single;
  end;

  RVec4 = record
    x: single;
    y: single;
    z: single;
    w: single;
  end;


procedure MainBit(); stdcall;
procedure glEnter2D; stdcall;
procedure glLeave2D; stdcall;
function glGetViewportWidth: integer; stdcall;
function glGetViewportHeight: integer; stdcall;
procedure glEnterBrendanMode; stdcall;
procedure glLeaveBrendanMode; stdcall;
function glW2S(ViewMatrx: MVPmatrix; plypos: RVec3): RVec2; stdcall;




implementation

procedure MainBit(); stdcall;
var
  nothing: PDWORD;

  glx: TglDrawCmds;

  mvp: array[0..15] of GLfloat;

  MsgFunc:PTMsg;
  WhatsTheOutPut:Cardinal;
  JValue:PSingle;
  HSpeed:Single;
  XSpeed:PSingle;
  YSpeed:PSingle;
  InAir:PBYTE;
  i: cardinal;
begin
  nothing := PDWORD($10300);
  Inc(nothing^);
  glx := TglDrawCmds.Create;

  glEnterBrendanMode;







  {
  if GetAsyncKeyState(VK_P) <> 0 then
  begin
     while GetAsyncKeyState(VK_P) <> 0 do
     begin

     end;

     MsgFunc:= GetProcAddress(GetModuleHandle('tier0.dll'),'Msg');
     MsgFunc^(PChar('Hello' + LineEnding));
     MessageBox(0,'Done calling','Yep',0);
  end;
  }

  //for i:= 0 to 15 do
  // begin
  //mvp[i] = PSingle(GetModuleHandle('hw.dll') + $7C91FC)^;
  //end;
  //end;


  JValue:=PSingle($10333C24);
  InAir:=PBYTE(GetModuleHandle('hw.dll') + $122DF54);
  if (GetAsyncKeyState(VK_SPACE) <> 0) and (JValue^ <= 0) and (InAir^=1) then
  begin

    JValue^:=237.0;
    end;

  glLineWidth(5);
  glPointSize(20.0);
  glColor3f(1, 0, 0);
  glx.DrawLine(((glx.ViewWidth) / 2) - (JValue^/2), glx.ViewHeight-5, (glx.ViewWidth /2) + (JValue^/2), glx.ViewHeight-5);


  XSpeed:=PSingle($10333C1C);
  YSpeed:=PSingle($10333C20);
  HSpeed:=sqrt((XSpeed^*XSpeed^)+(YSpeed^*YSpeed^));

  glColor3f(0, 1, 0);
  glx.DrawLine(((glx.ViewWidth) / 2) - (HSpeed)/2, glx.ViewHeight-10, (glx.ViewWidth /2) + (HSpeed/2), glx.ViewHeight-10);

  glxDrawNumber((glx.ViewWidth/2) - 4*4,100,round(HSpeed),4);


  glLeaveBrendanMode;

end;




procedure glEnter2D; stdcall;
begin
  glMatrixMode(GL_PROJECTION);
  glPushMatrix;
  glLoadIdentity;
  gluOrtho2D(0, glGetViewportWidth, 0, glGetViewportHeight);

  glMatrixMode(GL_MODELVIEW);
  glPushMatrix;
  glLoadIdentity;

  glDisable(GL_DEPTH_TEST);
end;


procedure glLeave2D; stdcall;
begin
  glMatrixMode(GL_PROJECTION);
  glPopMatrix;
  glMatrixMode(GL_MODELVIEW);
  glPopMatrix;

  glEnable(GL_DEPTH_TEST);
end;

function glGetViewportWidth: integer; stdcall;
var
  Rect: array[0..3] of integer;
begin
  glGetIntegerv(GL_VIEWPORT, @Rect);
  Result := Rect[2] - Rect[0];
end;

function glGetViewportHeight: integer; stdcall;
var
  Rect: array[0..3] of integer;
begin
  glGetIntegerv(GL_VIEWPORT, @Rect);
  Result := Rect[3] - Rect[1];
end;


procedure glEnterBrendanMode; stdcall;
begin
  glDisable(GL_DEPTH_TEST);
  glDisable(GL_CULL_FACE);
  glDisable(GL_TEXTURE_2D);
  glDisable(GL_LIGHTING);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(-100, 100, -100, 100);

  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glFlush();
end;

procedure glLeaveBrendanMode; stdcall;
begin
  glEnable(GL_TEXTURE_2D);
end;

function glW2S(ViewMatrx: MVPmatrix; plypos: RVec3): RVec2; stdcall;
var
  Clip: RVec4;
  NDC: RVec3;
  viewp: array[0..3] of GLint;
  depthr: array[0..1] of GLfloat;
  pycord: RVec2;
begin

  Clip.x := plypos.x * ViewMatrx[0] + plypos.y * ViewMatrx[4] + plypos.z *
    ViewMatrx[8] + ViewMatrx[12];
  Clip.y := plypos.x * ViewMatrx[1] + plypos.y * ViewMatrx[5] + plypos.z *
    ViewMatrx[9] + ViewMatrx[13];
  Clip.z := plypos.x * ViewMatrx[2] + plypos.y * ViewMatrx[6] + plypos.z *
    ViewMatrx[10] + ViewMatrx[14];
  Clip.w := plypos.x * ViewMatrx[3] + plypos.y * ViewMatrx[7] + plypos.z *
    ViewMatrx[11] + ViewMatrx[15];

  NDC.x := Clip.x / Clip.w;
  NDC.y := Clip.y / Clip.w;
  NDC.z := Clip.z / Clip.w;

  glGetIntegerv(GL_VIEWPORT, viewp);
  glGetFloatv(GL_DEPTH_RANGE, depthr);

  pycord.x := (viewp[2] / 2 * NDC.x) + (NDC.x + viewp[2] / 2);
  pycord.y := (viewp[3] / 2 * NDC.x) + (NDC.x + viewp[3] / 2);

  Result := pycord;
end;

exports
  MainBit;

end.
