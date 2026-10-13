# Port Verade para Android

Este pacote contém arquivos de código e configuração, não um APK.

1. Extraia o ZIP.
2. No repositório Carlos833-syber/Funkin-Verade, envie TODOS os arquivos mantendo seus caminhos. Inclua a pasta oculta `.github`, a pasta `scripts` e os arquivos em `source`. Substitua o workflow `.github/workflows/Build.yml`.
3. Faça o commit e inicie uma nova execução em Actions → Build Verade Android APK → Run workflow.
4. Baixe o artefato Verade-Android-arm64 ao finalizar e extraia o APK.

Confira que `scripts/setup_android.sh`, `scripts/prepare_android_assets.py`, `source/backend/AndroidBootstrapState.hx` e `source/backend/MobileControls.hx` estão presentes no GitHub. O workflow verifica esses arquivos antes de instalar dependências. Não envie somente o workflow.

As pastas dentro deste pacote começam na raiz do repositório. Não crie outra pasta envolvendo todos os arquivos. Se usar Git localmente, você pode aplicar o patch com `git apply verade-android.patch` na raiz de um checkout limpo do commit base a327e43544e62675b0c0e88ec0138c898dfa50a5.

A instalação exige Android6.0+ com ARM64. Vídeos desativados. Controles por toque incluem menus, notas simultâneas, notas longas e pausa. Lua/HScript ativos. Teste no aparelho ainda necessário.

A chave de teste muda entre builds; uma atualização pode exigir desinstalar o APK anterior, apagando saves. Leia docs/ANDROID.md para detalhes. Nenhum commit ou workflow foi enviado/executado remotamente pelo agente.
