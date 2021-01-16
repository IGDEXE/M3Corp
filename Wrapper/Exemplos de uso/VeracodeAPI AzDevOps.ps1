# Fazer download e configurar a API do Veracode para C#
# Ivo Dias

# Configuracoes
$urlDownloadAPI = "https://tools.veracode.com/integrations/API-Wrappers/C%23/bin/VeracodeC%23API.zip"
$veracodeID = ""
$veracodeAPIkey = ""
$appID = ""
$caminhoArquivo = ""
$numeroVersao = Get-Date -Format hhmmssddMMyy

Clear-Host
try {
   # Faz o download
    Write-Host "Fazendo o download da ferramenta"
    Invoke-WebRequest -Uri "$urlDownloadAPI" -OutFile "$env:LOCALAPPDATA/VeracodeAPI.zip"
    # Descompacta o arquivo
    Write-Host "Descompactando.."
    Expand-Archive -Path "$env:LOCALAPPDATA/VeracodeAPI.zip" -DestinationPath "$Env:Programfiles/Veracode/API/.NET"
    # Altera o nome do arquivo
    Rename-Item -Path "$Env:Programfiles/Veracode/API/.NET/VeracodeC#API.exe" -NewName "$Env:Programfiles/Veracode/API/.NET/VeracodeAPI.exe"
    # Adiciona o EXE ao caminho do Path do sistema
    Write-Host "Adicionando ao Path do sistema"
    $Env:PATH += ";$Env:Programfiles/Veracode/API/.NET"
    Write-Host "Procedimento de configuracao concluido"
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao fazer a configuracao da API"
    Write-Host "$ErrorMessage"
}

# Faz a verificacao
try {
    VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScanByAppId -appid "$appID" -filepath "$caminhoArquivo" -version $numeroVersao
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao fazer o processo de Uploud e Scan"
    Write-Host "$ErrorMessage"
}