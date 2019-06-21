# For deleting Local User Accounts from remote computers

clear
$hostdetail = Import-CSV 'C:\Users\oj\Desktop\Test\hosts.csv'


ForEach ($item in $hostdetail)
{
    # Test network connection before making connection and Verify that the OS
    # Version is 6.0 and above

    If ((!(Test-Connection -comp $item.hostname -count 1 -quiet)) -Or
    ((Get-WmiObject -ComputerName $item.hostname Win32_OperatingSystem -ea stop).Version -lt 6.0))
    {
        $UserMessage = "$($item.hostname) is not accessible or The Operating System of the computer is not supported.
        `nClient: Vista and above`nServer: Windows 2008 and above."

        Write-Warning -Message $UserMessage
    }
    else
    {
        If ($PSVersionTable.PSVersion.Major -ge 5)
        { Invoke-Command -ComputerName $Using:item.hostname -ScriptBlock {Remove-LocalUser -Name $Using:item.username} }
        Else
        {
        Invoke-Command -ComputerName $Using:item.hostname -ScriptBlock {


        # See this article for ADSI / WMI way to do this
        # https://www.petri.com/managing-local-user-accounts-with-powershell

         -Name $Using:item.username}
       }
    }
}
