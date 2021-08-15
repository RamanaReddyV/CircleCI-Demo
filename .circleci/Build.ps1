<#
.SYNOPSIS
  It'll build tesseract project & generate build files 
.DESCRIPTION
  It'll build the all .net core apps .
.PARAMETER <None>
    None
.INPUTS
  None
.OUTPUTS
  <Check the logs in CircleCI window>
.NOTES
  Version:        1.0
  Author:         <RamanaReddy.V>
  Creation Date:  <08-07-2021>
  Purpose/Change: Used to build the Project.
  
.EXAMPLE
  powershell.exe -File C:\Bitbucket\Demo\.circleci\Build.ps1
#>
TRY {
    
    
    $currentFilePath = ($pwd).path

    # Project Local Artifcates path
    $LocalArtiDemoPath = "$env:ARTIFACTS_LOCATION\Demo"
     
    $DemoWebApp = "\Demo\Demo.csproj"
   
    # Build & publish .Net core Apps 
    function Push-ApplicationsArtifacts {
        param (
            [Parameter()] $ProjectAddress,
            [Parameter()] $PublishLocation
        )

        # Publish 
        dotnet publish --configuration Release $ProjectAddress --output $PublishLocation
        if ($lastexitcode) {
            Write-Host "EXITTCODE = $lastexitcode"
            Write-Output "================ Publish Failed ==============="
            throw "Publish  Failed..."
        }
        else {
            Write-Output "================ Your Application Publish  Completed.. ==============="
        }

    }


    # Remove the Web.config files From Local Artifcates
    function delete-WebConfigFiles {
        if (Test-Path -Path $LocalArtiDemoPath"\web.config") {
            Remove-Item $LocalArtiDemoPath"\web.config" -Force
        }
    }

    # Buld & publish to Local --- TRAPI 
    Push-ApplicationsArtifacts -ProjectAddress ($currentFilePath, $DemoWebApp -join "\") -PublishLocation $LocalArtiDemoPath
   
    delete-WebConfigFiles
}
catch {
    Write-Output " ====================  ERROR ====================== "
    Write-Output ("catch is fired ...............")
    Write-Output ( $_.Exception.Message)
    Write-Output ( $_.Exception.ItemName)
    Write-Error " ====================  ERROR IN BUILD ======================"
    throw " ====================  ERROR IN BUILD ======================"
    $LASTEXITCODE = 1
    exit $LASTEXITCODE
}
