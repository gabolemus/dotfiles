vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
        ["+"] = "win32yank.exe -i",
        ["*"] = "win32yank.exe -i",
    },
    paste = {
        ["+"] = "pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
        ["*"] = "pwsh.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace('`r', ''))",
    },
    cache_enabled = 0,
}
