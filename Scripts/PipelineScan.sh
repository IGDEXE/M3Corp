# Configuracoes
urlPipeScan="https://downloads.veracode.com/securityscan/pipeline-scan-LATEST.zip"
veracodeID=""
veracodeAPIkey=""
caminhoArquivo="./teste.zip"

# Faz o download da ferramenta
curl -o pipescan.zip $urlPipeScan
# Descompacta a ferramenta
unzip -o pipescan.zip -d "./"
# Faz a analise
java -jar "pipeline-scan.jar" -f "$caminhoArquivo" -vid $veracodeID -vkey $veracodeAPIkey