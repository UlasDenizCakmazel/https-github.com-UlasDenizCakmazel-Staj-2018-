unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdServerIOHandler, IdSSL, IdSSLOpenSSL,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
  Vcl.StdCtrls, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, Vcl.Tabs,
  Vcl.DockTabSet, System.Actions, Vcl.ActnList, Vcl.ExtActns, Vcl.ComCtrls, System.IniFiles;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    OpenDialog1: TOpenDialog;
    Edit5: TEdit;
    ListBox1: TListBox;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    RichEdit1: TRichEdit;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  dosyasayi:Integer;

implementation

uses IdText, IdAttachmentFile;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Mode := sslmUnassigned;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyMode := [];
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyDepth := 0;

  IdMessage1.From.Address := Edit1.Text;
  IdMessage1.Recipients.EMailAddresses := Edit3.Text;
  IdMessage1.Subject := Edit4.Text;
  IdMessage1.Body.Text := RichEdit1.Text;
  IdMessage1.FieldAddress(OpenDialog1.FileName);

  IdSMTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdSMTP1.Host := 'smtp.gmail.com';
  IdSMTP1.Port := 587;
  IdSMTP1.username := Edit1.Text;
  IdSMTP1.password := Edit2.Text;
  IdSMTP1.UseTLS := utUseExplicitTLS;

  IdSMTP1.Connect;
  IdSMTP1.Send(IdMessage1);
  IdSMTP1.Disconnect;

  IdSMTP1.Free;
  IdMessage1.Free;
  IdSSLIOHandlerSocketOpenSSL1.Free;

  end;

procedure TForm1.Button2Click(Sender: TObject);
var
 yol:string;
begin
 if OpenDialog1.Execute then
    if FileExists(OpenDialog1.FileName) then
      begin
      yol:=OpenDialog1.FileName;
      TIdAttachmentFile.Create(IdMessage1.MessageParts,yol);
      Edit5.Text:=yol;
      ListBox1.Items.Add(ExtractFileName(yol));
      end
 else
    raise Exception.Create('No such file');
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  IniF: TIniFile;
  dsy:string;
  //dsy2,dsy3,dsy4:string;
  i:integer;
begin
  Edit1.PasswordChar:='*';
  IniF:=TIniFile.Create('c:posta.ini');
  try
    edit3.Text:=(IniF.ReadString('POSTA','Alici','Bos Geldi'));
    edit4.Text:=(IniF.ReadString('POSTA','Konu','Bos Geldi'));
    RichEdit1.Text:=(IniF.ReadString('POSTA','Icerik','Bos Geldi'));
    dosyasayi:=(IniF.ReadInteger('POSTA','dosyasayisi',0));
    for i := 1 to dosyasayi do
    begin
    dsy:=(IniF.ReadString('POSTA','dosya'+IntToStr(i),'Bos Geldi'));
    ListBox1.Items.Add(dsy);
    TIdAttachmentFile.Create(IdMessage1.MessageParts,dsy);
    end;
    (*dsy2:=(IniF.ReadString('POSTA','dosya2','Bos Geldi'));
    TIdAttachmentFile.Create(IdMessage1.MessageParts,dsy2);
    dsy3:=(IniF.ReadString('POSTA','dosya3','Bos Geldi'));
    TIdAttachmentFile.Create(IdMessage1.MessageParts,dsy3);
    dsy4:=(IniF.ReadString('POSTA','dosya4','Bos Geldi'));
    TIdAttachmentFile.Create(IdMessage1.MessageParts,dsy4); *)
  finally
    IniF.Free;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  IniF: TIniFile;
  dsy:string;
  i,gonder:integer;
begin
  Edit2.passwordchar:='*';
  Edit1.text:='denizcakmazel@gmail.com';
  Edit2.text:='ulasdeniz1998';
  IniF:=TIniFile.Create('c:maildx1.ini');
  try
  Edit3.Text:=(IniF.ReadString('POSTA','Alici','Bos Geldi')); //Edit3.text:='denizcakmazel@gmail.com';
  Edit4.Text:=(IniF.ReadString('POSTA','Konu','Bos Geldi'));  //Edit4.text:='konu';
  RichEdit1.Text:=(IniF.ReadString('POSTA','Icerik','Bos Geldi')); //RichEdit1.text:='i�erik';
  gonder:=(IniF.ReadInteger('POSTA','Gonder',0));
  Edit5.Text:=IntToStr(gonder);
  for i := 1 to dosyasayi do
    begin
    dsy:=(IniF.ReadString('POSTA','dosya'+IntToStr(i),'Bos Geldi'));
    ListBox1.Items.Add(dsy);
    TIdAttachmentFile.Create(IdMessage1.MessageParts,dsy);
    end;
  finally
    IniF.Free;
  end;
  if gonder=1 then
  begin
  Button1.Enabled:=False;
  Button4.Enabled:=False;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Method := sslvTLSv1;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.Mode := sslmUnassigned;
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyMode := [];
  IdSSLIOHandlerSocketOpenSSL1.SSLOptions.VerifyDepth := 0;

  IdMessage1.From.Address := Edit1.Text;
  IdMessage1.Recipients.EMailAddresses := Edit3.Text;
  IdMessage1.Subject := Edit4.Text;
  IdMessage1.Body.Text := RichEdit1.Text;
  IdMessage1.FieldAddress(OpenDialog1.FileName);

  IdSMTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdSMTP1.Host := 'smtp.gmail.com';
  IdSMTP1.Port := 587;
  IdSMTP1.username := Edit1.Text;
  IdSMTP1.password := Edit2.Text;
  IdSMTP1.UseTLS := utUseExplicitTLS;

  IdSMTP1.Connect;
  IdSMTP1.Send(IdMessage1);
  IdSMTP1.Disconnect;

  IdSMTP1.Free;
  IdMessage1.Free;
  IdSSLIOHandlerSocketOpenSSL1.Free;
  ShowMessage('Mail otomatik olarak ba�ar�yla g�nderildi...');
  end
  else ShowMessage('Otomatik g�nderme aktif de�il... L�tfen butonlar� kullanarak manuel olarak g�nderiniz...');

  end;

end.
