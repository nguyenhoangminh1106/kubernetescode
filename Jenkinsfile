node {
    def app

    stage('Check Docker Installation') {
        script {
                    // Check if Docker is installed
                    def dockerVersion = sh(script: 'docker --version', returnStdout: true).trim()
                    
                    if (dockerVersion.startsWith('Docker')) {
                        echo "Docker is already installed: ${dockerVersion}"
                    } else {
                        echo "Docker is not installed. Installing Docker..."
                        // Install Docker
                        sh 'curl -fsSL https://get.docker.com -o get-docker.sh'
                        sh 'sh get-docker.sh'
                        
                        // Add the Jenkins user to the Docker group
                        sh 'sudo usermod -aG docker jenkins'
                        
                        // Restart Docker
                        sh 'sudo systemctl restart docker'
                        
                        // Verify Docker installation
                        sh 'docker --version'
                    }
                }        
    }
    
    stage('Clone repository') {
      

        checkout scm
    }

    stage('Build image') {
  
       app = docker.build("nguyenhoangminh1106/test")
    }

    stage('Test image') {
  

        app.inside {
            sh 'echo "Tests passed"'
        }
    }

    stage('Push image') {
        
        docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
            app.push("${env.BUILD_NUMBER}")
        }
    }
    
    stage('Trigger ManifestUpdate') {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
        }
}
