# Configuracoes
$veracodeID = ""
$veracodeAPIkey = ""
$veracodeAppName = ""
$appID = $Null
$caminhoArquivo = ""

try {
    # Gera um ID para a versao
    $numeroVersao = Get-Date -Format hhmmssddMMyy
    # Recebe o App ID com base no nome da aplicacao dentro do Veracode
    [xml]$INFO = $(VeracodeAPI.exe -vid "$veracodeID" -vkey "$veracodeAPIkey" -action GetAppList | Select-String -Pattern $veracodeAppName)
    # Filtra o App ID
    $appID = $INFO.app.app_id
    # Caso exista um App ID, segue com os procedimentos
    if ($appID) {
        Clear-Host
        Write-Host "$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') | Perfil do aplicativo localizado com ID: $appID"
        # Faz o Uploud and Scan
        Write-Host "Iniciando Upload and Scan"
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScanByAppId -appid "$appID" -filepath "$caminhoArquivo" -version $numeroVersao
        Write-Host "Procedimento concluido"
    } else {
        Write-Host "Não foi encontrado um App ID para o $veracodeAppName"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao iniciar Uploud and Scan"
    Write-Host "$ErrorMessage"
}

try {
    do {
        VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action GetPreScanResults -appid "$appID" >> "$env:LOCALAPPDATA\$numeroVersao.txt"
        $retorno = Get-Content "$env:LOCALAPPDATA\$numeroVersao.txt"
        Clear-Host
        if ($retorno -match "$appID") {
            break
        } else {
            $validacao = $true
            Write-Host "Validando se o Scan $numeroVersao já foi concluido"
            Write-Host "Por favor aguarde"
            Start-Sleep -s 10
        }
    } while ($validacao)
    # Pega o ID da build
    [string]$INFO = VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action GetAppBuilds -appid "$appID"
    [xml]$INFO = $INFO.Replace(' xmlns=', ' _xmlns=')
    $buildINFO = $INFO.SelectSingleNode("//application[@app_id='$appId']")
    $buildID = $buildINFO.build.build_id
    # Gera o relatorio
    $out = VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action summaryreport -buildid "$buildID" -outputfilepath "$env:LOCALAPPDATA\$numeroVersao.xml"
    $securityINFO = [xml](Get-Content "$env:LOCALAPPDATA\$numeroVersao.xml")
    $securityINFO.summaryreport
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao validar o Scan e pegar os dados"
    Write-Host "$ErrorMessage"
}