pipeline {
  agent {
    kubernetes {
      yamlFile 'jenkins-agent.yaml'
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
            sh 'whoami'
            // sh 'sudo echo "103.160.90.59 registry-uat.fke.fptcloud.com" >> /etc/hosts'
          }
        }
    }

    stage('Build and Push image') {
      steps {
        script {
          docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry') {
            docker.build("576bb055-bc8d-4b31-a36a-a454eaeb2921/test").push("${env.BUILD_NUMBER}")
          }
        }
      }
    }

    stage('Delete unused Docker images') {
      steps {
         sh 'docker image prune -a -f'
      }
    }

    stage('Trigger ManifestUpdate') {
       echo "triggering updatemanifestjob"
       build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
    }
  }
}
