<###################################################################################>
<#       Script: FetchLifeTimeData                                                 #>
<#  Description: Fetch the latest Application and Environment data in LifeTime     #>
<#               for invoking the Deployment API.                                  #>
<#         Date: 2018-09-29                                                        #>
<#       Author: rrmendes, kmadel                                                  #>
<#         Path: FetchLifeTimeData.ps1                  			   #>
<###################################################################################>

<###################################################################################>
<#     Function: CallDeploymentAPI                                                 #>
<#  Description: Helper function that wraps calls to the LifeTime Deployment API.  #>
<#       Params: -Method: HTTP Method to use for API call                          #>
<#               -Endpoint: Endpoint of the API to invoke                          #>
<#               -Body: Request body to send when calling the API                  #>
<###################################################################################>
function CallDeploymentAPI ($Method, $Endpoint, $Body)
{
	$Url = "https://$env:LT_URL/LifeTimeAPI/rest/v1/$Endpoint"
	$ContentType = "application/json"
	$Headers = @{
		Authorization = "Bearer $env:AUTH_TOKEN"
		Accept = "application/json"
	}
		
	try { Invoke-RestMethod -Method $Method -Uri $Url -Headers $Headers -ContentType $ContentType -Body $body }
	catch { Write-Host $_; exit 9 }
}

# Fetch latest OS Environments data 
$Environments = CallDeploymentAPI -Method GET -Endpoint environments 
$Environments | Format-Table Name,Key > LT.Environments.mapping
"Environments=" + ( ( $Environments | %{ $_.Name } | Sort-Object ) -join "`\n" ) | Out-File LT.Environments.properties -Encoding Default
echo "OS Environments data - $env:LT_ENVIRONMENTS - retrieved successfully."

# Fetch latest OS Applications data
$Applications = CallDeploymentAPI -Method GET -Endpoint applications 
$Applications | Format-Table Name,Key > LT.Applications.mapping
"Applications=" + ( ( $Applications | %{ $_.Name } | Sort-Object ) -join "`\n" ) | Out-File LT.Applications.properties -Encoding Default
echo "OS Applications data retrieved successfully."
