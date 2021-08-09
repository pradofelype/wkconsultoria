unit ConexaoBanco;

interface

uses
  SqlExpr, IniFiles, SysUtils, Forms, Windows;

type
  TConexaoBanco = class
    private
      oConexaoBanco: TSQLConnection;
    public
      constructor Create;
      destructor Destroy; override;

      function getConexao: TSQLConnection;

      property ConexaoBanco: TSQLConnection read getConexao;
  end;

implementation

uses
  StrUtils, Math, Messages;

{ TConexaoBanco }

constructor TConexaoBanco.Create;
var
  ArquivoIni, Servidor, DataBase, DriverName, UserName, PassWord, MsgERRO: string;
  LocalServer: Integer;
  Configuracoes: TIniFile;

  procedure InicializarVariaveis;
  begin
    Servidor := '';
    DataBase := '';
    DriverName := '';
    UserName := '';
    PassWord := '';

    MsgERRO := '';
  end;

begin
  ArquivoIni := ExtractFilePath(Application.ExeName) + '\config.ini';

  InicializarVariaveis;

//  if not FileExists(ArquivoIni) then
//    Application.MessageBox('Arquivo de configuração não encontrado.', 'Erro de conexão', MB_ICONERROR or MB_OK)
//  else
  begin
    Configuracoes := TIniFile.Create(ArquivoIni);
    try
      Servidor := Configuracoes.ReadString('Dados', 'Servidor', Servidor);
      DataBase := Configuracoes.ReadString('Dados', 'DataBase', DataBase);
      DriverName := Configuracoes.ReadString('Dados', 'DriverName', DriverName);
      UserName := Configuracoes.ReadString('Dados', 'UserName', UserName);
      PassWord := Configuracoes.ReadString('Dados', 'PassWord', PassWord);
    finally
      FreeAndNil(Configuracoes);
    end;

    oConexaoBanco := TSQLConnection.Create(Application);
    oConexaoBanco.LoginPrompt := False;
    oConexaoBanco.Connected := False;

    try
      Servidor := IfThen(Trim(Servidor) = '', '127.0.0.1:3306', Servidor);
      DataBase := IfThen(Trim(DataBase) = '', 'wk_felypeprado', DataBase);
      DriverName := IfThen(Trim(DriverName) = '', 'MySQL', DriverName);
      UserName := IfThen(Trim(UserName) = '', 'root', UserName);
      PassWord := IfThen(Trim(PassWord) = '', 'admin', PassWord);


      oConexaoBanco.ConnectionName := 'MySQLConnection';
      oConexaoBanco.DriverName := 'MySQL';
      oConexaoBanco.LibraryName := 'dbxmys.dll';
      oConexaoBanco.VendorLib := 'libmysql.dll';
      oConexaoBanco.GetDriverFunc := 'getSQLDriverMYSQL';


      oConexaoBanco.Params.Values['Database'] := DataBase;
      oConexaoBanco.Params.Values['Hostname'] := Servidor;
      oConexaoBanco.Params.Values['UserName'] := UserName;
      oConexaoBanco.Params.Values['PassWord'] := PassWord;
      oConexaoBanco.Connected := True;
    except
      on e: Exception do
      begin
        try
          MsgERRO := 'Ocorreu o seguinte erro ao tentar conectar no MySQL.'+#13+#10+'Erro "'+e.Message+'".';
          Application.MessageBox(PWideChar(MsgERRO), 'Erro de conexão MySQL', MB_ICONERROR + MB_OK);

          InicializarVariaveis;

          Servidor := IfThen(Trim(Servidor) = '', '127.0.0.1/3050', Servidor);
          DataBase := IfThen(Trim(DataBase) = '', ExtractFilePath(Application.ExeName) + 'BD\WK_FELYPEPRADO.FDB', DataBase);
          DriverName := IfThen(Trim(DriverName) = '', 'Firebird', DriverName);
          UserName := IfThen(Trim(UserName) = '', 'sysdba', UserName);
          PassWord := IfThen(Trim(PassWord) = '', 'masterkey', PassWord);

          oConexaoBanco.ConnectionName := 'FBConnection';
          oConexaoBanco.DriverName := 'Firebird';
          oConexaoBanco.LibraryName := 'dbxfb.dll';
          oConexaoBanco.VendorLib := 'fbclient.dl';
          oConexaoBanco.GetDriverFunc := 'getSQLDriverINTERBASE';

          oConexaoBanco.Connected := False;
          oConexaoBanco.Params.Values['DataBase'] := Servidor + ':' + DataBase;
          oConexaoBanco.Params.Values['User_Name'] := UserName;
          oConexaoBanco.Params.Values['Password'] := PassWord;
          oConexaoBanco.Connected := True;
        except
          Application.MessageBox('Erro ao conectar ao banco de dados. Verifique as preferências do sistema', 'Erro de conexão',MB_ICONERROR + MB_OK);
        end;
      end;
    end;
  end;
end;

destructor TConexaoBanco.Destroy;
begin
  FreeAndNil(oConexaoBanco);

  inherited;
end;

function TConexaoBanco.getConexao: TSQLConnection;
begin
  Result := oConexaoBanco;
end;

end.
