$jsonPath = 'http://localhost/users.json'
$userList = invoke-webrequest $jsonPath | convertfrom-json
$logDirectory = 'C:\Scripts\Logs'
$date = get-date -Format "d-M-yyyy-hh-ss"
$logFile = ($logDirectory +'\' + $date +'.log')

if(!(Test-Path -Path $logDirectory ))
{
    New-Item -ItemType directory -Path $logDirectory
}

if(!(test-path -Path $logFile))
{
    New-Item -ItemType file -Path $logFile
}

foreach ($user in $userList)
{ 
    try 
    {
        get-aduser -identity $user.username | set-aduser -mobilephone $user.cellphone
    }
    catch
    {
        $errorMessage = $_.Exception.Message
        $failedItem = $_.Exception.ItemName
        Add-Content $logFile -Value ($FailedItem + '\n' + $ErrorMessage)
    }
}
