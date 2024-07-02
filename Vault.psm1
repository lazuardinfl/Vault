function Get-VaultSecret {
    [OutputType([PSCustomObject])]
    param (
        [Alias("VaultUrl")] [ValidateNotNullOrWhiteSpace()] [string]$url,
        [Alias("VaultPath")] [ValidateNotNullOrWhiteSpace()] [string]$path,
        [Alias("AuthToken")] [ValidateNotNullOrWhiteSpace()] [string]$token,
        [Alias("RenewLease")] [switch]$renew,
        [Alias("OnErrorContinue")] [switch]$silent
    )
    $headers = @{ "X-Vault-Token" = $token }
    try {
        $result = Invoke-RestMethod -Uri "$($url)/v1/$($path)" -Method Get -Headers $headers
        if ($renew) { Update-VaultLease $url $token | Out-Null }
        return $result.data
    }
    catch { if ($silent) { return $null } else { throw } }
}

function Update-VaultLease {
    [OutputType([PSCustomObject])]
    param (
        [Alias("VaultUrl")] [ValidateNotNullOrWhiteSpace()] [string]$url,
        [Alias("AuthToken")] [ValidateNotNullOrWhiteSpace()] [string]$token,
        [Alias("OnErrorContinue")] [switch]$silent
    )
    $headers = @{ "X-Vault-Token" = $token }
    try {
        $result = Invoke-RestMethod -Uri "$($url)/v1/auth/token/renew-self" -Method Post -Headers $headers
        return $result
    }
    catch { if ($silent) { return $null } else { throw } }
}