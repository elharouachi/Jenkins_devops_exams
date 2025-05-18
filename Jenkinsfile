pipeline {
  agent any

  environment {
    DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
    DOCKER_IMAGE = "admin/monexercicejenkins"
    HELM_CHART_PATH = "./charts"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${DOCKER_IMAGE}:${env.BRANCH_NAME} ."
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        script {
          sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
          sh "docker push ${DOCKER_IMAGE}:${env.BRANCH_NAME}"
        }
      }
    }

    stage('Deploy with Helm') {
      when {
        expression {
          return env.BRANCH_NAME in ['dev', 'qa', 'staging']
        }
      }
      steps {
        script {
          def namespaceMap = [ dev: 'devjen', qa: 'qajen', staging: 'stagingjen' ]
          def ns = namespaceMap[env.BRANCH_NAME]
          sh """
            helm upgrade --install myapp-${env.BRANCH_NAME} ${HELM_CHART_PATH} \
              --namespace ${ns} --create-namespace \
              --set image.repository=${DOCKER_IMAGE} \
              --set image.tag=${env.BRANCH_NAME}
          """
        }
      }
    }

    stage('Manual Deploy to PROD') {
      when {
        allOf {
          branch 'master'
          expression { return input(message: 'Déployer en production ?') }
        }
      }
      steps {
        sh """
          helm upgrade --install myapp-prod ${HELM_CHART_PATH} \
            --namespace prodjen \
            --create-namespace \
            --set image.repository=${DOCKER_IMAGE} \
            --set image.tag=master
        """
      }
    }
  }
}
