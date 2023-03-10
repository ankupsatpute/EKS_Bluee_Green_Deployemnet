pipeline {
    agent any
    environment {
    PATH = "/opt/apache-maven-3.8.7/bin/:$PATH"
    DOCKERHUB_CREDENTIALS = credentials('DockerHub')
    //Get the Latest tag
    DOCKER_TAG = getDockerTag()
    
     }
    stages{
        stage('Git CheckOut'){
            steps{
                git 'https://github.com/ankupsatpute/simple-app.git'     
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
                     sh "chmod +x changeTag_blue.sh"
                     sh "./changeTag_blue.sh ${DOCKER_TAG}"   
                     sh "kubectl apply -f node-app-pod.yml"
                     sh "kubectl apply -f service.yml"
  
                   }           
                }
            }
        
        stage('User approve to continue') {
            steps {
                input "Ready to change redirect traffic to green?"
            }
        }
        
        stage('Create the service in kubernetes cluster traffic to green controller'){
             steps{ 
                  withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'EKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                     sh "chmod +x changeTag_green.sh"
                     sh "./changeTag_green.sh ${DOCKER_TAG}"   
                     sh "kubectl apply -f node-app-pod.yml"
                     sh "kubectl apply -f service.yml"
  
                   }           
                }
            }
          
    }
}
def getDockerTag(){
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}

