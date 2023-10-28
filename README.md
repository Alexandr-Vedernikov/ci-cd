# Домашнее задание к занятию 10 «Jenkins»

## Подготовка к выполнению

1. Создать два VM: для jenkins-master и jenkins-agent.

С помощью Terraform созданы 2-е ВМ в Yandex Cloud.    
[Ссылка на код Terraform](vm)

2. Установить Jenkins при помощи playbook.

ВМ созданы на базе ubuntu. Для установки и настройки ВМ создан ansible-playbook.  
[Ссылка на ansible-playbook](ansible)

3. Запустить и проверить работоспособность.

![Start_Jenkins.png](image%2FStart_Jenkins.png)

4. Сделать первоначальную настройку.

a. Подключен node-agent к master по протоколу ssh. Создан отдельный ssh-key для соединения.  
b. На мастере в настройках устанавливаем "Количество процессов-исполнителей" = 0  
с. Заведен Credentials для подключения к GitHub по ssh.  

![Jenkins (master+agent).png](image%2FJenkins%20%28master%2Bagent%29.png)

Выполнение тестовой сборки

![first_test_task.png](image%2Ffirst_test_task.png)

## Основная часть

1. Сделать Freestyle Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

<details><summary> Содержание вывода консоли </summary>

````
Started by user Vedernikov.a.a
Running as SYSTEM
Building remotely on agent (linux ansible) in workspace /opt/jenkins_agent/workspace/freestyle_molecule
The recommended git tool is: NONE
No credentials specified
Cloning the remote Git repository
Cloning repository https://github.com/Alexandr-Vedernikov/vector-role.git
 > git init /opt/jenkins_agent/workspace/freestyle_molecule # timeout=10
Fetching upstream changes from https://github.com/Alexandr-Vedernikov/vector-role.git
 > git --version # timeout=10
 > git --version # 'git version 2.25.1'
 > git fetch --tags --force --progress -- https://github.com/Alexandr-Vedernikov/vector-role.git +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git config remote.origin.url https://github.com/Alexandr-Vedernikov/vector-role.git # timeout=10
 > git config --add remote.origin.fetch +refs/heads/*:refs/remotes/origin/* # timeout=10
Avoid second fetch
 > git rev-parse refs/remotes/origin/main^{commit} # timeout=10
Checking out Revision 071762e5180bf40db09280e4009b7ba4c183da12 (refs/remotes/origin/main)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 071762e5180bf40db09280e4009b7ba4c183da12 # timeout=10
Commit message: "new config molecule"
 > git rev-list --no-walk 071762e5180bf40db09280e4009b7ba4c183da12 # timeout=10
[freestyle_molecule] $ /bin/sh -xe /tmp/jenkins4974043335565854732.sh
+ cd /opt/jenkins_agent/workspace/freestyle_molecule
+ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Running ansible-galaxy role install -vr requirements.yml --roles-path /home/jenkins/.cache/ansible-compat/526fcf/roles
INFO     Set ANSIBLE_LIBRARY=/home/jenkins/.cache/ansible-compat/526fcf/modules:/home/jenkins/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/jenkins/.cache/ansible-compat/526fcf/collections:/home/jenkins/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/jenkins/.cache/ansible-compat/526fcf/roles:/home/jenkins/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /home/jenkins/.cache/ansible-compat/526fcf/roles/my_galaxy_namespace.my_name symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running default > dependency
INFO     Running from /opt/jenkins_agent/workspace/freestyle_molecule : ansible-galaxy collection install -vvv community.docker:>=3.0.2
INFO     Running from /opt/jenkins_agent/workspace/freestyle_molecule : ansible-galaxy collection install -vvv ansible.posix:>=1.4.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
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

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /opt/jenkins_agent/workspace/freestyle_molecule/molecule/default/converge.yml
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

TASK [Synchronization the context] *********************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True})
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8)
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/debian)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True})
ok: [localhost] => (item={'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=Centos7)
changed: [localhost] => (item=Centos8)
changed: [localhost] => (item=Debian)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '14605399708.138355', 'results_file': '/home/jenkins/.ansible_async/14605399708.138355', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'Centos7', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '196917647856.138383', 'results_file': '/home/jenkins/.ansible_async/196917647856.138383', 'changed': True, 'item': {'image': 'docker.io/pycontribs/centos:8', 'name': 'Centos8', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '876595205598.138425', 'results_file': '/home/jenkins/.ansible_async/876595205598.138425', 'changed': True, 'item': {'image': 'docker.io/pycontribs/debian', 'name': 'Debian', 'pre_build_image': True, 'privileged': True}, 'ansible_loop_var': 'item'})

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
included: /home/jenkins/.cache/ansible-compat/526fcf/roles/vector-role/tasks/install_deb.yml for Debian

TASK [vector-role : Get vector distrib] ****************************************
changed: [Debian]

TASK [vector-role : Install vector package] ************************************
changed: [Debian]

TASK [vector-role : Install package on CentOS 7 or 8] **************************
skipping: [Debian]
included: /home/jenkins/.cache/ansible-compat/526fcf/roles/vector-role/tasks/install_rpm.yml for Centos7, Centos8

TASK [vector-role : Modify mirrorlist in yum repos] ****************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Modify baseurl in yum repos] *******************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Get vector distrib] ****************************************
changed: [Centos8]
changed: [Centos7]

TASK [vector-role : Install vector package] ************************************
changed: [Centos7]
changed: [Centos8]

TASK [vector-role : VECTOR | Service] ******************************************
included: /home/jenkins/.cache/ansible-compat/526fcf/roles/vector-role/tasks/service.yml for Centos7, Centos8, Debian

TASK [vector-role : VECTOR | Copy Daemon script] *******************************
changed: [Debian]
changed: [Centos8]
changed: [Centos7]

PLAY RECAP *********************************************************************
Centos7                    : ok=9    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
Centos8                    : ok=9    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
Debian                     : ok=7    changed=3    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > idempotence

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
included: /home/jenkins/.cache/ansible-compat/526fcf/roles/vector-role/tasks/install_deb.yml for Debian

TASK [vector-role : Get vector distrib] ****************************************
ok: [Debian]

TASK [vector-role : Install vector package] ************************************
ok: [Debian]

TASK [vector-role : Install package on CentOS 7 or 8] **************************
skipping: [Debian]
included: /home/jenkins/.cache/ansible-compat/526fcf/roles/vector-role/tasks/install_rpm.yml for Centos7, Centos8

TASK [vector-role : Modify mirrorlist in yum repos] ****************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Modify baseurl in yum repos] *******************************
ok: [Centos8]
ok: [Centos7]

TASK [vector-role : Get vector distrib] ****************************************
ok: [Centos7]
ok: [Centos8]

TASK [vector-role : Install vector package] ************************************
ok: [Centos7]
ok: [Centos8]

TASK [vector-role : VECTOR | Service] ******************************************
included: /home/jenkins/.cache/ansible-compat/526fcf/roles/vector-role/tasks/service.yml for Centos7, Centos8, Debian

TASK [vector-role : VECTOR | Copy Daemon script] *******************************
ok: [Centos8]
ok: [Debian]
ok: [Centos7]

PLAY RECAP *********************************************************************
Centos7                    : ok=9    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
Centos8                    : ok=9    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
Debian                     : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

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

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
Finished: SUCCESS
````
</details>

![Finish_frestyle_test.png](image%2FFinish_frestyle_test.png)

![Freestyle_molecule_test.png](image%2FFreestyle_molecule_test.png)

2. Сделать Declarative Pipeline Job, который будет запускать `molecule test` из любого вашего репозитория с ролью.

Содержание pipeline script:

````
pipeline {
    agent {
        label 'ansible'
    }
    stages {
        stage('Clear work dir') {
            steps {
                deleteDir()
            }
        }
        stage('Clone git repo') {
            steps {
                dir('vector-role') {
                git branch: 'main', url: 'https://github.com/Alexandr-Vedernikov/vector-role.git'
                }
            }
        }
        stage('Molecule test') {
            steps {
                dir('vector-role') {
                sh 'molecule test'
                }
            }
        }
    }
}
````

3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`.

![Pypeline_molecule.png](image%2FPypeline_molecule.png)

![Pypeline_molecule1.png](image%2FPypeline_molecule1.png)

4. Создать Multibranch Pipeline на запуск `Jenkinsfile` из репозитория.

[test_role.jenkins](pipeline%2Ftest_role.jenkins)

![multibranch_final.png](image%2Fmultibranch_final.png)

5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline).

6. Внести необходимые изменения, чтобы Pipeline запускал `ansible-playbook` без флагов `--check --diff`, если не установлен 
параметр при запуске джобы (prod_run = True). По умолчанию параметр имеет значение False и запускает прогон с флагами `--check --diff`.

[ScriptedJenkinsfile](pipeline%2FScriptedJenkinsfile)

![parametr_pipeline.png](image%2Fparametr_pipeline.png)

7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл `ScriptedJenkinsfile`.

<details><summary> Содержание вывода консоли (prod_run = True) </summary>

````
PLAY [Install Java] ************************************************************

TASK [Gathering Facts] ********************************************************* /usr/local/lib/python3.6/site-packages/ansible/parsing/vault/init.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release. from cryptography.exceptions import InvalidSignature ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] ******* skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] ******* ok: [localhost]

TASK [java : Ensure installation dir exists] *********************************** ok: [localhost]

TASK [java : Extract java in the installation directory] *********************** skipping: [localhost]

TASK [java : Export environment variables] ************************************* ok: [localhost]

PLAY RECAP ********************************************************************* localhost : ok=4 changed=0 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0

[Pipeline] } [Pipeline] // stage [Pipeline] } [Pipeline] // node [Pipeline] End of Pipeline Finished: SUCCESS

````
</details>

<details><summary> Содержание вывода консоли (prod_run = False) </summary>

````
PLAY [Install Java] ************************************************************

TASK [Gathering Facts] ********************************************************* /usr/local/lib/python3.6/site-packages/ansible/parsing/vault/init.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release. from cryptography.exceptions import InvalidSignature ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] ******* skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] ******* ok: [localhost]

TASK [java : Ensure installation dir exists] *********************************** ok: [localhost]

TASK [java : Extract java in the installation directory] *********************** skipping: [localhost]

TASK [java : Export environment variables] ************************************* ok: [localhost]

PLAY RECAP ********************************************************************* localhost : ok=4 changed=0 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0

[Pipeline] } [Pipeline] // stage [Pipeline] } [Pipeline] // node [Pipeline] End of Pipeline Finished: SUCCESS
````
</details>

8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.


[Vector-role](https://github.com/Alexandr-Vedernikov/vector-role.git)

[pipeline.jenkins](pipeline%2Fpipeline.jenkins)

[ScriptedJenkinsfile](pipeline%2FScriptedJenkinsfile)


9. Сопроводите процесс настройки скриншотами для каждого пункта задания!!

