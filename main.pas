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
procedure glEnter2DDrawingMode; stdcall;
procedure glLeave2DDrawingMode; stdcall;
function glW2S(ViewMatrx: MVPmatrix; plypos: RVec3): RVec2; stdcall;
procedure DrawKeyPresses(hwBase:DWORD;glx:PTglDrawCmds);stdcall;


implementation

procedure MainBit(); stdcall;
var
  nothing: PDWORD;

  glx: TglDrawCmds; //Contains Drawing commands in a class. very dumb
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
  OnGround:PBYTE;
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
  glEnter2DDrawingMode;
  if hwBaseAndBaseOffset^ <> 0 then
  begin
    { -------------------- set Pointers -------------------- }
    OnGround:=PBYTE( hwBase + $122DF54);
    JValue:=PSingle(hwBaseAndBaseOffset^ + $A8);
    XSpeed:=PSingle(hwBaseAndBaseOffset^ + $A0);
    YSpeed:=PSingle(hwBaseAndBaseOffset^ + $A4);
    XCam:=PSingle(hwBaseAndBaseOffset^ + $D4);
    XPos:=PSingle(hwBaseAndBaseOffset^ + $88);
    YPos:=PSingle(hwBaseAndBaseOffset^ + $8C);
    ZPos:=PSingle(hwBaseAndBaseOffset^ + $90);
    MapString:=PChar(hwBase + $807DB0);



    { ----------------------- Auto Bhop ------------------------ }
    { -> if space is pressed (ingame) and vertical               }
    {    speed is less or equal to 0 and the player is touching  }
    {    the ground, set the players vertical velocity to 237    }
    {    (same as an actual jump)                                }
    { -> hw.dll + $1009D48 is 4 bytes. if its 2 the spacebar is   }
    {    pressed                                                 }
    if (PDWORD(hwBase + $AB3960)^>0) and (JValue^ <= 0) and (OnGround^=1) then
    begin
      JValue^:=237.0;
    end;

    { -------------------- Reset Max Speed --------------------- }
    { -> resets the maximum speed recorded back to 0 when 'R' is }
    {    pressed                                                 }
    { -> hw.dll+AB3AA8 is 1 when R is pressed and 0 when it's not}
    { -> hw.dll+AB3A6C is C                                      }
    if (PDWORD(hwBase + $AB3A6C)^>0) then begin
      PDWORD($10408)^:=0;
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
    //glxDrawString((glx.ViewWidth/2),140,'Speed',3,False);



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
    glxDrawString(180,150-50,'X:',2,True);
    glxDrawString(180,125-50,'Y:',2,True);
    glxDrawString(180,100-50,'Z:',2,True);
    glxDrawNumber(250,151-50,round(XPos^),2);
    glxDrawNumber(250,126-50,round(YPos^),2);
    glxDrawNumber(250,101-50,round(ZPos^),2);



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


    { --------------------- Draw Pressed Keys ------------------- }
    { -> Draw PressedKeys WASD, Space, LCTRL, E                   }
    DrawKeyPresses(hwBase,@glx);


  end;

  glLeave2DDrawingMode;
end;

procedure DrawKeyPresses(hwBase: DWORD; glx:PTglDrawCmds); stdcall;
var
  MainPosX:Single=150;
  MainPosY:Single=100;
  BoxWidth:Single=50;
  BoxHeight:Single=50;
begin
  MainPosX:=glx^.ViewWidth-MainPosX;
  MainPosY:=glx^.ViewHeight-MainPosY;

  glColor3f(0.8,0.8,0.8);
    glx^.DrawBoxAlt(MainPosX,MainPosY-BoxHeight,BoxWidth,BoxHeight);    //W
    glx^.DrawBoxAlt(MainPosX,MainPosY,BoxWidth,BoxHeight);              //S
    glx^.DrawBoxAlt(MainPosX+BoxWidth,MainPosY,BoxWidth,BoxHeight);     //A
    glx^.DrawBoxAlt(MainPosX-BoxWidth,MainPosY,BoxWidth,BoxHeight);     //D
    glx^.DrawBoxAlt(MainPosX+BoxWidth,MainPosY-BoxHeight,BoxWidth,BoxHeight);    //E


    if PDWORD(hwBase + $AB3ABC)^>0 then begin //W
      glxDrawString(MainPosX+BoxWidth/2,(glx^.ViewHeight-MainPosY)+BoxWidth/3,'W',3,False);
    end;

    if PDWORD(hwBase + $AB3AAC)^>0 then begin //S
      glxDrawString(MainPosX+BoxWidth/2,(glx^.ViewHeight-MainPosY)-BoxWidth/1.5,'S',3,False);
    end;

    if PDWORD(hwBase + $AB3A64)^>0 then begin //A
      glxDrawString(MainPosX-BoxWidth/2,(glx^.ViewHeight-MainPosY)-BoxWidth/1.5,'A',3,False);
    end;

    if PDWORD(hwBase + $AB3A70)^>0 then begin //D
      glxDrawString(MainPosX+BoxWidth*1.5,(glx^.ViewHeight-MainPosY)-BoxWidth/1.5,'D',3,False);
    end;

    if PDWORD(hwBase + $AB3A74)^>0 then begin //E
      glxDrawString(MainPosX+BoxWidth+(BoxWidth/2),(glx^.ViewHeight-MainPosY)+BoxWidth/3,'E',3,False);
    end;

    if PDWORD(hwBase + $AB3960)^>0 then begin
      glxDrawString(MainPosX+BoxWidth/2,(glx^.ViewHeight-MainPosY)-BoxWidth*1.5,'Space',3,False);
    end;

end;



procedure glEnter2DDrawingMode; stdcall;
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

procedure glLeave2DDrawingMode; stdcall;
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
