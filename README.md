# Домашнее задание к занятию 9 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).

<details><summary> Содержание вывода консоли ( terraform apply) </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_9/Practice_9.3/infrastructure/vm$ terraform apply

......

Plan: 5 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.develop: Creating...
yandex_vpc_network.develop: Creation complete after 2s [id=enp7bhlvqcdglcl2gr9a]
yandex_vpc_subnet.develop: Creating...
yandex_vpc_subnet.develop: Creation complete after 1s [id=e9bji1ttu4tkfq6lma1n]

......

local_file.hosts_cfg: Creating...
local_file.hosts_cfg: Creation complete after 0s [id=237b0490ac7cce1b73e7d293032e140da98b6149]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
````
</details>

2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.

<details><summary> Содержание файла hosts.yml. Формируется автоматически из шаблона hosts.tftpl при развертывания ВМ terraform. </summary>

````
---
all:
  hosts:
    sonar-01:
      ansible_host: 51.250.86.95
    nexus-01:
      ansible_host: 51.250.90.123
  children:
    sonarqube:
      hosts:
        sonar-01:
    nexus:
      hosts:
        nexus-01:
    postgres:
      hosts:
        sonar-01:
  vars:
    ansible_connection_type: paramiko
    ansible_user: centos
````
</details>

3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.

<details><summary> Содержание вывода консоли. Запуск плейбук ansible </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_9/Practice_9.3/infrastructure$ ansible-playbook -i ./inventory/cicd/hosts.yml site.yml

......

PLAY RECAP **************************************************************************************************************************************************************************************
nexus-01                   : ok=17   changed=15   unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
sonar-01                   : ok=35   changed=27   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
````
</details>

5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).
6. Зайдите под admin\admin, поменяйте пароль на свой.

![sonar-1.png](image%2Fsonar-1.png)

7. Проверьте готовность Nexus через [бразуер](http://localhost:8081).
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

![nexus-1.png](image%2Fnexus-1.png)

## Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.

![sonar-1.png](image%2Fsonar-1.png)

2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.

![1.4.png](image%2F1.4.png)

5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.
6. Посмотрите результат в интерфейсе.

![1.6.jpg](image%2F1.6.jpg)

7. Исправьте ошибки, которые он выявил, включая warnings.
8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.

<details><summary> Содержание вывода консоли. Запуск плейбук ansible </summary>

````
home@pc:~/DevOps обучение/practice/Раздел_9/Practice_9.3/example$ sonar-scanner   -Dsonar.projectKey=testpy   -Dsonar.sources=.   -Dsonar.host.url=http://51.250.86.95:9000   -Dsonar.login=fdec2e9a6dbb10dea430798c0e244b39899daf58 -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /home/home/.local/share/sonar-scanner-5.0.1.3006-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 5.0.1.3006
INFO: Java 17.0.7 Eclipse Adoptium (64-bit)
INFO: Linux 6.1.0-12-amd64 amd64
INFO: User cache: /home/home/.sonar/cache
INFO: Analyzing on SonarQube server 9.1.0
......
INFO: ------------- Run sensors on project
INFO: Sensor Zero Coverage Sensor
INFO: Sensor Zero Coverage Sensor (done) | time=1ms
INFO: SCM Publisher No SCM system was detected. You can use the 'sonar.scm.provider' property to explicitly specify it.
INFO: CPD Executor Calculating CPD for 1 file
INFO: CPD Executor CPD calculation finished (done) | time=8ms
INFO: Analysis report generated in 72ms, dir size=102,8 kB
INFO: Analysis report compressed in 26ms, zip size=13,8 kB
INFO: Analysis report uploaded in 61ms
INFO: ANALYSIS SUCCESSFUL, you can browse http://51.250.86.95:9000/dashboard?id=testpy
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://51.250.86.95:9000/api/ce/task?id=AYsRXroNRi4VmZbLfr_d
INFO: Analysis total time: 5.541 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 6.764s
INFO: Final Memory: 11M/56M
INFO: ------------------------------------------------------------------------
````
</details>

9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

![1.9.png](image%2F1.9.png)

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.

![2.4.png](image%2F2.4.png)

4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

[maven-metadata.xml](image%2Fmaven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.

![3.4.png](image%2F3.4.png)

5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.

![3.3.png](image%2F3.3.png)

4. В ответе пришлите исправленный файл `pom.xml`.

[pom.xml](mvn%2Fpom.xml)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
