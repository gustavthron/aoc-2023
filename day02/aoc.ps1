$inputContent = Get-Content ./input.txt
$part = $ENV:part

Write-Host 'PowerShell'
if ($part -eq 'part1') {
  $result = 0
  $id = 0
  $inputContent | ForEach-Object {
    $id++
    $red = $_ |
      Select-String -Pattern '\d+(?= red)' -AllMatches |
      Select-Object -ExpandProperty Matches |
      Measure-Object -Property Value -Maximum
    if ($red.Maximum -gt 12) {
      return
    }
    $green = $_ |
      Select-String -Pattern '\d+(?= green)' -AllMatches |
      Select-Object -ExpandProperty Matches |
      Measure-Object -Property Value -Maximum
    if ($green.Maximum -gt 13) {
      return
    }
    $blue = $_ |
      Select-String -Pattern '\d+(?= blue)' -AllMatches |
      Select-Object -ExpandProperty Matches |
      Measure-Object -Property Value -Maximum
    if ($blue.Maximum -gt 14) {
      return
    }
    $result += $id
  }
  Write-Host $result
}
elseif ($part -eq 'part2') {
  $result = 0
  $inputContent | ForEach-Object {
    $red = $_ |
      Select-String -Pattern '\d+(?= red)' -AllMatches |
      Select-Object -ExpandProperty Matches |
      Measure-Object -Property Value -Maximum
    $green = $_ |
      Select-String -Pattern '\d+(?= green)' -AllMatches |
      Select-Object -ExpandProperty Matches |
      Measure-Object -Property Value -Maximum
    $blue = $_ |
      Select-String -Pattern '\d+(?= blue)' -AllMatches |
      Select-Object -ExpandProperty Matches |
      Measure-Object -Property Value -Maximum
    $result += $red.Maximum * $green.Maximum * $blue.Maximum
  }
  Write-Host $result
}