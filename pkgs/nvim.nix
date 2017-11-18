{ pkgs }:
{
	customRC = ''
		syntax enable
		filetype on
		filetype plugin on
		filetype plugin indent on

		set number
		set norelativenumber
	'';
	vam.pluginDictionaries = [
		{
			names = [
				"vim-go"
                                "vim-nix"
                                "youcompleteme"
			];
		}
	];
}
