# Fazer download e configurar a API do Veracode para C#
# Ivo Dias

# Configuracoes
$urlDownloadAPI = "https://tools.veracode.com/integrations/API-Wrappers/C%23/bin/VeracodeC%23API.zip"

# Verifica se o Wrapper ja esta configurado
try {
    VeracodeAPI.exe
    Clear-Host
    Write-Host "Wrapper ja esta configurado"
}
catch {
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
         $novoPath = $env:Path + ";$Env:Programfiles/Veracode/API/.NET"
         Write-Host "##vso[task.setvariable variable=PATH;]$novoPath"
         Write-Host "Procedimento de configuracao concluido" 
     }
     catch {
         $ErrorMessage = $_.Exception.Message # Recebe o erro
         Write-Host "Erro ao fazer a configuracao da API"
         Write-Host "$ErrorMessage"
     }
}