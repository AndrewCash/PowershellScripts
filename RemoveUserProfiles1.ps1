
#Authored by https://powershell.org/profile/TestLink/
#Cleaned up by https://powershell.org/profile/postanote/
#Found at https://powershell.org/forums/topic/powershell-script-to-delete-100-local-user-accounts-from-50-desktops/

clear
$hostdetail = Import-CSV C:\Users\oj\Desktop\Test\hosts.csv

ForEach ($item in $hostdetail)
{
    # You really don't need any of this


    $hostname = $($item.hostname)
    $username = $($item.username)

    # This is redundant since you already have this in $hostname
    $computer = $hostname


    # Test network connection before making connection and Verify that the OS Version is 6.0 and above

    # Break long lines by natural break lines where possible, to prevent unnecessary long scrolling line commands, or use splatting to make things easier to read.

    If ((!(Test-Connection -comp $computer -count 1 -quiet)) -Or
    ((Get-WmiObject -ComputerName $computer Win32_OperatingSystem -ea stop).Version -lt 6.0))
    {
         Write-Warning "$computer is not accessible or The Operating System of the computer is not supported.`nClient: Vista and above`nServer: Windows 2008 and above."
    }
    else
    {
         # You cannot use local variables in a remote session, unless you set the scope properly.
         Invoke-Command -ComputerName $computer -ScriptBlock $scriptBlock
    }

}

# Any function, scriptblock should be loaded before you use it.
# Load all this sort of stuff at the top of your script

$scriptBlock = {
function Remove-UserProfile
{
# This is only an PSv5 cmdlet, if you have legacy PS versions, OS versions not running PSv5, then this will fail.
# So, plan for this using ADSI
Remove-LocalUser -Name $username
}
Remove-UserProfile
}

}
