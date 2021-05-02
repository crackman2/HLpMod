unit OGLHookMaker;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, Main;

type

  { TOGLHookMaker }

  TOGLHookMaker = class
    procedure CreateHook(); stdcall;
    procedure WriteJump(J_FROM: DWORD; J_TO: DWORD; J0C1: boolean); stdcall;
    procedure WriteCodeCave(Location: DWORD; addMyFunc: DWORD;
      JumpBackTo: DWORD); stdcall;
  end;

  ARRBYTE = array[0..3] of byte;

implementation

{ TOGLHookMaker }

procedure TOGLHookMaker.CreateHook(); stdcall;
var
  OGLBase: DWORD;
  SwapBuff: DWORD;
  CodeCave: DWORD;
  Garbage: DWORD = 0;
begin
  OGLBase := GetModuleHandle('OPENGL32.dll');
  {/////////////////////////////////////////}
  {///}//Messagebox(0, PChar('OGLBase: 0x' + IntToHex(OGLBase, 8)), 'Base', 0);
  {///}{THIS IS REQUIRED FOR SOME REASON////}
  {/////////////////////////////////////////}
  CodeCave := OGLBase + $A0508;
  Swapbuff := OGLBase + $45E21;


  if (VirtualProtect(LPVOID(CodeCave), 30, PAGE_EXECUTE_WRITECOPY, Garbage) =
    longbool(0)) then
    MessageBox(0, 'Can''t change page protection for code cave', 'Error', 0);
  if (VirtualProtect(LPVOID(Swapbuff), 5, PAGE_EXECUTE_WRITECOPY, Garbage) =
    longbool(0)) then
    MessageBox(0, 'Can''t change page protection for wglSwapBuffers', 'Error', 0);
  WriteCodeCave(CodeCave, DWORD(@MainBit), SwapBuff + 5);
  WriteJump(SwapBuff, CodeCave, False);
end;

procedure TOGLHookMaker.WriteJump(J_FROM: DWORD; J_TO: DWORD; J0C1: boolean); stdcall;
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

procedure TOGLHookMaker.WriteCodeCave(Location: DWORD; addMyFunc: DWORD;
  JumpBackTo: DWORD); stdcall;
var
  OriginalCode: array[0..4] of byte = ($8B, $FF, $55, $8B, $EC);
  i: cardinal;
begin
  PBYTE(Location + 00)^ := $60;//pushad
  PBYTE(Location + 01)^ := $9C;//pushfd
  WriteJump(Location + 02, addMyFunc, True); //CALL
  PBYTE(Location + 07)^ := $9D;//popfd
  PBYTE(Location + 08)^ := $61;//popfd
  for i := 0 to 4 do
  begin
    PBYTE(Location + 9 + i)^ := OriginalCode[i];
  end;
  WriteJump(Location + 14, JumpBackTo, False);
end;




end.
{ --- Documentation ---}{
wglSwapBuffers : OPENGL32.dll+45E21

        Original:
                 OPENGL32.dll+45E21 - 8B FF                 - mov edi,edi
                 OPENGL32.dll+45E23 - 55                    - push ebp
                 OPENGL32.dll+45E24 - 8B EC                 - mov ebp,esp

        Replace:
                 OPENGL32.dll+45E21 - E9 E2A60500           - jmp OPENGL32.dll+A0508 // jumpaddress = Jump_to - Jump_from





Codecave       : OPENGL32.dll+A0508

        Code:
                 OPENGL32.dll+A0508 - 60                    - pushad
                 OPENGL32.dll+A0509 - 9C                    - pushfd
                 OPENGL32.dll+A050A - E8 F1FAF5FF           - call OPENGL32.dll  //Replace with main function
                 OPENGL32.dll+A050F - 9D                    - popfd
                 OPENGL32.dll+A0510 - 61                    - popad
                 OPENGL32.dll+A0511 - 8B FF                 - mov edi,edi
                 OPENGL32.dll+A0513 - 55                    - push ebp
                 OPENGL32.dll+A0514 - 8B EC                 - mov ebp,esp
                 OPENGL32.dll+A0516 - E9 0B59FAFF           - jmp OPENGL32.dll+45E26


}
