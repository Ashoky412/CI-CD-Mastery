# Jenkinsfile Structure Cheatsheet

## 🎯 Overview

A Jenkinsfile is a code-based configuration for defining CI/CD pipelines in Jenkins. It supports two syntaxes:

- **Declarative** (recommended)
- **Scripted**

---

## 🧰 Pipeline Types

| Type        | Syntax Block                                  | Best For                            |
| ----------- | --------------------------------------------- | ----------------------------------- |
| Declarative | `pipeline {}`                                 | Most use cases; structured and safe |
| Scripted    | `node {}`                                     | Complex logic and dynamic behaviors |
| Hybrid      | Mix both using `script {}` inside declarative | Combining flexibility and structure |

---

## 🔍 Declarative vs Scripted (Quick Diff)

| Feature            | Declarative                | Scripted                    |
| ------------------ | -------------------------- | --------------------------- |
| Syntax             | `pipeline {}`              | `node {}`                   |
| Simplicity         | ✅ Easy, opinionated        | ⚠️ Complex, verbose         |
| Error Handling     | Built-in                   | Manual                      |
| Conditional Logic  | `when` block support       | Full Groovy                 |
| Visual Pipeline UI | Fully supported            | Partial                     |
| Shared Library Use | ✅ Yes                      | ✅ Yes                       |
| Stage/Step Control | Limited inside declarative | Full control                |
| Recommended For    | 90% of use cases           | Power users, legacy systems |

---

## ✅ Basic Declarative Pipeline

```groovy
pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        echo "Building..."
      }
    }
  }
}
```

---

## 🧠 Jenkinsfile Full Structure (Declarative)

```groovy
pipeline {
  agent any                     // Where to run: any node, label, docker, or k8s

  environment {
    ENV_VAR = "value"          // Global environment variable
  }

  options {
    timeout(time: 10, unit: 'MINUTES')
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }

  triggers {
    cron('*/15 * * * *')       // Every 15 minutes
  }

  parameters {
    string(name: 'REGION', defaultValue: 'us-east-1', description: 'AWS region')
  }

  stages {
    stage('Prepare') {
      steps {
        echo "Preparing..."
        script {
          // Optional Groovy logic
        }
      }
    }

    stage('Deploy') {
      when {
        branch 'main'          // Conditional execution
      }
      steps {
        echo "Deploying..."
      }
    }
  }

  post {
    success {
      echo 'Build succeeded!'
    }
    failure {
      echo 'Build failed!'
    }
    always {
      echo 'Always runs'
    }
  }
}
```

---

## 🧾 Scripted Pipeline Example

```groovy
node {
  stage('Build') {
    echo "Building..."
  }
  stage('Test') {
    echo "Testing..."
  }
}
```

---

## 🧪 Real-World SRE Pipeline (K8s)

```groovy
pipeline {
  agent {
    kubernetes {
      label 'jenkins-agent'
      defaultContainer 'jnlp'
    }
  }

  environment {
    REGION = "us-east-1"
    DEPLOY_ENV = "staging"
  }

  options {
    timestamps()
    timeout(time: 30, unit: 'MINUTES')
  }

  parameters {
    string(name: 'APP_NAME', defaultValue: 'myapp', description: 'App to build')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh 'make build'
      }
    }

    stage('Test') {
      steps {
        sh 'make test'
      }
    }

    stage('Deploy') {
      when {
        branch 'main'
      }
      steps {
        sh './scripts/deploy.sh ${DEPLOY_ENV}'
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    success {
      echo 'Deployed Successfully'
    }
    failure {
      mail to: 'ashok@example.com', subject: 'Failed Build', body: 'Check Jenkins logs.'
    }
  }
}
```

---

## 📘 Best Practices

| Practice                     | Why It Matters                             |
| ---------------------------- | ------------------------------------------ |
| Use Declarative Syntax       | Safer, easier, supports visual pipeline UI |
| Always Set Timeouts          | Prevents zombie builds                     |
| Archive Artifacts            | Stores output for downstream use           |
| Use `post {}` Section        | Consistent cleanup, notifications          |
| Trigger via Webhooks/Cron    | Automates build scheduling                 |
| Use Shared Libraries         | DRY, scalable pipelines                    |
| Branch/Env Conditional Logic | Prevents unnecessary stages                |

---

## 📁 Suggested GitHub Structure

```bash
CICD-MASTERY/
├── pipeline/
│   ├── Jenkinsfile-basic
│   ├── Jenkinsfile-scripted
│   ├── Jenkinsfile-cron
│   ├── Jenkinsfile-docker-agent
│   ├── Jenkinsfile-k8s-agent
├── shared-libs/
│   └── vars/
│       └── deployApp.groovy
```

