@{
    Module  = @{
        Describe     = "Module"
        ImportModule = "Importation locale du module."
        CommandCheck = "Vérification du nombre de fonctions exportées."
    }

    StopDocker    = @{
        Describe      = "Stop-DockerContainer"
        FromName      = "Arrêt du conteneur depuis le nom"
        FromId        = "Arrêt du conteneur depuis l'ID"
        FromContainer = "Arrêt du conteneur depuis l'objet"
    }

    StartDocker   = @{
        Describe      = "Start-DockerContainer"
        FromName      = "Démarrage du conteneur depuis le nom"
        FromId        = "Démarrage du conteneur depuis l'ID"
        FromContainer = "Démarrage du conteneur depuis l'objet"
    }

    InvokeCommand = @{
        Describe                 = "Invoke-DockerContainerCommand"
        FromContainerCommand     = "Execution de commande dans le conteneur depuis l'objet"
        FromContainerScriptBlock = "Execution de script block dans le conteneur depuis l'objet"
        FromIdExpression         = "Execution d'expression dans le conteneur depuis l'ID"
        FromIdScript             = "Execution de script dans le conteneur depuis l'ID"
    }
}