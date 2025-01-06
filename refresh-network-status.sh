#!/bin/bash


# Путь к файлу для записи активного hook
HOOK_LOG_FILE="$HOME/.config/polybar/network-status.log"

while true; do

    # Чтение текущего hook из файла
    if [[ -f "$HOOK_LOG_FILE" ]]; then
        current_hook=$(cat "$HOOK_LOG_FILE")
    else
        # Если файл не существует, устанавливаем значение по умолчанию
        current_hook="0"
        echo "$current_hook" > "$HOOK_LOG_FILE"
    fi


    # Повторение hook-0 и hook-1
    if [[ "$current_hook" -eq "0" ]]; then
        polybar-msg action "#network-status.hook.0"

        # Частота обновления иконки
        sleep 15
    else
        polybar-msg action "#network-status.hook.1"

        # Частота обновления информации
        sleep 1
    fi

done
