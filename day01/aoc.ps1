$inputContent = Get-Content ./input.txt
$part = $ENV:part

Write-Host "PowerShell"
if ($part -eq "part1") {
  $result = 0
  $inputContent | foreach {
    $_ -match '^\D*(\d).*?(\d)?\D*$' > $null
    $result += "$($Matches.1)$($Matches.2 -ne $null ? $Matches.2 : $Matches.1)"
  }
  Write-Host $result
} elseif ($part -eq "part2") {
  $digitMapping = @{
    'zero'  = 0
    'one'   = 1
    'two'   = 2
    'three' = 3
    'four'  = 4
    'five'  = 5
    'six'   = 6
    'seven' = 7
    'eight' = 8
    'nine'  = 9
  }
  $result = 0
  $inputContent | foreach {
    $m = $_ | Select-String -Pattern "(?=(\d|zero|one|two|three|four|five|six|seven|eight|nine))" -AllMatches | ForEach-Object { $_.Matches } | ForEach-Object { $_.Groups[1].Value } | ForEach-Object { $digitMapping.ContainsKey($_) ? $digitMapping[$_] : $_ }
    $result += "$($m[0])$($m[-1])"
  }
  Write-Host $result
}