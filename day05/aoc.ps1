class Range {
  [bigint]$Start
  [bigint]$Length
  Range([bigint]$Start, [bigint]$Length) {
    $this.Start = $Start
    $this.Length = $Length
  }
}

class CategoryMapRange {
  [bigint]$DestinationStart
  [bigint]$SourceStart
  [bigint]$Length
}

class CategoryMap {
  [CategoryMapRange[]]$CategoryMapRanges
}

class Almanac {
  [bigint[]]$Seeds
  [Range[]]$SeedRanges
  [CategoryMap[]]$CategoryMaps
}

function Get-CategoryMapRange {
  param (
    [string]$RangeContent
  )
  $Result = [CategoryMapRange]::new()
  $Numbers = $RangeContent -split ' '
  $Result.DestinationStart = $Numbers[0]
  $Result.SourceStart = $Numbers[1]
  $Result.Length = $Numbers[2]
  return $Result
}

function Get-CategoryMap {
  param (
    [string]$MapContent
  )
  $Result = [CategoryMap]::new()
  $Result.CategoryMapRanges = $MapContent -split '\n' |
    Select-Object -Skip 1 |
    ForEach-Object { Get-CategoryMapRange -RangeContent $_ }
  return $Result
}

function Get-Seeds {
  param (
    [string]$SeedContent
  )
  return $SeedContent |
    Select-String -Pattern '\d+' -AllMatches |
    Select-Object -ExpandProperty Matches |
    ForEach-Object { [bigint]$_.Value }
}

function Get-SeedRanges {
  param (
    [string]$SeedContent
  )
  return $SeedContent |
    Select-String -Pattern '(\d+) (\d+)' -AllMatches |
    Select-Object -ExpandProperty Matches |
    ForEach-Object { [Range]::new($_.Groups[1].Value, $_.Groups[2].Value) }
}


function Get-Almanac {
  param (
    [string]$FilePath
  )
  $Result = [Almanac]::new()
  $AlmanacContent = (Get-Content $FilePath -Raw) -split '\n\n'
  $Result.Seeds = Get-Seeds -SeedContent $AlmanacContent[0]
  $Result.SeedRanges = Get-SeedRanges -SeedContent $AlmanacContent[0]
  $Result.CategoryMaps = $AlmanacContent[1..$AlmanacContent.Length] |
    ForEach-Object { Get-CategoryMap -MapContent $_ }
  return $Result
}

function Get-DestinationValue {
  param (
    [bigint]$SourceValue,
    [CategoryMap]$CategoryMap
  )
  foreach ($CategoryMapRange in $CategoryMap.CategoryMapRanges) {
    if ($SourceValue -ge $CategoryMapRange.SourceStart -and $SourceValue -lt $CategoryMapRange.SourceStart + $CategoryMapRange.Length) {
      return $CategoryMapRange.DestinationStart + $SourceValue - $CategoryMapRange.SourceStart
    }
  }
  return $SourceValue
}

function Get-DestinationRanges {
  param (
    [bigint]$SourceStartValue,
    [CategoryMap]$CategoryMap
  )
  foreach ($CategoryMapRange in $CategoryMap.CategoryMapRanges) {
    if ($SourceValue -ge $CategoryMapRange.SourceStart -and $SourceValue -lt $CategoryMapRange.SourceStart + $CategoryMapRange.Length) {
      return $CategoryMapRange.DestinationStart + $SourceValue - $CategoryMapRange.SourceStart
    }
  }
  return $SourceValue
}

function Invoke-Part1Solution {
  param (
    [Almanac]$Almanac
  )
  $LowestLocationNumber = $null
  foreach ($Seed in $Almanac.Seeds) {
    $CurrentValue = $Seed
    foreach ($CategoryMap in $Almanac.CategoryMaps) {
      $CurrentValue = Get-DestinationValue -SourceValue $CurrentValue -CategoryMap $CategoryMap
    }
    if ($null -eq $LowestLocationNumber -or $CurrentValue -lt $LowestLocationNumber) {
      $LowestLocationNumber = $CurrentValue
    }
  }
  Write-Host $LowestLocationNumber
}

function Invoke-Part2Solution {
  param (
    [Almanac]$Almanac
  )
  $LowestLocationNumber = $null
  $Ranges = $Almanac.SeedRanges
  foreach ($CategoryMap in $Almanac.CategoryMaps) {
    for ($i = 0; $i -lt $Ranges.Length; $i++) {
      $Range = $Ranges[$i]
      foreach ($MapRange in $CategoryMap.CategoryMapRanges) {
        if ($Range.Start -lt $MapRange.SourceStart) {
          if ($Range.Start + $Range.Length -gt $MapRange.SourceStart) {
            $Ranges += [Range]::new($MapRange.SourceStart, $Range.Start + $Range.Length - $MapRange.SourceStart)
            $Range.Length = $MapRange.SourceStart - $Range.Start
          }
        }
        elseif ($Range.Start -lt $MapRange.SourceStart + $MapRange.Length) {
          if ($Range.Start + $Range.Length -gt $MapRange.SourceStart + $MapRange.Length) {
            $Ranges += [Range]::new($MapRange.SourceStart + $MapRange.Length, $Range.Start + $Range.Length - $MapRange.SourceStart - $MapRange.Length)
            $Range.Length = $MapRange.SourceStart + $MapRange.Length - $Range.Start
          }
          $Range.Start += $MapRange.DestinationStart - $MapRange.SourceStart
          break
        }
      }
    }
  }
  $LowestLocationNumber = $Ranges | ForEach-Object { $_.Start } | Measure-Object -Minimum | Select-Object -ExpandProperty Minimum
  Write-Host $LowestLocationNumber
}

function Invoke-AdventOfCode {
  Write-Host 'PowerShell'
  $Part = $ENV:part
  $Almanac = Get-Almanac -FilePath './input.txt'
  switch ($Part) {
    'part1' {
      Invoke-Part1Solution -Almanac $Almanac
    }
    'part2' {
      Invoke-Part2Solution -Almanac $Almanac
    }
  }
}

Invoke-AdventOfCode