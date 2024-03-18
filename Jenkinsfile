pipeline {
  agent {
    kubernetes {
      label 'push-image'  // all your pods will be named with this prefix, followed by a unique id
      idleMinutes 5  // how long the pod will live after no jobs have run on it
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
        docker.build("576bb055-bc8d-4b31-a36a-a454eaeb2921/test")
      }
    }

    stage('Push image') {
      steps {
        docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry').push("latest")
      }
    }

    // stage('Delete unused Docker images') {
    //   steps {
    //     sh 'docker image prune -a -f'
    //   }
    // }
  }
}
