# Enter-PSSession fpd-veh111.pd.ferguson.internal -Credential mdtadmin@pd.ferguson.internal

# Get-ScheduledTask UnlockStartLayout | Unregister-ScheduledTask -Confirm:$false
# Get-ScheduledTask  XblGameSaveTask | Unregister-ScheduledTask -Confirm:$false
# Get-ScheduledTask | Where-Object -Property TaskName -like *OneDrive* | Disable-ScheduledTask
# Get-Item DellSmbios:\POSTBehavior\ActiveKbdBLColor | Select PossibleValues
# Get-Item DellSmbios:\PowerManagement\PrimaryBattChargeCfg | Select PossibleValues

Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process
Import-Module DellBIOSProvider -Verbose
$BIOSroot = 'DellSmbios:'
$BIOSSettings = @(
    [PSCustomObject]@{Category='BIOSSetupAdvancedMode';Attribute='AdvancedMode';SettingValue='Enabled'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='UsbPowerShare';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AdvBatteryChargeCfg';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnAc';SettingValue='Disabled'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='UsbEmu';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnDock';SettingValue='Disabled'},
    [PSCustomObject]@{Category='Wireless';Attribute='WirelessWwan';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='WlanAntSwitch';SettingValue='SystemAntenna'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='WwanAntSwitch';SettingValue='SystemAntenna'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='LimitPanelBri50';SettingValue='Disabled'},
    [PSCustomObject]@{Category='MiscellaneousDevices';Attribute='SdCardReadOnly';SettingValue='Enabled'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='ActiveKbdBLColor';SettingValue='Red'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KbdBacklightTimeoutBatt';SettingValue='Never'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KbdBacklightTimeoutAc';SettingValue='Never'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltBoot';SettingValue='Disabled'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltPreboot';SettingValue='Disabled'},
    [PSCustomObject]@{Category='Video';Attribute='BrightnessBattery';SettingValue='10'},
    [PSCustomObject]@{Category='Video';Attribute='BrightnessAC';SettingValue='10'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnDock';SettingValue='Disabled'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='ExtPostTime';SettingValue='5s'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='KeyboardIlluminationExt';SettingValue='Levelis100'}
)

$BIOSSettings | ForEach-Object {
    $BIOSpath = Join-Path -Path (Join-Path -Path $BIOSroot -ChildPath $_.Category) -ChildPath $_.Attribute
    $PreBIOS = Get-Item -Path $BIOSpath
    Write-Host "Using BIOS Category $($_.Category)"
    Write-Host "Attempting to Set $($_.Attribute) to $($_.SettingValue) - Current Value : $($PreBIOS.CurrentValue)"
    if ($($_.SettingValue) -ne $($PreBIOS.CurrentValue)) {
        try {
            Set-Item -Path $BIOSpath $_.SettingValue -ErrorAction Stop
        }
        catch {
            Write-Error -Message "Unable to set $BIOSpath to $($_.SettingValue)" -TargetObject $BIOSpath `
            -RecommendedAction "Check the DELL SMB BIOS Provider Documentation" -ErrorId $error[0]
        }
        $PostBIOS = Get-Item -Path $BIOSpath
        if ($PostBIOS.CurrentValue -ne $_.SettingValue) {
            Write-Error -Message "Setting $BIOSpath to $($_.SettingValue) FAILED!  Current Value is $PostBIOS.CurrentValue" -TargetObject $BIOSpath `
            -RecommendedAction "Check the DELL SMB BIOS Provider Documentation" 
        } else {
            Write-Host "Success! $($PostBIOS.Attribute) is now set to $($PostBIOS.CurrentValue)"
        }
    } else {
        Write-Warning "No changes Needed. New Value is SAME as Current Value."
    }
    Write-Host "`n"
}

<#

# GET THE VALUES WE ARE MOIFYING TO CHECK

@(
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process
Import-Module DellBIOSProvider -Verbose
$BIOSroot = 'DellSmbios:'
$BIOSSettings = @(
    [PSCustomObject]@{Category='SystemInformation';Attribute='BIOSVersion';SettingValue=''},
    [PSCustomObject]@{Category='SystemInformation';Attribute='SvcTag';SettingValue=''},
    [PSCustomObject]@{Category='SystemInformation';Attribute='Asset';SettingValue=''},
    [PSCustomObject]@{Category='SystemInformation';Attribute='OwnershipTag';SettingValue=''},
    [PSCustomObject]@{Category='SystemInformation';Attribute='ManufactureDate';SettingValue=''},
    [PSCustomObject]@{Category='SystemInformation';Attribute='OwnershipDate';SettingValue=''},
    [PSCustomObject]@{Category='SystemInformation';Attribute='ExpressServiceCode';SettingValue=''},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='MemoryInstalled';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='ProcessorId';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='MaximumClockSpeed';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='CurrentClockSpeed';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='CoreCount';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='64BitTechnology';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='HTCapable';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='ProcessorL2Cache';SettingValue=''},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='ProcessorL3Cache';SettingValue=''},
    [PSCustomObject]@{Category='BatteryInformation';Attribute='PercentCharged';SettingValue=''},
    [PSCustomObject]@{Category='BIOSSetupAdvancedMode';Attribute='AdvancedMode';SettingValue='Enabled'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='UsbPowerShare';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AdvBatteryChargeCfg';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnAc';SettingValue='Disabled'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='UsbEmu';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnDock';SettingValue='Disabled'},
    [PSCustomObject]@{Category='Wireless';Attribute='WirelessWwan';SettingValue='Disabled'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='WlanAntSwitch';SettingValue='SystemAntenna'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='WwanAntSwitch';SettingValue='SystemAntenna'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='LimitPanelBri50';SettingValue='Disabled'},
    [PSCustomObject]@{Category='MiscellaneousDevices';Attribute='SdCardReadOnly';SettingValue='Enabled'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='ActiveKbdBLColor';SettingValue='Red'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KbdBacklightTimeoutBatt';SettingValue='Never'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KbdBacklightTimeoutAc';SettingValue='Never'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltBoot';SettingValue='Disabled'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltPreboot';SettingValue='Disabled'},
    [PSCustomObject]@{Category='Video';Attribute='BrightnessBattery';SettingValue='10'},
    [PSCustomObject]@{Category='Video';Attribute='BrightnessAC';SettingValue='10'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnDock';SettingValue='Disabled'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='ExtPostTime';SettingValue='5s'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='KeyboardIlluminationExt';SettingValue='Levelis100'}
)
$CurrentBIOSSettings = [System.Collections.Generic.List[PSObject]]::new()
$BIOSSettings | ForEach-Object {
    $BIOSpath = Join-Path -Path (Join-Path -Path $BIOSroot -ChildPath $_.Category) -ChildPath $_.Attribute
    $tempObj = Get-Item -Path $BIOSpath
    $obj = [PSCustomObject]@{
        Category = $_.Category;
        Attribute = $tempObj.Attribute;
        ShortDescription = $tempObj.ShortDescription;
        CurrentValue = $tempObj.CurrentValue;
        PossibleValues = $tempObj.PossibleValues
    }
    $CurrentBIOSSettings.Add($obj)
}
$CurrentBIOSSettings
)

#>

<#
# GET ALL VALUES!!

@(
Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process
Import-Module DellBIOSProvider -Verbose
$BIOSroot = 'DellSmbios:'
$BIOScategories = @(
    'SystemInformation',
    'MemoryInformation',
    'ProcessorInformation',
    'BatteryInformation',
    'BootSequence',
    'AdvancedBootOptions',
    'BIOSSetupAdvancedMode',
    'SystemConfiguration',
    'StealthModeControl',
    'MiscellaneousDevices',
    'USBConfiguration',
    'Video',
    'Security',
    'TPMSecurity',
    'SecureBoot',
    'IntelSoftwareGuardExtensions',
    'Performance',
    'PowerManagement',
    'POSTBehavior',
    'Manageability',
    'VirtualizationSupport',
    'Wireless',
    'Maintenance',
    'SystemLogs',
    'AdvancedConfigurations',
    'SupportAssistSystemResolution',
    'ThermalConfiguration',
    'Passwords',
    'PreEnabled',
    'UEFIvariables'
)
$BIOSAttributes = @(
    [PSCustomObject]@{Category='SystemInformation';Attribute='BIOSVersion'},
    [PSCustomObject]@{Category='SystemInformation';Attribute='SvcTag'},
    [PSCustomObject]@{Category='SystemInformation';Attribute='Asset'},
    [PSCustomObject]@{Category='SystemInformation';Attribute='OwnershipTag'},
    [PSCustomObject]@{Category='SystemInformation';Attribute='ManufactureDate'},
    [PSCustomObject]@{Category='SystemInformation';Attribute='OwnershipDate'},
    [PSCustomObject]@{Category='SystemInformation';Attribute='ExpressServiceCode'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='MemoryInstalled'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='MemoryAvailable'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='MemoryTechnology'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='DIMMASize'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='DIMMBSize'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='DIMMCSize'},
    [PSCustomObject]@{Category='MemoryInformation';Attribute='DIMMDSize'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='ProcessorId'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='MaximumClockSpeed'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='CurrentClockSpeed'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='CoreCount'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='64BitTechnology'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='HTCapable'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='ProcessorL2Cache'},
    [PSCustomObject]@{Category='ProcessorInformation';Attribute='ProcessorL3Cache'},
    [PSCustomObject]@{Category='BatteryInformation';Attribute='PercentCharged'},
    [PSCustomObject]@{Category='BootSequence';Attribute='BootList'},
    [PSCustomObject]@{Category='BootSequence';Attribute='BootSequence'},
    [PSCustomObject]@{Category='AdvancedBootOptions';Attribute='UefiBootPathSecurity'},
    [PSCustomObject]@{Category='AdvancedMode';Attribute='AdvancedMode'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='MicMuteLed'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='EmbNic1'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='UefiNwStack'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='Serial1'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='EmbSataRaid'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='Sata0'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='SmartErrors'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='UsbPowerShare'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='IntegratedAudio'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='InternalSpeaker'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='Microphone'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KeyboardBacklightEnabledColors'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KeyboardBacklightCustom1Color'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KeyboardBacklightCustom2Color'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='Touchscreen'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='M2PcieSsd0'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KbdBacklightTimeoutBatt'},
    [PSCustomObject]@{Category='SystemConfiguration';Attribute='KbdBacklightTimeoutAc'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='StealthMode'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisOnboardLEDs'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisOnboardLCDScreen'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisOnboardSpeakers'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisOnboardFans'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisBluetoothRadio'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisGPSReceiver'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisWLANRadio'},
    [PSCustomObject]@{Category='StealthModeControl';Attribute='DisWWANRadio'},
    [PSCustomObject]@{Category='MiscellaneousDevices';Attribute='Camera'},
    [PSCustomObject]@{Category='MiscellaneousDevices';Attribute='SdCard'},
    [PSCustomObject]@{Category='MiscellaneousDevices';Attribute='SdCardReadOnly'},
    [PSCustomObject]@{Category='MiscellaneousDevices';Attribute='SdCardBoot'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='UsbEmu'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='UsbPortsExternal'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='DellDockDevicesDis'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltPorts'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltBoot'},
    [PSCustomObject]@{Category='USBConfiguration';Attribute='ThunderboltPreboot'},
    [PSCustomObject]@{Category='Video';Attribute='PrivacyScreen'},
    [PSCustomObject]@{Category='Video';Attribute='BrightnessBattery'},
    [PSCustomObject]@{Category='Video';Attribute='BrightnessAc'},
    [PSCustomObject]@{Category='Security';Attribute='Absolute'},
    [PSCustomObject]@{Category='Security';Attribute='SmmSecurityMitigation'},
    [PSCustomObject]@{Category='Security';Attribute='PasswordLock'},
    [PSCustomObject]@{Category='Security';Attribute='CapsuleFirmwareUpdate'},
    [PSCustomObject]@{Category='Security';Attribute='IsSystemPasswordSet'},
    [PSCustomObject]@{Category='Security';Attribute='IsAdminPasswordSet'},
    [PSCustomObject]@{Category='Security';Attribute='HDDInfo'},
    [PSCustomObject]@{Category='Security';Attribute='AdminPassword'},
    [PSCustomObject]@{Category='Security';Attribute='SystemPassword'},
    [PSCustomObject]@{Category='Security';Attribute='HDDPassword'},
    [PSCustomObject]@{Category='Security';Attribute='StrongPassword'},
    [PSCustomObject]@{Category='Security';Attribute='PasswordBypass'},
    [PSCustomObject]@{Category='Security';Attribute='ChasIntrusion'},
    [PSCustomObject]@{Category='Security';Attribute='ChassisIntrusionStatus'},
    [PSCustomObject]@{Category='Security';Attribute='AdminSetupLockout'},
    [PSCustomObject]@{Category='Security';Attribute='MasterPasswordLockout'},
    [PSCustomObject]@{Category='TPMSecurity';Attribute='TpmPpiClearOverride'},
    [PSCustomObject]@{Category='TPMSecurity';Attribute='TpmSecurity'},
    [PSCustomObject]@{Category='TPMSecurity';Attribute='TpmClear'},
    [PSCustomObject]@{Category='SecureBoot';Attribute='SecureBootMode'},
    [PSCustomObject]@{Category='SecureBoot';Attribute='SecureBoot'},
    [PSCustomObject]@{Category='Performance';Attribute='AdaptiveCStates'},
    [PSCustomObject]@{Category='Performance';Attribute='CpuCore'},
    [PSCustomObject]@{Category='Performance';Attribute='Speedstep'},
    [PSCustomObject]@{Category='Performance';Attribute='CStatesCtrl'},
    [PSCustomObject]@{Category='Performance';Attribute='TurboMode'},
    [PSCustomObject]@{Category='Performance';Attribute='LogicProc'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='SpeedShift'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AutoOn'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AutoOnHr'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AutoOnMn'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='PeakShiftCfg'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='PeakShiftBatteryThreshold'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='PeakShiftDayConfiguration'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AdvBatteryChargeCfg'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='AdvancedBatteryChargeConfiguration'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnAc'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WlanAutoSense'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WwanAutoSense'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnLan'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='BlockSleep'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='PrimaryBattChargeCfg'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='CustomChargeStart'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='CustomChargeStop'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='SliceBattChargeCfg'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='SliceBattCustomChargeStart'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='SliceBattCustomChargeStop'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='WakeOnDock'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='LidSwitch'},
    [PSCustomObject]@{Category='PowerManagement';Attribute='TypeCPower'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='DockWarningsEnMsg'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='MacAddrPassThru'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='SignOfLifeByDisplay'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='WarningsAndErr'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='PowerWarn'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='NumLock'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='FnLock'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='FnLockMode'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='ExtPostTime'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='ActiveKbdBLColor'},
    [PSCustomObject]@{Category='POSTBehavior';Attribute='FullScreenLogo'},
    [PSCustomObject]@{Category='VirtualizationSupport';Attribute='Virtualization'},
    [PSCustomObject]@{Category='VirtualizationSupport';Attribute='VtForDirectIo'},
    [PSCustomObject]@{Category='VirtualizationSupport';Attribute='TrustExecution'},
    [PSCustomObject]@{Category='Wireless';Attribute='DynamicWirelessTransmitPower'},
    [PSCustomObject]@{Category='Wireless';Attribute='WirelessWwan'},
    [PSCustomObject]@{Category='Wireless';Attribute='WirelessLan'},
    [PSCustomObject]@{Category='Wireless';Attribute='BluetoothDevice'},
    [PSCustomObject]@{Category='Maintenance';Attribute='BiosRcvrFrmHdd'},
    [PSCustomObject]@{Category='Maintenance';Attribute='BiosAutoRcvr'},
    [PSCustomObject]@{Category='Maintenance';Attribute='AllowBiosDowngrade'},
    [PSCustomObject]@{Category='SystemLogs';Attribute='BiosLogClear'},
    [PSCustomObject]@{Category='SystemLogs';Attribute='PowerLogClear'},
    [PSCustomObject]@{Category='SystemLogs';Attribute='ThermalLogClear'},
    [PSCustomObject]@{Category='SupportAssistSystemResolution';Attribute='BIOSConnect'},
    [PSCustomObject]@{Category='SupportAssistSystemResolution';Attribute='SupportAssistOSRecovery'},
    [PSCustomObject]@{Category='SupportAssistSystemResolution';Attribute='AutoOSRecoveryThreshold'},
    [PSCustomObject]@{Category='Passwords';Attribute='PwdMinLen'},
    [PSCustomObject]@{Category='Passwords';Attribute='PwdLowerCaseRqd'},
    [PSCustomObject]@{Category='Passwords';Attribute='PwdUpperCaseRqd'},
    [PSCustomObject]@{Category='Passwords';Attribute='PwdDigitRqd'},
    [PSCustomObject]@{Category='Passwords';Attribute='PwdSpecialCharRqd'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='FOTA'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='TelemetryAccessLvl'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ReportLogoType'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ABIProvState'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ABIState'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ActiveECoresSelect'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='AutoRtcRecovery'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='BlockBootUntilChasIntrusionClr'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='CpuCoreSelect'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='DeviceHotkeyAccess'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='DisUsb4Pcie'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='FirmwareTamperDet'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='GpsAntSwitch'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='HttpsBoot'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='HttpsBootMode'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='IPv4PXEBoot'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='IPv6PXEBoot'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='IPvXBootOrder'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='IntelSagv'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='IntelTME'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='InternalDmaCompatibility'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='KernelDma'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='KeyboardIlluminationExt'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='LegacyInterfaceAccess'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='LimitPanelBri50'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='MSUefiCA'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='NonAdminPsidRevert'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='OwnerTagWithLogo'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='PreBootDma'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='PxeBootPriority'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='RestartOnShutdown'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ThermalManagement'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='TypeCDockAudio'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='TypeCDockLan'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='TypeCDockOverride'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='VerticalIntegration'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='VideoPowerOnlyPorts'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='WlanAntSwitch'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='WwanAntSwitch'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ActiveECoresNumber'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='CpuCoreExt'},
    [PSCustomObject]@{Category='PreEnabled';Attribute='ShutdownFailsafeTimer'}
)
$CurrentBIOSSettings = [System.Collections.Generic.List[PSObject]]::new()
$BIOSAttributes | ForEach-Object {
    $BIOSpath = Join-Path -Path (Join-Path -Path $BIOSroot -ChildPath $_.Category) -ChildPath $_.Attribute
    $tempObj = Get-Item -Path $BIOSpath -ErrorAction SilentlyContinue
    $obj = [PSCustomObject]@{
        Category = $_.Category;
        Attribute = $tempObj.Attribute;
        ShortDescription = $tempObj.ShortDescription;
        CurrentValue = $tempObj.CurrentValue;
        PossibleValues = $tempObj.PossibleValues
    }
    $CurrentBIOSSettings.Add($obj)
}
$CurrentBIOSSettings | Format-Table -Property Attribute,ShortDescription,CurrentValue,PossibleValues -GroupBy Category -Wrap
)

#>

<#
# WALK THE TREE AND SAVE THE VALUES DYNAMICALLY

Set-ExecutionPolicy -ExecutionPolicy AllSigned -Scope Process
Import-Module DellBIOSProvider -Verbose
$BIOSroot = 'DellSmbios:'
$SettingList = @()
$Categories = Get-ChildItem -Path $BIOSroot | Where-Object { $_.PSIsContainer }
$Categories | Foreach-Object {
    $BIOSpath = Join-Path -Path $BIOSroot -ChildPath $($_.Category)
    $SubCategories = Get-ChildItem -Path $BIOSpath | Where-Object { $_.PSIsContainer }
}
foreach ($Category in $Categories) {
    $SettingList += Get-ChildItem -Path (Join-Path -Path $BIOSroot -ChildPath $($Category.Category)) -ErrorAction SilentlyContinue
}

$SettingList | foreach-object { if ($_.Attribute -eq 'SvcTag') {$deviceSN = $_.CurrentValue} }

# Export the settings to a CSV file (e.g., C:\temp\DellBiosSettings.csv)
$SettingList | Export-Csv -Path "C:\temp\DellBiosSettings-$deviceSN.csv" -NoTypeInformation


#>
