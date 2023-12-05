$SpelledDigitValues = @{
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

function ConvertTo-Digit {
  param (
    [string]
    $PossiblySpelledDigit
  )
  return $SpelledDigitValues.Contains($PossiblySpelledDigit) ? $SpelledDigitValues[$PossiblySpelledDigit] : [int]$PossiblySpelledDigit
}

function Get-Digits {
  process {
    $_ |
      Select-String -Pattern '\d' -AllMatches |
      ForEach-Object { $_.Matches } |
      ForEach-Object { $_.Value }
  }
}

function Get-SpelledDigitsAndDigits {
  process {
    $_ |
      Select-String -Pattern "(?=(\d|$($SpelledDigitValues.Keys -join '|')))" -AllMatches |
      ForEach-Object { $_.Matches } |
      ForEach-Object { $_.Groups[1].Value }
  }
}

function New-CalibrationValue {
  param (
    [int[]]
    $LineDigits
  )
  return $LineDigits[0] * 10 + $LineDigits[-1]
}

function Invoke-Part1Solution {
  param (
    [string[]]
    $InputContent
  )
  $CalibrationValueSum = 0
  $InputContent | ForEach-Object {
    $LineDigits = $_ | Get-Digits
    $CalibrationValueSum += New-CalibrationValue -LineDigits $LineDigits
  }
  Write-Host $CalibrationValueSum
}

function Invoke-Part2Solution {
  param (
    [string[]]
    $InputContent
  )
  $CalibrationValueSum = 0
  $InputContent | ForEach-Object {
    $LineDigits = $_ |
      Get-SpelledDigitsAndDigits |
      ForEach-Object { ConvertTo-Digit -PossiblySpelledDigit $_ }
    $CalibrationValueSum += New-CalibrationValue -LineDigits $LineDigits
  }
  Write-Host $CalibrationValueSum
}

function Invoke-AdventOfCode {
  Write-Host 'PowerShell'
  $InputContent = Get-Content ./input.txt
  $Part = $ENV:part

  switch ($Part) {
    'part1' {
      Invoke-Part1Solution -InputContent $InputContent
    }
    'part2' {
      Invoke-Part2Solution -InputContent $InputContent
    }
  }
}

Invoke-AdventOfCode