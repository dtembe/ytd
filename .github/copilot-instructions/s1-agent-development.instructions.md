---
title: S1 Windows and Linux Agent Development Rules
description: Guidelines for developing S1 Windows and Linux Agent-based Dynamic Applications
version: 1.0.0
updated: 2025-12-21
---

# S1 Windows and Linux Agent Development Rules

> **Note on ScienceLogic Product Naming**: Throughout this documentation, S1 (Skylar One) refers to the ScienceLogic monitoring platform. This product may also be referenced as SL1 or EM7 in legacy documentation or code. All three terms (S1, SL1, EM7) refer to the same Skylar One platform.

This module provides specific guidelines for developing Dynamic Applications that run on S1 Windows and Linux Agents.

## 1. Agent Types Overview

S1 supports two primary agent types for remote monitoring:

- **Windows Agent**: PowerShell-based collection using Windows-native cmdlets
- **Linux Agent**: Python-based collection using the low_code framework with SSH execution

## 2. Windows Agent Development

### 2.0. S1 Agent-Compatible PowerPacks

ScienceLogic delivers several pre-built PowerPacks that are compatible with Windows Agents:

- **Microsoft: DHCP Server via PowerShell Agent** - Monitors DHCP server performance and statistics
- **Microsoft: DNS Server via PowerShell Agent** - Collects DNS server metrics and zone information
- **Microsoft: Failover Clustering via PowerShell Agent** - Monitors Windows Failover Cluster health and resources
- **Microsoft: Hyper-V via PowerShell Agent** - Monitors Hyper-V hosts, virtual machines, and resource utilization
- **Microsoft: IIS via PowerShell Agent** - Collects IIS web server metrics, application pools, and site statistics
- **Microsoft: MSSQL via PowerShell Agent** - Monitors SQL Server instances, databases, and performance counters
- **Microsoft: Windows Base via PowerShell Agent** - Core Windows OS monitoring (CPU, memory, disk, services)
- **Microsoft: Windows Updates via PowerShell Agent** - Tracks Windows Update status and pending updates
- **VMware: vSphere via PowerShell Agent** - Monitors VMware infrastructure using PowerCLI

These PowerPacks provide reference implementations and can be used as templates for custom agent-based monitoring solutions.

### 2.1. Environment Specifications

- **Platform**: Windows Server 2012 R2 and later, Windows 10/11
- **PowerShell Version**: PowerShell 5.1+ (Windows PowerShell) or PowerShell 7+ (PowerShell Core)
- **Execution Policy**: RemoteSigned or Bypass
- **Agent Location**: Installed on monitored Windows systems
- **Official Documentation**: [S1 PowerShell Agent Guide](https://docs.sciencelogic.com/latest/Content/Web_Vendor_Specific_Monitoring/Windows_PowerShell/chapter_06_agent_with_ps.htm)

### 2.2. Windows Agent Constraints

- **Script Structure**: Linear PowerShell scripts, no complex modules
- **Output Format**: Key-Value pairs using `Write-Output`
- **Error Handling**: Use `-ErrorAction SilentlyContinue` for non-critical operations
- **Timeout Considerations**: Scripts should complete within 60 seconds (configurable)
- **Credential Handling**: Agent runs with configured service account credentials
- **No User Interaction**: Scripts must run unattended
- **⚠️ CRITICAL**: **NO BLANK LINES AT END OF SCRIPT** - Any trailing blank lines will cause parser errors and script failure

#### Critical Error: Empty Pipe Element

**Issue**: Blank lines at the end of PowerShell scripts cause the following error:
```
At C:\Windows\TEMP\SiloAgent_XXXX.ps1:XX char:X
+ | Format-List | Out-String -Width 250; Write-Output "PowerShellAppid ...
+ ~
An empty pipe element is not allowed.
 + CategoryInfo : ParserError: (:) [], ParseException
 + FullyQualifiedErrorId : EmptyPipeElement
```

**Solution**: Always ensure your PowerShell script ends immediately after the last `Write-Output` statement with NO trailing blank lines.

### 2.3. Windows Agent Code Structure

```powershell
<#
@fileoverview: S1 PowerShell DA for [description]
@module: /home/em7admin/pyDev/.github/copilot-instructions/s1-agent-development.instructions.md
@author: [Author Name]
@created: YYYY-MM-DD HH:MM:SS UTC
@last_modified: YYYY-MM-DD HH:MM:SS UTC
@version: 1.0.0
#>

# =====================================
# Variable Initialization
# =====================================
$target = "8.8.8.8"
$parameter1 = -1
$parameter2 = -1
$status = "Unknown"

# =====================================
# Data Collection Logic
# =====================================
try {
    # Perform collection using Windows cmdlets
    $result = Test-Connection -ComputerName $target -Count 4 -ErrorAction SilentlyContinue
    
    if ($result) {
        # Process results
        $parameter1 = [Math]::Round($result.ResponseTime, 1)
        $status = "Success"
    }
} catch {
    # Handle errors gracefully
    $status = "Error"
}

# =====================================
# Output Results
# =====================================
Write-Output "Target : $target"
Write-Output "Parameter1 : $parameter1"
Write-Output "Parameter2 : $parameter2"
Write-Output "Status : $status"
```

### 2.4. Windows Agent Best Practices

For complete PowerShell agent development guidelines, refer to the [official S1 PowerShell Agent documentation](https://docs.sciencelogic.com/latest/Content/Web_Vendor_Specific_Monitoring/Windows_PowerShell/chapter_06_agent_with_ps.htm).

- **⚠️ NO BLANK LINES**: Never include blank lines at the end of your PowerShell script - this causes "Empty pipe element" parser errors
- **Use Native Cmdlets**: Prefer `Test-Connection`, `Test-NetConnection`, `Resolve-DnsName`, etc.
- **Error Suppression**: Use `-ErrorAction SilentlyContinue` and `-WarningAction SilentlyContinue`
- **Performance Optimization**: 
  - Cache results when making multiple similar calls
  - Use `-Count` parameters to limit iterations
  - Set reasonable timeout values with `-Hops` or `-TimeoutSeconds`
- **Math Rounding**: Always round floating-point values using `[Math]::Round($value, 1)`
- **Default Values**: Initialize all output variables with default values (-1, "Unknown", etc.)
- **Output Format**: Use `Write-Output "KeyName : $value"` format for S1 parsing

### 2.5. Common Windows Agent Patterns

#### Network Connectivity Check
```powershell
$pingResults = Test-Connection -ComputerName $target -Count 4 -ErrorAction SilentlyContinue
if ($pingResults) {
    $sum = 0
    $min = 999999
    $max = 0
    $successful = 0
    foreach ($result in $pingResults) {
        $rt = $result.ResponseTime
        $sum += $rt
        $successful++
        if ($rt -lt $min) { $min = $rt }
        if ($rt -gt $max) { $max = $rt }
    }
    if ($successful -gt 0) {
        $pingAvg = [Math]::Round(($sum / $successful), 1)
        $pingMin = [Math]::Round($min, 1)
        $pingMax = [Math]::Round($max, 1)
        $pingLossPct = [Math]::Round((($pingCount - $successful) / $pingCount) * 100, 1)
    }
}
```

#### DNS Lookup with Timing
```powershell
$dnsStart = Get-Date
$dnsResult = Resolve-DnsName -Name $target -ErrorAction SilentlyContinue
$dnsEnd = Get-Date
if ($dnsResult) { 
    $dnsLookupMS = [Math]::Round(($dnsEnd - $dnsStart).TotalMilliseconds, 1) 
}
```

#### TCP Port Test
```powershell
$tcpStart = Get-Date
$tcpResult = Test-NetConnection -ComputerName $target -Port $tcpPort -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
$tcpEnd = Get-Date
if ($tcpResult -and $tcpResult.TcpTestSucceeded -eq $true) { 
    $tcpConnectMS = [Math]::Round(($tcpEnd - $tcpStart).TotalMilliseconds, 1) 
}
```

## 3. Linux Agent Development

### 3.1. Environment Specifications

- **Platform**: Linux Agent installed on target systems
- **Python Version**: Matches S1 platform version (3.11 for S1 12.3.x)
- **Framework**: S1 low_code framework with silo.* modules
- **Execution Method**: SSH commands via low_code collection objects
- **Official Documentation**: [S1 Low-Code Tools Development](https://docs.sciencelogic.com/dev-docs/)

### 3.2. Linux Agent Constraints

- **Framework Required**: Must use `silo.low_code` and collection framework
- **Error Handling**: Use `error_manager` context manager
- **No Direct SSH**: Use snippet_framework and collection objects instead
- **Collection Objects**: Define in YAML format with low_code structure
- **Output Processing**: Handled automatically by snippet_framework

### 3.3. Linux Agent Code Structure

```python
# =====================================
# Standard Linux Agent DA Template
# =====================================
from silo.apps.errors import error_manager
with error_manager(self):

    from silo.low_code import *
    from silo.apps.collection import create_collections, save_collections

    # =====================================
    # =========== User Editable ===========
    # =====================================
    # List any custom substitutions that need to occur within the snippet arguments
    custom_substitution = {}
    # =====================================
    # ========= End User Editable =========
    # =====================================

    collections = create_collections(self)
    snippet_framework(collections, custom_substitution, snippet_id, app=self)
    save_collections(collections, self, indices_feature=True)
```

### 3.4. Linux Agent Collection Objects

Collection objects are defined in YAML format and specify the commands to execute via SSH. For complete documentation on low-code collection object structure and advanced features, see the [S1 Low-Code Tools Development Guide](https://docs.sciencelogic.com/dev-docs/).

#### Basic SSH Command Collection
```yaml
low_code:
  id: latency
  version: 2
  steps:
    - ssh:
        command: curl -w "%{time_total}\n" -o /dev/null -s "https://www.google.com" | awk '{print $1 * 1000}'
```

#### Multi-Step Collection
```yaml
low_code:
  id: system_info
  version: 1
  steps:
    - ssh:
        command: uname -a
    - ssh:
        command: df -h | grep -v tmpfs
    - ssh:
        command: free -m
```

#### Collection with Echo (Testing)
```yaml
low_code:
  id: website
  version: 1
  steps:
    - ssh:
        command: echo https://www.google.com
```

### 3.5. Linux Agent Best Practices

- **Use error_manager**: Always wrap code in `with error_manager(self):`
- **Import Inside Context**: Import silo modules inside the error_manager context
- **Custom Substitutions**: Use `custom_substitution` dict for dynamic value replacement
- **Collection Creation**: Use `create_collections(self)` to initialize
- **Snippet Framework**: Use `snippet_framework()` to execute collections
- **Save Results**: Use `save_collections()` with `indices_feature=True`
- **Command Design**: Keep SSH commands simple and focused
- **Error Handling**: Commands should handle errors gracefully (e.g., `2>/dev/null`)
- **Output Format**: Use commands that produce parseable output (grep, awk, cut, etc.)

### 3.6. Common Linux Agent Patterns

#### Latency Measurement
```yaml
low_code:
  id: http_latency
  version: 1
  steps:
    - ssh:
        command: curl -w "%{time_total}\n" -o /dev/null -s "${target_url}" | awk '{print $1 * 1000}'
```

#### Disk Space Collection
```yaml
low_code:
  id: disk_space
  version: 1
  steps:
    - ssh:
        command: df -BG | grep -v tmpfs | awk 'NR>1 {print $1, $2, $3, $4, $5, $6}'
```

#### Process Monitoring
```yaml
low_code:
  id: process_check
  version: 1
  steps:
    - ssh:
        command: ps aux | grep -v grep | grep "${process_name}" | wc -l
```

#### Network Statistics
```yaml
low_code:
  id: network_stats
  version: 1
  steps:
    - ssh:
        command: cat /proc/net/dev | grep "${interface}" | awk '{print $1, $2, $3, $10, $11}'
```

## 4. Agent Development Workflow

### 4.1. Windows Agent Workflow

1. **Design Collection**: Identify Windows cmdlets and metrics needed
2. **Create PowerShell Script**: Write linear script with proper error handling
3. **Test Locally**: Test on target Windows system with agent installed
4. **Add to S1**: Create Dynamic Application in S1 UI
5. **Configure Output Parsing**: Define presentation objects for metrics
6. **Deploy**: Apply to devices via S1 collections

### 4.2. Linux Agent Workflow

1. **Design Collection**: Identify SSH commands and metrics needed
2. **Create Collection Object**: Define YAML structure with SSH commands
3. **Create Python DA**: Use standard template with snippet_framework
4. **Test Command Execution**: Verify SSH commands work independently
5. **Add to S1**: Create Dynamic Application and collection objects in S1
6. **Configure Output Parsing**: Define presentation objects for metrics
7. **Deploy**: Apply to devices via S1 collections

## 5. Troubleshooting

### 5.1. Windows Agent Issues

**Empty Pipe Element Error:**
- **Cause**: Blank lines at the end of the PowerShell script
- **Error**: `An empty pipe element is not allowed. ParserError: EmptyPipeElement`
- **Solution**: Remove ALL blank lines after the final `Write-Output` statement
- **Prevention**: Always end script immediately after last output line

**Script Timeout:**
- Reduce `$pingCount` or `$maxHops` values
- Remove unnecessary operations
- Use `-TimeoutSeconds` parameters

**Permission Errors:**
- Verify agent service account has required permissions
- Test script manually with same account
- Check Windows Firewall rules

**No Output:**
- Verify `Write-Output` statements are present
- Check for PowerShell errors in agent logs
- Ensure script doesn't exit early

### 5.2. Linux Agent Issues

**Collection Not Executing:**
- Verify collection object YAML syntax
- Check `snippet_id` matches collection object ID
- Ensure SSH connectivity from agent to target

**Command Errors:**
- Test SSH command manually from agent system
- Verify command syntax (bash-compatible)
- Check for missing utilities (curl, awk, grep)

**No Data Returned:**
- Verify command produces output
- Check output format is parseable
- Review S1 presentation object configuration

## 6. Performance Considerations

### 6.1. Windows Agent Performance

- **Limit Iterations**: Use `-Count` parameters to limit ping/trace attempts
- **Parallel Operations**: Windows cmdlets are generally sequential; design accordingly
- **Memory Management**: Avoid storing large result sets in memory
- **Timeout Values**: Set realistic timeout values (30-60 seconds max)

### 6.2. Linux Agent Performance

- **Command Efficiency**: Use efficient commands (awk, grep vs. complex pipes)
- **Minimize SSH Calls**: Combine related operations in single command when possible
- **Output Size**: Limit output with head, tail, or specific filters
- **Avoid Interactive Commands**: Use non-interactive flags (-n, -B, etc.)

## 7. Security Best Practices

### 7.1. Windows Agent Security

- **Credential Storage**: Never hardcode credentials in scripts
- **Least Privilege**: Agent service account should have minimal required permissions
- **Secure Communication**: Use HTTPS/TLS for external connections
- **Input Validation**: Validate any dynamic parameters

### 7.2. Linux Agent Security

- **SSH Key Management**: Use SSH keys instead of passwords where possible
- **Command Injection**: Avoid user input in SSH commands without validation
- **Credential Handling**: Use S1 credential management
- **File Permissions**: Ensure proper permissions on agent files (600/700)

## 8. Testing Guidelines

### 8.1. Windows Agent Testing

```powershell
# Test script directly on Windows system
.\network_check.ps1

# Verify output format
.\network_check.ps1 | Select-String "PingAvgMS"

# Test with different targets
$target = "10.0.0.1"
.\network_check.ps1
```

### 8.2. Linux Agent Testing

```bash
# Test SSH command independently
ssh user@target 'curl -w "%{time_total}\n" -o /dev/null -s "https://www.google.com"'

# Verify output format
ssh user@target 'df -h | grep -v tmpfs'

# Test with different parameters
ssh user@target 'ps aux | grep httpd | wc -l'
```

## 9. References

### S1 Platform Documentation
- **S1 General Documentation**: [https://docs.sciencelogic.com/](https://docs.sciencelogic.com/)
- **S1 PowerShell Agent Development**: [https://docs.sciencelogic.com/latest/Content/Web_Vendor_Specific_Monitoring/Windows_PowerShell/chapter_06_agent_with_ps.htm](https://docs.sciencelogic.com/latest/Content/Web_Vendor_Specific_Monitoring/Windows_PowerShell/chapter_06_agent_with_ps.htm)
- **S1 Low-Code Tools Development**: [https://docs.sciencelogic.com/dev-docs/](https://docs.sciencelogic.com/dev-docs/)
- **S1 Development Portal**: [https://docs.sciencelogic.com/](https://docs.sciencelogic.com/)

### External Documentation
- **PowerShell Documentation**: [https://docs.microsoft.com/en-us/powershell/](https://docs.microsoft.com/en-us/powershell/)
- **PowerShell Cmdlet Reference**: [https://learn.microsoft.com/en-us/powershell/module/](https://learn.microsoft.com/en-us/powershell/module/)
- **Bash Command Reference**: [https://www.gnu.org/software/bash/manual/](https://www.gnu.org/software/bash/manual/)

## 10. Example: Complete Network Monitoring DA

### Windows Agent Version

```powershell
<#
@fileoverview: S1 PowerShell DA for comprehensive network connectivity checks
@version: 1.0.0
#>
$target = "8.8.8.8"
$pingCount = 4
$maxHops = 30
$tcpPort = 443
$pingAvg = -1
$pingMin = -1
$pingMax = -1
$pingLossPct = 100
$traceHopCount = 0
$traceLatencyMS = -1
$dnsLookupMS = -1
$tcpConnectMS = -1

# ICMP Ping Test
$pingResults = Test-Connection -ComputerName $target -Count $pingCount -ErrorAction SilentlyContinue
if ($pingResults) {
    $sum = 0
    $min = 999999
    $max = 0
    $successful = 0
    foreach ($result in $pingResults) {
        $rt = $result.ResponseTime
        $sum = $sum + $rt
        $successful = $successful + 1
        if ($rt -lt $min) { $min = $rt }
        if ($rt -gt $max) { $max = $rt }
    }
    if ($successful -gt 0) {
        $pingAvg = [Math]::Round(($sum / $successful), 1)
        $pingMin = [Math]::Round($min, 1)
        $pingMax = [Math]::Round($max, 1)
        $pingLossPct = [Math]::Round((($pingCount - $successful) / $pingCount) * 100, 1)
    }
}

# Traceroute Test
$traceResult = Test-NetConnection -ComputerName $target -TraceRoute -Hops $maxHops -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
if ($traceResult) {
    if ($traceResult.TraceRoute) { $traceHopCount = $traceResult.TraceRoute.Count }
    if ($traceResult.PingReplyDetails) { $traceLatencyMS = $traceResult.PingReplyDetails.RoundtripTime }
}

# DNS Lookup Test
$dnsStart = Get-Date
$dnsResult = Resolve-DnsName -Name $target -ErrorAction SilentlyContinue
$dnsEnd = Get-Date
if ($dnsResult) { $dnsLookupMS = [Math]::Round(($dnsEnd - $dnsStart).TotalMilliseconds, 1) }

# TCP Connection Test
$tcpStart = Get-Date
$tcpResult = Test-NetConnection -ComputerName $target -Port $tcpPort -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
$tcpEnd = Get-Date
if ($tcpResult -and $tcpResult.TcpTestSucceeded -eq $true) { $tcpConnectMS = [Math]::Round(($tcpEnd - $tcpStart).TotalMilliseconds, 1) }

# Output Results
Write-Output "Target : $target"
Write-Output "PingAvgMS : $pingAvg"
Write-Output "PingMinMS : $pingMin"
Write-Output "PingMaxMS : $pingMax"
Write-Output "PacketLossPct : $pingLossPct"
Write-Output "TraceHopCount : $traceHopCount"
Write-Output "TraceLatencyMS : $traceLatencyMS"
Write-Output "DnsLookupMS : $dnsLookupMS"
Write-Output "TcpConnectMS : $tcpConnectMS"
# ⚠️ CRITICAL: NO BLANK LINES AFTER THIS POINT - Script must end immediately after last Write-Output
```

### Linux Agent Version

**Dynamic Application Code:**
```python
from silo.apps.errors import error_manager
with error_manager(self):
    from silo.low_code import *
    from silo.apps.collection import create_collections, save_collections
    
    custom_substitution = {
        'target': '8.8.8.8',
        'tcp_port': '443'
    }
    
    collections = create_collections(self)
    snippet_framework(collections, custom_substitution, snippet_id, app=self)
    save_collections(collections, self, indices_feature=True)
```

**Collection Object:**
```yaml
low_code:
  id: network_monitoring
  version: 1
  steps:
    - ssh:
        command: ping -c 4 ${target} 2>/dev/null | tail -1 | awk '{print $4}' | cut -d'/' -f2
        name: ping_avg
    - ssh:
        command: traceroute -m 30 -w 2 ${target} 2>/dev/null | wc -l
        name: trace_hops
    - ssh:
        command: dig ${target} | grep "Query time" | awk '{print $4}'
        name: dns_lookup_ms
    - ssh:
        command: timeout 5 bash -c "time echo > /dev/tcp/${target}/${tcp_port}" 2>&1 | grep real | awk '{print $2}' | sed 's/0m//;s/s//' | awk '{print $1 * 1000}'
        name: tcp_connect_ms
```
