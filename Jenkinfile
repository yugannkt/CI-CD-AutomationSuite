pipeline {
    agent any
    environment {
        SONARQUBE_URL = 'http://{{sonar_url}}:9000'
        PROJECT_KEY = '{{ sonar_project_key }}'
        SONAR_SCANNER_HOME = '/opt/sonar-scanner-4.8.0.2856-linux'
        SONAR_TOKEN = '{{ sonar_token }}' // Use Jenkins credentials for security
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the GitHub repository
                git branch: 'main', url: 'https://github.com/your-repo/your-project.git'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    sh """
                    ${SONAR_SCANNER_HOME}/bin/sonar-scanner -X \
                        -Dsonar.projectKey=${PROJECT_KEY} \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=${SONARQUBE_URL} \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }
        stage('Quality Gate Check') {
            steps {
                script {
                    def sonarProjectUrl = "${SONARQUBE_URL}/api/qualitygates/project_status?projectKey=${PROJECT_KEY}"
                    def qualityGateStatus = ''

                    // Retry fetching the quality gate status until it is available or until a timeout
                    timeout(time: 10, unit: 'MINUTES') {
                        waitUntil {
                            sleep(30) // Wait for a bit before checking again
                            def response = sh(script: "curl -s -u ${SONAR_TOKEN}: ${sonarProjectUrl}", returnStdout: true)
                            def json = new groovy.json.JsonSlurper().parseText(response) // Parse the JSON response
                            qualityGateStatus = json.projectStatus.status // Extract the quality gate status
                            echo "Current Quality Gate Status: ${qualityGateStatus}"
                            return qualityGateStatus == 'OK' || qualityGateStatus == 'WARN' // Continue if the quality gate is OK or WARN
                        }
                    }

                    // Handle cases based on the quality gate status
                    if (qualityGateStatus == 'ERROR') {
                        currentBuild.result = 'FAILURE'
                        error "Quality Gate failed. Build aborted."
                    } else {
                        currentBuild.result = 'SUCCESS'
                    }
                }
            }
        }
        stage('Deploy to Apache') {
            when {
                expression {
                    return currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    // Apache deployment commands
                    def deployCommands = '''
                    #!/bin/bash
                    sudo systemctl start apache2
                    sudo rm -rf /var/www/html/*
                    sudo cp -r * /var/www/html/
                    sudo chown -R www-data:www-data /var/www/html/*
                    sudo chmod -R 755 /var/www/html/*
                    sudo systemctl restart apache2
                    '''

                    // Execute the deployment commands
                    sh deployCommands
                }
            }
        }
    }
}
