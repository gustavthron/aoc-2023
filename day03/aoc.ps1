function Get-AdjacentPositions {
  param (
    [int]$x,
    [int]$y
  )
  $r = for ($dx = [math]::Max(0, $x - 1); $dx -le [math]::Min(139, $x + 1); $dx++) {
    for ($dy = [math]::Max(0, $y - 1); $dy -le [math]::Min(139, $y + 1); $dy++) {
      Get-Position -x $dx -y $dy
    }
  }
  return $r
}

function Get-Position {
  param (
    [int]$x,
    [int]$y
  )
  return $y * 140 + $x
}



$inputContent = Get-Content ./input.txt
$part = $ENV:part

Write-Host "PowerShell"
if ($part -eq "part1") {
  $result = 0
  $adjacentSymbolPositions = @{}
  for ($y = 0; $y -lt 140; $y++) {
    $symbolMatch = $inputContent[$y] | Select-String -Pattern "(?!\.)\D" -AllMatches
    if ($null -eq $symbolMatch) {
      continue
    }
    $symbolMatch.Matches | ForEach-Object {
      Get-AdjacentPositions -x $_.Index -y $y | ForEach-Object { $adjacentSymbolPositions[$_] = $true }
    }
  }
  for ($y = 0; $y -lt 140; $y++) {
    $numberMatch = $inputContent[$y] | Select-String -Pattern "\d+" -AllMatches
    if ($null -eq $numberMatch) {
      continue
    }
    $numberMatch.Matches | ForEach-Object {
      for ($x = $_.Index; $x -lt $_.Index + $_.Length; $x++) {
        if ($adjacentSymbolPositions.Contains($(Get-Position -x $x -y $y))) {
          $result += $_.Value
          return
        }
      }
    }
  }
  Write-Host $result
}
elseif ($part -eq "part2") {
  $result = [bigint]0
  $numbers = @{}
  for ($y = 0; $y -lt 140; $y++) {
    $numberMatch = $inputContent[$y] | Select-String -Pattern "\d+" -AllMatches
    if ($null -eq $numberMatch) {
      continue
    }
    $numberMatch.Matches | ForEach-Object {
      $id = Get-Position -x $_.Index -y $y
      for ($x = $_.Index; $x -lt $_.Index + $_.Length; $x++) {
        $position = Get-Position -x $x -y $y
        $numbers[$position] = [PSCustomObject]@{
          Id    = $id
          Value = $_.Value
        }
      }
    }
  }
  for ($y = 0; $y -lt 140; $y++) {
    $gearMatch = $inputContent[$y] | Select-String -Pattern "\*" -AllMatches
    if ($null -eq $gearMatch) {
      continue
    }
    $gearMatch.Matches | ForEach-Object {
      $adjacentNumbers = @{}
      $values = @()
      $values = Get-AdjacentPositions -x $_.Index -y $y | ForEach-Object {
        if (!$numbers.Contains($_)) {
          return
        }
        $n = $numbers[$_]
        if ($adjacentNumbers.Contains($n.Id)) {
          return
        }
        $adjacentNumbers[$n.Id] = $true
        return [int]$n.Value
      }
      if ($adjacentNumbers.Count -ne 2) {
        return
      }
      $result += $values[0] * $values[1]
    }
  }
  Write-Host $result
}
