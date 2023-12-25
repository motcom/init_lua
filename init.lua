

-- packer.nvimの初期化
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
--use "cocopon/iceberg.vim"
  use "dense-analysis/ale"
  use "easymotion/vim-easymotion"
  use "junegunn/goyo.vim"
  use "junegunn/limelight.vim"
  use "junegunn/vim-easy-align"
  use "lambdalisue/fern.vim"
  use {"neoclide/coc.nvim",
        branch = "release"
      }
  use "simeji/winresizer"
  use "tpope/vim-commentary"
  use "tpope/vim-surround"
  use "mechatroner/rainbow_csv"
  use "aklt/plantuml-syntax"
  use "weirongxu/plantuml-previewer.vim"
  use "tyru/open-browser.vim"
  use "cpea2506/one_monokai.nvim"
  use "pocco81/true-zen.nvim"
  use "norcalli/nvim-colorizer.lua"
end)

-- ########## base set grp #############
local op = vim.opt


-- use system to clipboard
op.clipboard:append{"unnamedplus"}

-- nonuse to swapfile and backup
op.swapfile = false
op.backup = false
op.number  = true
op.smartindent = true
op.expandtab = true
op.shiftwidth = 2
op.softtabstop = 2
op.title = false
op.shortmess:append "I"


-- auto move current directory
op.autochdir = true

-- encoding
op.encoding="utf-8"
op.fileencoding="utf-8"

-- ##########  other setting ##########
--
-- monokai setting
require("one_monokai").setup({
    transparent = true,  -- enable transparent window
    colors = {
        dark_gray = "#5b6271", -- replace default color
        bg = "#181c24",
    },
    themes = function(colors)
        -- change highlight of some groups,
        -- the key and value will be passed respectively to "nvim_set_hl"
        return {
            ErrorMsg = { fg = colors.dark_gray, standout = true },
            ["@lsp.type.keyword"] = { link = "@keyword" }
        }
    end,
    italics = false, -- disable italics
})

-- syntax on
vim.cmd("syntax enable")
vim.cmd.colorscheme "one_monokai"

-- value setting
vim.g.python3_host_prog = '%HOME%/scoop/apps/python/current/python.exe'
vim.g.OmniSharp_server_use_net6 = 1
vim.g.EasyMotion_smatcase = 1
vim.g.guifont = 'Consolas'

-- terminal open
local function cmd()
   vim.cmd("vsplit")
   vim.cmd("wincmd l")
   vim.cmd("terminal")
   vim.cmd("wincmd h")
end
vim.api.nvim_create_user_command("Cmd", cmd, {})

-- run
local function run()
  local ext = vim.fn.expand("%:e")
  if ext == "py" then
    vim.cmd("w")
    vim.cmd("!python %")
  elseif ext == "cs" then
    vim.cmd("w")
    vim.cmd("!dotnet build")
    vim.cmd("!dotnet run")
  elseif ext == "rs" then
    vim.cmd("w")
    vim.cmd("!cargo run")
   end
end
vim.api.nvim_create_user_command("Run",run,{})

-- ########### key map grp ########### 
local keymap = vim.api.nvim_set_keymap
local keyopt   = {noremap = true,silent = true}
vim.g.mapleader = " "
-- normal
keymap("n","<CR>","i<CR><ESC>",keyopt)
keymap("n","0","^",keyopt)
keymap("n","^","0",keyopt)
keymap("n","s",":w!<CR>",keyopt)
keymap("n","<Leader>t",":Fern . -drawer<CR>",keyopt)
keymap("n","f","<Plug>(easymotion-overwin-f)",keyopt)

-- insert
keymap("i","jj","<ESC>",keyopt)

-- true_zen
keymap("v", "<leader>z", ":'<,'>TZNarrow<CR>", keyopt)
keymap("n", "<leader>z", ":TZAtaraxis<CR>", keyopt)


-- complete select settings
keymap("i", "<Tab>", [[coc#pum#visible() ?  coc#pum#confirm() : "<Tab>"]], {noremap = true,silent = true,expr = true})
keymap("n", "<Leader>g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keymap("n", "<Leader>G", "<Plug>(coc-diagnostic-next)", {silent = true})
------------------------------------------------------------------------------------------------
-- color lizer toggle
keymap("n", "<Leader>c", ":ColorizerToggle<CR>", {silent = true})

vim.api.nvim_create_augroup("vimrc", {})
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if(vim.bo.filetype ~= "fern") then
      vim.cmd("FernDo close -stay")
    end
  end,
})

