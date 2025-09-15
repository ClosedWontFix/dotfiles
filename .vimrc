"   .vimrc
"   Dan Borkowski

" Minimal .vimrc using EditorConfig for formatting

" Enable filetype detection (needed for plugins and syntax)
filetype plugin indent on
syntax on

" Load EditorConfig settings if the plugin is installed
if exists('+editorconfig')
  " For Neovim 0.9+ which has built-in support
  let g:editorconfig = 1
else
  " For Vim: install editorconfig-vim plugin to make this work
  " https://github.com/editorconfig/editorconfig-vim
endif

" Keep vimrc lean — don’t set tabstop/shiftwidth/expandtab here
" Formatting rules are now handled by .editorconfig

" Some sane defaults that EditorConfig won’t cover:
set number              " show line numbers
set ruler               " show cursor position
set ignorecase smartcase " better searching
set incsearch           " incremental search
set hlsearch            " highlight search matches
set backspace=indent,eol,start " make backspace behave intuitively
" ---------- Core style defaults ----------
set encoding=utf-8
set fileformat=unix
set nowrap
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set textwidth=0
set nofixendofline          " don't force newline; keep as-is
set list                    " visualize whitespace
set listchars=tab:»·,trail:·,extends:…,precedes:…

" Trim trailing whitespace on write (safe for most files)
augroup TrimWhitespace
  autocmd!
  autocmd BufWritePre * if &modifiable | silent! %s/\s\+$//e | endif
augroup END

" ---------- Filetype-specific indentation ----------
augroup IndentByFiletype
  autocmd!
  autocmd FileType python          setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType make            setlocal noexpandtab shiftwidth=8 tabstop=8 softtabstop=0
  autocmd FileType yaml            setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType toml,lua        setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType json,jsonc      setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType dockerfile      setlocal expandtab shiftwidth=4 tabstop=4
  autocmd FileType sh,bash,zsh     setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType perl            setlocal expandtab shiftwidth=4 tabstop=4
  autocmd FileType gitignore,conf  setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType tmux            setlocal expandtab shiftwidth=2 tabstop=2
augroup END

" ---------- Filetype detection helpers ----------
" Treat special config files as their languages
augroup ExtraFtDetect
  autocmd!
  autocmd BufNewFile,BufRead .tmux.conf,*.tmux      setfiletype tmux
  autocmd BufNewFile,BufRead lynx.cfg,.lynx.cfg     setfiletype conf
  autocmd BufNewFile,BufRead .gitignore,*.ignore    setfiletype gitignore
  autocmd BufNewFile,BufRead Dockerfile*,*.dockerfile setfiletype dockerfile
augroup END

if has('gui_running')
  set background=light
else
  set background=dark
endif

set t_Co=256

" Blink cursor on error instead of beeping
set visualbell

" Whitespace
set wrap
set formatoptions=tcqrn1

"set softtabstop=4

"set shiftwidth=4
"set noshiftround

" Enable mouse
set mouse=r

" Enable spellcheck language
set spelllang=en_us

" Encoding
set encoding=utf-8

" Enable syntax highlighting
"syntax enable

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k
"inoremap <C-^> <C-o><C-^>


" === Auto-insert shebang + modeline headers for new files ===

" POSIX sh
autocmd BufNewFile *.sh 0put =["#!/bin/sh", "# -*- sh -*-", "# vim: ft=sh", ""]

" Bash
autocmd BufNewFile *.bash 0put =["#!/usr/bin/env bash", "# -*- bash -*-", "# vim: ft=bash", ""]

" Zsh
autocmd BufNewFile *.zsh 0put =["#!/usr/bin/env zsh", "# -*- zsh -*-", "# vim: ft=zsh", ""]

" Python
autocmd BufNewFile *.py 0put =["#!/usr/bin/env python3", "# -*- python -*-", "# vim: ft=python", ""]

" Perl
autocmd BufNewFile *.pl,*.pm,*.t 0put =["#!/usr/bin/env perl", "# -*- perl -*-", "# vim: ft=perl", ""]

" Dockerfile
autocmd BufNewFile Dockerfile,*.Dockerfile 0put =["# -*- dockerfile -*-", "# vim: ft=dockerfile", ""]

" Docker Compose (YAML)
autocmd BufNewFile docker-compose.yml,docker-compose.yaml,compose.yml,compose.yaml 0put =["# -*- yaml -*-", "# vim: ft=yaml", ""]

" YAML (general)
autocmd BufNewFile *.yml,*.yaml 0put =["# -*- yaml -*-", "# vim: ft=yaml", ""]

" TOML
autocmd BufNewFile *.toml 0put =["# -*- conf-toml -*-", "# vim: ft=toml", ""]

" JSON
autocmd BufNewFile *.json 0put =["# -*- json -*-", "# vim: ft=json", ""]

" INI-style
autocmd BufNewFile *.ini,.editorconfig,.gitconfig 0put =["# -*- conf -*-", "# vim: ft=dosini", ""]

" Lua scripts
autocmd BufNewFile *.lua 0put =["#!/usr/bin/env lua", "# -*- lua -*-", "# vim: ft=lua", ""]

" Make scripts executable on save if they start with a shebang
augroup ShebangChmod
  autocmd!
  autocmd BufWritePost * if has('unix') && getline(1) =~ '^#!' | silent! execute '!' . 'chmod u+x -- ' . shellescape(expand('%:p')) | redraw! | endif
augroup END



"  Settings for yaml files
"au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
"autocmd FileType yaml setlocal ai ts=2 sts=2 sw=2 nu et cuc cul syntax
"
"" Settings for toml files
"au! BufNewFile,BufReadPost *.{toml} set filetype=toml
"autocmd FileType toml setlocal ai ts=2 sts=2 sw=2 nu et cuc cul syntax
"
"" Settings for shell scripts
"au! BufNewFile,BufReadPost *.{sh} set filetype=bash
"autocmd BufNewFile *.{sh} so ~/.vim/headers/bash
"autocmd BufNewFile *.{sh} exe "1," . 20 . "g/FILE/s//Script Name: " .expand("%")
"autocmd BufNewFile *.{sh} exe "1," . 20 . "g/AUTHOR/s//Dan Borkowski"
"autocmd BufNewFile *.{sh} exe "1," . 20 . "g/EMAIL/s//Email: closedwontfix@protonmail.com"
"autocmd BufNewFile *.{sh} exe "1," . 20 . "g/CREATED/s//Created: " .strftime("%m-%d-%Y") | normal G
"autocmd FileType bash setlocal ai ts=4 sw=4 sts=0 syntax noet
"
"" Settings for python scripts
"au! BufNewFile,BufReadPost *.{py,pyc} set filetype=python
"autocmd FileType python setlocal ai ts=2 sw=2 sts=2 et syntax
"
"" Settings for xml files
"autocmd FileType xml setlocal ts=2 sw=2 sts=2 et syntax
"
"" Xresources files
"au! BufNewFile,BufReadPost .Xresources.d/* setf xdefaults
"
"" Enable spell checking for mutt
"autocmd FileType mail setlocal tw=78 spell noai
"
"" Settings for asciidoc
"au! BufNewFile,BufReadPost *.{adoc} set filetype=asciidoc
"autocmd FileType asciidoc setlocal ts=2 sw=2 sts=2 syntax spell noai
"
"" Enable spell checking for Git commit messages
"autocmd BufReadPost COMMIT_EDITMSG setlocal spell tw=78
"
"" Add header for notes, and move cursor to end of file
"autocmd BufNewFile *-note.md so ~/.vim/headers/notes
"autocmd BufNewFile *-note.md exe "1," . 6 . "g/created.*/s//created: " .strftime("%FT%T%z")
"autocmd BufNewFile,BufWrite *-note.md exe "1," . 6 . "g/modified.*/s//modified: " .strftime("%FT%T%z")
"autocmd BufNewFile,BufReadPost *-note.md setlocal spell ai tw=78 | normal G
"
"" Enable spell checking for mutt
"autocmd FileType Dockerfile setlocal ts=4 sw=4 sts=4 tw=78 spell noai



"
"" https://github.com/junegunn/vim-plug
""
"" Install vim-plug if not found
"if empty(glob('~/.vim/autoload/plug.vim'))
"  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"endif
"
"" Run PlugInstall if there are missing plugins
"autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
"  \| PlugInstall --sync | source $MYVIMRC
"\| endif
"
"
"" Plugins will be downloaded under the specified directory.
"call plug#begin('~/.vim/plugged')
"
"Plug 'preservim/nerdtree'
"
"" Install ALE (Asynchronous Lint Engine)
"" https://github.com/dense-analysis/ale
"Plug 'dense-analysis/ale'
"
"" Install Ansible plugin
"" https://github.com/pearofducks/ansible-vim
"Plug 'pearofducks/ansible-vim'
"
"" https://github.com/habamax/vim-asciidoctor
""Plug 'habamax/vim-asciidoctor'
"
"" Install unicode.vim
"" https://github.com/chrisbra/unicode.vim
""Plug 'chrisbra/unicode.vim'
"
"" List ends here. Plugins become visible to Vim after this call.
"call plug#end()
"
"" Set Keybinding
"map <C-n> :NERDTreeToggle<CR>
"
"
"let g:NERDTreeWinPos = 'left'
