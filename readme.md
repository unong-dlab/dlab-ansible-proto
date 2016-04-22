# 기능별 command
* 아래 명시하는 모든 command 는 이 프로젝트 root dir 에서 실행하는걸로

## directory 셋팅
* ansible-playbook playbooks/setup-local.yml -i inven/local-proto --limit centos --tags base -K

#### tutorial 겸해서 위의 command 를 이해해보자.
> ansible-playbook playbooks/setup-local.yml 은 이 파일의 task 들을 실행하겠다는 의미
>
> -i 는 inventory 를 사용하겠다는 의미
>
> local-proto 라는 inventory 에는 배포하고 싶은 host 목록에 대한 명세, 별도로 설정하고 싶은 변수명들이 명시되어 있음.
>
> --limit centos 옵션은 주어진 inventory 중에 centos 라고 명시된 호스트만 사용하겠다는 의미
>
> 이 옵션이 var 들도 제한하지는 않는듯. (세세하게 테스트해보진 않았어용..)
>
> --tags base 는 playbook 에 명시된 task 들 중에 base 태그가 박힌 task 만 실행하겠다는 의미
>
> -K 는 sudo 와 같이 다른 계정에 대한 비번이 필요할때 물어보겠다는 의미.

## ec2 에 셋팅하기
* ansible-playbook -i inven/ec2/ec2.py playbooks/setup-local.yml --extra-vars "@group_vars/proto"