-- package management setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- configure packages

require("lazy").setup({
	-- colorscheme
	{ 
		"ellisonleao/gruvbox.nvim", 
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox]])
		end
	},
	-- lsp
	{
		'neovim/nvim-lspconfig',
		config = function()

			lspconfig = require "lspconfig"
			util = require "lspconfig/util"

			lspconfig.gopls.setup {
				cmd = {"gopls", "serve"},
				filetypes = {"go", "gomod"},
				root_dir = util.root_pattern("go.work", "go.mod", ".git"),
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
					},
				},
			}
		end
	},
	{
		'williamboman/mason.nvim',
		dependencies = {
			{ 
				'williamboman/mason-lspconfig.nvim'
			}
		}, 
		config = true
	},
	-- auto completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',
			'hrsh7th/cmp-nvim-lsp-signature-help',
			'hrsh7th/cmp-vsnip',           
			'hrsh7th/cmp-path',           
			'hrsh7th/cmp-buffer',           
			'hrsh7th/vim-vsnip',
		},
		config = function()
			local cmp = require"cmp"
			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = {
					{ name = 'path' },
					{ name = 'nvim_lsp', keyword_length = 3 },
					{ name = 'nvim_lsp_signature_help'}, 
					{ name = 'nvim_lua', keyword_length = 2},
					{ name = 'buffer', keyword_length = 2 },
					{ name = 'vsnip', keyword_length = 2 },
				},

				formatting = {
					fields = {'menu', 'abbr', 'kind'},
					format = function(entry, item)
						local menu_icon ={
							nvim_lsp = 'λ',
							vsnip = '⋗',
							buffer = 'b',
							path = 'p'
						}
						item.menu = menu_icon[entry.source.name]
						return item
					end,
				},	
			})
		end
	}

})


