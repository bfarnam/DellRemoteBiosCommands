$guid = [guid]::NewGuid().ToString()
$tempPath = Join-Path -Path $env:TEMP -ChildPath $guid

$downloadFile = 'https://aka.ms/vc14/vc_redist.x64.exe'
$tempFile = Join-Path -Path $tempPath - ChildPath = 'vc_redist.x64.exe'

Invoke-WebRequest -Uri $downloadFile -OutFile $tempFile
Unblock-File -Path $tempFile
Start-Process -FilePath "$tempFile" -ArgumentList "/install /passive" -PassThru -Wait
Remove-Item -Path "$tempFile"

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers -Verbose
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name DellBIOSProvider -Scope AllUsers -Verbose


<#
{
		$certificateFilePath = '\\.internal\deploy$\DellBIOSProvider\DellRemediationPowershellIdentityCert.cer'
		certutil -addstore -f "TrustedPublisher" $certificateFilePath
	    $certificateFilePath = '\\.internal\deploy$\DellBIOSProvider\DellBIOSProvider.cer'
		certutil -addstore -f "TrustedPublisher" $certificateFilePath
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope AllUsers -Verbose;
		Set-PSRepository -Name PSGallery -InstallationPolicy Trusted;
		Install-Module -Name DellBIOSProvider -Scope AllUsers -Verbose;
		# Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope MachinePolicy -Force;
#>