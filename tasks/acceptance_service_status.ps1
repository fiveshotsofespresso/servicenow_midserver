[CmdletBinding()]
Param(
 [Parameter(Mandatory = $False)][String] $service_name
)
try {
  choco -v
  $service = Get-Service -Name $service_name 
  $service | ConvertTo-Json
  if ( $service.status -eq 'Running' ) { exit 0 } else {  exit 1}
} catch {
  exit 1
}
