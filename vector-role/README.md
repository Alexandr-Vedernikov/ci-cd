Vector-role
=========

Install Vector

Requirements
------------

CentOS

Role Variables
--------------
|Variable| Value                     |
|--------|---------------------------|
|vector_data_dir| directory for Vector data |
|vector_url| Vector packages URL       |
|vector_documentation_link| Vector documentation link for systemd unit|
|vector_log_output| `StandardOutput` value for systemd unit|
|vector_syslog_identifier| `SyslogIdentifier` value for systemd unit|

Example Playbook
----------------

    - hosts: servers
      roles:
         - vector-role

License
-------

MIT

Author Information
------------------

Vedernikov Alexandr