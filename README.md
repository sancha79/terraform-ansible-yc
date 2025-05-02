# Terraform + Ansible для Yandex Cloud

Проект автоматизирует развертывание инфраструктуры в Yandex Cloud с:
- Terraform для создания ВМ
- Ansible для их настройки

## Структура проекта

```
terraform/       - Конфигурация инфраструктуры
ansible/         - Плейбуки и роли для настройки
```

## Как использовать

1. Инициализация Terraform:
```bash
cd terraform
terraform init
```

2. Развертывание инфраструктуры:
```bash
terraform apply
```

3. Настройка серверов через Ansible:
```bash
cd ../ansible
ansible-playbook -i inventory.ini playbook.yml
```
