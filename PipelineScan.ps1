# PipelineScan

# Funcao para validar os arquivos
function PipeScan {
    param (
        $arquivo,
        $veracodeID,
        $veracodeAPIkey

    )
    try {
        # Filtra os objetos
        $nomearquivo = $arquivo.name
        $caminhoarquivo = $arquivo.fullname
        # Scan
        java -jar "./PipeScan/pipeline-scan.jar" -f $caminhoarquivo -vid $veracodeID -vkey $veracodeAPIkey
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Erro ao verificar o arquivo: $nomearquivo"
        Write-Host "$ErrorMessage"
    }
}

# Configuracoes
$urlPipeScan = "https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip"
$veracodeID = ""
$veracodeAPIkey = ""
$tipofiltro = "jar"

try {
    # Verifica se ja tem o PipelineScan
    $existe = Test-Path -Path "./PipeScan"
    if ($Existe -eq $false) {
        # Faz o download
        Invoke-WebRequest -Uri "$urlPipeScan" -OutFile "./pipescan.zip"
        # Extrai o arquivo
        Expand-Archive -Path "./pipescan.zip" -DestinationPath "./PipeScan"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao fazer o download do Pipeline Scan"
    Write-Host "$ErrorMessage"
}

# Filtra os arquivos
$arquivos = Get-ChildItem "./*" -Include "*.$tipofiltro" -recurse
# Faz a verificacao
Clear-Host
foreach ($arquivo in $arquivos) {
    PipeScan $arquivo $veracodeID $veracodeAPIkey
}