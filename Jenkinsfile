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
       app = docker.build("576bb055-bc8d-4b31-a36a-a454eaeb2921/test")
    }

    stage('Push image') {
        docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry') {
            app.push("${env.BUILD_NUMBER}")
        }
    }

    stage('Delete unused Docker images') {
        // Run docker image prune -a command
        sh 'docker image prune -a -f'
    }
    
    stage('Trigger ManifestUpdate') {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}
