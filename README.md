# DellRemoteBiosCommands
This is just a collection of common commands to utilize using the Dell SMB Bios Powershell extension along with a script to install during domain setup.

Prerequistes:
  - Operating systems: Windows 11, Windows 10, Windows Red Stone RS1, RS2, RS3, RS4, RS5, RS6, 19H1, 19H2, and 20H1
  - Windows Management Framework (WMF): Versions 3.0, 4.0, 5.0, or 5.1 must be available on the system.
  - .NET Framework: Version 4.8 or later.
  - Windows PowerShell: 3.0 and later.
  - SMBIOS: 2.4 and later.
  - Platform Support: The system must support WMI-ACPI BIOS.
  - Microsoft Visual C++ redistributable: 2015, 2019 and 2022.
  - Dell Support Assist Remediation Service and Agent 
    NOTE: This may be required to ensure the certificates are available to verify the Dell PowerShell Scripts

Reference: https://www.dell.com/support/manuals/en-ee/command-powershell-provider/dcpp_rn/prerequisites?guid=guid-a02cfe4d-b018-4dca-9db1-31eb80e8ffbf&lang=en-us

The DellBiosProvide can be installed from the powershell gallery:
https://www.powershellgallery.com/packages/DellBIOSProvider/2.10.0

Or via the Dell Website at:
https://www.dell.com/support/home/en-us/drivers/DriversDetails?driverId=CJMC2

More information can be found via the Dell website at the below reference links:
https://www.dell.com/support/product-details/en-us/product/command-powershell-provider/resources/search

Users Guide is found here:
https://www.dell.com/support/product-details/en-us/product/command-powershell-provider/resources/manuals

Reference Guide is found here:
https://www.dell.com/support/manuals/en-us/command-powershell-provider/dcpp_2_10_1_ref_guide/Introduction-to-Dell-Command--PowerShell-Provider?guid=guid-80a7a07a-2643-4156-a275-a06f90f85e35&lang=en-us
