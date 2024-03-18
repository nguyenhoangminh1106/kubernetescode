pipeline {
  agent {
    kubernetes {
      yaml '''
          apiVersion: v1
          kind: Pod
          metadata:
            labels:
              jenkins: jenkins-agent
          spec:
            containers:  # list of containers that you want present for your build, you can define a default container in the Jenkinsfile
            #   - name: jnlp
            #     image: jenkins/inbound-agent:latest
            #     volumeMounts:
            #       - name: docker
            #         mountPath: /var/run/docker.sock # We use the k8s host docker engine
            #       - name: docker_pv
            #         mountPath: /var/run/docker.sock
            # volumes:
            #   - name: docker
            #     hostPath:
            #       path: /var/run/docker.sock
            #   - name: docker_pv
            #     persistentVolumeClaim:
            #       claimName: jenkins-pv-volume
          
              - name: docker
                image: docker:latest
                ports:
                  - containerPort: 50000
            volumes:
              - name: docker-socket
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
