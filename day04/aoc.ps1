$inputContent = Get-Content ./input.txt
$part = $ENV:part

Write-Host "PowerShell"
if ($part -eq "part1") {
  $result = 0
  $inputContent | ForEach-Object {
    $numbers = $_.Split(':')[1].Split('|')
    $winNumbers = $numbers[0] | Select-String -Pattern '\d+' -AllMatches | Select-Object -ExpandProperty Matches | ForEach-Object { $_.Value }
    $winCount = $numbers[1] | Select-String -Pattern '\d+' -AllMatches | Select-Object -ExpandProperty Matches | Where-Object { $winNumbers.Contains($_.Value) } | Measure-Object | Select-Object -ExpandProperty Count
    if ($winCount -eq 0) {
      return
    }
    $winCount--
    $result += [math]::Pow(2, $winCount)
  }
  Write-Host $result
} elseif ($part -eq "part2") {
  $result = 0
  $copies = 0..203 | ForEach-Object { 1 }
  for ($i = 0; $i -lt 204; $i++) {
    $numbers = $inputContent[$i].Split(':')[1].Split('|')
    $winNumbers = $numbers[0] | Select-String -Pattern '\d+' -AllMatches | Select-Object -ExpandProperty Matches | ForEach-Object { $_.Value }
    $winCount = $numbers[1] | Select-String -Pattern '\d+' -AllMatches | Select-Object -ExpandProperty Matches | Where-Object { $winNumbers.Contains($_.Value) } | Measure-Object | Select-Object -ExpandProperty Count
    for ($j = $i + 1; $j -le $i + $winCount; $j++) {
      $copies[$j] += $copies[$i]
    }
    $result += $copies[$i]
  }
  Write-Host $result
}
