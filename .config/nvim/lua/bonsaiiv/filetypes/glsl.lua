
vim.api.nvim_create_autocmd(
	{"BufEnter"},
	{
		pattern = ("*.vert,*.frag,*.geom,*.comp,*.tese,*.tesc"),
		callback = function()
			vim.opt.filetype='glsl'
		end
	}
)
