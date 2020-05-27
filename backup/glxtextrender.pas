unit glxTextRender;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, gl, glu, glDrawCmds;

var
  Characters: array[0..9] of array[0..19] of
  cardinal = (
  (0, 1, 1, 1, //
   0, 1, 0, 1, //#0
   0, 1, 0, 1, //
   0, 1, 0, 1, //
   0, 1, 1, 1),//
   //////////////
  (0, 0, 1, 0, //
   0, 1, 1, 0, //#1
   0, 0, 1, 0, //
   0, 0, 1, 0, //
   0, 1, 1, 1),//
   //////////////
  (0, 1, 1, 1, //
   0, 0, 0, 1, //#2
   0, 1, 1, 1, //
   0, 1, 0, 0, //
   0, 1, 1, 1),//
   //////////////
  (0, 1, 1, 1, //
   0, 0, 0, 1, //#3
   0, 1, 1, 1, //
   0, 0, 0, 1, //
   0, 1, 1, 1),//
   //////////////
  (0, 1, 0, 1, //
   0, 1, 0, 1, //#4
   0, 1, 1, 1, //
   0, 0, 0, 1, //
   0, 0, 0, 1),//
   //////////////
  (0, 1, 1, 1, //
   0, 1, 0, 0, //#5
   0, 1, 1, 1, //
   0, 0, 0, 1, //
   0, 1, 1, 1),//
   //////////////
  (0, 1, 1, 1, //
   0, 1, 0, 0, //#6
   0, 1, 1, 1, //
   0, 1, 0, 1, //
   0, 1, 1, 1),//
   //////////////
  (0, 1, 1, 1, //
   0, 0, 0, 1, //#7
   0, 0, 1, 0, //
   0, 0, 1, 0, //
   0, 0, 1, 0),//
   //////////////
  (0, 1, 1, 1, //
   0, 1, 0, 1, //#8
   0, 1, 1, 1, //
   0, 1, 0, 1, //
   0, 1, 1, 1),//
   //////////////
  (0, 1, 1, 1, //
   0, 1, 0, 1, //#9
   0, 1, 1, 1, //
   0, 0, 0, 1, //
   0, 1, 1, 1));

procedure glxDrawNumber(x: Single; y: Single; Num: cardinal; Scale:Cardinal); stdcall;

implementation

procedure glxDrawNumber(x: Single; y: Single; Num: cardinal; Scale:Cardinal); stdcall;
var
  tmp: PChar;
  i: cardinal;

  CurrentNumber: cardinal;
  dimPixY: cardinal;
  dimPixX: cardinal;
  glx:TglDrawCmds;
begin
  glx:=TglDrawCmds.Create;
  tmp := PChar(IntToStr(Num));




  glColor3f(0.8, 0.8, 0.8);

  for i := 0 to (Length(tmp)-1) do
  begin

    case tmp[i] of
      '0':
        CurrentNumber := 0;
      '1':
        CurrentNumber := 1;
      '2':
        CurrentNumber := 2;
      '3':
        CurrentNumber := 3;
      '4':
        CurrentNumber := 4;
      '5':
        CurrentNumber := 5;
      '6':
        CurrentNumber := 6;
      '7':
        CurrentNumber := 7;
      '8':
        CurrentNumber := 8;
      '9':
        CurrentNumber := 9;
      else
        CurrentNumber:= 0;
    end;



    for dimPixY := 0 to 4 do
    begin
      for dimPixX := 0 to 3 do
      begin
        if Characters[CurrentNumber][(dimPixY * 4) + dimPixX] > 0 then
        begin
          glx.SetPixel(
            round(x) + (i * (4*Scale)) + (dimPixX*Scale),
            round(y) + ((4-dimPixY)*round(Scale*(1/3))),
             Scale
            );
        end;

      end;
    end;
  end;

end;

end.

