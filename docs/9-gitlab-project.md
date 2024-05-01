# Sample GitLab docker project

manually add this file do gitlab project.

`.gitlab-ci.yml`

```yaml
stages:
  - test

run_windows_docker_command:
  stage: test
  tags:
    - windows
    - docker
  script:
    - docker run mcr.microsoft.com/windows/nanoserver:ltsc2022 cmd /c "echo Hello from Windows Nano Server 2022"
```
