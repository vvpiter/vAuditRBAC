Import-Module VMware.PowerCLI
Import-Module powershell-yaml

# Prompt for vCenter details
$vcenter = Read-Host "Enter vCenter Server FQDN or IP"
$creds = Get-Credential -Message "Enter credentials for $vcenter"

# Load policy
$policy = ConvertFrom-Yaml (Get-Content -Path "./policies/vcenter-prod-policy.yaml" -Raw)

# Connect to vCenter
Connect-VIServer -Server $vcenter -Credential $creds

# Get live roles and permissions
$liveRoles = Get-VIRole | Where-Object { -not $_.IsSystem }
$permissions = Get-VIPermission

$report = @()

foreach ($policyRole in $policy.roles) {
    $roleName = $policyRole.name
    $liveRole = $liveRoles | Where-Object { $_.Name -eq $roleName }

    if (-not $liveRole) {
        $report += "❌ Role '$roleName' not found in vCenter"
        continue
    }

    $livePrivs = (Get-VIPrivilege -Role $liveRole).Id
    $policyPrivs = $policyRole.privileges

    $missing = $policyPrivs | Where-Object { $_ -notin $livePrivs }
    $extra = $livePrivs | Where-Object { $_ -notin $policyPrivs }

    if ($missing.Count -gt 0 -or $extra.Count -gt 0) {
        $report += "⚠️ Role '$roleName' privilege mismatch:"
        if ($missing.Count -gt 0) { $report += "  - Missing: $($missing -join ', ')" }
        if ($extra.Count -gt 0) { $report += "  - Extra: $($extra -join ', ')" }
    }

    foreach ($assignment in $policyRole.assignments) {
        $found = $permissions | Where-Object {
            $_.Role -eq $liveRole -and
            $_.Principal -eq $assignment.group -and
            $_.Entity.Name -eq $assignment.entity -and
            $_.Propagate -eq $assignment.propagate
        }

        if (-not $found) {
            $report += "⚠️ Role '$roleName' missing assignment for group '$($assignment.group)' on '$($assignment.entity)'"
        }
    }
}

$report | Out-File -FilePath ./rbac-drift-report.txt
Write-Host "✅ Drift report saved to 'rbac-drift-report.txt'"