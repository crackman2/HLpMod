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
  { --------------------- What does this do? --------------------- }
  { -> Basically a refined version of the hook i used last time    }
  { -> Uses GetProcAddress to find glDrawElements as opposed to a  }
  {    fixed offset like i used in the wglSwapBuffers hook         }
  { -> How this works:                                             }
  {                   1. Define where stuff goes                   }
  {                      - found a code cave in opengl32.dll       }
  {                        using cheat engine. (turns out its the  }
  {                        same one i used for the swapbuffers     }
  {                        hook. also find glDrawElements using    }
  {                        GetProcAddress                          }
  {                   2. Write code into the Code Cave             }
  {                      - the code is basically always the same   }
  {                        scheme. 1. Save current state by        }
  {                        flags and registers onto the stack      }
  {                        (pushfd, pushad). 2. Call my function   }
  {                        reset state using popad and popfd       }
  {                        3. run original code that was replaced  }
  {                        at the hooked function                  }
  {                        4. jump back to the hooked function     }
  {                   3. Write the jump at the hooked function     }
  {                      - it is usually required to change the    }
  {                        the page's protection using             }
  {                        VirtualProtectEx before doing any       }
  {                        writing or it will simply fail.         }
  {                        the jump leads to the first instruction }
  {                        in the codecave. nop any bytes that are }
  {                        left over                               }
  CodeCave:=DWORD(GetModuleHandle('opengl32.dll') + $A051B);
  DrawElements:=DWORD(GetProcAddress(GetModuleHandle('opengl32.dll'),'glDrawElements'));
  WriteCodeCave(CodeCave,DWORD(@ChamMainF),DrawElements+5);
  VirtualProtectEx(GetCurrentProcess(),Pointer(DrawElements),6,PAGE_EXECUTE_WRITECOPY,@Garb);
  WriteJump(DrawElements,CodeCave,False);
  PBYTE(DrawElements + 5)^:=$90; //NOP
  PBYTE(DrawElements + 6)^:=$90; //NOP
end;



{  -------------------- Jump Writer -------------------- }
{  -> Jump offsets are calculated using a simple formula }
{     JumpOffset = Jump_to - Jump_from                   }
{     so if the jump is written at 0x100 and we want to  }
{     jump to 0x150 the offset will be 0x50.             }
{     in x86 the code would looks like E9 50000000       }
{     look out for edianness.                            }
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

{  -------------------- WriteCodeCave -------------------- }
{  -> explained above                                      }
procedure WriteCodeCave(Location: DWORD; addMyFunc: DWORD;
  JumpBackTo: DWORD); stdcall;
var
  OriginalCode: array[0..5] of byte = ($64,$A1,$18,$00,$00,$00);
  i: cardinal;
begin
  PBYTE(Location + 00)^ := $60;//pushad
  PBYTE(Location + 01)^ := $9C;//pushfd
  WriteJump(Location + 02, addMyFunc, True); //call my function
  PBYTE(Location + 07)^ := $9D;//popfd
  PBYTE(Location + 08)^ := $61;//popfd
  for i := 0 to 5 do  //write original code
  begin
    PBYTE(Location + 9 + i)^ := OriginalCode[i];
  end;
  WriteJump(Location + 15, JumpBackTo, False); //jump back to hooked function
end;

end.
{ ------------ Doc ------------
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

