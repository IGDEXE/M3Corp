# Configuracoes
$veracodeID = ""
$veracodeAPIkey = ""
$appID = ""
$caminhoArquivo = ""
$numeroVersao = Get-Date -Format hhmmssddMMyy


# Faz o Uploud e a verificacao
VeracodeAPI.exe -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScanByAppId -appid "$appID" -filepath "$caminhoArquivo" -version $numeroVersao