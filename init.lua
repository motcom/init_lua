-- packer.nvimの初期化
require("packer").startup(function(use)
   use "wbthomason/packer.nvim"
   --use "cocopon/iceberg.vim"

   -- use "dense-analysis/ale"
   use "easymotion/vim-easymotion"
   -- use "junegunn/goyo.vim"
   use "junegunn/limelight.vim"
   use "junegunn/vim-easy-align"
   use "lambdalisue/fern.vim"
   use "yuki-yano/fern-preview.vim"
   use { "neoclide/coc.nvim",
      branch = "release"
   }
   use "simeji/winresizer"
   use "tpope/vim-commentary"
   use "tpope/vim-surround"
   use "mechatroner/rainbow_csv"
   -- use "aklt/plantuml-syntax"
   use "weirongxu/plantuml-previewer.vim"
   -- use "tyru/open-browser.vim"
   use "cpea2506/one_monokai.nvim"
   use "pocco81/true-zen.nvim"
   use "norcalli/nvim-colorizer.lua"
   use "folke/zen-mode.nvim"
   use "tell-k/vim-autopep8"
end)

-- ########## base set grp #############
local op = vim.opt

-- use system to clipboard
op.clipboard:append { "unnamedplus" }

-- nonuse to swapfile and backup
op.guifont     = "consolas:h10"
op.smartcase   = true
op.swapfile    = false
op.backup      = false
op.number      = false
op.smartindent = true
op.expandtab   = true
op.shiftwidth  = 3
op.softtabstop = 3
op.title       = false
op.shortmess:append "I"


-- コメントアウトの自動挿入を無効化
vim.api.nvim_command('autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o')

-- auto move current directory

op.autochdir = true

-- encoding
op.encoding = "utf-8"

op.fileencoding = "utf-8"

-- ##########  other setting ##########
--

-- monokai setting
require("one_monokai").setup({
   transparent = true,       -- enable transparent window
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
vim.g.python3_host_prog
                          = '%HOME%/scoop/apps/python/current/python.exe'
vim.g.EasyMotion_smatcase = 1

-- terminal open
local function cmd()
   vim.cmd("split")
   vim.cmd("wincmd j")
   vim.cmd("terminal")
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("A", true, true, true), "n", false)
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
   elseif ext == "lua" then
      vim.cmd("w")
      vim.cmd("!lua %")
   end
end
vim.api.nvim_create_user_command("Run", run, {})

local function test()
   local ext = vim.fn.expand("%:e")
   if ext == "rs" then
      vim.cmd("w")
      vim.cmd("!cargo test")
   end
end
vim.api.nvim_create_user_command("Test", test, {})

-- ########### key map grp ###########
local keymap    = vim.api.nvim_set_keymap
local keyopt    = { noremap = true, silent = true }

vim.g.mapleader = " "
-- EasyMotionのリーダーキーを'<Leader>e'に変更する
vim.cmd [[
let g:EasyMotion_leader_key = '<Leader>e'
]]


-- normal
local function save_str()

   local status, err = pcall(vim.fn.CocAction, 'format')
   if not status then
      vim.api.nvim_command("w!")
   else
      vim.api.nvim_command("w!")
   end
end


vim.api.nvim_create_user_command("Save", save_str, {})
-- local save_str = ":call CocAction('format')<CR>" .. ":w!<CR>"
keymap("n", "<CR>", "i<CR><ESC>", keyopt)
keymap("n", "0", "^", keyopt)
keymap("n", "^", "0", keyopt)
keymap("n", "s", ":Save<CR>", keyopt)
keymap("n", "<Leader>f", "<Plug>(easymotion-overwin-f)", keyopt)
keymap("n", "<Leader>#", ":ColorizerToggle<CR>"
, { silent = true })
keymap("n", "<Leader>g", "<Plug>(coc-diagnostic-prev)"
, { silent = true })
keymap("n", "<Leader>G", "<Plug>(coc-diagnostic-next)"
, { silent = true })
keymap("n", "ga", "<Plug>(EasyAlign)", keyopt)
keymap("x", "ga", "<Plug>(EasyAlign)", keyopt)

keymap("n", "<Leader>p", ":CocCommand markdown-preview-enhanced.openPreview<CR>", keyopt)

-- insert
keymap("i", "jj", "<ESC>", keyopt)

-- terminal
keymap("t", "<ESC>", "<C-\\><C-n>", keyopt)
keymap("t", "<C-e>", "<C-\\><C-n>:WinResizerStartResize<CR>", keyopt)


keymap("n", "<C-c>", ":Cmd<CR>", keyopt)
keymap("t", "<C-c>", "<C-\\><C-n>:q<CR>", keyopt)


-- Fern をトグルする関数
local toggle_fern_flag = false
local function toggle_fern()
   if toggle_fern_flag then
      vim.cmd('FernDo close -stay')
      toggle_fern_flag = false
   else
      vim.cmd('Fern . -drawer')
      toggle_fern_flag = true
   end
end
vim.api.nvim_create_user_command("ToggleFern", toggle_fern, {})
keymap('n', '<Leader><Leader>', ':ToggleFern<CR>', { noremap = true, silent = true })


-- Fern プレビュー
keymap('n', '<C-p>', '<Plug>(fern-action-preview:auto:toggle)', { noremap = true, silent = true })




-- zenmode
require("zen-mode").setup({
   window = {
      width = .70 --  editor width
   }
})

keymap("n", "<Leader>z", ":ZenMode<CR>", keyopt)

-- complete select settings
keymap("i", "<Tab>", [[coc#pum#visible() ?  coc#pum#confirm() : "<Tab>"]],
   { noremap = true, silent = true, expr = true })

-- coc function
keymap("n", "gh", ":call CocAction('doHover')<CR>", keyopt)
keymap("n", "gr", ":call CocAction('references')<CR>", keyopt)
keymap("n", "gd", ":call CocAction('definition')<CR>", keyopt)
keymap("n", "<leader>r", ":call CocAction('rename')<CR>", keyopt)

-- ホバーポップアップを下にスクロールする
keymap('n', '<C-f>', "<Cmd>lua vim.call('coc#float#scroll', 1)<CR>", keyopt)

-- ホバーポップアップを上にスクロールする
keymap('n', '<C-b>', "<Cmd>lua vim.call('coc#float#scroll', 0)<CR>", keyopt)

---------------------------------------------------------------------------

vim.api.nvim_create_augroup("vimrc", {})
vim.api.nvim_create_autocmd("WinEnter", {
   callback = function()
      if (vim.bo.filetype ~= "fern") then
         vim.cmd("FernDo close -stay")
      end
   end,
})

-- my function

local function yankMatchingLines()
   -- 最後の検索パターンを取得
   local pattern = vim.fn.histget('search', -1)

   -- マッチする行を格納するテーブル
   local matching_lines = {}

   -- 全行をループし、パターンにマッチするか確認
   for i = 1, vim.fn.line('$') do
      local line = vim.fn.getline(i)
      if pattern == nil then
         return
      end
      if string.find(line, pattern) then
         table.insert(matching_lines, line)
      end
   end

   -- テーブルの内容を文字列に変換
   local text_to_yank = table.concat(matching_lines, "\n")

   -- yankバッファにテキストを挿入
   vim.fn.setreg('a', text_to_yank)
end

-- バッファを処理して更新する
vim.api.nvim_create_user_command("SearchYank", yankMatchingLines, {})

-- yankバッファをすべて削除

local function clearAllYankBuffers()
   local regs = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-\""
   for i = 1, #regs do
      local reg = regs:sub(i, i)
      vim.fn.setreg(reg, {})
   end
end
vim.api.nvim_create_user_command("ClearAllReg", clearAllYankBuffers, {})
keymap("n", "<leader>c", ":ClearAllReg<CR>", keyopt)
