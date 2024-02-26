# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\blue-owl.omp.json" | Invoke-Expression
oh-my-posh init pwsh --config "$HOME\.shell-themes\gabo-blue-owl.omp.json" | Invoke-Expression

# Temporary minimal prompt string
# function prompt { "`n❯ " }

# Nice themes:
# - Blue-Owl - blue-owl.omp.json
# - Clean-Detailed - clean-detailed.omp.json

# PowerShell general configuration
# Show navigable menu for all options when pressing tab
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# Arrow keys autocomletion
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# PgUp/PgDn autocomletion
Set-PSReadLineKeyHandler -Key PageUp -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key PageDown -Function HistorySearchForward

# Aliases
# Set-Alias -Name lua -Value "C:\Users\Gabo\Portable Apps\Lua\lua54.exe"
Set-Alias -Name vim -Value "C:\Program Files\Neovim\bin\nvim.exe"

# Reload profile
function Reload-Profile {
    @(
        $PROFILE.AllUsersAllHosts,
        $PROFILE.AllUsersCurrentHost,
        $PROFILE.CurrentUserAllHosts,
        $PROFILE.CurrentUserCurrentHost
    ) | ForEach-Object {
        if (Test-Path $_) {
            Write-Verbose "Reloading $_"
            . $_
        }
    }
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# # Deactivate Conda environment
# conda deactivate > $null

# Refresh the environment variables
RefreshEnv > $null
