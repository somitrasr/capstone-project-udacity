pipeline {
  agent any
  stages {
    stage('Lint HTML') {
      steps {
        sh 'tidy -q -e *.html'
      }
    }

    stage('Build Docker Image') {
      steps {
        withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
          sh '''
                        docker build -t somitrasr/capstone-devops .
                    '''
        }

      }
    }

    stage('Push Image To Dockerhub') {
      steps {
        withCredentials(bindings: [[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
          sh '''
                        docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                        docker push somitrasr/capstone-devops
                    '''
        }

      }
    }

    stage('Create cluster configuration') {
      steps {
        withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
          sh '''
                        aws eks --region ap-south-1 update-kubeconfig --name capstone-cloud-devops-cluster
                    '''
        }

      }
    }

    stage('Set kubectl context') {
      steps {
        withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
          sh '''
                     /home/ubuntu/bin/kubectl config use-context arn:aws:eks:ap-south-1:891377212219:cluster/capstone-cloud-devops-cluster
                    '''
        }

      }
    }

    stage('Deploy blue container') {
      steps {
        withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
          sh '''
                       /home/ubuntu/bin/kubectl apply -f ./blue-controller.yml
                    '''
        }

      }
    }

    stage('Deploy green container') {
      steps {
        withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
          sh '''
                        /home/ubuntu/bin/kubectl apply -f ./green-controller.yml
                    '''
        }

      }
    }

    stage('Create service in cluster, redirect to green') {
      steps {
        withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
          sh '''
                        /home/ubuntu/bin/kubectl apply -f green-service.yml
                    '''
        }

      }
    }

    stage('Wait user approve') {
      steps {
        input 'The service will redict to blue...'
      }
    }

    stage('Create service in cluster, redirect to blue') {
      steps {
        withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
          sh '''
                        /home/ubuntu/bin/kubectl apply -f blue-service.yml
                    '''
        }

      }
    }

  }
}