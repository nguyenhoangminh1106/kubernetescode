pipeline {
  agent {
    kubernetes {
      yaml '''
          apiVersion: v1
          kind: Pod
          spec:
            containers:  
              - name: jnlp
                image: jenkins/inbound-agent:latest
                volumeMounts:
                  - name: docker
                    mountPath: /var/run/docker.sock # We use the k8s host docker engine
            volumes:
              - name: docker
                hostPath:
                  path: /var/run/docker.sock
        '''
      
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
