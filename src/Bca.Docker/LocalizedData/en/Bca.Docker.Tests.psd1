@{
    Module        = @{
        Describe     = "Module"
        ImportModule = "Importing module locally."
        CommandCheck = "Checking exported commands count."
    }

    StopDocker    = @{
        Describe      = "Stop-DockerContainer"
        FromName      = "Stopping container from name"
        FromId        = "Stopping container from ID"
        FromContainer = "Stopping container from container"
    }

    StartDocker   = @{
        Describe      = "Start-DockerContainer"
        FromName      = "Starting container from name"
        FromId        = "Starting container from ID"
        FromContainer = "Starting container from container"
    }

    InvokeCommand = @{
        Describe                 = "Invoke-DockerContainerCommand"
        FromContainerCommand     = "Invoking command in container from container"
        FromContainerScriptBlock = "Invoking script block in container from container"
        FromIdExpression         = "Invoking expression in container from ID"
        FromIdScript             = "Invoking script in container from ID"
    }
}