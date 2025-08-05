# Jenkins Freestyle Job - HelloWorld-Freestyle

## 🎯 Objective
A Jenkins Freestyle job that:
- Echoes a greeting
- Writes output to `greeting.txt`
- Archives the file as an artifact
- Runs every 2 minutes automatically

---

## 📁 Job Configuration

### 🧾 General
- **Name**: `HelloWorld-Freestyle`
- **Description**: "This job prints a greeting message and archives the output."
- **Discard Old Builds**: Enabled, keep last 10 builds

### ⏰ Build Triggers
- **Build periodically**: `H/2 * * * *`  
  (Runs every 2 minutes)

### ⚙️ Build Step
- **Execute shell**:
```bash
#!/bin/bash
echo "Hello, Ashok! Welcome to Jenkins Freestyle."
echo "Run at: $(date)" > greeting.txt
cat greeting.txt
![](dashboard1.png)
![alt text](image.png)
![](2025-08-05-11-20-06.png)