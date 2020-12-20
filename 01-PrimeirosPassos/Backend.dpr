program Backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
    Horse,
    Horse.Jhonson,

    System.JSON,
    System.SysUtils;


begin
     THorse.Use(Jhonson);
     THorse.Get('/ping',
        procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
        begin
            Writeln('Request /ping');
            Res.Send('pong');
        end);

    THorse.Post('/ping',
        procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
        var
            LBody: TJSONObject;
        begin
            LBody := Req.Body<TJSONObject>;
            Res.Send<TJSONObject>(LBody);
        end);

    THorse.Get('/cliente',
        procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
        var
            clientes : TJSONArray;
        begin
            try
                clientes := TJSONArray.Create;

                clientes.Add(TJSONObject.Create(TJSONPair.Create('nome','Paulo')));
                clientes.Add(TJSONObject.Create(TJSONPair.Create('nome','Sandra')));
                clientes.Add(TJSONObject.Create(TJSONPair.Create('nome','Matheus')));

                raise Exception.Create('Error de teste');

                Writeln('Request /Clientes');
                Res.Send<TJSONArray>(clientes);

            except on ex:exception do
            begin
                Writeln('Erro no servidor: ' + Ex.Message);
                Res.Send<TJSONObject>(TJSONObject.Create.AddPair('Mensagem: ', ex.Message)).Status(500);
            end;
            end;  // end try
        end);


    THorse.Listen(9000,procedure (Horse: THorse)
        begin
            writeln('Servidor ouvindo na porta: ' + Horse.Port.ToString);
        end);
end.
