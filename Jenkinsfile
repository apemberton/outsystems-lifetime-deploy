def envProps = []
pipeline {
  agent { label 'windows' }
  options { 
    buildDiscarder(logRotator(numToKeepStr: '5')) 
    disableConcurrentBuilds()
  }
  environment {
    LT_URL = 'ap-demo-dev.outsystemscloud.com' 
    AUTH_TOKEN = credentials('lt-auth-token')
    LT_APPLICATIONS= ""
  }
  stages {
    stage('Retrieve Envs & Apps') {
      steps {
        powershell '.\\FetchLifeTimeData.ps1'  
        powershell 'ls'
        powershell 'echo $env:LT_ENVIRONMENTS'
        script {
          envProps = readProperties file: 'LT.Environments.properties'

        }
        echo "${envProps['Environments']}"
      }
    }
    stage('Deploy') {
      steps {
        input message: 'Deploy to target environment?', ok: 'Deploy', 
          parameters: [choice(choices: "${envProps['Environments']}", description: 'Source Environment', name: 'SOURCE')]
        powershell '.\\DeployToTargetEnv.ps1'
      }
    }
  }
}
