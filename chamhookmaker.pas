unit ChamHookMaker;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, ChamMain;

type
  ARRBYTE = array[0..3] of byte;

procedure HookglDrawElements();stdcall;
procedure WriteJump(J_FROM: DWORD; J_TO: DWORD; J0C1: boolean); stdcall;
procedure WriteCodeCave(Location: DWORD; addMyFunc: DWORD; JumpBackTo: DWORD); stdcall;

implementation
procedure HookglDrawElements();stdcall;
var
  CodeCave:DWORD;
  DrawElements:DWORD;
  Garb:DWORD;
begin
  CodeCave:=DWORD(GetModuleHandle('opengl32.dll') + $A051B);
  DrawElements:=DWORD(GetProcAddress(GetModuleHandle('opengl32.dll'),'glDrawElements'));
  WriteCodeCave(CodeCave,DWORD(@ChamMainF),DrawElements+5);
  VirtualProtectEx(GetCurrentProcess(),Pointer(DrawElements),6,PAGE_EXECUTE_WRITECOPY,@Garb);
  WriteJump(DrawElements,CodeCave,False);
  PBYTE(DrawElements + 5)^:=$90;
  PBYTE(DrawElements + 6)^:=$90;
end;




procedure WriteJump(J_FROM: DWORD; J_TO: DWORD; J0C1: boolean); stdcall;
var
  JCode: DWORD;
  FinalCode: ARRBYTE = (0, 0, 0, 0);
  PWriter: PBYTE;
  i: cardinal;
begin
  JCode := J_TO - J_FROM - $5;
  FinalCode := ARRBYTE(JCode);

  PWriter := PBYTE(J_FROM);
  if J0C1 then
    PWriter^ := $E8 //CALL
  else
    PWriter^ := $E9; //JMP

  for i := 0 to 3 do
  begin
    PWriter := PBYTE(J_FROM + 1 + i);
    PWriter^ := FinalCode[i];
  end;
end;

procedure WriteCodeCave(Location: DWORD; addMyFunc: DWORD;
  JumpBackTo: DWORD); stdcall;
var
  OriginalCode: array[0..5] of byte = ($64,$A1,$18,$00,$00,$00);
  i: cardinal;
begin
  PBYTE(Location + 00)^ := $60;//pushad
  PBYTE(Location + 01)^ := $9C;//pushfd
  WriteJump(Location + 02, addMyFunc, True);
  PBYTE(Location + 07)^ := $9D;//popfd
  PBYTE(Location + 08)^ := $61;//popfd
  for i := 0 to 5 do
  begin
    PBYTE(Location + 9 + i)^ := OriginalCode[i];
  end;
  WriteJump(Location + 15, JumpBackTo, False);
end;

end.
{ --- Doc ---
 OPENGL32.glDrawElements
                        Original:
                                 OPENGL32.glDrawElements - 64 A1 18000000        - mov eax,fs:[00000018] { 24 }

                        Replace:
                                 OPENGL32.glDrawElements - E9 B2E50900           - jmp OPENGL32.dll+A051B
                                 OPENGL32.glDrawElements+5 - 90                    - nop

CodeCave (Opengl32.dll + A051B):
                                 OPENGL32.dll+A051B - 60                    - pushad
                                 OPENGL32.dll+A051C - 9C                    - pushfd
                                 OPENGL32.dll+A051D - E8 DEFA0ECE           - call HLpMod.dll
                                 OPENGL32.dll+A0522 - 9D                    - popfd
                                 OPENGL32.dll+A0523 - 61                    - popad
                                 OPENGL32.dll+A0524 - 64 A1 18000000        - mov eax,fs:[00000018] { 24 }
                                 OPENGL32.dll+A052A - E9 3A1AF6FF           - jmp OPENGL32.glDrawElements+5




}

