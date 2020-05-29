unit ChamMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows;

procedure ChamMain();stdcall;

implementation

procedure ChamMain(); stdcall;
begin
  MessageBox(0,'Chams','Chams',0);
end;

exports
       ChamMain;

end.

