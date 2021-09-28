try {
    # Configuracoes do loop
    [int]$contador = 10
    [int]$hardcount = 0
    if ($hardcount -le 300) {
        do {
            VeracodeAPI.exe -vid $(veracodeID) -vkey $(veracodeAPIkey) -action GetPreScanResults -appid "$(appID)" >> "$env:LOCALAPPDATA\$(numeroVersao).txt"
            $retorno = Get-Content "$env:LOCALAPPDATA\$(numeroVersao).txt"
            Clear-Host
            if ($retorno -match "$(appID)") {
                break
            } else {
                $validacao = $true
                Write-Host "Validando se o Scan $(numeroVersao) já foi concluido"
                Write-Host "Por favor aguarde"
                Start-Sleep -s $contador
                $hardcount += $contador
            }
        } while ($validacao)
        # Pega o ID da build
        [string]$INFO = VeracodeAPI.exe -vid $(veracodeID) -vkey $(veracodeAPIkey) -action GetAppBuilds -appid "$(appID)"
        [xml]$INFO = $INFO.Replace(' xmlns=', ' _xmlns=')
        $buildINFO = $INFO.SelectSingleNode("//application[@app_id='$(appID)']")
        $buildID = $buildINFO.build.build_id
        # Gera o relatorio
        $out = VeracodeAPI.exe -vid $(veracodeID) -vkey $(veracodeAPIkey) -action summaryreport -buildid "$buildID" -outputfilepath "$env:LOCALAPPDATA\$(numeroVersao).xml"
        $securityINFO = [xml](Get-Content "$env:LOCALAPPDATA\$(numeroVersao).xml")

        # Recebendo informacoes
        Clear-Host
        $notaLetra = $securityINFO.summaryreport.'static-analysis'.rating
        $notaScore = $securityINFO.summaryreport.'static-analysis'.score
        $quemEnviou = $securityINFO.summaryreport.submitter
        $politica = $securityINFO.summaryreport.policy_name
        $complicanceStatus = $securityINFO.summaryreport.policy_compliance_status
        # Exibe os resultados
        Write-Host "Resultado do Scan: $(numeroVersao)"
        Write-Host "Nome App: $(veracodeAppName) - App ID: $(appID)"
        Write-Host "Enviado por: $quemEnviou"
        Write-Host "Politica: $politica"
        Write-Host "Nota: $notaLetra - Score: $notaScore - Resultado: $complicanceStatus"
        Write-Host "Lista dos problemas encontrados:"
        $levels = $securityINFO.summaryreport.severity.level
        foreach ($level in $levels) {
            $securityINFO.summaryreport.severity[$level].category
        }
    } else {
        Clear-Host
        Write-Host "Um erro aconteceu ao fazer o procedimento"
        Write-Host "Favor verificar a mensagem abaixo e comunicar o suporte"
        VeracodeAPI.exe -vid $(veracodeID) -vkey $(veracodeAPIkey) -action GetPreScanResults -appid "$(appID)"
    }
}
catch {
    $ErrorMessage = $_.Exception.Message # Recebe o erro
    Write-Host "Erro ao validar o Scan e pegar os dados"
    Write-Host "$ErrorMessage"
}