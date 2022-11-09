local disabled_builtins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
}

for _, plugin in pairs(disabled_builtins) do
    vim.g["loaded_" .. plugin] = 1
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'folke/lsp-colors.nvim'

  use 'nvim-tree/nvim-web-devicons'
  use {
      'nvim-tree/nvim-tree.lua',
      tag = 'nightly',
      config = [[require('thsutton.plugins.tree')]]
  }

  use {
    'neovim/nvim-lspconfig',
    config = [[require('thsutton.plugins.lsp')]],
  }


  use 'lewis6991/gitsigns.nvim'
  use 'norcalli/nvim-colorizer.lua'

  use {
      'folke/trouble.nvim',
      config = [[require('thsutton.plugins.trouble')]],
  }

  use {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.0',
  }

  use {
      'hrsh7th/nvim-cmp',
      requires = {
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-nvim-lua',
      },
      config = [[require('thsutton.plugins.cmp')]],
  }

  use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = [[require('thsutton.plugins.treesitter')]],
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
