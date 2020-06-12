unit glDrawCmds;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, gl, glu;

type
  RGLColor = array[0..2] of GLbyte;
  PRGLColor = ^RGLColor;

  { TglDrawCmds }

  TglDrawCmds = class
    constructor Create;
    procedure DrawLine(x1: single; y1: single; x2: single; y2: single); stdcall;
    procedure DrawBox(left:single; top:single; right:single; bottom:single);stdcall;
    procedure DrawBoxAlt(x:single;y:single;width:single;height:single);stdcall;
    procedure SetPixel(x:Integer; y:Integer; Thick:Single);stdcall;
    procedure DrawCircle(x: single; y: single; radius: single; detail:Cardinal); stdcall;


  public
    ViewWidth: cardinal;
    ViewHeight: cardinal;
  end;

  ArrGLint = array[0..3] of GLint;


implementation

{ TglDrawCmds }

constructor TglDrawCmds.Create;
var
  m_Viewport: ArrGLint;
begin
  glGetIntegerv(GL_VIEWPORT, m_Viewport);
  ViewWidth := m_Viewport[2];
  ViewHeight := m_Viewport[3];
end;



{ -------------------- Draw Commands -------------------- }
{ -> all draw commands need to convert the screen         }
{    coordinate input into weird coordinates where center }
{    x and y is 0. top is 100, right is 100               }
{    maybe it has something to do with how shaders are    }
{    drawn but i really have no idea                      }
procedure TglDrawCmds.DrawLine(x1: single; y1: single; x2: single;
  y2: single); stdcall;
var
  Convx: single;
  Convy: single;
begin
  Convx := ViewWidth / 200;
  Convy := ViewHeight / 200;

  glBegin(GL_LINES);
  glVertex2F((x1 / Convx) - 100, -((y1 / Convy) - 100));
  glVertex2F((x2 / Convx) - 100, -((y2 / Convy) - 100));
  glEnd();
end;

procedure TglDrawCmds.DrawBox(left: single; top: single; right: single;
  bottom: single); stdcall;
begin
  DrawLine(left,top,left,bottom);
  DrawLine(left,top,right,top);
  DrawLine(right,top,right,bottom);
  DrawLine(left,bottom,right,bottom);

end;

procedure TglDrawCmds.DrawBoxAlt(x: single; y: single; width: single;
  height: single); stdcall;
begin
  DrawBox(x,y,x+width,y+height);
end;


procedure TglDrawCmds.DrawCircle(x: single; y: single; radius: single; detail:Cardinal); stdcall;
var
  Convx: single;
  Convy: single;
  i:Cardinal;
  tPi:Single=6.28318530718;
begin
  Convx := ViewWidth / 200;
  Convy := ViewHeight / 200;


  glBegin(GL_LINES);
  for i:=0 to detail do
  begin
    glVertex2F(((x + cos(i * tPi/detail)*radius) / Convx) - 100, -(((y + sin(i* tPi/detail)*radius) / Convy) - 100));
    glVertex2F(((x + cos((i+1) * tPi/detail)*radius) / Convx) - 100, -(((y + sin((i+1)* tPi/detail)*radius) / Convy) - 100));
  end;
  glEnd();
end;

procedure TglDrawCmds.SetPixel(x: Integer; y: Integer; Thick:Single); stdcall;
var
  Convx: single;
  Convy: single;
begin
  Convx := ViewWidth / 200;
  Convy := ViewHeight / 200;
  glPointSize(Thick);
  glBegin(GL_POINTS);
  glVertex2f((x / Convx) - 100,(y / Convy) - 100);
  glEnd();
end;

end.
