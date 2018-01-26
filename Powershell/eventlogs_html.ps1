cls
### CSS style
$servers = 'servername'
$get_dfs_errors_result = @()
$logPath = "D:\dfs\eventlogs\"
$log = "DFS Replication" 

$css= '<meta http-equiv="refresh" content="30">'
$css= $css+ "<style>"
$css= $css+ "BODY{ text-align: center; background-color:white;}"
$css= $css+ "TABLE{    font-family: 'Lucida Sans Unicode', 'Lucida Grande', Sans-Serif;font-size: 12px;margin: 10px;width: 100%;text-align: left;border-collapse: collapse;border-top: 7px solid #004466;border-bottom: 7px solid #004466;}"
$css= $css+ "TH{font-size: 13px;font-weight: normal;padding: 1px;background: #cceeff;border-right: 1px solid #004466;border-left: 1px solid #004466;background-color:thistle}"
$css= $css+ "TD{padding: 1px;background: #e5f7ff;border-right: 1px solid #004466;border-left: 1px solid #004466;background-color:palegoldenrod;}"
$css= $css+ "TD{border-width: 100%;padding: 3px;border-style: solid;border-color: black;}"
$css= $css+ "</style>" 

$StartDate = (get-date).adddays(-11)

foreach ($server in $servers)
{
$get_dfs_errors_db = Get-WinEvent -ComputerName $server -FilterHashtable @{logname=$log; id='2104'; starttime=$StartDate;} -ErrorAction SilentlyContinue | sort -Property Message -Unique
$get_dfs_errors_replication = Get-WinEvent -ComputerName $server -FilterHashtable @{logname=$log; id='2004'; starttime=$StartDate} -ErrorAction SilentlyContinue | sort -Property Message -Unique



$get_dfs_errors_db | % {

$a = $_.Message -split (':')

		$Properties = @{
		
      Name = $_.MachineName
	  ID = $_.ID
	  Time = $_.TimeCreated
	  Message = $a[0]
 
 }		
	$get_dfs_errors_result += New-Object psobject -Property $properties
	
	
}

$get_dfs_errors_replication | %{

$a = $_.Message -split (':')

		$Properties = @{
		
      Name = $_.MachineName
	  ID = $_.ID
	  Time = $_.TimeCreated
	  Message = $a[0]

					   }		
$get_dfs_errors_result += New-Object psobject -Property $properties
	}

}


$last_refresh = Get-Date
ConvertTo-HTML -head $css -body "<H1>DFS Replication Errors</H>" | Out-File "$logPath\dfs_logs.htm"
$get_dfs_errors_result | ConvertTo-HTML -Head $css Name,ID,Time,Message -Body "<p>Last refresh at $last_refresh </p>"  | Out-File "$logPath\dfs_logs.htm" -Append
