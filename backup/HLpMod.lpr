library HLpMod;

{$mode objfpc}{$H+}

uses
  Classes, OGLHookMaker, Main, glDrawCmds
  { you can add units after this };

var
  hook:TOGLHookMaker;

begin
  hook:=TOGLHookMaker.Create;
  hook.CreateHook();
end.

