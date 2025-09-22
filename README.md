## IT Utils

Script para tarefas comuns de Suporte de TI em Windows.

### Requisitos
- Windows 10/11
- PowerShell (padrão do Windows)
- Para algumas opções: executar como Administrador (UAC)
- Para atualizar apps: `winget` (App Installer da Microsoft Store)

### Como usar
1. Baixe/clon​e este repositório.
2. Clique duas vezes em `ITUtils.bat` ou execute via Prompt/PowerShell.
3. Para recursos que exigem privilégios: clique com o botão direito e escolha “Executar como administrador”.

### Principais opções
- 1: Limpar cache DNS
- 2: Limpar arquivos temporários
- 3: Testar conexão com a Internet (ping 8.8.8.8)
- 4: Verificar/Reparar disco (chkdsk C: /f /r)
- 5: Verificar/Reparar arquivos do Windows (SFC)
- 6–8: Acessos rápidos (Gerenciador de Tarefas, Windows Update, Painel de Controle)
- 9: Diagnóstico de Memória
- 10: Desfragmentar disco (escolha da unidade)
- 11: DISM (ScanHealth/RestoreHealth)
- 12: Criar ponto de restauração (elevado)
- 13: Abrir Logs de Eventos
- 14: Informações do sistema (`systeminfo`)
- 15: Atualizar apps via winget (elevado)
- 16: Limpar Spooler de Impressão (elevado)
- 17: Relatórios de energia e bateria (HTML na Área de Trabalho, abre no navegador padrão)
- 18: Coletar logs (System/Application + systeminfo em ZIP na Área de Trabalho) [elevado]
- 19: Reset de rede (Winsock/IP + flush DNS) [elevado]
- 20: Windows Defender – verificação rápida [elevado]

Obs.: “Elevado” indica que será solicitado UAC para executar como Administrador.

### Dicas e solução de problemas
- Ponto de restauração (12): habilite a Proteção do Sistema para a unidade do sistema (`SystemPropertiesProtection.exe`).
- DISM/SFC (11/5): execute como Administrador e aguarde a conclusão.
- Winget (15): instale o “App Installer” da Microsoft Store se `winget` não estiver disponível.
- Relatórios (17): os arquivos são salvos na Área de Trabalho como `energy-report.html` e `battery-report.html`.

### Segurança
O script executa comandos administrativos. Revise e adapte às políticas da sua organização antes de distribuir.