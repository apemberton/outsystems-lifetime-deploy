dev envProps = []
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
        script {
          envProps = readProperties file: 'LT.Environments.properties'

        }
        echo "${envProps['Environments']}"
      }
    }
    stage('Deploy') {
      input {
        message "Deploy to target environment?"
        ok "Deploy"
        parameters {
          choice(name: 'SOURCE', choices: "${envProps['Environments']}", description: 'Source Environment')
          choice(name: 'TARGET', choices: "${envProps['Environments']}", description: 'Target Environment')
          choice(name: 'APPLICATION', choices: "${env.LT_APPLICATIONS}", description: 'Applications')
        }
      }
      steps {
        powershell '.\\DeployToTargetEnv.ps1'
      }
    }
  }
}
