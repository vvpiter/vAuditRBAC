$inputFile = "./rbac-drift-report.txt"
$outputFile = "./rbac-report.html"
$lines = Get-Content $inputFile

$html = @"
<html>
<head>
  <title>vAuditRBAC Report</title>
  <style>
    body { font-family: Arial; background: #f9f9f9; padding: 20px; }
    h1 { color: #004080; }
    .entry { background: #fff; border-left: 5px solid #007acc; padding: 10px; margin: 10px 0; }
  </style>
</head>
<body>
  <h1>vAuditRBAC: Drift Report</h1>
  <p><b>Generated:</b> $(Get-Date)</p>
"@

foreach ($line in $lines) {
    $html += "<div class='entry'>$line</div>`n"
}

$html += "</body></html>"

$html | Out-File -FilePath $outputFile -Encoding utf8
Write-Host "HTML report created: $outputFile"