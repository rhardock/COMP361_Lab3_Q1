#!/usr/bin/env groovy

pipeline {
    agent any
    
    tools {
        maven 'Maven'
    }

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        IMAGE_NAME = 'comp367-lab3-q1' // Replace with your Docker Hub username and image name
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the repository
                // git url: 'https://github.com/rhardock/COMP361_Lab3_Q1.git', branch: 'main'
                checkout scm
            }
        }

        stage('Build Maven Project') {
            steps {
                // Build the Maven project
                sh 'mvn clean package'
            }
        }

        stage('Docker Login') {
            steps {
                // Login to Docker Hub
                withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    script {
                        // Set environment variables for Docker login
                        env.DOCKER_USERNAME = "${DOCKER_USERNAME}"
                        env.DOCKER_PASSWORD = "${DOCKER_PASSWORD}"
                    }
                    sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                }
            }
        }

        stage('Docker Build') {
            steps {
                // Build the Docker image
                sh '''
                    docker build -t ${DOCKER_USERNAME}/$IMAGE_NAME:latest .
                '''
            }
        }

        stage('Docker Push') {
            steps {
                // Push the Docker image to Docker Hub
                sh '''
                    docker push ${DOCKER_USERNAME}/${IMAGE_NAME}:latest
                '''
            }
        }
    }

    post {
        always {
            // Clean up Docker images
            sh 'docker rmi ${DOCKER_USERNAME}/${IMAGE_NAME}:latest'
        }
    }
}
