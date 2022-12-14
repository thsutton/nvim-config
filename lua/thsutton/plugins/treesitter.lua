require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'lua', 'rust' },
    sync_install = false,
    auto_install = true,
    ignore_install = { "javascript" },
    highlight = {
        enable = true,
    }

}
