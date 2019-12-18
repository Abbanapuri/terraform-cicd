## cicd
### jenkins with terraform
####upstream
   1 scm (git clone)
   2 build (mvn package)
   3 sonarqube (static code analysis)
   4 jfrog (storing atrtifacts)
 after succesfull upstream the call down stream
 for testing or demo deploy into dev env test env staging
 byusing
    chef 
    ansible
    terraform
      write terraform file(create vpc , launch instance with tomcat8 and deploy war file into webapps) push into github
#### downstream 
1 stage
   clone terraform file
    apply commands in execute shell
      terraform init . 
      terraform apply . -auto-approve


LAB SETUP:
 install jenkins on ubuntu
   upstream:
       maven   --- take ubuntu install maven configure master-slave
       sonarqube   -- take ubuntu install sonarqube and integrate to jenkins 
                  /etc/apt/sources.list: deb [trusted=yes] http://downloads.sourceforge.net/project/sonar-pkg/deb  binary/
                  sudo apt-get update
                  sudo apt-get install openjdk-8-jdk
                  sudo apt-get install sonar=6.7.4
                  sudo service sonar start   
                  c09c86927f66c7ecd1459b8a5210a6eaf09db414
       jfrog      -- take ubuntu install jfrog and integrate to jenkins 
   downstream:
       terraform   --take ubuntu install terraform configure master-slave
    


node('maven') {

   stage('SCM') {
	  git ' https://github.com/wakaleo/game-of-life.git'
   }
   
   stage ('build the packages') {
	  sh 'mvn package'
   }
   
   stage('SonarQube analysis') {
    // performing sonarqube analysis with "withSonarQubeENV(<Name of Server configured in Jenkins>)"
    withSonarQubeEnv('sonar') {
      // requires SonarQube Scanner for Maven 3.2+
      sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'
    }
  }
  stage('jfrog'){
      sh 'curl -u admin:password -T  /home/jenkins/workspace/upstream/gameoflife-web/target/gameoflife.war "http://54.202.1.182/artifactory/gol/"'
  }

}




node('terraform'){
    stage('clone'){
        git 'https://github.com/kumarreddynaredla123/terraform.git'
    }
    stage('apply'){
        sh 'cd terraform'
        sh 'terraform init .'
        sh 'terraform apply . -auto-approve'
    }
}