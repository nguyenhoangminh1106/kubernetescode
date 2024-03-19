pipeline {
  agent {
    kubernetes {
      label 'jenkins-agent'
    }
  }

  hosts {
    103.160.90.59 registry-uat.fke.fptcloud.com

    fallthrough
  }

  stages {
    stage('Clone repository') {
        steps {
          checkout scm
        }
    }

    stage('Initialize'){
        steps {
          script {
            def dockerHome = tool 'Docker'
            env.PATH = "${dockerHome}/bin:${env.PATH}"
        
          }
        }
    }

    stage('Build and Push image') {
      steps {
        script {
          docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry') {
            docker.build("576bb055-bc8d-4b31-a36a-a454eaeb2921/test").push("latest")
          }
        }
      }
    }

    stage('Delete unused Docker images') {
      steps {
         sh 'docker image prune -a -f'
      }
    }
  }
}
