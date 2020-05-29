unit Main;

{$mode objfpc}{$H+}
{$asmMode intel}

interface


uses
  Classes, SysUtils, GL, glu, Windows, glDrawCmds, glxTextRender, ntlm;

type
  MVPmatrix = array[0..15] of single;
  PMVPmatrix = ^MVPmatrix;
  TMsg = function (PMessage:PChar):Cardinal;cdecl;
  PTMsg = ^TMsg;
  PPChar = ^PChar;
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



  JValue:PSingle;
  HSpeed:Single;
  XSpeed:PSingle;
  YSpeed:PSingle;
  XCam:PSingle;
  XPos:PSingle;
  YPos:PSingle;
  ZPos:PSingle;
  MapString:PChar;
  FinalMapString:AnsiString;
  InAir:PBYTE;
  i: cardinal;
  hwBase:Cardinal;
  hwBaseAndBaseOffset:PCardinal;

  MaxSpeed:PDWORD=PDWORD($10408);
begin
  { -------------------------- Counter --------------------------- }
  { -> Used to see if it's running at all as well as maybe  timing }
  nothing := PDWORD($10300);
  Inc(nothing^);

  { ------------------ Custom Graphics Object -------------------- }
  glx := TglDrawCmds.Create;


  { -------------------- hw.dll Base Pointer --------------------- }
  { -> read player values                                          }
  hwBase:=GetModuleHandle('hw.dll');
  hwBaseAndBaseOffset:=PCardinal(hwBase + $7F5F84);


  { --------------------- Check for nullptr ---------------------- }
  { -> Check if player values can be read at all                   }
  {    aka. check to see if the player is ingame to prevent crash  }
  glEnterBrendanMode;
  if hwBaseAndBaseOffset^ <> 0 then
  begin
    { -------------------- set Pointers -------------------- }
    InAir:=PBYTE( hwBase + $122DF54);
    JValue:=PSingle(hwBaseAndBaseOffset^ + $A8);
    XSpeed:=PSingle(hwBaseAndBaseOffset^ + $A0);
    YSpeed:=PSingle(hwBaseAndBaseOffset^ + $A4);
    XCam:=PSingle(hwBaseAndBaseOffset^ + $D4);
    XPos:=PSingle(hwBaseAndBaseOffset^ + $88);
    YPos:=PSingle(hwBaseAndBaseOffset^ + $8C);
    ZPos:=PSingle(hwBaseAndBaseOffset^ + $90);
    MapString:=PChar(hwBase + $807DB0);



    { ----------------------- Auto Bhop ------------------------ }
    if (GetAsyncKeyState(VK_SPACE) <> 0) and (JValue^ <= 0) and (InAir^=1) then
    begin
      JValue^:=237.0;
    end;



    { ---------------- Vertical Speed Indicator ---------------- }
    { -> Draw vertical speed indicator as a thick red line at    }
    {    the bottom of the screen. centered and horizontally     }
    {    mirrored                                                }
    glLineWidth(5);
    glPointSize(20.0);
    glColor3f(1, 0, 0); //Red
    glx.DrawLine(((glx.ViewWidth) / 2) - (JValue^/2), glx.ViewHeight-5, (glx.ViewWidth /2) + (JValue^/2), glx.ViewHeight-5);




    { --------------- Horizontal Speed Indicator --------------- }
    { -> Draw horizontal speed indicator as a thick green line   }
    {    at the bottom of the screen above the vertical speed    }
    {    indicator. centered and and horizontally mirrored       }
    { -> LineWidth taken from previous call                      }
    HSpeed:=sqrt((XSpeed^*XSpeed^)+(YSpeed^*YSpeed^));
    glColor3f(0, 1, 0); //Green
    glx.DrawLine(((glx.ViewWidth) / 2) - (HSpeed)/2, glx.ViewHeight-10, (glx.ViewWidth /2) + (HSpeed/2), glx.ViewHeight-10);


    { ----------------------- Speedometer ---------------------- }
    { -> renders current speed in u/s to screen using the        }
    {    customfunction in glxTextRender.                        }
    { -> Positioned above both lines                             }
    glColor3f(0.8,0.8,0.8);
    glxDrawNumber((glx.ViewWidth/2),100,round(HSpeed),4);



    { ------------------------- MaxSpeed ----------------------- }
    { -> render number to screen using the customfunction in     }
    {    glxTextRender. smaller font                             }
    { -> Positioned below the speedometer                        }
    if(HSpeed > MaxSpeed^) then
              MaxSpeed^:=round(HSpeed);
    glxDrawNumber((glx.ViewWidth/2), 60, MaxSpeed^, 3);



    { ------------------------- "Speed" ------------------------ }
    glxDrawString((glx.ViewWidth/2),140,'Speed',3,False);



    { ---------------------- Top Down Angle --------------------- }
    { -> Graphical indicator for current horizontal viewing angle }
    glColor3f(1,0,0);
    glLineWidth(1);
    glx.DrawCircle(100,(glx.ViewHeight) - 100,50,32);
    glColor3f(1,1,1);
    glx.DrawLine(100,(glx.ViewHeight) - 100,100+cos(-XCam^/57.2957795131)*50,(glx.ViewHeight-100)+sin(-XCam^/57.2957795131)*50);



    { ---------------------- World Position --------------------- }
    { -> Display current positon                                  }
    glColor3f(0.8,0.8,0.8);
    glxDrawString(180,150+50,'X:',2,True);
    glxDrawString(180,125+50,'Y:',2,True);
    glxDrawString(180,100+50,'Z:',2,True);
    glxDrawNumber(250,151+50,round(XPos^),2);
    glxDrawNumber(250,126+50,round(YPos^),2);
    glxDrawNumber(250,101+50,round(ZPos^),2);



    { ------------------------- Map String ---------------------- }
    { -> Displays current map's name                              }
    i:=1;
    FinalMapString:='';
    while(MapString[i-1] <> Char(0)) do
    begin
      SetLength(FinalMapString,i);
      FinalMapString[i]:=MapString[i-1];
      Inc(i)
    end;
    glxDrawString(180,75+50,AnsiString('Map: ' + (FinalMapString)),2,True);


  end;

  glLeaveBrendanMode;
  glDisable(GL_DEPTH_TEST);

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
