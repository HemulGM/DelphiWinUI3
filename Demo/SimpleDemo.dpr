program SimpleDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  SimpleDemo.Main in 'SimpleDemo.Main.pas' {Form7};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TForm7, Form7);
  Application.Run;
end.
