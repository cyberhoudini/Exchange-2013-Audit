<#
    .SYNOPSIS
    Exchange 2013 Audit Configurations according to CIS

    .DESCRIPTION

    This is used to query current 2013 Exchange configurations and give a report. 

    .PARAMETER Report
    FilePath to write CSV Report C:/This/is/the/filepath/filename.csv

    .PARAMETER ExchangeMailDatbase
    The Exchange server name and database to query. Written in the following format: "EXCHANGE01\Mailbox Database"

    .PARAMETER SendConnectorIdentity
    The Send Connector Identity

    .PARAMETER SendConnectorWebsite
    The Send Connector to/from Website 

    .PARAMETER RemoteDomain
    Remote domain for Get-RemoteDomain field

    .PARAMETER OWAIdentity
    Written in the following format "Contoso\owa*"

    .PARAMETER ServerName
    This is the server name ie. EXCHANGE1

    .PARAMETER UMDialPlan



#>
Param(
    [parameter(Mandatory=$true)][string] $Report,
    [parameter(Mandatory=$true)][string] $ExchangeMailDatbase,
    [parameter(Mandatory=$true)][string] $SendConnectorIdentity,
    [parameter(Mandatory=$true)][string] $SendConnectorWebsite,
    [parameter(Mandatory=$true)][string] $RemoteDomain,
    [parameter(Mandatory=$true)][string] $OWAIdentity,
    [parameter(Mandatory=$true)][string] $ServerName,
    [parameter(Mandatory=$false)][string] $UMDialPlan
    )

Set-SenderIDConfig | fl -property Enabled | Export-CSV -Path $Report -Force
Get-SendConnector "Connection to $SendConnectorWebsite" | fl -property DNSRoutingEnabled  | Export-CSV -Path $Report -NoClobber -Force
Get-SenderFilterConfig | fl -property Enabled | Export-CSV -Path $Report -NoClobber -Force
Get-SendConnector -identity <connector_name> | fl -property IgnoreSTARTTLS | Export-CSV -Path $Report -NoClobber -Force
Get-PopSettings | fl -property LoginType | Export-CSV -Path $Report -NoClobber -Force
Get-SendConnector -identity $SendConnectorIdentity | fl -property ProtocolLoggingLevel | Export-CSV -Path $Report -NoClobber -Force
Get-Sendconnector -Identity $SendConnectorIdentity | fl DomainSecureEnabled | Export-CSV -Path $Report -NoClobber -Force
Get-TransportService $ServerName | fl -property MessageTrackingLogEnabled | Export-CSV -Path $Report -NoClobber -Force
Get-ImapSettings | fl -property LoginType | Export-CSV -Path $Report -NoClobber -Force
Get-ReceiveConnector "Connection from $SendConnectorWebsite" | fl -property MaxMessageSize | Export-CSV -Path $Report -NoClobber -Force
Get-MailboxDatabase $ExchangeMailDatbase | fl -property ProhibitSendReceiveQuota | Export-CSV -Path $Report -NoClobber -Force
Get-Mailboxdatabase  $ExchangeMailDatbase | fl -property MailboxRetention | Export-CSV -Path $Report -NoClobber -Force
Get-MailboxDatabase $ExchangeMailDatbase | fl -property RetainDeletedItemsUntilBackup  | Export-CSV -Path $Report -NoClobber -Force
Get-MobileDeviceMailboxPolicy | fl -property AllowSimplePassword | Export-CSV -Path $Report -NoClobber -Force
Get-UMService -Identity $ServerName | fl -property UMStartUpMode | Export-CSV -Path $Report -NoClobber -Force
Get-UMDialPlan -identity $UMDialPlan | fl -property VoIPSecurity | Export-CSV -Path $Report -NoClobber -Force
Get-MailboxDatabase -Identity $ExchangeMailDatbase | fl -property DeletedItemRetention | Export-CSV -Path $Report -NoClobber -Force
Get-MobileDeviceMailboxPolicy -Identity default | fl -property AllowNonProvisionableDevices | Export-CSV -Path $Report -NoClobber -Force
Get-MobileDeviceMailboxPolicy -Identity default | fl -property RequireDeviceEncryption| Export-CSV -Path $Report -NoClobber -Force
Get-RpcClientAccess  | fl -property EncryptionRequired | Export-CSV -Path $Report -NoClobber -Force
Get-AdminAuditLogConfig | fl -property AdminAuditLogCmdlets | Export-CSV -Path $Report -NoClobber -Force
Get-ExecutionPolicy | fl -property RemoteSigned | Export-CSV -Path $Report -NoClobber -Force
Get-AdminAuditLogConfig | fl -property AdminAuditLogEnabled | Export-CSV -Path $Report -NoClobber -Force
Get-OwaVirtualDirectory -Identity $OWAIdentity | fl -property BasicAuthentication | Export-CSV -Path $Report -NoClobber -Force
Get-RemoteDomain $RemoteDomain | fl -property AllowedOOFType | Export-CSV -Path $Report -NoClobber -Force
Get-OWAVirtualDirectory -identity $OWAIdentity | fl -property SMimeEnabled | Export-CSV -Path $Report -NoClobber -Force
Get-AdminAuditLogConfig | fl -property AdminAuditLogEnabled | Export-CSV -Path $Report -NoClobber -Force
