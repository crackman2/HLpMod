unit ChamMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows;

procedure ChamMainF();stdcall;

implementation

procedure ChamMainF(); stdcall;
begin
  MessageBox(0,'Chams','Chams',0);
end;

exports
       ChamMainF;

end.

