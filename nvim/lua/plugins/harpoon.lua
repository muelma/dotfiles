return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
	lazy = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
	keys = {
		{ "<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Mark file with harpoon" },
		{ "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", desc = "Go to next harpoon mark" },
		{ "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", desc = "Go to previous harpoon mark" },
		{ "<leader>ha", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Show harpoon marks" },
		{ "<leader>hj", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Jump to harpoon marked file #1" },
		{ "<leader>hk", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Jump to harpoon marked file #2" },
		{ "<leader>hl", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Jump to harpoon marked file #3" },
		{ "<leader>h;", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Jump to harpoon marked file #4" },
	},
}
