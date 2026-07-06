# rclone 설치 및 초기화
[설치 방법](https://glorychoi.tistory.com/entry/Ubuntu%EC%97%90%EC%84%9C-Google-Drive-%EC%82%AC%EC%9A%A9%ED%95%98%EA%B8%B0)
- 위 블로그 내용대로 진행
### **원격 접속 등으로 인해 브라우저 인증이 불가할 때**
- Use auto config?에서 n 입력
- 토큰 입력 화면이 나온다면 잠시 그대로 두고, 개인 PC에서 아래 명령어 입력 (개인 PC에도 rclone 설치 필요)
```
rclone authorize "drive"
```
- 브라우저 화면에서 인증 완료 후 터미널에 출력된 토큰 복사 (Paste the following into your remote machine ---> 메세지 다음 부터 <---End paste 전까지)
- 해당 토큰을 원격 머신의 토큰 입력 화면에 붙여넣기 및 엔터
- 나머지는 블로그 내용과 동일하게 진행
# 서버 이전 준비 (도커 사용 전 기준)
### 0. 루트 디렉토리 이동
- ```cd ~```
### 1. 데이터 압축
- 압축 제외 항목 작성
  - ```
    cat << EOF > server_data_compress_exclude_list.txt
    cache
    config
    eula.txt
    fabric-server-loader-*.jar
    fabricloader.log
    logs
    mods
    world/.git
    world/.fastback
    world/.gitattributes
    world/.gitignore
    server-starter.sh
    EOF
    ```
- 압축
  - ```
    // 서버 파일이 있는 디렉토리로 이동
    cd {서버 디렉토리}
    // 압축
    tar -zcvf ~/mc_server_data.tar.gz -X ~/server_data_compress_exclude_list.txt ./*
    ```
### 2. 구글 드라이브 업로드 (시간 다소 소요)
   - ```rclone copyto ~/mc_server_data.tar.gz gdrive:mc_server_data/mc_server_data.tar.gz```
# 서버 이전 (초기 세팅)
### 0. 루트 디렉토리 이동
- ```cd ~```
### 1. 데이터 다운로드
  - ```rclone copyto gdrive:mc_server_data/mc_server_data.tar.gz ~/mc_server_data.tar.gz```
### 2. 데이터 적용
  - ```
    // 서버의 데이터 디렉토리로 이동
    cd ~/mc-server/data
    // 압축 해제
    tar -zxvf ~/mc_server_data.tar.gz
    ```
### 3. 서버 구동 및 초기화
  - [도커 설치](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)
  - ```
    // 깃 설치
    sudo apt install git git-lfs
    ```
  - ```
    // 서버 구동
    cd ~/mc-server
    sudo docker compose up
    ```
  - 서버 구동 완료 메세지 확인 후 'd'를 눌러 detach
  - Fast Backups 모드 초기화
    ```
    // 마인크래프트 프롬프트 접속
    sudo docker exec -it mc-fabric-server rcon-cli
    // 백업 세팅
    backup init
    backup set shutdown-action local // 서버 종료 시 자동 저장 설정 (로컬)
    backup set autoback-action local // 자동 저장 설정 (로컬)
    backup set autoback-wait 10 // 약 10분 간격으로 백업 실시 (마인크래프트 자동 저장 타이밍에 따라 약간의 오차 발생 가능)
    backup set broadcast-enabled false // 백업 시작 메세지 비활성화
    // 초기 백업
    backup local // 현재 월드를 로컬에 백업
    ```
    Ctrl + C 혹은 'exit'을 입력해 접속 종료

# 마인크래프트 서버 콘솔
- 명령어 하나 보내기 (일회성)
  - ```sudo docker exec mc-fabric-server rcon-cli {명령어}```
- 콘솔 접속
  - 간단한 경우
    - ```sudo docker exec -it mc-fabric-server rcon-cli```
  - rcon-cli에서 명령어에 대한 로그가 제대로 출력되지 않는 경우 (spark, backup 등 결과 출력에 시간이 필요한 명령어에서 자주 발생)
    - ```docker compose attach mc-fabric-server // Ctrl + p, Ctrl + q를 순서대로 눌러 detach```
