# Verade para Android

Port experimental para celulares **ARM64 com Android 6.0 ou superior**. Android de 32 bits não é suportado. Compilação e instalação não substituem o teste do jogo no aparelho.

## Aplicar os arquivos no GitHub

Extraia `verade-android-port.zip` e envie **todos** os arquivos para a raiz do repositório Funkin-Verade, preservando as pastas. Substitua `.github/workflows/Build.yml` e os arquivos existentes. As pastas `scripts` e os arquivos `source/backend/AndroidBootstrapState.hx` e `source/backend/MobileControls.hx` também são necessários.

Não envie o ZIP inteiro como um arquivo do repositório. Confira que `scripts/prepare_android_assets.py` está visível no GitHub após o commit. O manifesto `assets/android-files.json` é gerado durante a compilação e não precisa ser enviado.

## Gerar o APK

1. Abra **Actions → Build Verade Android APK → Run workflow** no commit com todos os arquivos do port.
2. Aguarde a conclusão. O primeiro build instala dependências e compila o C++; pode levar dezenas de minutos.
3. Baixe o artefato **Verade-Android-arm64**, extraia o APK e instale no celular.
4. Se falhar, baixe **Verade-build-logs** ou envie o trecho do primeiro erro no log.

A assinatura usa uma chave de teste nova a cada execução. Para instalar outro build, pode ser necessário desinstalar o anterior, apagando seus saves. Esta configuração não prepara publicação na Play Store.

## Controles e arquivos

- Menus: quatro setas, **OK** e **VOLTAR**.
- Música: quatro botões para notas, com toques simultâneos e notas longas; **PAUSA** abre o menu.
- Lua e HScript continuam ativos; os recursos usados pelos carregadores de arquivos são copiados do APK para o armazenamento privado do aplicativo na primeira abertura e após mudanças nos recursos.
- Não são necessárias permissões de acesso ao armazenamento compartilhado. Reserve espaço para o APK instalado e uma cópia local dos recursos do jogo. A primeira abertura mostra o progresso da cópia.
- Vídeos e Discord ficam desativados no Android. A tradução do repositório permanece habilitada. O carregamento usa uma thread de trabalho no Android.
- Easter eggs que exigem digitar letras e os editores continuam dependendo de teclado; não há teclado virtual nesta versão.

## Compilar localmente

Requer Haxe 4.3.6, Neko, Java 17, Android SDK 34, build tools 34.0.0 e NDK 21.4.7075529.

```bash
bash scripts/setup_android.sh
python3 scripts/prepare_android_assets.py
haxelib run lime config ANDROID_SDK "$ANDROID_HOME"
haxelib run lime config ANDROID_NDK_ROOT "$ANDROID_HOME/ndk/21.4.7075529"
haxelib run lime config JAVA_HOME "$JAVA_HOME"
haxelib run lime config ANDROID_SETUP true
haxelib run lime build android -release -arm64
```

O script fixa as dependências de acordo com `setup/unix.sh`, além do hxcpp. O workflow alinha, assina e verifica o APK. Sem certificado de distribuição configurado, Lime pode produzir o APK na pasta `debug`, mesmo com `-release`; o workflow localiza o APK gerado em vez de presumir a pasta.

## Testar no celular

Verifique a primeira abertura, a escolha de luzes piscantes, título, história, música disponível, notas simultâneas e longas, pausa/retorno, game over, configurações e galeria. Confirme áudio, animações e desempenho. Estes fluxos ainda precisam de teste em dispositivo real.

## Verificação do port

O código final compilou para ARM64 e gerou um APK alinhado e assinado neste ambiente. A assinatura, os metadados e os445 recursos do manifesto foram verificados. O APK ocupa cerca de253MiB. Ainda não houve teste de jogabilidade em aparelho Android.
