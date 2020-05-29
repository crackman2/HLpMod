unit glxTextRender;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, gl, glu, glDrawCmds;




var
  Alphabet: array [0..39] of array[0..19] of
  cardinal = (
  ///////////////
  (0, 1, 1, 0, //
   1, 0, 0, 1, //#A
   1, 1, 1, 1, //
   1, 0, 0, 1, //
   1, 0, 0, 1),//

  ///////////////
  (1, 1, 1, 0, //
   1, 0, 0, 1, //#B
   1, 1, 1, 0, //
   1, 0, 0, 1, //
   1, 1, 1, 0),//

  ///////////////
  (1, 1, 1, 1, //
   1, 0, 0, 0, //#C
   1, 0, 0, 0, //
   1, 0, 0, 0, //
   1, 1, 1, 1),//

   ///////////////
  (1, 1, 1, 0, //
   1, 0, 0, 1, //#D
   1, 0, 0, 1, //
   1, 0, 0, 1, //
   1, 1, 1, 0),//

  ///////////////
  (1, 1, 1, 1, //
   1, 0, 0, 0, //#E
   1, 1, 1, 0, //
   1, 0, 0, 0, //
   1, 1, 1, 1),//

   ///////////////
  (1, 1, 1, 1, //
   1, 0, 0, 0, //#F
   1, 1, 1, 0, //
   1, 0, 0, 0, //
   1, 0, 0, 0),//

   ///////////////
  (0, 1, 1, 1, //
   1, 0, 0, 0, //#G
   1, 0, 1, 1, //
   1, 0, 0, 1, //
   0, 1, 1, 1),//

   ///////////////
  (1, 0, 0, 1, //
   1, 0, 0, 1, //#H
   1, 1, 1, 1, //
   1, 0, 0, 1, //
   1, 0, 0, 1),//

   ///////////////
  (1, 1, 1, 1, //
   0, 1, 0, 0, //#I
   0, 1, 0, 0, //
   0, 1, 0, 0, //
   1, 1, 1, 1),//

  ///////////////
  (1, 1, 1, 1, //
   0, 0, 1, 0, //#J
   0, 0, 1, 0, //
   1, 0, 1, 0, //
   0, 1, 0, 0),//

   ///////////////
  (1, 0, 0, 1, //
   1, 0, 1, 0, //#K
   1, 1, 0, 0, //
   1, 0, 1, 0, //
   1, 0, 0, 1),//

   ///////////////
  (1, 0, 0, 0, //
   1, 0, 0, 0, //#L
   1, 0, 0, 0, //
   1, 0, 0, 0, //
   1, 1, 1, 1),//

   ///////////////
  (1, 0, 1, 1, //
   1, 1, 1, 1, //#M
   1, 1, 0, 1, //
   1, 0, 0, 1, //
   1, 0, 0, 1),//

   ///////////////
  (1, 0, 0, 1, //
   1, 1, 0, 1, //#N
   1, 0, 1, 1, //
   1, 0, 1, 1, //
   1, 0, 0, 1),//

   ///////////////
  (0, 1, 1, 0, //
   1, 0, 0, 1, //#O
   1, 0, 0, 1, //
   1, 0, 0, 1, //
   0, 1, 1, 0),//

   ///////////////
  (1, 1, 1, 0, //
   1, 0, 0, 1, //#P
   1, 1, 1, 0, //
   1, 0, 0, 0, //
   1, 0, 0, 0),//

   ///////////////
  (0, 1, 1, 0, //
   1, 0, 0, 1, //#Q
   1, 0, 0, 1, //
   1, 0, 1, 1, //
   0, 1, 1, 1),//

   ///////////////
  (1, 1, 1, 0, //
   1, 0, 0, 1, //#R
   1, 1, 1, 0, //
   1, 0, 1, 1, //
   1, 0, 0, 1),//

   ///////////////
  (0, 1, 1, 1, //
   1, 0, 0, 0, //#S
   0, 1, 1, 0, //
   0, 0, 0, 1, //
   1, 1, 1, 0),//

   ///////////////
  (1, 1, 1, 1, //
   0, 1, 0, 0, //#T
   0, 1, 0, 0, //
   0, 1, 0, 0, //
   0, 1, 0, 0),//

   ///////////////
  (1, 0, 0, 1, //
   1, 0, 0, 1, //#U
   1, 0, 0, 1, //
   1, 0, 0, 1, //
   0, 1, 1, 0),//

   ///////////////
  (1, 0, 0, 1, //
   1, 0, 0, 1, //#V
   1, 0, 1, 0, //
   1, 0, 1, 0, //
   0, 1, 0, 0),//

   ///////////////
  (1, 0, 0, 1, //
   1, 0, 0, 1, //#W
   1, 0, 1, 1, //
   1, 0, 1, 1, //
   0, 1, 0, 1),//

   ///////////////
  (1, 0, 0, 1, //
   0, 1, 1, 0, //#X
   0, 1, 1, 0, //
   1, 0, 0, 1, //
   1, 0, 0, 1),//

   ///////////////
  (1, 0, 0, 1, //
   1, 0, 1, 0, //#Y
   0, 1, 0, 0, //
   0, 1, 0, 0, //
   0, 1, 0, 0),//

   ///////////////
  (1, 1, 1, 1, //
   0, 0, 1, 0, //#Z
   0, 1, 0, 0, //
   1, 0, 0, 0, //
   1, 1, 1, 1),//

   ///////////////
  (1, 1, 1, 0, //
   0, 0, 0, 1, //#?
   0, 1, 1, 0, //
   0, 0, 0, 0, //
   0, 1, 0, 0),//

   ///////////////
  (0, 0, 0, 0, //
   0, 1, 0, 0, //#:
   0, 0, 0, 0, //
   0, 0, 0, 0, //
   0, 1, 0, 0),//

   ///////////////
  (0, 0, 0, 0, //
   0, 0, 0, 0, //#SPACE
   0, 0, 0, 0, //
   0, 0, 0, 0, //
   0, 0, 0, 0),//

   ///////////////
  (1, 0, 1, 0, //
   0, 1, 0, 1, //#ERROR
   1, 0, 1, 0, //
   0, 1, 0, 1, //
   1, 0, 1, 0),//

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
   0, 1, 1, 1)
  );

  Characters: array[0..11] of array[0..19] of
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
   0, 1, 1, 1),

  ///////////////
  (0, 0, 0, 0, //
   0, 0, 0, 0, //#-
   0, 1, 1, 1, //
   0, 0, 0, 0, //
   0, 0, 0, 0),//

   ///////////////
  (0, 0, 0, 0, //
   0, 0, 0, 0, //#.
   0, 0, 0, 0, //
   0, 0, 0, 0, //
   0, 0, 1, 0)//


   );

procedure glxDrawNumber(x: Single; y: Single; Num: Integer; Scale:Cardinal); stdcall;
procedure glxDrawString(x: Single; y: Single; Num: AnsiString; Scale:Single; LeftBound:Boolean); stdcall;

implementation


{ ------------------ glxDrawNumber ------------------ }
{ -> can only draw singed integers... havend tested   }
{    unsigned ones.                                   }
{ -> converts integer to string and compares each     }
{    char in a case statement and maps it onto an     }
{    array of defined characters. this array is used  }
{    to define where the pixels go for each char      }
{ -> this was the least shit method to draw text for  }
{    me. hl.exe doesn't load freeglut and other       }
{    like bitmaps were too tricky for me to grasp     }
procedure glxDrawNumber(x: Single; y: Single; Num: integer; Scale:Cardinal); stdcall;
var
  tmp: String;
  tmplen:Integer;
  i: cardinal;
  iInit:cardinal;

  CurrentNumber: cardinal;
  dimPixY: cardinal;
  dimPixX: cardinal;
  glx:TglDrawCmds;
  CenterCorrection:Cardinal;
  CenterPositioning:Cardinal;
begin
  glx:=TglDrawCmds.Create;
  tmp := IntToStr(Num);


  if Num < 0 then begin
    tmplen:=Length(tmp);
    iInit:=1;
  end
  else
  begin
     tmplen:=Length(tmp);
     iInit:=1;
  end;

  CenterCorrection:= round(((Length(tmp)) * 4 * Scale)/2);
  CenterPositioning:=round((8*Scale)/2);

  for i := iInit to tmplen do
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
      '-':
        CurrentNumber:=10;
      '.':
        CurrentNumber:=11;
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
            round(x - CenterCorrection - CenterPositioning) + (i * (4*Scale)) + (dimPixX*Scale),
            round(y) + ((4-dimPixY)*round(Scale)),
             Scale
            );
        end;

      end;
    end;
  end;

end;


{ ------------------ glxDrawString ------------------ }
{ -> basically the same as glxDrawNumber but with way }
{    more characters.                                 }
{ -> tool used to define characters: https://github.com/MeteorTheLizard/AutoIt-OpenGL-Character-to-Array-Converter-for-Freepascal }
{                                                     }
procedure glxDrawString(x: Single; y: Single; Num: AnsiString; Scale:Single; LeftBound:Boolean); stdcall;
var
  tmp: PChar;
  i: cardinal;

  CurrentNumber: cardinal;
  dimPixY: cardinal;
  dimPixX: cardinal;
  glx:TglDrawCmds;
  CenterCorrection:Cardinal;
  CenterPositioning:Cardinal;
begin
  glx:=TglDrawCmds.Create;
  tmp := Pchar(UpperCase(Num));


  CenterCorrection:= round(((Length(tmp)-1) * 5 * Scale)/2);
  CenterPositioning:=round((4*Scale)/2);



  for i := 0 to (Length(tmp)-1) do
  begin

    case tmp[i] of
      'A':
        CurrentNumber := 0;
      'B':
        CurrentNumber := 1;
      'C':
        CurrentNumber := 2;
      'D':
        CurrentNumber := 3;
      'E':
        CurrentNumber := 4;
      'F':
        CurrentNumber := 5;
      'G':
        CurrentNumber := 6;
      'H':
        CurrentNumber := 7;
      'I':
        CurrentNumber := 8;
      'J':
        CurrentNumber := 9;
      'K':
        CurrentNumber := 10;
      'L':
        CurrentNumber := 11;
      'M':
        CurrentNumber := 12;
      'N':
        CurrentNumber := 13;
      'O':
        CurrentNumber := 14;
      'P':
        CurrentNumber := 15;
      'Q':
        CurrentNumber := 16;
      'R':
        CurrentNumber := 17;
      'S':
        CurrentNumber := 18;
      'T':
        CurrentNumber := 19;
      'U':
        CurrentNumber := 20;
      'V':
        CurrentNumber := 21;
      'W':
        CurrentNumber := 22;
      'X':
        CurrentNumber := 23;
      'Y':
        CurrentNumber := 24;
      'Z':
        CurrentNumber := 25;
      '?':
        CurrentNumber := 26;
      ':':
        CurrentNumber := 27;
      ' ':
        CurrentNumber := 28;
      '0':
        CurrentNumber:= 30;
      '1':
        CurrentNumber:= 31;
      '2':
        CurrentNumber:= 32;
      '3':
        CurrentNumber:= 33;
      '4':
        CurrentNumber:= 34;
      '5':
        CurrentNumber:= 35;
      '6':
        CurrentNumber:= 36;
      '7':
        CurrentNumber:= 37;
      '8':
        CurrentNumber:= 38;
      '9':
        CurrentNumber:= 39;

      else
        CurrentNumber:= 29;
    end;



    for dimPixY := 0 to 4 do
    begin
      for dimPixX := 0 to 3 do
      begin
        if Alphabet[CurrentNumber][(dimPixY * 4) + dimPixX] > 0 then
        begin
          if LeftBound then
          begin
            glx.SetPixel(
            round(x) + round((i * (5*Scale)) + (dimPixX*Scale)),
            round(y) + round((5-dimPixY)*round(Scale)),
             Scale
            );
          end
          else
          begin
            glx.SetPixel(
            round(x - CenterCorrection - CenterPositioning) + round((i * (5*Scale)) + (dimPixX*Scale)),
            round(y) + round((5-dimPixY)*round(Scale)),
             Scale
            );
          end;

        end;

      end;
    end;
  end;

end;

end.



end.

