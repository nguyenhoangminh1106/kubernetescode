pipeline {
  agent {
    kubernetes {
      label 'push-image'  // all your pods will be named with this prefix, followed by a unique id
      idleMinutes 5  // how long the pod will live after no jobs have run on it
      yamlFile 'jenkins-pod.yaml'  // path to the pod definition relative to the root of our project 
      defaultContainer 'maven'  // define a default container if more than a few stages use it, will default to jnlp container
    }
  }

  stages {
    // stage('Initialize'){
    //     def dockerHome = tool 'Docker'
    //     env.PATH = "${dockerHome}/bin:${env.PATH}"
        
    // }
    
    stage('Clone repository') {
        checkout scm
    }

    stage('Build') {
      sh "mvn clean install"   
    }

    stage('Build image') {
       app = docker.build("576bb055-bc8d-4b31-a36a-a454eaeb2921/test")
        // app = docker.build("nguyenhoangminh1106/test")
    }

    stage('Push image') {
        docker.withRegistry('https://registry-uat.fke.fptcloud.com', 'fptContainerRegistry') {
            // app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        }

        // docker.withRegistry('https://registry.hub.docker.com', 'dockerhub') {
        //     app.push("${env.BUILD_NUMBER}")
        // }
    }

    stage('Delete unused Docker images') {
        // Run docker image prune -a command
        sh 'docker image prune -a -f'
    }
    
    // stage('Trigger ManifestUpdate') {
    //     echo "triggering updatemanifestjob"
    //     build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
    // }
  }
}
