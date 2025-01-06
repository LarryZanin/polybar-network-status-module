#!/bin/bash

# Имя скрипта автообновления
SCRIPT_NAME="refresh-network-status.sh"

# Расположение скрипта автообновления
SCRIPT_LOCATION="$HOME/polybar-scripts/$SCRIPT_NAME"

# Путь к файлу для записи активного hook
HOOK_LOG_FILE="$HOME/.config/polybar/network-status.log"



# Определяем сетевой интерфейс
INTERFACE=$(ip route | grep default | awk '{print $5}')

# Если интерфейс отсутствует
if [ -z "$INTERFACE" ]; then
    echo " No connection"
    exit 0
fi

# Определяем тип подключения и имя сети
if [[ $(iw dev 2>/dev/null | grep Interface | awk '{print $2}') == "$INTERFACE" ]]; then
    CONNECTION_TYPE=" "
    NETWORK_NAME=$(iw dev "$INTERFACE" info | grep ssid | awk '{print $2}')
else
    CONNECTION_TYPE="󰈁"
    NETWORK_NAME=$(ip link show "$INTERFACE" | awk -F': ' '/state UP/ {print $2}')
fi



function toggle_format {

    # Найти PID скрипта автообновления
    SCRIPT_PID=$(pgrep -f "$SCRIPT_NAME")

    # Остановка скрипта автообновления
    kill "$SCRIPT_PID"

    # Чтение текущего значения из файла
    if [[ -f "$HOOK_LOG_FILE" ]]; then
        current_hook=$(cat "$HOOK_LOG_FILE")
    else
        # Если файл не существует, устанавливаем значение по умолчанию
        current_hook="0"
        echo "$current_hook" > "$HOOK_LOG_FILE"
    fi

    # Переключение между hook-0 и hook-1
    if [ "$current_hook" -eq "0" ]; then
        polybar-msg action "#network-status.hook.1"
        echo "1" > "$HOOK_LOG_FILE"
    else
        polybar-msg action "#network-status.hook.0"
        echo "0" > "$HOOK_LOG_FILE"
    fi


    # Запуск скрипта автообновления
    nohup "$SCRIPT_LOCATION" > /dev/null 2>&1 &

}


function show_glyph {
    # Вывод информации
    echo "$CONNECTION_TYPE"
}

function show_info {

    # Скорость загрузки и отдачи
    RX1=$(< /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
    sleep 0.1
    RX2=$(< /sys/class/net/"$INTERFACE"/statistics/rx_bytes)

    # Вычисление скорости
    RX_DIFF=$((RX2 - RX1))
    TX_DIFF=$((TX2 - TX1))
    DOWNLOAD_SPEED=$((RX_DIFF * 80 / 1024)) # в Kbps

    if [ "$DOWNLOAD_SPEED" -ge 1024 ]; then
        DOWNLOAD_SPEED="$(awk "BEGIN {printf \"%.1f\", $DOWNLOAD_SPEED / 1024}") MB/s"
    else
        DOWNLOAD_SPEED="${DOWNLOAD_SPEED} KB/s"
    fi

    # Асинхронное получение IP и пинга
    IP=$(curl -s https://api.ipify.org &)
    PING=$(ping -c 1 8.8.8.8 | awk -F'time=' '/time=/ {print $2}' | cut -d' ' -f1 || echo "N/A")

    # Вывод информации
    echo "$CONNECTION_TYPE $NETWORK_NAME | $IP  |  $DOWNLOAD_SPEED | 󱙷 $PING ms"

}

# Проверка на наличие аргументов
if [ $# -eq 0 ]; then
        show_glyph
elif [ "$1" == "info" ]; then
	show_info
elif [ "$1" == "toggle" ]; then
    toggle_format
else
    # Если передан другой аргумент, выводим ошибку
    echo "Unknown argument: $1, perhaps you meant "info" or "toggle""
    exit 0
fi
