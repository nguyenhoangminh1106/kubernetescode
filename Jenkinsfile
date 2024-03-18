pipeline {
  agent {
    kubernetes {
      idleMinutes 5  // how long the pod will live after no jobs have run on it
      inheritFrom 'jenkins-agent.yaml'
      
    }
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

    // stage('Build image') {
    //   steps {
    //     container('docker') {  
    //       sh "docker build -t 576bb055-bc8d-4b31-a36a-a454eaeb2921/test:latest ."           
    //     }
    //   }
    // }

    stage('Build image') {
      steps {
        script{
          docker.build("576bb055-bc8d-4b31-a36a-a454eaeb2921/test")
        }
      }
    }

    stage('Push image') {
      steps {
        script {
          docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry').push("latest")
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
