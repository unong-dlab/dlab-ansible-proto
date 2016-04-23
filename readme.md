# 명세버전: 0.1.0
## Prerequisite
* pem directory 아래에 aws 접속에 필요한 pem 파일을 넣어두고 group-vars 파일에서 접속에 필요한 pem 파일을 지정해주자.
* 접속하고자 하는 aws resource 권한을 가진 키정보를 inven/ec2/{{type}}/ 아래에 aws_access_key.sh 파일을 만들어서 export 가능하게 해주자.

## 기능별 command
* 아래 명시하는 모든 command 는 이 프로젝트 root dir 에서 실행하는걸로
* aws_access_key.sh 와 aws private pem key 는 별도 공유.

### directory 셋팅
```{r, engine='bash', count_lines}
$ansible-playbook playbooks/setup-local.yml -i inven/local-proto --limit centos --tags base -K
```
 > * ansible-playbook playbooks/setup-local.yml 은 이 파일의 task 들을 실행하겠다는 의미
 > * -i 는 inventory 를 사용하겠다는 의미
 > * local-proto 라는 inventory 에는 배포하고 싶은 host 목록에 대한 명세, 별도로 설정하고 싶은 변수명들이 명시되어 있음.
 > * --limit centos 옵션은 주어진 inventory 중에 centos 라고 명시된 호스트만 사용하겠다는 의미
 > * 이 옵션이 var 들도 제한하지는 않는듯. (세세하게 테스트해보진 않았어용..)
 > * --tags base 는 playbook 에 명시된 task 들 중에 base 태그가 박힌 task 만 실행하겠다는 의미
 > * -K 는 sudo 와 같이 다른 계정에 대한 비번이 필요할때 물어보겠다는 의미.

### ec2 용 playbook 실행
* 먼저 아래 shell command 를 통해 어떤 aws_secret_access_key 를 사용할것인지 셋팅해준다.
```{r, engine='bash', count_lines}
## 앞에 . 꼭 있어야함
## 뒤에 proto 파라미터는 inven/ec2/ 아래 directory 명을 의미
$. export_ec2_hosts.sh proto
```
 > * 이렇게 했을때 실행하는 내용은 먼저 aws secret access key pair 를 어떤 값으로 사용할것인지 정함
 > * IAM 설정으로 어떤 유저계정으로 ansible 로 셋팅하고자 하는 서버목록을 정하기 위함임.
 > * 마지막으로 ec2.py 와 ec2.ini 를 이용해서 해당하는 aws resource 목록을 ~/.ssh/tmp/~.cache 파일에 기록한다.
 > * cache 파일을 적어두면 이후 ansible 로 호스틈목록 가져올때 오래걸리는 api 를 거치지 않고 캐시파일에서 읽어옴 (당연히 갱신해주고 싶으면 다시 실행해주면됨)

```{r, engine='bash', count_lines}
$ansible-playbook playbooks/setup-local.yml -i inven/ec2/proto/ec2.py --limit tag_Type_proto --extra-vars "@group_vars/tag_Type_proto.yml"
```
 > * -i option 은 앞서 inventory 라고 소개했었는데 이번엔 python script 임. dynamic inventory 라고함.
 > * ec2.py 는 사실 건들게 없어보임. ec2.ini 는 케이스에 맞게 수정하는게 좋음.(그래서 경로를 나눠놨음) 자세한 내용은 ini 파일 열어보면 감이옴.
 > * 앞서 cache 에 저장했던 json 목록을 보면 --limit 값에 대해 감이 옴. 해당 access_key 로 접근 가능한 resource 가 다양한데 대표값으로 필터하기 위함.
 > * 다른건 설명이 딱히 필요없고 --extra-vars 에 대해서만 알면될듯
 > * 외부 변수묶음 파일이라고 보면되고 setup-local.yml 안에 있는 {{ 변수명 }} 값을 채워주기 위한 용도 -> 요 경우는 inventory 파일로도 커버 가능한데 동적 inventory 에서는 어캐 하는지 모르겠음
 > * 그 외에도 ansible 이 ssh 접속을 할때 어떤 private key 를 사용할지 어떤 유저명으로 접속할지를 셋팅해줄 수 있음.

# ansible-galaxy
* ansible repository 같은곳
* https://galaxy.ansible.com/intro
```{r, engine='base', count_lines}
$ansible-galaxy install username.rolename
```
* 이렇게 하면 role 을 다운로드함.
## docker 설치
```{engine='bash'}
$ansible-galaxy install dochang.docker
```
* 이러면 roles 경로 아래에 설치됨. 설치되고 난 후의 yml 은 galaxy repository 와 전혀 관계 없으니 입맛에 맞게 수정하면 될껄로 보인다.
* 기본적인 정보는 해당 role 아래의 readme 보면 될듯.