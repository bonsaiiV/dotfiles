local opt = vim.opt
local api = vim.api
local isdir = vim.fn.isdirectory
vim.g.mapleader = ' '
local join = vim.fs.joinpath

opt.relativenumber = true
opt.scrolloff = 4
opt.shell='/bin/fish'
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- If netrw was already loaded, clear this augroup
local auGroup =  api.nvim_create_augroup("FileExplorer", { clear = true })
local function show_mailbox ()
	local bufnr = api.nvim_get_current_buf()
	local cur_dir = join(api.nvim_buf_get_name(bufnr), vim.api.nvim_get_current_line(), "cur")
	local subjects = {}
	for mail_filename in vim.fs.dir(cur_dir) do
		local mail_path = join(cur_dir, mail_filename)
		local mail_file = assert(io.open(mail_path, "r"))
		local done = false
		repeat
			local line = mail_file:read("*l")
			if line == "" then
				done = true
			else
				local start, _ = string.find(line, "Subject:")
				if start == 1 then
					table.insert(subjects, line)
					done = true
				end
			end
		until done

	end
	local buf = api.nvim_create_buf(true, false)
	if buf == 0 then
		print("failed to crate buffer")
		return
	end
	vim.bo[buf].buftype='nofile'
	api.nvim_buf_set_lines(buf, 0, 0, false, subjects)
    api.nvim_open_win(buf, true, {relative = 'win', row=3, col=10, width=100, height=12})
end
api.nvim_create_autocmd("VimEnter", {
	desc = "Setup",
	group = auGroup,
	pattern = "*",
	callback = function ()
		local bufnr = api.nvim_get_current_buf()
		local bufname = api.nvim_buf_get_name(bufnr)
		if vim.fn.isdirectory(bufname) == 0 then
			error("Maildir not found")
		end
		vim.bo[bufnr].buftype='nofile'
		vim.bo[bufnr].filetype = "Mail"

		local lines = {}
		for entry in vim.fs.dir(bufname, {}) do
			local mailbox_path = join(bufname,entry)
			if vim.fn.isdirectory(mailbox_path) ~= 0 then
				if vim.fn.filereadable(join(mailbox_path, ".uidvalidity")) and
					isdir(join(mailbox_path, "cur")) ~= 0 then
					table.insert(lines, entry)
				end
			end
		end
		api.nvim_buf_set_lines(0, 0, -1, false, lines)
		vim.keymap.set('n', '<Leader>o', show_mailbox, {})
	end
})

