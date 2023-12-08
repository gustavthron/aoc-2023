$CardValues = @{
  'A' = 14
  'K' = 13
  'Q' = 12
  'J' = 11
  'T' = 10
  '9' = 9
  '8' = 8
  '7' = 7
  '6' = 6
  '5' = 5
  '4' = 4
  '3' = 3
  '2' = 2
}

$TypeValues = @{
  '5'     = 7
  '14'    = 6
  '23'    = 5
  '113'   = 4
  '122'   = 3
  '1112'  = 2
  '11111' = 1
}

class Hand {
  [bigint]$Score
  [bigint]$Bid
}

function Get-Hand {
  param (
    $HandContent
  )
  $Result = [Hand]::new()
  $HandContentParts = $HandContent -split ' '
  $Cards = [char[]]$HandContentParts[0]
  $CardCounts = @{}
  for ($i = 0; $i -lt 5; $i++) {
    $Card = $Cards[$i]
    $CardCounts[$Card] += 1
    $Result.Score += [Math]::Pow(10, (4 - $i) * 2) * $CardValues[[string]$Card]
  }
  $Type = $CardCounts.Values |
    Sort-Object |
    Join-String
  $Result.Score += [Math]::Pow(10, 10) * $TypeValues[$Type]
  $Result.Bid = $HandContentParts[1]
  return $Result
}

function Invoke-SolutionPart1 {
  param (
    [string[]]
    $InputContent
  )
  $Hands = $InputContent |
    ForEach-Object { Get-Hand -HandContent $_ } |
    Sort-Object -Property Score
  $Result = 0
  for ($i = 0; $i -lt $Hands.Length; $i++) {
    $Result += ($i + 1) * $Hands[$i].Bid
  }
  Write-Host $Result
}

$CardValues2 = @{
  'A' = 14
  'K' = 13
  'Q' = 12
  'T' = 10
  '9' = 9
  '8' = 8
  '7' = 7
  '6' = 6
  '5' = 5
  '4' = 4
  '3' = 3
  '2' = 2
  'J' = 1
}

function Get-Hand2 {
  param (
    $HandContent
  )
  $Result = [Hand]::new()
  $HandContentParts = $HandContent -split ' '
  $Cards = [char[]]$HandContentParts[0]
  $CardCounts = @{}
  for ($i = 0; $i -lt 5; $i++) {
    $Card = [string]$Cards[$i]
    $CardCounts[$Card] += 1
    $Result.Score += [Math]::Pow(10, (4 - $i) * 2) * $CardValues2[$Card]
  }
  $JokerCountValue = $CardCounts['J']
  $CardCounts.Remove('J')
  $CardCountValues = [int[]]($CardCounts.Values | Sort-Object)
  if ($CardCountValues.Length -eq 0) {
    $CardCountValues = , 0
  }
  $CardCountValues[-1] += $JokerCountValue
  $Type = $CardCountValues | Join-String
  $Result.Score += [Math]::Pow(10, 10) * $TypeValues[$Type]
  $Result.Bid = $HandContentParts[1]
  return $Result
}

function Invoke-SolutionPart2 {
  param (
    [string[]]
    $InputContent
  )
  $Hands = $InputContent |
    ForEach-Object { Get-Hand2 -HandContent $_ } |
    Sort-Object -Property Score
  $Result = 0
  for ($i = 0; $i -lt $Hands.Length; $i++) {
    $Result += ($i + 1) * $Hands[$i].Bid
  }
  Write-Host $Result
}

function Invoke-AdventOfCode {
  Write-Host 'PowerShell'
  $InputContent = Get-Content ./input.txt
  $Part = $ENV:part

  switch ($Part) {
    'part1' {
      Invoke-SolutionPart1 -InputContent $InputContent
    }
    'part2' {
      Invoke-SolutionPart2 -InputContent $InputContent
    }
  }
}

Invoke-AdventOfCode