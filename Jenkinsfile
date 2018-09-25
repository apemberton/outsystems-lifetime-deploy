pipeline {
  agent { label 'windows' }
  options { 
    buildDiscarder(logRotator(numToKeepStr: '5')) 
    disableConcurrentBuilds()
  }
  environment {
    LT_URL = 'ap-demo-dev.outsystemscloud.com' 
    AUTH_TOKEN = credentials('lt-auth-token')     
    LT_ENVIRONMENTS = ""
    LT_APPLICATIONS=""
  }
    stages {
      stage('Retrieve Envs & Apps') {
        steps {
          powershell '.\\FetchLifeTimeData.ps1'  
          script {
            def envProps = readProperties file: 'LT.Environments.properties'
            env.LT_ENVIRONMENTS = envProps['Environments']
          }
          echo "${envProps['Environments']}"
        }
      }
      stage('Deploy') {
              input {
                message "Deploy to target environment?"
                ok "Deploy"
                parameters {
                  choice(name: 'SOURCE', choices: "${env.LT_ENVIRONMENTS}", description: 'Source Environment')
                  choice(name: 'TARGET', choices: "${env.LT_ENVIRONMENTS}", description: 'Target Environment')
                  choice(name: 'APPLICATION', choices: "${env.LT_APPLICATIONS}", description: 'Applications')
                }
              }
              steps {
                powershell '.\\DeployToTargetEnv.ps1'
              }
            }
    }
}
