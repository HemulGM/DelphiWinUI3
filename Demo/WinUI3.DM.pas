unit WinUI3.DM;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  TDataModuleRes = class(TDataModule)
    ImageListDemo: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleRes: TDataModuleRes;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
