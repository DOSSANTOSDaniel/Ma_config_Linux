# Ma_config_Linux
Configurations sous Linux

| Dossiers | Descriptions |
|:--:|:--:|
| apps | Applications que j'ai l’habitude d'utiliser|
| config_vimrc_bashrc | Ma configuration de .bashrc et .vimrc |
| printer | Configuration de mon imprimante EPSON ET-3750 |

```
         +--------------> app_kali_docker.sh : Utilisé pour installer les outils Kali sur Debian.
+----+   |
|apps|---+--------------> apps_desktop.sh : Choix d'applications ou commandes desktop.
+----+   |
         +--------------> apps_server.sh : Choix d'applications ou commandes server.


                        +-----------> apply_conf.sh : Automatise la configuration.
+-------------------+   |
|config_vimrc_bashrc|---+-----------> config_vimrc : Configuration .vimrc.
+-------------------+   |
                        +-----------> config_bashrc : Configuration .bashrc.

 
            +-----------> DEB : Paquets drivers et utilitaires pour Linux deb.
+-------+   |
|printer|---+-----------> RPM : Paquets drivers et utilitaires pour Linux rpm.
+-------+   |
            +-----------> ep_printer.sh : Automatisation de l'installation.

```

