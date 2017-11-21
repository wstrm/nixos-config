{ pkgs }:
{
	customRC = ''
		syntax enable
		filetype on
		filetype plugin on
		filetype plugin indent on

		set number
		set norelativenumber
                set encoding=utf-8

                set statusline+=%{fugitive#statusline()}
                set statusline+=%#warningmsg#
                set statusline+=%{SyntasticStatuslineFlag()}
                set statusline+=%*

                let g:syntastic_always_populate_loc_list = 1
                let g:syntastic_auto_loc_list = 1
                let g:syntastic_check_on_open = 1
                let g:syntastic_check_on_wq = 0

                let g:go_fmt_command = "goimports"
	'';
	vam.pluginDictionaries = [
		{
			names = [
				"vim-go"
                                "vim-nix"
                                "youcompleteme"
                                "nerdtree"
                                "syntastic"
                                "tagbar"
                                "deoplete-go"
                                "goyo"
                                "commentary"
                                "fugitive"
			];
		}
	];
}
