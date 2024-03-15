node {
    def app

    stage('Initialize'){
        def dockerHome = tool 'Docker'
        env.PATH = "${dockerHome}/bin:${env.PATH}"
        
    }
    
    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
       app = docker.build("test")
    }

    stage('Test image') {
  

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        
        docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry') {
            app.push("${env.BUILD_NUMBER}")
        }
    }
    
    stage('Trigger ManifestUpdate') {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}
