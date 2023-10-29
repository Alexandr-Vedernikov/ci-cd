# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей.
Задача — сделать сценарии тестирования для vector.
Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
Ответ:
Добавлены для тестирования Centos:8 и Debian:latest. Для этого в molecule.yml в раздел platforms добавлены изменения.
 
<details><summary> Часть кода molecule.yml ( раздел platforms ) </summary>

````
platforms:
  - name: Centos7
    image: docker.io/pycontribs/centos:7
    privileged: true
    pre_build_image: true

  - name: Centos8
    image: docker.io/pycontribs/centos:8
    privileged: true
    pre_build_image: true

  - name: Debian
    image: docker.io/pycontribs/debian
    privileged: true
    pre_build_image: true
````
</details>

Все Task разбиты на функциональные группы. В том числе необходимо разбить процесс установки в зависимости от типа ОС.
Для Debian запускается install_deb.yml, а для Centos запускается install_rpm.yml

<details><summary> Часть кода tasks, main.yml ( Ветвление тестирования роли в зависимости от ОС ) </summary>

````
  - name: Determine OS
    set_fact:
      os_type: "{{ ansible_distribution }}"

  - name: Install package on Debian
    include_tasks: install_deb.yml
    when: os_type == 'Debian'
    tags:
      - vector_install_Debian

  - name: Install package on CentOS 7 or 8
    include_tasks: install_rpm.yml
    when: os_type == 'CentOS'
    tags:
      - vector_install_Centos
````
</details>

Скрин результата выполнения тестирования роли.
![Molecule.png](Image%2FMolecule.png)

4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 

Ответ: 
Добавлены assert в verify.yml для проверки версии установленного пакета Vector. 
<details><summary> Часть кода assert в verify.yml </summary>

````
  - name: Execute vector --version
    command: vector --version
    changed_when: false
    register: vector_version_rc

  - name: Output command vector --version
    debug:
      var: vector_version_rc.stdout
````
</details>



5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

Ответ:
Скрин результата выполнения тестирования роли с дополнительными assert в verify.yml.

![Molecule_2.png](Image%2FMolecule_2.png)

<details><summary> Содержание вывода консоли ( molecule test ) </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role$ molecule test
WARNING  Driver docker does not provide a schema.
INFO     default scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Using /home/home/.ansible/roles/my_galaxy_namespace.my_name symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=Centos7)
changed: [localhost] => (item=Centos8)
changed: [localhost] => (item=Debian)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=Centos7)
ok: [localhost] => (item=Centos8)
ok: [localhost] => (item=Debian)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True})
skipping: [localhost]

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True})
skipping: [localhost]

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'false_condition': 'not item.pre_build_image | default(false)', 'item': {'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/debian) 
skipping: [localhost]

TASK [Create docker network(s)] ************************************************
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=Centos7)
changed: [localhost] => (item=Centos8)
changed: [localhost] => (item=Debian)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j364947532438.689399', 'results_file': '/home/home/.ansible_async/j364947532438.689399', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j80768369789.689425', 'results_file': '/home/home/.ansible_async/j80768369789.689425', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j588213766327.689450', 'results_file': '/home/home/.ansible_async/j588213766327.689450', 'changed': True, 'item': {'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=2    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Centos8]
ok: [Debian]
ok: [Centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Determine OS] **********************************************
ok: [Centos7]
ok: [Centos8]
ok: [Debian]

TASK [vector-role : Install package on Debian] *********************************
skipping: [Centos7]
skipping: [Centos8]
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/install_deb.yml for Debian

TASK [vector-role : Get vector distrib] ****************************************
changed: [Debian]

TASK [vector-role : Install vector package] ************************************
changed: [Debian]

TASK [vector-role : Install package on CentOS 7 or 8] **************************
skipping: [Debian]
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/install_rpm.yml for Centos7, Centos8

TASK [vector-role : Modify mirrorlist in yum repos] ****************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Modify baseurl in yum repos] *******************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Get vector distrib] ****************************************
changed: [Centos7]
changed: [Centos8]

TASK [vector-role : Install vector package] ************************************
changed: [Centos7]
changed: [Centos8]

TASK [vector-role : VECTOR | Configure] ****************************************
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/config.yml for Centos7, Centos8, Debian

TASK [vector-role : VECTOR | Create templates config skeleton] *****************
skipping: [Centos7]
skipping: [Centos8]
skipping: [Debian]

TASK [vector-role : VECTOR | Configure vector] *********************************
skipping: [Centos7]
skipping: [Centos8]
skipping: [Debian]

TASK [vector-role : VECTOR | Service] ******************************************
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/service.yml for Centos7, Centos8, Debian

TASK [vector-role : VECTOR | Copy Daemon script] *******************************
changed: [Centos7]
changed: [Debian]
changed: [Centos8]

PLAY RECAP *********************************************************************
Centos7                    : ok=10   changed=3    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
Centos8                    : ok=10   changed=3    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
Debian                     : ok=8    changed=3    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Debian]
ok: [Centos8]
ok: [Centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Determine OS] **********************************************
ok: [Centos7]
ok: [Centos8]
ok: [Debian]

TASK [vector-role : Install package on Debian] *********************************
skipping: [Centos7]
skipping: [Centos8]
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/install_deb.yml for Debian

TASK [vector-role : Get vector distrib] ****************************************
ok: [Debian]

TASK [vector-role : Install vector package] ************************************
ok: [Debian]

TASK [vector-role : Install package on CentOS 7 or 8] **************************
skipping: [Debian]
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/install_rpm.yml for Centos7, Centos8

TASK [vector-role : Modify mirrorlist in yum repos] ****************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Modify baseurl in yum repos] *******************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Get vector distrib] ****************************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Install vector package] ************************************
ok: [Centos7]
ok: [Centos8]

TASK [vector-role : VECTOR | Configure] ****************************************
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/config.yml for Centos7, Centos8, Debian

TASK [vector-role : VECTOR | Create templates config skeleton] *****************
skipping: [Centos7]
skipping: [Centos8]
skipping: [Debian]

TASK [vector-role : VECTOR | Configure vector] *********************************
skipping: [Centos7]
skipping: [Centos8]
skipping: [Debian]

TASK [vector-role : VECTOR | Service] ******************************************
included: /home/home/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role/tasks/service.yml for Centos7, Centos8, Debian

TASK [vector-role : VECTOR | Copy Daemon script] *******************************
ok: [Debian]
ok: [Centos7]
ok: [Centos8]

PLAY RECAP *********************************************************************
Centos7                    : ok=10   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
Centos8                    : ok=10   changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0
Debian                     : ok=8    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [Debian]
ok: [Centos8]
ok: [Centos7]

TASK [Example assertion] *******************************************************
ok: [Centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [Centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [Debian] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Execute vector --version] ************************************************
ok: [Debian]
ok: [Centos8]
ok: [Centos7]

TASK [Output command vector --version] *****************************************
ok: [Centos7] => {
    "vector_version_rc.stdout": "vector 0.33.0 (x86_64-unknown-linux-gnu 89605fb 2023-09-27 14:18:24.180809939)"
}
ok: [Centos8] => {
    "vector_version_rc.stdout": "vector 0.33.0 (x86_64-unknown-linux-gnu 89605fb 2023-09-27 14:18:24.180809939)"
}
ok: [Debian] => {
    "vector_version_rc.stdout": "vector 0.33.0 (x86_64-unknown-linux-gnu 89605fb 2023-09-27 14:18:24.180809939)"
}

PLAY RECAP *********************************************************************
Centos7                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
Centos8                    : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
Debian                     : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=Centos7)
changed: [localhost] => (item=Centos8)
changed: [localhost] => (item=Debian)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=Centos7)
changed: [localhost] => (item=Centos8)
changed: [localhost] => (item=Debian)

TASK [Delete docker networks(s)] ***********************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
home@pc:~/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role$ 

````
</details>

6. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

https://github.com/Alexandr-Vedernikov/vector-role/tree/2e2b12e21630b405f428275ce044fd2788fa40e3


### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

Ответ:

<details><summary> Содержание вывода консоли </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role$ docker run --privileged=True -v ./:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash 
[root@325e38ff0193 vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.6.0,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='354590007'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
^[[Fpy37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.6.0,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='354590007'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.10,ansible-core==2.15.5,ansible-lint==5.1.3,arrow==1.3.0,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.4,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.16.0,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.19.1,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.3.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.2,requests==2.31.0,resolvelib==1.0.1,rich==13.6.0,rpds-py==0.10.6,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.3,text-unidecode==1.3,types-python-dateutil==2.8.19.14,typing_extensions==4.8.0,urllib3==2.0.7,wcmatch==8.5,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='354590007'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.10,ansible-core==2.15.5,ansible-lint==5.1.3,arrow==1.3.0,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.4,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.16.0,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.19.1,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.3.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.2,requests==2.31.0,resolvelib==1.0.1,rich==13.6.0,rpds-py==0.10.6,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.3,text-unidecode==1.3,types-python-dateutil==2.8.19.14,typing_extensions==4.8.0,urllib3==2.0.7,wcmatch==8.5,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='354590007'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
__________________________________________________ summary __________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed  
````
</details>

4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.

5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.

Ответ:

````

[tox]
minversion = 1.8
basepython = python3.6
envlist = py{37,39}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    {posargs:molecule test -s light-tox --destroy always} 
````

6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.

Проведен тест с использованием драйвера 'podman'.  

<details><summary> Вывод консоли при запуске теста Tox с использованием драйвера 'podman' </summary>

````
  home@pc:~/DevOps обучение/practice/Раздел_8/Practice_8.5/vector-role$ docker run --privileged=True -v ./:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash 
[root@4542bb85442b vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.6.0,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='2354744357'
py37-ansible210 run-test: commands[0] | molecule test -s light-tox --destroy always
INFO     light-tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light-tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running light-tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running light-tox > converge

PLAY [Converge] ****************************************************************

TASK [Replace this task with one that validates your content] ******************
ok: [Centos7] => {
    "msg": "This is the effective test"
}

PLAY RECAP *********************************************************************
Centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running light-tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.15.1,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.2.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.6.0,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.3,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.7,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='2354744357'
py37-ansible30 run-test: commands[0] | molecule test -s light-tox --destroy always
INFO     light-tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light-tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running light-tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running light-tox > converge

PLAY [Converge] ****************************************************************

TASK [Replace this task with one that validates your content] ******************
ok: [Centos7] => {
    "msg": "This is the effective test"
}

PLAY RECAP *********************************************************************
Centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running light-tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.10,ansible-core==2.15.5,ansible-lint==5.1.3,arrow==1.3.0,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.4,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.16.0,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.19.1,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.3.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.2,requests==2.31.0,resolvelib==1.0.1,rich==13.6.0,rpds-py==0.10.6,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.3,text-unidecode==1.3,types-python-dateutil==2.8.19.14,typing_extensions==4.8.0,urllib3==2.0.7,wcmatch==8.5,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='2354744357'
py39-ansible210 run-test: commands[0] | molecule test -s light-tox --destroy always
INFO     light-tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light-tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running light-tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running light-tox > converge

PLAY [Converge] ****************************************************************

TASK [Replace this task with one that validates your content] ******************
ok: [Centos7] => {
    "msg": "This is the effective test"
}

PLAY RECAP *********************************************************************
Centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running light-tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.10,ansible-core==2.15.5,ansible-lint==5.1.3,arrow==1.3.0,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.4,Cerberus==1.3.5,certifi==2023.7.22,cffi==1.16.0,chardet==5.2.0,charset-normalizer==3.3.0,click==8.1.7,click-help-colors==0.9.2,cookiecutter==2.4.0,cryptography==41.0.4,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.19.1,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.2,paramiko==2.12.0,pathspec==0.11.2,pluggy==1.3.0,pycparser==2.21,Pygments==2.16.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.2,requests==2.31.0,resolvelib==1.0.1,rich==13.6.0,rpds-py==0.10.6,ruamel.yaml==0.17.35,ruamel.yaml.clib==0.2.8,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.3,text-unidecode==1.3,types-python-dateutil==2.8.19.14,typing_extensions==4.8.0,urllib3==2.0.7,wcmatch==8.5,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='2354744357'
py39-ansible30 run-test: commands[0] | molecule test -s light-tox --destroy always
INFO     light-tox scenario test matrix: destroy, create, converge, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running light-tox > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running light-tox > create

PLAY [Create] ******************************************************************

TASK [Populate instance config dict] *******************************************
skipping: [localhost]

TASK [Convert instance config dict to a list] **********************************
skipping: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=0    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

INFO     Running light-tox > converge

PLAY [Converge] ****************************************************************

TASK [Replace this task with one that validates your content] ******************
ok: [Centos7] => {
    "msg": "This is the effective test"
}

PLAY RECAP *********************************************************************
Centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running light-tox > destroy

PLAY [Destroy] *****************************************************************

TASK [Populate instance config] ************************************************
ok: [localhost]

TASK [Dump instance config] ****************************************************
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0


INFO     Pruning extra files from scenario ephemeral directory
__________________________________________________ summary __________________________________________________
  py37-ansible210: commands succeeded
  py37-ansible30: commands succeeded
  py39-ansible210: commands succeeded
  py39-ansible30: commands succeeded
[root@4542bb85442b vector-role]# 
````
</details>

7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

https://github.com/Alexandr-Vedernikov/vector-role


После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Ответ
[Molecule default scenario](./roles/vector-role/molecule/default) <br />
[Molecule tox scenario](./roles/vector-role/molecule/tox) <br />
[tox.ini](./roles/vector-role/tox.ini)

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.