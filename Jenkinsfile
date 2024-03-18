pipeline {
  agent {
    kubernetes {
      yaml '''
          apiVersion: v1
          kind: Pod
          metadata:
            name: jenkins-slave
          spec:
            containers:
            - name: jenkins-slave
              image: docker:latest
              command:
              - "cat"
              tty: true
              volumeMounts:
              - name: docker-socket
                mountPath: /var/run/docker.sock
            restartPolicy: Never
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
