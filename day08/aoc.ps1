class Node {
  [string]$L
  [string]$R
  Node($L, $R) {
    $this.L = $L
    $this.R = $R
  }
}

function Get-Nodes {
  param (
    [string[]]
    $NodesContent
  )
  $Result = @{}
  $NodesContent |
    Select-String -Pattern '(...) = \((...), (...)\)' -AllMatches |
    Select-Object -ExpandProperty Matches |
    ForEach-Object { $Result[$_.Groups[1].Value] = [Node]::new($_.Groups[2].Value, $_.Groups[3].Value) }
  return $Result
}

function Get-Gcd {
  param (
    [Int64]
    $A,
    [Int64]
    $B
  )
  $Min = [Math]::Min($A, $B)
  $Max = [Math]::Max($A, $B)
  if ($Min -eq 0) {
    return $Max
  }
  return Get-Gcd -A $Min -B ($Max % $Min)
}

function Get-Lcm {
  param (
    [Int64]
    $A,
    [Int64]
    $B
  )
  return $A * $B / (Get-Gcd -A $A -B $B)
}


function Get-Steps {
  param (
    [string[]]
    $Instructions,
    [hashtable]
    $Nodes,
    [string]
    $StartNode,
    [string]
    $EndNode
  )
  $Result = 0
  $CurrentNode = $StartNode
  while ($CurrentNode -notmatch $EndNode) {
    $Step = $Instructions[$Result % $Instructions.Length]
    $CurrentNode = $Nodes[$CurrentNode].$Step
    $Result++
  }
  return [Int64]$Result
}

function Invoke-SolutionPart1 {
  param (
    [string[]]
    $Instructions,
    [hashtable]
    $Nodes
  )
  $Result = Get-Steps -Instructions $Instructions -Nodes $Nodes -StartNode 'AAA' -EndNode 'ZZZ'
  Write-Host $Result
}

function Invoke-SolutionPart2 {
  param (
    [string[]]
    $Instructions,
    [hashtable]
    $Nodes
  )
  $StepsToFirstZ = $Nodes.Keys -match 'A$' |
    ForEach-Object { Get-Steps -Instructions $Instructions -Nodes $Nodes -StartNode $_ -EndNode 'Z$' }
  $Result = $StepsToFirstZ[0]
  $StepsToFirstZ | Select-Object -Skip 1 | ForEach-Object { $Result = Get-Lcm -A $Result -B $_ }

  Write-Host $Result
}

function Invoke-AdventOfCode {
  Write-Host 'PowerShell'
  $InputContent = (Get-Content ./input.txt -Raw) -split '\n\n'
  $Part = $ENV:part

  $Instructions = [string[]][char[]]$InputContent[0]
  $Nodes = Get-Nodes -NodesContent $InputContent[1]

  switch ($Part) {
    'part1' {
      Invoke-SolutionPart1 -Instructions $Instructions -Nodes $Nodes
    }
    'part2' {
      Invoke-SolutionPart2 -Instructions $Instructions -Nodes $Nodes
    }
  }
}

Invoke-AdventOfCode