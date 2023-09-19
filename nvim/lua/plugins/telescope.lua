return {
    'nvim-telescope/telescope.nvim', tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
	keys = {
		{ "<leader>pf", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Project Files" },
		{ "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<cr>", desc = "Git files" },
		{ "<leader>ps", "<cmd>lua require('telescope.builtin').grep_string({search = vim.fn.input('Grep > ') })<cr>", desc = "Project Search" },

	},
}