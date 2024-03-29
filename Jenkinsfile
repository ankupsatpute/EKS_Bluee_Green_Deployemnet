pipeline {
    agent any
    environment {
    PATH = "/opt/apache-maven-3.8.7/bin/:$PATH"
    DOCKERHUB_CREDENTIALS = credentials('DockerHub')
    //Get the Latest tag
    DOCKER_TAG = getDockerTag()
    
     }
    
    stages{
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                sh """
                echo "Cleaned Up Workspace For Project"
                """
            }
        }
    
      stage('Git CheckOut'){
            steps{
                 git branch: '$BRANCH_NAME', changelog: false, poll: false, url: 'https://github.com/ankupsatpute/EKS_Bluee_Green_Deployemnet.git' 
                //echo "$BUILD_TRIGGER_BY"
               }
            }
        
       stage('Maven Build'){
           steps{
               sh 'mvn clean package'
                 }
               }
        
        stage('Docker Build'){
            steps{
                 sh " docker build . -t ankushsatpute/ankush:${DOCKER_TAG}"
               }
             }
          
         stage ('Docker Image Push'){
            steps{
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                sh "docker push ankushsatpute/ankush:${DOCKER_TAG}"
                sh "docker rmi ankushsatpute/ankush:${DOCKER_TAG}"
                
                }
             }
          
          stage('Create the service in kubernetes cluster traffic to blue controller'){
             steps{ 
                  withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'EKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                     sh "chmod +x changeTagblue.sh"
                     sh "./changeTagblue.sh ${DOCKER_TAG}"   
                     sh "kubectl apply -f blue.yml"
                     sh "kubectl apply -f blue_service.yml"
  
                   }           
                }
            }
        
       /* stage('Create the service in kubernetes cluster traffic to green controller'){
             steps{ 
                  withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'EKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                     sh "chmod +x changeTaggreen.sh"
                     sh "./changeTaggreen.sh ${DOCKER_TAG}"   
                     sh "kubectl apply -f green.yml"
                     sh "kubectl apply -f green_service.yml"
  
                   }           
                }
            }*/
          
    }
}
def getDockerTag(){
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}

