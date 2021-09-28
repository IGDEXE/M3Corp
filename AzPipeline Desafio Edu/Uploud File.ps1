# Faz o Uploud sem aguardar
try {
    # Caso exista um App ID, segue com os procedimentos
    if ($(appID)) {
        Clear-Host
        Write-Host "$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') | Perfil do aplicativo localizado com ID: $(appID)"
        # Faz o Uploud
        Write-Host "Iniciando Upload do arquivo"
        VeracodeAPI.exe -vid $(veracodeID) -vkey $(veracodeAPIkey) -action uploadfile -appid "$(appID)" -filepath "$(caminhoArquivo)"
        Write-Host "Procedimento concluido"
    } else {
        Write-Host "Não foi encontrado um App ID para o $(veracodeAppName)"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao iniciar Uploud"
    Write-Host "$ErrorMessage"
}