#PK used to sign LF assemblies. Has been stable since 8.3
$PublicKey = "3f98b3eaee6c16a6"
#internal state vars
$_sesion = $null
$_loadedLib = $null

function Add-LaserficheSDK {  
    param(
        [Parameter(Mandatory=$true)]
        [String] $name, 
        [Parameter(Mandatory=$true)]
        [String] $version
    )

    $supported_libs = @(
        'Laserfiche.RepositoryAccess', 
        'Laserfiche.PdfServices',
        'Laserfiche.DocumentServices')
    #assume that patch and build numbers are not used and 0 
    $version = "$($version).0.0"
    if($supported_libs.contains($name)) {
        $asm_name = "$($name), Version=$($version), Culture=neutral, PublicKeyToken=$($PublicKey)"
        Add-Type -AssemblyName $asm_name -PassThru
        $_loadedLib = $asm_name
        return $true
    }
    else {
        echo "$($name) is not supported."
        return $false
    }
}

function New-LaserficheSession {

    param(
        [String] $user = $null,
        [String] $password = $null,
        [Parameter(Mandatory=$true)]
        [String] $server,
        [Parameter(Mandatory=$true)]
        [String] $repo
    )

    if($user -eq $null -and $password -eq $null){
        $_session = [Laserfiche.RepositoryAccess.Session]::Create($server, $repo)
    }
    else {
        $_session = [Laserfiche.RepositoryAccess.Session]::Create($server, $repo, $user, $pass)
    }
}

Export-ModuleMember -Function 'Add-*'
Export-ModuleMember -Function 'New-*'
