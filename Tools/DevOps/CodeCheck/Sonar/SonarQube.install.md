# Install SonarQube
1. 默认密码
```properties
user=admin
password=admin
new_password=mBM&R^Xb*o!5
```

# Jenkins Integration SonarQube Scanner
1. 
2. Sonar Config
```properties
sonar.projectKey=${JOB_NAME}
sonar.projectName=${JOB_NAME}
sonar.projectVersion=${BUILD_VERSION}
sonar.source=.
sonar.language=java
sonar.sourceEncoding=UTF-8
sonar.java.binaries=$WORKSPACE
```
[博客51CTO](https://blog.51cto.com/u_14268033/2475711)


# Sonar Plugin
[ScmGit Code](https://github.com/SonarSource/sonar-scm-git)