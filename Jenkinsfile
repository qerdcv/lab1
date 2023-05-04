pipeline {
    agent any

    stages {
        stage('Deploy') {
            steps {
                sh 'rsync -avz . root@172.31.86.54:/usr/share/nginx/html'
            }
        }
    }
}
