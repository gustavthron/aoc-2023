function Get-WinHoldTime {
  param (
    $Time,
    $Distance,
    $Min
  )
  $SqrtSignum = $Min ? -1 : 1
  $IntersectTime = ($Time + $SqrtSignum * [Math]::Sqrt([Math]::Pow($Time, 2) - 4 * $Distance)) / 2
  $Result = $Min ? [Math]::Floor($IntersectTime + 1) : [Math]::Ceiling($IntersectTime - 1)
  return $Result
}

function Get-Numbers {
  param (
    $InputObject
  )
  return [double[]] ($InputObject |
    Select-String -Pattern '\d+' -AllMatches |
    Select-Object -ExpandProperty Matches |
    Select-Object -ExpandProperty Value)
}

function Invoke-Solution {
  param (
    [string[]]
    $InputContent
  )
  $Result = 1
  $Times = Get-Numbers -InputObject $InputContent[0]
  $Distances = Get-Numbers -InputObject $InputContent[1]
  for ($i = 0; $i -lt $Times.Length; $i++) {
    $MinWinHoldTime = Get-WinHoldTime -Time $Times[$i] -Distance $Distances[$i] -Min $true
    $MaxWinHoldTime = Get-WinHoldTime -Time $Times[$i] -Distance $Distances[$i] -Min $false
    $Result *= ($MaxWinHoldTime - $MinWinHoldTime + 1)
  }
  Write-Host $Result
}

function Invoke-AdventOfCode {
  Write-Host 'PowerShell'
  $InputContent = Get-Content ./input.txt
  $Part = $ENV:part

  switch ($Part) {
    'part1' {
      Invoke-Solution -InputContent $InputContent
    }
    'part2' {
      $InputContent = $InputContent -replace ' ', ''
      Invoke-Solution -InputContent $InputContent
    }
  }
}

Invoke-AdventOfCode