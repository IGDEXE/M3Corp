# Recebe o App ID com base no nome da aplicacao dentro do Veracode
[xml]$INFO = $(VeracodeAPI.exe -vid "$(veracodeID)" -vkey "$(veracodeAPIkey)" -action GetAppList | Select-String -Pattern $(veracodeAppName))
# Filtra o App ID
$appID = $INFO.app.app_id
# Gera um ID para a versao
$numeroVersao = Get-Date -Format hhmmssddMMyy
# Publica as variaveis para o Az Pipeline
Write-Host "##vso[task.setvariable variable=appID;]$appID"
Write-Host "##vso[task.setvariable variable=numeroVersao;]$numeroVersao"

# Faz o Uploud and Scan
try {
    # Caso exista um App ID, segue com os procedimentos
    if ($appID) {
        Clear-Host
        Write-Host "$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') | Perfil do aplicativo localizado com ID: $appID"
        # Faz o Uploud and Scan
        Write-Host "Iniciando Upload and Scan"
        VeracodeAPI.exe -vid $(veracodeID) -vkey $(veracodeAPIkey) -action UploadAndScanByAppId -appid "$appID" -filepath "$(caminhoArquivo)" -version $numeroVersao
        Write-Host "Procedimento concluido"
    } else {
        Write-Host "Não foi encontrado um App ID para o $(veracodeAppName)"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao iniciar Uploud and Scan"
    Write-Host "$ErrorMessage"
}