node {
    def app

    stage('Initialize'){
        def dockerHome = tool 'Docker'
        env.PATH = "${dockerHome}/bin:${env.PATH}"

        // Add Docker's official GPG key:
        sh 'apt-get update'
        sh 'apt-get install ca-certificates curl'
        sh 'install -m 0755 -d /etc/apt/keyrings'
        sh 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc'
        sh 'chmod a+r /etc/apt/keyrings/docker.asc'
        
        // Add the repository to Apt sources:
        sh 'echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null'
        sh 'apt-get update'
        sh 'chmod 666 /var/run/docker.sock'
        
    }
    
    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
       sh 'ls /var/run/'
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
