# Bca.Docker
![Platform](https://img.shields.io/powershellgallery/p/Bca.Docker?logo=powershell&logoColor=white) [![License](https://img.shields.io/github/license/baptistecabrera/bca-docker?logo=open-source-initiative&logoColor=white)](https://opensource.org/licenses/MIT) [![Tag](https://img.shields.io/github/v/tag/baptistecabrera/bca-docker?logo=github&logoColor=white&label=tag)](https://github.com/baptistecabrera/bca-docker/releases)

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/Bca.Docker?color=informational&logo=powershell&logoColor=white)](https://www.powershellgallery.com/packages/Bca.Docker) [![Nuget](https://img.shields.io/nuget/v/Bca.Docker?color=informational&logo=nuget&logoColor=white)](https://www.nuget.org/packages/Bca.Docker/) [![Chocolatey](https://img.shields.io/chocolatey/v/bca-docker?color=informational&logo=chocolatey&logoColor=white)](https://chocolatey.org/packages/bca-docker) [![GitHub](https://img.shields.io/badge/dynamic/json?url=https://304e1aad263a8b23b4e14ef1714e6a54a183a0a5@nuget.pkg.github.com/baptistecabrera/Bca.Docker/index.json&label=github&query=$.items[:1].upper&logo=github&logoColor=white)](https://www.github.com/baptistecabrera/bca-docker/packages/)

## Description

_Bca.Docker_ is a PowerShell module used to interact with Docker containers.

It can be used to remotely stop/start containers, or remotely invoke commands or script inside a container.

## Disclaimer

- _Bca.Docker_ has been created to answer my needs, but I provide it to people who may need such a tool.
- Remoting must be enabled on the computer that hosts the containers.
- It may contain bugs or lack some features, in this case, feel free to open an issue, and I'll manage it as best as I can.
- This _GitHub_ repository is not the primary one, but you are welcome to contribute, see transparency for more information.

## Dependencies

- _(none)_

## Documentation
Find extended documentation [at this page](doc/ReadMe.md).

## How to install

### The easiest way

In a PowerShell console, run the following:
```powershell
Find-Module -Name Bca.Docker | Install-Module
```

### Package

_Bca.Docker_ is available as a package from _[PowerShell Gallery](https://www.powershellgallery.com/packages/Bca.Docker)_, _[NuGet](https://www.nuget.org/packages/Bca.Docker/)_, _[GitHub](https://www.github.com/baptistecabrera/bca-docker/packages/)_ and _[Chocolatey](https://chocolatey.org/packages/bca-docker)_*, please refer to each specific plateform on how to install the package.

\* Availability on Chocolatey is subject to approval.

### Manually

If you decide to install _Bca.Docker_ manually, copy the content of `src` into one or all of the path(s) contained in the variable `PSModulePath` depending on the scope you need.

I'll advise you use a path with the version, that can be found in the module manifest `psd1` file (e.g. `C:\Program Files\WindowsPowerShell\Modules\Bca.Docker\1.0.0`). In that case copy the content of `src/Bca.Docker` in this path.

## Transparency

_Please not that to date I am the only developper for this module._

- All code is primarily stored on a private Git repository on Azure DevOps;
- Issues opened in GitHub create a bug in Azure DevOps; [![Sync issue to Azure DevOps](https://github.com/baptistecabrera/bca-docker/workflows/Sync%20issue%20to%20Azure%20DevOps/badge.svg)](https://github.com/baptistecabrera/bca-docker/actions?query=workflow%3A"Sync+issue+to+Azure+DevOps")
- All pushes made in GitHub are synced to Azure DevOps (that includes all branches except `master`); [![Sync branches to Azure DevOps](https://github.com/baptistecabrera/bca-docker/workflows/Sync%20branches%20to%20Azure%20DevOps/badge.svg)](https://github.com/baptistecabrera/bca-docker/actions?query=workflow%3A"Sync+branches+to+Azure+DevOps")
- When a GitHub Pull Request is submitted, it is analyzed and merged in `develop` on GitHub, then synced to Azure DevOps that will trigger the CI;
- A Pull Request is then submitted in Azure DevOps to merge `develop` to `master`, it runs the CI again;
- Once merged to `master`, the CI is one last time, but this time it will create a Chocolatey and a NuGet packages that are pushed on private Azure DevOps Artifacts feeds;
- If the CI succeeds and the packages are well pushed, the CD is triggered.

### CI
[![Build Status](https://dev.azure.com/baptistecabrera/Bca/_apis/build/status/Build/Bca.Docker?repoName=bca-docker&branchName=master)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=30&repoName=bca-docker&branchName=master)

[![Azure DevOps tests (branch)](https://img.shields.io/azure-devops/tests/baptistecabrera/Bca/30/master?logo=azure-pipelines&logoColor=white)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=30&repoName=bca-docker&branchName=master) [![Azure DevOps coverage (branch)](https://img.shields.io/azure-devops/coverage/baptistecabrera/Bca/30/master?logo=azure-pipelines&logoColor=white)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=30&repoName=bca-docker&branchName=master)

The CI is an Azure DevOps build pipeline that will:
- Test the module and does code coverage with _[Pester](https://pester.dev/)_;
- Run the _[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)_;
- Mirror the repository to GitHub

### CD
[![Build Status](https://dev.azure.com/baptistecabrera/Bca/_apis/build/status/Release/Bca.Docker?repoName=bca-docker&branchName=master)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=31&repoName=bca-docker&branchName=master)

[![Azure DevOps tests (branch)](https://img.shields.io/azure-devops/tests/baptistecabrera/Bca/31/master?logo=azure-pipelines&logoColor=white)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=31&repoName=bca-docker&branchName=master) [![Azure DevOps coverage (branch)](https://img.shields.io/azure-devops/coverage/baptistecabrera/Bca/31/master?logo=azure-pipelines&logoColor=white)](https://dev.azure.com/baptistecabrera/Bca/_build/latest?definitionId=31&repoName=bca-docker&branchName=master)

The CD is an Azure DevOps release pipeline is trigerred that will:
- In a **Prerelease** step, install both Chocolatey and Nuget packages from the private feed in a container, and run tests again. If tests are successful, the packages are promoted to `@Prerelease` view inside the private feed;
- In a **Release** step, publish the packages to _[NuGet](https://www.nuget.org/)_ and _[Chocolatey](https://chocolatey.org/)_, and publish the module to _[PowerShell Gallery](https://www.powershellgallery.com/)_, then promote the packages to to `@Release` view inside the private feed.
