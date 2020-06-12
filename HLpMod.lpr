library HLpMod;

{$mode objfpc}{$H+}

uses
  Classes, OGLHookMaker
  { you can add units after this };

var
  hook:TOGLHookMaker;

begin
  //if GetModuleHandle('freeglut.dll') = 0 then begin
    // LoadLibrary('freeglut.dll');
  //end;

  { ------------------ wglSwapBuffers ----------------- }
  { ----------------------- wtf? -----------------------}
  { -> the reason there is an object for the first hook }
  {    is that i didn't know at the time that it wasn't }
  {    required to wrap them in a class. so yea...      }
  {    now i know though :) all in the name of learning }
  hook:=TOGLHookMaker.Create;
  hook.CreateHook();

  { ------------------- glDrawElements ---------------- }
  { -> this one doesn't do anything because             }
  {    glDrawElements is never called by HL             }
 // HookglDrawElements();
end.

