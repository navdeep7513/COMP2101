Get-Ciminstance win32_networkadapterconfiguration | Where { $_.IPEnabled -eq $True } |  ft Description, Index, IPSubnet, DNSDomain, DNSServerSearchOrder, IPAddress -AutoSize;
