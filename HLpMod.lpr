library HLpMod;

{$mode objfpc}{$H+}

uses
  Classes, OGLHookMaker, Main
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
  { -> some injectors may want to call the exported     }
  {    MainBit function directly, but this is fine.     }
  {    either method should work                        }
  hook:=TOGLHookMaker.Create;
  hook.CreateHook(@MainBit);

  { ------------------- glDrawElements ---------------- }
  { -> this one doesn't do anything because             }
  {    glDrawElements is never called by HL             }
 // HookglDrawElements();
end.

