pipeline {
  agent { label 'windows' }
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
                }
            }
            stage('Deploy') {
              input {
                message "Deploy to target environment?"
                ok "Deploy"
                parameters {
                  choice(name: 'SOURCE', choices: "${LT_ENVIRONMENTS}", description: 'Source Environment')
                  choice(name: 'TARGET', choices: "${LT_ENVIRONMENTS}", description: 'Target Environment')
                  choice(name: 'APPLICATION', choices: "${LT_APPLICATIONS}", description: 'Applications')
                }
              }
              steps {
                powershell '.\\DeployToTargetEnv.ps1'
              }
            }
    }
}
