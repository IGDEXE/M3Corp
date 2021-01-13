# Fazer download e configurar a API do Veracode para C#
# Ivo Dias

# Configuracoes
$urlPipeScan = "https://tools.veracode.com/integrations/API-Wrappers/C%23/bin/VeracodeC%23API.zip"

Clear-Host
try {
   # Faz o download
    Write-Host "Fazendo o download da ferramenta"
    Invoke-WebRequest -Uri "$urlPipeScan" -OutFile "$env:LOCALAPPDATA/VeracodeAPI.zip"
    # Descompacta o arquivo
    Write-Host "Descompactando.."
    Expand-Archive -Path "$env:LOCALAPPDATA/VeracodeAPI.zip" -DestinationPath "$Env:Programfiles/Veracode/API/.NET"
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