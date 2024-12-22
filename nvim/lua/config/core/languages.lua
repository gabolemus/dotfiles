-- Set filetype for Salesforce Apex files
vim.cmd([[
  au BufRead,BufNewFile *.cls,*.trigger,*.apex set filetype=apex
]])

-- Optional: You can also customize the indentation settings for Apex files
vim.cmd([[
  autocmd FileType apex setlocal shiftwidth=2 tabstop=2 softtabstop=2
]])

-- Optional: Enable syntax highlighting for Apex files
vim.cmd([[autocmd FileType apex setlocal syntax=apex]])
