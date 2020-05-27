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
    procedure SetPixel(x:Integer; y:Integer);stdcall;

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

procedure TglDrawCmds.SetPixel(x: Integer; y: Integer; Thick:Cardinal); stdcall;
var
  Convx: single;
  Convy: single;
begin
  Convx := ViewWidth / 200;
  Convy := ViewHeight / 200;


  glPointSize(Thick);
  glBegin(GL_POINTS);
  glVertex2f((x / Convx) - 100,(y / Convx) - 100);
  glEnd();
end;

end.
