def envProps
def appProps
pipeline {
  agent { label 'windows' }
  options { 
    buildDiscarder(logRotator(numToKeepStr: '5')) 
    disableConcurrentBuilds()
    timeout(time: 20, unit: 'SECONDS')
  }
  environment {
    LT_URL = 'ap-demo-dev.outsystemscloud.com' 
    AUTH_TOKEN = credentials('lt-auth-token')
    SLEEP_SECONDS = 20
    DEPLOYMENT_TIMEOUT = 300
  }
  stages {
    stage('Retrieve Envs & Apps') {
      steps {
        powershell '.\\FetchLifeTimeData.ps1'  
        script {
          envProps = readProperties file: 'LT.Environments.properties'
          appProps = readProperties file: 'LT.Applications.properties'
        }
      }
    }
    stage('Deploy') {
      steps {
        script {
          def userInput = input message: 'Deploy to target environment?', ok: 'Deploy', 
            parameters: [choice(choices: "${envProps['Environments']}", description: 'Source Environment', name: 'SOURCE'),
                        choice(choices: "${envProps['Environments']}", description: 'Target Environment', name: 'TARGET'),
                        choice(choices: "${appProps['Applications']}", description: 'Applications', name: 'APPLICATION')]
          env.SOURCE = userInput.SOURCE
          env.TARGET = userInput.TARGET
          env.APPLICATION = userInput.APPLICATION
        }
        
        powershell ".\\DeployToTargetEnv.ps1"
      }
    }
  }
}
