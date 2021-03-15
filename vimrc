" __  __               _                    
"|  \/  |_   _  __   _(_)_ __ ___  _ __ ___ 
"| |\/| | | | | \ \ / / | '_ ` _ \| '__/ __|
"| |  | | |_| |  \ V /| | | | | | | | | (__ 
"|_|  |_|\__, |   \_/ |_|_| |_| |_|_|  \___|
"        |___/                              
"Daniel dossantosjdf@gmail.com


" Configuration générale
" =============================
set nocompatible           "Ne pas utiliser le mode de compatibilité avec vi
set number                 "Afficher les numéros de ligne
set shell=/bin/bash        "Shell par défaut
filetype plugin on
filetype plugin indent on  "Activation de l'indentation
set laststatus=2           "Menu du bas plus claire
colorscheme murphy
set title                  "Affiche en titre le fichier en cours de modification
syntax on
set encoding=utf-8
set shiftwidth=2           "Indentation configurée à deux espaces
set hlsearch               "Surligne tous les résultats de la recherche
set smartindent            "Améliore l'auto-indentation
set showmatch              "Détection des parenthèses ouvrantes et fermantes
set wildmenu               
set wildmode=longest:full,full "Simplifie la complétion des commandes vim

"Abréviations
ab apt apt-get

"Fermeture automatique des parenthèses
imap { {}<left>
imap ( ()<left>
imap [ []<left>

" Modèle d'entête pour la création de scripts Bash
" =============================
function Bash()
  0put =\"\#!/bin/bash\"|$
  1put =\"\#-*- coding: UTF8 -*-\"|$
  2put =\"\"|$
  3put =\"\#************************************************#\"|$
  4put =\"\# Nom:                                           \"|$
  5put =\"\# Auteur:  Daniel dossantosjdf@gmail.com         #\"|$
  6put =\"\# Date:                                          \"|$
  7put =\"\# Version: 1.0                                   #\"|$
  8put =\"\#                                                \"|$
  9put =\"\# Rôle:     Que fait le script?                  #\"|$
  10put =\"\# Usage:                                         \"|$
  11put =\"\# Limites:  limites d'utilisation                #\"|$
  12put =\"\# Contraintes:                                   \"|$
  13put =\"\# Licence:                                       #\"|$
  14put =\"\#************************************************#\"|$
  15put =\"\"|$
  16put =\"\### Includes ###\"|$
  17put =\"\"|$
  18put =\"\### Fonctions ###\"|$
  19put =\"\"|$
  20put =\"\### Variables ###\"|$
  21put =\"\"|$
  22put =\"\### Main ###\"|$
  23put =\"\"|$
  24put =\"\### Clean ###\"|$
endfunction

"Appel de la fonction
autocmd BufNewFile *.sh,*.bash call Bash()
"Ajout du nom du script
autocmd BufNewFile *.sh,*.bash exe "1," . 14 . "g/Nom:/s//Nom: " .expand("%")
"Ajout de la date de création
autocmd bufnewfile *.sh,*.bash exe "1," . 14 . "g/Date:/s//Date: " .strftime("%c")

autocmd bufnewfile *.sh,*.bash exe "1," . 14 . "g#Usage:#s##Usage: ./" .expand("%")
"Écriture des données en buffer sur le fichier
autocmd Bufwritepre,filewritepre *.sh,*.bash exe "normal ma"
"Ajout du droit d’exécution
autocmd BufWritePost *.sh silent execute "! sudo chmod u+x %"

"Raccourci faisant appel à la fonction Bash
nnoremap <F2> :call Bash()<CR>

" Fichiers Markdown
" =============================
autocmd BufNewFile,BufRead *.markdown set filetype=markdown
autocmd BufNewFile,BufRead *.md set filetype=markdown

" Fichiers Bash
" =============================
autocmd BufNewFile,BufRead ~/.bash/* setfiletype sh

" Fichiers YAML
" =============================
autocmd BufRead,BufNewFile *.yml setfiletype yaml

" Backups
" =============================
set backup "Activation des backups
set backupdir=$HOME/.vim/backups "Dossier des backups
set bex=.bak "Extension des fichiers de backup

" Annuler, Rétablir
" =============================
"Permet d'annuler ou rétablir les modifications, après la fermeture de vim ou après un redémarrage de l'ordinateur
if has('persistent_undo') "Vérification de la version de vim
  set undodir=$HOME/.vim/undo "Dossier ou sera stocké les fichiers
  set undofile "Activation de la configuration
endif
