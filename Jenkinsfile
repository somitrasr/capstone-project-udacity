pipeline {
    environment {
        registry = "somitrasr/capstone-project-udacity"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent any
    stages {

		    stage('Lint HTML') {
			    steps {
				    sh 'tidy -q -e *.html'
				    sh 'echo $USER'
			    }
		    }
        
    
            stage('Building image') {
                steps{
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    }
                }
            }

            stage('Deploy Image') {
                steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
                        }
                    }
                }
            }

          

             stage('Create cluster configuration') {
                  steps {
                  withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
                 sh '''
                        aws eks --region ap-south-1 update-kubeconfig --name capstone-project-udacity
                    '''
        }

      }
    }

            stage('Set kubectl context') {
            steps {
            withAWS(region: 'ap-south-1', credentials: 'aws-devops') {
            sh '''
                     /home/ubuntu/bin/kubectl config use-context arn:aws:eks:ap-south-1:891377212219:cluster/capstone-project-udacity
                    '''
        }

      }
    }




            stage('Deploy Updated Image to Cluster'){
                steps {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh 'sudo kubectl apply -f ./deployments/deployment.yml'
					sh 'sudo kubectl apply -f ./deployments/load-balancer.yml'
                }
            }
        }
    }
}




