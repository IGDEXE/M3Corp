# Configuracoes
urlDownloadAPI="https://repo1.maven.org/maven2/com/veracode/vosp/api/wrappers/vosp-api-wrappers-java/20.12.7.3/vosp-api-wrappers-java-20.12.7.3.jar"
veracodeID=""
veracodeAPIkey=""
appID=""
caminhoArquivo=""
numeroVersao=$(date +%H%M%s%d%m%y)

# Faz o download da ferramenta
curl -L -o VeracodeJavaAPI.jar $urlDownloadAPI
# Utiliza a ferramenta
java -jar VeracodeJavaAPI.jar -vid $veracodeID -vkey $veracodeAPIkey -action UploadAndScanByAppId -appid "$appID" -filepath "$caminhoArquivo" -version $numeroVersao