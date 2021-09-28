# PipelineScan
# Ivo Dias

<#
    Visão Geral:
        A ideia desse script é facilitar o uso da ferramenta Pipeline Scan da Veracode
        Ele é bem simples, e tem como ideia servir mais de base para que você possa criar seu proprio codigo
        Recomendo que pesquise sobre o que pode fazer com a ferramenta, mas basicamente, o que ela vai fazer é validar arquivo por arquivo, em busca de falhas de segurança
        Como ela é feita em Java, você precisa ter ele previamente instalado

    Estrutura:
        Inicialmente temos uma função para fazer a validação, para utilizar ela, vamos precisar informar algumas coisas:
            Arquivo -> Um objeto que representa cada um dos arquivos que estão na pasta, vamos obter eles com a função Get-ChildItem
            Veracode ID e API Key -> São informações da Veracode que precisa para utilizar a ferramenta, consegue elas em seu portal da Veracode
            Pasta Ferramenta -> Caminho da pasta onde está o arquivo jar da ferramenta
        Utilizei a abordagem da função, pois nos permite fazer a validação de uma forma mais elegante e simplifica o codigo, já que podemos ter muita repetição dessa etapa

        Na etapa de configurações, precisa informar alguns dados, conforme explicado na seção
        A instalação e download, será feita na mesma pasta do projeto, isso provavelmente não é o ideal, mas para o cenario onde eu precisei criar esse script (alguns exemplos de uso que precisei fazer)
        Facilitava ter uma resposta generica para cada um dos projetos, mas caso queria alterar, pode utilizar a abordagem de já deixar ele em um pasta pré determinada
        Depois disso, o script vai listar todos os objetos que passam pelo filtro que definimos, armazena-los numa variavel e passa-los um a um, para a função que criamos
#>
function PipeScan {
    param (
        [parameter(position=0,Mandatory=$True)]
        $veracodeID,
        [parameter(position=1,Mandatory=$True)]
        $veracodeAPIkey,
        [parameter(position=2,Mandatory=$True)]
        $tipofiltro,
        [parameter(position=3)]
        $pastaferramenta  = "./PipeScan",
        [parameter(position=4)]
        $urlPipeScan = "https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip" # Link para fazer o download da ferramenta, conforme documentação
    )

    # Funcao para validar os arquivos
    function FileScan {
        # Define os parametros que serao utilizados
        param (
            $arquivo,
            $veracodeID,
            $veracodeAPIkey,
            $pastaferramenta

        )
        try {
            # Filtra os objetos
            $nomearquivo = $arquivo.name # Recebe o nome do arquivo, exemplo: Foto123.png
            $caminhoarquivo = $arquivo.fullname # Recebe o caminho do arquivo: C:/Fotos/Foto123.png
            # Scan
            java -jar "$pastaferramenta/pipeline-scan.jar" -f $caminhoarquivo -vid $veracodeID -vkey $veracodeAPIkey # Faz a validação conforme as orientações do fabricante
        }
        catch {
            # Esse bloco é ativado no caso de algum problema ocorrer no uso dos comandos anteriores
            # Recebendo o erro e exibindo ele, parando a execução
            $ErrorMessage = $_.Exception.Message # Recebe o erro
            # Mostra uma mensagem personalizada
            Write-Host "Erro ao verificar o arquivo: $nomearquivo"
            Write-Host "$ErrorMessage"
        }
    }

    # Instalacao da ferramenta
    try {
        # Verifica se ja tem o PipelineScan
        $existe = Test-Path -Path "$pastaferramenta"
        if ($Existe -eq $false) {
            # Faz o download
            Invoke-WebRequest -Uri "$urlPipeScan" -OutFile "$env:userprofile/Download/pipescan.zip"
            # Extrai o arquivo
            Expand-Archive -Path "$env:userprofile/Download/pipescan.zip" -DestinationPath "$pastaferramenta"
        }
        # Caso ela ja esteja instalada, nada é feito
    }
    catch {
        $ErrorMessage = $_.Exception.Message # Recebe o erro
        Write-Host "Erro ao fazer o download do Pipeline Scan"
        Write-Host "$ErrorMessage"
    }

    # Filtra os arquivos
    $arquivos = Get-ChildItem "./*" -Include "*.$tipofiltro" -recurse # Recebe todos os arquivos do tipo especificado que estejam na mesma pasta do script
    # Faz a verificacao
    Clear-Host # Limpa a tela
    foreach ($arquivo in $arquivos) {
        FileScan $arquivo $veracodeID $veracodeAPIkey $pastaferramenta # Valida arquivo por arquivo
    }
}