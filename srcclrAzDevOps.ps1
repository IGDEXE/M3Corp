# Configurações
$caminhoArquivo = ""
# Recebe o token
$Env:SRCCLR_API_TOKEN = "$(APITOKEN)"
# Faz o download do agente
iex ((New-Object System.Net.WebClient).DownloadString("https://download.srcclr.com/ci.ps1"))
# Faz a verificacao
srcclr scan "$caminhoArquivo"