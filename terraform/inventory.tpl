[proxy]
${proxy_hostname} ansible_host=${proxy_ip}

[app]
%{ for index, ip in app_ips ~}
${app_hostnames[index]} ansible_host=${ip}
%{ endfor ~}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_ed25519
