require('lsp-colors').setup {}

local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.sourcekit.setup {
    capabilities = capabilities,
}

lspconfig.terraformls.setup {
    capabilities = capabilities,
}

lspconfig.sumneko_lua.setup {
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                globals = {'vim'},
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        }
    }
}

lspconfig.bashls.setup {
    capabilities = capabilities,
}

-- lspconfig.html.setup {
--     capabilities = capabilities,
-- }
--
-- lspconfig.cssls.setup {
--     capabilities = capabilities,
-- }
--
-- lspconfig.yamlls.setup {
--     capabilities = capabilities,
-- }

local function _do_rename(win)
    return function()
        local new_name = vim.trim(vim.fn.getline('.'))
        vim.api.nvim_win_close(win, true)
        vim.lsp.buf.rename(new_name)
    end
end

local function rename()
    local opt = {
        relative = 'cursor',
        row = 0,
        col = 0,
        width = 30,
        height = 1,
        style = 'minimal',
        border = 'single',
    }
    local cword = vim.fn.expand('<cword>')
    local buf = vim.api.nvim_create_buf(false, true)
    local win = vim.api.nvim_open_win(buf, true, opt)

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {cword})
    vim.keymap.set('n', '<CR>', _do_rename(win), {buffer = buf, silent = true})
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.hoverProvider then
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.bug })
        end

        if client.server_capabilities.renameProvider then
            vim.keymap.set('n', '<leader>rn', rename, {silent = true, buffer = args.bug})
        end
    end
})

