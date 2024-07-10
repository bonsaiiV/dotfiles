return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		main = 'nvim-treesitter.configs',
		opts = { -- require 'nvim-treesitter'.setup()
			ensure_installed = {
				'vimdoc',
				'gitignore', 'gitcommit',
				'diff',
				'fish', 'bash', 'awk',
				'lua', 'rust',
				'markdown',
				'ledger',
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {enable = true},
		},
	},
}
